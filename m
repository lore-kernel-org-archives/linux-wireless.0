Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51631 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbaLBSL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:58 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so28911504wiv.6
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:57 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/26] iwlwifi: pcie: config regs according to fw tlv
Date: Tue,  2 Dec 2014 20:11:15 +0200
Message-Id: <1417543877-24193-24-git-send-email-egrumbach@gmail.com> (sfid-20141202_191204_954659_54C6C1BE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Sometimes there is a need to configure some registers for
setting some FW properties, such as the FW monitor mode
(internal/external). This patch supports setting this for
PCIe mode.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h  |  7 ++++
 drivers/net/wireless/iwlwifi/mvm/ops.c    |  4 +++
 drivers/net/wireless/iwlwifi/pcie/trans.c | 60 +++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 0289803..028408a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -574,6 +574,9 @@ enum iwl_trans_state {
  * @rx_mpdu_cmd_hdr_size: used for tracing, amount of data before the
  *	start of the 802.11 header in the @rx_mpdu_cmd
  * @dflt_pwr_limit: default power limit fetched from the platform (ACPI)
+ * @dbg_dest_tlv: points to the destination TLV for debug
+ * @dbg_conf_tlv: array of pointers to configuration TLVs for debug
+ * @dbg_dest_reg_num: num of reg_ops in %dbg_dest_tlv
  */
 struct iwl_trans {
 	const struct iwl_trans_ops *ops;
@@ -605,6 +608,10 @@ struct iwl_trans {
 
 	u64 dflt_pwr_limit;
 
+	const struct iwl_fw_dbg_dest_tlv *dbg_dest_tlv;
+	const struct iwl_fw_dbg_conf_tlv *dbg_conf_tlv[FW_DBG_MAX];
+	u8 dbg_dest_reg_num;
+
 	/* pointer to trans specific struct */
 	/*Ensure that this pointer will always be aligned to sizeof pointer */
 	char trans_specific[0] __aligned(sizeof(void *));
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index daad985..97dfba5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -496,6 +496,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	trans->rx_mpdu_cmd = REPLY_RX_MPDU_CMD;
 	trans->rx_mpdu_cmd_hdr_size = sizeof(struct iwl_rx_mpdu_res_start);
+	trans->dbg_dest_tlv = mvm->fw->dbg_dest_tlv;
+	trans->dbg_dest_reg_num = mvm->fw->dbg_dest_reg_num;
+	memcpy(trans->dbg_conf_tlv, mvm->fw->dbg_conf_tlv,
+	       sizeof(trans->dbg_conf_tlv));
 
 	/* set up notification wait support */
 	iwl_notification_wait_init(&mvm->notif_wait);
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index ced3354..71d466c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -756,6 +756,64 @@ static int iwl_pcie_load_cpu_sections(struct iwl_trans *trans,
 	return 0;
 }
 
+static void iwl_pcie_apply_destination(struct iwl_trans *trans)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	const struct iwl_fw_dbg_dest_tlv *dest = trans->dbg_dest_tlv;
+	int i;
+
+	if (dest->version)
+		IWL_ERR(trans,
+			"DBG DEST version is %d - expect issues\n",
+			dest->version);
+
+	IWL_INFO(trans, "Applying debug destination %s\n",
+		 get_fw_dbg_mode_string(dest->monitor_mode));
+
+	if (dest->monitor_mode == EXTERNAL_MODE)
+		iwl_pcie_alloc_fw_monitor(trans);
+	else
+		IWL_WARN(trans, "PCI should have external buffer debug\n");
+
+	for (i = 0; i < trans->dbg_dest_reg_num; i++) {
+		u32 addr = le32_to_cpu(dest->reg_ops[i].addr);
+		u32 val = le32_to_cpu(dest->reg_ops[i].val);
+
+		switch (dest->reg_ops[i].op) {
+		case CSR_ASSIGN:
+			iwl_write32(trans, addr, val);
+			break;
+		case CSR_SETBIT:
+			iwl_set_bit(trans, addr, BIT(val));
+			break;
+		case CSR_CLEARBIT:
+			iwl_clear_bit(trans, addr, BIT(val));
+			break;
+		case PRPH_ASSIGN:
+			iwl_write_prph(trans, addr, val);
+			break;
+		case PRPH_SETBIT:
+			iwl_set_bits_prph(trans, addr, BIT(val));
+			break;
+		case PRPH_CLEARBIT:
+			iwl_clear_bits_prph(trans, addr, BIT(val));
+			break;
+		default:
+			IWL_ERR(trans, "FW debug - unknown OP %d\n",
+				dest->reg_ops[i].op);
+			break;
+		}
+	}
+
+	if (dest->monitor_mode == EXTERNAL_MODE && trans_pcie->fw_mon_size) {
+		iwl_write_prph(trans, le32_to_cpu(dest->base_reg),
+			       trans_pcie->fw_mon_phys >> dest->base_shift);
+		iwl_write_prph(trans, le32_to_cpu(dest->end_reg),
+			       (trans_pcie->fw_mon_phys +
+				trans_pcie->fw_mon_size) >> dest->end_shift);
+	}
+}
+
 static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 				const struct fw_img *image)
 {
@@ -796,6 +854,8 @@ static int iwl_pcie_load_given_ucode(struct iwl_trans *trans,
 				       (trans_pcie->fw_mon_phys +
 					trans_pcie->fw_mon_size) >> 4);
 		}
+	} else if (trans->dbg_dest_tlv) {
+		iwl_pcie_apply_destination(trans);
 	}
 
 	/* release CPU reset */
-- 
1.9.1

