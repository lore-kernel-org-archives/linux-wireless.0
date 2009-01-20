Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:34932 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZATQCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 11:02:22 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1524227yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 08:02:21 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18805.62728.34610.424793@localhost.localdomain> (sfid-20090120_170228_682210_E6BC54B7)
Date: Tue, 20 Jan 2009 21:30:08 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@Atheros.com
Subject: Re: [PATCH] mac80211: Add capability to enable/disable beaconing
In-Reply-To: <1232448779.20158.4.camel@johannes.local>
References: <18805.33791.193195.755178@gargle.gargle.HOWL>
	<1232448779.20158.4.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> cOn Tue, 2009-01-20 at 13:27 +0530, Sujith wrote:
> > This patch adds a flag to notify drivers to start and
> > stop beaconing when needed, for example, during a scan run.
> 
> 
> > +	if ((changed & IEEE80211_IFCC_BEACON) &&
> > +	    (sdata->vif.type == NL80211_IFTYPE_AP ||
> > +	     sdata->vif.type == NL80211_IFTYPE_ADHOC ||
> > +	     sdata->vif.type == NL80211_IFTYPE_MESH_POINT)) {
> > +		if (local->sw_scanning || local->hw_scanning)
> > +			conf.enable_beacon = false;
> > +		else
> > +			conf.enable_beacon = true;
> > +	}
> > +
> 
> You really just want to do the minimal thing, right? :)

Oh, absolutely :)

> That won't work when userspace disables the beacon by removing it, for
> instance, right now drivers won't know when hostapd removed the beacon
> except that ieee80211_beacon_get will start returning 0... Also, I think
> a separate change flag would be appropriate, sometimes we might just
> re-enable the beacon without having changed it, after scanning?

Ok, how about this ?

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9a5869e..72a3025 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -624,12 +624,18 @@ struct ieee80211_if_init_conf {
  * enum ieee80211_if_conf_change - interface config change flags
  *
  * @IEEE80211_IFCC_BSSID: The BSSID changed.
- * @IEEE80211_IFCC_BEACON: The beacon for this interface changed
- *	(currently AP and MESH only), use ieee80211_beacon_get().
+ * @IEEE80211_IFCC_CONFIGURE_BEACON: The beacon for this interface changed
+ *	(currently AP,IBSS and MESH only), use ieee80211_beacon_get().
+ * @IEEE80211_IFCC_STOP_BEACON: Indicates that beaconing should be stopped
+ *	by the driver.
+ * @IEEE80211_IFCC_RESUME_BEACON: Beaconing can be resumed by the driver,
+ *	with the original template obtained from mac80211.
  */
 enum ieee80211_if_conf_change {
-	IEEE80211_IFCC_BSSID	= BIT(0),
-	IEEE80211_IFCC_BEACON	= BIT(1),
+	IEEE80211_IFCC_BSSID		= BIT(0),
+	IEEE80211_IFCC_CONFIGURE_BEACON	= BIT(1),
+	IEEE80211_IFCC_STOP_BEACON	= BIT(2),
+	IEEE80211_IFCC_RESUME_BEACON	= BIT(3)
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index d1ac3ab..b6d718c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -523,7 +523,7 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 
 	kfree(old);
 
-	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	return ieee80211_if_config(sdata, IEEE80211_IFCC_CONFIGURE_BEACON);
 }
 
 static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
@@ -583,7 +583,7 @@ static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 	synchronize_rcu();
 	kfree(old);
 
-	return ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	return ieee80211_if_config(sdata, IEEE80211_IFCC_STOP_BEACON);
 }
 
 /* Layer 2 Update frame (802.2 Type 1 LLC XID Update response) */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 82f568e..988827c 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -427,7 +427,7 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 
 	free_plinks = mesh_plink_availables(sdata);
 	if (free_plinks != sdata->u.mesh.accepting_plinks)
-		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+		ieee80211_if_config(sdata, IEEE80211_IFCC_CONFIGURE_BEACON);
 
 	ifmsh->housekeeping = false;
 	mod_timer(&ifmsh->housekeeping_timer,
@@ -442,7 +442,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 
 	ifmsh->housekeeping = true;
 	queue_work(local->hw.workqueue, &ifmsh->work);
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_CONFIGURE_BEACON);
 }
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 81c5cff..59197bd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1598,7 +1598,7 @@ static int ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	ifsta->probe_resp = skb;
 
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_CONFIGURE_BEACON);
 
 
 	rates = 0;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a2caeed..09f4839 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -459,6 +459,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 
 	local->sw_scanning = false;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_RESUME_BEACON);
 
 	netif_tx_lock_bh(local->mdev);
 	netif_addr_lock(local->mdev);
@@ -655,6 +656,8 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 	local->scan_band = IEEE80211_BAND_2GHZ;
 	local->scan_sdata = scan_sdata;
 
+	ieee80211_if_config(scan_sdata, IEEE80211_IFCC_STOP_BEACON);
+
 	netif_addr_lock_bh(local->mdev);
 	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
 	local->ops->configure_filter(local_to_hw(local),
