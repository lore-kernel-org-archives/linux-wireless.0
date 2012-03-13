Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51510 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752720Ab2CMCf4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 22:35:56 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 02/15] mwifiex: rearrange switch statement
Date: Mon, 12 Mar 2012 19:35:09 -0700
Message-Id: <1331606116-32745-3-git-send-email-bzhao@marvell.com> (sfid-20120313_033559_644603_3D149B2B)
In-Reply-To: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
References: <1331606116-32745-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

Fixing coding style by rearranging the switch statement

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  198 ++++++++++++----------------
 1 files changed, 87 insertions(+), 111 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 0d8618a..3f13ff0 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -420,38 +420,34 @@ static int mwifiex_ret_tx_power_cfg(struct mwifiex_private *priv,
 
 	switch (action) {
 	case HostCmd_ACT_GEN_GET:
-		{
-			pg_tlv_hdr =
-				(struct mwifiex_types_power_group *) ((u8 *)
-						txp_cfg +
-						sizeof
-						(struct
-						 host_cmd_ds_txpwr_cfg));
-			pg = (struct mwifiex_power_group *) ((u8 *)
-						pg_tlv_hdr +
-						sizeof(struct
-						mwifiex_types_power_group));
-			if (adapter->hw_status ==
-			    MWIFIEX_HW_STATUS_INITIALIZING)
-				mwifiex_get_power_level(priv, txp_cfg);
-			priv->tx_power_level = (u16) pg->power_min;
-			break;
-		}
+		pg_tlv_hdr = (struct mwifiex_types_power_group *)
+			((u8 *) txp_cfg +
+			 sizeof(struct host_cmd_ds_txpwr_cfg));
+
+		pg = (struct mwifiex_power_group *)
+			((u8 *) pg_tlv_hdr +
+			 sizeof(struct mwifiex_types_power_group));
+
+		if (adapter->hw_status == MWIFIEX_HW_STATUS_INITIALIZING)
+			mwifiex_get_power_level(priv, txp_cfg);
+
+		priv->tx_power_level = (u16) pg->power_min;
+		break;
+
 	case HostCmd_ACT_GEN_SET:
-		if (le32_to_cpu(txp_cfg->mode)) {
-			pg_tlv_hdr =
-				(struct mwifiex_types_power_group *) ((u8 *)
-						txp_cfg +
-						sizeof
-						(struct
-						 host_cmd_ds_txpwr_cfg));
-			pg = (struct mwifiex_power_group *) ((u8 *) pg_tlv_hdr
-						+
-						sizeof(struct
-						mwifiex_types_power_group));
-			if (pg->power_max == pg->power_min)
-				priv->tx_power_level = (u16) pg->power_min;
-		}
+		if (!le32_to_cpu(txp_cfg->mode))
+			break;
+
+		pg_tlv_hdr = (struct mwifiex_types_power_group *)
+			((u8 *) txp_cfg +
+			 sizeof(struct host_cmd_ds_txpwr_cfg));
+
+		pg = (struct mwifiex_power_group *)
+			((u8 *) pg_tlv_hdr +
+			 sizeof(struct mwifiex_types_power_group));
+
+		if (pg->power_max == pg->power_min)
+			priv->tx_power_level = (u16) pg->power_min;
 		break;
 	default:
 		dev_err(adapter->dev, "CMD_RESP: unknown cmd action %d\n",
@@ -679,90 +675,70 @@ static int mwifiex_ret_reg_access(u16 type, struct host_cmd_ds_command *resp,
 {
 	struct mwifiex_ds_reg_rw *reg_rw;
 	struct mwifiex_ds_read_eeprom *eeprom;
+	union reg {
+		struct host_cmd_ds_mac_reg_access *mac;
+		struct host_cmd_ds_bbp_reg_access *bbp;
+		struct host_cmd_ds_rf_reg_access *rf;
+		struct host_cmd_ds_pmic_reg_access *pmic;
+		struct host_cmd_ds_802_11_eeprom_access *eeprom;
+	} r;
+
+	if (!data_buf)
+		return 0;
 
-	if (data_buf) {
-		reg_rw = data_buf;
-		eeprom = data_buf;
-		switch (type) {
-		case HostCmd_CMD_MAC_REG_ACCESS:
-			{
-				struct host_cmd_ds_mac_reg_access *reg;
-				reg = (struct host_cmd_ds_mac_reg_access *)
-					&resp->params.mac_reg;
-				reg_rw->offset = cpu_to_le32(
-					(u32) le16_to_cpu(reg->offset));
-				reg_rw->value = reg->value;
-				break;
-			}
-		case HostCmd_CMD_BBP_REG_ACCESS:
-			{
-				struct host_cmd_ds_bbp_reg_access *reg;
-				reg = (struct host_cmd_ds_bbp_reg_access *)
-					&resp->params.bbp_reg;
-				reg_rw->offset = cpu_to_le32(
-					(u32) le16_to_cpu(reg->offset));
-				reg_rw->value = cpu_to_le32((u32) reg->value);
-				break;
-			}
+	reg_rw = data_buf;
+	eeprom = data_buf;
+	switch (type) {
+	case HostCmd_CMD_MAC_REG_ACCESS:
+		r.mac = (struct host_cmd_ds_mac_reg_access *)
+			&resp->params.mac_reg;
+		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.mac->offset));
+		reg_rw->value = r.mac->value;
+		break;
+	case HostCmd_CMD_BBP_REG_ACCESS:
+		r.bbp = (struct host_cmd_ds_bbp_reg_access *)
+			&resp->params.bbp_reg;
+		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.bbp->offset));
+		reg_rw->value = cpu_to_le32((u32) r.bbp->value);
+		break;
 
-		case HostCmd_CMD_RF_REG_ACCESS:
-			{
-				struct host_cmd_ds_rf_reg_access *reg;
-				reg = (struct host_cmd_ds_rf_reg_access *)
-					&resp->params.rf_reg;
-				reg_rw->offset = cpu_to_le32(
-					(u32) le16_to_cpu(reg->offset));
-				reg_rw->value = cpu_to_le32((u32) reg->value);
-				break;
-			}
-		case HostCmd_CMD_PMIC_REG_ACCESS:
-			{
-				struct host_cmd_ds_pmic_reg_access *reg;
-				reg = (struct host_cmd_ds_pmic_reg_access *)
-					&resp->params.pmic_reg;
-				reg_rw->offset = cpu_to_le32(
-					(u32) le16_to_cpu(reg->offset));
-				reg_rw->value = cpu_to_le32((u32) reg->value);
-				break;
-			}
-		case HostCmd_CMD_CAU_REG_ACCESS:
-			{
-				struct host_cmd_ds_rf_reg_access *reg;
-				reg = (struct host_cmd_ds_rf_reg_access *)
-					&resp->params.rf_reg;
-				reg_rw->offset = cpu_to_le32(
-					(u32) le16_to_cpu(reg->offset));
-				reg_rw->value = cpu_to_le32((u32) reg->value);
-				break;
-			}
-		case HostCmd_CMD_802_11_EEPROM_ACCESS:
-			{
-				struct host_cmd_ds_802_11_eeprom_access
-					*cmd_eeprom =
-					(struct host_cmd_ds_802_11_eeprom_access
-					 *) &resp->params.eeprom;
-				pr_debug("info: EEPROM read len=%x\n",
-				       cmd_eeprom->byte_count);
-				if (le16_to_cpu(eeprom->byte_count) <
-						le16_to_cpu(
-						cmd_eeprom->byte_count)) {
-					eeprom->byte_count = cpu_to_le16(0);
-					pr_debug("info: EEPROM read "
-							"length is too big\n");
-					return -1;
-				}
-				eeprom->offset = cmd_eeprom->offset;
-				eeprom->byte_count = cmd_eeprom->byte_count;
-				if (le16_to_cpu(eeprom->byte_count) > 0)
-					memcpy(&eeprom->value,
-					       &cmd_eeprom->value,
-					       le16_to_cpu(eeprom->byte_count));
-
-				break;
-			}
-		default:
+	case HostCmd_CMD_RF_REG_ACCESS:
+		r.rf = (struct host_cmd_ds_rf_reg_access *)
+		       &resp->params.rf_reg;
+		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.rf->offset));
+		reg_rw->value = cpu_to_le32((u32) r.bbp->value);
+		break;
+	case HostCmd_CMD_PMIC_REG_ACCESS:
+		r.pmic = (struct host_cmd_ds_pmic_reg_access *)
+			 &resp->params.pmic_reg;
+		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.pmic->offset));
+		reg_rw->value = cpu_to_le32((u32) r.pmic->value);
+		break;
+	case HostCmd_CMD_CAU_REG_ACCESS:
+		r.rf = (struct host_cmd_ds_rf_reg_access *)
+		       &resp->params.rf_reg;
+		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.rf->offset));
+		reg_rw->value = cpu_to_le32((u32) r.rf->value);
+		break;
+	case HostCmd_CMD_802_11_EEPROM_ACCESS:
+		r.eeprom = (struct host_cmd_ds_802_11_eeprom_access *)
+			   &resp->params.eeprom;
+		pr_debug("info: EEPROM read len=%x\n", r.eeprom->byte_count);
+		if (le16_to_cpu(eeprom->byte_count) <
+		    le16_to_cpu(r.eeprom->byte_count)) {
+			eeprom->byte_count = cpu_to_le16(0);
+			pr_debug("info: EEPROM read length is too big\n");
 			return -1;
 		}
+		eeprom->offset = r.eeprom->offset;
+		eeprom->byte_count = r.eeprom->byte_count;
+		if (le16_to_cpu(eeprom->byte_count) > 0)
+			memcpy(&eeprom->value, &r.eeprom->value,
+			       le16_to_cpu(r.eeprom->byte_count));
+
+		break;
+	default:
+		return -1;
 	}
 	return 0;
 }
-- 
1.7.0.2

