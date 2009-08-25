Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33703 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729AbZHYSZ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 14:25:28 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2009 11:25:31 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath5k: fix print on warning on ath5k_hw_to_driver_rix()
Date: Tue, 25 Aug 2009 11:25:28 -0700
Message-ID: <1251224728-7180-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was printing the wrong value on the warning. While at it
lets expand this warning to provide a little more useful
information for debugging such as the band and hardware rate
index when possible and clarify what the warning is actually
printing.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I hit this warning and found it would be more useful with this.
I can't reproduce this right now, but I believe what I did was
suspend at home and resume at the office. Anyway this should
help clear things up.

 drivers/net/wireless/ath/ath5k/base.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 5056410..a4e69c5 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1136,11 +1136,15 @@ ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 
 	/* return base rate on errors */
 	if (WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
-			"hw_rix out of bounds: %x\n", hw_rix))
+		 "hardware rate index out of bounds: %x"
+		 "(band: %s)\n", hw_rix,
+		 sc->curband->band ? "5 GHz" : "2.4 GHz"))
 		return 0;
 
 	rix = sc->rate_idx[sc->curband->band][hw_rix];
-	if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_rix))
+	if (WARN(rix < 0, "invalid driver rate index: %x "
+		 "(hw_rix: %x band: %s)\n", rix, hw_rix,
+		 sc->curband->band ? "5 GHz" : "2.4 GHz"))
 		rix = 0;
 
 	return rix;
-- 
1.6.3.3

