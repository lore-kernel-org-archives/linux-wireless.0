Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33113 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbbHRRCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 13:02:34 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	dan.carpenter@oracle.com, Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH] staging: wilc1000: Set all options in region debugfs file
Date: Tue, 18 Aug 2015 22:32:17 +0530
Message-Id: <1439917337-18473-1-git-send-email-csgorentla@gmail.com> (sfid-20150818_190253_969638_C2D17F5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows setting all options in the module's debug region
options file 'wilc_debug_region'.  This functionality allows the user
to enable logging from all regions (initialization, locks, firmware
etc.) of the driver.  Logging from the following regions is enabled
during the driver initialization:

INIT_DBG, GENERIC_DBG, CFG80211_DBG, FIRM_DBG and HOSTAPD_DBG

Before this change, the numerical value set is equal first byte of 
input minus 0x30 (ASCII value of '0').  Because of this, after a write 
to this debugfs file, it is difficult to predict the regions on which
logging is enabled.

The DBG_REGION_ALL now includes 3 additional regions TCP_ENH, SPIN_DEBUG
and FIRM_DBG.

Before this change, the region flag FIRM_DBG is enabled during
initialization but cleared after a write to the debugfs file.


Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---

It is verified by code walk that while generating logs for the flags
TCP_ENH and SPIN_DEBUG code does not try to print strings that are not
terminated by NULL and variables do not try to access invalid
memory locations.

 drivers/staging/wilc1000/wilc_debugfs.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index ae11186..70d98ee 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,7 +24,10 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | HOSTINF_DBG | CORECONFIG_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
+#define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | HOSTINF_DBG |	\
+			CORECONFIG_DBG | CFG80211_DBG | INT_DBG |	\
+			TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG |		\
+			BUS_DBG | MEM_DBG | TCP_ENH | SPIN_DEBUG | FIRM_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 atomic_t REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
 atomic_t DEBUG_LEVEL = ATOMIC_INIT(ERR);
@@ -87,23 +90,20 @@ static ssize_t wilc_debug_region_read(struct file *file, char __user *userbuf, s
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 
-static ssize_t wilc_debug_region_write(struct file *filp, const char *buf, size_t count, loff_t *ppos)
+static ssize_t wilc_debug_region_write(struct file *filp,
+					const char __user *buf,
+					size_t count, loff_t *ppos)
 {
-	char buffer[128] = {};
 	int flag;
+	int ret;
 
-	if (count > sizeof(buffer))
-		return -EINVAL;
-
-	if (copy_from_user(buffer, buf, count)) {
-		return -EFAULT;
-	}
-
-	flag = buffer[0] - '0';
+	ret = kstrtouint_from_user(buf, count, 16, &flag);
+	if (ret)
+		return ret;
 
 	if (flag > DBG_REGION_ALL) {
 		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&REGION));
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	atomic_set(&REGION, (int)flag);
-- 
2.5.0

