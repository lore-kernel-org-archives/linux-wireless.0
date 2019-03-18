Return-Path: <SRS0=49bh=RV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FEEC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 19:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33BD820685
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Mar 2019 19:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfCRTGK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:06:10 -0400
Received: from mout.gmx.net ([212.227.15.19]:39591 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbfCRTGK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 15:06:10 -0400
Received: from p2520la.lan ([217.250.41.225]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0Lkx9B-1gVFNy1QCz-00aidn; Mon, 18
 Mar 2019 20:05:59 +0100
From:   Tim Schumacher <timschumi@gmx.de>
Cc:     timschumi@gmx.de,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: Check for errors when reading SREV register
Date:   Mon, 18 Mar 2019 20:05:57 +0100
Message-Id: <20190318190557.21599-1-timschumi@gmx.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:cocOPNRNIFWYM+QHizlzTdm2QpnaGOu14cNMCU324yXbaOvcCZh
 cHzIjzxr6XR2jU9OIVJ6D8LHk8wCniNr5l261Zr5MW2UObItx7rGPvyM16x9t66m3gVHPRc
 zLzDOr5Z3Ta4WStuYtL6haQJKwi5TixnWSqCde3kp6+AFoBcoKtKABAyEfbpanriDJQDs0K
 UYIivn1npXDINrHDT/KGw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CRKAgQEkL1E=:omKtUtlsLveC70tGYWeP5a
 XPqX4VWi/XcmzXRPFUrUdGhHiYRqD7t2IHyOZIdPJQ1hPjSHNLpGZvLLutjeqz/aemV3RHY2H
 JS90egpurRYLc4zEOwEjOdLCuF6cYOjbfUSk8TwK98BvIUj07NdmSoIECvbk4e0CCgLM6HTJh
 5tvzIx3Lt/LXngj1932CDUjfH6Y8Gg5poDsWpGRZZRCzz+Eoa2k3/Y5g94nysVlRHQwfGpNTC
 jF6OQhxL0tjbarjzYs+jTxkVvk2GtiPptZtVf28TsKo2I9PIiIFsw+5RXw4D8HreJeAMVFC7U
 1/RdCx7TaUIWnP1toykiretDfr0YESNiUqXMrgLJCXn7MUX+oMDY/CSDCB0+FmwUX7M+HvY2k
 BDnasF42HenYJtBKIoWkwZqljZuPqsGrFfXEGoBNm6lQlHElTFiDhovpXHMpyN/x47EevbUq8
 jZOYN5nMSorUNrp59+G4hkzdyi5+GcBApBWRxOY3otx2/KCCB79TBRexcwgPJ1ryEOxE24mb4
 LZNP2uNrqpoC6Ska2TzqMGTPHiRKcfW6oaNbGdjl7mDyL1rrX96ZUH2QgF3lEYVlr9qKksdwj
 kG3Gf9Q3PERaHXAQS0LIBZssr8TGv1A3tBdeH1n+CcT5Zm9ijSUGRIw4K+w6yBgS/vMQi162q
 1A6fpmeM0PRRloJj0/79qBDB973zFnRpS/ui2kIjrY+OV6D0tfiCbWKGcBcFsIwV6kE9hIsqk
 97e+raTE4bo3NKL+Tfily/rTjsKiYdQSpZAhXUtY18woBgUYBGTHLjHhqVgW69gmfAhWdG6j4
 I7l2CeuRyllA3WrplaTtkOlAilpr6XuaAPbOe9oyjZp9gA8tG47ZrEhqeCUjPKXvWzrNLVENp
 xusvAHY57OH3PuPgyi14dAiY20U+vE6s4YXOZA+JRycDiLynZTiIkvkJCBPdDT
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Right now, if an error is encountered during the SREV register
read (i.e. an EIO in ath9k_regread()), that error code gets
passed all the way to __ath9k_hw_init(), where it is visible
during the "Chip rev not supported" message.

    ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
    ath: phy2: Mac Chip Rev 0x0f.3 is not supported by this driver
    ath: phy2: Unable to initialize hardware; initialization status: -95
    ath: phy2: Unable to initialize hardware; initialization status: -95
    ath9k_htc: Failed to initialize the device

Check for -EIO explicitly in ath9k_hw_read_revisions() and return
a boolean based on the success of the operation. Check for that in
__ath9k_hw_init() and abort with a more debugging-friendly message
if reading the revisions wasn't successful.

    ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
    ath: phy2: Failed to read SREV register
    ath: phy2: Could not read hardware revision
    ath: phy2: Unable to initialize hardware; initialization status: -95
    ath: phy2: Unable to initialize hardware; initialization status: -95
    ath9k_htc: Failed to initialize the device

This helps when debugging by directly showing the first point of
failure and it could prevent possible errors if a 0x0f.3 revision
is ever supported.

Signed-off-by: Tim Schumacher <timschumi@gmx.de>
---
 drivers/net/wireless/ath/ath9k/hw.c | 32 +++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8581d917635a..b6773d613f0c 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -252,8 +252,9 @@ void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 /* Chip Revisions */
 /******************/
 
-static void ath9k_hw_read_revisions(struct ath_hw *ah)
+static bool ath9k_hw_read_revisions(struct ath_hw *ah)
 {
+	u32 srev;
 	u32 val;
 
 	if (ah->get_mac_revision)
@@ -269,25 +270,33 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 			val = REG_READ(ah, AR_SREV);
 			ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
 		}
-		return;
+		return true;
 	case AR9300_DEVID_AR9340:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9340;
-		return;
+		return true;
 	case AR9300_DEVID_QCA955X:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9550;
-		return;
+		return true;
 	case AR9300_DEVID_AR953X:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9531;
-		return;
+		return true;
 	case AR9300_DEVID_QCA956X:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9561;
-		return;
+		return true;
 	}
 
-	val = REG_READ(ah, AR_SREV) & AR_SREV_ID;
+	srev = REG_READ(ah, AR_SREV);
+
+	if (srev == -EIO) {
+		ath_err(ath9k_hw_common(ah),
+			"Failed to read SREV register");
+		return false;
+	}
+
+	val = srev & AR_SREV_ID;
 
 	if (val == 0xFF) {
-		val = REG_READ(ah, AR_SREV);
+		val = srev;
 		ah->hw_version.macVersion =
 			(val & AR_SREV_VERSION2) >> AR_SREV_TYPE2_S;
 		ah->hw_version.macRev = MS(val, AR_SREV_REVISION2);
@@ -306,6 +315,8 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCIE)
 			ah->is_pciexpress = true;
 	}
+
+	return true;
 }
 
 /************************************/
@@ -559,7 +570,10 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	int r = 0;
 
-	ath9k_hw_read_revisions(ah);
+	if (!ath9k_hw_read_revisions(ah)) {
+		ath_err(common, "Could not read hardware revisions");
+		return -EOPNOTSUPP;
+	}
 
 	switch (ah->hw_version.macVersion) {
 	case AR_SREV_VERSION_5416_PCI:
-- 
2.21.0

