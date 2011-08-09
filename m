Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1HIJOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:25 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:25 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 29/40] wl12xx: AP-mode - configure STA HT rates on join
Date: Tue,  9 Aug 2011 12:13:42 +0300
Message-Id: <1312881233-9366-30-git-send-email-eliad@wizery.com> (sfid-20110809_111436_350166_2E702AA6)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
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
index b8d6848..9ef8621 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1411,16 +1411,18 @@ int wl1271_cmd_set_peer_state(struct wl1271 *wl, u8 hlid)
 out_free:
 	kfree(cmd);
 
 out:
 	return ret;
 }
+
 int wl1271_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
 {
 	struct wl1271_cmd_add_peer *cmd;
 	int ret;
+	u32 sta_rates;
 
 	wl1271_debug(DEBUG_CMD, "cmd add sta %d", (int)hlid);
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
@@ -1433,14 +1435,18 @@ int wl1271_cmd_add_peer(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid)
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
 
 	wl1271_debug(DEBUG_CMD, "new sta rates: 0x%x", cmd->supported_rates);
 
 	ret = wl1271_cmd_send(wl, CMD_ADD_PEER, cmd, sizeof(*cmd), 0);
 	if (ret < 0) {
 		wl1271_error("failed to initiate cmd add sta");
-- 
1.7.6.401.g6a319

