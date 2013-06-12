Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab3FLOms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 10:42:48 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jake Edge <jake@lwn.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/4] iwlegacy: small refactoring of il_{stop,wake}_queue
Date: Wed, 12 Jun 2013 16:44:47 +0200
Message-Id: <1371048290-8015-1-git-send-email-sgruszka@redhat.com> (sfid-20130612_164250_366861_06BCB80F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tested-by: Jake Edge <jake@lwn.net>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 4caaf52..67da89b 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -2257,6 +2257,19 @@ il_set_swq_id(struct il_tx_queue *txq, u8 ac, u8 hwq)
 }
 
 static inline void
+_il_wake_queue(struct il_priv *il, u8 ac)
+{
+	if (atomic_dec_return(&il->queue_stop_count[ac]) <= 0)
+		ieee80211_wake_queue(il->hw, ac);
+}
+
+static inline void
+_il_stop_queue(struct il_priv *il, u8 ac)
+{
+	if (atomic_inc_return(&il->queue_stop_count[ac]) > 0)
+		ieee80211_stop_queue(il->hw, ac);
+}
+static inline void
 il_wake_queue(struct il_priv *il, struct il_tx_queue *txq)
 {
 	u8 queue = txq->swq_id;
@@ -2264,8 +2277,7 @@ il_wake_queue(struct il_priv *il, struct il_tx_queue *txq)
 	u8 hwq = (queue >> 2) & 0x1f;
 
 	if (test_and_clear_bit(hwq, il->queue_stopped))
-		if (atomic_dec_return(&il->queue_stop_count[ac]) <= 0)
-			ieee80211_wake_queue(il->hw, ac);
+		_il_wake_queue(il, ac);
 }
 
 static inline void
@@ -2276,8 +2288,7 @@ il_stop_queue(struct il_priv *il, struct il_tx_queue *txq)
 	u8 hwq = (queue >> 2) & 0x1f;
 
 	if (!test_and_set_bit(hwq, il->queue_stopped))
-		if (atomic_inc_return(&il->queue_stop_count[ac]) > 0)
-			ieee80211_stop_queue(il->hw, ac);
+		_il_stop_queue(il, ac);
 }
 
 #ifdef ieee80211_stop_queue
-- 
1.7.11.7

