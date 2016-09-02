Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57672 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751296AbcIBHfg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 03:35:36 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u827YNiv017275
        for <linux-wireless@vger.kernel.org>; Fri, 2 Sep 2016 00:35:35 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 25733crh93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2016 00:35:35 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v5 1/2] mwifiex: add manufacturing mode support
Date: Fri, 2 Sep 2016 13:05:06 +0530
Message-ID: <1472801707-6939-1-git-send-email-akarwar@marvell.com> (sfid-20160902_093540_474886_6A53FC2F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

By default normal mode is chosen when driver is loaded. This
patch adds a provision to choose manufacturing mode via module
parameters.

Below command loads driver in manufacturing mode
insmod mwifiex.ko mfg_mode=1.

Tested-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
v5: Fix format issue and enhance mfg_mode module parameter description
    (Brian Norris).
v4: Removed mfg_firmware module parameter and hardcoded the firmware name
    in driver(Kalle Valo).
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c |  8 ++++++++
 drivers/net/wireless/marvell/mwifiex/init.c   | 22 +++++++++++++++-------
 drivers/net/wireless/marvell/mwifiex/main.c   | 26 ++++++++++++++++++++++----
 drivers/net/wireless/marvell/mwifiex/main.h   |  2 ++
 drivers/net/wireless/marvell/mwifiex/pcie.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/usb.c    |  2 +-
 7 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index d433aa0..5347728 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -595,6 +595,14 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 			return -1;
 		}
 	}
+	/* We don't expect commands in manufacturing mode. They are cooked
+	 * in application and ready to download buffer is passed to the driver
+	 */
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
index db4925d..945275a 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -23,6 +23,7 @@
 #include "11n.h"
 
 #define VERSION	"1.0"
+#define MFG_FIRMWARE	"mwifiex_mfg.bin"
 
 static unsigned int debug_mask = MWIFIEX_DEFAULT_DEBUG_MASK;
 module_param(debug_mask, uint, 0);
@@ -37,6 +38,10 @@ module_param(driver_mode, ushort, 0);
 MODULE_PARM_DESC(driver_mode,
 		 "station=0x1(default), ap-sta=0x3, station-p2p=0x5, ap-sta-p2p=0x7");
 
+bool mfg_mode;
+module_param(mfg_mode, bool, 0);
+MODULE_PARM_DESC(mfg_mode, "manufacturing mode enable:1, disable:0");
+
 /*
  * This function registers the device and performs all the necessary
  * initializations.
@@ -559,10 +564,12 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
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
@@ -666,6 +673,17 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
 {
 	int ret;
 
+	/* Override default firmware with manufacturing one if
+	 * manufacturing mode is enabled
+	 */
+	if (mfg_mode) {
+		if (strlcpy(adapter->fw_name, MFG_FIRMWARE,
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
index 5902600..fcc2af35 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -58,6 +58,7 @@
 #include "sdio.h"
 
 extern const char driver_version[];
+extern bool mfg_mode;
 
 struct mwifiex_adapter;
 struct mwifiex_private;
@@ -990,6 +991,7 @@ struct mwifiex_adapter {
 	u32 drv_info_size;
 	bool scan_chan_gap_enabled;
 	struct sk_buff_head rx_data_q;
+	bool mfg_mode;
 	struct mwifiex_chan_stats *chan_stats;
 	u32 num_in_chan_stats;
 	int survey_idx;
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 453ab6a..a6af85d 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -225,7 +225,7 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
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
index 3bd04f5..9213516 100644
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
