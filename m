Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3747 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933794AbaFTEjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 00:39:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/7] mwifiex: add hscfg to debugfs
Date: Thu, 19 Jun 2014 21:38:56 -0700
Message-ID: <1403239138-3113-5-git-send-email-bzhao@marvell.com> (sfid-20140620_063924_859131_F7108B13)
In-Reply-To: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
References: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Some SDIO controllers do not support MMC_PM_KEEP_POWER properly.
To test host sleep feature without putting the system into sleep
we need to simulate host sleep configuration & handshake between
driver and firmware using customized parameters.
This patch adds hscfg debugfs item, with which user could change
host sleep parameters for debugging.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README      | 30 +++++++++++
 drivers/net/wireless/mwifiex/debugfs.c   | 93 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.h      |  2 +
 drivers/net/wireless/mwifiex/sta_ioctl.c |  4 +-
 4 files changed, 127 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 3b55ce5..831a98f 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -194,6 +194,36 @@ rdeeprom
 	Example:
 		echo "0 20" > rdeeprom      : Read 20 bytes of EEPROM data from offset 0
 
+hscfg
+	This command is used to debug/simulate host sleep feature using
+	different configuration parameters.
+
+	Usage:
+		echo "<condition> [GPIO# [gap]]]" > hscfg
+		cat hscfg
+
+	where the parameters are,
+		<condition>: bit 0 = 1   -- broadcast data
+			     bit 1 = 1   -- unicast data
+			     bit 2 = 1   -- mac event
+			     bit 3 = 1   -- multicast data
+		[GPIO#]: pin number of GPIO used to wakeup the host.
+			 GPIO pin# (e.g. 0-7) or 0xff (interface, e.g. SDIO
+			 will be used instead).
+		[gap]:   the gap in milliseconds between wakeup signal and
+			 wakeup event or 0xff for special setting (host
+			 acknowledge required) when GPIO is used to wakeup host.
+
+	Examples:
+		echo "-1" > hscfg        : Cancel host sleep mode
+		echo "3" > hscfg         : Broadcast and unicast data;
+					   Use GPIO and gap set previously
+		echo "2 3" > hscfg       : Unicast data and GPIO 3;
+					   Use gap set previously
+		echo "2 1 160" > hscfg   : Unicast data, GPIO 1 and gap 160 ms
+		echo "2 1 0xff" > hscfg  : Unicast data, GPIO 1; Wait for host
+					   to ack before sending wakeup event
+
 getlog
         This command is used to get the statistics available in the station.
 	Usage:
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 7b419bb..6a194a9 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -692,6 +692,97 @@ done:
 	return ret;
 }
 
+/* Proc hscfg file write handler
+ * This function can be used to configure the host sleep parameters.
+ */
+static ssize_t
+mwifiex_hscfg_write(struct file *file, const char __user *ubuf,
+		    size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv = (void *)file->private_data;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+	size_t buf_size = min_t(size_t, count, PAGE_SIZE - 1);
+	int ret, arg_num;
+	struct mwifiex_ds_hs_cfg hscfg;
+	int conditions = HS_CFG_COND_DEF;
+	u32 gpio = HS_CFG_GPIO_DEF, gap = HS_CFG_GAP_DEF;
+
+	if (!buf)
+		return -ENOMEM;
+
+	if (copy_from_user(buf, ubuf, buf_size)) {
+		ret = -EFAULT;
+		goto done;
+	}
+
+	arg_num = sscanf(buf, "%d %x %x", &conditions, &gpio, &gap);
+
+	memset(&hscfg, 0, sizeof(struct mwifiex_ds_hs_cfg));
+
+	if (arg_num > 3) {
+		dev_err(priv->adapter->dev, "Too many arguments\n");
+		ret = -EINVAL;
+		goto done;
+	}
+
+	if (arg_num >= 1 && arg_num < 3)
+		mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_GET,
+				      MWIFIEX_SYNC_CMD, &hscfg);
+
+	if (arg_num) {
+		if (conditions == HS_CFG_CANCEL) {
+			mwifiex_cancel_hs(priv, MWIFIEX_ASYNC_CMD);
+			ret = count;
+			goto done;
+		}
+		hscfg.conditions = conditions;
+	}
+	if (arg_num >= 2)
+		hscfg.gpio = gpio;
+	if (arg_num == 3)
+		hscfg.gap = gap;
+
+	hscfg.is_invoke_hostcmd = false;
+	mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_SET,
+			      MWIFIEX_SYNC_CMD, &hscfg);
+
+	mwifiex_enable_hs(priv->adapter);
+	priv->adapter->hs_enabling = false;
+	ret = count;
+done:
+	free_page(addr);
+	return ret;
+}
+
+/* Proc hscfg file read handler
+ * This function can be used to read host sleep configuration
+ * parameters from driver.
+ */
+static ssize_t
+mwifiex_hscfg_read(struct file *file, char __user *ubuf,
+		   size_t count, loff_t *ppos)
+{
+	struct mwifiex_private *priv = (void *)file->private_data;
+	unsigned long addr = get_zeroed_page(GFP_KERNEL);
+	char *buf = (char *)addr;
+	int pos, ret;
+	struct mwifiex_ds_hs_cfg hscfg;
+
+	if (!buf)
+		return -ENOMEM;
+
+	mwifiex_set_hs_params(priv, HostCmd_ACT_GEN_GET,
+			      MWIFIEX_SYNC_CMD, &hscfg);
+
+	pos = snprintf(buf, PAGE_SIZE, "%u 0x%x 0x%x\n", hscfg.conditions,
+		       hscfg.gpio, hscfg.gap);
+
+	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
+
+	free_page(addr);
+	return ret;
+}
 
 #define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
 	if (!debugfs_create_file(#name, 0644, priv->dfs_dev_dir,        \
@@ -725,6 +816,7 @@ MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_READ_OPS(fw_dump);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
 MWIFIEX_DFS_FILE_OPS(rdeeprom);
+MWIFIEX_DFS_FILE_OPS(hscfg);
 
 /*
  * This function creates the debug FS directory structure and the files.
@@ -747,6 +839,7 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
 	MWIFIEX_DFS_ADD_FILE(rdeeprom);
 	MWIFIEX_DFS_ADD_FILE(fw_dump);
+	MWIFIEX_DFS_ADD_FILE(hscfg);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 582a9f9..5e734f9 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -920,6 +920,8 @@ int mwifiex_ret_enh_power_mode(struct mwifiex_private *priv,
 void mwifiex_process_hs_config(struct mwifiex_adapter *adapter);
 void mwifiex_hs_activated_event(struct mwifiex_private *priv,
 					u8 activated);
+int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
+			  int cmd_type, struct mwifiex_ds_hs_cfg *hs_cfg);
 int mwifiex_ret_802_11_hs_cfg(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
 int mwifiex_process_rx_packet(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 2295263..6b9395f 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -389,8 +389,8 @@ done:
  * This function prepares the correct firmware command and
  * issues it.
  */
-static int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
-				 int cmd_type, struct mwifiex_ds_hs_cfg *hs_cfg)
+int mwifiex_set_hs_params(struct mwifiex_private *priv, u16 action,
+			  int cmd_type, struct mwifiex_ds_hs_cfg *hs_cfg)
 
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-- 
1.8.2.3

