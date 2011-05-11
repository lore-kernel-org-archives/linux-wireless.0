Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:47302 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab1EKDm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 23:42:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: remove redundant local structures
Date: Tue, 10 May 2011 20:47:35 -0700
Message-Id: <1305085656-12484-1-git-send-email-bzhao@marvell.com> (sfid-20110511_054315_607730_2C8DD2AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Avoid use of local structure in the function if the structure is
already allocated by the caller and the structure pointer is passed.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   28 +++++++++-------------------
 1 files changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 75bca56..d05907d 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1250,11 +1250,9 @@ mwifiex_drv_get_driver_version(struct mwifiex_adapter *adapter, char *version,
 int mwifiex_get_signal_info(struct mwifiex_private *priv,
 			    struct mwifiex_ds_get_signal *signal)
 {
-	struct mwifiex_ds_get_signal info;
 	int status;
 
-	memset(&info, 0, sizeof(struct mwifiex_ds_get_signal));
-	info.selector = ALL_RSSI_INFO_MASK;
+	signal->selector = ALL_RSSI_INFO_MASK;
 
 	/* Signal info can be obtained only if connected */
 	if (!priv->media_connected) {
@@ -1267,13 +1265,10 @@ int mwifiex_get_signal_info(struct mwifiex_private *priv,
 				       HostCmd_ACT_GEN_GET, 0, signal);
 
 	if (!status) {
-		if (signal)
-			memcpy(signal, &info,
-			       sizeof(struct mwifiex_ds_get_signal));
-		if (info.selector & BCN_RSSI_AVG_MASK)
-			priv->w_stats.qual.level = info.bcn_rssi_avg;
-		if (info.selector & BCN_NF_AVG_MASK)
-			priv->w_stats.qual.noise = info.bcn_nf_avg;
+		if (signal->selector & BCN_RSSI_AVG_MASK)
+			priv->w_stats.qual.level = signal->bcn_rssi_avg;
+		if (signal->selector & BCN_NF_AVG_MASK)
+			priv->w_stats.qual.noise = signal->bcn_nf_avg;
 	}
 
 	return status;
@@ -1333,19 +1328,14 @@ mwifiex_get_stats_info(struct mwifiex_private *priv,
 		       struct mwifiex_ds_get_stats *log)
 {
 	int ret;
-	struct mwifiex_ds_get_stats get_log;
 
-	memset(&get_log, 0, sizeof(struct mwifiex_ds_get_stats));
 	ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_GET_LOG,
-				    HostCmd_ACT_GEN_GET, 0, &get_log);
+				    HostCmd_ACT_GEN_GET, 0, log);
 
 	if (!ret) {
-		if (log)
-			memcpy(log, &get_log, sizeof(struct
-					mwifiex_ds_get_stats));
-		priv->w_stats.discard.fragment = get_log.fcs_error;
-		priv->w_stats.discard.retries = get_log.retry;
-		priv->w_stats.discard.misc = get_log.ack_failure;
+		priv->w_stats.discard.fragment = log->fcs_error;
+		priv->w_stats.discard.retries = log->retry;
+		priv->w_stats.discard.misc = log->ack_failure;
 	}
 
 	return ret;
-- 
1.7.0.2

