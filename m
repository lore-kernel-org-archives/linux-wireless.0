Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50486 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1IDILh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Sep 2011 04:11:37 -0400
Received: by wyh22 with SMTP id 22so2903585wyh.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Sep 2011 01:11:36 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2] mac80211: add ssid config to bss information in AP-mode
Date: Sun,  4 Sep 2011 11:11:32 +0300
Message-Id: <1315123892-5031-1-git-send-email-arik@wizery.com> (sfid-20110904_101151_620400_83D62F7F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set SSID information from nl80211 beacon parameters. Advertise changes
in SSID to low level drivers.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->2: fixed a bug introduced to ieee80211_reconfig (thanks Eliad)

include/net/mac80211.h |    8 ++++++++
 net/mac80211/cfg.c     |   19 ++++++++++++++++++-
 net/mac80211/util.c    |    2 ++
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2f01d84..137d67d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -164,6 +164,7 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_QOS: QoS for this association was enabled/disabled. Note
  *	that it is only ever disabled for station mode.
  * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
+ * @BSS_CHANGED_SSID: SSID changed for this BSS (AP mode)
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -181,6 +182,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_ARP_FILTER		= 1<<12,
 	BSS_CHANGED_QOS			= 1<<13,
 	BSS_CHANGED_IDLE		= 1<<14,
+	BSS_CHANGED_SSID		= 1<<15,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -254,6 +256,9 @@ enum ieee80211_rssi_event {
  * @idle: This interface is idle. There's also a global idle flag in the
  *	hardware config which may be more appropriate depending on what
  *	your driver/device needs to do.
+ * @ssid: The SSID of the current vif. Only valid in AP-mode.
+ * @ssid_len: Length of SSID given in @ssid.
+ * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -280,6 +285,9 @@ struct ieee80211_bss_conf {
 	bool arp_filter_enabled;
 	bool qos;
 	bool idle;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	size_t ssid_len;
+	bool hidden_ssid;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7d17a91..d8682dd 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -455,6 +455,20 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static void ieee80211_config_ap_ssid(struct ieee80211_sub_if_data *sdata,
+				     struct beacon_parameters *params)
+{
+	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
+
+	bss_conf->ssid_len = params->ssid_len;
+
+	if (params->ssid_len)
+		memcpy(bss_conf->ssid, params->ssid, params->ssid_len);
+
+	bss_conf->hidden_ssid =
+		(params->hidden_ssid != NL80211_HIDDEN_SSID_NOT_IN_USE);
+}
+
 /*
  * This handles both adding a beacon and setting new beacon info
  */
@@ -548,8 +562,11 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 
 	kfree(old);
 
+	ieee80211_config_ap_ssid(sdata, params);
+
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED |
-						BSS_CHANGED_BEACON);
+						BSS_CHANGED_BEACON |
+						BSS_CHANGED_SSID);
 	return 0;
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ce916ff..096f7a9 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1082,6 +1082,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			changed |= BSS_CHANGED_IBSS;
 			/* fall through */
 		case NL80211_IFTYPE_AP:
+			changed |= BSS_CHANGED_SSID;
+			/* fall through */
 		case NL80211_IFTYPE_MESH_POINT:
 			changed |= BSS_CHANGED_BEACON |
 				   BSS_CHANGED_BEACON_ENABLED;
-- 
1.7.4.1

