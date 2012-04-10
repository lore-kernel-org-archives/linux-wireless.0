Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:25447 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab2DJJFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 05:05:31 -0400
Date: Tue, 10 Apr 2012 12:04:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	kernel-janitors@vger.kernel.org
Subject: [RFC] ath9k_hw: precedence bug in ath9k_hw_set_ofdm_nil()
Message-ID: <20120410090445.GB26832@elgon.mountain> (sfid-20120410_110536_783701_2B5D3C80)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was introduced in 54da20d83f "ath9k_hw: improve ANI processing and
rx desensitizing parameters".  It triggers a Smatch complaint because
the "if (!x != y) { ..." formation is a common precedence error.

In this case, maybe the code was intended to be as it is.  The
"->ofdmWeakSigDetectOff" and "->ofdm_weak_signal_on" variables are both
boolean.

Or perhaps based we could change the != to an == and remove the negate?

But normally when I see this formation it is a precedence bug so that's
the patch I've sent.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 47a9fb4..8304e27 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -291,7 +291,7 @@ static void ath9k_hw_set_ofdm_nil(struct ath_hw *ah, u8 immunityLevel)
 				     entry_ofdm->fir_step_level);
 
 	if ((aniState->noiseFloor >= aniState->rssiThrHigh) &&
-	    (!aniState->ofdmWeakSigDetectOff !=
+	    (aniState->ofdmWeakSigDetectOff !=
 	     entry_ofdm->ofdm_weak_signal_on)) {
 			ath9k_hw_ani_control(ah,
 				ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
