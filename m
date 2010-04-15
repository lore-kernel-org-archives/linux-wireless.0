Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab0DOVjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 17:39:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3 12/97] ath9k_hw: add a private callback for PLL control computation
Date: Thu, 15 Apr 2010 17:38:17 -0400
Message-Id: <1271367582-992-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
References: <1271367582-992-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PLL control computation used to program the AR_RTC_PLL_CONTROL
register varies between our harware so just add a private callback for it.
AR9003 will use its own callback.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   55 +++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   31 +++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c         |   64 +++------------------------
 drivers/net/wireless/ath/ath9k/hw.h         |    4 ++
 4 files changed, 97 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 982b0d3..9685f4c 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -967,6 +967,54 @@ static void ar5008_set_diversity(struct ath_hw *ah, bool value)
 	REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
 }
 
+static u32 ar9100_hw_compute_pll_control(struct ath_hw *ah,
+					 struct ath9k_channel *chan)
+{
+	if (chan && IS_CHAN_5GHZ(chan))
+		return 0x1450;
+	return 0x1458;
+}
+
+static u32 ar9160_hw_compute_pll_control(struct ath_hw *ah,
+					 struct ath9k_channel *chan)
+{
+	u32 pll;
+
+	pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
+
+	if (chan && IS_CHAN_HALF_RATE(chan))
+		pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
+	else if (chan && IS_CHAN_QUARTER_RATE(chan))
+		pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
+
+	if (chan && IS_CHAN_5GHZ(chan))
+		pll |= SM(0x50, AR_RTC_9160_PLL_DIV);
+	else
+		pll |= SM(0x58, AR_RTC_9160_PLL_DIV);
+
+	return pll;
+}
+
+static u32 ar5008_hw_compute_pll_control(struct ath_hw *ah,
+					 struct ath9k_channel *chan)
+{
+	u32 pll;
+
+	pll = AR_RTC_PLL_REFDIV_5 | AR_RTC_PLL_DIV2;
+
+	if (chan && IS_CHAN_HALF_RATE(chan))
+		pll |= SM(0x1, AR_RTC_PLL_CLKSEL);
+	else if (chan && IS_CHAN_QUARTER_RATE(chan))
+		pll |= SM(0x2, AR_RTC_PLL_CLKSEL);
+
+	if (chan && IS_CHAN_5GHZ(chan))
+		pll |= SM(0xa, AR_RTC_PLL_DIV);
+	else
+		pll |= SM(0xb, AR_RTC_PLL_DIV);
+
+	return pll;
+}
+
 void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -988,4 +1036,11 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->enable_rfkill = ar5008_hw_enable_rfkill;
 	priv_ops->restore_chainmask = ar5008_restore_chainmask;
 	priv_ops->set_diversity = ar5008_set_diversity;
+
+	if (AR_SREV_9100(ah))
+		priv_ops->compute_pll_control = ar9100_hw_compute_pll_control;
+	else if (AR_SREV_9160_10_OR_LATER(ah))
+		priv_ops->compute_pll_control = ar9160_hw_compute_pll_control;
+	else
+		priv_ops->compute_pll_control = ar5008_hw_compute_pll_control;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 29b50ca..87541a8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -437,6 +437,36 @@ static void ar9002_olc_init(struct ath_hw *ah)
 	}
 }
 
+static u32 ar9002_hw_compute_pll_control(struct ath_hw *ah,
+					 struct ath9k_channel *chan)
+{
+	u32 pll;
+
+	pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
+
+	if (chan && IS_CHAN_HALF_RATE(chan))
+		pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
+	else if (chan && IS_CHAN_QUARTER_RATE(chan))
+		pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
+
+	if (chan && IS_CHAN_5GHZ(chan)) {
+		pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
+
+
+		if (AR_SREV_9280_20(ah)) {
+			if (((chan->channel % 20) == 0)
+			    || ((chan->channel % 10) == 0))
+				pll = 0x2850;
+			else
+				pll = 0x142c;
+		}
+	} else {
+		pll |= SM(0x2c, AR_RTC_9160_PLL_DIV);
+	}
+
+	return pll;
+}
+
 void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 {
 	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
@@ -447,4 +477,5 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->rf_set_freq = ar9002_hw_set_channel;
 	priv_ops->spur_mitigate_freq = ar9002_hw_spur_mitigate;
 	priv_ops->olc_init = ar9002_olc_init;
+	priv_ops->compute_pll_control = ar9002_hw_compute_pll_control;
 }
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8aa1684..245e678 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -67,6 +67,12 @@ static bool ath9k_hw_macversion_supported(struct ath_hw *ah)
 	return priv_ops->macversion_supported(ah->hw_version.macVersion);
 }
 
+static u32 ath9k_hw_compute_pll_control(struct ath_hw *ah,
+					struct ath9k_channel *chan)
+{
+	return ath9k_hw_private_ops(ah)->compute_pll_control(ah, chan);
+}
+
 /********************/
 /* Helper Functions */
 /********************/
@@ -1024,64 +1030,8 @@ static void ath9k_hw_init_qos(struct ath_hw *ah)
 static void ath9k_hw_init_pll(struct ath_hw *ah,
 			      struct ath9k_channel *chan)
 {
-	u32 pll;
-
-	if (AR_SREV_9100(ah)) {
-		if (chan && IS_CHAN_5GHZ(chan))
-			pll = 0x1450;
-		else
-			pll = 0x1458;
-	} else {
-		if (AR_SREV_9280_10_OR_LATER(ah)) {
-			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
-
-			if (chan && IS_CHAN_HALF_RATE(chan))
-				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
-			else if (chan && IS_CHAN_QUARTER_RATE(chan))
-				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
-
-			if (chan && IS_CHAN_5GHZ(chan)) {
-				pll |= SM(0x28, AR_RTC_9160_PLL_DIV);
-
-
-				if (AR_SREV_9280_20(ah)) {
-					if (((chan->channel % 20) == 0)
-					    || ((chan->channel % 10) == 0))
-						pll = 0x2850;
-					else
-						pll = 0x142c;
-				}
-			} else {
-				pll |= SM(0x2c, AR_RTC_9160_PLL_DIV);
-			}
-
-		} else if (AR_SREV_9160_10_OR_LATER(ah)) {
-
-			pll = SM(0x5, AR_RTC_9160_PLL_REFDIV);
-
-			if (chan && IS_CHAN_HALF_RATE(chan))
-				pll |= SM(0x1, AR_RTC_9160_PLL_CLKSEL);
-			else if (chan && IS_CHAN_QUARTER_RATE(chan))
-				pll |= SM(0x2, AR_RTC_9160_PLL_CLKSEL);
-
-			if (chan && IS_CHAN_5GHZ(chan))
-				pll |= SM(0x50, AR_RTC_9160_PLL_DIV);
-			else
-				pll |= SM(0x58, AR_RTC_9160_PLL_DIV);
-		} else {
-			pll = AR_RTC_PLL_REFDIV_5 | AR_RTC_PLL_DIV2;
-
-			if (chan && IS_CHAN_HALF_RATE(chan))
-				pll |= SM(0x1, AR_RTC_PLL_CLKSEL);
-			else if (chan && IS_CHAN_QUARTER_RATE(chan))
-				pll |= SM(0x2, AR_RTC_PLL_CLKSEL);
+	u32 pll = ath9k_hw_compute_pll_control(ah, chan);
 
-			if (chan && IS_CHAN_5GHZ(chan))
-				pll |= SM(0xa, AR_RTC_PLL_DIV);
-			else
-				pll |= SM(0xb, AR_RTC_PLL_DIV);
-		}
-	}
 	REG_WRITE(ah, AR_RTC_PLL_CONTROL, pll);
 
 	/* Switch the core clock for ar9271 to 117Mhz */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index d740e9c..79b938b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -454,6 +454,8 @@ struct ath_gen_timer_table {
  * @rf_alloc_ext_banks:
  * @rf_free_ext_banks:
  * @set_rf_regs:
+ * @compute_pll_control: compute the PLL control value to use for
+ *	AR_RTC_PLL_CONTROL for a given channel
  */
 struct ath_hw_private_ops {
 	void (*init_cal_settings)(struct ath_hw *ah);
@@ -483,6 +485,8 @@ struct ath_hw_private_ops {
 	void (*enable_rfkill)(struct ath_hw *ah);
 	void (*restore_chainmask)(struct ath_hw *ah);
 	void (*set_diversity)(struct ath_hw *ah, bool value);
+	u32 (*compute_pll_control)(struct ath_hw *ah,
+				   struct ath9k_channel *chan);
 };
 
 /**
-- 
1.6.3.3

