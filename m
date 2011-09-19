Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55822 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab1ISQP6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:15:58 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 3/9] ath6kl: Remove RSSI update for internal node table
Date: Mon, 19 Sep 2011 19:15:01 +0300
Message-ID: <1316448907-10166-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20110919_181601_821232_AF4F6CC6)
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl does not actually update cfg80211 BSS table when this update
occurs, so there is not much need in updating the internal table
that is not used or exposed.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index acbd35d..f21e4b1 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1091,26 +1091,11 @@ static void ath6kl_update_target_stats(struct ath6kl *ar, u8 *ptr, u32 len)
 		(struct wmi_target_stats *) ptr;
 	struct target_stats *stats = &ar->target_stats;
 	struct tkip_ccmp_stats *ccmp_stats;
-	struct bss *conn_bss = NULL;
-	struct cserv_stats *c_stats;
 	u8 ac;
 
 	if (len < sizeof(*tgt_stats))
 		return;
 
-	/* update the RSSI of the connected bss */
-	if (test_bit(CONNECTED, &ar->flag)) {
-		conn_bss = ath6kl_wmi_find_node(ar->wmi, ar->bssid);
-		if (conn_bss) {
-			c_stats = &tgt_stats->cserv_stats;
-			conn_bss->ni_rssi =
-				a_sle16_to_cpu(c_stats->cs_ave_beacon_rssi);
-			conn_bss->ni_snr =
-				tgt_stats->cserv_stats.cs_ave_beacon_snr;
-			ath6kl_wmi_node_return(ar->wmi, conn_bss);
-		}
-	}
-
 	ath6kl_dbg(ATH6KL_DBG_TRC, "updating target stats\n");
 
 	stats->tx_pkt += le32_to_cpu(tgt_stats->stats.tx.pkt);
-- 
1.7.4.1

