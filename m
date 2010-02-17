Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:44193 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321Ab0BQVER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 16:04:17 -0500
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id 3F95CEF389
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 23:04:16 +0200 (EET)
Received: from [127.0.1.1] (a91-155-131-184.elisa-laajakaista.fi [91.155.131.184])
	by emh02.mail.saunalahti.fi (Postfix) with ESMTP id 21F722BD6D
	for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 23:04:15 +0200 (EET)
Subject: [RFC PATCH 2/3] mac80211: use nullfunc in connection monitor
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 17 Feb 2010 23:04:14 +0200
Message-ID: <20100217210414.30634.77618.stgit@tikku>
In-Reply-To: <20100217210202.30634.69236.stgit@tikku>
References: <20100217210202.30634.69236.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Currently mac80211 is periodically sending probe request to the AP
during idle periods to make sure that the connection to the AP works. But
on hardware which have IEEE80211_HW_REPORTS_TX_ACK_STATUS we can use
nullfunc frames. This is because  we can check from the tx status if an
acknowledgement frame was received from the AP or not.

Major benefit from this is that we don't need to wakeup from power save
just for this and can save power. Another benefit is that we can faster notice
if the AP is lost and hopefully reduce the roaming time in that case.
(NB: these are not implemented yet)

In the first phase we just use nullfunc frames instead of the probe requsts
and do not change the mlme drastically, just to be on the safe side. Later
on the logic can be improved and we can get the benefits mentioned above.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   37 ++++++++++++++++++++++++------
 net/mac80211/status.c      |   54 +++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 241533e..79e065b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -317,6 +317,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_MFP_ENABLED	= BIT(6),
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
+	IEEE80211_STA_CON_POLL_ACKED	= BIT(9),
 };
 
 struct ieee80211_if_managed {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 41812a1..4b9596f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -857,11 +857,16 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_local *local = sdata->local;
 	const u8 *ssid;
 
-	ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
-	ieee80211_send_probe_req(sdata, ifmgd->associated->bssid,
-				 ssid + 2, ssid[1], NULL, 0);
+	if (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) {
+		ieee80211_send_nullfunc(local, sdata, 0);
+	} else {
+		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
+		ieee80211_send_probe_req(sdata, ifmgd->associated->bssid,
+					 ssid + 2, ssid[1], NULL, 0);
+	}
 
 	ifmgd->probe_send_count++;
 	ifmgd->probe_timeout = jiffies + IEEE80211_PROBE_WAIT;
@@ -1579,9 +1584,27 @@ static void ieee80211_sta_work(struct work_struct *work)
 	/* then process the rest of the work */
 	mutex_lock(&ifmgd->mtx);
 
-	if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
+	if ((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
+	    (ifmgd->flags & IEEE80211_STA_CON_POLL_ACKED)) {
+		/* FIXME: refactor with rx_mgmg_probe_resp() */
+		ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
+				  IEEE80211_STA_BEACON_POLL |
+				  IEEE80211_STA_CON_POLL_ACKED);
+		mutex_lock(&sdata->local->iflist_mtx);
+		ieee80211_recalc_ps(sdata->local, -1);
+		mutex_unlock(&sdata->local->iflist_mtx);
+		/*
+		 * We've received a probe response, but are not sure whether
+		 * we have or will be receiving any beacons or data, so let's
+		 * schedule the timers again, just in case.
+		 */
+		mod_beacon_timer(sdata);
+		mod_timer(&ifmgd->conn_mon_timer,
+			  round_jiffies_up(jiffies +
+					   IEEE80211_CONNECTION_IDLE_TIME));
+	} else if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
 			    IEEE80211_STA_CONNECTION_POLL) &&
-	    ifmgd->associated) {
+		   ifmgd->associated) {
 		u8 bssid[ETH_ALEN];
 
 		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
@@ -1590,7 +1613,7 @@ static void ieee80211_sta_work(struct work_struct *work)
 
 		else if (ifmgd->probe_send_count < IEEE80211_MAX_PROBE_TRIES) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			printk(KERN_DEBUG "No probe response from AP %pM"
+			printk(KERN_DEBUG "No response from AP %pM"
 				" after %dms, try %d\n", bssid,
 				(1000 * IEEE80211_PROBE_WAIT)/HZ,
 				ifmgd->probe_send_count);
@@ -1603,7 +1626,7 @@ static void ieee80211_sta_work(struct work_struct *work)
 			 */
 			ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 					  IEEE80211_STA_BEACON_POLL);
-			printk(KERN_DEBUG "No probe response from AP %pM"
+			printk(KERN_DEBUG "No response from AP %pM"
 				" after %dms, disconnecting.\n",
 				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
 			ieee80211_set_disassoc(sdata);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 8a17454..5311977 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -162,12 +162,58 @@ static void ieee80211_nullfunc_status(struct ieee80211_local *local,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_if_managed *ifmgd;
 	__le16 fc = hdr->frame_control;
 
-	if (ieee80211_has_pm(fc) &&
-	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
-	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-	    local->ps_sdata && !(local->scanning)) {
+	if (!(local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS))
+		return;
+
+	if (info->flags & IEEE80211_TX_CTL_INJECTED)
+		return;
+
+	if (local->scanning)
+		return;
+
+	/* FIXME: check association? */
+
+	/*
+	 * only executed when either 1) power save is enabled or 2) idle
+	 * connection monitor is enabled, so this is definitely not in fast
+	 * path and can be slow
+	 */
+
+	/* connection tracking */
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (sdata->vif.type != NL80211_IFTYPE_STATION)
+			continue;
+
+		ifmgd = &sdata->u.mgd;
+
+		if (ifmgd->flags & (IEEE80211_STA_BEACON_POLL |
+				    IEEE80211_STA_CONNECTION_POLL)) {
+			printk(KERN_DEBUG "nullfunc %s\n",
+			       (info->flags & IEEE80211_TX_STAT_ACK) ?
+			       "acked" : "nacked");
+
+			if (info->flags & IEEE80211_TX_STAT_ACK)
+				ifmgd->flags |= IEEE80211_STA_CON_POLL_ACKED;
+
+			/*
+			 * FIXME: report negative failure somehow, that way
+			 * there's no need to wait for the timer to
+			 * trigger
+			 */
+			ieee80211_queue_work(&local->hw, &ifmgd->work);
+		}
+
+	}
+	rcu_read_unlock();
+
+	/* trying to go into power save */
+	/* FIXME: add check for IEEE80211_HW_PS_NULLFUNC_STACK */
+	if (local->ps_sdata && ieee80211_has_pm(fc)) {
 		if (info->flags & IEEE80211_TX_STAT_ACK) {
 			local->ps_sdata->u.mgd.flags |=
 				IEEE80211_STA_NULLFUNC_ACKED;

