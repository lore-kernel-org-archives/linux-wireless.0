Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58938 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab2BPGXD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 01:23:03 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20284.41140.357784.351830@gargle.gargle.HOWL> (sfid-20120216_072308_348652_2569F4EB)
Date: Thu, 16 Feb 2012 11:52:44 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 7/9] ath9k: Initialize NF values properly
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using AR_SREV_* macros for setting up the chip-specific NF
values will make adding support for new chips hard. Use separate
macros for each chip. Currently, AR9462 has the same value for
all NF limits.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   15 +++++++++++----
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |   13 +++++++++----
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2b0bfb8..70e27d2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1099,13 +1099,20 @@ static void ar9003_hw_set_nf_limits(struct ath_hw *ah)
 {
 	ah->nf_2g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ;
 	ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ;
-	if (AR_SREV_9330(ah))
-		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9330_2GHZ;
-	else
-		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9300_2GHZ;
+	ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9300_2GHZ;
 	ah->nf_5g.max = AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ;
 	ah->nf_5g.min = AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ;
 	ah->nf_5g.nominal = AR_PHY_CCA_NOM_VAL_9300_5GHZ;
+
+	if (AR_SREV_9330(ah))
+		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9330_2GHZ;
+
+	if (AR_SREV_9462(ah)) {
+		ah->nf_2g.min = AR_PHY_CCA_MIN_GOOD_VAL_9462_2GHZ;
+		ah->nf_2g.nominal = AR_PHY_CCA_NOM_VAL_9462_2GHZ;
+		ah->nf_5g.min = AR_PHY_CCA_MIN_GOOD_VAL_9462_5GHZ;
+		ah->nf_5g.nominal = AR_PHY_CCA_NOM_VAL_9462_5GHZ;
+	}
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index ed64114..aca24bf 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -325,13 +325,18 @@
 
 #define AR_PHY_RX_OCGAIN        (AR_AGC_BASE + 0x200)
 
-#define AR_PHY_CCA_NOM_VAL_9300_2GHZ          (AR_SREV_9462(ah) ? -127 : -110)
-#define AR_PHY_CCA_NOM_VAL_9300_5GHZ          (AR_SREV_9462(ah) ? -127 : -115)
-#define AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ     (AR_SREV_9462(ah) ? -127 : -125)
-#define AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ     (AR_SREV_9462(ah) ? -127 : -125)
+#define AR_PHY_CCA_NOM_VAL_9300_2GHZ          -110
+#define AR_PHY_CCA_NOM_VAL_9300_5GHZ          -115
+#define AR_PHY_CCA_MIN_GOOD_VAL_9300_2GHZ     -125
+#define AR_PHY_CCA_MIN_GOOD_VAL_9300_5GHZ     -125
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ     -95
 #define AR_PHY_CCA_MAX_GOOD_VAL_9300_5GHZ     -100
 
+#define AR_PHY_CCA_NOM_VAL_9462_2GHZ          -127
+#define AR_PHY_CCA_MIN_GOOD_VAL_9462_2GHZ     -127
+#define AR_PHY_CCA_NOM_VAL_9462_5GHZ          -127
+#define AR_PHY_CCA_MIN_GOOD_VAL_9462_5GHZ     -127
+
 #define AR_PHY_CCA_NOM_VAL_9330_2GHZ          -118
 
 /*
-- 
1.7.9.1

