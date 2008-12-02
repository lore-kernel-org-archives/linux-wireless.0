Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56905 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbYLBNLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 08:11:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 05:11:00 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18741.13098.251906.342409@gargle.gargle.HOWL> (sfid-20081202_141105_054498_D0BB4400)
Date: Tue, 2 Dec 2008 18:37:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>, <johannes@sipsolutions.net>
Subject: [PATCH] ath9k: Choose correct ANI calibration period
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ANI can't be turned on/off dynamically yet, but the calculation
of the calibration period is wrong anyway. This patch fixes it.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index c590e9d..8b67708 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -421,8 +421,9 @@ static void ath_ani_calibrate(unsigned long data)
 	* The interval must be the shortest necessary to satisfy ANI,
 	* short calibration and long calibration.
 	*/
-
-	cal_interval = ATH_ANI_POLLINTERVAL;
+	cal_interval = ATH_LONG_CALINTERVAL;
+	if (sc->sc_ah->ah_config.enable_ani)
+		cal_interval = min(cal_interval, (u32)ATH_ANI_POLLINTERVAL);
 	if (!sc->sc_ani.sc_caldone)
 		cal_interval = min(cal_interval, (u32)ATH_SHORT_CALINTERVAL);
 
-- 
1.6.0.3

