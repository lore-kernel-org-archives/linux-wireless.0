Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756529Ab0EaJk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 05:40:27 -0400
Subject: [PATCH] mac80211: move plink state
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 May 2010 11:40:23 +0200
Message-ID: <1275298823.3586.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For some odd reason, the plink_state enum is
declared in the middle between aggregation
related structures. Move it down to make the
file easier to read.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.h |   44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

--- wireless-testing.orig/net/mac80211/sta_info.h	2010-05-31 11:35:53.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.h	2010-05-31 11:39:01.000000000 +0200
@@ -120,6 +120,28 @@ struct tid_ampdu_rx {
 };
 
 /**
+ * struct sta_ampdu_mlme - STA aggregation information.
+ *
+ * @tid_active_rx: TID's state in Rx session state machine.
+ * @tid_rx: aggregation info for Rx per TID
+ * @tid_state_tx: TID's state in Tx session state machine.
+ * @tid_tx: aggregation info for Tx per TID
+ * @addba_req_num: number of times addBA request has been sent.
+ * @dialog_token_allocator: dialog token enumerator for each new session;
+ */
+struct sta_ampdu_mlme {
+	/* rx */
+	bool tid_active_rx[STA_TID_NUM];
+	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
+	/* tx */
+	u8 tid_state_tx[STA_TID_NUM];
+	struct tid_ampdu_tx *tid_tx[STA_TID_NUM];
+	u8 addba_req_num[STA_TID_NUM];
+	u8 dialog_token_allocator;
+};
+
+
+/**
  * enum plink_state - state of a mesh peer link finite state machine
  *
  * @PLINK_LISTEN: initial state, considered the implicit state of non existant
@@ -143,28 +165,6 @@ enum plink_state {
 };
 
 /**
- * struct sta_ampdu_mlme - STA aggregation information.
- *
- * @tid_active_rx: TID's state in Rx session state machine.
- * @tid_rx: aggregation info for Rx per TID
- * @tid_state_tx: TID's state in Tx session state machine.
- * @tid_tx: aggregation info for Tx per TID
- * @addba_req_num: number of times addBA request has been sent.
- * @dialog_token_allocator: dialog token enumerator for each new session;
- */
-struct sta_ampdu_mlme {
-	/* rx */
-	bool tid_active_rx[STA_TID_NUM];
-	struct tid_ampdu_rx *tid_rx[STA_TID_NUM];
-	/* tx */
-	u8 tid_state_tx[STA_TID_NUM];
-	struct tid_ampdu_tx *tid_tx[STA_TID_NUM];
-	u8 addba_req_num[STA_TID_NUM];
-	u8 dialog_token_allocator;
-};
-
-
-/**
  * struct sta_info - STA information
  *
  * This structure collects information about a station that


