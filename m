Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53494 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbYLSCpr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:47 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 43/43] iwl3945: use iwl_rb_status
Date: Fri, 19 Dec 2008 10:37:43 +0800
Message-Id: <1229654263-21454-44-git-send-email-yi.zhu@intel.com> (sfid-20081219_040901_414509_701B54BD)
In-Reply-To: <1229654263-21454-43-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-11-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-12-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-13-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-14-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-15-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-16-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-17-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-18-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-19-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-20-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-21-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-22-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-23-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-24-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-25-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-26-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-27-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-28-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-29-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-30-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-31-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-32-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-33-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-34-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-35-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-36-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-37-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-38-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-39-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-40-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-41-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-42-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-43-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch makes use of iwl_rb_status also in 3945. The structure
for 3945 is not the same but since only closed_rb_num filed is used
in both cases there is no reason to duplicate it.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   11 +----------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-fh.h       |    1 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 6 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 5d461bd..fc1b774 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -302,7 +302,6 @@ static inline int iwl3945_hw_valid_rtc_data_addr(u32 addr)
  * and &iwl3945_shared.rx_read_ptr[0] is provided to FH_RCSR_RPTR_ADDR(0) */
 struct iwl3945_shared {
 	__le32 tx_base_ptr[8];
-	__le32 rx_read_ptr[3];
 } __attribute__ ((packed));
 
 struct iwl3945_tfd_frame_data {
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 31ba6a5..131bae7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -975,9 +975,7 @@ static int iwl3945_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	}
 
 	iwl_write_direct32(priv, FH39_RCSR_RBD_BASE(0), rxq->dma_addr);
-	iwl_write_direct32(priv, FH39_RCSR_RPTR_ADDR(0),
-			     priv->shared_phys +
-			     offsetof(struct iwl3945_shared, rx_read_ptr[0]));
+	iwl_write_direct32(priv, FH39_RCSR_RPTR_ADDR(0), rxq->rb_stts_dma);
 	iwl_write_direct32(priv, FH39_RCSR_WPTR(0), 0);
 	iwl_write_direct32(priv, FH39_RCSR_CONFIG(0),
 		FH39_RCSR_RX_CONFIG_REG_VAL_DMA_CHNL_EN_ENABLE |
@@ -2378,13 +2376,6 @@ int iwl3945_hw_tx_queue_init(struct iwl_priv *priv, struct iwl3945_tx_queue *txq
 	return 0;
 }
 
-int iwl3945_hw_get_rx_read(struct iwl_priv *priv)
-{
-	struct iwl3945_shared *shared_data = priv->shared_virt;
-
-	return le32_to_cpu(shared_data->rx_read_ptr[0]);
-}
-
 /**
  * iwl3945_init_hw_rate_table - Initialize the hardware rate fallback table
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 9c520c4..aff6a3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -282,7 +282,6 @@ extern int iwl3945_hw_tx_queue_init(struct iwl_priv *priv,
 				struct iwl3945_tx_queue *txq);
 extern unsigned int iwl3945_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl3945_frame *frame, u8 rate);
-extern int iwl3945_hw_get_rx_read(struct iwl_priv *priv);
 void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv, struct iwl_cmd *cmd,
 				     struct ieee80211_tx_info *info,
 				     struct ieee80211_hdr *hdr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 6a07a68..8981c05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1021,7 +1021,7 @@ struct iwl_priv {
 	u16 beacon_int;
 	struct ieee80211_vif *vif;
 
-	/*Added	for 3945 */
+	/*Added for 3945 */
 	void *shared_virt;
 	dma_addr_t shared_phys;
 	/*End*/
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index d7da198..7c19790 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -414,6 +414,7 @@ struct iwl_rb_status {
 	__le16 closed_fr_num;
 	__le16 finished_rb_num;
 	__le16 finished_fr_nam;
+	__le32 __unused; /* 3945 only */
 } __attribute__ ((packed));
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1a2a4f3..4b4ed65 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3594,7 +3594,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
-	r = iwl3945_hw_get_rx_read(priv);
+	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
 	i = rxq->read;
 
 	if (iwl3945_rx_queue_space(rxq) > (RX_QUEUE_SIZE / 2))
-- 
1.5.3.6

