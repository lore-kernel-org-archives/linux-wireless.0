Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798Ab3EWMTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 08:19:33 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Jake Edge <jake@lwn.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFT/RFC 1/4] iwlegacy: small refactoring of il_{stop,wake}_queue
Date: Thu, 23 May 2013 14:20:57 +0200
Message-Id: <1369311660-15378-2-git-send-email-sgruszka@redhat.com> (sfid-20130523_141936_359881_056F3B02)
In-Reply-To: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index f8246f2..c6956ea 100644
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

