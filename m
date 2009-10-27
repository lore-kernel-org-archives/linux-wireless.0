Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbZJ0Q7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 12:59:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/5] ath9k_hw: correct AR_PHY_SPECTRAL_SCAN register offset
Date: Tue, 27 Oct 2009 12:59:36 -0400
Message-Id: <1256662777-20469-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1256662777-20469-1-git-send-email-lrodriguez@atheros.com>
References: <1256662777-20469-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We had 0x9912 but AR_PHY_SPECTRAL_SCAN is 0x9910. By using the
0x9912 we were making the hardware unresponsive. This allows us
to move forward with hardware reset on ar9271 on the ath9k_htc
driver.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c  |    3 ++-
 drivers/net/wireless/ath/ath9k/phy.h |   16 ++++++++++++++--
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index bb540bf..111ff04 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1309,7 +1309,8 @@ static void ath9k_hw_override_ini(struct ath_hw *ah,
 		 * AR9271 1.1
 		 */
 		if (AR_SREV_9271_10(ah)) {
-			val = REG_READ(ah, AR_PHY_SPECTRAL_SCAN) | AR_PHY_SPECTRAL_SCAN_ENABLE;
+			val = REG_READ(ah, AR_PHY_SPECTRAL_SCAN) |
+			      AR_PHY_SPECTRAL_SCAN_ENABLE;
 			REG_WRITE(ah, AR_PHY_SPECTRAL_SCAN, val);
 		}
 		else if (AR_SREV_9271_11(ah))
diff --git a/drivers/net/wireless/ath/ath9k/phy.h b/drivers/net/wireless/ath/ath9k/phy.h
index a9b9a7d..dc145a1 100644
--- a/drivers/net/wireless/ath/ath9k/phy.h
+++ b/drivers/net/wireless/ath/ath9k/phy.h
@@ -192,8 +192,20 @@ void ath9k_hw_decrease_chain_power(struct ath_hw *ah,
 #define AR_PHY_PLL_CTL_44_2133  0xeb
 #define AR_PHY_PLL_CTL_40_2133  0xea
 
-#define AR_PHY_SPECTRAL_SCAN		0x9912
-#define AR_PHY_SPECTRAL_SCAN_ENABLE	0x1
+#define AR_PHY_SPECTRAL_SCAN			0x9910  /* AR9280 spectral scan configuration register */
+#define	AR_PHY_SPECTRAL_SCAN_ENABLE		0x1
+#define AR_PHY_SPECTRAL_SCAN_ENA		0x00000001  /* Enable spectral scan, reg 68, bit 0 */
+#define AR_PHY_SPECTRAL_SCAN_ENA_S		0  /* Enable spectral scan, reg 68, bit 0 */
+#define AR_PHY_SPECTRAL_SCAN_ACTIVE		0x00000002  /* Activate spectral scan reg 68, bit 1*/
+#define AR_PHY_SPECTRAL_SCAN_ACTIVE_S		1  /* Activate spectral scan reg 68, bit 1*/
+#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD		0x000000F0  /* Interval for FFT reports, reg 68, bits 4-7*/
+#define AR_PHY_SPECTRAL_SCAN_FFT_PERIOD_S	4
+#define AR_PHY_SPECTRAL_SCAN_PERIOD		0x0000FF00  /* Interval for FFT reports, reg 68, bits 8-15*/
+#define AR_PHY_SPECTRAL_SCAN_PERIOD_S		8
+#define AR_PHY_SPECTRAL_SCAN_COUNT		0x00FF0000  /* Number of reports, reg 68, bits 16-23*/
+#define AR_PHY_SPECTRAL_SCAN_COUNT_S		16
+#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT	0x01000000  /* Short repeat, reg 68, bit 24*/
+#define AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT_S	24  /* Short repeat, reg 68, bit 24*/
 
 #define AR_PHY_RX_DELAY           0x9914
 #define AR_PHY_SEARCH_START_DELAY 0x9918
-- 
1.6.0.4

