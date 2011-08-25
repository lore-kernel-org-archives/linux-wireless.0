Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48551 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1HYLZh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 07:25:37 -0400
Received: by wyg24 with SMTP id 24so1571326wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 04:25:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] wl12xx: declare support for WIPHY_FLAG_AP_UAPSD
Date: Thu, 25 Aug 2011 14:26:54 +0300
Message-Id: <1314271614-8830-1-git-send-email-eliad@wizery.com> (sfid-20110825_132540_062528_D59705A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Declare support for uapsd when working as AP, and
set psd_type and sp_len whan a station is being added.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
(depends on "mac80211: add uapsd_queues and max_sp params fields")
v2: delcare support for WIPHY_FLAG_AP_UAPSD

 drivers/net/wireless/wl12xx/cmd.c  |   15 ++++++++++-----
 drivers/net/wireless/wl12xx/cmd.h  |    7 +++++++
 drivers/net/wireless/wl12xx/main.c |    2 ++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 817bc18..d5a0ebe 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1413,7 +1413,7 @@ out:
 int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 {
 	struct wl12xx_cmd_add_peer *cmd;
-	int ret;
+	int i, ret;
 	u32 sta_rates;
 
 	wl1271_debug(DEBUG_CMD, "cmd add peer %d", (int)hlid);
@@ -1424,15 +1424,19 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 		goto out;
 	}
 
-	/* currently we don't support UAPSD */
-	cmd->sp_len = 0;
-
 	memcpy(cmd->addr, sta->addr, ETH_ALEN);
 	cmd->bss_index = WL1271_AP_BSS_INDEX;
 	cmd->aid = sta->aid;
 	cmd->hlid = hlid;
+	cmd->sp_len = sta->max_sp;
 	cmd->wmm = sta->wme ? 1 : 0;
 
+	for (i = 0; i < NUM_ACCESS_CATEGORIES_COPY; i++)
+		if (sta->wme && (sta->uapsd_queues & BIT(i)))
+			cmd->psd_type[i] = WL1271_PSD_UPSD_TRIGGER;
+		else
+			cmd->psd_type[i] = WL1271_PSD_LEGACY;
+
 	sta_rates = sta->supp_rates[wl->band];
 	if (sta->ht_cap.ht_supported)
 		sta_rates |= sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET;
@@ -1440,7 +1444,8 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 	cmd->supported_rates =
 		cpu_to_le32(wl1271_tx_enabled_rates_get(wl, sta_rates));
 
-	wl1271_debug(DEBUG_CMD, "new peer rates: 0x%x", cmd->supported_rates);
+	wl1271_debug(DEBUG_CMD, "new peer rates=0x%x queues=0x%x",
+		     cmd->supported_rates, sta->uapsd_queues);
 
 	ret = wl1271_cmd_send(wl, CMD_ADD_PEER, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 22c2f37..8e4d11e 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -591,6 +591,13 @@ enum wl12xx_ssid_type {
 	WL12XX_SSID_TYPE_ANY = 2,
 };
 
+enum wl1271_psd_type {
+	WL1271_PSD_LEGACY = 0,
+	WL1271_PSD_UPSD_TRIGGER = 1,
+	WL1271_PSD_LEGACY_PSPOLL = 2,
+	WL1271_PSD_SAPSD = 3
+};
+
 struct wl12xx_cmd_add_peer {
 	struct wl1271_cmd_header header;
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bde8402..58060d2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -4500,6 +4500,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_DFLT_SIZE -
 			sizeof(struct ieee80211_header);
 
+	wl->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
+
 	/* make sure all our channels fit in the scanned_ch bitmask */
 	BUILD_BUG_ON(ARRAY_SIZE(wl1271_channels) +
 		     ARRAY_SIZE(wl1271_channels_5ghz) >
-- 
1.7.6.401.g6a319

