Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58727 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751008AbZH3XPz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2009 19:15:55 -0400
Message-ID: <4A9B082A.5080407@gmx.de>
Date: Mon, 31 Aug 2009 01:15:54 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ar9170: added phy register initialisation from eeprom values
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the initialisation of some PHY registers
from the modal_header[] values in the EEPROM (see otus/hal/hpmain.c, line 333 ff.)

Signed-off-by: Joerg Albert <jal2@gmx.de>

---
 drivers/net/wireless/ath/ar9170/phy.c |  129 ++++++++++++++++++++++++++++++++-
 1 files changed, 128 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index cb8b5cd..47a5e5c 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -396,6 +396,131 @@ static struct ar9170_phy_init ar5416_phy_init[] = {
 	{ 0x1c9384, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, }
 };
 
+/* look up a certain register in ar5416_phy_init[] and return the init. value
+   for the band and bandwidth given. Return 0 if register address not found. */
+u32 ar9170_get_default_phy_reg_val(int reg, bool is_2ghz, bool is_40mhz)
+{
+	struct ar9170_phy_init *p;
+	struct ar9170_phy_init *endp =
+		ar5416_phy_init+ARRAY_SIZE(ar5416_phy_init);
+
+	for (p = ar5416_phy_init; p < endp; p++)
+		if (p->reg == reg) {
+			if (is_2ghz)
+				return is_40mhz ? p->_2ghz_40 : p->_2ghz_20;
+			else
+				return is_40mhz ? p->_5ghz_40 : p->_5ghz_20;
+		}
+	return 0;
+}
+
+/* initialize some phy regs from eeprom values in modal_header[]
+   acc. to band and bandwith */
+static int ar9170_init_phy_from_eeprom(struct ar9170 *ar,
+				bool is_2ghz, bool is_40mhz)
+{
+	const u8 xpd2pd[16] = {
+		0x2, 0x2, 0x2, 0x1, 0x2, 0x2, 0x6, 0x2,
+		0x2, 0x3, 0x7, 0x2, 0xB, 0x2, 0x2, 0x2
+	};
+	u32 defval, newval; /* two separate for debugging the changes */
+	/* pointer to the modal_header acc. to band */
+	struct ar9170_eeprom_modal *m = ar->eeprom.modal_header +
+		(is_2ghz ? 1 : 0);
+
+	ar9170_regwrite_begin(ar);
+
+	/* ant common control (index 0) */
+	defval = ar9170_get_default_phy_reg_val(0x1c5964, is_2ghz, is_40mhz);
+	newval = le32_to_cpu(m->antCtrlCommon);
+	ar9170_regwrite(0x1c5964, newval);
+
+	/* ant control chain 0 (index 1) */
+	defval = ar9170_get_default_phy_reg_val(0x1c5960, is_2ghz, is_40mhz);
+	newval = le32_to_cpu(m->antCtrlChain[0]);
+	ar9170_regwrite(0x1c5960, newval);
+
+	/* ant control chain 2 (index 2) */
+	defval = ar9170_get_default_phy_reg_val(0x1c7960, is_2ghz, is_40mhz);
+	newval = le32_to_cpu(m->antCtrlChain[1]);
+	ar9170_regwrite(0x1c7960, newval);
+
+	/* SwSettle (index 3) */
+	if (!is_40mhz) {
+		defval = ar9170_get_default_phy_reg_val(0x1c5844,
+							is_2ghz, is_40mhz);
+		newval = (defval & ~0x3f80) | ((m->switchSettling & 0x7f)<<7);
+		ar9170_regwrite(0x1c5844, newval);
+	}
+
+	/* adcDesired, pdaDesired (index 4) */
+	defval = ar9170_get_default_phy_reg_val(0x1c5850, is_2ghz, is_40mhz);
+	newval = (defval & ~0xffff) | ((u8)m->pgaDesiredSize << 8) |
+		((u8)m->adcDesiredSize);
+	ar9170_regwrite(0x1c5850, newval);
+
+	/* TxEndToXpaOff, TxFrameToXpaOn (index 5) */
+	defval = ar9170_get_default_phy_reg_val(0x1c5834, is_2ghz, is_40mhz);
+	newval = (m->txEndToXpaOff << 24) | (m->txEndToXpaOff << 16) |
+		(m->txFrameToXpaOn << 8) | m->txFrameToXpaOn;
+	ar9170_regwrite(0x1c5834, newval);
+
+	/* TxEndToRxOn (index 6) */
+	defval = ar9170_get_default_phy_reg_val(0x1c5828, is_2ghz, is_40mhz);
+	newval = (defval & ~0xff0000) | (m->txEndToRxOn << 16);
+	ar9170_regwrite(0x1c5828, newval);
+
+	/* thresh62 (index 7) */
+	defval = ar9170_get_default_phy_reg_val(0x1c8864, is_2ghz, is_40mhz);
+	newval = (defval & ~0x7f000) | (m->thresh62 << 12);
+	ar9170_regwrite(0x1c8864, newval);
+
+	/* tx/rx attenuation chain 0 (index 8) */
+	defval = ar9170_get_default_phy_reg_val(0x1c5848, is_2ghz, is_40mhz);
+	newval = (defval & ~0x3f000) | ((m->txRxAttenCh[0] & 0x3f) << 12);
+	ar9170_regwrite(0x1c5848, newval);
+
+	/* tx/rx attenuation chain 2 (index 9) */
+	defval = ar9170_get_default_phy_reg_val(0x1c7848, is_2ghz, is_40mhz);
+	newval = (defval & ~0x3f000) | ((m->txRxAttenCh[1] & 0x3f) << 12);
+	ar9170_regwrite(0x1c7848, newval);
+
+	/* tx/rx margin chain 0 (index 10) */
+	defval = ar9170_get_default_phy_reg_val(0x1c620c, is_2ghz, is_40mhz);
+	newval = (defval & ~0xfc0000) | ((m->rxTxMarginCh[0] & 0x3f) << 18);
+	/* bsw margin chain 0 for 5GHz only */
+	if (!is_2ghz)
+		newval = (newval & ~0x3c00) | ((m->bswMargin[0] & 0xf) << 10);
+	ar9170_regwrite(0x1c620c, newval);
+
+	/* tx/rx margin chain 2 (index 11) */
+	defval = ar9170_get_default_phy_reg_val(0x1c820c, is_2ghz, is_40mhz);
+	newval = (defval & ~0xfc0000) | ((m->rxTxMarginCh[1] & 0x3f) << 18);
+	ar9170_regwrite(0x1c820c, newval);
+
+	/* iqCall, iqCallq chain 0 (index 12) */
+	defval = ar9170_get_default_phy_reg_val(0x1c5920, is_2ghz, is_40mhz);
+	newval = (defval & ~0x7ff) | (((u8)m->iqCalICh[0] & 0x3f) << 5) |
+		((u8)m->iqCalQCh[0] & 0x1f);
+	ar9170_regwrite(0x1c5920, newval);
+
+	/* iqCall, iqCallq chain 2 (index 13) */
+	defval = ar9170_get_default_phy_reg_val(0x1c7920, is_2ghz, is_40mhz);
+	newval = (defval & ~0x7ff) | (((u8)m->iqCalICh[1] & 0x3f) << 5) |
+		((u8)m->iqCalQCh[1] & 0x1f);
+	ar9170_regwrite(0x1c7920, newval);
+
+	/* xpd gain mask (index 14) */
+	defval = ar9170_get_default_phy_reg_val(0x1c6258, is_2ghz, is_40mhz);
+	newval = (defval & ~0xf0000) | (xpd2pd[m->xpdGain & 0xf] << 16);
+	ar9170_regwrite(0x1c6258, newval);
+
+
+	ar9170_regwrite_finish();
+
+	return ar9170_regwrite_result();
+}
+
 int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
 {
 	int i, err;
@@ -426,7 +551,9 @@ int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
 	if (err)
 		return err;
 
-	/* XXX: use EEPROM data here! */
+	err = ar9170_init_phy_from_eeprom(ar, is_2ghz, is_40mhz);
+	if (err)
+		return err;
 
 	err = ar9170_init_power_cal(ar);
 	if (err)
-- 
1.6.0.4


