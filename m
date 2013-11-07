Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46894 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab3KGAQk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 19:16:40 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/13] ath9k: Use CONFIG_ATH9K_WOW
Date: Thu,  7 Nov 2013 05:41:53 +0530
Message-Id: <1383783120-22435-7-git-send-email-sujith@msujith.org> (sfid-20131107_011645_774314_F21232B9)
In-Reply-To: <1383783120-22435-1-git-send-email-sujith@msujith.org>
References: <1383783120-22435-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Move the WoW code to wow.c and compile it conditionally
based on CONFIG_ATH9K_WOW.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Makefile |   3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h  |  28 ++-
 drivers/net/wireless/ath/ath9k/hw.h     |   4 +-
 drivers/net/wireless/ath/ath9k/init.c   |   4 +-
 drivers/net/wireless/ath/ath9k/main.c   | 338 +------------------------------
 drivers/net/wireless/ath/ath9k/wow.c    | 341 ++++++++++++++++++++++++++++++++
 6 files changed, 381 insertions(+), 337 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 796686a..337c459 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -15,6 +15,7 @@ ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 ath9k-$(CONFIG_ATH9K_DFS_DEBUGFS) += dfs_debug.o
 ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += dfs.o
 ath9k-$(CONFIG_ATH9K_TX99) += tx99.o
+ath9k-$(CONFIG_ATH9K_WOW) += wow.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
 
@@ -40,7 +41,7 @@ ath9k_hw-y:=	\
 		ar9003_eeprom.o \
 		ar9003_paprd.o
 
-ath9k_hw-$(CONFIG_PM_SLEEP) += ar9003_wow.o
+ath9k_hw-$(CONFIG_ATH9K_WOW) += ar9003_wow.o
 
 ath9k_hw-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += btcoex.o \
 					   ar9003_mci.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 62f5892..9e1b728 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -570,6 +570,30 @@ static inline void ath_fill_led_pin(struct ath_softc *sc)
 }
 #endif
 
+/************************/
+/* Wake on Wireless LAN */
+/************************/
+
+#ifdef CONFIG_ATH9K_WOW
+int ath9k_suspend(struct ieee80211_hw *hw,
+		  struct cfg80211_wowlan *wowlan);
+int ath9k_resume(struct ieee80211_hw *hw);
+void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled);
+#else
+static inline int ath9k_suspend(struct ieee80211_hw *hw,
+				struct cfg80211_wowlan *wowlan)
+{
+	return 0;
+}
+static inline int ath9k_resume(struct ieee80211_hw *hw)
+{
+	return 0;
+}
+static inline void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
+{
+}
+#endif /* CONFIG_ATH9K_WOW */
+
 /*******************************/
 /* Antenna diversity/combining */
 /*******************************/
@@ -784,7 +808,7 @@ struct ath_softc {
 	bool tx99_state;
 	s16 tx99_power;
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ATH9K_WOW
 	atomic_t wow_got_bmiss_intr;
 	atomic_t wow_sleep_proc_intr; /* in the middle of WoW sleep ? */
 	u32 wow_intr_before_sleep;
@@ -983,6 +1007,8 @@ extern bool is_ath9k_unloaded;
 u8 ath9k_parse_mpdudensity(u8 mpdudensity);
 irqreturn_t ath_isr(int irq, void *dev);
 int ath_reset(struct ath_softc *sc);
+void ath_cancel_work(struct ath_softc *sc);
+void ath_restart_work(struct ath_softc *sc);
 int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9ea24f1..69542c1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -920,7 +920,7 @@ struct ath_hw {
 	/* Enterprise mode cap */
 	u32 ent_mode;
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ATH9K_WOW
 	u32 wow_event_mask;
 #endif
 	bool is_clk_25mhz;
@@ -1126,7 +1126,7 @@ ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
 #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ATH9K_WOW
 const char *ath9k_hw_wow_event_to_string(u32 wow_event);
 void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
 				u8 *user_mask, int pattern_count,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 17502b4..ee7da65 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -870,7 +870,7 @@ static const struct ieee80211_iface_combination if_comb[] = {
 	}
 };
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_ATH9K_WOW
 static const struct wiphy_wowlan_support ath9k_wowlan_support = {
 	.flags = WIPHY_WOWLAN_MAGIC_PKT | WIPHY_WOWLAN_DISCONNECT,
 	.n_patterns = MAX_NUM_USER_PATTERN,
@@ -928,7 +928,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_5_10_MHZ;
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ATH9K_WOW
 	if ((ah->caps.hw_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
 	    (sc->driver_data & ATH9K_PCI_WOW) &&
 	    device_can_wakeup(sc->dev))
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3d17398..e54ffdd 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -163,13 +163,13 @@ static void __ath_cancel_work(struct ath_softc *sc)
 #endif
 }
 
-static void ath_cancel_work(struct ath_softc *sc)
+void ath_cancel_work(struct ath_softc *sc)
 {
 	__ath_cancel_work(sc);
 	cancel_work_sync(&sc->hw_reset_work);
 }
 
-static void ath_restart_work(struct ath_softc *sc)
+void ath_restart_work(struct ath_softc *sc)
 {
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
@@ -579,7 +579,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 		goto chip_reset;
 	}
-#ifdef CONFIG_PM_SLEEP
+
+#ifdef CONFIG_ATH9K_WOW
 	if (status & ATH9K_INT_BMISS) {
 		if (atomic_read(&sc->wow_sleep_proc_intr) == 0) {
 			ath_dbg(common, ANY, "during WoW we got a BMISS\n");
@@ -588,6 +589,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 		}
 	}
 #endif
+
+
 	if (status & ATH9K_INT_SWBA)
 		tasklet_schedule(&sc->bcon_tasklet);
 
@@ -2021,333 +2024,6 @@ static int ath9k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-
-static void ath9k_wow_map_triggers(struct ath_softc *sc,
-				   struct cfg80211_wowlan *wowlan,
-				   u32 *wow_triggers)
-{
-	if (wowlan->disconnect)
-		*wow_triggers |= AH_WOW_LINK_CHANGE |
-				 AH_WOW_BEACON_MISS;
-	if (wowlan->magic_pkt)
-		*wow_triggers |= AH_WOW_MAGIC_PATTERN_EN;
-
-	if (wowlan->n_patterns)
-		*wow_triggers |= AH_WOW_USER_PATTERN_EN;
-
-	sc->wow_enabled = *wow_triggers;
-
-}
-
-static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	int pattern_count = 0;
-	int i, byte_cnt;
-	u8 dis_deauth_pattern[MAX_PATTERN_SIZE];
-	u8 dis_deauth_mask[MAX_PATTERN_SIZE];
-
-	memset(dis_deauth_pattern, 0, MAX_PATTERN_SIZE);
-	memset(dis_deauth_mask, 0, MAX_PATTERN_SIZE);
-
-	/*
-	 * Create Dissassociate / Deauthenticate packet filter
-	 *
-	 *     2 bytes        2 byte    6 bytes   6 bytes  6 bytes
-	 *  +--------------+----------+---------+--------+--------+----
-	 *  + Frame Control+ Duration +   DA    +  SA    +  BSSID +
-	 *  +--------------+----------+---------+--------+--------+----
-	 *
-	 * The above is the management frame format for disassociate/
-	 * deauthenticate pattern, from this we need to match the first byte
-	 * of 'Frame Control' and DA, SA, and BSSID fields
-	 * (skipping 2nd byte of FC and Duration feild.
-	 *
-	 * Disassociate pattern
-	 * --------------------
-	 * Frame control = 00 00 1010
-	 * DA, SA, BSSID = x:x:x:x:x:x
-	 * Pattern will be A0000000 | x:x:x:x:x:x | x:x:x:x:x:x
-	 *			    | x:x:x:x:x:x  -- 22 bytes
-	 *
-	 * Deauthenticate pattern
-	 * ----------------------
-	 * Frame control = 00 00 1100
-	 * DA, SA, BSSID = x:x:x:x:x:x
-	 * Pattern will be C0000000 | x:x:x:x:x:x | x:x:x:x:x:x
-	 *			    | x:x:x:x:x:x  -- 22 bytes
-	 */
-
-	/* Create Disassociate Pattern first */
-
-	byte_cnt = 0;
-
-	/* Fill out the mask with all FF's */
-
-	for (i = 0; i < MAX_PATTERN_MASK_SIZE; i++)
-		dis_deauth_mask[i] = 0xff;
-
-	/* copy the first byte of frame control field */
-	dis_deauth_pattern[byte_cnt] = 0xa0;
-	byte_cnt++;
-
-	/* skip 2nd byte of frame control and Duration field */
-	byte_cnt += 3;
-
-	/*
-	 * need not match the destination mac address, it can be a broadcast
-	 * mac address or an unicast to this station
-	 */
-	byte_cnt += 6;
-
-	/* copy the source mac address */
-	memcpy((dis_deauth_pattern + byte_cnt), common->curbssid, ETH_ALEN);
-
-	byte_cnt += 6;
-
-	/* copy the bssid, its same as the source mac address */
-
-	memcpy((dis_deauth_pattern + byte_cnt), common->curbssid, ETH_ALEN);
-
-	/* Create Disassociate pattern mask */
-
-	dis_deauth_mask[0] = 0xfe;
-	dis_deauth_mask[1] = 0x03;
-	dis_deauth_mask[2] = 0xc0;
-
-	ath_dbg(common, WOW, "Adding disassoc/deauth patterns for WoW\n");
-
-	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
-				   pattern_count, byte_cnt);
-
-	pattern_count++;
-	/*
-	 * for de-authenticate pattern, only the first byte of the frame
-	 * control field gets changed from 0xA0 to 0xC0
-	 */
-	dis_deauth_pattern[0] = 0xC0;
-
-	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
-				   pattern_count, byte_cnt);
-
-}
-
-static void ath9k_wow_add_pattern(struct ath_softc *sc,
-				  struct cfg80211_wowlan *wowlan)
-{
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath9k_wow_pattern *wow_pattern = NULL;
-	struct cfg80211_pkt_pattern *patterns = wowlan->patterns;
-	int mask_len;
-	s8 i = 0;
-
-	if (!wowlan->n_patterns)
-		return;
-
-	/*
-	 * Add the new user configured patterns
-	 */
-	for (i = 0; i < wowlan->n_patterns; i++) {
-
-		wow_pattern = kzalloc(sizeof(*wow_pattern), GFP_KERNEL);
-
-		if (!wow_pattern)
-			return;
-
-		/*
-		 * TODO: convert the generic user space pattern to
-		 * appropriate chip specific/802.11 pattern.
-		 */
-
-		mask_len = DIV_ROUND_UP(wowlan->patterns[i].pattern_len, 8);
-		memset(wow_pattern->pattern_bytes, 0, MAX_PATTERN_SIZE);
-		memset(wow_pattern->mask_bytes, 0, MAX_PATTERN_SIZE);
-		memcpy(wow_pattern->pattern_bytes, patterns[i].pattern,
-		       patterns[i].pattern_len);
-		memcpy(wow_pattern->mask_bytes, patterns[i].mask, mask_len);
-		wow_pattern->pattern_len = patterns[i].pattern_len;
-
-		/*
-		 * just need to take care of deauth and disssoc pattern,
-		 * make sure we don't overwrite them.
-		 */
-
-		ath9k_hw_wow_apply_pattern(ah, wow_pattern->pattern_bytes,
-					   wow_pattern->mask_bytes,
-					   i + 2,
-					   wow_pattern->pattern_len);
-		kfree(wow_pattern);
-
-	}
-
-}
-
-static int ath9k_suspend(struct ieee80211_hw *hw,
-			 struct cfg80211_wowlan *wowlan)
-{
-	struct ath_softc *sc = hw->priv;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 wow_triggers_enabled = 0;
-	int ret = 0;
-
-	mutex_lock(&sc->mutex);
-
-	ath_cancel_work(sc);
-	ath_stop_ani(sc);
-	del_timer_sync(&sc->rx_poll_timer);
-
-	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
-		ath_dbg(common, ANY, "Device not present\n");
-		ret = -EINVAL;
-		goto fail_wow;
-	}
-
-	if (WARN_ON(!wowlan)) {
-		ath_dbg(common, WOW, "None of the WoW triggers enabled\n");
-		ret = -EINVAL;
-		goto fail_wow;
-	}
-
-	if (!device_can_wakeup(sc->dev)) {
-		ath_dbg(common, WOW, "device_can_wakeup failed, WoW is not enabled\n");
-		ret = 1;
-		goto fail_wow;
-	}
-
-	/*
-	 * none of the sta vifs are associated
-	 * and we are not currently handling multivif
-	 * cases, for instance we have to seperately
-	 * configure 'keep alive frame' for each
-	 * STA.
-	 */
-
-	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
-		ath_dbg(common, WOW, "None of the STA vifs are associated\n");
-		ret = 1;
-		goto fail_wow;
-	}
-
-	if (sc->nvifs > 1) {
-		ath_dbg(common, WOW, "WoW for multivif is not yet supported\n");
-		ret = 1;
-		goto fail_wow;
-	}
-
-	ath9k_wow_map_triggers(sc, wowlan, &wow_triggers_enabled);
-
-	ath_dbg(common, WOW, "WoW triggers enabled 0x%x\n",
-		wow_triggers_enabled);
-
-	ath9k_ps_wakeup(sc);
-
-	ath9k_stop_btcoex(sc);
-
-	/*
-	 * Enable wake up on recieving disassoc/deauth
-	 * frame by default.
-	 */
-	ath9k_wow_add_disassoc_deauth_pattern(sc);
-
-	if (wow_triggers_enabled & AH_WOW_USER_PATTERN_EN)
-		ath9k_wow_add_pattern(sc, wowlan);
-
-	spin_lock_bh(&sc->sc_pcu_lock);
-	/*
-	 * To avoid false wake, we enable beacon miss interrupt only
-	 * when we go to sleep. We save the current interrupt mask
-	 * so we can restore it after the system wakes up
-	 */
-	sc->wow_intr_before_sleep = ah->imask;
-	ah->imask &= ~ATH9K_INT_GLOBAL;
-	ath9k_hw_disable_interrupts(ah);
-	ah->imask = ATH9K_INT_BMISS | ATH9K_INT_GLOBAL;
-	ath9k_hw_set_interrupts(ah);
-	ath9k_hw_enable_interrupts(ah);
-
-	spin_unlock_bh(&sc->sc_pcu_lock);
-
-	/*
-	 * we can now sync irq and kill any running tasklets, since we already
-	 * disabled interrupts and not holding a spin lock
-	 */
-	synchronize_irq(sc->irq);
-	tasklet_kill(&sc->intr_tq);
-
-	ath9k_hw_wow_enable(ah, wow_triggers_enabled);
-
-	ath9k_ps_restore(sc);
-	ath_dbg(common, ANY, "WoW enabled in ath9k\n");
-	atomic_inc(&sc->wow_sleep_proc_intr);
-
-fail_wow:
-	mutex_unlock(&sc->mutex);
-	return ret;
-}
-
-static int ath9k_resume(struct ieee80211_hw *hw)
-{
-	struct ath_softc *sc = hw->priv;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	u32 wow_status;
-
-	mutex_lock(&sc->mutex);
-
-	ath9k_ps_wakeup(sc);
-
-	spin_lock_bh(&sc->sc_pcu_lock);
-
-	ath9k_hw_disable_interrupts(ah);
-	ah->imask = sc->wow_intr_before_sleep;
-	ath9k_hw_set_interrupts(ah);
-	ath9k_hw_enable_interrupts(ah);
-
-	spin_unlock_bh(&sc->sc_pcu_lock);
-
-	wow_status = ath9k_hw_wow_wakeup(ah);
-
-	if (atomic_read(&sc->wow_got_bmiss_intr) == 0) {
-		/*
-		 * some devices may not pick beacon miss
-		 * as the reason they woke up so we add
-		 * that here for that shortcoming.
-		 */
-		wow_status |= AH_WOW_BEACON_MISS;
-		atomic_dec(&sc->wow_got_bmiss_intr);
-		ath_dbg(common, ANY, "Beacon miss interrupt picked up during WoW sleep\n");
-	}
-
-	atomic_dec(&sc->wow_sleep_proc_intr);
-
-	if (wow_status) {
-		ath_dbg(common, ANY, "Waking up due to WoW triggers %s with WoW status = %x\n",
-			ath9k_hw_wow_event_to_string(wow_status), wow_status);
-	}
-
-	ath_restart_work(sc);
-	ath9k_start_btcoex(sc);
-
-	ath9k_ps_restore(sc);
-	mutex_unlock(&sc->mutex);
-
-	return 0;
-}
-
-static void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
-{
-	struct ath_softc *sc = hw->priv;
-
-	mutex_lock(&sc->mutex);
-	device_init_wakeup(sc->dev, 1);
-	device_set_wakeup_enable(sc->dev, enabled);
-	mutex_unlock(&sc->mutex);
-}
-
-#endif
 static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
@@ -2403,7 +2079,7 @@ struct ieee80211_ops ath9k_ops = {
 	.set_antenna	    = ath9k_set_antenna,
 	.get_antenna	    = ath9k_get_antenna,
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_ATH9K_WOW
 	.suspend	    = ath9k_suspend,
 	.resume		    = ath9k_resume,
 	.set_wakeup	    = ath9k_set_wakeup,
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
new file mode 100644
index 0000000..e161bbc
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -0,0 +1,341 @@
+/*
+ * Copyright (c) 2013 Qualcomm Atheros, Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "ath9k.h"
+
+static void ath9k_wow_map_triggers(struct ath_softc *sc,
+				   struct cfg80211_wowlan *wowlan,
+				   u32 *wow_triggers)
+{
+	if (wowlan->disconnect)
+		*wow_triggers |= AH_WOW_LINK_CHANGE |
+				 AH_WOW_BEACON_MISS;
+	if (wowlan->magic_pkt)
+		*wow_triggers |= AH_WOW_MAGIC_PATTERN_EN;
+
+	if (wowlan->n_patterns)
+		*wow_triggers |= AH_WOW_USER_PATTERN_EN;
+
+	sc->wow_enabled = *wow_triggers;
+
+}
+
+static void ath9k_wow_add_disassoc_deauth_pattern(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	int pattern_count = 0;
+	int i, byte_cnt;
+	u8 dis_deauth_pattern[MAX_PATTERN_SIZE];
+	u8 dis_deauth_mask[MAX_PATTERN_SIZE];
+
+	memset(dis_deauth_pattern, 0, MAX_PATTERN_SIZE);
+	memset(dis_deauth_mask, 0, MAX_PATTERN_SIZE);
+
+	/*
+	 * Create Dissassociate / Deauthenticate packet filter
+	 *
+	 *     2 bytes        2 byte    6 bytes   6 bytes  6 bytes
+	 *  +--------------+----------+---------+--------+--------+----
+	 *  + Frame Control+ Duration +   DA    +  SA    +  BSSID +
+	 *  +--------------+----------+---------+--------+--------+----
+	 *
+	 * The above is the management frame format for disassociate/
+	 * deauthenticate pattern, from this we need to match the first byte
+	 * of 'Frame Control' and DA, SA, and BSSID fields
+	 * (skipping 2nd byte of FC and Duration feild.
+	 *
+	 * Disassociate pattern
+	 * --------------------
+	 * Frame control = 00 00 1010
+	 * DA, SA, BSSID = x:x:x:x:x:x
+	 * Pattern will be A0000000 | x:x:x:x:x:x | x:x:x:x:x:x
+	 *			    | x:x:x:x:x:x  -- 22 bytes
+	 *
+	 * Deauthenticate pattern
+	 * ----------------------
+	 * Frame control = 00 00 1100
+	 * DA, SA, BSSID = x:x:x:x:x:x
+	 * Pattern will be C0000000 | x:x:x:x:x:x | x:x:x:x:x:x
+	 *			    | x:x:x:x:x:x  -- 22 bytes
+	 */
+
+	/* Create Disassociate Pattern first */
+
+	byte_cnt = 0;
+
+	/* Fill out the mask with all FF's */
+
+	for (i = 0; i < MAX_PATTERN_MASK_SIZE; i++)
+		dis_deauth_mask[i] = 0xff;
+
+	/* copy the first byte of frame control field */
+	dis_deauth_pattern[byte_cnt] = 0xa0;
+	byte_cnt++;
+
+	/* skip 2nd byte of frame control and Duration field */
+	byte_cnt += 3;
+
+	/*
+	 * need not match the destination mac address, it can be a broadcast
+	 * mac address or an unicast to this station
+	 */
+	byte_cnt += 6;
+
+	/* copy the source mac address */
+	memcpy((dis_deauth_pattern + byte_cnt), common->curbssid, ETH_ALEN);
+
+	byte_cnt += 6;
+
+	/* copy the bssid, its same as the source mac address */
+
+	memcpy((dis_deauth_pattern + byte_cnt), common->curbssid, ETH_ALEN);
+
+	/* Create Disassociate pattern mask */
+
+	dis_deauth_mask[0] = 0xfe;
+	dis_deauth_mask[1] = 0x03;
+	dis_deauth_mask[2] = 0xc0;
+
+	ath_dbg(common, WOW, "Adding disassoc/deauth patterns for WoW\n");
+
+	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
+				   pattern_count, byte_cnt);
+
+	pattern_count++;
+	/*
+	 * for de-authenticate pattern, only the first byte of the frame
+	 * control field gets changed from 0xA0 to 0xC0
+	 */
+	dis_deauth_pattern[0] = 0xC0;
+
+	ath9k_hw_wow_apply_pattern(ah, dis_deauth_pattern, dis_deauth_mask,
+				   pattern_count, byte_cnt);
+
+}
+
+static void ath9k_wow_add_pattern(struct ath_softc *sc,
+				  struct cfg80211_wowlan *wowlan)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_wow_pattern *wow_pattern = NULL;
+	struct cfg80211_pkt_pattern *patterns = wowlan->patterns;
+	int mask_len;
+	s8 i = 0;
+
+	if (!wowlan->n_patterns)
+		return;
+
+	/*
+	 * Add the new user configured patterns
+	 */
+	for (i = 0; i < wowlan->n_patterns; i++) {
+
+		wow_pattern = kzalloc(sizeof(*wow_pattern), GFP_KERNEL);
+
+		if (!wow_pattern)
+			return;
+
+		/*
+		 * TODO: convert the generic user space pattern to
+		 * appropriate chip specific/802.11 pattern.
+		 */
+
+		mask_len = DIV_ROUND_UP(wowlan->patterns[i].pattern_len, 8);
+		memset(wow_pattern->pattern_bytes, 0, MAX_PATTERN_SIZE);
+		memset(wow_pattern->mask_bytes, 0, MAX_PATTERN_SIZE);
+		memcpy(wow_pattern->pattern_bytes, patterns[i].pattern,
+		       patterns[i].pattern_len);
+		memcpy(wow_pattern->mask_bytes, patterns[i].mask, mask_len);
+		wow_pattern->pattern_len = patterns[i].pattern_len;
+
+		/*
+		 * just need to take care of deauth and disssoc pattern,
+		 * make sure we don't overwrite them.
+		 */
+
+		ath9k_hw_wow_apply_pattern(ah, wow_pattern->pattern_bytes,
+					   wow_pattern->mask_bytes,
+					   i + 2,
+					   wow_pattern->pattern_len);
+		kfree(wow_pattern);
+
+	}
+
+}
+
+int ath9k_suspend(struct ieee80211_hw *hw,
+		  struct cfg80211_wowlan *wowlan)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 wow_triggers_enabled = 0;
+	int ret = 0;
+
+	mutex_lock(&sc->mutex);
+
+	ath_cancel_work(sc);
+	ath_stop_ani(sc);
+	del_timer_sync(&sc->rx_poll_timer);
+
+	if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
+		ath_dbg(common, ANY, "Device not present\n");
+		ret = -EINVAL;
+		goto fail_wow;
+	}
+
+	if (WARN_ON(!wowlan)) {
+		ath_dbg(common, WOW, "None of the WoW triggers enabled\n");
+		ret = -EINVAL;
+		goto fail_wow;
+	}
+
+	if (!device_can_wakeup(sc->dev)) {
+		ath_dbg(common, WOW, "device_can_wakeup failed, WoW is not enabled\n");
+		ret = 1;
+		goto fail_wow;
+	}
+
+	/*
+	 * none of the sta vifs are associated
+	 * and we are not currently handling multivif
+	 * cases, for instance we have to seperately
+	 * configure 'keep alive frame' for each
+	 * STA.
+	 */
+
+	if (!test_bit(SC_OP_PRIM_STA_VIF, &sc->sc_flags)) {
+		ath_dbg(common, WOW, "None of the STA vifs are associated\n");
+		ret = 1;
+		goto fail_wow;
+	}
+
+	if (sc->nvifs > 1) {
+		ath_dbg(common, WOW, "WoW for multivif is not yet supported\n");
+		ret = 1;
+		goto fail_wow;
+	}
+
+	ath9k_wow_map_triggers(sc, wowlan, &wow_triggers_enabled);
+
+	ath_dbg(common, WOW, "WoW triggers enabled 0x%x\n",
+		wow_triggers_enabled);
+
+	ath9k_ps_wakeup(sc);
+
+	ath9k_stop_btcoex(sc);
+
+	/*
+	 * Enable wake up on recieving disassoc/deauth
+	 * frame by default.
+	 */
+	ath9k_wow_add_disassoc_deauth_pattern(sc);
+
+	if (wow_triggers_enabled & AH_WOW_USER_PATTERN_EN)
+		ath9k_wow_add_pattern(sc, wowlan);
+
+	spin_lock_bh(&sc->sc_pcu_lock);
+	/*
+	 * To avoid false wake, we enable beacon miss interrupt only
+	 * when we go to sleep. We save the current interrupt mask
+	 * so we can restore it after the system wakes up
+	 */
+	sc->wow_intr_before_sleep = ah->imask;
+	ah->imask &= ~ATH9K_INT_GLOBAL;
+	ath9k_hw_disable_interrupts(ah);
+	ah->imask = ATH9K_INT_BMISS | ATH9K_INT_GLOBAL;
+	ath9k_hw_set_interrupts(ah);
+	ath9k_hw_enable_interrupts(ah);
+
+	spin_unlock_bh(&sc->sc_pcu_lock);
+
+	/*
+	 * we can now sync irq and kill any running tasklets, since we already
+	 * disabled interrupts and not holding a spin lock
+	 */
+	synchronize_irq(sc->irq);
+	tasklet_kill(&sc->intr_tq);
+
+	ath9k_hw_wow_enable(ah, wow_triggers_enabled);
+
+	ath9k_ps_restore(sc);
+	ath_dbg(common, ANY, "WoW enabled in ath9k\n");
+	atomic_inc(&sc->wow_sleep_proc_intr);
+
+fail_wow:
+	mutex_unlock(&sc->mutex);
+	return ret;
+}
+
+int ath9k_resume(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 wow_status;
+
+	mutex_lock(&sc->mutex);
+
+	ath9k_ps_wakeup(sc);
+
+	spin_lock_bh(&sc->sc_pcu_lock);
+
+	ath9k_hw_disable_interrupts(ah);
+	ah->imask = sc->wow_intr_before_sleep;
+	ath9k_hw_set_interrupts(ah);
+	ath9k_hw_enable_interrupts(ah);
+
+	spin_unlock_bh(&sc->sc_pcu_lock);
+
+	wow_status = ath9k_hw_wow_wakeup(ah);
+
+	if (atomic_read(&sc->wow_got_bmiss_intr) == 0) {
+		/*
+		 * some devices may not pick beacon miss
+		 * as the reason they woke up so we add
+		 * that here for that shortcoming.
+		 */
+		wow_status |= AH_WOW_BEACON_MISS;
+		atomic_dec(&sc->wow_got_bmiss_intr);
+		ath_dbg(common, ANY, "Beacon miss interrupt picked up during WoW sleep\n");
+	}
+
+	atomic_dec(&sc->wow_sleep_proc_intr);
+
+	if (wow_status) {
+		ath_dbg(common, ANY, "Waking up due to WoW triggers %s with WoW status = %x\n",
+			ath9k_hw_wow_event_to_string(wow_status), wow_status);
+	}
+
+	ath_restart_work(sc);
+	ath9k_start_btcoex(sc);
+
+	ath9k_ps_restore(sc);
+	mutex_unlock(&sc->mutex);
+
+	return 0;
+}
+
+void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
+{
+	struct ath_softc *sc = hw->priv;
+
+	mutex_lock(&sc->mutex);
+	device_init_wakeup(sc->dev, 1);
+	device_set_wakeup_enable(sc->dev, enabled);
+	mutex_unlock(&sc->mutex);
+}
-- 
1.8.4.2

