Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:41320 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbZHaJxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 05:53:37 -0400
Date: Mon, 31 Aug 2009 11:53:37 +0200
Message-Id: <1789900589@web.de>
MIME-Version: 1.0
From: Chunkeey@web.de
To: Joerg Albert <jal2@gmx.de>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: =?iso-8859-15?Q?Re:_[PATCH]_ar9170:_added_phy_register_initialisation_?=
 =?iso-8859-15?Q?from_eeprom_values?=
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> "Joerg Albert" <jal2@gmx.de> wrote:
>
> This patch adds the initialisation of some PHY registers
> from the modal_header[] values in the EEPROM (see otus/hal/hpmain.c, line 333 ff.)
> 
> Signed-off-by: Joerg Albert <jal2@gmx.de>

meh, no hardware... and only a shitty kiosk with web-interface here.
testing has to wait until the weekend.
 
> diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
> index cb8b5cd..47a5e5c 100644
> --- a/drivers/net/wireless/ath/ar9170/phy.c
> +++ b/drivers/net/wireless/ath/ar9170/phy.c
> @@ -396,6 +396,131 @@ static struct ar9170_phy_init ar5416_phy_init[] = {
>  	{ 0x1c9384, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, 0xf3307ff0, }
>  };
>  
> +/* look up a certain register in ar5416_phy_init[] and return the init. value
> +   for the band and bandwidth given. Return 0 if register address not found. */
See Documentation/CodingStyle - Chapter 8

The preferred style for long (multi-line) comments is:
/*
 * look up a certain register in ar5416_phy_init[] and return the init. value
 * for the band and bandwidth given. Return 0 if register address not found.
 */

> +u32 ar9170_get_default_phy_reg_val(int reg, bool is_2ghz, bool is_40mhz)
please consider this instead: 
static u32 ar9170_get_default_phy_reg_val(u32 reg, [...])
(static function, and reg is a u32)

> +{
> +	struct ar9170_phy_init *p;
> +	struct ar9170_phy_init *endp =
> +		ar5416_phy_init+ARRAY_SIZE(ar5416_phy_init);
(see Codingstyle: 3.1:  Spaces
  => Use one space around (on each side of) most binary [...] operators)

> +
> +	for (p = ar5416_phy_init; p < endp; p++)
a extra { } wouldn't hurt. The following statements also has multiple lines.

> +		if (p->reg == reg) {
> +			if (is_2ghz)
> +				return is_40mhz ? p->_2ghz_40 : p->_2ghz_20;
> +			else
> +				return is_40mhz ? p->_5ghz_40 : p->_5ghz_20;
> +		}
> +	return 0;
> +}
hmm, it's a bit odd to use pointers over a fixed array,
what about (unfortunately space and line damaged... and untested):

{
        unsigned int i;
        for (i = 0; i < ARRAY_SIZE(ar5416_phy_init); i++) {
                if (ar5416_phy_init[i].reg != reg)
                        continue;

                if (is_2ghz) {
                        if (is_40mhz)
                                return ar5416_phy_init[i]._2ghz_40;
                        else
                                return ar5416_phy_init[i]._2ghz_20;
                } else {
                        if (is_40mhz)
                                return ar5416_phy_init[i]._5ghz_40;
                        else
                                return ar5416_phy_init[i]._5ghz_20;
                }
        }
        return 0;
}
this follows the looks of the rest of the code. (e.g ar9170_init_phy)
(of course, either version should be fine.
 so stay with yours if you have doubts.)

> +/* initialize some phy regs from eeprom values in modal_header[]
> +   acc. to band and bandwith */
(multi-line comment, but I guess you know what do here now...)

> +static int ar9170_init_phy_from_eeprom(struct ar9170 *ar,
> +				bool is_2ghz, bool is_40mhz)
> +{
> +	const u8 xpd2pd[16] = {
> +		0x2, 0x2, 0x2, 0x1, 0x2, 0x2, 0x6, 0x2,
> +		0x2, 0x3, 0x7, 0x2, 0xB, 0x2, 0x2, 0x2
> +	};
static const u8 xpd2pd ?

> +	u32 defval, newval; /* two separate for debugging the changes */
> +	/* pointer to the modal_header acc. to band */
> +	struct ar9170_eeprom_modal *m = ar->eeprom.modal_header +
> +		(is_2ghz ? 1 : 0);
what about:
struct ar9170_eeprom_modal *m = &ar->eeprom.modal_header[is_2ghz]; ?

> +	ar9170_regwrite_begin(ar);
> +
> +	/* ant common control (index 0) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c5964, is_2ghz, is_40mhz);
> +	newval = le32_to_cpu(m->antCtrlCommon);
> +	ar9170_regwrite(0x1c5964, newval);
> +
> +	/* ant control chain 0 (index 1) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c5960, is_2ghz, is_40mhz);
> +	newval = le32_to_cpu(m->antCtrlChain[0]);
> +	ar9170_regwrite(0x1c5960, newval);
> +
> +	/* ant control chain 2 (index 2) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c7960, is_2ghz, is_40mhz);
> +	newval = le32_to_cpu(m->antCtrlChain[1]);
> +	ar9170_regwrite(0x1c7960, newval);
> +
> +	/* SwSettle (index 3) */
> +	if (!is_40mhz) {
> +		defval = ar9170_get_default_phy_reg_val(0x1c5844,
> +							is_2ghz, is_40mhz);
> +		newval = (defval & ~0x3f80) | ((m->switchSettling & 0x7f)<<7);
(well )<<7 is a bit tight, but it looks like you ran out of space in this line?)
  
> +		ar9170_regwrite(0x1c5844, newval);
> +	}
> +
> +	/* adcDesired, pdaDesired (index 4) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c5850, is_2ghz, is_40mhz);
> +	newval = (defval & ~0xffff) | ((u8)m->pgaDesiredSize << 8) |
> +		((u8)m->adcDesiredSize);
> +	ar9170_regwrite(0x1c5850, newval);
> +
> +	/* TxEndToXpaOff, TxFrameToXpaOn (index 5) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c5834, is_2ghz, is_40mhz);
> +	newval = (m->txEndToXpaOff << 24) | (m->txEndToXpaOff << 16) |
> +		(m->txFrameToXpaOn << 8) | m->txFrameToXpaOn;
> +	ar9170_regwrite(0x1c5834, newval);
> +
> +	/* TxEndToRxOn (index 6) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c5828, is_2ghz, is_40mhz);
> +	newval = (defval & ~0xff0000) | (m->txEndToRxOn << 16);
> +	ar9170_regwrite(0x1c5828, newval);
> +
> +	/* thresh62 (index 7) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c8864, is_2ghz, is_40mhz);
> +	newval = (defval & ~0x7f000) | (m->thresh62 << 12);
> +	ar9170_regwrite(0x1c8864, newval);
> +
> +	/* tx/rx attenuation chain 0 (index 8) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c5848, is_2ghz, is_40mhz);
> +	newval = (defval & ~0x3f000) | ((m->txRxAttenCh[0] & 0x3f) << 12);
> +	ar9170_regwrite(0x1c5848, newval);
> +
> +	/* tx/rx attenuation chain 2 (index 9) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c7848, is_2ghz, is_40mhz);
> +	newval = (defval & ~0x3f000) | ((m->txRxAttenCh[1] & 0x3f) << 12);
> +	ar9170_regwrite(0x1c7848, newval);
> +
> +	/* tx/rx margin chain 0 (index 10) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c620c, is_2ghz, is_40mhz);
> +	newval = (defval & ~0xfc0000) | ((m->rxTxMarginCh[0] & 0x3f) << 18);
> +	/* bsw margin chain 0 for 5GHz only */
> +	if (!is_2ghz)
> +		newval = (newval & ~0x3c00) | ((m->bswMargin[0] & 0xf) << 10);
> +	ar9170_regwrite(0x1c620c, newval);
> +
> +	/* tx/rx margin chain 2 (index 11) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c820c, is_2ghz, is_40mhz);
> +	newval = (defval & ~0xfc0000) | ((m->rxTxMarginCh[1] & 0x3f) << 18);
> +	ar9170_regwrite(0x1c820c, newval);
> +
> +	/* iqCall, iqCallq chain 0 (index 12) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c5920, is_2ghz, is_40mhz);
> +	newval = (defval & ~0x7ff) | (((u8)m->iqCalICh[0] & 0x3f) << 5) |
> +		((u8)m->iqCalQCh[0] & 0x1f);
> +	ar9170_regwrite(0x1c5920, newval);
> +
> +	/* iqCall, iqCallq chain 2 (index 13) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c7920, is_2ghz, is_40mhz);
> +	newval = (defval & ~0x7ff) | (((u8)m->iqCalICh[1] & 0x3f) << 5) |
> +		((u8)m->iqCalQCh[1] & 0x1f);
> +	ar9170_regwrite(0x1c7920, newval);
> +
> +	/* xpd gain mask (index 14) */
> +	defval = ar9170_get_default_phy_reg_val(0x1c6258, is_2ghz, is_40mhz);
> +	newval = (defval & ~0xf0000) | (xpd2pd[m->xpdGain & 0xf] << 16);
> +	ar9170_regwrite(0x1c6258, newval);
(cannot test this now. it looks good, though.)
It's amazing how much **** you can _cut_ from the vendor driver.

BTW: does this patch help the 1-stage fw stability, or is it still broken?

Regards,
   Chr

________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

