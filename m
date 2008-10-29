Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:59918 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbYJ2C2t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 22:28:49 -0400
Date: Wed, 29 Oct 2008 04:28:28 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Update PCU code
Message-ID: <20081029022828.GA7376@makis> (sfid-20081029_032854_484005_20FDAC3A)
References: <20081029021121.GA3079@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081029021121.GA3079@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * In set_opmode don't handle antenna settings and preserve other STA_ID1 settings
 (shouldn't matter because we call it during reset but it makes things cleaner)
 Also set properly AP/ADHOC indicator flag on CFG while setting AP/ADHOC modes
 and always enable key search mode.

 * Properly set BSSID Mask during reset (cache it and reuse it durring set_associd)

 * Update beacon_init to flush pending BMISS interrupts and handle setting of adhoc
 beacon ATIM policy flag for ad-hoc mode. Also set TSF to 0 to start TSF increment
 on AP mode. We need to handle sleep timers for AR5212 there + add support for PCF.
 
 * Properly clean MIC key from keytable when TKIP is used (Bob is working on set_key
 function etc so i leave it for now).

 Tested on AR5212 (Hainan) and AR5413 and works fine

 v2 Set PISR on AR5211+ and ISR on AR5210, got to sleep more ;-)

 Changes-Licensed-under: ISC
 Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index b117920..a725bb9 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -1093,10 +1093,11 @@ struct ath5k_hw {
 
 	u8			ah_sta_id[ETH_ALEN];
 
-	/* Current BSSID we are trying to assoc to / creating.
+	/* Current BSSID we are trying to assoc to / create.
 	 * This is passed by mac80211 on config_interface() and cached here for
 	 * use in resets */
 	u8			ah_bssid[ETH_ALEN];
+	u8			ah_bssid_mask[ETH_ALEN];
 
 	u32			ah_gpio[AR5K_MAX_GPIO];
 	int			ah_gpio_npins;
diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
index a47df9a..5674639 100644
--- a/drivers/net/wireless/ath5k/pcu.c
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -46,34 +46,45 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
 {
 	u32 pcu_reg, beacon_reg, low_id, high_id;
 
-	pcu_reg = 0;
+
+	/* Preserve rest settings */
+	pcu_reg = ath5k_hw_reg_read(ah, AR5K_STA_ID1) & 0xffff0000;
+	pcu_reg &= ~(AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_AP
+			| AR5K_STA_ID1_KEYSRCH_MODE
+			| (ah->ah_version == AR5K_AR5210 ?
+			(AR5K_STA_ID1_PWR_SV | AR5K_STA_ID1_NO_PSPOLL) : 0));
+
 	beacon_reg = 0;
 
 	ATH5K_TRACE(ah->ah_sc);
 
 	switch (ah->ah_op_mode) {
 	case NL80211_IFTYPE_ADHOC:
-		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_DESC_ANTENNA |
-			(ah->ah_version == AR5K_AR5210 ?
-				AR5K_STA_ID1_NO_PSPOLL : 0);
+		pcu_reg |= AR5K_STA_ID1_ADHOC | AR5K_STA_ID1_KEYSRCH_MODE;
 		beacon_reg |= AR5K_BCR_ADHOC;
+		if (ah->ah_version == AR5K_AR5210)
+			pcu_reg |= AR5K_STA_ID1_NO_PSPOLL;
+		else
+			AR5K_REG_DISABLE_BITS(ah, AR5K_CFG, AR5K_CFG_ADHOC);
 		break;
 
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MESH_POINT:
-		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_RTS_DEF_ANTENNA |
-			(ah->ah_version == AR5K_AR5210 ?
-				AR5K_STA_ID1_NO_PSPOLL : 0);
+		pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_KEYSRCH_MODE;
 		beacon_reg |= AR5K_BCR_AP;
+		if (ah->ah_version == AR5K_AR5210)
+			pcu_reg |= AR5K_STA_ID1_NO_PSPOLL;
+		else
+			AR5K_REG_ENABLE_BITS(ah, AR5K_CFG, AR5K_CFG_ADHOC);
 		break;
 
 	case NL80211_IFTYPE_STATION:
-		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
-			(ah->ah_version == AR5K_AR5210 ?
+		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
+			| (ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_PWR_SV : 0);
 	case NL80211_IFTYPE_MONITOR:
-		pcu_reg |= AR5K_STA_ID1_DEFAULT_ANTENNA |
-			(ah->ah_version == AR5K_AR5210 ?
+		pcu_reg |= AR5K_STA_ID1_KEYSRCH_MODE
+			| (ah->ah_version == AR5K_AR5210 ?
 				AR5K_STA_ID1_NO_PSPOLL : 0);
 		break;
 
@@ -130,6 +141,8 @@ void ath5k_hw_update_mib_counters(struct ath5k_hw *ah,
 		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_RXCLR);
 		ath5k_hw_reg_write(ah, 0, AR5K_PROFCNT_CYCLE);
 	}
+
+	/* TODO: Handle ANI stats */
 }
 
 /**
@@ -254,6 +267,10 @@ void ath5k_hw_get_lladdr(struct ath5k_hw *ah, u8 *mac)
  * @mac: The card's mac address
  *
  * Set station id on hw using the provided mac address
+ *
+ * NOTE: This is only called during attach, don't call it
+ * on reset because it overwrites all AR5K_STA_ID1 settings.
+ * We have set_opmode (above) for reset.
  */
 int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac)
 {
@@ -290,8 +307,10 @@ void ath5k_hw_set_associd(struct ath5k_hw *ah, const u8 *bssid, u16 assoc_id)
 	 * Set simple BSSID mask on 5212
 	 */
 	if (ah->ah_version == AR5K_AR5212) {
-		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM0);
-		ath5k_hw_reg_write(ah, 0xffffffff, AR5K_BSS_IDM1);
+		ath5k_hw_reg_write(ah, AR5K_LOW_ID(ah->ah_bssid_mask),
+							AR5K_BSS_IDM0);
+		ath5k_hw_reg_write(ah, AR5K_HIGH_ID(ah->ah_bssid_mask),
+							AR5K_BSS_IDM1);
 	}
 
 	/*
@@ -415,6 +434,9 @@ int ath5k_hw_set_bssid_mask(struct ath5k_hw *ah, const u8 *mask)
 	u32 low_id, high_id;
 	ATH5K_TRACE(ah->ah_sc);
 
+	/* Cache bssid mask so that we can restore it
+	 * on reset */
+	memcpy(ah->ah_bssid_mask, mask, ETH_ALEN);
 	if (ah->ah_version == AR5K_AR5212) {
 		low_id = AR5K_LOW_ID(mask);
 		high_id = AR5K_HIGH_ID(mask);
@@ -576,7 +598,7 @@ void ath5k_hw_set_rx_filter(struct ath5k_hw *ah, u32 filter)
 		filter |= AR5K_RX_FILTER_PROM;
 	}
 
-	/*Zero length DMA*/
+	/*Zero length DMA (phy error reporting) */
 	if (data)
 		AR5K_REG_ENABLE_BITS(ah, AR5K_RXCFG, AR5K_RXCFG_ZLFDMA);
 	else
@@ -661,7 +683,12 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 	 * Set the additional timers by mode
 	 */
 	switch (ah->ah_op_mode) {
+	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_STATION:
+		/* In STA mode timer1 is used as next wakeup
+		 * timer and timer2 as next CFP duration start
+		 * timer. Both in 1/8TUs. */
+		/* TODO: PCF handling */
 		if (ah->ah_version == AR5K_AR5210) {
 			timer1 = 0xffffffff;
 			timer2 = 0xffffffff;
@@ -669,27 +696,60 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 			timer1 = 0x0000ffff;
 			timer2 = 0x0007ffff;
 		}
+		/* Mark associated AP as PCF incapable for now */
+		AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, AR5K_STA_ID1_PCF);
 		break;
-
+	case NL80211_IFTYPE_ADHOC:
+		AR5K_REG_ENABLE_BITS(ah, AR5K_TXCFG, AR5K_TXCFG_ADHOC_BCN_ATIM);
 	default:
+		/* On non-STA modes timer1 is used as next DMA
+		 * beacon alert (DBA) timer and timer2 as next
+		 * software beacon alert. Both in 1/8TUs. */
 		timer1 = (next_beacon - AR5K_TUNE_DMA_BEACON_RESP) << 3;
 		timer2 = (next_beacon - AR5K_TUNE_SW_BEACON_RESP) << 3;
+		break;
 	}
 
+	/* Timer3 marks the end of our ATIM window
+	 * a zero length window is not allowed because
+	 * we 'll get no beacons */
 	timer3 = next_beacon + (ah->ah_atim_window ? ah->ah_atim_window : 1);
 
 	/*
 	 * Set the beacon register and enable all timers.
-	 * (next beacon, DMA beacon, software beacon, ATIM window time)
 	 */
-	ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
+	/* When in AP mode zero timer0 to start TSF */
+	if (ah->ah_op_mode == NL80211_IFTYPE_AP)
+		ath5k_hw_reg_write(ah, 0, AR5K_TIMER0);
+	else
+		ath5k_hw_reg_write(ah, next_beacon, AR5K_TIMER0);
 	ath5k_hw_reg_write(ah, timer1, AR5K_TIMER1);
 	ath5k_hw_reg_write(ah, timer2, AR5K_TIMER2);
 	ath5k_hw_reg_write(ah, timer3, AR5K_TIMER3);
 
+	/* Force a TSF reset if requested and enable beacons */
+	if (interval & AR5K_BEACON_RESET_TSF)
+		ath5k_hw_reset_tsf(ah);
+
 	ath5k_hw_reg_write(ah, interval & (AR5K_BEACON_PERIOD |
-			AR5K_BEACON_RESET_TSF | AR5K_BEACON_ENABLE),
-		AR5K_BEACON);
+					AR5K_BEACON_ENABLE),
+						AR5K_BEACON);
+
+	/* Flush any pending BMISS interrupts on ISR by
+	 * performing a clear-on-write operation on PISR
+	 * register for the BMISS bit (writing a bit on
+	 * ISR togles a reset for that bit and leaves
+	 * the rest bits intact) */
+	if (ah->ah_version == AR5K_AR5210)
+		ath5k_hw_reg_write(ah, AR5K_ISR_BMISS, AR5K_ISR);
+	else
+		ath5k_hw_reg_write(ah, AR5K_ISR_BMISS, AR5K_PISR);
+
+	/* TODO: Set enchanced sleep registers on AR5212
+	 * based on vif->bss_conf params, until then
+	 * disable power save reporting.*/
+	AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, AR5K_STA_ID1_PWR_SV);
+
 }
 
 #if 0
@@ -899,14 +959,25 @@ int ath5k_hw_beaconq_finish(struct ath5k_hw *ah, unsigned long phys_addr)
  */
 int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
 {
-	unsigned int i;
+	unsigned int i, type;
 
 	ATH5K_TRACE(ah->ah_sc);
 	AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
 
+	type = ath5k_hw_reg_read(ah, AR5K_KEYTABLE_TYPE(entry));
+
 	for (i = 0; i < AR5K_KEYCACHE_SIZE; i++)
 		ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_OFF(entry, i));
 
+	/* Reset associated MIC entry if TKIP
+	 * is enabled located at offset (entry + 64) */
+	if (type == AR5K_KEYTABLE_TYPE_TKIP) {
+		entry = entry + AR5K_KEYTABLE_MIC_OFFSET;
+		AR5K_ASSERT_ENTRY(entry, AR5K_KEYTABLE_SIZE);
+		for (i = 0; i < AR5K_KEYCACHE_SIZE / 2 ; i++)
+			ath5k_hw_reg_write(ah, 0, AR5K_KEYTABLE_OFF(entry, i));
+	}
+
 	/*
 	 * Set NULL encryption on AR5212+
 	 *
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 0dae54d..69755fc 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -1114,14 +1114,16 @@
 #define AR5K_PCU_MAX	0x8fff
 
 /*
- * First station id register (MAC address in lower 32 bits)
+ * First station id register (Lower 32 bits of MAC address)
  */
-#define AR5K_STA_ID0	0x8000
+#define AR5K_STA_ID0		0x8000
+#define	AR5K_STA_ID0_ARRD_L32	0xffffffff
 
 /*
- * Second station id register (MAC address in upper 16 bits)
+ * Second station id register (Upper 16 bits of MAC address + PCU settings)
  */
 #define AR5K_STA_ID1			0x8004			/* Register Address */
+#define	AR5K_STA_ID1_ADDR_U16		0x0000ffff	/* Upper 16 bits of MAC addres */
 #define AR5K_STA_ID1_AP			0x00010000	/* Set AP mode */
 #define AR5K_STA_ID1_ADHOC		0x00020000	/* Set Ad-Hoc mode */
 #define AR5K_STA_ID1_PWR_SV		0x00040000	/* Power save reporting */
@@ -1811,6 +1813,10 @@
 #define AR5K_KEYTABLE_MAC1(_n)		AR5K_KEYTABLE_OFF(_n, 7)
 #define AR5K_KEYTABLE_VALID		0x00008000
 
+/* If key type is TKIP and MIC is enabled
+ * MIC key goes in offset entry + 64 */
+#define	AR5K_KEYTABLE_MIC_OFFSET	64
+
 /* WEP 40-bit	= 40-bit  entered key + 24 bit IV = 64-bit
  * WEP 104-bit	= 104-bit entered key + 24-bit IV = 128-bit
  * WEP 128-bit	= 128-bit entered key + 24 bit IV = 152-bit
