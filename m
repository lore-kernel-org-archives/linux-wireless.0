Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45527 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3LSIjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 03:39:18 -0500
Received: by mail-pa0-f42.google.com with SMTP id lj1so877237pab.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Dec 2013 00:39:17 -0800 (PST)
From: Thomas Pedersen <twpedersen@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/2] mac80211: sync dtim_count to TSF
Date: Thu, 19 Dec 2013 00:37:59 -0800
Message-Id: <1387442279-1526-2-git-send-email-twpedersen@gmail.com> (sfid-20131219_093925_370409_E48E7922)
In-Reply-To: <1387442279-1526-1-git-send-email-twpedersen@gmail.com>
References: <1387442279-1526-1-git-send-email-twpedersen@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thomas Pedersen <thomas@cozybit.com>

On starting a mesh, ad-hoc, or AP BSS, the interface
dtim_count countdown should match that of the driver TSF.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
v2:
	adjust dtim_count instead of setting TSF=0
	(Sergey)

 net/mac80211/cfg.c            |    2 ++
 net/mac80211/debugfs_netdev.c |    1 +
 net/mac80211/ibss.c           |    1 +
 net/mac80211/ieee80211_i.h    |    2 ++
 net/mac80211/mesh.c           |    1 +
 net/mac80211/util.c           |   28 ++++++++++++++++++++++++++++
 6 files changed, 35 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ac18528..8211d30 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -951,6 +951,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			      struct cfg80211_ap_settings *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
 	struct beacon_data *old;
 	struct ieee80211_sub_if_data *vlan;
 	u32 changed = BSS_CHANGED_BEACON_INT |
@@ -1030,6 +1031,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		return err;
 	}
 
+	ieee80211_recalc_dtim(local, sdata);
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(dev);
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 04b5a14..89160f7 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -468,6 +468,7 @@ static ssize_t ieee80211_if_parse_tsf(
 		}
 	}
 
+	ieee80211_recalc_dtim(local, sdata);
 	return buflen;
 }
 __IEEE80211_IF_FILE_W(tsf);
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d6ba8414..a92c8a9 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -369,6 +369,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		return;
 	}
 
+	ieee80211_recalc_dtim(local, sdata);
 	ieee80211_bss_info_change_notify(sdata, bss_change);
 
 	ifibss->state = IEEE80211_IBSS_MLME_JOINED;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 33ebe08..337fcad 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1794,6 +1794,8 @@ ieee80211_cs_get(struct ieee80211_local *local, u32 cipher,
 int ieee80211_cs_headroom(struct ieee80211_local *local,
 			  struct cfg80211_crypto_settings *crypto,
 			  enum nl80211_iftype iftype);
+void ieee80211_recalc_dtim(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *sdata);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5a74b24..5b919ca 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -807,6 +807,7 @@ int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		return -ENOMEM;
 	}
 
+	ieee80211_recalc_dtim(local, sdata);
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(sdata->dev);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 656648b..599cf37 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2588,3 +2588,31 @@ int ieee80211_cs_headroom(struct ieee80211_local *local,
 
 	return headroom;
 }
+
+void ieee80211_recalc_dtim(struct ieee80211_local *local,
+			   struct ieee80211_sub_if_data *sdata)
+{
+	u64 tsf = drv_get_tsf(local, sdata);
+	u64 dtim_count = 0;
+	u16 beacon_int = sdata->vif.bss_conf.beacon_int * 1024;
+	u8 dtim_period = sdata->vif.bss_conf.dtim_period;
+	u8 bcns_from_dtim;
+
+	if (tsf == -1ULL || !beacon_int || !dtim_period)
+		return;
+
+	/*
+	 * actually finds last dtim_count, mac80211 will update in
+	 * __beacon_add_tim().
+	 * dtim_count = dtim_period - (tsf / bcn_int) % dtim_period
+	 */
+	do_div(tsf, beacon_int);
+	bcns_from_dtim = do_div(tsf, dtim_period);
+	/* just had a DTIM */
+	if (!bcns_from_dtim)
+		dtim_count = 0;
+	else
+		dtim_count = dtim_period - bcns_from_dtim;
+
+	sdata->u.mesh.ps.dtim_count = dtim_count;
+}
-- 
1.7.10.4

