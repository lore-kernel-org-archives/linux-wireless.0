Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1177 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/30] staging: brcm80211: removed static function
 declarations in 3 files
Date: Thu, 1 Sep 2011 11:16:58 +0200
Message-ID: <1314868640-9425-9-git-send-email-rvossen@broadcom.com> (sfid-20110901_111755_627158_AADD48FA)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nicpci.c, srom.c and stf.c

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/nicpci.c |   18 --
 drivers/staging/brcm80211/brcmsmac/srom.c   |  329 +++++++++++++--------------
 drivers/staging/brcm80211/brcmsmac/stf.c    |  117 +++++-----
 3 files changed, 213 insertions(+), 251 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 2d46e70..b34fe7d 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -215,24 +215,6 @@ struct pcicore_info {
 #define	PCI_ERROR(args)
 #define PCIE_PUB(sih) ((sih)->buscoretype == PCIE_CORE_ID)
 
-/* routines to access mdio slave device registers */
-static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk);
-static int pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr,
-		       bool write, uint *val);
-static int pcie_mdiowrite(struct pcicore_info *pi, uint physmedia, uint readdr,
-			  uint val);
-static int pcie_mdioread(struct pcicore_info *pi, uint physmedia, uint readdr,
-			 uint *ret_val);
-
-static void pcie_extendL1timer(struct pcicore_info *pi, bool extend);
-static void pcie_clkreq_upd(struct pcicore_info *pi, uint state);
-
-static void pcie_war_aspm_clkreq(struct pcicore_info *pi);
-static void pcie_war_serdes(struct pcicore_info *pi);
-static void pcie_war_noplldown(struct pcicore_info *pi);
-static void pcie_war_polarity(struct pcicore_info *pi);
-static void pcie_war_pci_setup(struct pcicore_info *pi);
-
 #define PCIE_ASPM(sih)							\
 	((PCIE_PUB(sih)) &&						\
 	 (((sih)->buscorerev >= 3) &&					\
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index a8f7c00..c8f6897 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -792,16 +792,45 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
 
 static u8 srom_crc8_table[CRC8_TABLE_SIZE];
 
-static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off,
-			       struct brcms_varbuf *b);
-static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
-			     uint *count);
-static int sprom_read_pci(struct si_pub *sih, u16 *sprom,
-			  uint wordoff, u16 *buf, uint nwords, bool check_crc);
-static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz);
+/* Parse SROM and create name=value pairs. 'srom' points to
+ * the SROM word array. 'off' specifies the offset of the
+ * first word 'srom' points to, which should be either 0 or
+ * SROM3_SWRG_OFF (full SROM or software region).
+ */
 
-static int initvars_table(char *start, char *end,
-			  char **vars, uint *count);
+static uint mask_shift(u16 mask)
+{
+	uint i;
+	for (i = 0; i < (sizeof(mask) << 3); i++) {
+		if (mask & (1 << i))
+			return i;
+	}
+	return 0;
+}
+
+static uint mask_width(u16 mask)
+{
+	int i;
+	for (i = (sizeof(mask) << 3) - 1; i >= 0; i--) {
+		if (mask & (1 << i))
+			return (uint) (i - mask_shift(mask) + 1);
+	}
+	return 0;
+}
+
+static inline void ltoh16_buf(u16 *buf, unsigned int size)
+{
+	size /= 2;
+	while (size--)
+		*(buf + size) = le16_to_cpu(*(buf + size));
+}
+
+static inline void htol16_buf(u16 *buf, unsigned int size)
+{
+	size /= 2;
+	while (size--)
+		*(buf + size) = cpu_to_le16(*(buf + size));
+}
 
 /* Initialization of varbuf structure */
 static void varbuf_init(struct brcms_varbuf *b, char *buf, uint size)
@@ -864,167 +893,6 @@ static int varbuf_append(struct brcms_varbuf *b, const char *fmt, ...)
 	return r;
 }
 
-/*
- * Initialize local vars from the right source for this platform.
- * Return 0 on success, nonzero on error.
- */
-int srom_var_init(struct si_pub *sih, void *curmap, char **vars, uint *count)
-{
-	uint len;
-
-	len = 0;
-
-	if (vars == NULL || count == NULL)
-		return 0;
-
-	*vars = NULL;
-	*count = 0;
-
-	if (curmap != NULL)
-		return initvars_srom_pci(sih, curmap, vars, count);
-
-	return -EINVAL;
-}
-
-static inline void ltoh16_buf(u16 *buf, unsigned int size)
-{
-	size /= 2;
-	while (size--)
-		*(buf + size) = le16_to_cpu(*(buf + size));
-}
-
-static inline void htol16_buf(u16 *buf, unsigned int size)
-{
-	size /= 2;
-	while (size--)
-		*(buf + size) = cpu_to_le16(*(buf + size));
-}
-
-/*
- * Read in and validate sprom.
- * Return 0 on success, nonzero on error.
- */
-static int
-sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
-	       u16 *buf, uint nwords, bool check_crc)
-{
-	int err = 0;
-	uint i;
-
-	/* read the sprom */
-	for (i = 0; i < nwords; i++)
-		buf[i] = R_REG(&sprom[wordoff + i]);
-
-	if (check_crc) {
-
-		if (buf[0] == 0xffff)
-			/*
-			 * The hardware thinks that an srom that starts with
-			 * 0xffff is blank, regardless of the rest of the
-			 * content, so declare it bad.
-			 */
-			return -ENODATA;
-
-		/* fixup the endianness so crc8 will pass */
-		htol16_buf(buf, nwords * 2);
-		if (crc8(srom_crc8_table, (u8 *) buf, nwords * 2,
-			 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(srom_crc8_table))
-			/* DBG only pci always read srom4 first, then srom8/9 */
-			err = -EIO;
-
-		/* now correct the endianness of the byte array */
-		ltoh16_buf(buf, nwords * 2);
-	}
-	return err;
-}
-
-static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
-{
-	u8 *otp;
-	uint sz = OTP_SZ_MAX / 2;	/* size in words */
-	int err = 0;
-
-	otp = kzalloc(OTP_SZ_MAX, GFP_ATOMIC);
-	if (otp == NULL)
-		return -ENOMEM;
-
-	err = otp_read_region(sih, OTP_HW_RGN, (u16 *) otp, &sz);
-
-	memcpy(buf, otp, bufsz);
-
-	kfree(otp);
-
-	/* Check CRC */
-	if (buf[0] == 0xffff)
-		/* The hardware thinks that an srom that starts with 0xffff
-		 * is blank, regardless of the rest of the content, so declare
-		 * it bad.
-		 */
-		return -ENODATA;
-
-	/* fixup the endianness so crc8 will pass */
-	htol16_buf(buf, bufsz);
-	if (crc8(srom_crc8_table, (u8 *) buf, SROM4_WORDS * 2,
-		 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(srom_crc8_table))
-		err = -EIO;
-
-	/* now correct the endianness of the byte array */
-	ltoh16_buf(buf, bufsz);
-
-	return err;
-}
-
-/*
-* Create variable table from memory.
-* Return 0 on success, nonzero on error.
-*/
-static int initvars_table(char *start, char *end,
-			  char **vars, uint *count)
-{
-	int c = (int)(end - start);
-
-	/* do it only when there is more than just the null string */
-	if (c > 1) {
-		char *vp = kmalloc(c, GFP_ATOMIC);
-		if (!vp)
-			return -ENOMEM;
-		memcpy(vp, start, c);
-		*vars = vp;
-		*count = c;
-	} else {
-		*vars = NULL;
-		*count = 0;
-	}
-
-	return 0;
-}
-
-/* Parse SROM and create name=value pairs. 'srom' points to
- * the SROM word array. 'off' specifies the offset of the
- * first word 'srom' points to, which should be either 0 or
- * SROM3_SWRG_OFF (full SROM or software region).
- */
-
-static uint mask_shift(u16 mask)
-{
-	uint i;
-	for (i = 0; i < (sizeof(mask) << 3); i++) {
-		if (mask & (1 << i))
-			return i;
-	}
-	return 0;
-}
-
-static uint mask_width(u16 mask)
-{
-	int i;
-	for (i = (sizeof(mask) << 3) - 1; i >= 0; i--) {
-		if (mask & (1 << i))
-			return (uint) (i - mask_shift(mask) + 1);
-	}
-	return 0;
-}
-
 static void
 _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 {
@@ -1160,6 +1028,105 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 }
 
 /*
+ * Read in and validate sprom.
+ * Return 0 on success, nonzero on error.
+ */
+static int
+sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
+	       u16 *buf, uint nwords, bool check_crc)
+{
+	int err = 0;
+	uint i;
+
+	/* read the sprom */
+	for (i = 0; i < nwords; i++)
+		buf[i] = R_REG(&sprom[wordoff + i]);
+
+	if (check_crc) {
+
+		if (buf[0] == 0xffff)
+			/*
+			 * The hardware thinks that an srom that starts with
+			 * 0xffff is blank, regardless of the rest of the
+			 * content, so declare it bad.
+			 */
+			return -ENODATA;
+
+		/* fixup the endianness so crc8 will pass */
+		htol16_buf(buf, nwords * 2);
+		if (crc8(srom_crc8_table, (u8 *) buf, nwords * 2,
+			 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(srom_crc8_table))
+			/* DBG only pci always read srom4 first, then srom8/9 */
+			err = -EIO;
+
+		/* now correct the endianness of the byte array */
+		ltoh16_buf(buf, nwords * 2);
+	}
+	return err;
+}
+
+static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
+{
+	u8 *otp;
+	uint sz = OTP_SZ_MAX / 2;	/* size in words */
+	int err = 0;
+
+	otp = kzalloc(OTP_SZ_MAX, GFP_ATOMIC);
+	if (otp == NULL)
+		return -ENOMEM;
+
+	err = otp_read_region(sih, OTP_HW_RGN, (u16 *) otp, &sz);
+
+	memcpy(buf, otp, bufsz);
+
+	kfree(otp);
+
+	/* Check CRC */
+	if (buf[0] == 0xffff)
+		/* The hardware thinks that an srom that starts with 0xffff
+		 * is blank, regardless of the rest of the content, so declare
+		 * it bad.
+		 */
+		return -ENODATA;
+
+	/* fixup the endianness so crc8 will pass */
+	htol16_buf(buf, bufsz);
+	if (crc8(srom_crc8_table, (u8 *) buf, SROM4_WORDS * 2,
+		 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(srom_crc8_table))
+		err = -EIO;
+
+	/* now correct the endianness of the byte array */
+	ltoh16_buf(buf, bufsz);
+
+	return err;
+}
+
+/*
+* Create variable table from memory.
+* Return 0 on success, nonzero on error.
+*/
+static int initvars_table(char *start, char *end,
+			  char **vars, uint *count)
+{
+	int c = (int)(end - start);
+
+	/* do it only when there is more than just the null string */
+	if (c > 1) {
+		char *vp = kmalloc(c, GFP_ATOMIC);
+		if (!vp)
+			return -ENOMEM;
+		memcpy(vp, start, c);
+		*vars = vp;
+		*count = c;
+	} else {
+		*vars = NULL;
+		*count = 0;
+	}
+
+	return 0;
+}
+
+/*
  * Initialize nonvolatile variable table from sprom.
  * Return 0 on success, nonzero on error.
  */
@@ -1249,3 +1216,25 @@ errout:
 	kfree(srom);
 	return err;
 }
+
+/*
+ * Initialize local vars from the right source for this platform.
+ * Return 0 on success, nonzero on error.
+ */
+int srom_var_init(struct si_pub *sih, void *curmap, char **vars, uint *count)
+{
+	uint len;
+
+	len = 0;
+
+	if (vars == NULL || count == NULL)
+		return 0;
+
+	*vars = NULL;
+	*count = 0;
+
+	if (curmap != NULL)
+		return initvars_srom_pci(sih, curmap, vars, count);
+
+	return -EINVAL;
+}
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index a4c5c63..0c32e20 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -30,15 +30,6 @@
 #define BRCMS_STF_SS_STBC_RX(wlc) (BRCMS_ISNPHY(wlc->band) && \
 	NREV_GT(wlc->band->phyrev, 3) && NREV_LE(wlc->band->phyrev, 6))
 
-static bool brcms_c_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val);
-static int brcms_c_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts, u8 val);
-static int brcms_c_stf_spatial_policy_set(struct brcms_c_info *wlc, int val);
-static void brcms_c_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val);
-
-static void _brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc);
-static u16 _brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
-				       u32 rspec);
-
 #define NSTS_1	1
 #define NSTS_2	2
 #define NSTS_3	3
@@ -222,6 +213,60 @@ static int brcms_c_stf_spatial_policy_set(struct brcms_c_info *wlc, int val)
 	return 0;
 }
 
+/*
+ * Centralized txant update function. call it whenever wlc->stf->txant and/or
+ * wlc->stf->txchain change.
+ *
+ * Antennas are controlled by ucode indirectly, which drives PHY or GPIO to
+ * achieve various tx/rx antenna selection schemes
+ *
+ * legacy phy, bit 6 and bit 7 means antenna 0 and 1 respectively, bit6+bit7
+ * means auto(last rx).
+ * for NREV<3, bit 6 and bit 7 means antenna 0 and 1 respectively, bit6+bit7
+ * means last rx and do tx-antenna selection for SISO transmissions
+ * for NREV=3, bit 6 and bit _8_ means antenna 0 and 1 respectively, bit6+bit7
+ * means last rx and do tx-antenna selection for SISO transmissions
+ * for NREV>=7, bit 6 and bit 7 mean antenna 0 and 1 respectively, nit6+bit7
+ * means both cores active
+*/
+static void _brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
+{
+	s8 txant;
+
+	txant = (s8) wlc->stf->txant;
+	if (BRCMS_PHY_11N_CAP(wlc->band)) {
+		if (txant == ANT_TX_FORCE_0) {
+			wlc->stf->phytxant = PHY_TXC_ANT_0;
+		} else if (txant == ANT_TX_FORCE_1) {
+			wlc->stf->phytxant = PHY_TXC_ANT_1;
+
+			if (BRCMS_ISNPHY(wlc->band) &&
+			    NREV_GE(wlc->band->phyrev, 3)
+			    && NREV_LT(wlc->band->phyrev, 7))
+				wlc->stf->phytxant = PHY_TXC_ANT_2;
+		} else {
+			if (BRCMS_ISLCNPHY(wlc->band) ||
+			    BRCMS_ISSSLPNPHY(wlc->band))
+				wlc->stf->phytxant = PHY_TXC_LCNPHY_ANT_LAST;
+			else {
+				/* catch out of sync wlc->stf->txcore */
+				WARN_ON(wlc->stf->txchain <= 0);
+				wlc->stf->phytxant =
+				    wlc->stf->txchain << PHY_TXC_ANT_SHIFT;
+			}
+		}
+	} else {
+		if (txant == ANT_TX_FORCE_0)
+			wlc->stf->phytxant = PHY_TXC_OLD_ANT_0;
+		else if (txant == ANT_TX_FORCE_1)
+			wlc->stf->phytxant = PHY_TXC_OLD_ANT_1;
+		else
+			wlc->stf->phytxant = PHY_TXC_OLD_ANT_LAST;
+	}
+
+	brcms_b_txant_set(wlc->hw, wlc->stf->phytxant);
+}
+
 int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 {
 	u8 txchain = (u8) int_val;
@@ -358,60 +403,6 @@ void brcms_c_stf_detach(struct brcms_c_info *wlc)
 {
 }
 
-/*
- * Centralized txant update function. call it whenever wlc->stf->txant and/or
- * wlc->stf->txchain change.
- *
- * Antennas are controlled by ucode indirectly, which drives PHY or GPIO to
- * achieve various tx/rx antenna selection schemes
- *
- * legacy phy, bit 6 and bit 7 means antenna 0 and 1 respectively, bit6+bit7
- * means auto(last rx).
- * for NREV<3, bit 6 and bit 7 means antenna 0 and 1 respectively, bit6+bit7
- * means last rx and do tx-antenna selection for SISO transmissions
- * for NREV=3, bit 6 and bit _8_ means antenna 0 and 1 respectively, bit6+bit7
- * means last rx and do tx-antenna selection for SISO transmissions
- * for NREV>=7, bit 6 and bit 7 mean antenna 0 and 1 respectively, nit6+bit7
- * means both cores active
-*/
-static void _brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
-{
-	s8 txant;
-
-	txant = (s8) wlc->stf->txant;
-	if (BRCMS_PHY_11N_CAP(wlc->band)) {
-		if (txant == ANT_TX_FORCE_0) {
-			wlc->stf->phytxant = PHY_TXC_ANT_0;
-		} else if (txant == ANT_TX_FORCE_1) {
-			wlc->stf->phytxant = PHY_TXC_ANT_1;
-
-			if (BRCMS_ISNPHY(wlc->band) &&
-			    NREV_GE(wlc->band->phyrev, 3)
-			    && NREV_LT(wlc->band->phyrev, 7))
-				wlc->stf->phytxant = PHY_TXC_ANT_2;
-		} else {
-			if (BRCMS_ISLCNPHY(wlc->band) ||
-			    BRCMS_ISSSLPNPHY(wlc->band))
-				wlc->stf->phytxant = PHY_TXC_LCNPHY_ANT_LAST;
-			else {
-				/* catch out of sync wlc->stf->txcore */
-				WARN_ON(wlc->stf->txchain <= 0);
-				wlc->stf->phytxant =
-				    wlc->stf->txchain << PHY_TXC_ANT_SHIFT;
-			}
-		}
-	} else {
-		if (txant == ANT_TX_FORCE_0)
-			wlc->stf->phytxant = PHY_TXC_OLD_ANT_0;
-		else if (txant == ANT_TX_FORCE_1)
-			wlc->stf->phytxant = PHY_TXC_OLD_ANT_1;
-		else
-			wlc->stf->phytxant = PHY_TXC_OLD_ANT_LAST;
-	}
-
-	brcms_b_txant_set(wlc->hw, wlc->stf->phytxant);
-}
-
 void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
 {
 	_brcms_c_stf_phy_txant_upd(wlc);
-- 
1.7.4.1


