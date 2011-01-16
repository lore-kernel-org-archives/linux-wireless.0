Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:65317 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab1APGUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 01:20:42 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 22:20:24 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: abort tx/rx on fast channel change
Date: Sun, 16 Jan 2011 11:49:54 +0530
Message-ID: <1295158794-3088-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Abort Tx/Rx on fast channel change before hw reset.
This helps to avoid timeout on loading noise floor
values after channel change.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 187af5b..d374867 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -193,8 +193,6 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	ath9k_htc_ps_wakeup(priv);
 	htc_stop(priv->htc);
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
-	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
-	WMI_CMD(WMI_STOP_RECV_CMDID);
 
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"(%u MHz) -> (%u MHz), HT: %d, HT40: %d fastcc: %d\n",
@@ -202,8 +200,21 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 		channel->center_freq, conf_is_ht(conf), conf_is_ht40(conf),
 		fastcc);
 
-	if (!fastcc)
+	if (fastcc) {
+		/* abort pending tx frames */
+		WMI_CMD(WMI_ABORT_TX_DMA_CMDID);
+		WMI_CMD(WMI_ABORT_TXQ_CMDID);
+
+		/* Clear receive filter */
+		ath9k_hw_setrxfilter(ah, 0);
+
+		WMI_CMD(WMI_STOP_DMA_RECV_CMDID);
+		WMI_CMD(WMI_RX_LINK_CMDID);
+	} else {
+		WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
+		WMI_CMD(WMI_STOP_RECV_CMDID);
 		caldata = &priv->caldata;
+	}
 	ret = ath9k_hw_reset(ah, hchan, caldata, fastcc);
 	if (ret) {
 		ath_err(common,
-- 
1.7.3.5

