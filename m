Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59783 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab0ENFs3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 01:48:29 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 22:48:29 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19436.58438.219044.451729@gargle.gargle.HOWL>
Date: Fri, 14 May 2010 11:18:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/4] ath9k_htc: Add queue statistics to xmit debugfs file
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    3 +++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   13 +++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    4 ++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index ad556aa..2dd9ad3 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -256,12 +256,15 @@ struct ath9k_htc_tx_ctl {
 #define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
 #define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.rx_stats.c++)
 
+#define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
+
 struct ath_tx_stats {
 	u32 buf_queued;
 	u32 buf_completed;
 	u32 skb_queued;
 	u32 skb_completed;
 	u32 skb_dropped;
+	u32 queue_stats[WME_NUM_AC];
 };
 
 struct ath_rx_stats {
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 9d371c1..cf1112b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -617,6 +617,19 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 			"%20s : %10u\n", "SKBs dropped",
 			priv->debug.tx_stats.skb_dropped);
 
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "BE queued",
+			priv->debug.tx_stats.queue_stats[WME_AC_BE]);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "BK queued",
+			priv->debug.tx_stats.queue_stats[WME_AC_BK]);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "VI queued",
+			priv->debug.tx_stats.queue_stats[WME_AC_VI]);
+	len += snprintf(buf + len, sizeof(buf) - len,
+			"%20s : %10u\n", "VO queued",
+			priv->debug.tx_stats.queue_stats[WME_AC_VO]);
+
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 28abc7d..2a0585d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -135,16 +135,20 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 
 		switch (hw_qnum) {
 		case 0:
+			TX_QSTAT_INC(WME_AC_BE);
 			epid = priv->data_be_ep;
 			break;
 		case 2:
+			TX_QSTAT_INC(WME_AC_VI);
 			epid = priv->data_vi_ep;
 			break;
 		case 3:
+			TX_QSTAT_INC(WME_AC_VO);
 			epid = priv->data_vo_ep;
 			break;
 		case 1:
 		default:
+			TX_QSTAT_INC(WME_AC_BK);
 			epid = priv->data_bk_ep;
 			break;
 		}
-- 
1.7.1

