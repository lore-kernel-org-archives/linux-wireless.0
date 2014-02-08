Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37650 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706AbaBHA1n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:27:43 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 13/30] mwifiex: handle AMPDU supported check for AP interface
Date: Fri, 7 Feb 2014 16:27:28 -0800
Message-ID: <1391819254-21130-3-git-send-email-bzhao@marvell.com> (sfid-20140208_012746_948331_9910760F)
In-Reply-To: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
References: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch fixes a bug where we were checking for AP's AMPDU param
setting even when transmitting traffic to associated station.
Patch adds provision to pass additional parameter ra_list pointer
to function which checks if AMPDU is allowed. If current BSS type is
AP, we check station's AMPDU params else we check AP's AMPDU params.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.h | 26 ++++++++++++++++++++------
 drivers/net/wireless/mwifiex/wmm.c |  2 +-
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 375db01..353032d 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -64,14 +64,28 @@ int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
 				struct mwifiex_ds_11n_amsdu_aggr_ctrl *aa_ctrl);
 void mwifiex_del_tx_ba_stream_tbl_by_ra(struct mwifiex_private *priv, u8 *ra);
 
-/*
- * This function checks whether AMPDU is allowed or not for a particular TID.
- */
 static inline u8
-mwifiex_is_ampdu_allowed(struct mwifiex_private *priv, int tid)
+mwifiex_is_station_ampdu_allowed(struct mwifiex_private *priv,
+				 struct mwifiex_ra_list_tbl *ptr, int tid)
 {
-	return ((priv->aggr_prio_tbl[tid].ampdu_ap != BA_STREAM_NOT_ALLOWED)
-		? true : false);
+	struct mwifiex_sta_node *node = mwifiex_get_sta_entry(priv, ptr->ra);
+
+	if (unlikely(!node))
+		return false;
+
+	return (node->ampdu_sta[tid] != BA_STREAM_NOT_ALLOWED) ? true : false;
+}
+
+/* This function checks whether AMPDU is allowed or not for a particular TID. */
+static inline u8
+mwifiex_is_ampdu_allowed(struct mwifiex_private *priv,
+			 struct mwifiex_ra_list_tbl *ptr, int tid)
+{
+	if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_UAP)
+		return mwifiex_is_station_ampdu_allowed(priv, ptr, tid);
+	else
+		return (priv->aggr_prio_tbl[tid].ampdu_ap !=
+			BA_STREAM_NOT_ALLOWED) ? true : false;
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 13eaeed..ee44789 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -1226,7 +1226,7 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		/* ra_list_spinlock has been freed in
 		   mwifiex_send_single_packet() */
 	} else {
-		if (mwifiex_is_ampdu_allowed(priv, tid) &&
+		if (mwifiex_is_ampdu_allowed(priv, ptr, tid) &&
 		    ptr->ba_pkt_count > ptr->ba_packet_thr) {
 			if (mwifiex_space_avail_for_new_ba_stream(adapter)) {
 				mwifiex_create_ba_tbl(priv, ptr->ra, tid,
-- 
1.8.2.3

