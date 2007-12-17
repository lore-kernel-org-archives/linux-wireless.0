Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31951 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008AbXLQQNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 11:13:33 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 2/8] mac80211: A-MPDU Rx add MLME structures
Date: Mon, 17 Dec 2007 17:57:43 +0200
Message-Id: <11979070782201-git-send-email-ron.rindjunsky@intel.com> (sfid-20071217_161340_386711_73735AB3)
In-Reply-To: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the needed structures to describe the Rx aggregation MLME per STA
new:
 - struct tid_ampdu_rx: TID aggregation information (Rx)
 - struct sta_ampdu_mlme: MLME aggregation information for STA
changed:
 - struct sta_info: ampdu_mlme added to describe A-MPDU MLME per STA,
		    and timer_to_tid added to map timer id into TID

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/sta_info.h |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index e1a4ac1..451b761 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -31,6 +31,51 @@
 #define WLAN_STA_WME BIT(9)
 #define WLAN_STA_WDS BIT(27)
 
+#define STA_TID_NUM 16
+#define ADDBA_RESP_INTERVAL HZ
+
+#define HT_AGG_STATE_INITIATOR_SHIFT	(4)
+
+#define HT_AGG_STATE_REQ_STOP_BA_MSK	BIT(3)
+
+#define HT_AGG_STATE_IDLE		(0x0)
+#define HT_AGG_STATE_OPERATIONAL	(0x7)
+
+/**
+ * struct tid_ampdu_rx - TID aggregation information (Rx).
+ *
+ * @state: TID's state in session state machine.
+ * @dialog_token: dialog token for aggregation session
+ * @ssn: Starting Sequence Number expected to be aggregated.
+ * @buf_size: buffer size for incoming A-MPDUs
+ * @timeout: reset timer value.
+ * @head_seq_num: head sequence number in reordering buffer.
+ * @stored_mpdu_num: number of MPDUs in reordering buffer
+ * @reorder_buf: buffer to reorder incoming aggregated MPDUs
+ * @session_timer: check if peer keeps Tx-ing on the TID (by timeout value)
+ */
+struct tid_ampdu_rx {
+	u8 state;
+	u8 dialog_token;
+	u16 ssn;
+	u16 buf_size;
+	u16 timeout;
+	u16 head_seq_num;
+	u16 stored_mpdu_num;
+	struct sk_buff **reorder_buf;
+	struct timer_list session_timer;
+};
+
+/**
+ * struct sta_ampdu_mlme - STA aggregation information.
+ *
+ * @tid_agg_info_rx: aggregation info for Rx per TID
+ * @ampdu_rx: for locking sections in aggregation Rx flow
+ */
+struct sta_ampdu_mlme {
+	struct tid_ampdu_rx tid_rx[STA_TID_NUM];
+	spinlock_t ampdu_rx;
+};
 
 struct sta_info {
 	struct kref kref;
@@ -101,6 +146,8 @@ struct sta_info {
 
 	struct ieee80211_ht_info ht_info; /* 802.11n HT capabilities
 					     of this STA */
+	struct sta_ampdu_mlme ampdu_mlme;
+	int timer_to_tid[STA_TID_NUM];  /* convert timer id to tid */
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct sta_info_debugfsdentries {
-- 
1.5.3.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

