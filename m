Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60870 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932068AbcGCT7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:59:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:50 +0300
Message-Id: <1467575332-32112-11-git-send-email-luca@coelho.fi> (sfid-20160703_215918_638075_9924BF9A)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 11/13] iwlwifi: pcie: make sure packet arrived to destined queue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Add a warning in case packet didn't end up in the HW
destined queue.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 8 +++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c   | 3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 2f024c7..a45be1d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -212,6 +212,8 @@ struct iwl_cmd_header_wide {
 #define FH_RSCSR_FRAME_INVALID		0x55550000
 #define FH_RSCSR_FRAME_ALIGN		0x40
 #define FH_RSCSR_RPA_EN			BIT(25)
+#define FH_RSCSR_RXQ_POS		16
+#define FH_RSCSR_RXQ_MASK		0x3F0000
 
 struct iwl_rx_packet {
 	/*
@@ -223,7 +225,11 @@ struct iwl_rx_packet {
 	 * 29:    flag fast IRQ request
 	 * 28-26: Reserved
 	 * 25:    Offload enabled
-	 * 24-14: Reserved
+	 * 24:    RPF enabled
+	 * 23:    RSS enabled
+	 * 22:    Checksum enabled
+	 * 21-16: RX queue
+	 * 15-14: Reserved
 	 * 13-00: RX frame size
 	 */
 	__le32 len_n_flags;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 4fad808..70e39e4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1104,6 +1104,9 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		if (pkt->len_n_flags == cpu_to_le32(FH_RSCSR_FRAME_INVALID))
 			break;
 
+		WARN_ON((le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_RXQ_MASK) >>
+			FH_RSCSR_RXQ_POS != rxq->id);
+
 		IWL_DEBUG_RX(trans,
 			     "cmd at offset %d: %s (0x%.2x, seq 0x%x)\n",
 			     rxcb._offset,
-- 
2.8.1

