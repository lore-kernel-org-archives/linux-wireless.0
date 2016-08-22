Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11997 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754770AbcHVJna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 05:43:30 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 4/4] wil6210: extract firmware version from file header
Date: Mon, 22 Aug 2016 12:42:22 +0300
Message-Id: <1471858942-23766-5-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160822_114337_423800_EC1132B8)
In-Reply-To: <1471858942-23766-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1471858942-23766-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Currently the FW version is taken from the sw_version field
of the FW ready event. This version is based on internal
version control revision and it is difficult to map to actual
FW version.
Fix this by using the actual FW version stored in the FW file
header record.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 28 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/wil6210/fw.h      |  3 +++
 drivers/net/wireless/ath/wil6210/fw_inc.c  |  7 +++++++
 drivers/net/wireless/ath/wil6210/main.c    |  1 +
 drivers/net/wireless/ath/wil6210/netdev.c  |  2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h |  3 ++-
 drivers/net/wireless/ath/wil6210/wmi.c     |  8 ++++----
 7 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index a244a36..5e4058a 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1577,6 +1577,32 @@ static const struct file_operations fops_fw_capabilities = {
 	.llseek		= seq_lseek,
 };
 
+/*---------FW version------------*/
+static int wil_fw_version_debugfs_show(struct seq_file *s, void *data)
+{
+	struct wil6210_priv *wil = s->private;
+
+	if (wil->fw_version[0])
+		seq_printf(s, "%s\n", wil->fw_version);
+	else
+		seq_puts(s, "N/A\n");
+
+	return 0;
+}
+
+static int wil_fw_version_seq_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, wil_fw_version_debugfs_show,
+			   inode->i_private);
+}
+
+static const struct file_operations fops_fw_version = {
+	.open		= wil_fw_version_seq_open,
+	.release	= single_release,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+};
+
 /*----------------*/
 static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
 				       struct dentry *dbg)
@@ -1628,6 +1654,7 @@ static const struct {
 	{"led_cfg",	S_IRUGO | S_IWUSR,	&fops_led_cfg},
 	{"led_blink_time",	S_IRUGO | S_IWUSR,	&fops_led_blink_time},
 	{"fw_capabilities",	S_IRUGO,	&fops_fw_capabilities},
+	{"fw_version",	S_IRUGO,		&fops_fw_version},
 };
 
 static void wil6210_debugfs_init_files(struct wil6210_priv *wil,
@@ -1668,7 +1695,6 @@ static void wil6210_debugfs_init_isr(struct wil6210_priv *wil,
 static const struct dbg_off dbg_wil_off[] = {
 	WIL_FIELD(privacy,	S_IRUGO,		doff_u32),
 	WIL_FIELD(status[0],	S_IRUGO | S_IWUSR,	doff_ulong),
-	WIL_FIELD(fw_version,	S_IRUGO,		doff_u32),
 	WIL_FIELD(hw_version,	S_IRUGO,		doff_x32),
 	WIL_FIELD(recovery_count, S_IRUGO,		doff_u32),
 	WIL_FIELD(ap_isolate,	S_IRUGO,		doff_u32),
diff --git a/drivers/net/wireless/ath/wil6210/fw.h b/drivers/net/wireless/ath/wil6210/fw.h
index c3191c6..2f2b910 100644
--- a/drivers/net/wireless/ath/wil6210/fw.h
+++ b/drivers/net/wireless/ath/wil6210/fw.h
@@ -102,6 +102,9 @@ struct wil_fw_record_verify { /* type == wil_fw_verify */
 /* file header
  * First record of every file
  */
+/* the FW version prefix in the comment */
+#define WIL_FW_VERSION_PREFIX "FW version: "
+#define WIL_FW_VERSION_PREFIX_LEN (sizeof(WIL_FW_VERSION_PREFIX) - 1)
 struct wil_fw_record_file_header {
 	__le32 signature ; /* Wilocity signature */
 	__le32 reserved;
diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index 3860238..8f40eb3 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -223,6 +223,13 @@ static int fw_handle_file_header(struct wil6210_priv *wil, const void *data,
 	wil_hex_dump_fw("", DUMP_PREFIX_OFFSET, 16, 1, d->comment,
 			sizeof(d->comment), true);
 
+	if (!memcmp(d->comment, WIL_FW_VERSION_PREFIX,
+		    WIL_FW_VERSION_PREFIX_LEN))
+		memcpy(wil->fw_version,
+		       d->comment + WIL_FW_VERSION_PREFIX_LEN,
+		       min(sizeof(d->comment) - WIL_FW_VERSION_PREFIX_LEN,
+			   sizeof(wil->fw_version) - 1));
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 7198c86..e7130b5 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -893,6 +893,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 			 WIL_FW2_NAME);
 
 		wil_halt_cpu(wil);
+		memset(wil->fw_version, 0, sizeof(wil->fw_version));
 		/* Loading f/w from the file */
 		rc = wil_request_firmware(wil, WIL_FW_NAME, true);
 		if (rc)
diff --git a/drivers/net/wireless/ath/wil6210/netdev.c b/drivers/net/wireless/ath/wil6210/netdev.c
index 4bc9bb0a..61de5e9 100644
--- a/drivers/net/wireless/ath/wil6210/netdev.c
+++ b/drivers/net/wireless/ath/wil6210/netdev.c
@@ -216,6 +216,8 @@ int wil_if_add(struct wil6210_priv *wil)
 
 	wil_dbg_misc(wil, "entered");
 
+	strlcpy(wiphy->fw_version, wil->fw_version, sizeof(wiphy->fw_version));
+
 	rc = wiphy_register(wiphy);
 	if (rc < 0) {
 		wil_err(wil, "failed to register wiphy, err %d\n", rc);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 979536c..a949cd6 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -17,6 +17,7 @@
 #ifndef __WIL6210_H__
 #define __WIL6210_H__
 
+#include <linux/etherdevice.h>
 #include <linux/netdevice.h>
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
@@ -576,7 +577,7 @@ struct wil6210_priv {
 	struct wireless_dev *wdev;
 	void __iomem *csr;
 	DECLARE_BITMAP(status, wil_status_last);
-	u32 fw_version;
+	u8 fw_version[ETHTOOL_FWVERS_LEN];
 	u32 hw_version;
 	const char *hw_name;
 	DECLARE_BITMAP(hw_capabilities, hw_capability_last);
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 0b109b2..fae4f12 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -312,14 +312,14 @@ static void wmi_evt_ready(struct wil6210_priv *wil, int id, void *d, int len)
 	struct wireless_dev *wdev = wil->wdev;
 	struct wmi_ready_event *evt = d;
 
-	wil->fw_version = le32_to_cpu(evt->sw_version);
 	wil->n_mids = evt->numof_additional_mids;
 
-	wil_info(wil, "FW ver. %d; MAC %pM; %d MID's\n", wil->fw_version,
+	wil_info(wil, "FW ver. %s(SW %d); MAC %pM; %d MID's\n",
+		 wil->fw_version, le32_to_cpu(evt->sw_version),
 		 evt->mac, wil->n_mids);
 	/* ignore MAC address, we already have it from the boot loader */
-	snprintf(wdev->wiphy->fw_version, sizeof(wdev->wiphy->fw_version),
-		 "%d", wil->fw_version);
+	strlcpy(wdev->wiphy->fw_version, wil->fw_version,
+		sizeof(wdev->wiphy->fw_version));
 
 	wil_set_recovery_state(wil, fw_recovery_idle);
 	set_bit(wil_status_fwready, wil->status);
-- 
1.9.1
