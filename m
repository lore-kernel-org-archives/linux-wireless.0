Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:12568 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753288Ab0CIH4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 02:56:18 -0500
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0428981376
	for <linux-wireless@vger.kernel.org>; Tue,  9 Mar 2010 16:56:16 +0900 (JST)
Subject: [PATCH 12/13] ath5k: IQ calibration for AR5211 is slightly different
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 09 Mar 2010 16:56:15 +0900
Message-ID: <20100309075615.30616.36296.stgit@void>
In-Reply-To: <20100309075124.30616.40896.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

according to the HAL sources the calculation of the Q value is slightly
different for AR5211 chips.

i couldn't test this since IQ calibration never finishes on older parts. this
is a different problem...

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 95cebd6..3a18742 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1399,7 +1399,11 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 	}
 
 	i_coffd = ((i_pwr >> 1) + (q_pwr >> 1)) >> 7;
-	q_coffd = q_pwr >> 7;
+
+	if (ah->ah_version == AR5K_AR5211)
+		q_coffd = q_pwr >> 6;
+	else
+		q_coffd = q_pwr >> 7;
 
 	/* protect against divide by 0 and loss of sign bits */
 	if (i_coffd == 0 || q_coffd < 2)
@@ -1408,7 +1412,10 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 	i_coff = (-iq_corr) / i_coffd;
 	i_coff = clamp(i_coff, -32, 31); /* signed 6 bit */
 
-	q_coff = (i_pwr / q_coffd) - 128;
+	if (ah->ah_version == AR5K_AR5211)
+		q_coff = (i_pwr / q_coffd) - 64;
+	else
+		q_coff = (i_pwr / q_coffd) - 128;
 	q_coff = clamp(q_coff, -16, 15); /* signed 5 bit */
 
 	ATH5K_DBG_UNLIMIT(ah->ah_sc, ATH5K_DEBUG_CALIBRATE,

