Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47276 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbFPFOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:14:32 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH 07/10] ath10k: Extend CE src desc flags for interrupt indication
Date: Tue, 16 Jun 2015 10:42:19 +0530
Message-ID: <1434431542-14724-8-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20150616_071434_921281_66696F35)
In-Reply-To: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
References: <1434431542-14724-1-git-send-email-vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

QCA99X0 uses two new copy engine src desc flags for interrupt
indication. Bit_2 is to mark if host interrupt is disabled after
processing the current desc and bit_3 is to mark if target interrupt
is diabled after the processing of current descriptor.
CE_DESC_FLAGS_META_DATA_MASK and CE_DESC_FLAGS_META_DATA_LSB are based
on the target type.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ce.c | 1 +
 drivers/net/wireless/ath/ath10k/ce.h | 9 +++++++--
 drivers/net/wireless/ath/ath10k/hw.c | 6 ++++++
 drivers/net/wireless/ath/ath10k/hw.h | 2 ++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index e508c65..cf28fbe 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -452,6 +452,7 @@ int ath10k_ce_completed_recv_next_nolock(struct ath10k_ce_pipe *ce_state,
 {
 	struct ath10k_ce_ring *dest_ring = ce_state->dest_ring;
 	unsigned int nentries_mask = dest_ring->nentries_mask;
+	struct ath10k *ar = ce_state->ar;
 	unsigned int sw_index = dest_ring->sw_index;
 
 	struct ce_desc *base = dest_ring->base_addr_owner_space;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index bb4b8f3..5c903e15 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -38,8 +38,13 @@ struct ath10k_ce_pipe;
 
 #define CE_DESC_FLAGS_GATHER         (1 << 0)
 #define CE_DESC_FLAGS_BYTE_SWAP      (1 << 1)
-#define CE_DESC_FLAGS_META_DATA_MASK 0xFFFC
-#define CE_DESC_FLAGS_META_DATA_LSB  2
+
+/* Following desc flags are used in QCA99X0 */
+#define CE_DESC_FLAGS_HOST_INT_DIS	(1 << 2)
+#define CE_DESC_FLAGS_TGT_INT_DIS	(1 << 3)
+
+#define CE_DESC_FLAGS_META_DATA_MASK ar->hw_values->ce_desc_meta_data_mask
+#define CE_DESC_FLAGS_META_DATA_LSB  ar->hw_values->ce_desc_meta_data_lsb
 
 struct ce_desc {
 	__le32 addr;
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index e5fe33d9..1414e1f 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -114,6 +114,8 @@ const struct ath10k_hw_values qca988x_values = {
 	.ce_count			= 8,
 	.msi_assign_ce_max		= 7,
 	.num_target_ce_config_wlan	= 7,
+	.ce_desc_meta_data_mask		= 0xFFFC,
+	.ce_desc_meta_data_lsb		= 2,
 };
 
 const struct ath10k_hw_values qca6174_values = {
@@ -121,6 +123,8 @@ const struct ath10k_hw_values qca6174_values = {
 	.ce_count			= 8,
 	.msi_assign_ce_max		= 7,
 	.num_target_ce_config_wlan	= 7,
+	.ce_desc_meta_data_mask		= 0xFFFC,
+	.ce_desc_meta_data_lsb		= 2,
 };
 
 const struct ath10k_hw_values qca99x0_values = {
@@ -128,6 +132,8 @@ const struct ath10k_hw_values qca99x0_values = {
 	.ce_count			= 12,
 	.msi_assign_ce_max		= 12,
 	.num_target_ce_config_wlan	= 10,
+	.ce_desc_meta_data_mask		= 0xFFF0,
+	.ce_desc_meta_data_lsb		= 4,
 };
 
 void ath10k_hw_fill_survey_time(struct ath10k *ar, struct survey_info *survey,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5819659..35cd8ca 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -195,6 +195,8 @@ struct ath10k_hw_values {
 	u8 ce_count;
 	u8 msi_assign_ce_max;
 	u8 num_target_ce_config_wlan;
+	u16 ce_desc_meta_data_mask;
+	u8 ce_desc_meta_data_lsb;
 };
 
 extern const struct ath10k_hw_values qca988x_values;
-- 
1.9.1

