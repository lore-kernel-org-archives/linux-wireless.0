Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:50684 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1HWLuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 07:50:32 -0400
Received: by ewy4 with SMTP id 4so6893ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 04:50:31 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: set psd_type and sp_len on wl12xx_cmd_add_peer()
Date: Tue, 23 Aug 2011 14:51:42 +0300
Message-Id: <1314100302-25913-1-git-send-email-eliad@wizery.com> (sfid-20110823_135035_590885_A468524E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the values given by mac80211 in order to configure
WME correctly (AP mode)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
this patch depends on 
"mac80211: add uapsd_queues and max_sp params fields"

 drivers/net/wireless/wl12xx/cmd.c |   15 ++++++++++-----
 drivers/net/wireless/wl12xx/cmd.h |    7 +++++++
 2 files changed, 17 insertions(+), 5 deletions(-)

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
 
-- 
1.7.6.401.g6a319

