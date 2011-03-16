Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:38854 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab1CPCmx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 22:42:53 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 5/6] mwifiex: remove htcapinfo command from debugfs
Date: Tue, 15 Mar 2011 19:46:09 -0700
Message-Id: <1300243570-6798-6-git-send-email-bzhao@marvell.com>
In-Reply-To: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
References: <1300243570-6798-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marc Yang <yangyang@marvell.com>

The default setting is 0x4800000
Bit 26: Rx STBC support enabled
Bit 23: Short GI in 20 MHz enabled

Signed-off-by: Marc Yang <yangyang@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c     |   25 -----------
 drivers/net/wireless/mwifiex/README    |   33 --------------
 drivers/net/wireless/mwifiex/debugfs.c |   72 --------------------------------
 drivers/net/wireless/mwifiex/fw.h      |    2 -
 4 files changed, 0 insertions(+), 132 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 156582f..c118669 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -26,31 +26,6 @@
 #include "11n.h"
 
 /*
- * IOCTL request handler to set/get 11n HT capability.
- */
-int mwifiex_set_get_11n_htcap_cfg(struct mwifiex_private *priv, u16 action,
-				  int *htcap_cfg)
-{
-	struct mwifiex_adapter *adapter = priv->adapter;
-
-	if (action == HostCmd_ACT_GEN_SET) {
-		if (((*htcap_cfg & ~IGN_HW_DEV_CAP) &
-		     adapter->hw_dot_11n_dev_cap)
-		    != (*htcap_cfg & ~IGN_HW_DEV_CAP))
-			return -EFAULT;
-		else
-			adapter->usr_dot_11n_dev_cap = *htcap_cfg;
-	} else {
-		*htcap_cfg = adapter->usr_dot_11n_dev_cap;
-	}
-
-	dev_dbg(adapter->dev, "info: usr_dot_11n_dev_cap %#x\n",
-			adapter->usr_dot_11n_dev_cap);
-
-	return 0;
-}
-
-/*
  * IOCTL request handler to set/get AMSDU aggregation control.
  *
  * This function prepares the correct firmware command and
diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 54ef654..c82cbc2 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -497,39 +497,6 @@ httxcfg
         in 40 MHz even 20/40 MHz is enabled in httxcfg.
 
 
-htcapinfo
-        This command is used to configure some of paramters in HTCapInfo IE
-        (such as Short GI, Channel BW, and Green field support)
-
-	echo "<m>" > htcapinfo
-	cat htcapinfo
-
-        where <m>
-        This is a bitmap and should be used as following
-                Bit 29: Green field enable/disable
-                Bit 26: Rx STBC Support enable/disable. (As we support
-                        single spatial stream only 1 bit is used for Rx STBC)
-                Bit 24: Short GI in 40 Mhz enable/disable
-                Bit 23: Short GI in 20 Mhz enable/disable
-                Bit 17: 20/40 Mhz enable disable.
-                Bit  8: Enable/disable 40Mhz Intolarent bit in ht capinfo.
-                        0 will reset this bit and 1 will set this bit in
-                        htcapinfo attached in assoc request.
-                All others are reserved and should be set to 0.
-
-        Setting of any other bits will return error.
-
-        echo "0x1820000" > htcapinfo
-        This will enable Short GI, Channel BW to 20/40 and disable Green field support.
-
-        echo "0x800000" > htcapinfo
-        This will enable Short GI, Channel BW to 20 only, No Rx STBC support and disable Green field support.
-
-        The default value is 0x4800000
-
-        Note:- This command can be issued any time but it will only come to effect from
-        next association. (as HTCapInfo is sent only during Association).
-
 getlog
         This command is used to get the statistics available in the station.
 	Usage:
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 0bcedde..57a9313 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -1134,76 +1134,6 @@ mwifiex_httxcfg_read(struct file *file, char __user *ubuf,
 }
 
 /*
- * Proc htcapinfo file write handler.
- *
- * This function is called when the 'htcapinfo' file is opened for writing
- *
- * This function can be used to set the HT capability information.
- */
-static ssize_t
-mwifiex_htcapinfo_write(struct file *file,
-		    const char __user *ubuf, size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	size_t buf_size = min(count, (size_t) (PAGE_SIZE - 1));
-	int htcap = 0;
-	int ret = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	if (copy_from_user(buf, ubuf, buf_size)) {
-		ret = -EFAULT;
-		goto done;
-	}
-
-	sscanf(buf, "%x", &htcap);
-
-	ret = mwifiex_set_get_11n_htcap_cfg(priv, HostCmd_ACT_GEN_SET, &htcap);
-
-	if (!ret)
-		ret = count;
-
-done:
-	free_page(addr);
-	return ret;
-}
-
-/*
- * Proc htcapinfo file read handler.
- *
- * This function is called when the 'htcapinfo' file is opened for reading
- *
- * This function can be used to get the HT capability information.
- */
-static ssize_t
-mwifiex_htcapinfo_read(struct file *file, char __user *ubuf,
-		   size_t count, loff_t *ppos)
-{
-	struct mwifiex_private *priv =
-		(struct mwifiex_private *) file->private_data;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *) addr;
-	int pos = 0, ret = 0;
-	int htcap = 0;
-
-	if (!buf)
-		return -ENOMEM;
-
-	mwifiex_set_get_11n_htcap_cfg(priv, HostCmd_ACT_GEN_GET, &htcap);
-
-	pos += snprintf(buf, PAGE_SIZE, "%x\n", htcap);
-
-	ret = simple_read_from_buffer(ubuf, count, ppos, buf, pos);
-
-	free_page(addr);
-	return ret;
-}
-
-/*
  * Proc antcfg file write handler.
  *
  * This function is called when the 'antcfg' file is opened for writing
@@ -1787,7 +1717,6 @@ MWIFIEX_DFS_FILE_OPS(mpactrl);
 MWIFIEX_DFS_FILE_OPS(qoscfg);
 MWIFIEX_DFS_FILE_OPS(txratecfg);
 MWIFIEX_DFS_FILE_OPS(httxcfg);
-MWIFIEX_DFS_FILE_OPS(htcapinfo);
 MWIFIEX_DFS_FILE_READ_OPS(getlog);
 MWIFIEX_DFS_FILE_OPS(antcfg);
 MWIFIEX_DFS_FILE_OPS(regrdwr);
@@ -1821,7 +1750,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	MWIFIEX_DFS_ADD_FILE(qoscfg);
 	MWIFIEX_DFS_ADD_FILE(txratecfg);
 	MWIFIEX_DFS_ADD_FILE(httxcfg);
-	MWIFIEX_DFS_ADD_FILE(htcapinfo);
 	MWIFIEX_DFS_ADD_FILE(getlog);
 	MWIFIEX_DFS_ADD_FILE(antcfg);
 	MWIFIEX_DFS_ADD_FILE(regrdwr);
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 859998c..eeb2c07 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -199,10 +199,8 @@ enum MWIFIEX_802_11_WEP_STATUS {
 #define HWSPEC_SHORTGI40_SUPP	 BIT(24)
 #define HWSPEC_SHORTGI20_SUPP	 BIT(23)
 #define HWSPEC_CHANBW40_SUPP	 BIT(17)
-#define CAPINFO_40MHZ_INTOLARENT BIT(8)
 
 #define DEFAULT_11N_CAP_MASK	(HWSPEC_SHORTGI20_SUPP | HWSPEC_RXSTBC_SUPP)
-#define IGN_HW_DEV_CAP		(CAPINFO_40MHZ_INTOLARENT)
 #define ISSUPP_11NENABLED(FwCapInfo) (FwCapInfo & BIT(11))
 #define ISSUPP_MAXAMSDU(Dot11nDevCap) (Dot11nDevCap & BIT(31))
 #define ISSUPP_BEAMFORMING(Dot11nDevCap) (Dot11nDevCap & BIT(30))
-- 
1.7.0.2

