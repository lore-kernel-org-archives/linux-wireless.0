Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59596 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759251Ab2DJPPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 11:15:21 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [WIP 07/11] ath9k_hw: Add hardware code for WoW
Date: Tue, 10 Apr 2012 20:43:17 +0530
Message-ID: <1334070801-21708-8-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120410_171527_889913_4BAA4AEF)
In-Reply-To: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

add a new file wow.c which takes care of the hardware code
for WoW.

*program the descriptors and data words to periodically
send Keep Alive Frames.
*program the user defined patterns/masks and pattern length
in the hardware registers.
*'ath9k_hw_wow_enable' is called during the drivers suspend
callback which takes care of the following
	- tracking wow event mask (to suppress spurious
	  wow events)
	- properly configure suspend/resume WAR registers
	- configure PCIE PM control register
	- configure MAC WoW registers and their timeouts
	- enabling wow configuration like magic packet,
	  user patterns based on users configuration
	- configuring timeouts for KAL, beacon miss,
	  aifs, slot time, backoff
	- create Keep Alive Pattern ('KAL')
*'ath9k_hw_wow_wakeup' is called during the drivers resume
callback which takes care of the following
	- primary task is to find the reason for wakeup
	  from the wow status register
	- configure/restore AR_PCIE_PM_CTRL register
	- clear all WoW events
	- configure/restore suspend/resume WAR registers

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/Makefile |    1 +
 drivers/net/wireless/ath/ath9k/hw.h     |   32 ++
 drivers/net/wireless/ath/ath9k/wow.c    |  547 +++++++++++++++++++++++++++++++
 3 files changed, 580 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/wow.c

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 27d95fe..72ffcd0 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -12,6 +12,7 @@ ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
 ath9k-$(CONFIG_ATH9K_DFS_DEBUGFS) += dfs_debug.o
 ath9k-$(CONFIG_ATH9K_DFS_CERTIFIED) += dfs.o
+ath9k-$(CONFIG_PM_SLEEP) += wow.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ca770e4..3f70800 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1105,6 +1105,38 @@ ath9k_hw_get_btcoex_scheme(struct ath_hw *ah)
 }
 #endif /* CONFIG_ATH9K_BTCOEX_SUPPORT */
 
+
+#ifdef CONFIG_PM_SLEEP
+const char *ath9k_hw_wow_event_to_string(u32 wow_event);
+void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
+				u8 *user_mask, int pattern_count,
+				int pattern_len);
+u32 ath9k_hw_wow_wakeup(struct ath_hw *ah);
+void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable);
+#else
+static inline const char *ath9k_hw_wow_event_to_string(u32 wow_event)
+{
+	return NULL;
+}
+static inline void ath9k_hw_wow_apply_pattern(struct ath_hw *ah,
+					      u8 *user_pattern, u8 *user_mask,
+					      int pattern_count,
+					      int pattern_len)
+{
+	return;
+}
+static inline u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
+{
+	return 0;
+}
+static inline void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
+{
+	return;
+}
+#endif
+
+
+
 #define ATH9K_CLOCK_RATE_CCK		22
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
new file mode 100644
index 0000000..6eed9de
--- /dev/null
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -0,0 +1,547 @@
+
+/*
+ * Copyright (c) 2008-2011 Atheros Communications Inc.
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
+#include <linux/export.h>
+#include "ath9k.h"
+#include "reg.h"
+#include "hw-ops.h"
+
+const char *ath9k_hw_wow_event_to_string(u32 wow_event)
+{
+	if (wow_event & AH_WOW_MAGIC_PATTERN_EN)
+		return "Magic pattern";
+	if (wow_event & AH_WOW_USER_PATTERN_EN)
+		return "User pattern";
+	if (wow_event & AH_WOW_LINK_CHANGE)
+		return "Link change";
+	if (wow_event & AH_WOW_BEACON_MISS)
+		return "Beacon reason";
+
+	return  "unknown reason";
+}
+EXPORT_SYMBOL(ath9k_hw_wow_event_to_string);
+
+static void ath9k_hw_config_serdes_wow_sleep(struct ath_hw *ah)
+{
+	int i;
+	/*
+	 * for WoW sleep, we reprogram the SerDes so that the PLL
+	 * and CHK REQ are both enabled. This use more power
+	 * but otherwise WoW sleep is unstable and the chip may
+	 * disappear
+	 */
+
+	for (i = 0; i < ah->iniPcieSerdesWow.ia_rows; i++)
+		REG_WRITE(ah, INI_RA(&ah->iniPcieSerdesWow, i, 0),
+				INI_RA(&ah->iniPcieSerdesWow, i, 1));
+
+	udelay(1000);
+}
+
+static void ath9k_hw_set_powermode_wow_sleep(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	REG_SET_BIT(ah, AR_STA_ID1, AR_STA_ID1_PWR_SAV);
+	REG_WRITE(ah, AR_CR, AR_CR_RXD); /* set rx disable bit */
+
+	if (!ath9k_hw_wait(ah, AR_CR, AR_CR_RXE, 0, AH_WAIT_TIMEOUT)) {
+		ath_err(common, "Failed to stop Rx DMA in 10ms"
+			"AR_CR=0x%08x AR_DIAG_SW=0x%08x\n",
+			REG_READ(ah, AR_CR), REG_READ(ah, AR_DIAG_SW));
+	} else {
+		if (!AR_SREV_9300_20_OR_LATER(ah))
+			REG_WRITE(ah, AR_RXDP, 0x0);
+	}
+
+	/* AR9280 WoW has sleep issue, do not set it to sleep */
+	if (AR_SREV_9280_20(ah))
+		return;
+
+	REG_WRITE(ah, AR_RTC_FORCE_WAKE, AR_RTC_FORCE_WAKE_ON_INT);
+}
+
+#define KAL_FRAME_LEN		28
+#define KAL_FRAME_TYPE		0x2 /* data frame */
+#define KAL_FRAME_SUB_TYPE	0x4 /* null data frame */
+#define KAL_DURATION_ID		0x3d
+#define KAL_NUM_DATA_WORDS	6
+
+static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
+{
+	struct ath_common *common = ath9k_hw_common(ah);
+	u32 frame_len = KAL_FRAME_LEN;
+	u32 tpc = MAX_RATE_POWER;
+	u32 antenna_mode = 1;
+	u32 transmit_rate;
+	u32 frame_type = KAL_FRAME_TYPE; /* frame type -> data */
+	u32 sub_type = KAL_FRAME_SUB_TYPE; /* subtype -> NULL data */
+	u32 to_ds = 1;
+	u32 duration_id = KAL_DURATION_ID;
+	u8 sta_mac_addr[ETH_ALEN], ap_mac_addr[ETH_ALEN];
+	u32 ctl[12] = {0};
+	u32 data_word[KAL_NUM_DATA_WORDS];
+	u8 i;
+	u32 wow_ka_data_word0;
+
+	memcpy(sta_mac_addr, common->macaddr, ETH_ALEN);
+	memcpy(ap_mac_addr, common->curbssid, ETH_ALEN);
+
+	if (ah->curchan->channelFlags & CHANNEL_CCK)
+		transmit_rate = 0x1b; /* CCK_1M hardware value for this rate */
+	else
+		transmit_rate = 0xb; /* OFDM_6M hardware value for this rate */
+
+	/* set the transmit buffer */
+	ctl[0] = (frame_len | (tpc << 16)) + (antenna_mode << 25);
+	/* antenna_mode not required for AR9300 family of chipsets ? */
+
+	ctl[1] = 0;
+	ctl[2] = 0x7 << 16; /* tx_tries 0 */
+	ctl[3] = transmit_rate;
+	ctl[4] = 0;
+	ctl[7] = (ah->txchainmask) << 2;
+
+	for (i = 0; i < 12; i++)
+		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + i * 4), ctl[i]);
+
+	data_word[0] = (frame_type << 2) | (sub_type << 4) |
+			(to_ds << 8) | (duration_id << 16);
+	data_word[1] = (ap_mac_addr[3] << 24) | (ap_mac_addr[2] << 16) |
+			(ap_mac_addr[1] << 8) | (ap_mac_addr[0]);
+	data_word[2] = (sta_mac_addr[1] << 24) | (sta_mac_addr[0] << 16) |
+			(ap_mac_addr[5] << 8) | (ap_mac_addr[4]);
+	data_word[3] = (sta_mac_addr[5] << 24) | (sta_mac_addr[4] << 16) |
+			(sta_mac_addr[3] << 8) | (sta_mac_addr[2]);
+	data_word[4] = (ap_mac_addr[3] << 24) | (ap_mac_addr[2] << 16) |
+			(ap_mac_addr[1] << 8) | (ap_mac_addr[0]);
+	data_word[5] = (ap_mac_addr[5] << 8) | (ap_mac_addr[4]);
+
+	if (AR_SREV_9462_20_OR_LATER(ah)) {
+		/* AR9462 2.0 has an extra descriptor word (time based
+		 * discard) compared to other chips */
+		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + 12*4), 0);
+		wow_ka_data_word0 = AR_WOW_TXBUF(13);
+	} else {
+		wow_ka_data_word0 = AR_WOW_TXBUF(12);
+	}
+
+	for (i = 0; i < KAL_NUM_DATA_WORDS; i++)
+		REG_WRITE(ah, (wow_ka_data_word0 + i*4), data_word[i]);
+
+}
+
+void ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
+				u8 *user_mask, int pattern_count,
+				int pattern_len)
+{
+	int i;
+	u32 reg_pat[] = {AR_WOW_TB_PATTERN0,
+		AR_WOW_TB_PATTERN1,
+		AR_WOW_TB_PATTERN2,
+		AR_WOW_TB_PATTERN3,
+		AR_WOW_TB_PATTERN4,
+		AR_WOW_TB_PATTERN5,
+		AR_WOW_TB_PATTERN6,
+		AR_WOW_TB_PATTERN7
+	}; /* pattern registers */
+	u32 reg_mask[] = {AR_WOW_TB_MASK0,
+		AR_WOW_TB_MASK1,
+		AR_WOW_TB_MASK2,
+		AR_WOW_TB_MASK3,
+		AR_WOW_TB_MASK4,
+		AR_WOW_TB_MASK5,
+		AR_WOW_TB_MASK6,
+		AR_WOW_TB_MASK7
+	}; /* pattern mask registers */
+	u32 pattern_val;
+	u32 mask_val;
+	u32 val;
+	u8 mask_bit = 0x1;
+	u8 pattern;
+
+	/* FIXME: should check count by querying the hardware caopability */
+	if (pattern_count >= MAX_NUM_USER_PATTERN)
+		return;
+
+	pattern = (u8)REG_READ(ah, AR_WOW_PATTERN);
+	pattern = pattern | (mask_bit << pattern_count);
+	REG_WRITE(ah, AR_WOW_PATTERN, pattern);
+
+	/* set the registers for pattern */
+	for (i = 0; i < MAX_PATTERN_SIZE; i += 4) {
+		memcpy(&pattern_val, user_pattern, 4);
+		REG_WRITE(ah, (reg_pat[pattern_count] + i), pattern_val);
+	}
+
+	/* set the registers for mask */
+	for (i = 0; i < MAX_PATTERN_SIZE; i += 4) {
+		memcpy(&mask_val, user_mask, 4);
+		REG_WRITE(ah, (reg_mask[pattern_count] + i), mask_val);
+	}
+
+	/* set the pattern length to be matched
+	 *
+	 * AR_WOW_LENGTH1_REG1
+	 * bit 31:24 pattern 0 length
+	 * bit 23:16 pattern 1 length
+	 * bit 15:8 pattern 2 length
+	 * bit 7:0 pattern 3 length
+	 *
+	 * AR_WOW_LENGTH1_REG2
+	 * bit 31:24 pattern 4 length
+	 * bit 23:16 pattern 5 length
+	 * bit 15:8 pattern 6 length
+	 * bit 7:0 pattern 7 length
+	 *
+	 * the below logic writes out the new
+	 * pattern length for the corresponding
+	 * pattern_count, while masking out the
+	 * other fields
+	 */
+
+	if (AR_SREV_9285_12_OR_LATER(ah)) {
+		if (pattern_count < 4) {
+			/* Pattern 0-3 uses AR_WOW_LENGTH1 register */
+			val = REG_READ(ah, AR_WOW_LENGTH1);
+			val = ((val & (~AR_WOW_LENGTH1_MASK(pattern_count))) |
+					((pattern_len & AR_WOW_LENGTH_MAX) <<
+					 AR_WOW_LEN1_SHIFT(pattern_count)));
+			REG_WRITE(ah, AR_WOW_LENGTH1, val);
+		} else {
+			/* Pattern 4-7 uses AR_WOW_LENGTH2 register */
+			val = REG_READ(ah, AR_WOW_LENGTH2);
+			val = ((val & (~AR_WOW_LENGTH2_MASK(pattern_count))) |
+					((pattern_len & AR_WOW_LENGTH_MAX) <<
+					 AR_WOW_LEN2_SHIFT(pattern_count)));
+			REG_WRITE(ah, AR_WOW_LENGTH2, val);
+		}
+	}
+
+	ah->wow_event_mask |= (1 << (pattern_count + AR_WOW_PAT_FOUND_SHIFT));
+
+}
+EXPORT_SYMBOL(ath9k_hw_wow_apply_pattern);
+
+u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
+{
+	u32 wow_status = 0;
+	u32 val = 0, rval;
+
+	/*
+	 * read the WoW status register to know
+	 * the wakeup reason
+	 */
+	rval = REG_READ(ah, AR_WOW_PATTERN);
+	val = AR_WOW_STATUS(rval);
+
+	/*
+	 * mask only the WoW events that we have enabled. Sometimes
+	 * we have spurious WoW events from the AR_WOW_PATTERN
+	 * register. This mask will clean it up.
+	 */
+
+	val &= ah->wow_event_mask;
+
+	if (val) {
+
+		if (val & AR_WOW_MAGIC_PAT_FOUND)
+			wow_status |= AH_WOW_MAGIC_PATTERN_EN;
+
+		if (AR_WOW_PATTERN_FOUND(val))
+			wow_status |= AH_WOW_USER_PATTERN_EN;
+
+		if (val & AR_WOW_KEEP_ALIVE_FAIL)
+			wow_status |= AH_WOW_LINK_CHANGE;
+
+		if (val & AR_WOW_BEACON_FAIL)
+			wow_status |= AH_WOW_BEACON_MISS;
+
+	}
+
+	/*
+	 * set and clear WOW_PME_CLEAR registers for the chip to
+	 * generate next wow signal.
+	 * disable D3 before accessing other registers ?
+	 */
+
+	val = REG_READ(ah, AR_PCIE_PM_CTRL);
+	val &= ~AR_PMCTRL_PWR_STATE_D1D3;
+	/* do we need to check the bit value 0x01000000 (7-10) ?? */
+	val |= AR_PMCTRL_WOW_PME_CLR;
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, val);
+
+	/*
+	 * clear all events
+	 */
+	REG_WRITE(ah, AR_WOW_PATTERN,
+		      AR_WOW_CLEAR_EVENTS(REG_READ(ah, AR_WOW_PATTERN)));
+
+	/*
+	 * tie reset register
+	 * NB: not tieing it back might have some repurcussions.
+	 */
+
+	if (AR_SREV_9280_20_OR_LATER(ah) && !(AR_SREV_9300_20_OR_LATER(ah)))
+		REG_WRITE(ah, AR_WA, (REG_READ(ah, AR_WA) |
+					AR_WA_UNTIE_RESET_EN |
+					AR_WA_POR_SHORT |
+					AR_WA_RESET_EN));
+
+	/* restore the beacon threshold to init value */
+	REG_RMW_FIELD(ah, AR_RSSI_THR, AR_RSSI_THR_BM_THR, INIT_RSSI_THR);
+
+	/*
+	 * Restore the way the PCI-E reset, Power-On-Reset, external
+	 * PCIE_POR_SHORT pins are tied to its original value.
+	 * Previously just before WoW sleep, we untie the PCI-E
+	 * reset to our Chip's Power On Reset so that any PCI-E
+	 * reset from the bus will not reset our chip
+	 */
+
+	if (AR_SREV_9280_20_OR_LATER(ah) && ah->is_pciexpress)
+		ath9k_hw_configpcipowersave(ah, false);
+
+	ah->wow_event_mask = 0;
+
+	return wow_status;
+}
+EXPORT_SYMBOL(ath9k_hw_wow_wakeup);
+
+void ath9k_hw_wow_enable(struct ath_hw *ah, u32 pattern_enable)
+{
+	u32 init_val, val, rval = 0;
+	const int ka_delay = 4; /* delay of 4 milliseconds between
+				   two keep alive frames */
+	u32 wow_event_mask;
+	u32 wa_reg_val;
+
+	/*
+	 * wow_event_mask is a mask to the AR_WOW_PATTERN register to
+	 * indicate which WoW events we have enabled. The WoW events
+	 * are from the 'pattern_enable' in this function and
+	 * 'pattern_count' of ath9k_hw_wow_apply_pattern()
+	 */
+
+	wow_event_mask = ah->wow_event_mask;
+
+	/*
+	 * Untie Power-on-Reset from the PCI-E-Reset. When we are in
+	 * WOW sleep, we do want the Reset from the PCI-E to disturb
+	 * our hw state
+	 */
+
+	if (ah->is_pciexpress) {
+
+		if (AR_SREV_9280_20_OR_LATER(ah) &&
+		    !(AR_SREV_9300_20_OR_LATER(ah))) {
+			/*
+			 * we need to untie
+			 */
+			if (AR_SREV_9285(ah) || AR_SREV_9287(ah))
+				wa_reg_val = AR9285_WA_DEFAULT;
+			else
+				wa_reg_val = AR9280_WA_DEFAULT;
+
+			/*
+			 * In AR9280 and AR9285, bit 14 in WA register
+			 * (disable L1) should only be set when device
+			 * enters D3 state and be cleared when device
+			 * comes back to D0
+			 */
+
+			if (ah->config.pcie_waen & AR_WA_D3_L1_DISABLE)
+				wa_reg_val = wa_reg_val | AR_WA_D3_L1_DISABLE;
+
+			wa_reg_val = wa_reg_val & ~(AR_WA_UNTIE_RESET_EN);
+			wa_reg_val = wa_reg_val | AR_WA_RESET_EN |
+				     AR_WA_POR_SHORT;
+			REG_WRITE(ah, AR_WA, wa_reg_val);
+
+			if (!AR_SREV_9285(ah) || AR_SREV_9285_12_OR_LATER(ah))
+				ath9k_hw_config_serdes_wow_sleep(ah);
+
+		}
+
+		if (AR_SREV_9300_20_OR_LATER(ah)) {
+			wa_reg_val = REG_READ(ah, AR_WA);
+			wa_reg_val = wa_reg_val & ~(AR_WA_UNTIE_RESET_EN |
+				     AR_WA_D3_L1_DISABLE);
+			wa_reg_val = wa_reg_val | AR_WA_RESET_EN |
+				     AR_WA_POR_SHORT;
+			REG_WRITE(ah, AR_WA, wa_reg_val);
+		}
+
+	}
+
+	/*
+	 * set the power states appropriately and enable PME
+	 */
+	val = REG_READ(ah, AR_PCIE_PM_CTRL);
+	val |= AR_PMCTRL_HOST_PME_EN | AR_PMCTRL_PWR_PM_CTRL_ENA |
+	       AR_PMCTRL_AUX_PWR_DET;
+
+	val |= AR_PMCTRL_WOW_PME_CLR;
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, val);
+	val &= ~AR_PMCTRL_WOW_PME_CLR;
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, val);
+
+	/*
+	 * Setup for:
+	 *	- beacon misses
+	 *	- magic pattern
+	 *	- keep alive timeout
+	 *	- pattern matching
+	 */
+
+	/*
+	 * Program default values foa pattern backoff, aifs/slot/KAL count,
+	 * beacon miss timeout, KAL timeout,
+	 */
+
+	init_val = REG_READ(ah, AR_WOW_PATTERN);
+	val = AR_WOW_BACK_OFF_SHIFT(AR_WOW_PAT_BACKOFF) | init_val;
+	REG_WRITE(ah, AR_WOW_PATTERN, val);
+	rval = REG_READ(ah, AR_WOW_PATTERN);
+
+	init_val = REG_READ(ah, AR_WOW_COUNT);
+	val = AR_WOW_AIFS_CNT(AR_WOW_CNT_AIFS_CNT) |
+	      AR_WOW_SLOT_CNT(AR_WOW_CNT_SLOT_CNT) |
+	      AR_WOW_KEEP_ALIVE_CNT(AR_WOW_CNT_KA_CNT);
+	REG_WRITE(ah, AR_WOW_COUNT, val);
+	rval = REG_READ(ah, AR_WOW_COUNT);
+
+	init_val = REG_READ(ah, AR_WOW_BCN_TIMO);
+	if (pattern_enable & AH_WOW_BEACON_MISS)
+		val = AR_WOW_BEACON_TIMO;
+	else
+		/* we are not using the beacon miss. program a value */
+		val = AR_WOW_BEACON_TIMO_MAX;
+
+	REG_WRITE(ah, AR_WOW_BCN_TIMO, val);
+	rval = REG_READ(ah, AR_WOW_BCN_TIMO);
+
+	init_val = REG_READ(ah, AR_WOW_KEEP_ALIVE_TIMO);
+
+	/*
+	 * keep alive timo in ms  except AR9280
+	 */
+	if (!pattern_enable || AR_SREV_9280(ah))
+		val = AR_WOW_KEEP_ALIVE_NEVER;
+	else
+		val = 60000 * 32;
+
+	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_TIMO, val);
+	rval = REG_READ(ah, AR_WOW_KEEP_ALIVE_TIMO);
+
+	init_val = REG_READ(ah, AR_WOW_KEEP_ALIVE_DELAY);
+	/*
+	 * keep alive delay in us. based on 'power on clock',
+	 * therefore in usec
+	 */
+	val = ka_delay * 1000;
+	REG_WRITE(ah, AR_WOW_KEEP_ALIVE_DELAY, val);
+	rval = REG_READ(ah, AR_WOW_KEEP_ALIVE_DELAY);
+
+	/*
+	 * create keep alive pattern to respond to beacons
+	 */
+	ath9k_wow_create_keep_alive_pattern(ah);
+
+	/*
+	 * configure MAC WoW Registers
+	 */
+	val = REG_READ(ah, AR_WOW_KEEP_ALIVE);
+
+	/*
+	 * send keep alive timeouts anyway
+	 */
+
+	val &= ~AR_WOW_KEEP_ALIVE_AUTO_DIS;
+
+	if (pattern_enable & AH_WOW_LINK_CHANGE) {
+		val &= ~AR_WOW_KEEP_ALIVE_FAIL_DIS;
+		wow_event_mask |= AR_WOW_KEEP_ALIVE_FAIL;
+	} else {
+		val |= AR_WOW_KEEP_ALIVE_FAIL_DIS;
+	}
+
+	REG_WRITE(ah, AR_WOW_KEEP_ALIVE, val);
+	val = REG_READ(ah, AR_WOW_KEEP_ALIVE);
+
+	val = REG_READ(ah, AR_WOW_BCN_EN);
+
+	/*
+	 * we are relying on a bmiss failure. ensure we have
+	 * enough threshold to prevent false positives
+	 */
+	REG_RMW_FIELD(ah, AR_RSSI_THR, AR_RSSI_THR_BM_THR,
+		      AR_WOW_BMISSTHRESHOLD);
+
+	/*
+	 * Beacon miss and user pattern evets are broken
+	 * in some older chipsets
+	 */
+	if (!AR_SREV_9280_20_OR_LATER(ah))
+		pattern_enable &= ~AH_WOW_BEACON_MISS;
+
+	if (pattern_enable & AH_WOW_BEACON_MISS) {
+		val |= AR_WOW_BEACON_FAIL_EN;
+		wow_event_mask |= AR_WOW_BEACON_FAIL;
+	} else {
+		val &= ~AR_WOW_BEACON_FAIL_EN;
+	}
+
+	REG_WRITE(ah, AR_WOW_BCN_EN, val);
+	val = REG_READ(ah, AR_WOW_BCN_EN);
+
+	/*
+	 * Enable the magic packet registers
+	 */
+	val = REG_READ(ah, AR_WOW_PATTERN);
+
+	if (pattern_enable & AH_WOW_MAGIC_PATTERN_EN) {
+		val |= AR_WOW_MAGIC_EN;
+		wow_event_mask |= AR_WOW_MAGIC_PAT_FOUND;
+	} else {
+		val &= ~AR_WOW_MAGIC_EN;
+	}
+	val |= AR_WOW_MAC_INTR_EN;
+	REG_WRITE(ah, AR_WOW_PATTERN, val);
+	val = REG_READ(ah, AR_WOW_PATTERN);
+
+	/*
+	 * For AR9285 and later version of chipsets
+	 * enable WoW pattern match for packets less
+	 * than 256 bytes for all patterns
+	 */
+	if (AR_SREV_9285_12_OR_LATER(ah))
+		REG_WRITE(ah, AR_WOW_PATTERN_MATCH_LT_256B,
+			      AR_WOW_PATTERN_SUPPORTED);
+
+	/*
+	 * set the power states appropriately and enable PME
+	 */
+	val = REG_READ(ah, AR_PCIE_PM_CTRL);
+	val |= AR_PMCTRL_PWR_STATE_D1D3 | AR_PMCTRL_HOST_PME_EN |
+	       AR_PMCTRL_PWR_PM_CTRL_ENA;
+	REG_WRITE(ah, AR_PCIE_PM_CTRL, val);
+
+	REG_CLR_BIT(ah, AR_STA_ID1, AR_STA_ID1_PRESERVE_SEQNUM);
+	ath9k_hw_set_powermode_wow_sleep(ah);
+	ah->wow_event_mask = wow_event_mask;
+}
+EXPORT_SYMBOL(ath9k_hw_wow_enable);
-- 
1.7.0.4

