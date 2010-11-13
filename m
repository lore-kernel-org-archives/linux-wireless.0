Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48251 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216Ab0KMBYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 20:24:24 -0500
Received: by gxk23 with SMTP id 23so2185256gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 17:24:23 -0800 (PST)
From: Brian Cavagnolo <brian@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: buytenh@wantstofly.org, Brian Cavagnolo <brian@cozybit.com>
Subject: [PATCH V2 5/7] mwl8k: add API version checking for AP firmware
Date: Fri, 12 Nov 2010 17:23:51 -0800
Message-Id: <1289611433-5119-6-git-send-email-brian@cozybit.com>
In-Reply-To: <1288659351-22313-1-git-send-email-brian@cozybit.com>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AP firmware specifies an API version in the GET_HW_SPEC
command response.  Currently, the driver only supports AP
firmware for the 8366, and only supports API v1.  In the future,
if higher API version firmwares emerge (possibly for different
chips), different ops can be selected based on the reported API
version.

Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
---
 drivers/net/wireless/mwl8k.c |   23 +++++++++++++++++++++--
 1 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index cbf7271..e5b062c 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -101,6 +101,7 @@ struct mwl8k_device_info {
 	char *fw_image_sta;
 	char *fw_image_ap;
 	struct rxd_ops *ap_rxd_ops;
+	u32 fw_api_ap;
 };
 
 struct mwl8k_rx_queue {
@@ -1827,6 +1828,7 @@ struct mwl8k_cmd_get_hw_spec_ap {
 	__le32 wcbbase1;
 	__le32 wcbbase2;
 	__le32 wcbbase3;
+	__le32 fw_api_version;
 } __packed;
 
 static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
@@ -1834,6 +1836,7 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 	struct mwl8k_priv *priv = hw->priv;
 	struct mwl8k_cmd_get_hw_spec_ap *cmd;
 	int rc;
+	u32 api_version;
 
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (cmd == NULL)
@@ -1850,6 +1853,16 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 	if (!rc) {
 		int off;
 
+		api_version = le32_to_cpu(cmd->fw_api_version);
+		if (priv->device_info->fw_api_ap != api_version) {
+			printk(KERN_ERR "%s: Unsupported fw API version for %s."
+			       "  Expected %d got %d.\n", MWL8K_NAME,
+			       priv->device_info->part_name,
+			       priv->device_info->fw_api_ap,
+			       api_version);
+			rc = -EINVAL;
+			goto done;
+		}
 		SET_IEEE80211_PERM_ADDR(hw, cmd->perm_addr);
 		priv->num_mcaddrs = le16_to_cpu(cmd->num_mcaddrs);
 		priv->fw_rev = le32_to_cpu(cmd->fw_rev);
@@ -1877,6 +1890,7 @@ static int mwl8k_cmd_get_hw_spec_ap(struct ieee80211_hw *hw)
 		iowrite32(priv->txq[3].txd_dma, priv->sram + off);
 	}
 
+done:
 	kfree(cmd);
 	return rc;
 }
@@ -3939,6 +3953,10 @@ enum {
 	MWL8366,
 };
 
+#define MWL8K_8366_AP_FW_API 1
+#define _MWL8K_8366_AP_FW(api) "mwl8k/fmimage_8366_ap-" #api ".fw"
+#define MWL8K_8366_AP_FW(api) _MWL8K_8366_AP_FW(api)
+
 static struct mwl8k_device_info mwl8k_info_tbl[] __devinitdata = {
 	[MWL8363] = {
 		.part_name	= "88w8363",
@@ -3954,7 +3972,8 @@ static struct mwl8k_device_info mwl8k_info_tbl[] __devinitdata = {
 		.part_name	= "88w8366",
 		.helper_image	= "mwl8k/helper_8366.fw",
 		.fw_image_sta	= "mwl8k/fmimage_8366.fw",
-		.fw_image_ap	= "mwl8k/fmimage_8366_ap-1.fw",
+		.fw_image_ap	= MWL8K_8366_AP_FW(MWL8K_8366_AP_FW_API),
+		.fw_api_ap	= MWL8K_8366_AP_FW_API,
 		.ap_rxd_ops	= &rxd_8366_ap_ops,
 	},
 };
@@ -3965,7 +3984,7 @@ MODULE_FIRMWARE("mwl8k/helper_8687.fw");
 MODULE_FIRMWARE("mwl8k/fmimage_8687.fw");
 MODULE_FIRMWARE("mwl8k/helper_8366.fw");
 MODULE_FIRMWARE("mwl8k/fmimage_8366.fw");
-MODULE_FIRMWARE("mwl8k/fmimage_8366_ap-1.fw");
+MODULE_FIRMWARE(MWL8K_8366_AP_FW(MWL8K_8366_AP_FW_API));
 
 static DEFINE_PCI_DEVICE_TABLE(mwl8k_pci_id_table) = {
 	{ PCI_VDEVICE(MARVELL, 0x2a0a), .driver_data = MWL8363, },
-- 
1.7.1.1

