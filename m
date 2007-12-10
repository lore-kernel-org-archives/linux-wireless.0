Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXLJPps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:45:48 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 23/48] libertas: Fix up error handling in lbs_setuserscan()
Message-Id: <E1J1kpS-0006ly-8N@shinybook.infradead.org> (sfid-20071210_154551_859860_A95E0D5A)
Date: Mon, 10 Dec 2007 10:45:58 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sat, 8 Dec 2007 00:23:55 +0000

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/debugfs.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 1d881ae..dde0c37 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -292,18 +292,23 @@ static ssize_t lbs_setuserscan(struct file *file,
 	struct lbs_ioctl_user_scan_cfg *scan_cfg;
 	union iwreq_data wrqu;
 	int dur;
-	unsigned long addr = get_zeroed_page(GFP_KERNEL);
-	char *buf = (char *)addr;
+	char *buf = (char *)get_zeroed_page(GFP_KERNEL);
 
-	scan_cfg = kzalloc(sizeof(struct lbs_ioctl_user_scan_cfg), GFP_KERNEL);
-	if (!scan_cfg)
+	if (!buf)
 		return -ENOMEM;
-
+		
 	buf_size = min(count, len - 1);
 	if (copy_from_user(buf, userbuf, buf_size)) {
 		res = -EFAULT;
-		goto out_unlock;
+		goto out_buf;
+	}
+
+	scan_cfg = kzalloc(sizeof(struct lbs_ioctl_user_scan_cfg), GFP_KERNEL);
+	if (!scan_cfg) {
+		res = -ENOMEM;
+		goto out_buf;
 	}
+	res = count;
 
 	scan_cfg->bsstype = LBS_SCAN_BSS_TYPE_ANY;
 
@@ -316,15 +321,19 @@ static ssize_t lbs_setuserscan(struct file *file,
 
 	lbs_scan_networks(priv, scan_cfg, 1);
 	wait_event_interruptible(priv->adapter->cmd_pending,
-				 !priv->adapter->nr_cmd_pending);
+				 priv->adapter->surpriseremoved || !priv->adapter->nr_cmd_pending);
+
+	if (priv->adapter->surpriseremoved)
+		goto out_scan_cfg;
 
 	memset(&wrqu, 0x00, sizeof(union iwreq_data));
 	wireless_send_event(priv->dev, SIOCGIWSCAN, &wrqu, NULL);
 
-out_unlock:
-	free_page(addr);
+ out_scan_cfg:
 	kfree(scan_cfg);
-	return count;
+ out_buf:
+	free_page((unsigned long)buf);
+	return res;
 }
 
 
-- 
1.5.3.4

