Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21564 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760288AbYEWCMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 22:12:08 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: add iwl5000_tx_response structure
Date: Fri, 23 May 2008 10:09:26 +0800
Message-Id: <1211508569-3163-49-git-send-email-yi.zhu@intel.com> (sfid-20080523_042833_763013_F1879694)
In-Reply-To: <1211508569-3163-48-git-send-email-yi.zhu@intel.com>
References: <1211508569-3163-1-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-2-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-3-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-4-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-5-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-6-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-7-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-8-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-9-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-10-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-11-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-12-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-13-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-14-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-15-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-16-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-17-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-18-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-19-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-20-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-21-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-22-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-23-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-24-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-25-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-26-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-27-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-28-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-29-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-30-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-31-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-32-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-33-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-34-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-35-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-36-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-37-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-38-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-39-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-40-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-41-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-42-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-43-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-44-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-45-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-46-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-47-git-send-email-yi.zhu@intel.com>
 <1211508569-3163-48-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch adds iwl5000_tx_repsons structure.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   48 ++++++++++++++++++++++++---
 1 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6f62beb..bad0e94 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1419,6 +1419,11 @@ enum {
  *     within the sending station (this 4965), rather than whether it was
  *     received successfully by the destination station.
  */
+struct agg_tx_status {
+	__le16 status;
+	__le16 sequence;
+} __attribute__ ((packed));
+
 struct iwl4965_tx_resp {
 	u8 frame_count;		/* 1 no aggregation, >1 aggregation */
 	u8 bt_kill_count;	/* # blocked by bluetooth (unused for agg) */
@@ -1453,11 +1458,6 @@ struct iwl4965_tx_resp {
 	__le32 status;	/* TX status (for aggregation status of 1st frame) */
 } __attribute__ ((packed));
 
-struct agg_tx_status {
-	__le16 status;
-	__le16 sequence;
-} __attribute__ ((packed));
-
 struct iwl4965_tx_resp_agg {
 	u8 frame_count;         /* 1 no aggregation, >1 aggregation */
 	u8 reserved1;
@@ -1472,6 +1472,44 @@ struct iwl4965_tx_resp_agg {
 					/* of 1st frame) */
 } __attribute__ ((packed));
 
+struct iwl5000_tx_resp {
+	u8 frame_count;		/* 1 no aggregation, >1 aggregation */
+	u8 bt_kill_count;	/* # blocked by bluetooth (unused for agg) */
+	u8 failure_rts;		/* # failures due to unsuccessful RTS */
+	u8 failure_frame;	/* # failures due to no ACK (unused for agg) */
+
+	/* For non-agg:  Rate at which frame was successful.
+	 * For agg:  Rate at which all frames were transmitted. */
+	__le32 rate_n_flags;	/* RATE_MCS_*  */
+
+	/* For non-agg:  RTS + CTS + frame tx attempts time + ACK.
+	 * For agg:  RTS + CTS + aggregation tx time + block-ack time. */
+	__le16 wireless_media_time;	/* uSecs */
+
+	__le16 reserved;
+	__le32 pa_power1;	/* RF power amplifier measurement (not used) */
+	__le32 pa_power2;
+
+	__le32 tfd_info;
+	__le16 seq_ctl;
+	__le16 byte_cnt;
+	__le32 tlc_info;
+	/*
+	 * For non-agg:  frame status TX_STATUS_*
+	 * For agg:  status of 1st frame, AGG_TX_STATE_*; other frame status
+	 *           fields follow this one, up to frame_count.
+	 *           Bit fields:
+	 *           11- 0:  AGG_TX_STATE_* status code
+	 *           15-12:  Retry count for 1st frame in aggregation (retries
+	 *                   occur if tx failed for this frame when it was a
+	 *                   member of a previous aggregation block).  If rate
+	 *                   scaling is used, retry count indicates the rate
+	 *                   table entry used for all frames in the new agg.
+	 *           31-16:  Sequence # for this frame's Tx cmd (not SSN!)
+	 */
+	struct agg_tx_status status;	/* TX status (in aggregation -
+					 * status of 1st frame) */
+} __attribute__ ((packed));
 /*
  * REPLY_COMPRESSED_BA = 0xc5 (response only, not a command)
  *
-- 
1.5.3.6

