Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:32417 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752572Ab0CEGdJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 01:33:09 -0500
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-029126788
	for <linux-wireless@vger.kernel.org>; Fri,  5 Mar 2010 15:33:08 +0900 (JST)
Subject: [PATCH 3/3] ath5k: IQ calibration for AR5211 is slightly different
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: 8an@praha12.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, mickflemm@gmail.com
Date: Fri, 05 Mar 2010 15:33:06 +0900
Message-ID: <20100305063306.29522.89859.stgit@void>
In-Reply-To: <20100305063255.29522.83920.stgit@void>
References: <20100305063255.29522.83920.stgit@void>
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
index 4977d22..b474d51 100644
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
@@ -1412,7 +1416,10 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 	else if (i_coff < -32)
 		i_coff = -32;
 
-	q_coff = (i_pwr / q_coffd) - 128;
+	if (ah->ah_version == AR5K_AR5211)
+		q_coff = (i_pwr / q_coffd) - 64;
+	else
+		q_coff = (i_pwr / q_coffd) - 128;
 	/* Boundary check (signed 5 bit) */
 	if (q_coff > 15)
 		q_coff = 15;

