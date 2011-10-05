Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41414 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934210Ab1JEJzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:55:53 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so1903568bkb.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:55:52 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/29] wl12xx: replace wl->bssid with vif->bss_conf.bssid
Date: Wed,  5 Oct 2011 11:55:44 +0200
Message-Id: <1317808566-18857-8-git-send-email-eliad@wizery.com> (sfid-20111005_115556_451437_DB9911F2)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the per-interface vif->bss_conf instead of the global wl->bssid.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   13 ++++++++-----
 drivers/net/wireless/wl12xx/event.c  |    2 +-
 drivers/net/wireless/wl12xx/main.c   |   15 ++-------------
 drivers/net/wireless/wl12xx/wl12xx.h |    1 -
 4 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index ccc3571..5f4d31d 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -557,6 +557,7 @@ out:
 
 int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct wl12xx_cmd_role_start *cmd;
 	int ret;
 
@@ -577,7 +578,7 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->sta.ssid_type = WL12XX_SSID_TYPE_ANY;
 	cmd->sta.ssid_len = wl->ssid_len;
 	memcpy(cmd->sta.ssid, wl->ssid, wl->ssid_len);
-	memcpy(cmd->sta.bssid, wl->bssid, ETH_ALEN);
+	memcpy(cmd->sta.bssid, vif->bss_conf.bssid, ETH_ALEN);
 	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
 	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID) {
@@ -769,6 +770,7 @@ out:
 
 int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
+	struct ieee80211_vif *vif = wl12xx_wlvif_to_vif(wlvif);
 	struct wl12xx_cmd_role_start *cmd;
 	struct ieee80211_bss_conf *bss_conf = &wl->vif->bss_conf;
 	int ret;
@@ -791,7 +793,7 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	cmd->ibss.ssid_type = WL12XX_SSID_TYPE_ANY;
 	cmd->ibss.ssid_len = wl->ssid_len;
 	memcpy(cmd->ibss.ssid, wl->ssid, wl->ssid_len);
-	memcpy(cmd->ibss.bssid, wl->bssid, ETH_ALEN);
+	memcpy(cmd->ibss.bssid, vif->bss_conf.bssid, ETH_ALEN);
 	cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
 
 	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID) {
@@ -807,7 +809,8 @@ int wl12xx_cmd_role_start_ibss(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 		     wl->role_id, cmd->sta.hlid, cmd->sta.session,
 		     wlvif->basic_rate_set, wlvif->rate_set);
 
-	wl1271_debug(DEBUG_CMD, "wl->bssid = %pM", wl->bssid);
+	wl1271_debug(DEBUG_CMD, "vif->bss_conf.bssid = %pM",
+		     vif->bss_conf.bssid);
 
 	ret = wl1271_cmd_send(wl, CMD_ROLE_START, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
@@ -1213,9 +1216,9 @@ int wl1271_build_qos_null_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 	memset(&template, 0, sizeof(template));
 
-	memcpy(template.addr1, wl->bssid, ETH_ALEN);
+	memcpy(template.addr1, vif->bss_conf.bssid, ETH_ALEN);
 	memcpy(template.addr2, vif->addr, ETH_ALEN);
-	memcpy(template.addr3, wl->bssid, ETH_ALEN);
+	memcpy(template.addr3, vif->bss_conf.bssid, ETH_ALEN);
 
 	template.frame_control = cpu_to_le16(IEEE80211_FTYPE_DATA |
 					     IEEE80211_STYPE_QOS_NULLFUNC |
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 3cee847..2066c91 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -184,7 +184,7 @@ static void wl1271_stop_ba_event(struct wl1271 *wl)
 		if (!wl->ba_rx_bitmap)
 			return;
 		ieee80211_stop_rx_ba_session(wl->vif, wl->ba_rx_bitmap,
-					     wl->bssid);
+					     wl->vif->bss_conf.bssid);
 	} else {
 		int i;
 		struct wl1271_link *lnk;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 59a6040..ad8a324 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2098,7 +2098,6 @@ deinit:
 	wl1271_tx_reset(wl, reset_tx_queues);
 	wl1271_power_off(wl);
 
-	memset(wl->bssid, 0, ETH_ALEN);
 	memset(wl->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
 	wl->ssid_len = 0;
 	wl->bss_type = MAX_BSS_TYPE;
@@ -2244,8 +2243,6 @@ static int wl1271_unjoin(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	memset(wl->bssid, 0, ETH_ALEN);
-
 	/* reset TX security counters on a clean disconnect */
 	wl->tx_security_last_seq_lsb = 0;
 	wl->tx_security_seq = 0;
@@ -3444,15 +3441,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		wl->rssi_thold = bss_conf->cqm_rssi_thold;
 	}
 
-	if ((changed & BSS_CHANGED_BSSID) &&
-	    /*
-	     * Now we know the correct bssid, so we send a new join command
-	     * and enable the BSSID filter
-	     */
-	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
-		memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
-
-		if (!is_zero_ether_addr(wl->bssid)) {
+	if (changed & BSS_CHANGED_BSSID)
+		if (!is_zero_ether_addr(bss_conf->bssid)) {
 			ret = wl12xx_cmd_build_null_data(wl, wlvif);
 			if (ret < 0)
 				goto out;
@@ -3464,7 +3454,6 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			/* Need to update the BSSID (for filtering etc) */
 			do_join = true;
 		}
-	}
 
 	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_HT)) {
 		rcu_read_lock();
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4af4f24..efa4720 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -398,7 +398,6 @@ struct wl1271 {
 
 	s8 hw_pg_ver;
 
-	u8 bssid[ETH_ALEN];
 	u8 mac_addr[ETH_ALEN];
 	u8 bss_type;
 	u8 set_bss_type;
-- 
1.7.6.401.g6a319

