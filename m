Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64842 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759852Ab1D1OXS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 10:23:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 07:22:51 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: <linville@tuxdriver.com>, <lrodriguez@atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [RFC/RFT 1/9] ath9k_hw: make antenna diversity modules chip specific
Date: Thu, 28 Apr 2011 19:52:51 +0530
Message-ID: <1304000579-5784-2-git-send-email-mshajakhan@atheros.com> (sfid-20110428_162321_512717_B5B09877)
In-Reply-To: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

this is necessary to support Antenna diversity and combining in new chip
sets such as AR9485, previously Antenna diversity support is available
only in AR9285

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_mac.c |    2 ++
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/hw-ops.h     |   12 ++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h         |   15 +++++++++++----
 4 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_mac.c b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
index c338efb..106714d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_mac.c
@@ -458,4 +458,6 @@ void ar9002_hw_attach_mac_ops(struct ath_hw *ah)
 	ops->clr11n_aggr = ar9002_hw_clr11n_aggr;
 	ops->set11n_burstduration = ar9002_hw_set11n_burstduration;
 	ops->set_clrdmask = ar9002_hw_set_clrdmask;
+	ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
+	ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 7d68d61..aa2d08a 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -533,7 +533,7 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 	ar9002_hw_set_nf_limits(ah);
 }
 
-void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+void ar9002_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 				   struct ath_hw_antcomb_conf *antconf)
 {
 	u32 regval;
@@ -546,9 +546,9 @@ void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 	antconf->fast_div_bias = (regval & AR_PHY_9285_FAST_DIV_BIAS) >>
 				  AR_PHY_9285_FAST_DIV_BIAS_S;
 }
-EXPORT_SYMBOL(ath9k_hw_antdiv_comb_conf_get);
+EXPORT_SYMBOL(ar9002_hw_antdiv_comb_conf_get);
 
-void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
+void ar9002_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 				   struct ath_hw_antcomb_conf *antconf)
 {
 	u32 regval;
@@ -566,4 +566,4 @@ void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 
 	REG_WRITE(ah, AR_PHY_MULTICHAIN_GAIN_CTL, regval);
 }
-EXPORT_SYMBOL(ath9k_hw_antdiv_comb_conf_set);
+EXPORT_SYMBOL(ar9002_hw_antdiv_comb_conf_set);
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 9dd90a8..199d697 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -127,6 +127,18 @@ static inline void ath9k_hw_set_clrdmask(struct ath_hw *ah, void *ds, bool val)
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
index 6a028bd..48420df 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -628,6 +628,11 @@ struct ath_hw_ops {
 	void (*set11n_burstduration)(struct ath_hw *ah, void *ds,
 				     u32 burstDuration);
 	void (*set_clrdmask)(struct ath_hw *ah, void *ds, bool val);
+	void (*antdiv_comb_conf_get)(struct ath_hw *ah,
+			struct ath_hw_antcomb_conf *antconf);
+	void (*antdiv_comb_conf_set)(struct ath_hw *ah,
+			struct ath_hw_antcomb_conf *antconf);
+
 };
 
 struct ath_nf_limits {
@@ -901,10 +906,6 @@ void ath9k_hw_cfg_output(struct ath_hw *ah, u32 gpio,
 void ath9k_hw_set_gpio(struct ath_hw *ah, u32 gpio, u32 val);
 u32 ath9k_hw_getdefantenna(struct ath_hw *ah);
 void ath9k_hw_setantenna(struct ath_hw *ah, u32 antenna);
-void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
-				   struct ath_hw_antcomb_conf *antconf);
-void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
-				   struct ath_hw_antcomb_conf *antconf);
 
 /* General Operation */
 bool ath9k_hw_wait(struct ath_hw *ah, u32 reg, u32 mask, u32 val, u32 timeout);
@@ -975,6 +976,12 @@ void ar9002_hw_enable_async_fifo(struct ath_hw *ah);
 void ar9002_hw_update_async_fifo(struct ath_hw *ah);
 void ar9002_hw_enable_wep_aggregation(struct ath_hw *ah);
 
+/* Antenna diversity/combining */
+void ar9002_hw_antdiv_comb_conf_get(struct ath_hw *ah,
+				struct ath_hw_antcomb_conf *antconf);
+void ar9002_hw_antdiv_comb_conf_set(struct ath_hw *ah,
+				struct ath_hw_antcomb_conf *antconf);
+
 /*
  * Code specific to AR9003, we stuff these here to avoid callbacks
  * for older families
-- 
1.7.0.4

