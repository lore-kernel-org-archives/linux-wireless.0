Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab2HGBQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 21:16:08 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20512.27655.51108.298733@gargle.gargle.HOWL> (sfid-20120807_032551_914601_7388627E)
Date: Tue, 7 Aug 2012 06:44:47 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC 13/14] ath9k: Remove MIMO-PS specific code
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 2051fac..cce0c51 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1120,15 +1120,6 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 						 rates[i].count);
 			}
 		}
-	} else {
-		/*
-		 * Handle the special case of MIMO PS burst, where the second
-		 * aggregate is sent out with only one rate and one try.
-		 * Treating it as an excessive retry penalizes the rate
-		 * inordinately.
-		 */
-		if (rates[0].count == 1 && xretries == 1)
-			xretries = 2;
 	}
 
 	flags = rates[final_ts_idx].flags;
-- 
1.7.11.4

