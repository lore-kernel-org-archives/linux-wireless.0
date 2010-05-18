Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19731 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab0ERB5x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 21:57:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 18:57:53 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k: Make sure null func frame is acked before going into PS for ar9003
Date: Mon, 17 May 2010 18:57:54 -0700
Message-ID: <1274147876-9228-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing code to handle nullfunc frame completion in
ath_tx_edma_tasklet().

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3db1917..debb62d 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2277,6 +2277,17 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 
 		txok = !(txs.ts_status & ATH9K_TXERR_MASK);
 
+		/*
+		 * Make sure null func frame is acked before configuring
+		 * hw into ps mode.
+		 */
+		if (bf->bf_isnullfunc && txok) {
+			if ((sc->ps_flags & PS_ENABLED))
+				ath9k_enable_ps(sc);
+			else
+				sc->ps_flags |= PS_NULLFUNC_COMPLETED;
+		}
+
 		if (!bf_isampdu(bf)) {
 			bf->bf_retries = txs.ts_longretry;
 			if (txs.ts_status & ATH9K_TXERR_XRETRY)
-- 
1.7.0.4

