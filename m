Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:56731 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747AbZJICQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 22:16:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] libertas: Check return status of command functions
Date: Thu,  8 Oct 2009 19:38:45 -0700
Message-Id: <1255055925-2013-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Return status of lbs_prepare_and_send_command and lbs_cmd_with_response
functions is not checked at some places. Those checks are added.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/debugfs.c |   27 ++++++++++++++++++---------
 drivers/net/wireless/libertas/main.c    |    2 ++
 drivers/net/wireless/libertas/scan.c    |   11 +++++++----
 drivers/net/wireless/libertas/wext.c    |   10 +++++++---
 4 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
index 893a55c..587b0cb 100644
--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -451,10 +451,12 @@ static ssize_t lbs_rdmac_read(struct file *file, char __user *userbuf,
 				CMD_MAC_REG_ACCESS, 0,
 				CMD_OPTION_WAITFORRSP, 0, &offval);
 	mdelay(10);
-	pos += snprintf(buf+pos, len-pos, "MAC[0x%x] = 0x%08x\n",
+	if (!ret) {
+		pos += snprintf(buf+pos, len-pos, "MAC[0x%x] = 0x%08x\n",
 				priv->mac_offset, priv->offsetvalue.value);
 
-	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	}
 	free_page(addr);
 	return ret;
 }
@@ -514,7 +516,8 @@ static ssize_t lbs_wrmac_write(struct file *file,
 				CMD_OPTION_WAITFORRSP, 0, &offval);
 	mdelay(10);
 
-	res = count;
+	if (!res)
+		res = count;
 out_unlock:
 	free_page(addr);
 	return res;
@@ -539,10 +542,12 @@ static ssize_t lbs_rdbbp_read(struct file *file, char __user *userbuf,
 				CMD_BBP_REG_ACCESS, 0,
 				CMD_OPTION_WAITFORRSP, 0, &offval);
 	mdelay(10);
-	pos += snprintf(buf+pos, len-pos, "BBP[0x%x] = 0x%08x\n",
+	if (!ret) {
+		pos += snprintf(buf+pos, len-pos, "BBP[0x%x] = 0x%08x\n",
 				priv->bbp_offset, priv->offsetvalue.value);
 
-	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	}
 	free_page(addr);
 
 	return ret;
@@ -603,7 +608,8 @@ static ssize_t lbs_wrbbp_write(struct file *file,
 				CMD_OPTION_WAITFORRSP, 0, &offval);
 	mdelay(10);
 
-	res = count;
+	if (!res)
+		res = count;
 out_unlock:
 	free_page(addr);
 	return res;
@@ -628,10 +634,12 @@ static ssize_t lbs_rdrf_read(struct file *file, char __user *userbuf,
 				CMD_RF_REG_ACCESS, 0,
 				CMD_OPTION_WAITFORRSP, 0, &offval);
 	mdelay(10);
-	pos += snprintf(buf+pos, len-pos, "RF[0x%x] = 0x%08x\n",
+	if (!ret) {
+		pos += snprintf(buf+pos, len-pos, "RF[0x%x] = 0x%08x\n",
 				priv->rf_offset, priv->offsetvalue.value);
 
-	ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+		ret = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
+	}
 	free_page(addr);
 
 	return ret;
@@ -692,7 +700,8 @@ static ssize_t lbs_wrrf_write(struct file *file,
 				CMD_OPTION_WAITFORRSP, 0, &offval);
 	mdelay(10);
 
-	res = count;
+	if (!res)
+		res = count;
 out_unlock:
 	free_page(addr);
 	return res;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 3b14fcc..bce752c 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1087,6 +1087,8 @@ static void auto_deepsleep_timer_fn(unsigned long data)
 			ret = lbs_prepare_and_send_command(priv,
 					CMD_802_11_DEEP_SLEEP, 0,
 					0, 0, NULL);
+			if (ret)
+				lbs_pr_err("Enter Deep Sleep command failed\n");
 		}
 	}
 	mod_timer(&priv->auto_deepsleep_timer , jiffies +
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 6c95af3..d8fc2b8 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -1022,9 +1022,12 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
 		return -EAGAIN;
 
 	/* Update RSSI if current BSS is a locally created ad-hoc BSS */
-	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate)
-		lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
-					     CMD_OPTION_WAITFORRSP, 0, NULL);
+	if ((priv->mode == IW_MODE_ADHOC) && priv->adhoccreate) {
+		err = lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
+				CMD_OPTION_WAITFORRSP, 0, NULL);
+		if (err)
+			goto out;
+	}
 
 	mutex_lock(&priv->lock);
 	list_for_each_entry_safe (iter_bss, safe, &priv->network_list, list) {
@@ -1058,7 +1061,7 @@ int lbs_get_scan(struct net_device *dev, struct iw_request_info *info,
 
 	dwrq->length = (ev - extra);
 	dwrq->flags = 0;
-
+out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", err);
 	return err;
 }
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 69dd19b..4594841 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -832,7 +832,7 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 	u32 rssi_qual;
 	u32 tx_qual;
 	u32 quality = 0;
-	int stats_valid = 0;
+	int ret, stats_valid = 0;
 	u8 rssi;
 	u32 tx_retries;
 	struct cmd_ds_802_11_get_log log;
@@ -881,7 +881,9 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 
 	memset(&log, 0, sizeof(log));
 	log.hdr.size = cpu_to_le16(sizeof(log));
-	lbs_cmd_with_response(priv, CMD_802_11_GET_LOG, &log);
+	ret = lbs_cmd_with_response(priv, CMD_802_11_GET_LOG, &log);
+	if (ret)
+		goto out;
 
 	tx_retries = le32_to_cpu(log.retry);
 
@@ -909,8 +911,10 @@ static struct iw_statistics *lbs_get_wireless_stats(struct net_device *dev)
 	stats_valid = 1;
 
 	/* update stats asynchronously for future calls */
-	lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
+	ret = lbs_prepare_and_send_command(priv, CMD_802_11_RSSI, 0,
 					0, 0, NULL);
+	if (ret)
+		lbs_pr_err("RSSI command failed\n");
 out:
 	if (!stats_valid) {
 		priv->wstats.miss.beacon = 0;
-- 
1.5.4.3

