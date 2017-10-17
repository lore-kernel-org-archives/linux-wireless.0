Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44320 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755946AbdJQTd7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 15:33:59 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wil6210: remove SSID debugfs
Date: Tue, 17 Oct 2017 21:33:55 +0200
Message-Id: <20171017193355.7351-1-johannes@sipsolutions.net> (sfid-20171017_213402_319952_53C133C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This driver shouldn't be using wdev->ssid to start with, as
it's more or less an internal field in cfg80211 used for
various purposes. Reading it is possible through nl80211,
even if that's not really what we should be doing there
for anything but AP type interfaces.

It *really* shouldn't allow modifying it!

Remove the whole debugfs entry.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 45 ------------------------------
 1 file changed, 45 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 6db00c167d2e..e58dc6dc1f9c 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1048,50 +1048,6 @@ static const struct file_operations fops_bf = {
 	.llseek		= seq_lseek,
 };
 
-/*---------SSID------------*/
-static ssize_t wil_read_file_ssid(struct file *file, char __user *user_buf,
-				  size_t count, loff_t *ppos)
-{
-	struct wil6210_priv *wil = file->private_data;
-	struct wireless_dev *wdev = wil_to_wdev(wil);
-
-	return simple_read_from_buffer(user_buf, count, ppos,
-				       wdev->ssid, wdev->ssid_len);
-}
-
-static ssize_t wil_write_file_ssid(struct file *file, const char __user *buf,
-				   size_t count, loff_t *ppos)
-{
-	struct wil6210_priv *wil = file->private_data;
-	struct wireless_dev *wdev = wil_to_wdev(wil);
-	struct net_device *ndev = wil_to_ndev(wil);
-
-	if (*ppos != 0) {
-		wil_err(wil, "Unable to set SSID substring from [%d]\n",
-			(int)*ppos);
-		return -EINVAL;
-	}
-
-	if (count > sizeof(wdev->ssid)) {
-		wil_err(wil, "SSID too long, len = %d\n", (int)count);
-		return -EINVAL;
-	}
-	if (netif_running(ndev)) {
-		wil_err(wil, "Unable to change SSID on running interface\n");
-		return -EINVAL;
-	}
-
-	wdev->ssid_len = count;
-	return simple_write_to_buffer(wdev->ssid, wdev->ssid_len, ppos,
-				      buf, count);
-}
-
-static const struct file_operations fops_ssid = {
-	.read = wil_read_file_ssid,
-	.write = wil_write_file_ssid,
-	.open  = simple_open,
-};
-
 /*---------temp------------*/
 static void print_temp(struct seq_file *s, const char *prefix, u32 t)
 {
@@ -1695,7 +1651,6 @@ static const struct {
 	{"stations", 0444,		&fops_sta},
 	{"desc",	0444,		&fops_txdesc},
 	{"bf",		0444,		&fops_bf},
-	{"ssid",	0644,		&fops_ssid},
 	{"mem_val",	0644,		&fops_memread},
 	{"reset",	0244,		&fops_reset},
 	{"rxon",	0244,		&fops_rxon},
-- 
2.14.2
