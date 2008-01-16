Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbYAPSlI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 13:41:08 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC PATCH 02/12 v2] mac80211: A-MPDU Tx add MLME structures
Date: Wed, 16 Jan 2008 20:40:50 +0200
Message-Id: <1200508864189-git-send-email-ron.rindjunsky@intel.com> (sfid-20080116_184113_132575_8F580E72)
In-Reply-To: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
References: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the needed structures to describe the Tx aggregation MLME
per STA
new:
 - struct tid_ampdu_tx: TID aggregation information (Tx)
changed:
 - struct sta_ampdu_mlme: Tx aggregation information per TID and
			  dialog token creator were added
 - struct sta_info: tid_to_tx_q added for tid<->tx queue mapping

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/sta_info.h |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 96fe3ed..48f25f2 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -33,15 +33,36 @@
 
 #define STA_TID_NUM 16
 #define ADDBA_RESP_INTERVAL HZ
+#define HT_AGG_MAX_RETRIES		(0x3)
 
 #define HT_AGG_STATE_INITIATOR_SHIFT	(4)
 
+#define HT_ADDBA_REQUESTED_MSK		BIT(0)
+#define HT_ADDBA_DRV_READY_MSK		BIT(1)
+#define HT_ADDBA_RECEIVED_MSK		BIT(2)
 #define HT_AGG_STATE_REQ_STOP_BA_MSK	BIT(3)
-
+#define HT_AGG_STATE_INITIATOR_MSK      BIT(HT_AGG_STATE_INITIATOR_SHIFT)
 #define HT_AGG_STATE_IDLE		(0x0)
 #define HT_AGG_STATE_OPERATIONAL	(0x7)
 
 /**
+ * struct tid_ampdu_tx - TID aggregation information (Tx).
+ *
+ * @state: TID's state in session state machine.
+ * @dialog_token: dialog token for aggregation session
+ * @ssn: Starting Sequence Number expected to be aggregated.
+ * @addba_resp_timer: timer for peer's response to addba request
+ * @addba_req_num: number of times addBA request has been sent.
+ */
+struct tid_ampdu_tx {
+	u8 state;
+	u8 dialog_token;
+	u16 ssn;
+	struct timer_list addba_resp_timer;
+	u8 addba_req_num;
+};
+
+/**
  * struct tid_ampdu_rx - TID aggregation information (Rx).
  *
  * @state: TID's state in session state machine.
@@ -69,12 +90,18 @@ struct tid_ampdu_rx {
 /**
  * struct sta_ampdu_mlme - STA aggregation information.
  *
- * @tid_agg_info_rx: aggregation info for Rx per TID
+ * @tid_rx: aggregation info for Rx per TID
+ * @tid_tx: aggregation info for Tx per TID
  * @ampdu_rx: for locking sections in aggregation Rx flow
+ * @ampdu_tx: for locking sectionsi in aggregation Tx flow
+ * @dialog_token_allocator: dialog token enumerator for each new session;
  */
 struct sta_ampdu_mlme {
 	struct tid_ampdu_rx tid_rx[STA_TID_NUM];
+	struct tid_ampdu_tx tid_tx[STA_TID_NUM];
 	spinlock_t ampdu_rx;
+	spinlock_t ampdu_tx;
+	u8 dialog_token_allocator;
 };
 
 struct sta_info {
@@ -148,6 +175,7 @@ struct sta_info {
 					     of this STA */
 	struct sta_ampdu_mlme ampdu_mlme;
 	u8 timer_to_tid[STA_TID_NUM];	/* convert timer id to tid */
+	u8 tid_to_tx_q[STA_TID_NUM];	/* map tid to tx queue */
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct sta_info_debugfsdentries {
-- 
1.5.3.3

