Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:61318 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZAWFyV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 00:54:21 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 21:54:21 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18809.23231.524650.836747@gargle.gargle.HOWL> (sfid-20090123_065434_586596_D73FDE8C)
Date: Fri, 23 Jan 2009 11:20:55 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/3] ath9k: Fix bug in NF calibration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of chainmasks for AR9285 weren't being
setup when running NF calibration.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/calib.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 8e073d6..39e7a45 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -620,7 +620,9 @@ void ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
 	};
 	u8 chainmask;
 
-	if (AR_SREV_9280(ah))
+	if (AR_SREV_9285(ah))
+		chainmask = 0x9;
+	else if (AR_SREV_9280(ah))
 		chainmask = 0x1B;
 	else
 		chainmask = 0x3F;
-- 
1.6.1

