Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28014 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab1GANHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 09:07:36 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k: Fix tx throughput drops for AR9003 chips with AES encryption
Date: Fri, 1 Jul 2011 18:37:33 +0530
Message-ID: <1309525653-1368-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110701_150748_004792_455FF114)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While sending aggregated frames in AES, the AR5416 chips
required additional padding b/w subframes. This workaround
is not needed for edma (AR9003 family) chips. With this patch
~4Mbps thoughput improvement was observed in clear environment.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a1fed6c..9283440 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -661,7 +661,8 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 * TODO - this could be improved to be dependent on the rate.
 	 *      The hardware can keep up at lower rates, but not higher rates
 	 */
-	if (fi->keyix != ATH9K_TXKEYIX_INVALID)
+	if ((fi->keyix != ATH9K_TXKEYIX_INVALID) &&
+	    !(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA))
 		ndelim += ATH_AGGR_ENCRYPTDELIM;
 
 	/*
-- 
1.7.6

