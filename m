Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676AbZGOAWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:22:04 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 5/5] ath9k: Add Wake-on-Wireless-LAN support
Date: Tue, 14 Jul 2009 20:22:00 -0400
Message-Id: <1247617320-20163-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds WoW suppport for ath9k. Note that not all cards
have WoW support available; you also need BIOS support to
trigger a wake from the device's PCI PME. We enable only
Magic Packet triggers for now, note that if you disconnect
you won't get a wake up. Beacon miss and link change triggers
need more testing before being enabled.

Tested on AR9280 with Magic Packet.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/Makefile   |    1 +
 drivers/net/wireless/ath/ath9k/ath9k.h    |   18 +
 drivers/net/wireless/ath/ath9k/debug.c    |    1 -
 drivers/net/wireless/ath/ath9k/hw.c       |   22 ++
 drivers/net/wireless/ath/ath9k/hw.h       |   21 ++
 drivers/net/wireless/ath/ath9k/initvals.h |   31 ++
 drivers/net/wireless/ath/ath9k/main.c     |   23 ++
 drivers/net/wireless/ath/ath9k/pci.c      |  102 ++++++
 drivers/net/wireless/ath/ath9k/reg.h      |  154 +++++++++
 drivers/net/wireless/ath/ath9k/wow.c      |  511 +++++++++++++++++++++++++++++
 10 files changed, 883 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 783bc39..d4a598d 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -14,5 +14,6 @@ ath9k-y +=	hw.o \
 ath9k-$(CONFIG_PCI) += pci.o
 ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUG) += debug.o
+ath9k-$(CONFIG_PM) += wow.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1576812..2723385 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -604,6 +604,12 @@ struct ath_softc {
 
 	struct ath_ani ani;
 	struct ath9k_node_stats nodestats;
+#ifdef CONFIG_PM
+	bool wow_got_bmiss_intr;
+	bool wow_sleep_proc_intr;
+	u32 wow_intr_before_sleep;
+	u32 wow_triggers_enabled;
+#endif
 #ifdef CONFIG_ATH9K_DEBUG
 	struct ath9k_debug debug;
 #endif
@@ -612,6 +618,18 @@ struct ath_softc {
 	struct delayed_work tx_complete_work;
 };
 
+#ifdef CONFIG_PM
+/*
+ * WoW trigger types
+ */
+#define AH_WOW_USER_PATTERN_EN		0x1
+#define AH_WOW_MAGIC_PATTERN_EN		0x2
+#define AH_WOW_LINK_CHANGE		0x4
+#define AH_WOW_BEACON_MISS		0x8
+#define AH_WOW_MAX_EVENTS		4
+
+#endif
+
 struct ath_wiphy {
 	struct ath_softc *sc; /* shared for all virtual wiphys */
 	struct ieee80211_hw *hw;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9f99f00..8705c35 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -486,7 +486,6 @@ static const struct file_operations fops_wiphy = {
 	.owner = THIS_MODULE
 };
 
-
 int ath9k_init_debug(struct ath_softc *sc)
 {
 	sc->debug.debug_mask = ath9k_debug;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b9d1a13..3d98f8d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -718,6 +718,12 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 			ARRAY_SIZE(ar9285PciePhy_clkreq_always_on_L1_9285_1_2),
 				  2);
 		}
+#ifdef CONFIG_PM
+		/* SerDes values during WOW sleep */
+		INIT_INI_ARRAY(&ah->iniPcieSerdesWow,
+			       ar9285PciePhy_AWOW_9285_1_2,
+			       ARRAY_SIZE(ar9285PciePhy_AWOW_9285_1_2), 2);
+#endif
 	} else if (AR_SREV_9285_10_OR_LATER(ah)) {
 		INIT_INI_ARRAY(&ah->iniModes, ar9285Modes_9285,
 			       ARRAY_SIZE(ar9285Modes_9285), 6);
@@ -748,6 +754,12 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 			       ar9280PciePhy_clkreq_always_on_L1_9280,
 			       ARRAY_SIZE(ar9280PciePhy_clkreq_always_on_L1_9280), 2);
 		}
+#ifdef CONFIG_PM
+		/* SerDes values during WOW sleep */
+		INIT_INI_ARRAY(&ah->iniPcieSerdesWow, ar9280PciePhy_AWOW_9280,
+			       ARRAY_SIZE(ar9280PciePhy_AWOW_9280), 2);
+#endif
+
 		INIT_INI_ARRAY(&ah->iniModesAdditional,
 			       ar9280Modes_fast_clock_9280_2,
 			       ARRAY_SIZE(ar9280Modes_fast_clock_9280_2), 3);
@@ -893,6 +905,16 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		goto bad;
 	}
 
+#ifdef CONFIG_PM
+	/* WOW */
+	ath9k_wow_set_gpio_reset_low(ah);
+	/* Clear the Wow Status */
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, REG_READ(ah, AR_PCIE_PM_CTRL) |
+		  AR_PMCTRL_WOW_PME_CLR);
+	REG_WRITE(ah, AR_WOW_PATTERN_REG,
+		  AR_WOW_CLEAR_EVENTS(REG_READ(ah, AR_WOW_PATTERN_REG)));
+#endif
+
 	if (AR_SREV_9285(ah))
 		ah->tx_trig_level = (AR_FTRIG_256B >> AR_FTRIG_S);
 	else
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9a4570d..6126b99 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -520,6 +520,11 @@ struct ath_hw {
 	int initPDADC;
 	int PDADCdelta;
 
+#ifdef CONFIG_PM
+	/* WoW mask -- used to indicate which WoW we have enabled */
+	u32 ah_wowEventMask;
+#endif
+
 	struct ar5416IniArray iniModes;
 	struct ar5416IniArray iniCommon;
 	struct ar5416IniArray iniBank0;
@@ -535,6 +540,10 @@ struct ath_hw {
 	struct ar5416IniArray iniModesAdditional;
 	struct ar5416IniArray iniModesRxGain;
 	struct ar5416IniArray iniModesTxGain;
+#ifdef CONFIG_PM
+	/* SerDes values during WOW sleep */
+	struct ar5416IniArray iniPcieSerdesWow;
+#endif
 };
 
 /* Attach, Detach, Reset */
@@ -613,4 +622,16 @@ enum ath9k_int ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints);
 
 void ath9k_hw_btcoex_enable(struct ath_hw *ah);
 
+#ifdef CONFIG_PM
+
+/* WOW - Wake on Wireless */
+void ath9k_wow_set_gpio_reset_low(struct ath_hw *ah);
+/* Called when going to suspend/hibernate */
+void ath9k_hw_wow_enable(struct ath_hw *ah, u32 patternEnable);
+/* Called when coming back up from suspend/hibernation */
+u32 ath9k_hw_wow_wake_up(struct ath_hw *ah);
+const char *ath9k_hw_wow_event_to_string(u32 wow_event);
+
+#endif /* CONFIG_PM */
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/initvals.h b/drivers/net/wireless/ath/ath9k/initvals.h
index f67a2a9..52e1743 100644
--- a/drivers/net/wireless/ath/ath9k/initvals.h
+++ b/drivers/net/wireless/ath/ath9k/initvals.h
@@ -3439,6 +3439,22 @@ static const u32 ar9280PciePhy_clkreq_always_on_L1_9280[][2] = {
     {0x00004044,  0x00000000 },
 };
 
+#ifdef CONFIG_PM
+/* Auto generated PCI-E PHY config for AR9280 with WOW */
+static const u_int32_t ar9280PciePhy_AWOW_9280[][2] = {
+    {0x00004040,  0x9248fd00 },
+    {0x00004040,  0x24924924 },
+    {0x00004040,  0xa8000019 },
+    {0x00004040,  0x13160820 },
+    {0x00004040,  0xe5980560 },
+    {0x00004040,  0xc01ddffd },
+    {0x00004040,  0x1aaabe41 },
+    {0x00004040,  0xbe105554 },
+    {0x00004040,  0x00043007 },
+    {0x00004044,  0x00000000 },
+};
+#endif
+
 /* AR9285 Revsion 10*/
 static const u_int32_t ar9285Modes_9285[][6] = {
     { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
@@ -4849,3 +4865,18 @@ static const u_int32_t ar9285PciePhy_clkreq_off_L1_9285_1_2[][2] = {
     {0x00004040,  0x00043007 },
     {0x00004044,  0x00000000 },
 };
+
+#ifdef CONFIG_PM
+static const u_int32_t ar9285PciePhy_AWOW_9285_1_2[][2] = {
+    {0x00004040,  0x9248fd00 },
+    {0x00004040,  0x24924924 },
+    {0x00004040,  0xa8000019 },
+    {0x00004040,  0x13160820 },
+    {0x00004040,  0xe5980560 },
+    {0x00004040,  0xc01ddffd },
+    {0x00004040,  0x1aaabe41 },
+    {0x00004040,  0xbe105554 },
+    {0x00004040,  0x00043007 },
+    {0x00004044,  0x00000000 },
+};
+#endif /* CONFIG_PM */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index f40f2cf..84c0fed 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -596,6 +596,20 @@ irqreturn_t ath_isr(int irq, void *dev)
 		ath9k_hw_set_interrupts(ah, sc->imask);
 	}
 
+	if (status & ATH9K_INT_BMISS) {
+#ifdef CONFIG_PM
+		if (sc->wow_sleep_proc_intr) {
+			DPRINTF(sc, (ATH_DBG_ANY | ATH_DBG_INTERRUPT),
+				"during WoW we got a BMISS\n");
+			sc->wow_got_bmiss_intr = true;
+			sc->wow_sleep_proc_intr = false;
+		}
+#else
+		/* BMISS not enabled on ath9k unless WoW is enabled */
+		DPRINTF(sc, ATH_DBG_INTERRUPT,
+			"spurious unattended beacon miss interrupt\n");
+#endif
+	}
 	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_AUTOSLEEP))
 		if (status & ATH9K_INT_TIM_TIMER) {
 			/* Clear RxAbort bit so that we can
@@ -2094,6 +2108,15 @@ static void ath9k_stop(struct ieee80211_hw *hw, struct cfg80211_wow *wow)
 
 	aphy->state = ATH_WIPHY_INACTIVE;
 
+#ifdef CONFIG_PM
+	if (wow && wow->triggers_enabled) {
+		sc->wow_triggers_enabled = wow->triggers_enabled;
+		DPRINTF(sc, ATH_DBG_ANY, "Leaving radio on during "
+			"suspend for WoW\n");
+		return;
+	}
+#endif
+
 	if (sc->sc_flags & SC_OP_INVALID) {
 		DPRINTF(sc, ATH_DBG_ANY, "Device not present\n");
 		return;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 170c5b3..4d5865c 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -142,6 +142,9 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
+	device_init_wakeup(&pdev->dev, 1);
+	device_set_wakeup_enable(&pdev->dev, 0);
+
 	ret = pci_request_region(pdev, 0, "ath9k");
 	if (ret) {
 		dev_err(&pdev->dev, "PCI memory region reserve error\n");
@@ -192,6 +195,14 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	sc->irq = pdev->irq;
 
+	/* WoW is for PCI for ath9k */
+
+	/*
+	 * Bmiss and link change triggers not yet fully tested, add them
+	 * after properly testing and confirming behaviour.
+	 */
+	hw->wiphy->wow_triggers_supported = NL80211_WOW_TRIGGER_MAGIC_PACKET;
+
 	ah = sc->sc_ah;
 	printk(KERN_INFO
 	       "%s: Atheros AR%s MAC/BB Rev:%x "
@@ -228,21 +239,109 @@ static void ath_pci_remove(struct pci_dev *pdev)
 
 #ifdef CONFIG_PM
 
+static u32 ath9k_wow_event_map(u32 cfg_wow_events)
+{
+	u32 wow_events = 0;
+
+	if (cfg_wow_events & NL80211_WOW_TRIGGER_MAGIC_PACKET)
+		wow_events |= AH_WOW_MAGIC_PATTERN_EN;
+	if (cfg_wow_events & NL80211_WOW_TRIGGER_BMISS)
+		wow_events |= AH_WOW_BEACON_MISS;
+	if (cfg_wow_events & NL80211_WOW_TRIGGER_LINK_CHANGE)
+		wow_events |= AH_WOW_LINK_CHANGE;
+
+	return wow_events;
+}
+
+static void ath9k_pci_wow_enable(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	u32 wake_up_events;
+
+	wake_up_events = ath9k_wow_event_map(sc->wow_triggers_enabled);
+
+	/* eventually we'll add this...
+	 * if (wake_up_events & AH_WOW_USER_PATTERN_EN)
+	 *	ath9k_wow_create_pattern(sc);
+	 */
+
+	/*
+	 * To avoid false wake, we enable beacon miss interrupt only when
+	 * we go to sleep. We save the current interrupt mask so that
+	 * we can restore it after the system wakes up.
+	 */
+	sc->wow_intr_before_sleep = ah->mask_reg;
+	ath9k_hw_set_interrupts(ah, ATH9K_INT_BMISS | ATH9K_INT_GLOBAL);
+	sc->imask = ATH9K_INT_BMISS | ATH9K_INT_GLOBAL;
+
+	ath9k_hw_wow_enable(ah, wake_up_events);
+	device_set_wakeup_enable(sc->dev, 1);
+
+	DPRINTF(sc, ATH_DBG_ANY,
+		"WoW enabled\n");
+
+	sc->wow_sleep_proc_intr = true;
+}
+
 static int ath_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
+	if (!!sc->wow_triggers_enabled && device_can_wakeup(&pdev->dev))
+		ath9k_pci_wow_enable(sc);
+
 	ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 1);
 
 	pci_save_state(pdev);
 	pci_disable_device(pdev);
+
+	if (!!sc->wow_triggers_enabled && device_can_wakeup(&pdev->dev)) {
+		pci_prepare_to_sleep(pdev);
+		return 0;
+	}
+
+	pci_wake_from_d3(pdev, !!sc->wow_triggers_enabled);
 	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
 }
 
+static void ath9k_pci_wow_wake(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	u32 wow_status;
+
+	ath9k_hw_set_interrupts(ah, sc->wow_intr_before_sleep);
+	sc->imask = sc->wow_intr_before_sleep;
+
+	wow_status = ath9k_hw_wow_wake_up(sc->sc_ah);
+
+	if (sc->wow_got_bmiss_intr) {
+		/*
+		 * Some devices may not pick beacon miss
+		 * as the reason they woke up so we add that
+		 * here for that shortcoming
+		 */
+		wow_status |= AH_WOW_BEACON_MISS;
+		sc->wow_got_bmiss_intr = false;
+		DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+			"Beacon miss interrupt picked up during sleep, "
+			"adding as possible wake up reason\n");
+	}
+
+	if (wow_status) {
+		DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+			"Waking up due to WoW trigger%s\n",
+			ath9k_hw_wow_event_to_string(wow_status));
+		DPRINTF(ah->ah_sc, ATH_DBG_ANY,
+			"WoW status: %d\n WoW reason: %s\n",
+			wow_status,
+			ath9k_hw_wow_event_to_string((wow_status & 0x0FFF)));
+	}
+}
+
 static int ath_pci_resume(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
@@ -264,6 +363,9 @@ static int ath_pci_resume(struct pci_dev *pdev)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
+	if (sc->wow_triggers_enabled)
+		ath9k_pci_wow_wake(sc);
+
 	/* Enable LED */
 	ath9k_hw_cfg_output(sc->sc_ah, ATH_LED_PIN,
 			    AR_GPIO_OUTPUT_MUX_AS_OUTPUT);
diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index 5260524..387bbe7 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -665,6 +665,11 @@
 #define AR_RC_HOSTIF         0x00000100
 
 #define AR_WA                		0x4004
+#define AR_WA_UNTIE_RESET_EN	(1 << 15)   /* Enable PCI Reset to POR (power-on-reset) */
+#define AR_WA_RESET_EN		(1 << 18)   /* Sw Control to enable PCI-Reset to POR (bit 15) */
+#define AR_WA_ANALOG_SHIFT	(1 << 20)
+#define AR_WA_POR_SHORT		(1 << 21)   /* PCI-E Phy reset control */
+
 #define AR9285_WA_DEFAULT 		0x004a05cb
 #define AR9280_WA_DEFAULT           	0x0040073f
 #define AR_WA_DEFAULT               	0x0000073f
@@ -1508,4 +1513,153 @@ enum {
 #define AR_KEYTABLE_MAC0(_n)    (AR_KEYTABLE(_n) + 24)
 #define AR_KEYTABLE_MAC1(_n)    (AR_KEYTABLE(_n) + 28)
 
+/* WoW - Wake On Wireless */
+
+#define AR_PMCTRL_AUX_PWR_DET		0x10000000  /* Puts Chip in L2 state */
+#define AR_PMCTRL_D3COLD_VAUX		0x00800000
+#define AR_PMCTRL_HOST_PME_EN		0x00400000    /* Send OOB WAKE_L on WoW event */
+#define AR_PMCTRL_WOW_PME_CLR		0x00200000    /* Clear WoW event */
+#define AR_PMCTRL_PWR_STATE_MASK	0x0F000000    /* Power State Mask */
+#define AR_PMCTRL_PWR_STATE_D1D3	0x0F000000    /* Activate D1 and D3 */
+#define AR_PMCTRL_PWR_STATE_D0		0x08000000    /* Activate D0 */
+#define AR_PMCTRL_PWR_PM_CTRL_ENA	0x00008000    /* Enable power management */
+
+#define AR_WOW_BEACON_TIMO_MAX		0xFFFFFFFF  /* Max. value for Beacon Timeout */
+
+/*
+ * MAC WoW Registers.
+ */
+#define AR_WOW_PATTERN_REG		0x825C
+#define AR_WOW_COUNT_REG		0x8260
+#define AR_WOW_BCN_EN_REG		0x8270
+#define AR_WOW_BCN_TIMO_REG		0x8274
+#define AR_WOW_KEEP_ALIVE_TIMO_REG	0x8278
+#define AR_WOW_KEEP_ALIVE_REG		0x827C
+#define AR_WOW_US_SCALAR_REG		0x8284
+#define AR_WOW_KEEP_ALIVE_DELAY_REG	0x8288
+#define AR_WOW_PATTERN_MATCH_REG	0x828C
+#define AR_WOW_PATTERN_OFF1_REG		0x8290 /* Pattern bytes 0 -> 3 */
+#define AR_WOW_PATTERN_OFF2_REG		0x8294 /* Pattern bytes 4 -> 7 */
+/* For AR9285 or Later version of chips */
+#define AR_WOW_EXACT_REG		0x829C
+#define AR_WOW_LENGTH1_REG		0x8360
+#define AR_WOW_LENGTH2_REG		0x8364
+/* Register to enable pattern match for less than 256 bytes packets */
+#define AR_WOW_PATTERN_MATCH_LT_256B_REG	0x8368
+
+/* AR_WOW_PATTERN_REG Values */
+#define AR_WOW_BACK_OFF_SHIFT(x)	((x & 0xf) << 27)    /* in usecs */
+#define AR_WOW_MAC_INTR_EN		0x00040000
+#define AR_WOW_MAGIC_EN			0x00010000
+#define AR_WOW_PATTERN_EN(x)		((x & 0xff) << 0)
+#define AR_WOW_PATTERN_FOUND_SHIFT	8
+#define AR_WOW_PATTERN_FOUND(x)		(x & (0xff << AR_WOW_PATTERN_FOUND_SHIFT))
+#define AR_WOW_PATTERN_FOUND_MASK	((0xff) << AR_WOW_PATTERN_FOUND_SHIFT)
+#define AR_WOW_MAGIC_PAT_FOUND		0x00020000
+#define AR_WOW_MAC_INTR			0x00080000
+#define AR_WOW_KEEP_ALIVE_FAIL		0x00100000
+#define AR_WOW_BEACON_FAIL		0x00200000
+
+#define AR_WOW_STATUS(x)	(x & (AR_WOW_PATTERN_FOUND_MASK | \
+				      AR_WOW_MAGIC_PAT_FOUND | \
+				      AR_WOW_KEEP_ALIVE_FAIL | \
+				      AR_WOW_BEACON_FAIL))
+#define AR_WOW_CLEAR_EVENTS(x)	(x & ~(AR_WOW_PATTERN_EN(0xff) | \
+				       AR_WOW_MAGIC_EN | \
+				       AR_WOW_MAC_INTR_EN | \
+				       AR_WOW_BEACON_FAIL | \
+				       AR_WOW_KEEP_ALIVE_FAIL))
+
+/* AR_WOW_COUNT_REG Values */
+#define AR_WOW_AIFS_CNT(x)		((x & 0xff) << 0)
+#define AR_WOW_SLOT_CNT(x)		((x & 0xff) << 8)
+#define AR_WOW_KEEP_ALIVE_CNT(x)	((x & 0xff) << 16)
+
+/* AR_WOW_BCN_EN_REG */
+#define AR_WOW_BEACON_FAIL_EN		0x00000001
+
+/* AR_WOW_BCN_TIMO_REG */
+#define AR_WOW_BEACON_TIMO		0x40000000  /* Valid if BCN_EN is set */
+
+/* AR_WOW_KEEP_ALIVE_TIMO_REG */
+#define AR_WOW_KEEP_ALIVE_TIMO		0x00007A12
+#define AR_WOW_KEEP_ALIVE_NEVER		0xFFFFFFFF
+
+/* AR_WOW_KEEP_ALIVE_REG */
+#define AR_WOW_KEEP_ALIVE_AUTO_DIS	0x00000001
+#define AR_WOW_KEEP_ALIVE_FAIL_DIS	0x00000002
+
+/* AR_WOW_KEEP_ALIVE_DELAY_REG */
+#define AR_WOW_KEEP_ALIVE_DELAY		0x000003E8 /* 1 msec */
+
+/*
+ * Keep it long for Beacon workaround - ensures no false alarm
+ */
+#define AR_WOW_BMISSTHRESHOLD 0x20
+
+/* AR_WOW_PATTERN_MATCH_REG */
+#define AR_WOW_PAT_END_OF_PKT(x)	((x & 0xf) << 0)
+#define AR_WOW_PAT_OFF_MATCH(x)		((x & 0xf) << 8)
+
+/*
+ * Default values for Wow Configuration for backoff, aifs, slot, keep-alive, etc
+ * to be programmed into various registers.
+ */
+#define AR_WOW_PAT_BACKOFF	0x00000004 /* AR_WOW_PATTERN_REG */
+#define AR_WOW_CNT_AIFS_CNT	0x00000022 /* AR_WOW_COUNT_REG */
+#define AR_WOW_CNT_SLOT_CNT	0x00000009 /* AR_WOW_COUNT_REG */
+/*
+ * Keepalive count applicable for AR9280 2.0 and above.
+ */
+#define AR_WOW_CNT_KA_CNT 0x00000008    /* AR_WOW_COUNT_REG */
+
+/* WoW - Transmit buffer for keep alive frames */
+#define AR_WOW_TRANSMIT_BUFFER	0xE000 /* E000 - EFFC */
+
+#define AR_WOW_KA_DESC_WORD2	0xE000
+#define AR_WOW_KA_DESC_WORD3	0xE004
+#define AR_WOW_KA_DESC_WORD4	0xE008
+#define AR_WOW_KA_DESC_WORD5	0xE00C
+#define AR_WOW_KA_DESC_WORD6	0xE010
+#define AR_WOW_KA_DESC_WORD7	0xE014
+#define AR_WOW_KA_DESC_WORD8	0xE018
+#define AR_WOW_KA_DESC_WORD9	0xE01C
+#define AR_WOW_KA_DESC_WORD10	0xE020
+#define AR_WOW_KA_DESC_WORD11	0xE024
+#define AR_WOW_KA_DESC_WORD12	0xE028
+#define AR_WOW_KA_DESC_WORD13	0xE02C
+
+#define AR_WOW_KA_DATA_WORD0	0xE030
+#define AR_WOW_KA_DATA_WORD1	0xE034
+#define AR_WOW_KA_DATA_WORD2	0xE038
+#define AR_WOW_KA_DATA_WORD3	0xE03C
+#define AR_WOW_KA_DATA_WORD4	0xE040
+#define AR_WOW_KA_DATA_WORD5	0xE044
+
+/* WoW Transmit Buffer for patterns */
+#define AR_WOW_TB_PATTERN0	0xE100
+#define AR_WOW_TB_PATTERN1	0xE200
+#define AR_WOW_TB_PATTERN2	0xE300
+#define AR_WOW_TB_PATTERN3	0xE400
+#define AR_WOW_TB_PATTERN4	0xE500
+#define AR_WOW_TB_PATTERN5	0xE600
+#define AR_WOW_TB_PATTERN6	0xE700
+#define AR_WOW_TB_PATTERN7	0xE800
+#define AR_WOW_TB_MASK0		0xEC00
+#define AR_WOW_TB_MASK1		0xEC20
+#define AR_WOW_TB_MASK2		0xEC40
+#define AR_WOW_TB_MASK3		0xEC60
+#define AR_WOW_TB_MASK4		0xEC80
+#define AR_WOW_TB_MASK5		0xECa0
+#define AR_WOW_TB_MASK6		0xECC0
+#define AR_WOW_TB_MASK7		0xECE0
+
+/* Currently Pattern 0-7 are supported - so bit 0-7 are set */
+#define AR_WOW_PATTERN_SUPPORTED	0xFF
+#define AR_WOW_LENGTH_MAX		0xFF
+#define AR_WOW_LENGTH1_SHIFT(_i)	((0x3 - ((_i) & 0x3)) << 0x3)
+#define AR_WOW_LENGTH1_MASK(_i)		(AR_WOW_LENGTH_MAX << AR_WOW_LENGTH1_SHIFT(_i))
+#define AR_WOW_LENGTH2_SHIFT(_i)	((0x7 - ((_i) & 0x7)) << 0x3)
+#define AR_WOW_LENGTH2_MASK(_i)		(AR_WOW_LENGTH_MAX << AR_WOW_LENGTH2_SHIFT(_i))
+
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
new file mode 100644
index 0000000..ca9073c
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -0,0 +1,511 @@
+/*
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
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
+#include "reg.h"
+
+#ifdef CONFIG_PM
+
+/*
+ * This routine is called to configure the SerDes register for the
+ * AR9280 2.0 and above chip during WOW sleep.
+ */
+static void
+ath9k_ar928xConfigSerDes_WowSleep(struct ath_hw *ah)
+{
+	unsigned int i;
+
+	/*
+	 * For WOW sleep, we reprogram the SerDes so that the PLL and CHK REQ
+	 * are both enabled. This uses more power but in certain cases this
+	 * is required as otherwise WOW sleep is unstable and chip may
+	 * disappears.
+	 */
+	for (i = 0; i < ah->iniPcieSerdesWow.ia_rows; i++)
+		REG_WRITE(ah,
+			  INI_RA(&ah->iniPcieSerdesWow, i, 0),
+			  INI_RA(&ah->iniPcieSerdesWow, i, 1));
+	udelay(1000);
+}
+
+static bool ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
+{
+	u32 frame_len = 28;
+	u32 tpc = 0x3f;
+	u32 antenna_mode = 1;
+	u32 transmit_rate;
+	u32 frame_type = 0x2; /* Frame Type -> Data */
+	u32 sub_type = 0x4; /* Subtype -> Null Data */
+	u32 to_ds = 1;
+	u32 duration_id = 0x3d;
+	u8 *StaMacAddr, *ApMacAddr;
+	u8 *addr1, *addr2, *addr3;
+	u32 ctl[12] = { 0 };
+	u32 data_word0 = 0, data_word1 = 0, data_word2 = 0,
+	data_word3 = 0, data_word4 = 0, data_word5 = 0;
+	u32 i;
+
+	StaMacAddr = (u8 *)ah->macaddr;
+	ApMacAddr = (u8 *)ah->ah_sc->curbssid;
+	addr2 = StaMacAddr;
+	addr1 = addr3 = ApMacAddr;
+
+	/*
+	 * XXX: we need a way to determine if the AP we're on
+	 * is using CCK only and if so use this:
+	 * transmit_rate = 0x1B; // CCK_1M
+	 * For now we just assume your AP supports OFDM
+	 */
+	transmit_rate = 0xB; /* OFDM_6M */
+
+	/* Set the Transmit Buffer. */
+	ctl[0] = (frame_len | (tpc << 16)) + (antenna_mode << 25);
+	ctl[1] = 0;
+	ctl[2] = 0x7 << 16; /* tx_tries0 */
+	ctl[3] = transmit_rate;
+	ctl[4] = 0;
+	ctl[7] = ah->txchainmask << 2;
+
+	for (i = 0; i < 12; i++)
+		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + i * 4), ctl[i]);
+
+	data_word0 = (frame_type << 2) | (sub_type << 4) |
+		     (to_ds << 8) | (duration_id << 16);
+	data_word1 = (((u32)addr1[3] << 24) | ((u32)addr1[2] << 16) |
+		     ((u32)addr1[1]) << 8 | ((u32)addr1[0]));
+	data_word2 = (((u32)addr2[1] << 24) | ((u32)addr2[0] << 16) |
+		     ((u32)addr1[5]) << 8 | ((u32)addr1[4]));
+	data_word3 = (((u32)addr2[5] << 24) | ((u32)addr2[4] << 16) |
+		     ((u32)addr2[3]) << 8 | ((u32)addr2[2]));
+	data_word4 = (((u32)addr3[3] << 24) | ((u32)addr3[2] << 16) |
+		     ((u32)addr3[1]) << 8 | (u32)addr3[0]);
+	data_word5 = (((u32)addr3[5]) << 8 | ((u32)addr3[4]));
+
+	REG_WRITE(ah, AR_WOW_KA_DATA_WORD0, data_word0);
+	REG_WRITE(ah, AR_WOW_KA_DATA_WORD1, data_word1);
+	REG_WRITE(ah, AR_WOW_KA_DATA_WORD2, data_word2);
+	REG_WRITE(ah, AR_WOW_KA_DATA_WORD3, data_word3);
+	REG_WRITE(ah, AR_WOW_KA_DATA_WORD4, data_word4);
+	REG_WRITE(ah, AR_WOW_KA_DATA_WORD5, data_word5);
+
+	return true;
+}
+
+/* TBD: Should querying hw for hardware capability */
+#define MAX_PATTERN_SIZE	256
+#define MAX_PATTERN_MASK_SIZE	32
+
+/* Deducting the disassociate/deauthenticate packets */
+#define MAX_NUM_USER_PATTERN	6
+
+# if 0
+static void ath9k_wow_apply_pattern(struct ath_hw *ah,
+				    u8 *pAthPattern, u8 *pAthMask,
+				    int pattern_count, u32 athPatternLen)
+{
+	unsigned int i;
+	u32 reg_pat[] = {
+		AR_WOW_TB_PATTERN0,
+		AR_WOW_TB_PATTERN1,
+		AR_WOW_TB_PATTERN2,
+		AR_WOW_TB_PATTERN3,
+		AR_WOW_TB_PATTERN4,
+		AR_WOW_TB_PATTERN5,
+		AR_WOW_TB_PATTERN6,
+		AR_WOW_TB_PATTERN7
+	};
+	u32 reg_mask[] = {
+		AR_WOW_TB_MASK0,
+		AR_WOW_TB_MASK1,
+		AR_WOW_TB_MASK2,
+		AR_WOW_TB_MASK3,
+		AR_WOW_TB_MASK4,
+		AR_WOW_TB_MASK5,
+		AR_WOW_TB_MASK6,
+		AR_WOW_TB_MASK7
+	};
+	u32 pattern_val;
+	u32 mask_val;
+	u8 mask_bit = 0x1;
+	u8 pattern;
+
+	/* TBD: should check count by querying the hardware capability */
+	if (pattern_count >= MAX_NUM_USER_PATTERN)
+		return;
+
+	pattern = (u8)REG_READ(ah, AR_WOW_PATTERN_REG);
+	pattern = pattern | (mask_bit << pattern_count);
+	REG_WRITE(ah, AR_WOW_PATTERN_REG, pattern);
+
+	/* Set the registers for pattern */
+	for (i = 0; i < MAX_PATTERN_SIZE; i+=4) {
+		pattern_val = (((u32)pAthPattern[i]) |
+			      ((u32)pAthPattern[i+1] << 8) |
+			      ((u32)pAthPattern[i+2] << 16) |
+			      ((u32)pAthPattern[i+3] << 24));
+		REG_WRITE(ah, (reg_pat[pattern_count] + i), pattern_val);
+	}
+
+	/* Set the registers for mask */
+	for (i = 0; i < MAX_PATTERN_MASK_SIZE; i+=4) {
+		mask_val = (((u32)pAthMask[i]) |
+			   ((u32)pAthMask[i+1] << 8) |
+			   ((u32)pAthMask[i+2] << 16) |
+			   ((u32)pAthMask[i+3] << 24));
+		REG_WRITE(ah, (reg_mask[pattern_count] + i), mask_val);
+	}
+
+	if (AR_SREV_9285_10_OR_LATER(ah)) {
+		/* Set the pattern length to be matched */
+		u32 val;
+		if (pattern_count < 4) {
+			/* Pattern 0-3 uses AR_WOW_LENGTH1_REG register */
+			val = REG_READ(ah, AR_WOW_LENGTH1_REG);
+			val = ((val & (~AR_WOW_LENGTH1_MASK(pattern_count))) |
+			      ((athPatternLen & AR_WOW_LENGTH_MAX)
+				<< AR_WOW_LENGTH1_SHIFT(pattern_count)));
+			REG_WRITE(ah, AR_WOW_LENGTH1_REG, val);
+		} else {
+			/* Pattern 4-7 uses AR_WOW_LENGTH2_REG register */
+			val = REG_READ(ah, AR_WOW_LENGTH2_REG);
+			val = ((val & (~AR_WOW_LENGTH2_MASK(pattern_count))) |
+			      ((athPatternLen & AR_WOW_LENGTH_MAX)
+				<< AR_WOW_LENGTH2_SHIFT(pattern_count)));
+			REG_WRITE(ah, AR_WOW_LENGTH2_REG, val);
+		}
+	}
+
+	ah->ah_wowEventMask |=
+		(1 << (pattern_count + AR_WOW_PATTERN_FOUND_SHIFT));
+}
+#endif
+
+static bool ath9k_set_power_mode_wow_sleep(struct ath_hw *ah)
+{
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+
+	REG_WRITE(ah, AR_CR, AR_CR_RXD); /* Set receive disable bit */
+	if (!ath9k_hw_wait(ah, AR_CR, AR_CR_RXE, 0, AH_WAIT_TIMEOUT)) {
+		DPRINTF(ah->ah_sc, ATH_DBG_CONFIG,
+			"dma failed to stop in 10ms\n"
+			"AR_CR=0x%08x\nAR_DIAG_SW=0x%08x\n",
+			REG_READ(ah, AR_CR),
+			REG_READ(ah, AR_DIAG_SW));
+		return false;
+	} else {
+		REG_WRITE(ah, AR_RXDP, 0x0);
+
+		/* AR9280 2.0/2.1 WOW has sleep issue, do not set it to sleep */
+		if (AR_SREV_9280_20(ah))
+			return true;
+		else
+			REG_WRITE(ah, AR_RTC_FORCE_WAKE,
+				  AR_RTC_FORCE_WAKE_ON_INT);
+		return true;
+	}
+}
+
+void ath9k_hw_wow_enable(struct ath_hw *ah, u32 patternEnable)
+{
+	u32 init_val, val, rval = 0;
+	/* Send a Keep-Alive frame every 900 millisec */
+	const int ka_timo = 900;
+	/* Delay of 4 millisec between two KeepAlive's */
+	const int ka_delay = 4;
+	u32 wow_event_mask;
+
+	/*
+	 * ah_wowEventMask is a mask to the AR_WOW_PATTERN_REG register to
+	 * indicate which WOW events that we have enabled. The WOW Events
+	 * are from the patternEnable in this function and pattern_count of
+	 * ath9k_wow_apply_pattern()
+	 */
+	wow_event_mask = ah->ah_wowEventMask;
+
+	/*
+	 * Untie Power-On-Reset from the PCI-E Reset. When we are in WOW sleep,
+	 * we do not want the Reset from the PCI-E to disturb our hw state.
+	 */
+	if (AR_SREV_9280_20_OR_LATER(ah) && ah->is_pciexpress) {
+		/*
+		 * We need to untie the internal POR (power-on-reset) to the
+		 * external PCI-E reset. We also need to tie the PCI-E Phy
+		 * reset to the PCI-E reset.
+		 */
+		u32 wa_reg_val;
+		if (AR_SREV_9285(ah))
+			wa_reg_val = AR9285_WA_DEFAULT;
+		else
+			wa_reg_val = AR9280_WA_DEFAULT;
+		wa_reg_val = wa_reg_val & ~(AR_WA_UNTIE_RESET_EN);
+		wa_reg_val = wa_reg_val | AR_WA_RESET_EN | AR_WA_POR_SHORT;
+		REG_WRITE(ah, AR_WA, wa_reg_val);
+
+		if (!AR_SREV_9285(ah) || AR_SREV_9285_12_OR_LATER(ah)) {
+			/*
+			 * For WOW sleep, we reprogram the SerDes so that the
+			 * PLL and CHK REQ are both enabled. This uses more
+			 * power but otherwise in certain cases, WOW sleep is
+			 * unusable and chip may disappears.
+			 */
+			ath9k_ar928xConfigSerDes_WowSleep(ah);
+		}
+	}
+
+	/*
+	 * Set the power states appropriately and enable pme.
+	 */
+	val = REG_READ(ah, AR_PCIE_PM_CTRL);
+	val |= AR_PMCTRL_HOST_PME_EN |
+	       AR_PMCTRL_PWR_PM_CTRL_ENA |
+	       AR_PMCTRL_AUX_PWR_DET;
+	val &= ~AR_PMCTRL_WOW_PME_CLR;
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, val);
+
+	/*
+	 * Setup for:
+	 *     - beacon misses
+	 *     - magic pattern
+	 *     - keep alive timeout
+	 *     - pattern matching
+	 */
+
+	/*
+	 * Program some default values for keep-alives, beacon misses, etc.
+	 */
+	init_val = REG_READ(ah, AR_WOW_PATTERN_REG);
+	val = AR_WOW_BACK_OFF_SHIFT(AR_WOW_PAT_BACKOFF) | init_val;
+	REG_WRITE(ah, AR_WOW_PATTERN_REG, val);
+	rval = REG_READ(ah, AR_WOW_PATTERN_REG);
+
+	init_val = REG_READ(ah, AR_WOW_COUNT_REG);
+	val = AR_WOW_AIFS_CNT(AR_WOW_CNT_AIFS_CNT) | \
+	      AR_WOW_SLOT_CNT(AR_WOW_CNT_SLOT_CNT) | \
+	AR_WOW_KEEP_ALIVE_CNT(AR_WOW_CNT_KA_CNT);
+	REG_WRITE(ah, AR_WOW_COUNT_REG, val);
+	rval = REG_READ(ah, AR_WOW_COUNT_REG);
+
+
+	init_val = REG_READ(ah, AR_WOW_BCN_TIMO_REG);
+	if (patternEnable & AH_WOW_BEACON_MISS)
+		val = AR_WOW_BEACON_TIMO;
+	else
+		/* We are not using the beacon miss. Program a large value. */
+		val = AR_WOW_BEACON_TIMO_MAX;
+	REG_WRITE(ah, AR_WOW_BCN_TIMO_REG, val);
+
+	init_val = REG_READ(ah, AR_WOW_KEEP_ALIVE_TIMO_REG);
+
+	/*
+	 * Keep Alive Timo in ms.
+	 */
+	if (patternEnable == 0)
+		val =  AR_WOW_KEEP_ALIVE_NEVER;
+	else
+		val =  ka_timo * 32;
+	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_TIMO_REG, val);
+	rval = REG_READ(ah, AR_WOW_KEEP_ALIVE_TIMO_REG);
+
+	init_val = REG_READ(ah, AR_WOW_KEEP_ALIVE_DELAY_REG);
+	/*
+	 * Keep Alive delay in us.
+	 */
+	val = ka_delay * 1000;
+	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_DELAY_REG, val);
+	rval = REG_READ(ah, AR_WOW_KEEP_ALIVE_DELAY_REG);
+
+	/*
+	 * Create KeepAlive Pattern to respond to beacons.
+	 */
+	ath9k_wow_create_keep_alive_pattern(ah);
+
+	/*
+	 * Configure Mac Wow Registers.
+	 */
+
+	val = REG_READ(ah, AR_WOW_KEEP_ALIVE_REG);
+	/*
+	 * Send keep alive timeouts anyway.
+	 */
+	val &= ~AR_WOW_KEEP_ALIVE_AUTO_DIS;
+
+	if (patternEnable & AH_WOW_LINK_CHANGE) {
+		val &= ~ AR_WOW_KEEP_ALIVE_FAIL_DIS;
+		wow_event_mask |= AR_WOW_KEEP_ALIVE_FAIL;
+	} else
+		val |=  AR_WOW_KEEP_ALIVE_FAIL_DIS;
+
+	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_REG, val);
+	val = REG_READ(ah, AR_WOW_BCN_EN_REG);
+
+	/*
+	 * We are relying on a bmiss failure. Ensure we have enough
+	 * threshold to prevent false positives.
+	 */
+	REG_RMW_FIELD(ah, AR_RSSI_THR, AR_RSSI_THR_BM_THR,
+		      AR_WOW_BMISSTHRESHOLD);
+
+	/*
+	 * Beacon miss & user pattern events do not work on AR5416.
+	 * We enable beacon miss wow pattern only for AR9280...
+	 */
+	if (!AR_SREV_9280_10_OR_LATER(ah))
+		patternEnable &= ~AH_WOW_BEACON_MISS;
+
+	if (patternEnable & AH_WOW_BEACON_MISS) {
+		val |= AR_WOW_BEACON_FAIL_EN;
+		wow_event_mask |= AR_WOW_BEACON_FAIL;
+	} else
+		val &= ~AR_WOW_BEACON_FAIL_EN;
+
+	REG_WRITE(ah, AR_WOW_BCN_EN_REG, val);
+
+	/*
+	 * Enable the magic packet registers.
+	 */
+	val = REG_READ(ah, AR_WOW_PATTERN_REG);
+	if (patternEnable & AH_WOW_MAGIC_PATTERN_EN) {
+		val |= AR_WOW_MAGIC_EN;
+		wow_event_mask |= AR_WOW_MAGIC_PAT_FOUND;
+	} else
+		val &= ~AR_WOW_MAGIC_EN;
+
+	val |= AR_WOW_MAC_INTR_EN;
+	REG_WRITE(ah, AR_WOW_PATTERN_REG, val);
+
+	/*
+	 * For AR9285 and later version of the chips
+	 * enable wow pattern match for packets less than
+	 * 256 bytes for all patterns.
+	 */
+	if (AR_SREV_9285_10_OR_LATER(ah))
+		REG_WRITE(ah, AR_WOW_PATTERN_MATCH_LT_256B_REG,
+			  AR_WOW_PATTERN_SUPPORTED);
+
+	/*
+	 * Set the power states appropriately and enable pme.
+	 */
+	val = REG_READ(ah, AR_PCIE_PM_CTRL);
+	val |=  AR_PMCTRL_PWR_STATE_D1D3 |
+		AR_PMCTRL_HOST_PME_EN |
+		AR_PMCTRL_PWR_PM_CTRL_ENA;
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, val);
+
+	ath9k_set_power_mode_wow_sleep(ah);
+
+	ah->ah_wowEventMask = wow_event_mask;
+}
+
+u32 ath9k_hw_wow_wake_up(struct ath_hw *ah)
+{
+	u32 wowStatus = 0;
+	u32 val = 0, rval;
+
+	/*
+	 * Read the WOW Status register to know the wakeup reason.
+	 */
+	rval = REG_READ(ah, AR_WOW_PATTERN_REG);
+	val = AR_WOW_STATUS(rval);
+
+	/*
+	 * Mask only the WOW events that we have enabled. Sometimes, we have
+	 * spurious WOW events from the AR_WOW_PATTERN_REG register. This mask
+	 * will clean it up.
+	 */
+	val &= ah->ah_wowEventMask;
+
+	if (val) {
+		if (val & AR_WOW_MAGIC_PAT_FOUND)
+			wowStatus |= AH_WOW_MAGIC_PATTERN_EN;
+		if (AR_WOW_PATTERN_FOUND(val))
+			wowStatus |= AH_WOW_USER_PATTERN_EN;
+		if (val & AR_WOW_KEEP_ALIVE_FAIL)
+			wowStatus |= AH_WOW_LINK_CHANGE;
+		if (val & AR_WOW_BEACON_FAIL)
+			wowStatus |= AH_WOW_BEACON_MISS;
+	}
+
+	/*
+	 * Set and clear WOW_PME_CLEAR registers for the chip to generate next
+	 * wow signal. Disable D3 before accessing other registers ?
+	 */
+	val = REG_READ(ah, AR_PCIE_PM_CTRL);
+	/* Do we have to check the bit value 0x01000000 (7-10) ?? */
+	val &= ~AR_PMCTRL_PWR_STATE_D1D3;
+	val |= AR_PMCTRL_WOW_PME_CLR;
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, val);
+
+	/*
+	 * Clear all events.
+	 */
+	REG_WRITE(ah, AR_WOW_PATTERN_REG,
+		  AR_WOW_CLEAR_EVENTS(REG_READ(ah, AR_WOW_PATTERN_REG)));
+
+	/*
+	 * Tie reset register.
+	 * NB: Not tieing it back might have some repurcussions.
+	 */
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		REG_WRITE(ah, AR_WA, REG_READ(ah, AR_WA) |
+				     AR_WA_UNTIE_RESET_EN |
+				     AR_WA_POR_SHORT |
+				     AR_WA_RESET_EN);
+	}
+
+	/* Restore the Beacon Threshold to init value */
+	REG_WRITE(ah, AR_RSSI_THR, INIT_RSSI_THR);
+
+	/*
+	 * Restore the way the PCI-E Reset, Power-On-Reset, external
+	 * PCIE_POR_SHORT pins are tied to its original value. Previously
+	 * just before WOW sleep, we untie the PCI-E Reset to our Chip's
+	 * Power On Reset so that any PCI-E reset from the bus will not
+	 * reset our chip.
+	 */
+	if (AR_SREV_9280_20_OR_LATER(ah) && ah->is_pciexpress)
+		ath9k_hw_configpcipowersave(ah, 0);
+
+	ah->ah_wowEventMask = 0;
+
+	return wowStatus;
+}
+
+void ath9k_wow_set_gpio_reset_low(struct ath_hw *ah)
+{
+    u32 val;
+
+    val = REG_READ(ah, AR_GPIO_OE_OUT);
+    val |= (1 << (2 * 2));
+    REG_WRITE(ah, AR_GPIO_OE_OUT, val);
+    val = REG_READ(ah, AR_GPIO_OE_OUT);
+    val = REG_READ(ah,AR_GPIO_IN_OUT );
+}
+
+const char *
+ath9k_hw_wow_event_to_string(u32 wow_event)
+{
+	if (wow_event & AH_WOW_MAGIC_PATTERN_EN)
+		return "Magic pattern";
+	if (wow_event & AH_WOW_USER_PATTERN_EN)
+		return "User pattern";
+	if (wow_event & AH_WOW_LINK_CHANGE)
+		return "Link change";
+	if (wow_event & AH_WOW_BEACON_MISS)
+		return "Beacon miss";
+	return "Uknown reason";
+}
+
+#endif /* CONFIG_PM */
-- 
1.6.0.6

