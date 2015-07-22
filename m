Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34321 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbbGVInS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 04:43:18 -0400
Received: by wibud3 with SMTP id ud3so143938982wib.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 01:43:17 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@lists.ath9k.org
Cc: ath9k-devel@qca.qualcomm.com, nbd@openwrt.org,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
Date: Wed, 22 Jul 2015 10:42:43 +0200
Message-Id: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com> (sfid-20150722_104338_377097_C16D6D7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The FreeBSD driver [0] uses the same 2G values as for the AR9280 chips.
Using the same values in ath9k results in much better throughput for me.

Before this patch I had a huge amount of packet loss (sometimes up to
40%) and the max transfer speed was somewhere around 5Mbit/s. With this
patch applied I have zero packet loss and ten times the throughput.
My device uses a AR9227 which is the PCI variant of the AR9287.

[0] http://bxr.su/FreeBSD/sys/dev/ath/ath_hal/ar9002/ar9287.h

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Patch has not changed, I am just CC'ing @linux-wireless (instead of
@ath9k-devel only).

 drivers/net/wireless/ath/ath9k/ar9002_phy.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.h b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
index 6314ae2..9d17a53 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.h
@@ -610,8 +610,8 @@
 #define AR_PHY_CCA_MIN_GOOD_VAL_9271_2GHZ      -127
 #define AR_PHY_CCA_MAX_GOOD_VAL_9271_2GHZ      -116
 
-#define AR_PHY_CCA_NOM_VAL_9287_2GHZ           -120
+#define AR_PHY_CCA_NOM_VAL_9287_2GHZ           -112
 #define AR_PHY_CCA_MIN_GOOD_VAL_9287_2GHZ    -127
-#define AR_PHY_CCA_MAX_GOOD_VAL_9287_2GHZ    -110
+#define AR_PHY_CCA_MAX_GOOD_VAL_9287_2GHZ    -97
 
 #endif
-- 
2.4.6

