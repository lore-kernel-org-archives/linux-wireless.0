Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58739 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071Ab2EJJPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:15:32 -0400
Received: by wgbds11 with SMTP id ds11so231730wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:15:31 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 28/78] wlcore: support peer MIMO rates
Date: Thu, 10 May 2012 12:13:33 +0300
Message-Id: <1336641263-5761-29-git-send-email-arik@wizery.com> (sfid-20120510_112353_003389_20A704B8)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parse the peer ht_cap element containing MCS8-MCS15 rates and pass it
to the FW. Rates unsupported by the HW will be sanitized by mac80211
before reaching us.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/cmd.c    |    4 +++-
 drivers/net/wireless/ti/wlcore/main.c   |    3 ++-
 drivers/net/wireless/ti/wlcore/tx.c     |    4 ++--
 drivers/net/wireless/ti/wlcore/wl12xx.h |    1 +
 4 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
index 8450f0e..0dec465 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -1371,7 +1371,9 @@ int wl12xx_cmd_add_peer(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 
 	sta_rates = sta->supp_rates[wlvif->band];
 	if (sta->ht_cap.ht_supported)
-		sta_rates |= sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET;
+		sta_rates |=
+			(sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET) |
+			(sta->ht_cap.mcs.rx_mask[1] << HW_MIMO_RATES_OFFSET);
 
 	cmd->supported_rates =
 		cpu_to_le32(wl1271_tx_enabled_rates_get(wl, sta_rates,
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 3cd2ddd..f64aeb9 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3695,7 +3695,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		sta_rate_set = sta->supp_rates[wl->hw->conf.channel->band];
 		if (sta->ht_cap.ht_supported)
 			sta_rate_set |=
-			    (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
+			  (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET) |
+			  (sta->ht_cap.mcs.rx_mask[1] << HW_MIMO_RATES_OFFSET);
 		sta_ht_cap = sta->ht_cap;
 		sta_exists = true;
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index 44e4e7b..200d091 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -428,10 +428,10 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set,
 		rate_set >>= 1;
 	}
 
-	/* MCS rates indication are on bits 16 - 23 */
+	/* MCS rates indication are on bits 16 - 31 */
 	rate_set >>= HW_HT_RATES_OFFSET - band->n_bitrates;
 
-	for (bit = 0; bit < 8; bit++) {
+	for (bit = 0; bit < 16; bit++) {
 		if (rate_set & 0x1)
 			enabled_rates |= (CONF_HW_BIT_RATE_MCS_0 << bit);
 		rate_set >>= 1;
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx.h b/drivers/net/wireless/ti/wlcore/wl12xx.h
index 05e6f74..571a4ef 100644
--- a/drivers/net/wireless/ti/wlcore/wl12xx.h
+++ b/drivers/net/wireless/ti/wlcore/wl12xx.h
@@ -502,6 +502,7 @@ void wl1271_rx_filter_flatten_fields(struct wl12xx_rx_filter *filter,
 /* Macros to handle wl1271.sta_rate_set */
 #define HW_BG_RATES_MASK	0xffff
 #define HW_HT_RATES_OFFSET	16
+#define HW_MIMO_RATES_OFFSET	24
 
 #define WL12XX_HW_BLOCK_SIZE	256
 
-- 
1.7.9.5

