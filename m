Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17830 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbbFAMdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 08:33:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t51CUhrw018191
	for <linux-wireless@vger.kernel.org>; Mon, 1 Jun 2015 05:33:13 -0700
Received: from sc-owa.marvell.com ([199.233.58.135])
	by mx0a-0016f401.pphosted.com with ESMTP id 1upunhwk3t-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 05:33:13 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <huxm@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCHv4 06/17] mwifiex: disable CAC upon radar detection event
Date: Mon, 1 Jun 2015 23:32:04 +0530
Message-ID: <1433181735-15712-7-git-send-email-patila@marvell.com> (sfid-20150601_143317_115506_B94C960A)
In-Reply-To: <1433181735-15712-1-git-send-email-patila@marvell.com>
References: <1433181735-15712-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to disable ongoing CAC in FW upon
detecting radar during CAC period.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/11h.c  | 30 ++++++++++++++++++++++++++----
 drivers/net/wireless/mwifiex/main.h |  2 ++
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
index 65cd461..bb2ffd9 100644
--- a/drivers/net/wireless/mwifiex/11h.c
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -161,19 +161,38 @@ int mwifiex_cmd_issue_chan_report_request(struct mwifiex_private *priv,
 	cr_req->chan_desc.chan_width = radar_params->chandef->width;
 	cr_req->msec_dwell_time = cpu_to_le32(radar_params->cac_time_ms);
 
-	mwifiex_dbg(priv->adapter, MSG,
-		    "11h: issuing DFS Radar check for channel=%d\n",
-		    radar_params->chandef->chan->hw_value);
+	if (radar_params->cac_time_ms)
+		mwifiex_dbg(priv->adapter, MSG,
+			    "11h: issuing DFS Radar check for channel=%d\n",
+			    radar_params->chandef->chan->hw_value);
+	else
+		mwifiex_dbg(priv->adapter, MSG, "cancelling CAC\n");
 
 	return 0;
 }
 
+int mwifiex_stop_radar_detection(struct mwifiex_private *priv,
+				 struct cfg80211_chan_def *chandef)
+{
+	struct mwifiex_radar_params radar_params;
+
+	memset(&radar_params, 0, sizeof(struct mwifiex_radar_params));
+	radar_params.chandef = chandef;
+	radar_params.cac_time_ms = 0;
+
+	return mwifiex_send_cmd(priv, HostCmd_CMD_CHAN_REPORT_REQUEST,
+				HostCmd_ACT_GEN_SET, 0, &radar_params, true);
+}
+
 /* This function is to abort ongoing CAC upon stopping AP operations
  * or during unload.
  */
 void mwifiex_abort_cac(struct mwifiex_private *priv)
 {
 	if (priv->wdev.cac_started) {
+		if (mwifiex_stop_radar_detection(priv, &priv->dfs_chandef))
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "failed to stop CAC in FW\n");
 		mwifiex_dbg(priv->adapter, MSG,
 			    "Aborting delayed work for CAC.\n");
 		cancel_delayed_work_sync(&priv->dfs_cac_work);
@@ -245,6 +264,9 @@ int mwifiex_11h_handle_radar_detected(struct mwifiex_private *priv,
 	if (le32_to_cpu(rdr_event->passed)) {
 		mwifiex_dbg(priv->adapter, MSG,
 			    "radar detected; indicating kernel\n");
+		if (mwifiex_stop_radar_detection(priv, &priv->dfs_chandef))
+			mwifiex_dbg(priv->adapter, ERROR,
+				    "Failed to stop CAC in FW\n");
 		cfg80211_radar_event(priv->adapter->wiphy, &priv->dfs_chandef,
 				     GFP_KERNEL);
 		mwifiex_dbg(priv->adapter, MSG, "regdomain: %d\n",
@@ -252,7 +274,7 @@ int mwifiex_11h_handle_radar_detected(struct mwifiex_private *priv,
 		mwifiex_dbg(priv->adapter, MSG, "radar detection type: %d\n",
 			    rdr_event->det_type);
 	} else {
-		mwifiex_dbg(priv->adapter, ERROR,
+		mwifiex_dbg(priv->adapter, MSG,
 			    "false radar detection event!\n");
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5a6c1c7..3ac18c6 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1473,6 +1473,8 @@ mwifiex_clone_skb_for_tx_status(struct mwifiex_private *priv,
 void mwifiex_dfs_cac_work_queue(struct work_struct *work);
 void mwifiex_dfs_chan_sw_work_queue(struct work_struct *work);
 void mwifiex_abort_cac(struct mwifiex_private *priv);
+int mwifiex_stop_radar_detection(struct mwifiex_private *priv,
+				 struct cfg80211_chan_def *chandef);
 int mwifiex_11h_handle_radar_detected(struct mwifiex_private *priv,
 				      struct sk_buff *skb);
 
-- 
1.8.1.4

