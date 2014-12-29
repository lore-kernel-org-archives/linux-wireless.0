Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54312 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaL2GSq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2014 01:18:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Fix DMA burst size
Date: Mon, 29 Dec 2014 11:51:06 +0530
Message-Id: <1419834066-11802-1-git-send-email-sujith@msujith.org> (sfid-20141229_071947_269938_A4A55C03)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

A value of zero indicates that 128B is the maximum
DMA request size for read/writes. But PCI cards based
on AR9880 can support 256B, so enable this for
the 10.2 firmware.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  | 3 +++
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5729901..7b771ae 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -183,6 +183,9 @@ struct ath10k_pktlog_hdr {
 #define TARGET_10X_NUM_MSDU_DESC		(1024 + 400)
 #define TARGET_10X_MAX_FRAG_ENTRIES		0
 
+/* 10.2 parameters */
+#define TARGET_10_2_DMA_BURST_SIZE		1
+
 /* Target specific defines for WMI-TLV firmware */
 #define TARGET_TLV_NUM_VDEVS			3
 #define TARGET_TLV_NUM_STATIONS			32
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ac74290..b103122 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3744,7 +3744,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	config.mcast2ucast_mode = __cpu_to_le32(TARGET_10X_MCAST2UCAST_MODE);
 	config.tx_dbg_log_size = __cpu_to_le32(TARGET_10X_TX_DBG_LOG_SIZE);
 	config.num_wds_entries = __cpu_to_le32(TARGET_10X_NUM_WDS_ENTRIES);
-	config.dma_burst_size = __cpu_to_le32(TARGET_10X_DMA_BURST_SIZE);
+	config.dma_burst_size = __cpu_to_le32(TARGET_10_2_DMA_BURST_SIZE);
 	config.mac_aggr_delim = __cpu_to_le32(TARGET_10X_MAC_AGGR_DELIM);
 
 	val = TARGET_10X_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK;
-- 
2.2.1

