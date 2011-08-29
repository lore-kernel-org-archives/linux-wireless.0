Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60432 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab1H2Fyd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 01:54:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 3/4] ath9k: only fill antenna diversity hw ops on chips that support it
Date: Mon, 29 Aug 2011 07:54:21 +0200
Message-Id: <1314597262-49427-3-git-send-email-nbd@openwrt.org> (sfid-20110829_075453_193212_561FDC8A)
In-Reply-To: <1314597262-49427-2-git-send-email-nbd@openwrt.org>
References: <1314597262-49427-1-git-send-email-nbd@openwrt.org>
 <1314597262-49427-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    6 ++++--
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    6 ++++--
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 3cbbb03..38e91f8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -570,8 +570,10 @@ void ar9002_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->compute_pll_control = ar9002_hw_compute_pll_control;
 	priv_ops->do_getnf = ar9002_hw_do_getnf;
 
-	ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
-	ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
+	if (AR_SREV_9285(ah)) {
+		ops->antdiv_comb_conf_get = ar9002_hw_antdiv_comb_conf_get;
+		ops->antdiv_comb_conf_set = ar9002_hw_antdiv_comb_conf_set;
+	}
 
 	ar9002_hw_set_nf_limits(ah);
 }
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 33edb56..e837792 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1283,8 +1283,10 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->ani_cache_ini_regs = ar9003_hw_ani_cache_ini_regs;
 	priv_ops->set_radar_params = ar9003_hw_set_radar_params;
 
-	ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
-	ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
+	if (AR_SREV_9330(ah) || AR_SREV_9485(ah)) {
+		ops->antdiv_comb_conf_get = ar9003_hw_antdiv_comb_conf_get;
+		ops->antdiv_comb_conf_set = ar9003_hw_antdiv_comb_conf_set;
+	}
 
 	ar9003_hw_set_nf_limits(ah);
 	ar9003_hw_set_radar_conf(ah);
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index dd9003e..530ed33 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -121,13 +121,15 @@ static inline void ath9k_hw_set_clrdmask(struct ath_hw *ah, void *ds, bool val)
 static inline void ath9k_hw_antdiv_comb_conf_get(struct ath_hw *ah,
 		struct ath_hw_antcomb_conf *antconf)
 {
-	ath9k_hw_ops(ah)->antdiv_comb_conf_get(ah, antconf);
+	if (ath9k_hw_ops(ah)->antdiv_comb_conf_get)
+		ath9k_hw_ops(ah)->antdiv_comb_conf_get(ah, antconf);
 }
 
 static inline void ath9k_hw_antdiv_comb_conf_set(struct ath_hw *ah,
 		struct ath_hw_antcomb_conf *antconf)
 {
-	ath9k_hw_ops(ah)->antdiv_comb_conf_set(ah, antconf);
+	if (ath9k_hw_ops(ah)->antdiv_comb_conf_set)
+		ath9k_hw_ops(ah)->antdiv_comb_conf_set(ah, antconf);
 }
 
 /* Private hardware call ops */
-- 
1.7.3.2

