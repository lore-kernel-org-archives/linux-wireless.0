Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58613 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbcGMNue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 09:50:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6DDkovb012984
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 06:48:59 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0a-0016f401.pphosted.com with ESMTP id 242xmm7tqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 06:48:59 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v3 1/2] mwifiex: add manufacturing mode support
Date: Wed, 13 Jul 2016 19:18:22 +0530
Message-ID: <1468417703-32716-1-git-send-email-akarwar@marvell.com> (sfid-20160713_155347_860405_29DFD699)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By default normal mode is chosen when driver is loaded. This patch adds
a provision to choose manufacturing mode via module parameters.

Command to load driver in manufacturing mode
insmod mwifiex.ko mfg_mode=1 and mfg_firmware=mrvl/firmware.

Tested-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c |  8 ++++++
 drivers/net/wireless/marvell/mwifiex/init.c   | 22 +++++++++++------
 drivers/net/wireless/marvell/mwifiex/main.c   | 35 ++++++++++++++++++++++++---
 drivers/net/wireless/marvell/mwifiex/main.h   |  4 +++
 drivers/net/wireless/marvell/mwifiex/pcie.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/usb.c    |  2 +-
 7 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index c29f26d..8d57493 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -581,6 +581,14 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 			return -1;
 		}
 	}
+	/* We don't expect commands in manufacturing mode. They are cooked
+	 * in application and ready to download buffer is passed to the driver
+	*/
+	if (adapter->mfg_mode && cmd_no) {
+		dev_dbg(adapter->dev, "Ignoring commands in manufacturing mode\n");
+		return -1;
+	}
+
 
 	/* Get a new command node */
 	cmd_node = mwifiex_get_cmd_node(adapter);
diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 1489c90..82839d9 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -298,6 +298,7 @@ static void mwifiex_init_adapter(struct mwifiex_adapter *adapter)
 	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
 	adapter->arp_filter_size = 0;
 	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
+	adapter->mfg_mode = mfg_mode;
 	adapter->key_api_major_ver = 0;
 	adapter->key_api_minor_ver = 0;
 	eth_broadcast_addr(adapter->perm_addr);
@@ -553,15 +554,22 @@ int mwifiex_init_fw(struct mwifiex_adapter *adapter)
 				return -1;
 		}
 	}
+	if (adapter->mfg_mode) {
+		adapter->hw_status = MWIFIEX_HW_STATUS_READY;
+		ret = -EINPROGRESS;
+	} else {
+		for (i = 0; i < adapter->priv_num; i++) {
+			if (adapter->priv[i]) {
+				ret = mwifiex_sta_init_cmd(adapter->priv[i],
+							   first_sta, true);
+				if (ret == -1)
+					return -1;
+
+				first_sta = false;
+			}
+
 
-	for (i = 0; i < adapter->priv_num; i++) {
-		if (adapter->priv[i]) {
-			ret = mwifiex_sta_init_cmd(adapter->priv[i], first_sta,
-						   true);
-			if (ret == -1)
-				return -1;
 
-			first_sta = false;
 		}
 	}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 0e280f8..b54edf4 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -36,6 +36,14 @@ static unsigned short driver_mode;
 module_param(driver_mode, ushort, 0);
 MODULE_PARM_DESC(driver_mode,
 		 "station=0x1(default), ap-sta=0x3, station-p2p=0x5, ap-sta-p2p=0x7");
+bool mfg_mode;
+module_param(mfg_mode, bool, 0);
+MODULE_PARM_DESC(mfg_mode, "0:disable 1:enable (bool)");
+
+char *mfg_firmware = "";
+module_param(mfg_firmware, charp, 0);
+MODULE_PARM_DESC(mfg_firmware, "firmware path");
+
 
 /*
  * This function registers the device and performs all the necessary
@@ -559,10 +567,12 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 		goto done;
 	}
 	/* Wait for mwifiex_init to complete */
-	wait_event_interruptible(adapter->init_wait_q,
-				 adapter->init_wait_q_woken);
-	if (adapter->hw_status != MWIFIEX_HW_STATUS_READY)
-		goto err_init_fw;
+	if (!adapter->mfg_mode) {
+		wait_event_interruptible(adapter->init_wait_q,
+					 adapter->init_wait_q_woken);
+		if (adapter->hw_status != MWIFIEX_HW_STATUS_READY)
+			goto err_init_fw;
+	}
 
 	priv = adapter->priv[MWIFIEX_BSS_ROLE_STA];
 	if (mwifiex_register_cfg80211(adapter)) {
@@ -666,6 +676,23 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 {
 	int ret;
 
+	if (mfg_mode && !strlen(mfg_firmware)) {
+		pr_err("%s: mfg firmware missing. Ignoring manufacturing mode\n",
+		       __func__);
+		mfg_mode = false;
+	}
+
+	/* Override default firmware with manufacturing one if
+	 * manufacturing mode is enabled
+	 */
+	if (mfg_mode) {
+		if (strlcpy(adapter->fw_name, mfg_firmware,
+			    sizeof(adapter->fw_name)) >=
+			    sizeof(adapter->fw_name)) {
+			pr_err("%s: fw_name too long!\n", __func__);
+			return -1;
+		}
+	}
 	ret = request_firmware_nowait(THIS_MODULE, 1, adapter->fw_name,
 				      adapter->dev, GFP_KERNEL, adapter,
 				      mwifiex_fw_dpc);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 9f6bb40..ee71e4a 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -58,6 +58,9 @@
 #include "sdio.h"
 
 extern const char driver_version[];
+extern bool mfg_mode;
+extern char *mfg_firmware;
+
 
 struct mwifiex_adapter;
 struct mwifiex_private;
@@ -989,6 +992,7 @@ struct mwifiex_adapter {
 	u32 drv_info_size;
 	bool scan_chan_gap_enabled;
 	struct sk_buff_head rx_data_q;
+	bool mfg_mode;
 	struct mwifiex_chan_stats *chan_stats;
 	u32 num_in_chan_stats;
 	int survey_idx;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 22fe993..e54a98a 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -226,7 +226,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	if (!adapter || !adapter->priv_num)
 		return;
 
-	if (user_rmmod) {
+	if (user_rmmod && !adapter->mfg_mode) {
 #ifdef CONFIG_PM_SLEEP
 		if (adapter->is_suspended)
 			mwifiex_pcie_resume(&pdev->dev);
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index d3e1561..6dba409 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -289,7 +289,7 @@ mwifiex_sdio_remove(struct sdio_func *func)
 
 	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
 
-	if (user_rmmod) {
+	if (user_rmmod && !adapter->mfg_mode) {
 		if (adapter->is_suspended)
 			mwifiex_sdio_resume(adapter->dev);
 
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 0857575..ba616ec 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -611,7 +611,7 @@ static void mwifiex_usb_disconnect(struct usb_interface *intf)
 	if (!adapter->priv_num)
 		return;
 
-	if (user_rmmod) {
+	if (user_rmmod && !adapter->mfg_mode) {
 #ifdef CONFIG_PM
 		if (adapter->is_suspended)
 			mwifiex_usb_resume(intf);
-- 
1.9.1

