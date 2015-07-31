Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1095 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750947AbbGaEnV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 00:43:21 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] iwlwifi: pcie: fix stuck queue detection for sleeping clients
Date: Fri, 31 Jul 2015 07:43:13 +0300
Message-Id: <1438317793-7435-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150731_064323_865436_A79C41E5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7DC508@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7DC508@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The stuck queue detection mechanism allows to detect queues
that are stuck. For sleeping clients, a queue may rightfully
be stuck: if a poor client implementation stays asleep for
more than 10s, then we don't want to trigger recovery flows
because of that client.
In order to cope with this, I added a mechanism that
monitors the state of the client: when a client goes to
sleep, the timer of his queues is frozen. When he wakes up,
the timer is reset to the right value so that if a client
was awake for more than 10s and the queues are stuck, only
then, the recovery flow will kick in.
This is valid only on non-shared queues: A-MPDU queues.

There was a bug in case we Tx to a sleeping client that has
an empty A-MPDU queue: the timer was armed to now + 10s.
This is bad, but pretty harmless.
The problem is that when the client wakes up, the timer is
modified to be now + remainder. But remainder is 0 since the
queue was empty when that client went to sleep...

Fix this by checking the state of the client before playing
with the timer when we add a packet to an empty queue.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 2b86c21..607acb5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1875,8 +1875,19 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	/* start timer if queue currently empty */
 	if (q->read_ptr == q->write_ptr) {
-		if (txq->wd_timeout)
-			mod_timer(&txq->stuck_timer, jiffies + txq->wd_timeout);
+		if (txq->wd_timeout) {
+			/*
+			 * If the TXQ is active, then set the timer, if not,
+			 * set the timer in remainder so that the timer will
+			 * be armed with the right value when the station will
+			 * wake up.
+			 */
+			if (!txq->frozen)
+				mod_timer(&txq->stuck_timer,
+					  jiffies + txq->wd_timeout);
+			else
+				txq->frozen_expiry_remainder = txq->wd_timeout;
+		}
 		IWL_DEBUG_RPM(trans, "Q: %d first tx - take ref\n", q->id);
 		iwl_trans_pcie_ref(trans);
 	}
-- 
2.1.4

