Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1HNKR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:59 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967072wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:58 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 29/40] wl12xx: AP-mode - configure STA HT rates on join
Date: Sun, 14 Aug 2011 13:17:28 +0300
Message-Id: <1313317059-16567-30-git-send-email-eliad@wizery.com> (sfid-20110814_121804_120637_41CB40B6)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

When a new STA joins the BSS, configure the HT rates it supports to the
FW.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index d8c3916..d3e9380 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1412,16 +1412,18 @@ int wl12xx_cmd_set_peer_state(struct wl1271 *wl, u8 hlid)
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
+
 int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 {
 	struct wl12xx_cmd_add_peer *cmd;
 	int ret;
+	u32 sta_rates;
 
 	wl1271_debug(DEBUG_CMD, "cmd add peer %d", (int)hlid);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
@@ -1434,14 +1436,18 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 	memcpy(cmd->addr, sta->addr, ETH_ALEN);
 	cmd->bss_index = WL1271_AP_BSS_INDEX;
 	cmd->aid = sta->aid;
 	cmd->hlid = hlid;
 	cmd->wmm = sta->wme ? 1 : 0;
 
-	cmd->supported_rates = cpu_to_le32(wl1271_tx_enabled_rates_get(wl,
-						sta->supp_rates[wl->band]));
+	sta_rates = sta->supp_rates[wl->band];
+	if (sta->ht_cap.ht_supported)
+		sta_rates |= sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET;
+
+	cmd->supported_rates =
+		cpu_to_le32(wl1271_tx_enabled_rates_get(wl, sta_rates));
 
 	wl1271_debug(DEBUG_CMD, "new peer rates: 0x%x", cmd->supported_rates);
 
 	ret = wl1271_cmd_send(wl, CMD_ADD_PEER, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to initiate cmd add peer");
-- 
1.7.6.401.g6a319

