Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35111 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753218AbdBNTKd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 14:10:33 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Chris Blake <chrisrblake93@gmail.com>,
        Gabor Juhos <juhosg@openwrt.org>, stable@vger.kernel.org
Subject: [PATCH] ath9k: use correct OTP register offsets for the AR9340 and AR9550
Date: Tue, 14 Feb 2017 20:10:30 +0100
Message-Id: <20170214191030.31070-1-chunkeey@googlemail.com> (sfid-20170214_201038_006210_4B2AD997)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the OTP register definitions for the AR934x and AR9550
WMAC SoC.

Previously, the ath9k driver was unable to initialize the integrated
WMAC on an Aerohive AP121:

| ath: phy0: timeout (1000 us) on reg 0x30018: 0xbadc0ffe & 0x00000007 != 0x00000004
| ath: phy0: timeout (1000 us) on reg 0x30018: 0xbadc0ffe & 0x00000007 != 0x00000004
| ath: phy0: Unable to initialize hardware; initialization status: -5
| ath9k ar934x_wmac: failed to initialize device
| ath9k: probe of ar934x_wmac failed with error -5

It turns out that the AR9300_OTP_STATUS and AR9300_OTP_DATA
definitions contain a typo.

Cc: Gabor Juhos <juhosg@openwrt.org>
Cc: stable@vger.kernel.org
Fixes: add295a4afbdf5852d0 "ath9k: use correct OTP register offsets for AR9550"
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Chris Blake <chrisrblake93@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index 7dc7205dc877..bd2269c7de6b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -75,13 +75,13 @@
 #define AR9300_OTP_BASE \
 		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x30000 : 0x14000)
 #define AR9300_OTP_STATUS \
-		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x30018 : 0x15f18)
+		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x31018 : 0x15f18)
 #define AR9300_OTP_STATUS_TYPE		0x7
 #define AR9300_OTP_STATUS_VALID		0x4
 #define AR9300_OTP_STATUS_ACCESS_BUSY	0x2
 #define AR9300_OTP_STATUS_SM_BUSY	0x1
 #define AR9300_OTP_READ_DATA \
-		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x3001c : 0x15f1c)
+		((AR_SREV_9340(ah) || AR_SREV_9550(ah)) ? 0x3101c : 0x15f1c)
 
 enum targetPowerHTRates {
 	HT_TARGET_RATE_0_8_16,
-- 
2.11.0
