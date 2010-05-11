Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:47563 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903Ab0EKPXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 11:23:12 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 4/4] ath9k_hw: clean up EEPROM endian handling on AR9003
Date: Tue, 11 May 2010 17:23:03 +0200
Message-Id: <1273591383-76696-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1273591383-76696-3-git-send-email-nbd@openwrt.org>
References: <1273591383-76696-1-git-send-email-nbd@openwrt.org>
 <1273591383-76696-2-git-send-email-nbd@openwrt.org>
 <1273591383-76696-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the double swapping of the descriptor data structure, instead
keep it little-endian (native format of the eeprom data), and byteswap
on access.
This allows sparse to verify endian access to the eeprom struct.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |  174 ++++++++++-------------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h |   10 +-
 2 files changed, 81 insertions(+), 103 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 8a79550..23eb60e 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -38,6 +38,9 @@
 #define AR_SWITCH_TABLE_ALL (0xfff)
 #define AR_SWITCH_TABLE_ALL_S (0)
 
+#define LE16(x) __constant_cpu_to_le16(x)
+#define LE32(x) __constant_cpu_to_le32(x)
+
 static const struct ar9300_eeprom ar9300_default = {
 	.eepromVersion = 2,
 	.templateVersion = 2,
@@ -45,7 +48,7 @@ static const struct ar9300_eeprom ar9300_default = {
 	.custData = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 		     0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
 	.baseEepHeader = {
-		.regDmn = {0, 0x1f},
+		.regDmn = { LE16(0), LE16(0x1f) },
 		.txrxMask =  0x77, /* 4 bits tx and 4 bits rx */
 		.opCapFlags = {
 			.opFlags = AR9300_OPFLAGS_11G | AR9300_OPFLAGS_11A,
@@ -76,15 +79,15 @@ static const struct ar9300_eeprom ar9300_default = {
 	.modalHeader2G = {
 	/* ar9300_modal_eep_header  2g */
 		/* 4 idle,t1,t2,b(4 bits per setting) */
-		.antCtrlCommon = 0x110,
+		.antCtrlCommon = LE32(0x110),
 		/* 4 ra1l1, ra2l1, ra1l2, ra2l2, ra12 */
-		.antCtrlCommon2 = 0x22222,
+		.antCtrlCommon2 = LE32(0x22222),
 
 		/*
 		 * antCtrlChain[AR9300_MAX_CHAINS]; 6 idle, t, r,
 		 * rx1, rx12, b (2 bits each)
 		 */
-		.antCtrlChain = {0x150, 0x150, 0x150},
+		.antCtrlChain = { LE16(0x150), LE16(0x150), LE16(0x150) },
 
 		/*
 		 * xatten1DB[AR9300_MAX_CHAINS];  3 xatten1_db
@@ -287,12 +290,12 @@ static const struct ar9300_eeprom ar9300_default = {
 	 },
 	.modalHeader5G = {
 		/* 4 idle,t1,t2,b (4 bits per setting) */
-		.antCtrlCommon = 0x110,
+		.antCtrlCommon = LE32(0x110),
 		/* 4 ra1l1, ra2l1, ra1l2,ra2l2,ra12 */
-		.antCtrlCommon2 = 0x22222,
+		.antCtrlCommon2 = LE32(0x22222),
 		 /* antCtrlChain 6 idle, t,r,rx1,rx12,b (2 bits each) */
 		.antCtrlChain = {
-			0x000, 0x000, 0x000,
+			LE16(0x000), LE16(0x000), LE16(0x000),
 		},
 		 /* xatten1DB 3 xatten1_db for AR9280 (0xa20c/b20c 5:0) */
 		.xatten1DB = {0, 0, 0},
@@ -620,9 +623,9 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 	case EEP_MAC_MSW:
 		return eep->macAddr[4] << 8 | eep->macAddr[5];
 	case EEP_REG_0:
-		return pBase->regDmn[0];
+		return le16_to_cpu(pBase->regDmn[0]);
 	case EEP_REG_1:
-		return pBase->regDmn[1];
+		return le16_to_cpu(pBase->regDmn[1]);
 	case EEP_OP_CAP:
 		return pBase->deviceCap;
 	case EEP_OP_MODE:
@@ -640,93 +643,80 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct ath_hw *ah,
 		/* Bit 4 is internal regulator flag */
 		return (pBase->featureEnable & 0x10) >> 4;
 	case EEP_SWREG:
-		return pBase->swreg;
+		return le32_to_cpu(pBase->swreg);
 	default:
 		return 0;
 	}
 }
 
-#ifdef __BIG_ENDIAN
-static void ar9300_swap_eeprom(struct ar9300_eeprom *eep)
+static bool ar9300_eeprom_read_byte(struct ath_common *common, int address,
+				    u8 *buffer)
 {
-	u32 dword;
-	u16 word;
-	int i;
-
-	word = swab16(eep->baseEepHeader.regDmn[0]);
-	eep->baseEepHeader.regDmn[0] = word;
-
-	word = swab16(eep->baseEepHeader.regDmn[1]);
-	eep->baseEepHeader.regDmn[1] = word;
-
-	dword = swab32(eep->baseEepHeader.swreg);
-	eep->baseEepHeader.swreg = dword;
+	u16 val;
 
-	dword = swab32(eep->modalHeader2G.antCtrlCommon);
-	eep->modalHeader2G.antCtrlCommon = dword;
+	if (unlikely(!ath9k_hw_nvram_read(common, address / 2, &val)))
+		return false;
 
-	dword = swab32(eep->modalHeader2G.antCtrlCommon2);
-	eep->modalHeader2G.antCtrlCommon2 = dword;
+	*buffer = (val >> (8 * (address % 2))) & 0xff;
+	return true;
+}
 
-	dword = swab32(eep->modalHeader5G.antCtrlCommon);
-	eep->modalHeader5G.antCtrlCommon = dword;
+static bool ar9300_eeprom_read_word(struct ath_common *common, int address,
+				    u8 *buffer)
+{
+	u16 val;
 
-	dword = swab32(eep->modalHeader5G.antCtrlCommon2);
-	eep->modalHeader5G.antCtrlCommon2 = dword;
+	if (unlikely(!ath9k_hw_nvram_read(common, address / 2, &val)))
+		return false;
 
-	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
-		word = swab16(eep->modalHeader2G.antCtrlChain[i]);
-		eep->modalHeader2G.antCtrlChain[i] = word;
+	buffer[0] = val >> 8;
+	buffer[1] = val & 0xff;
 
-		word = swab16(eep->modalHeader5G.antCtrlChain[i]);
-		eep->modalHeader5G.antCtrlChain[i] = word;
-	}
+	return true;
 }
-#endif
 
-static bool ar9300_hw_read_eeprom(struct ath_hw *ah,
-				  long address, u8 *buffer, int many)
+static bool ar9300_read_eeprom(struct ath_hw *ah, int address, u8 *buffer,
+			       int count)
 {
-	int i;
-	u8 value[2];
-	unsigned long eepAddr;
-	unsigned long byteAddr;
-	u16 *svalue;
 	struct ath_common *common = ath9k_hw_common(ah);
+	int i;
 
-	if ((address < 0) || ((address + many) > AR9300_EEPROM_SIZE - 1)) {
+	if ((address < 0) || ((address + count) / 2 > AR9300_EEPROM_SIZE - 1)) {
 		ath_print(common, ATH_DBG_EEPROM,
 			  "eeprom address not in range\n");
 		return false;
 	}
 
-	for (i = 0; i < many; i++) {
-		eepAddr = (u16) (address + i) / 2;
-		byteAddr = (u16) (address + i) % 2;
-		svalue = (u16 *) value;
-		if (!ath9k_hw_nvram_read(common, eepAddr, svalue)) {
-			ath_print(common, ATH_DBG_EEPROM,
-				  "unable to read eeprom region\n");
-			return false;
-		}
-		*svalue = le16_to_cpu(*svalue);
-		buffer[i] = value[byteAddr];
+	/*
+	 * Since we're reading the bytes in reverse order from a little-endian
+	 * word stream, an even address means we only use the lower half of
+	 * the 16-bit word at that address
+	 */
+	if (address % 2 == 0) {
+		if (!ar9300_eeprom_read_byte(common, address--, buffer++))
+			goto error;
+
+		count--;
 	}
 
-	return true;
-}
+	for (i = 0; i < count / 2; i++) {
+		if (!ar9300_eeprom_read_word(common, address, buffer))
+			goto error;
 
-static bool ar9300_read_eeprom(struct ath_hw *ah,
-			       int address, u8 *buffer, int many)
-{
-	int it;
+		address -= 2;
+		buffer += 2;
+	}
+
+	if (count % 2)
+		if (!ar9300_eeprom_read_byte(common, address, buffer))
+			goto error;
 
-	for (it = 0; it < many; it++)
-		if (!ar9300_hw_read_eeprom(ah,
-					   (address - it),
-					   (buffer + it), 1))
-			return false;
 	return true;
+
+error:
+	ath_print(common, ATH_DBG_EEPROM,
+		  "unable to read eeprom region at offset %d\n", address);
+	return false;
 }
 
 static void ar9300_comp_hdr_unpack(u8 *best, int *code, int *reference,
@@ -927,30 +917,13 @@ fail:
  */
 static bool ath9k_hw_ar9300_fill_eeprom(struct ath_hw *ah)
 {
-	u8 *mptr = NULL;
-	int mdata_size;
+	u8 *mptr = (u8 *) &ah->eeprom.ar9300_eep;
 
-	mptr = (u8 *) &ah->eeprom.ar9300_eep;
-	mdata_size = sizeof(struct ar9300_eeprom);
+	if (ar9300_eeprom_restore_internal(ah, mptr,
+			sizeof(struct ar9300_eeprom)) < 0)
+		return false;
 
-	if (mptr && mdata_size > 0) {
-		/* At this point, mptr points to the eeprom data structure
-		 * in it's "default" state. If this is big endian, swap the
-		 * data structures back to "little endian"
-		 */
-		/* First swap, default to Little Endian */
-#ifdef __BIG_ENDIAN
-		ar9300_swap_eeprom((struct ar9300_eeprom *)mptr);
-#endif
-		if (ar9300_eeprom_restore_internal(ah, mptr, mdata_size) >= 0)
-			return true;
-
-		/* Second Swap, back to Big Endian */
-#ifdef __BIG_ENDIAN
-		ar9300_swap_eeprom((struct ar9300_eeprom *)mptr);
-#endif
-	}
-	return false;
+	return true;
 }
 
 /* XXX: review hardware docs */
@@ -998,21 +971,25 @@ static void ar9003_hw_xpa_bias_level_apply(struct ath_hw *ah, bool is2ghz)
 static u32 ar9003_hw_ant_ctrl_common_get(struct ath_hw *ah, bool is2ghz)
 {
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	__le32 val;
 
 	if (is2ghz)
-		return eep->modalHeader2G.antCtrlCommon;
+		val = eep->modalHeader2G.antCtrlCommon;
 	else
-		return eep->modalHeader5G.antCtrlCommon;
+		val = eep->modalHeader5G.antCtrlCommon;
+	return le32_to_cpu(val);
 }
 
 static u32 ar9003_hw_ant_ctrl_common_2_get(struct ath_hw *ah, bool is2ghz)
 {
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	__le32 val;
 
 	if (is2ghz)
-		return eep->modalHeader2G.antCtrlCommon2;
+		val = eep->modalHeader2G.antCtrlCommon2;
 	else
-		return eep->modalHeader5G.antCtrlCommon2;
+		val = eep->modalHeader5G.antCtrlCommon2;
+	return le32_to_cpu(val);
 }
 
 static u16 ar9003_hw_ant_ctrl_chain_get(struct ath_hw *ah,
@@ -1020,15 +997,16 @@ static u16 ar9003_hw_ant_ctrl_chain_get(struct ath_hw *ah,
 					bool is2ghz)
 {
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
+	__le16 val = 0;
 
 	if (chain >= 0 && chain < AR9300_MAX_CHAINS) {
 		if (is2ghz)
-			return eep->modalHeader2G.antCtrlChain[chain];
+			val = eep->modalHeader2G.antCtrlChain[chain];
 		else
-			return eep->modalHeader5G.antCtrlChain[chain];
+			val = eep->modalHeader5G.antCtrlChain[chain];
 	}
 
-	return 0;
+	return le16_to_cpu(val);
 }
 
 static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
index d8c0318..23fb353 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.h
@@ -169,7 +169,7 @@ enum CompressAlgorithm {
 };
 
 struct ar9300_base_eep_hdr {
-	u16 regDmn[2];
+	__le16 regDmn[2];
 	/* 4 bits tx and 4 bits rx */
 	u8 txrxMask;
 	struct eepFlags opCapFlags;
@@ -199,16 +199,16 @@ struct ar9300_base_eep_hdr {
 	u8 rxBandSelectGpio;
 	u8 txrxgain;
 	/* SW controlled internal regulator fields */
-	u32 swreg;
+	__le32 swreg;
 } __packed;
 
 struct ar9300_modal_eep_header {
 	/* 4 idle, t1, t2, b (4 bits per setting) */
-	u32 antCtrlCommon;
+	__le32 antCtrlCommon;
 	/* 4 ra1l1, ra2l1, ra1l2, ra2l2, ra12 */
-	u32 antCtrlCommon2;
+	__le32 antCtrlCommon2;
 	/* 6 idle, t, r, rx1, rx12, b (2 bits each) */
-	u16 antCtrlChain[AR9300_MAX_CHAINS];
+	__le16 antCtrlChain[AR9300_MAX_CHAINS];
 	/* 3 xatten1_db for AR9280 (0xa20c/b20c 5:0) */
 	u8 xatten1DB[AR9300_MAX_CHAINS];
 	/* 3  xatten1_margin for merlin (0xa20c/b20c 16:12 */
-- 
1.6.4.2

