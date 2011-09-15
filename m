Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37057 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388Ab1IOMZq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 08:25:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH RESEND 3/4] ath9k_hw: fix setting the hardware diversity flag
Date: Thu, 15 Sep 2011 14:25:37 +0200
Message-Id: <1316089538-91685-3-git-send-email-nbd@openwrt.org> (sfid-20110915_142554_963677_58CBD944)
In-Reply-To: <1316089538-91685-2-git-send-email-nbd@openwrt.org>
References: <1316089538-91685-1-git-send-email-nbd@openwrt.org>
 <1316089538-91685-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_set_diversity is only called from init.c where it cannot affect
the hardware setting because it's cleared on the next reset.
Instead of using a PHY op for something that's supposed to be initialized
statically, set the register value directly in the INI override function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |   14 +++-----------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   14 +++-----------
 drivers/net/wireless/ath/ath9k/hw-ops.h     |    5 -----
 drivers/net/wireless/ath/ath9k/hw.h         |    1 -
 drivers/net/wireless/ath/ath9k/init.c       |    1 -
 5 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 1381a39..794a2d9 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -704,6 +704,9 @@ static void ar5008_hw_override_ini(struct ath_hw *ah,
 		REG_WRITE(ah, AR_PCU_MISC_MODE2, val);
 	}
 
+	REG_SET_BIT(ah, AR_PHY_CCK_DETECT,
+		    AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
+
 	if (AR_SREV_9280_20_OR_LATER(ah))
 		return;
 	/*
@@ -1007,16 +1010,6 @@ static void ar5008_restore_chainmask(struct ath_hw *ah)
 	}
 }
 
-static void ar5008_set_diversity(struct ath_hw *ah, bool value)
-{
-	u32 v = REG_READ(ah, AR_PHY_CCK_DETECT);
-	if (value)
-		v |= AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
-	else
-		v &= ~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
-	REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
-}
-
 static u32 ar9100_hw_compute_pll_control(struct ath_hw *ah,
 					 struct ath9k_channel *chan)
 {
@@ -1654,7 +1647,6 @@ void ar5008_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->rfbus_req = ar5008_hw_rfbus_req;
 	priv_ops->rfbus_done = ar5008_hw_rfbus_done;
 	priv_ops->restore_chainmask = ar5008_restore_chainmask;
-	priv_ops->set_diversity = ar5008_set_diversity;
 	priv_ops->do_getnf = ar5008_hw_do_getnf;
 	priv_ops->set_radar_params = ar5008_hw_set_radar_params;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 2f35aee..d7d251e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -592,6 +592,9 @@ static void ar9003_hw_override_ini(struct ath_hw *ah)
 	val = REG_READ(ah, AR_PCU_MISC_MODE2) & (~AR_ADHOC_MCAST_KEYID_ENABLE);
 	REG_WRITE(ah, AR_PCU_MISC_MODE2,
 		  val | AR_AGG_WEP_ENABLE_FIX | AR_AGG_WEP_ENABLE);
+
+	REG_SET_BIT(ah, AR_PHY_CCK_DETECT,
+		    AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV);
 }
 
 static void ar9003_hw_prog_ini(struct ath_hw *ah,
@@ -785,16 +788,6 @@ static void ar9003_hw_rfbus_done(struct ath_hw *ah)
 	REG_WRITE(ah, AR_PHY_RFBUS_REQ, 0);
 }
 
-static void ar9003_hw_set_diversity(struct ath_hw *ah, bool value)
-{
-	u32 v = REG_READ(ah, AR_PHY_CCK_DETECT);
-	if (value)
-		v |= AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
-	else
-		v &= ~AR_PHY_CCK_DETECT_BB_ENABLE_ANT_FAST_DIV;
-	REG_WRITE(ah, AR_PHY_CCK_DETECT, v);
-}
-
 static bool ar9003_hw_ani_control(struct ath_hw *ah,
 				  enum ath9k_ani_cmd cmd, int param)
 {
@@ -1277,7 +1270,6 @@ void ar9003_hw_attach_phy_ops(struct ath_hw *ah)
 	priv_ops->set_delta_slope = ar9003_hw_set_delta_slope;
 	priv_ops->rfbus_req = ar9003_hw_rfbus_req;
 	priv_ops->rfbus_done = ar9003_hw_rfbus_done;
-	priv_ops->set_diversity = ar9003_hw_set_diversity;
 	priv_ops->ani_control = ar9003_hw_ani_control;
 	priv_ops->do_getnf = ar9003_hw_do_getnf;
 	priv_ops->ani_cache_ini_regs = ar9003_hw_ani_cache_ini_regs;
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index 41f4bf3..e9782d1 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -181,11 +181,6 @@ static inline void ath9k_hw_restore_chainmask(struct ath_hw *ah)
 	return ath9k_hw_private_ops(ah)->restore_chainmask(ah);
 }
 
-static inline void ath9k_hw_set_diversity(struct ath_hw *ah, bool value)
-{
-	return ath9k_hw_private_ops(ah)->set_diversity(ah, value);
-}
-
 static inline bool ath9k_hw_ani_control(struct ath_hw *ah,
 					enum ath9k_ani_cmd cmd, int param)
 {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 1444292..45e866d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -583,7 +583,6 @@ struct ath_hw_private_ops {
 	bool (*rfbus_req)(struct ath_hw *ah);
 	void (*rfbus_done)(struct ath_hw *ah);
 	void (*restore_chainmask)(struct ath_hw *ah);
-	void (*set_diversity)(struct ath_hw *ah, bool value);
 	u32 (*compute_pll_control)(struct ath_hw *ah,
 				   struct ath9k_channel *chan);
 	bool (*ani_control)(struct ath_hw *ah, enum ath9k_ani_cmd cmd,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9b34c4b..39514de 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -506,7 +506,6 @@ static void ath9k_init_misc(struct ath_softc *sc)
 		sc->sc_flags |= SC_OP_RXAGGR;
 	}
 
-	ath9k_hw_set_diversity(sc->sc_ah, true);
 	sc->rx.defant = ath9k_hw_getdefantenna(sc->sc_ah);
 
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
-- 
1.7.3.2

