Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab3FLOmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 10:42:45 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jake Edge <jake@lwn.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/4] iwlegacy: add il_{stop,wake}_queues_by_reason functions
Date: Wed, 12 Jun 2013 16:44:48 +0200
Message-Id: <1371048290-8015-2-git-send-email-sgruszka@redhat.com> (sfid-20130612_164248_348601_15823C17)
In-Reply-To: <1371048290-8015-1-git-send-email-sgruszka@redhat.com>
References: <1371048290-8015-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add functions that will stop/wake all queues. Make them safe
regarding multiple calls and when some ac are stopped/woke
independently.

Tested-by: Jake Edge <jake@lwn.net>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 67da89b..83f8ed8 100644
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

