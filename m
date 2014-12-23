Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52922 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751976AbaLWIOm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:42 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBN8EGhj007968
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:41 -0800
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rcjut132d-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:41 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<huxm@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/8] mwifiex: add bcn_rcv_cnt and bcn_miss_cnt in getlog debugfs
Date: Tue, 23 Dec 2014 19:14:06 +0530
Message-ID: <1419342252-2702-3-git-send-email-patila@marvell.com> (sfid-20141223_091450_934416_6A6827FA)
In-Reply-To: <1419342252-2702-1-git-send-email-patila@marvell.com>
References: <1419342252-2702-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch add receive beacon count and miss beacon count statistics
in debugfs getlog item.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c     | 10 ++++++++--
 drivers/net/wireless/mwifiex/fw.h          |  2 ++
 drivers/net/wireless/mwifiex/ioctl.h       |  2 ++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  2 ++
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index b506032..3d2fb9a 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -297,6 +297,8 @@ mwifiex_fw_dump_read(struct file *file, char __user *ubuf,
  *      - Number of FCS errors
  *      - Number of Tx frames
  *      - WEP ICV error counts
+ *      - Number of received beacons
+ *      - Number of missed beacons
  */
 static ssize_t
 mwifiex_getlog_read(struct file *file, char __user *ubuf,
@@ -333,7 +335,9 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 		     "wepicverrcnt-1   %u\n"
 		     "wepicverrcnt-2   %u\n"
 		     "wepicverrcnt-3   %u\n"
-		     "wepicverrcnt-4   %u\n",
+		     "wepicverrcnt-4   %u\n"
+		     "bcn_rcv_cnt   %u\n"
+		     "bcn_miss_cnt   %u\n",
 		     stats.mcast_tx_frame,
 		     stats.failed,
 		     stats.retry,
@@ -349,7 +353,9 @@ mwifiex_getlog_read(struct file *file, char __user *ubuf,
 		     stats.wep_icv_error[0],
 		     stats.wep_icv_error[1],
 		     stats.wep_icv_error[2],
-		     stats.wep_icv_error[3]);
+		     stats.wep_icv_error[3],
+		     stats.bcn_rcv_cnt,
+		     stats.bcn_miss_cnt);
 
 
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 9a82323..15ad776 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1077,6 +1077,8 @@ struct host_cmd_ds_802_11_get_log {
 	__le32 tx_frame;
 	__le32 reserved;
 	__le32 wep_icv_err_cnt[4];
+	__le32 bcn_rcv_cnt;
+	__le32 bcn_miss_cnt;
 };
 
 /* Enumeration for rate format */
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index dcf4bdb..d2b05c3 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -137,6 +137,8 @@ struct mwifiex_ds_get_stats {
 	u32 fcs_error;
 	u32 tx_frame;
 	u32 wep_icv_error[4];
+	u32 bcn_rcv_cnt;
+	u32 bcn_miss_cnt;
 };
 
 #define MWIFIEX_MAX_VER_STR_LEN    128
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index b65e101..65d10a3 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -248,6 +248,8 @@ static int mwifiex_ret_get_log(struct mwifiex_private *priv,
 			le32_to_cpu(get_log->wep_icv_err_cnt[2]);
 		stats->wep_icv_error[3] =
 			le32_to_cpu(get_log->wep_icv_err_cnt[3]);
+		stats->bcn_rcv_cnt = le32_to_cpu(get_log->bcn_rcv_cnt);
+		stats->bcn_miss_cnt = le32_to_cpu(get_log->bcn_miss_cnt);
 	}
 
 	return 0;
-- 
1.8.1.4

