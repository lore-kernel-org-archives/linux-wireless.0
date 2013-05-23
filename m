Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356Ab3EWMTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 08:19:47 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jake Edge <jake@lwn.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFT/RFC 2/4] iwlegacy: add il_{stop,wake}_queues_by_reason functions
Date: Thu, 23 May 2013 14:20:58 +0200
Message-Id: <1369311660-15378-3-git-send-email-sgruszka@redhat.com> (sfid-20130523_141949_563263_1ED0C298)
In-Reply-To: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add functions that will stop/wake all queues. Make them safe
regarding multiple calls and when some ac are stopped/woke
independently.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index c6956ea..3c9143e 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1299,6 +1299,8 @@ struct il_priv {
 	/* queue refcounts */
 #define IL_MAX_HW_QUEUES	32
 	unsigned long queue_stopped[BITS_TO_LONGS(IL_MAX_HW_QUEUES)];
+#define IL_STOP_REASON_PASSIVE	0
+	unsigned long stop_reason;
 	/* for each AC */
 	atomic_t queue_stop_count[4];
 
@@ -2291,6 +2293,26 @@ il_stop_queue(struct il_priv *il, struct il_tx_queue *txq)
 		_il_stop_queue(il, ac);
 }
 
+static inline void
+il_wake_queues_by_reason(struct il_priv *il, int reason)
+{
+	u8 ac;
+
+	if (test_and_clear_bit(reason, &il->stop_reason))
+		for (ac = 0; ac < 4; ac++)
+			_il_wake_queue(il, ac);
+}
+
+static inline void
+il_stop_queues_by_reason(struct il_priv *il, int reason)
+{
+	u8 ac;
+
+	if (!test_and_set_bit(reason, &il->stop_reason))
+		for (ac = 0; ac < 4; ac++)
+			_il_stop_queue(il, ac);
+}
+
 #ifdef ieee80211_stop_queue
 #undef ieee80211_stop_queue
 #endif
-- 
1.7.11.7

