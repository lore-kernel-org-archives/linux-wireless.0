Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:63367 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932862Ab1JEFsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 01:48:47 -0400
Date: Wed, 5 Oct 2011 08:48:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: [patch] ath9k: remove some bogus error handling code
Message-ID: <20111005054820.GB32077@elgon.mountain> (sfid-20111005_074853_166021_8DEF5618)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If "axq_qnum >= ARRAY_SIZE(sc->tx.txq)", then the call to
ath9k_hw_releasetxqueue() would read beyond the end of the ah->txq[]
array and possibly corrupt memory.  Fortunately,
ath9k_hw_setuptxqueue() doesn't return high values of "axq_qnum" and
this code can be removed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index fa3dcfd..fa1c85d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1255,7 +1255,6 @@ static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_tx_queue_info qi;
 	static const int subtype_txq_to_hwq[] = {
 		[WME_AC_BE] = ATH_TXQ_AC_BE,
@@ -1305,12 +1304,6 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 		 */
 		return NULL;
 	}
-	if (axq_qnum >= ARRAY_SIZE(sc->tx.txq)) {
-		ath_err(common, "qnum %u out of range, max %zu!\n",
-			axq_qnum, ARRAY_SIZE(sc->tx.txq));
-		ath9k_hw_releasetxqueue(ah, axq_qnum);
-		return NULL;
-	}
 	if (!ATH_TXQ_SETUP(sc, axq_qnum)) {
 		struct ath_txq *txq = &sc->tx.txq[axq_qnum];
 
