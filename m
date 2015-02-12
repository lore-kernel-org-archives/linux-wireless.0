Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50936 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbbBLJ3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 04:29:09 -0500
From: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
Subject: [PATCH] ath10k: Increase AST table SKID length limit
Date: Thu, 12 Feb 2015 14:58:42 +0530
Message-ID: <1423733322-31113-1-git-send-email-sjegadee@qti.qualcomm.com> (sfid-20150212_102914_499763_409ACA29)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current SKID length configuration causes firmware
to reject peer creation for not able to allocate
AST entries for peers. This issue is observed when
least significant 3 bytes are used ramdomly to create
client MAC addresses.

AST table SKID length configuration is increased to
maximum value to fix this issue.

Signed-off-by: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.h  | 1 +
 drivers/net/wireless/ath/ath10k/wmi.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 460771f..b86996e 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -254,6 +254,7 @@ struct ath10k_pktlog_hdr {

 /* 10.2 parameters */
 #define TARGET_10_2_DMA_BURST_SIZE		1
+#define TARGET_10_2_AST_SKID_LIMIT		128

 /* Target specific defines for WMI-TLV firmware */
 #define TARGET_TLV_NUM_VDEVS			3
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index aeea1c7..13290da 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -3920,7 +3920,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
 	config.num_peer_keys = __cpu_to_le32(TARGET_10X_NUM_PEER_KEYS);
 	config.num_tids = __cpu_to_le32(TARGET_10X_NUM_TIDS);
-	config.ast_skid_limit = __cpu_to_le32(TARGET_10X_AST_SKID_LIMIT);
+	config.ast_skid_limit = __cpu_to_le32(TARGET_10_2_AST_SKID_LIMIT);
 	config.tx_chain_mask = __cpu_to_le32(TARGET_10X_TX_CHAIN_MASK);
 	config.rx_chain_mask = __cpu_to_le32(TARGET_10X_RX_CHAIN_MASK);
 	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
--
1.9.1

