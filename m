Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40646 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab0CMFq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 00:46:58 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 08/12] ath9k_hw: restrict valid nf readings for AR9271 to -114
Date: Sat, 13 Mar 2010 00:46:52 -0500
Message-Id: <1268459216-22372-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
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
1.6.3.3

