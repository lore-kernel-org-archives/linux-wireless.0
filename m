Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30885 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230Ab1EMO7O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 10:59:14 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 07:58:45 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Jouni.Malinen@Atheros.com>, <Vasanth.Thiagarajan@Atheros.com>,
	<Kent.Chuang@Atheros.com>, <Ming-Yi.Lin@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>,
	Gabriel Tseng <Gabriel.Tseng@Atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
Subject: [PATCH 1/9] ath9k_hw: make antenna diversity modules chip specific
Date: Fri, 13 May 2011 20:29:04 +0530
Message-ID: <1305298744-3269-1-git-send-email-mshajakhan@atheros.com> (sfid-20110513_165917_584634_C18B1656)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

this is necessary to support Antenna diversity and combining in new chip
sets such as AR9485, previously Antenna diversity support is available
only in AR9285

Cc: Gabriel Tseng <Gabriel.Tseng@Atheros.com>
Cc: Senthilkumar Balasubramanian <Senthilkumar.Balasubramanian@Atheros.com>
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |   42 ++++++++++++++-------------
 drivers/net/wireless/ath/ath9k/hw-ops.h     |   12 +++++++
 drivers/net/wireless/ath/ath9k/hw.h         |    9 +++--
 3 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 7d68d61..b4a0c1d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -517,23 +517,7 @@ static void ar9002_hw_set_nf_limits(struct ath_hw *ah)
 	}
 }
 
-void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
-{
-	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
-
-	priv_ops->set_rf_regs = NULL;
-	priv_ops->rf_alloc_ext_banks = NULL;
-	priv_ops->rf_free_ext_banks = NULL;
-	priv_ops->rf_set_freq = ar9002_hw_set_channel;
-	priv_ops->spur_mitigate_freq = ar9002_hw_spur_mitigate;
-	priv_ops->olc_init = ar9002_olc_init;
-	priv_ops->compute_pll_control = ar9002_hw_compute_pll_control;
-	priv_ops->do_getnf = ar9002_hw_do_getnf;
-
-	ar9002_hw_set_nf_limits(ah);
-}
-
-void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+static void ar9002_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				   struct ath_hw_antcomb_conf *antconf)
 {
 	u32 regval;
@@ -546,9 +530,8 @@ void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 	antconf->fast_div_bias = (regval & AR_PHY_9285_FAST_DIV_BIAS) >>
 				  AR_PHY_9285_FAST_DIV_BIAS_S;
 }
-EXPORT_SYMBOL(ath9k_hw_antdiv_comb_conf_get);
 
-void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
+static void ar9002_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 				   struct ath_hw_antcomb_conf *antconf)
 {
 	u32 regval;
@@ -566,4 +549,23 @@ void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 
 	REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regval);
 }
-EXPORT_SYMBOL(ath9k_hw_antdiv_comb_conf_set);
+
+void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
+{
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+	struct ath_hw_ops *ops = ath9k_hw_ops(ah);
+
+	priv_ops->set_rf_regs = NULL;
+	priv_ops->rf_alloc_ext_banks = NULL;
+	priv_ops->rf_free_ext_banks = NULL;
+	priv_ops->rf_set_freq = ar9002_hw_set_channel;
+	priv_ops->spur_mitigate_freq = ar9002_hw_spur_mitigate;
+	priv_ops->olc_init = ar9002_olc_init;
+	priv_ops->compute_pll_control = ar9002_hw_compute_pll_control;
+	priv_ops->do_getnf = ar9002_hw_do_getnf;
+
+	ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
+	ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
+
+	ar9002_hw_set_nf_limits(ah);
+}
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 99f8334..8b8f044 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -121,6 +121,18 @@ static inline void ath9k_hw_set_clrdmask(struct ath_hw *ah, void *ds, bool val)
 	ath9k_hw_ops(ah)->set_clrdmask(ah, ds, val);
 }
 
+static inline void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+		struct ath_hw_antcomb_conf *antconf)
+{
+	ath9k_hw_ops(ah)->antdiv_comb_conf_get(ah, antconf);
+}
+
+static inline void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
+		struct ath_hw_antcomb_conf *antconf)
+{
+	ath9k_hw_ops(ah)->antdiv_comb_conf_set(ah, antconf);
+}
+
 /* Private hardware call ops */
 
 /* PHY ops */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index b2248bb..67cca10 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -629,6 +629,11 @@ struct ath_hw_ops {
 	void (*set11n_aggr_last)(struct ath_hw *ah, void *ds);
 	void (*clr11n_aggr)(struct ath_hw *ah, void *ds);
 	void (*set_clrdmask)(struct ath_hw *ah, void *ds, bool val);
+	void (*antdiv_comb_conf_get)(struct ath_hw *ah,
+			struct ath_hw_antcomb_conf *antconf);
+	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
+			struct ath_hw_antcomb_conf *antconf);
+
 };
 
 struct ath_nf_limits {
@@ -904,10 +909,6 @@ void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
 u32 ath9k_hw_getdefantenna(struct ath_hw *ah);
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
-void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
-				   struct ath_hw_antcomb_conf *antconf);
-void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
-				   struct ath_hw_antcomb_conf *antconf);
 
 /* General Operation */
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
-- 
1.7.0.4

