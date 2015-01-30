Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51313 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507AbbA3Nct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:49 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgm-004FiR-O8
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 07/17] ath9k: Check WOW triggers properly
Date: Fri, 30 Jan 2015 19:05:27 +0530
Message-Id: <1422624937-4810-8-git-send-email-sujith@msujith.org> (sfid-20150130_143349_777083_90626C3F)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch makes sure that valid WOW triggers
are present before trying to suspend the device.
Also, introduce and use ATH_OP_WOW_ENABLED to
bypass PCI suspend and clear it in resume().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h       |  1 +
 drivers/net/wireless/ath/ath9k/pci.c |  5 +++-
 drivers/net/wireless/ath/ath9k/wow.c | 53 ++++++++++++++++--------------------
 3 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index ccba4fe..1eebe2e 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -64,6 +64,7 @@ enum ath_op_flags {
 	ATH_OP_HW_RESET,
 	ATH_OP_SCANNING,
 	ATH_OP_MULTI_CHANNEL,
+	ATH_OP_WOW_ENABLED,
 };
 
 enum ath_bus_type {
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index cc5c681..e6fef1b 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -998,9 +998,12 @@ static int ath_pci_suspend(struct device *device)
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
-	if (sc->wow_enabled)
+	if (test_bit(ATH_OP_WOW_ENABLED, &common->op_flags)) {
+		dev_info(&pdev->dev, "WOW is enabled, bypassing PCI suspend\n");
 		return 0;
+	}
 
 	/* The device has to be moved to FULLSLEEP forcibly.
 	 * Otherwise the chip never moved to full sleep,
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 8bcbaa9..c0c564d 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -23,21 +23,21 @@ static const struct wiphy_wowlan_support ath9k_wowlan_support = {
 	.pattern_max_len = MAX_PATTERN_SIZE,
 };
 
-static void ath9k_wow_map_triggers(struct ath_softc *sc,
-				   struct cfg80211_wowlan *wowlan,
-				   u32 *wow_triggers)
+static u8 ath9k_wow_map_triggers(struct ath_softc *sc,
+				 struct cfg80211_wowlan *wowlan)
 {
+	u8 wow_triggers = 0;
+
 	if (wowlan->disconnect)
-		*wow_triggers |= AH_WOW_LINK_CHANGE |
-				 AH_WOW_BEACON_MISS;
+		wow_triggers |= AH_WOW_LINK_CHANGE |
+				AH_WOW_BEACON_MISS;
 	if (wowlan->magic_pkt)
-		*wow_triggers |= AH_WOW_MAGIC_PATTERN_EN;
+		wow_triggers |= AH_WOW_MAGIC_PATTERN_EN;
 
 	if (wowlan->n_patterns)
-		*wow_triggers |= AH_WOW_USER_PATTERN_EN;
-
-	sc->wow_enabled = *wow_triggers;
+		wow_triggers |= AH_WOW_USER_PATTERN_EN;
 
+	return wow_triggers;
 }
 
 static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
@@ -45,7 +45,7 @@ static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	int pattern_count = 0;
-	int i, byte_cnt;
+	int i, byte_cnt = 0;
 	u8 dis_deauth_pattern[MAX_PATTERN_SIZE];
 	u8 dis_deauth_mask[MAX_PATTERN_SIZE];
 
@@ -80,12 +80,7 @@ static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 	 *			    | x:x:x:x:x:x  -- 22 bytes
 	 */
 
-	/* Create Disassociate Pattern first */
-
-	byte_cnt = 0;
-
 	/* Fill out the mask with all FF's */
-
 	for (i = 0; i < MAX_PATTERN_MASK_SIZE; i++)
 		dis_deauth_mask[i] = 0xff;
 
@@ -108,17 +103,13 @@ static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 	byte_cnt += 6;
 
 	/* copy the bssid, its same as the source mac address */
-
 	memcpy((dis_deauth_pattern + byte_cnt), common->curbssid, ETH_ALEN);
 
 	/* Create Disassociate pattern mask */
-
 	dis_deauth_mask[0] = 0xfe;
 	dis_deauth_mask[1] = 0x03;
 	dis_deauth_mask[2] = 0xc0;
 
-	ath_dbg(common, WOW, "Adding disassoc/deauth patterns for WoW\n");
-
 	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
 				   pattern_count, byte_cnt);
 
@@ -131,7 +122,6 @@ static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
 
 	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
 				   pattern_count, byte_cnt);
-
 }
 
 static void ath9k_wow_add_pattern(struct ath_softc *sc,
@@ -190,7 +180,7 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	u32 wow_triggers_enabled = 0;
+	u8 triggers;
 	int ret = 0;
 
 	ath9k_deinit_channel_context(sc);
@@ -230,14 +220,16 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 		goto fail_wow;
 	}
 
+	triggers = ath9k_wow_map_triggers(sc, wowlan);
+	if (!triggers) {
+		ath_dbg(common, WOW, "No valid WoW triggers\n");
+		ret = 1;
+		goto fail_wow;
+	}
+
 	ath_cancel_work(sc);
 	ath_stop_ani(sc);
 
-	ath9k_wow_map_triggers(sc, wowlan, &wow_triggers_enabled);
-
-	ath_dbg(common, WOW, "WoW triggers enabled 0x%x\n",
-		wow_triggers_enabled);
-
 	ath9k_ps_wakeup(sc);
 
 	ath9k_stop_btcoex(sc);
@@ -248,7 +240,7 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 	 */
 	ath9k_wow_add_disassoc_deauth_pattern(sc);
 
-	if (wow_triggers_enabled & AH_WOW_USER_PATTERN_EN)
+	if (triggers & AH_WOW_USER_PATTERN_EN)
 		ath9k_wow_add_pattern(sc, wowlan);
 
 	spin_lock_bh(&sc->sc_pcu_lock);
@@ -273,12 +265,13 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 	synchronize_irq(sc->irq);
 	tasklet_kill(&sc->intr_tq);
 
-	ath9k_hw_wow_enable(ah, wow_triggers_enabled);
+	ath9k_hw_wow_enable(ah, triggers);
 
 	ath9k_ps_restore(sc);
-	ath_dbg(common, ANY, "WoW enabled in ath9k\n");
+	ath_dbg(common, WOW, "Suspend with WoW triggers: 0x%x\n", triggers);
 	atomic_inc(&sc->wow_sleep_proc_intr);
 
+	set_bit(ATH_OP_WOW_ENABLED, &common->op_flags);
 fail_wow:
 	mutex_unlock(&sc->mutex);
 	return ret;
@@ -327,6 +320,8 @@ int ath9k_resume(struct ieee80211_hw *hw)
 	ath_restart_work(sc);
 	ath9k_start_btcoex(sc);
 
+	clear_bit(ATH_OP_WOW_ENABLED, &common->op_flags);
+
 	ath9k_ps_restore(sc);
 	mutex_unlock(&sc->mutex);
 
-- 
2.2.2

