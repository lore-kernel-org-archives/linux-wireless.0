Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:26839 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab0CQV1R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 17:27:17 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Mar 2010 14:27:17 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 07/12] ath9k_hw: restrict valid nf readings for AR9271 to -114
Date: Wed, 17 Mar 2010 14:25:20 +0530
Message-ID: <1268816125-16173-8-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1268816125-16173-7-git-send-email-senthilkumar@atheros.com>
References: <1268816125-16173-1-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-2-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-3-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-4-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-5-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-6-git-send-email-senthilkumar@atheros.com>
 <1268816125-16173-7-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith <Sujith.Manoharan@atheros.com>

Noisefloor values read on AR9271 are unreliable if they
are less than -114, set those statically to -116.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 0c3e9c8..e76dd74 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -101,6 +101,10 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 		nf = 0 - ((nf ^ 0x1ff) + 1);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ctl] [chain 0] is %d\n", nf);
+
+	if (AR_SREV_9271(ah) && (nf >= -114))
+		nf = -116;
+
 	nfarray[0] = nf;
 
 	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
@@ -139,6 +143,10 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
 		nf = 0 - ((nf ^ 0x1ff) + 1);
 	ath_print(common, ATH_DBG_CALIBRATE,
 		  "NF calibrated [ext] [chain 0] is %d\n", nf);
+
+	if (AR_SREV_9271(ah) && (nf >= -114))
+		nf = -116;
+
 	nfarray[3] = nf;
 
 	if (!AR_SREV_9285(ah) && !AR_SREV_9271(ah)) {
-- 
1.6.4.2

