Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49456 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZATIBT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 03:01:19 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 00:01:19 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18805.33791.193195.755178@gargle.gargle.HOWL> (sfid-20090120_090137_912566_0F86D8CC)
Date: Tue, 20 Jan 2009 13:27:51 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<Jouni.Malinen@Atheros.com>
Subject: [PATCH] mac80211: Add capability to enable/disable beaconing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a flag to notify drivers to start and
stop beaconing when needed, for example, during a scan run.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 include/net/mac80211.h |    3 +++
 net/mac80211/main.c    |   10 ++++++++++
 net/mac80211/scan.c    |    3 +++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9a5869e..a9f71b5 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -637,6 +637,8 @@ enum ieee80211_if_conf_change {
  *
  * @changed: parameters that have changed, see &enum ieee80211_if_conf_change.
  * @bssid: BSSID of the network we are associated to/creating.
+ * @enable_beacon: Indicates whether beacons can be sent.
+ *	This is valid only for AP/IBSS/MESH modes.
  *
  * This structure is passed to the config_interface() callback of
  * &struct ieee80211_hw.
@@ -644,6 +646,7 @@ enum ieee80211_if_conf_change {
 struct ieee80211_if_conf {
 	u32 changed;
 	u8 *bssid;
+	bool enable_beacon;
 };
 
 /**
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c78304d..44585c7 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -183,6 +183,16 @@ int ieee80211_if_config(struct ieee80211_sub_if_data *sdata, u32 changed)
 		return -EINVAL;
 	}
 
+	if ((changed & IEEE80211_IFCC_BEACON) &&
+	    (sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+	     sdata->vif.type == NL80211_IFTYPE_MESH_POINT)) {
+		if (local->sw_scanning || local->hw_scanning)
+			conf.enable_beacon = false;
+		else
+			conf.enable_beacon = true;
+	}
+
 	if (WARN_ON(!conf.bssid && (changed & IEEE80211_IFCC_BSSID)))
 		return -EINVAL;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index a2caeed..c8be92d 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -459,6 +459,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 
 	local->sw_scanning = false;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
 
 	netif_tx_lock_bh(local->mdev);
 	netif_addr_lock(local->mdev);
@@ -655,6 +656,8 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 	local->scan_band = IEEE80211_BAND_2GHZ;
 	local->scan_sdata = scan_sdata;
 
+	ieee80211_if_config(scan_sdata, IEEE80211_IFCC_BEACON);
+
 	netif_addr_lock_bh(local->mdev);
 	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
 	local->ops->configure_filter(local_to_hw(local),
-- 
1.6.1

