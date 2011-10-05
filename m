Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:63060 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab1JEFre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 01:47:34 -0400
Date: Wed, 5 Oct 2011 08:46:37 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: [patch] ath5k: remove some unneeded error handling code
Message-ID: <20111005054637.GA32077@elgon.mountain> (sfid-20111005_074745_066003_67B01259)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

th5k_hw_setup_tx_queue() returns a valid offset into the ah->ah_txq[]
array.  The ah->ah_txq[] and the ah->txqs[] array are the same size.
Both have AR5K_NUM_TX_QUEUES elements.  So this error handling code
will never trigger.

Also it's wrong.  The call to ath5k_hw_release_tx_queue() with a qnum
of AR5K_NUM_TX_QUEUES or more will just trigger a WARN_ON() and
return.  Or if it missed the WARN_ON(), it would just corrupt some
memory and return.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index e9ea38d..b346d04 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -921,12 +921,6 @@ ath5k_txq_setup(struct ath5k_hw *ah,
 		 */
 		return ERR_PTR(qnum);
 	}
-	if (qnum >= ARRAY_SIZE(ah->txqs)) {
-		ATH5K_ERR(ah, "hw qnum %u out of range, max %tu!\n",
-			qnum, ARRAY_SIZE(ah->txqs));
-		ath5k_hw_release_tx_queue(ah, qnum);
-		return ERR_PTR(-EINVAL);
-	}
 	txq = &ah->txqs[qnum];
 	if (!txq->setup) {
 		txq->qnum = qnum;
