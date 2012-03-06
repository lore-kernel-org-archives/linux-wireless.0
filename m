Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46148 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604Ab2CFXYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 18:24:07 -0500
Message-ID: <4F569C78.90204@hauke-m.de> (sfid-20120307_002413_135787_E2929220)
Date: Wed, 07 Mar 2012 00:23:36 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Rafal Milecki <zajec5@gmail.com>, linux-wireless@vger.kernel.org,
	b43-dev-list <b43-dev@lists.infradead.org>
Subject: Re: [RFC] bcma: replace ssb_sprom structure with bcma_sprom structure
References: <1331036818-9240-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1331036818-9240-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2012 01:26 PM, Arend van Spriel wrote:
> BCMA shared a structure with SSB in which sprom data was stored. This
> could have been appropriate but with upcoming srom revisions that are
> of no interest to SSB it is better to have own definitions with BCMA.
> 
> This patch adds support for srom revisions 8 and 9.

Will sprom version 10 contain many new or different attributes so the
struct has to be extended a lot in comparison to the changes made from
version 8 to 9?

> 
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> The BCMA structure is based on internal specifications. Therefor the structure
> fields are not matching the SSB sprom structure. By dropping the use of the SSB
> sprom structure in BCMA a fair amount of work is needed in b43 driver. If it
> helps I can provide a mapping between bcma_sprom and ssb_sprom structure members.
The bcm47xx architecture code will not compile with this patch either.

A quick look into b43 showed that it uses the boardflags flags all other
the code and the other stuff in most cases just in some initialization
function of the specific phy so it should be manageable to use a
different sprom strcut for bcma. Is there any other PHY than the N-PHY
that is used with ssb and bcma?
> 
> The sprom extraction functions show code duplication, which I intend to reduce.
> 
> Gr. AvS
> ---
>  drivers/bcma/driver_chipcommon.c |    7 +-
>  drivers/bcma/sprom.c             | 1452 ++++++++++++++++++++++++++++++++++----
>  include/linux/bcma/bcma.h        |    7 +-
>  include/linux/bcma/bcma_sprom.h  |  201 ++++++
>  4 files changed, 1523 insertions(+), 144 deletions(-)
>  create mode 100644 include/linux/bcma/bcma_sprom.h
> 
> diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
> index e9f1b3f..a6e3281 100644
> --- a/drivers/bcma/driver_chipcommon.c
> +++ b/drivers/bcma/driver_chipcommon.c
> @@ -47,10 +47,9 @@ void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
>  		pr_err("Power control not implemented!\n");
>  
>  	if (cc->core->id.rev >= 16) {
> -		if (cc->core->bus->sprom.leddc_on_time &&
> -		    cc->core->bus->sprom.leddc_off_time) {
> -			leddc_on = cc->core->bus->sprom.leddc_on_time;
> -			leddc_off = cc->core->bus->sprom.leddc_off_time;
> +		if (cc->core->bus->sprom.leddc) {
> +			leddc_on = cc->core->bus->sprom.leddc >> 8;
> +			leddc_off = cc->core->bus->sprom.leddc & 0xFF;
>  		}
>  		bcma_cc_write32(cc, BCMA_CC_GPIOTIMER,
>  			((leddc_on << BCMA_CC_GPIOTIMER_ONTIME_SHIFT) |
> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
> index 19658fd..90d6b1e 100644
> --- a/drivers/bcma/sprom.c
> +++ b/drivers/bcma/sprom.c
> @@ -14,6 +14,1303 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/slab.h>
>  
> +/* Per-path offsets & fields */
> +#define	BCMA_SROM_PATH0		96
> +#define	BCMA_SROM_PATH1		112
> +#define	BCMA_SROM_PATH2		128
> +#define	BCMA_SROM_PATH3		144
> +
> +static int bcma_sprom_get_mask_shift(int mask)
> +{
> +	if (!mask)
> +		return 0;
> +
> +	return ffs(mask) - 1;
> +}
> +
> +static u8 bcma_sprom_extract_u8(bool no_ffs, u16 *data, u16 offset, u16 mask)
> +{
> +	u8 w;
> +
> +	w = (data[offset] & mask) >> bcma_sprom_get_mask_shift(mask);
> +	if (no_ffs && w == 0xFF)
> +		return 0;
> +
> +	return w;
> +}
> +
> +static s8 bcma_sprom_extract_s8(bool no_ffs, u16 *data, u16 offset, u16 mask)
> +{
> +	s8 w;
> +
> +	w = (data[offset] & mask) >> bcma_sprom_get_mask_shift(mask);
> +	if (no_ffs && w == 0xFF)
> +		return 0;
> +
> +	return w;
> +}
> +
> +static u16 bcma_sprom_extract_u16(bool no_ffs, u16 *data, u16 offset, u16 mask)
> +{
> +	u16 w;
> +
> +	w = (data[offset] & mask) >> bcma_sprom_get_mask_shift(mask);
> +	if (no_ffs && w == 0xFFFF)
> +		return 0;
> +
> +	return w;
> +}
> +
> +static s16 bcma_sprom_extract_s16(bool no_ffs, u16 *data, u16 offset, u16 mask)
> +{
> +	s16 w;
> +
> +	w = (data[offset] & mask) >> bcma_sprom_get_mask_shift(mask);
> +	if (no_ffs && w == 0xFFFF)
> +		return 0;
> +
> +	return w;
> +}
> +
> +static u32 bcma_sprom_extract_u32(bool no_ffs, u16 *data, u16 offset, u16 mask)
> +{
> +	u32 w;
> +	u16 wl, wh;
> +
> +	wl = (data[offset] & mask) >> bcma_sprom_get_mask_shift(mask);
> +	wh = (data[offset+1] & mask) >> bcma_sprom_get_mask_shift(mask);
> +	w = (wh << 16) | wl;
> +	if (no_ffs && w == 0xFFFFFFFF)
> +		return 0;
> +
> +	return w;
> +}
> +
> +static s32 bcma_sprom_extract_s32(bool no_ffs, u16 *data, u16 offset, u16 mask)
> +{
> +	s32 w;
> +	u16 wl, wh;
> +
> +	wl = (data[offset] & mask) >> bcma_sprom_get_mask_shift(mask);
> +	wh = (data[offset+1] & mask) >> bcma_sprom_get_mask_shift(mask);
> +	w = (wh << 16) | wl;
> +	if (no_ffs && w == 0xFFFFFFFF)
> +		return 0;
> +
> +	return w;
> +}
> +
> +static void bcma_sprom_extract_ether(u8 *ea, u16 *data, u16 offset)
> +{
> +	ea[0] = (data[offset] >> 8) & 0xff;
> +	ea[1] = data[offset] & 0xff;
> +	ea[2] = (data[offset + 1] >> 8) & 0xff;
> +	ea[3] = data[offset + 1] & 0xff;
> +	ea[4] = (data[offset + 2] >> 8) & 0xff;
> +	ea[5] = data[offset + 2] & 0xff;
> +}
> +
> +/*
> + * srom layout macros for rev 8
> + */
> +#define BCMA_SROM8_DEVID			0x30
> +#define  BCMA_SROM8_DEVID_MASK		0xFFFF
> +#define BCMA_SROM8_BOARDREV			0x41
> +#define  BCMA_SROM8_BOARDREV_MASK		0xFFFF
> +#define BCMA_SROM8_BOARDFLAGS			0x42
> +#define  BCMA_SROM8_BOARDFLAGS_MASK		0xFFFF
> +#define  BCMA_SROM8_BOARDFLAGS_MASK1		0xFFFF
> +#define BCMA_SROM8_BOARDFLAGS2			0x44
> +#define  BCMA_SROM8_BOARDFLAGS2_MASK		0xFFFF
> +#define  BCMA_SROM8_BOARDFLAGS2_MASK1		0xFFFF
> +#define BCMA_SROM8_BOARDTYPE			0x2
> +#define  BCMA_SROM8_BOARDTYPE_MASK		0xFFFF
> +#define BCMA_SROM8_BOARDNUM			0x48
> +#define  BCMA_SROM8_BOARDNUM_MASK		0xFFFF
> +#define BCMA_SROM8_REGREV			0x4A
> +#define  BCMA_SROM8_REGREV_MASK		0xFF
> +#define BCMA_SROM8_LEDBH0			0x4B
> +#define  BCMA_SROM8_LEDBH0_MASK		0xFF
> +#define BCMA_SROM8_LEDBH1			0x4B
> +#define  BCMA_SROM8_LEDBH1_MASK		0xFF00
> +#define BCMA_SROM8_LEDBH2			0x4C
> +#define  BCMA_SROM8_LEDBH2_MASK		0xFF
> +#define BCMA_SROM8_LEDBH3			0x4C
> +#define  BCMA_SROM8_LEDBH3_MASK		0xFF00
> +#define BCMA_SROM8_PA0B0			0x61
> +#define  BCMA_SROM8_PA0B0_MASK		0xFFFF
> +#define BCMA_SROM8_PA0B1			0x62
> +#define  BCMA_SROM8_PA0B1_MASK		0xFFFF
> +#define BCMA_SROM8_PA0B2			0x63
> +#define  BCMA_SROM8_PA0B2_MASK		0xFFFF
> +#define BCMA_SROM8_PA0ITSSIT			0x60
> +#define  BCMA_SROM8_PA0ITSSIT_MASK		0xFF00
> +#define BCMA_SROM8_PA0MAXPWR			0x60
> +#define  BCMA_SROM8_PA0MAXPWR_MASK		0xFF
> +#define BCMA_SROM8_OPO			0xA1
> +#define  BCMA_SROM8_OPO_MASK		0xFF
> +#define BCMA_SROM8_AA2G			0x4E
> +#define  BCMA_SROM8_AA2G_MASK		0xFF
> +#define BCMA_SROM8_AA5G			0x4E
> +#define  BCMA_SROM8_AA5G_MASK		0xFF00
> +#define BCMA_SROM8_AG0			0x4F
> +#define  BCMA_SROM8_AG0_MASK		0xFF
> +#define BCMA_SROM8_AG1			0x4F
> +#define  BCMA_SROM8_AG1_MASK		0xFF00
> +#define BCMA_SROM8_AG2			0x50
> +#define  BCMA_SROM8_AG2_MASK		0xFF
> +#define BCMA_SROM8_AG3			0x50
> +#define  BCMA_SROM8_AG3_MASK		0xFF00
> +#define BCMA_SROM8_PA1B0			0x66
> +#define  BCMA_SROM8_PA1B0_MASK		0xFFFF
> +#define BCMA_SROM8_PA1B1			0x67
> +#define  BCMA_SROM8_PA1B1_MASK		0xFFFF
> +#define BCMA_SROM8_PA1B2			0x68
> +#define  BCMA_SROM8_PA1B2_MASK		0xFFFF
> +#define BCMA_SROM8_PA1LOB0			0x69
> +#define  BCMA_SROM8_PA1LOB0_MASK		0xFFFF
> +#define BCMA_SROM8_PA1LOB1			0x6A
> +#define  BCMA_SROM8_PA1LOB1_MASK		0xFFFF
> +#define BCMA_SROM8_PA1LOB2			0x6B
> +#define  BCMA_SROM8_PA1LOB2_MASK		0xFFFF
> +#define BCMA_SROM8_PA1HIB0			0x6C
> +#define  BCMA_SROM8_PA1HIB0_MASK		0xFFFF
> +#define BCMA_SROM8_PA1HIB1			0x6D
> +#define  BCMA_SROM8_PA1HIB1_MASK		0xFFFF
> +#define BCMA_SROM8_PA1HIB2			0x6E
> +#define  BCMA_SROM8_PA1HIB2_MASK		0xFFFF
> +#define BCMA_SROM8_PA1ITSSIT			0x64
> +#define  BCMA_SROM8_PA1ITSSIT_MASK		0xFF00
> +#define BCMA_SROM8_PA1MAXPWR			0x64
> +#define  BCMA_SROM8_PA1MAXPWR_MASK		0xFF
> +#define BCMA_SROM8_PA1LOMAXPWR			0x65
> +#define  BCMA_SROM8_PA1LOMAXPWR_MASK		0xFF00
> +#define BCMA_SROM8_PA1HIMAXPWR			0x65
> +#define  BCMA_SROM8_PA1HIMAXPWR_MASK		0xFF
> +#define BCMA_SROM8_BXA2G			0x52
> +#define  BCMA_SROM8_BXA2G_MASK		0x1800
> +#define BCMA_SROM8_RSSISAV2G			0x52
> +#define  BCMA_SROM8_RSSISAV2G_MASK		0x700
> +#define BCMA_SROM8_RSSISMC2G			0x52
> +#define  BCMA_SROM8_RSSISMC2G_MASK		0xF0
> +#define BCMA_SROM8_RSSISMF2G			0x52
> +#define  BCMA_SROM8_RSSISMF2G_MASK		0xF
> +#define BCMA_SROM8_BXA5G			0x53
> +#define  BCMA_SROM8_BXA5G_MASK		0x1800
> +#define BCMA_SROM8_RSSISAV5G			0x53
> +#define  BCMA_SROM8_RSSISAV5G_MASK		0x700
> +#define BCMA_SROM8_RSSISMC5G			0x53
> +#define  BCMA_SROM8_RSSISMC5G_MASK		0xF0
> +#define BCMA_SROM8_RSSISMF5G			0x53
> +#define  BCMA_SROM8_RSSISMF5G_MASK		0xF
> +#define BCMA_SROM8_TRI2G			0x54
> +#define  BCMA_SROM8_TRI2G_MASK		0xFF
> +#define BCMA_SROM8_TRI5G			0x54
> +#define  BCMA_SROM8_TRI5G_MASK		0xFF00
> +#define BCMA_SROM8_TRI5GL			0x55
> +#define  BCMA_SROM8_TRI5GL_MASK		0xFF
> +#define BCMA_SROM8_TRI5GH			0x55
> +#define  BCMA_SROM8_TRI5GH_MASK		0xFF00
> +#define BCMA_SROM8_RXPO2G			0x56
> +#define  BCMA_SROM8_RXPO2G_MASK		0xFF
> +#define BCMA_SROM8_RXPO5G			0x56
> +#define  BCMA_SROM8_RXPO5G_MASK		0xFF00
> +#define BCMA_SROM8_TXCHAIN			0x51
> +#define  BCMA_SROM8_TXCHAIN_MASK		0xF
> +#define BCMA_SROM8_RXCHAIN			0x51
> +#define  BCMA_SROM8_RXCHAIN_MASK		0xF0
> +#define BCMA_SROM8_ANTSWITCH			0x51
> +#define  BCMA_SROM8_ANTSWITCH_MASK		0xFF00
> +#define BCMA_SROM8_TSSIPOS2G			0x57
> +#define  BCMA_SROM8_TSSIPOS2G_MASK		0x1
> +#define BCMA_SROM8_EXTPAGAIN2G			0x57
> +#define  BCMA_SROM8_EXTPAGAIN2G_MASK		0x6
> +#define BCMA_SROM8_PDETRANGE2G			0x57
> +#define  BCMA_SROM8_PDETRANGE2G_MASK		0xF8
> +#define BCMA_SROM8_TRISO2G			0x57
> +#define  BCMA_SROM8_TRISO2G_MASK		0x700
> +#define BCMA_SROM8_ANTSWCTL2G			0x57
> +#define  BCMA_SROM8_ANTSWCTL2G_MASK		0xF800
> +#define BCMA_SROM8_TSSIPOS5G			0x58
> +#define  BCMA_SROM8_TSSIPOS5G_MASK		0x1
> +#define BCMA_SROM8_EXTPAGAIN5G			0x58
> +#define  BCMA_SROM8_EXTPAGAIN5G_MASK		0x6
> +#define BCMA_SROM8_PDETRANGE5G			0x58
> +#define  BCMA_SROM8_PDETRANGE5G_MASK		0xF8
> +#define BCMA_SROM8_TRISO5G			0x58
> +#define  BCMA_SROM8_TRISO5G_MASK		0x700
> +#define BCMA_SROM8_ANTSWCTL5G			0x58
> +#define  BCMA_SROM8_ANTSWCTL5G_MASK		0xF800
> +#define BCMA_SROM8_CCODE			0x49
> +#define  BCMA_SROM8_CCODE_MASK		0xFFFF
> +#define BCMA_SROM8_MACADDR			0x46
> +#define  BCMA_SROM8_MACADDR_MASK		0xFFFF
> +#define BCMA_SROM8_LEDDC			0x4D
> +#define  BCMA_SROM8_LEDDC_MASK		0xFFFF
> +#define BCMA_SROM8_TEMPTHRESH			0x59
> +#define  BCMA_SROM8_TEMPTHRESH_MASK		0xFF00
> +#define BCMA_SROM8_TEMPOFFSET			0x59
> +#define  BCMA_SROM8_TEMPOFFSET_MASK		0xFF
> +#define BCMA_SROM8_RAWTEMPSENSE			0x5A
> +#define  BCMA_SROM8_RAWTEMPSENSE_MASK		0x1FF
> +#define BCMA_SROM8_MEASPOWER			0x5A
> +#define  BCMA_SROM8_MEASPOWER_MASK		0xFE00
> +#define BCMA_SROM8_TEMPSENSE_SLOPE			0x5B
> +#define  BCMA_SROM8_TEMPSENSE_SLOPE_MASK		0xFF
> +#define BCMA_SROM8_TEMPCORRX			0x5B
> +#define  BCMA_SROM8_TEMPCORRX_MASK		0xFC00
> +#define BCMA_SROM8_TEMPSENSE_OPTION			0x5B
> +#define  BCMA_SROM8_TEMPSENSE_OPTION_MASK		0x300
> +#define BCMA_SROM8_FREQOFFSET_CORR			0x5C
> +#define  BCMA_SROM8_FREQOFFSET_CORR_MASK		0xF
> +#define BCMA_SROM8_IQCAL_SWP_DIS			0x5C
> +#define  BCMA_SROM8_IQCAL_SWP_DIS_MASK		0x10
> +#define BCMA_SROM8_HW_IQCAL_EN			0x5C
> +#define  BCMA_SROM8_HW_IQCAL_EN_MASK		0x20
> +#define BCMA_SROM8_ELNA2G			0x5D
> +#define  BCMA_SROM8_ELNA2G_MASK		0xFF
> +#define BCMA_SROM8_ELNA5G			0x5D
> +#define  BCMA_SROM8_ELNA5G_MASK		0xFF00
> +#define BCMA_SROM8_PHYCAL_TEMPDELTA			0x5E
> +#define  BCMA_SROM8_PHYCAL_TEMPDELTA_MASK		0xFF
> +#define BCMA_SROM8_TEMPS_PERIOD			0x5E
> +#define  BCMA_SROM8_TEMPS_PERIOD_MASK		0xF00
> +#define BCMA_SROM8_TEMPS_HYSTERESIS			0x5E
> +#define  BCMA_SROM8_TEMPS_HYSTERESIS_MASK		0xF000
> +#define BCMA_SROM8_MEASPOWER1			0x5F
> +#define  BCMA_SROM8_MEASPOWER1_MASK		0x7F
> +#define BCMA_SROM8_MEASPOWER2			0x5F
> +#define  BCMA_SROM8_MEASPOWER2_MASK		0x3F80
> +#define BCMA_SROM8_CCK2GPO			0xA0
> +#define  BCMA_SROM8_CCK2GPO_MASK		0xFFFF
> +#define BCMA_SROM8_OFDM2GPO			0xA1
> +#define  BCMA_SROM8_OFDM2GPO_MASK		0xFFFF
> +#define  BCMA_SROM8_OFDM2GPO_MASK1		0xFFFF
> +#define BCMA_SROM8_OFDM5GPO			0xA3
> +#define  BCMA_SROM8_OFDM5GPO_MASK		0xFFFF
> +#define  BCMA_SROM8_OFDM5GPO_MASK1		0xFFFF
> +#define BCMA_SROM8_OFDM5GLPO			0xA5
> +#define  BCMA_SROM8_OFDM5GLPO_MASK		0xFFFF
> +#define  BCMA_SROM8_OFDM5GLPO_MASK1		0xFFFF
> +#define BCMA_SROM8_OFDM5GHPO			0xA7
> +#define  BCMA_SROM8_OFDM5GHPO_MASK		0xFFFF
> +#define  BCMA_SROM8_OFDM5GHPO_MASK1		0xFFFF
> +#define BCMA_SROM8_MCS2GPO0			0xA9
> +#define  BCMA_SROM8_MCS2GPO0_MASK		0xFFFF
> +#define BCMA_SROM8_MCS2GPO1			0xAA
> +#define  BCMA_SROM8_MCS2GPO1_MASK		0xFFFF
> +#define BCMA_SROM8_MCS2GPO2			0xAB
> +#define  BCMA_SROM8_MCS2GPO2_MASK		0xFFFF
> +#define BCMA_SROM8_MCS2GPO3			0xAC
> +#define  BCMA_SROM8_MCS2GPO3_MASK		0xFFFF
> +#define BCMA_SROM8_MCS2GPO4			0xAD
> +#define  BCMA_SROM8_MCS2GPO4_MASK		0xFFFF
> +#define BCMA_SROM8_MCS2GPO5			0xAE
> +#define  BCMA_SROM8_MCS2GPO5_MASK		0xFFFF
> +#define BCMA_SROM8_MCS2GPO6			0xAF
> +#define  BCMA_SROM8_MCS2GPO6_MASK		0xFFFF
> +#define BCMA_SROM8_MCS2GPO7			0xB0
> +#define  BCMA_SROM8_MCS2GPO7_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GPO0			0xB1
> +#define  BCMA_SROM8_MCS5GPO0_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GPO1			0xB2
> +#define  BCMA_SROM8_MCS5GPO1_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GPO2			0xB3
> +#define  BCMA_SROM8_MCS5GPO2_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GPO3			0xB4
> +#define  BCMA_SROM8_MCS5GPO3_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GPO4			0xB5
> +#define  BCMA_SROM8_MCS5GPO4_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GPO5			0xB6
> +#define  BCMA_SROM8_MCS5GPO5_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GPO6			0xB7
> +#define  BCMA_SROM8_MCS5GPO6_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GPO7			0xB8
> +#define  BCMA_SROM8_MCS5GPO7_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GLPO0			0xB9
> +#define  BCMA_SROM8_MCS5GLPO0_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GLPO1			0xBA
> +#define  BCMA_SROM8_MCS5GLPO1_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GLPO2			0xBB
> +#define  BCMA_SROM8_MCS5GLPO2_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GLPO3			0xBC
> +#define  BCMA_SROM8_MCS5GLPO3_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GLPO4			0xBD
> +#define  BCMA_SROM8_MCS5GLPO4_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GLPO5			0xBE
> +#define  BCMA_SROM8_MCS5GLPO5_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GLPO6			0xBF
> +#define  BCMA_SROM8_MCS5GLPO6_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GLPO7			0xC0
> +#define  BCMA_SROM8_MCS5GLPO7_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GHPO0			0xC1
> +#define  BCMA_SROM8_MCS5GHPO0_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GHPO1			0xC2
> +#define  BCMA_SROM8_MCS5GHPO1_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GHPO2			0xC3
> +#define  BCMA_SROM8_MCS5GHPO2_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GHPO3			0xC4
> +#define  BCMA_SROM8_MCS5GHPO3_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GHPO4			0xC5
> +#define  BCMA_SROM8_MCS5GHPO4_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GHPO5			0xC6
> +#define  BCMA_SROM8_MCS5GHPO5_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GHPO6			0xC7
> +#define  BCMA_SROM8_MCS5GHPO6_MASK		0xFFFF
> +#define BCMA_SROM8_MCS5GHPO7			0xC8
> +#define  BCMA_SROM8_MCS5GHPO7_MASK		0xFFFF
> +#define BCMA_SROM8_CDDPO			0xC9
> +#define  BCMA_SROM8_CDDPO_MASK		0xFFFF
> +#define BCMA_SROM8_STBCPO			0xCA
> +#define  BCMA_SROM8_STBCPO_MASK		0xFFFF
> +#define BCMA_SROM8_BW40PO			0xCB
> +#define  BCMA_SROM8_BW40PO_MASK		0xFFFF
> +#define BCMA_SROM8_BWDUPPO			0xCC
> +#define  BCMA_SROM8_BWDUPPO_MASK		0xFFFF
> +#define BCMA_SROM8_MAXP2GA			0x0
> +#define  BCMA_SROM8_MAXP2GA_MASK		0xFF
> +#define BCMA_SROM8_ITT2GA			0x0
> +#define  BCMA_SROM8_ITT2GA_MASK		0xFF00
> +#define BCMA_SROM8_ITT5GA			0x4
> +#define  BCMA_SROM8_ITT5GA_MASK		0xFF00
> +#define BCMA_SROM8_PA2GW0A			0x1
> +#define  BCMA_SROM8_PA2GW0A_MASK		0xFFFF
> +#define BCMA_SROM8_PA2GW1A			0x2
> +#define  BCMA_SROM8_PA2GW1A_MASK		0xFFFF
> +#define BCMA_SROM8_PA2GW2A			0x3
> +#define  BCMA_SROM8_PA2GW2A_MASK		0xFFFF
> +#define BCMA_SROM8_MAXP5GA			0x4
> +#define  BCMA_SROM8_MAXP5GA_MASK		0xFF
> +#define BCMA_SROM8_MAXP5GHA			0x5
> +#define  BCMA_SROM8_MAXP5GHA_MASK		0xFF
> +#define BCMA_SROM8_MAXP5GLA			0x5
> +#define  BCMA_SROM8_MAXP5GLA_MASK		0xFF00
> +#define BCMA_SROM8_PA5GW0A			0x6
> +#define  BCMA_SROM8_PA5GW0A_MASK		0xFFFF
> +#define BCMA_SROM8_PA5GW1A			0x7
> +#define  BCMA_SROM8_PA5GW1A_MASK		0xFFFF
> +#define BCMA_SROM8_PA5GW2A			0x8
> +#define  BCMA_SROM8_PA5GW2A_MASK		0xFFFF
> +#define BCMA_SROM8_PA5GLW0A			0x9
> +#define  BCMA_SROM8_PA5GLW0A_MASK		0xFFFF
> +#define BCMA_SROM8_PA5GLW1A			0xA
> +#define  BCMA_SROM8_PA5GLW1A_MASK		0xFFFF
> +#define BCMA_SROM8_PA5GLW2A			0xB
> +#define  BCMA_SROM8_PA5GLW2A_MASK		0xFFFF
> +#define BCMA_SROM8_PA5GHW0A			0xC
> +#define  BCMA_SROM8_PA5GHW0A_MASK		0xFFFF
> +#define BCMA_SROM8_PA5GHW1A			0xD
> +#define  BCMA_SROM8_PA5GHW1A_MASK		0xFFFF
> +#define BCMA_SROM8_PA5GHW2A			0xE
> +#define  BCMA_SROM8_PA5GHW2A_MASK		0xFFFF
> +
> +/*
> + * srom layout macros for rev 9
> + */
> +#define BCMA_SROM9_CCKBW202GPO			0xA0
> +#define  BCMA_SROM9_CCKBW202GPO_MASK		0xFFFF
> +#define BCMA_SROM9_CCKBW20UL2GPO			0xA1
> +#define  BCMA_SROM9_CCKBW20UL2GPO_MASK		0xFFFF
> +#define BCMA_SROM9_LEGOFDMBW202GPO			0xA2
> +#define  BCMA_SROM9_LEGOFDMBW202GPO_MASK		0xFFFF
> +#define  BCMA_SROM9_LEGOFDMBW202GPO_MASK1		0xFFFF
> +#define BCMA_SROM9_LEGOFDMBW20UL2GPO			0xA4
> +#define  BCMA_SROM9_LEGOFDMBW20UL2GPO_MASK		0xFFFF
> +#define  BCMA_SROM9_LEGOFDMBW20UL2GPO_MASK1		0xFFFF
> +#define BCMA_SROM9_LEGOFDMBW205GLPO			0xA6
> +#define  BCMA_SROM9_LEGOFDMBW205GLPO_MASK		0xFFFF
> +#define  BCMA_SROM9_LEGOFDMBW205GLPO_MASK1		0xFFFF
> +#define BCMA_SROM9_LEGOFDMBW20UL5GLPO			0xA8
> +#define  BCMA_SROM9_LEGOFDMBW20UL5GLPO_MASK		0xFFFF
> +#define  BCMA_SROM9_LEGOFDMBW20UL5GLPO_MASK1		0xFFFF
> +#define BCMA_SROM9_LEGOFDMBW205GMPO			0xAA
> +#define  BCMA_SROM9_LEGOFDMBW205GMPO_MASK		0xFFFF
> +#define  BCMA_SROM9_LEGOFDMBW205GMPO_MASK1		0xFFFF
> +#define BCMA_SROM9_LEGOFDMBW20UL5GMPO			0xAC
> +#define  BCMA_SROM9_LEGOFDMBW20UL5GMPO_MASK		0xFFFF
> +#define  BCMA_SROM9_LEGOFDMBW20UL5GMPO_MASK1		0xFFFF
> +#define BCMA_SROM9_LEGOFDMBW205GHPO			0xAE
> +#define  BCMA_SROM9_LEGOFDMBW205GHPO_MASK		0xFFFF
> +#define  BCMA_SROM9_LEGOFDMBW205GHPO_MASK1		0xFFFF
> +#define BCMA_SROM9_LEGOFDMBW20UL5GHPO			0xB0
> +#define  BCMA_SROM9_LEGOFDMBW20UL5GHPO_MASK		0xFFFF
> +#define  BCMA_SROM9_LEGOFDMBW20UL5GHPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW202GPO			0xB2
> +#define  BCMA_SROM9_MCSBW202GPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW202GPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW20UL2GPO			0xB4
> +#define  BCMA_SROM9_MCSBW20UL2GPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW20UL2GPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW402GPO			0xB6
> +#define  BCMA_SROM9_MCSBW402GPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW402GPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW205GLPO			0xB8
> +#define  BCMA_SROM9_MCSBW205GLPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW205GLPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW20UL5GLPO			0xBA
> +#define  BCMA_SROM9_MCSBW20UL5GLPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW20UL5GLPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW405GLPO			0xBC
> +#define  BCMA_SROM9_MCSBW405GLPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW405GLPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW205GMPO			0xBE
> +#define  BCMA_SROM9_MCSBW205GMPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW205GMPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW20UL5GMPO			0xC0
> +#define  BCMA_SROM9_MCSBW20UL5GMPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW20UL5GMPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW405GMPO			0xC2
> +#define  BCMA_SROM9_MCSBW405GMPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW405GMPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW205GHPO			0xC4
> +#define  BCMA_SROM9_MCSBW205GHPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW205GHPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW20UL5GHPO			0xC6
> +#define  BCMA_SROM9_MCSBW20UL5GHPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW20UL5GHPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCSBW405GHPO			0xC8
> +#define  BCMA_SROM9_MCSBW405GHPO_MASK		0xFFFF
> +#define  BCMA_SROM9_MCSBW405GHPO_MASK1		0xFFFF
> +#define BCMA_SROM9_MCS32PO			0xCA
> +#define  BCMA_SROM9_MCS32PO_MASK		0xFFFF
> +#define BCMA_SROM9_LEGOFDM40DUPPO			0xCB
> +#define  BCMA_SROM9_LEGOFDM40DUPPO_MASK		0xFFFF
> +
> +/*
> + * srom data extractor for rev 8
> + */
> +void bcma_sprom_extract_rev8(struct bcma_sprom *sprom, u16 *data)
> +{
> +	u16 path_offset[] = { BCMA_SROM_PATH0, BCMA_SROM_PATH1,
> +			      BCMA_SROM_PATH2, BCMA_SROM_PATH3 };
> +	uint path;
> +
> +	/*
> +	 * extract variables
> +	 */
> +	sprom->devid = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_DEVID,
> +					BCMA_SROM8_DEVID_MASK);
> +	sprom->boardrev = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_BOARDREV,
> +					BCMA_SROM8_BOARDREV_MASK);
> +	sprom->boardflags = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM8_BOARDFLAGS,
> +					BCMA_SROM8_BOARDFLAGS_MASK);
> +	sprom->boardflags2 = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM8_BOARDFLAGS2,
> +					BCMA_SROM8_BOARDFLAGS2_MASK);
> +	sprom->boardtype = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_BOARDTYPE,
> +					BCMA_SROM8_BOARDTYPE_MASK);
> +	sprom->boardnum = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_BOARDNUM,
> +					BCMA_SROM8_BOARDNUM_MASK);
> +	sprom->regrev = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_REGREV,
> +					BCMA_SROM8_REGREV_MASK);
> +	sprom->ledbh0 = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_LEDBH0,
> +					BCMA_SROM8_LEDBH0_MASK);
> +	sprom->ledbh1 = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_LEDBH1,
> +					BCMA_SROM8_LEDBH1_MASK);
> +	sprom->ledbh2 = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_LEDBH2,
> +					BCMA_SROM8_LEDBH2_MASK);
> +	sprom->ledbh3 = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_LEDBH3,
> +					BCMA_SROM8_LEDBH3_MASK);
> +	sprom->pa0b0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA0B0,
> +					BCMA_SROM8_PA0B0_MASK);
> +	sprom->pa0b1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA0B1,
> +					BCMA_SROM8_PA0B1_MASK);
> +	sprom->pa0b2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA0B2,
> +					BCMA_SROM8_PA0B2_MASK);
> +	sprom->pa0itssit = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA0ITSSIT,
> +					BCMA_SROM8_PA0ITSSIT_MASK);
> +	sprom->pa0maxpwr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA0MAXPWR,
> +					BCMA_SROM8_PA0MAXPWR_MASK);
> +	sprom->opo = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_OPO,
> +					BCMA_SROM8_OPO_MASK);
> +	sprom->aa2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AA2G,
> +					BCMA_SROM8_AA2G_MASK);
> +	sprom->aa5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AA5G,
> +					BCMA_SROM8_AA5G_MASK);
> +	sprom->ag0 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AG0,
> +					BCMA_SROM8_AG0_MASK);
> +	sprom->ag1 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AG1,
> +					BCMA_SROM8_AG1_MASK);
> +	sprom->ag2 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AG2,
> +					BCMA_SROM8_AG2_MASK);
> +	sprom->ag3 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AG3,
> +					BCMA_SROM8_AG3_MASK);
> +	sprom->pa1b0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1B0,
> +					BCMA_SROM8_PA1B0_MASK);
> +	sprom->pa1b1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1B1,
> +					BCMA_SROM8_PA1B1_MASK);
> +	sprom->pa1b2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1B2,
> +					BCMA_SROM8_PA1B2_MASK);
> +	sprom->pa1lob0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1LOB0,
> +					BCMA_SROM8_PA1LOB0_MASK);
> +	sprom->pa1lob1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1LOB1,
> +					BCMA_SROM8_PA1LOB1_MASK);
> +	sprom->pa1lob2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1LOB2,
> +					BCMA_SROM8_PA1LOB2_MASK);
> +	sprom->pa1hib0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1HIB0,
> +					BCMA_SROM8_PA1HIB0_MASK);
> +	sprom->pa1hib1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1HIB1,
> +					BCMA_SROM8_PA1HIB1_MASK);
> +	sprom->pa1hib2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1HIB2,
> +					BCMA_SROM8_PA1HIB2_MASK);
> +	sprom->pa1itssit = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA1ITSSIT,
> +					BCMA_SROM8_PA1ITSSIT_MASK);
> +	sprom->pa1maxpwr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA1MAXPWR,
> +					BCMA_SROM8_PA1MAXPWR_MASK);
> +	sprom->pa1lomaxpwr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA1LOMAXPWR,
> +					BCMA_SROM8_PA1LOMAXPWR_MASK);
> +	sprom->pa1himaxpwr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA1HIMAXPWR,
> +					BCMA_SROM8_PA1HIMAXPWR_MASK);
> +	sprom->bxa2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_BXA2G,
> +					BCMA_SROM8_BXA2G_MASK);
> +	sprom->rssisav2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISAV2G,
> +					BCMA_SROM8_RSSISAV2G_MASK);
> +	sprom->rssismc2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISMC2G,
> +					BCMA_SROM8_RSSISMC2G_MASK);
> +	sprom->rssismf2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISMF2G,
> +					BCMA_SROM8_RSSISMF2G_MASK);
> +	sprom->bxa5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_BXA5G,
> +					BCMA_SROM8_BXA5G_MASK);
> +	sprom->rssisav5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISAV5G,
> +					BCMA_SROM8_RSSISAV5G_MASK);
> +	sprom->rssismc5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISMC5G,
> +					BCMA_SROM8_RSSISMC5G_MASK);
> +	sprom->rssismf5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISMF5G,
> +					BCMA_SROM8_RSSISMF5G_MASK);
> +	sprom->tri2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRI2G,
> +					BCMA_SROM8_TRI2G_MASK);
> +	sprom->tri5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRI5G,
> +					BCMA_SROM8_TRI5G_MASK);
> +	sprom->tri5gl = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRI5GL,
> +					BCMA_SROM8_TRI5GL_MASK);
> +	sprom->tri5gh = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRI5GH,
> +					BCMA_SROM8_TRI5GH_MASK);
> +	sprom->rxpo2g = bcma_sprom_extract_s8(false, data,
> +					BCMA_SROM8_RXPO2G,
> +					BCMA_SROM8_RXPO2G_MASK);
> +	sprom->rxpo5g = bcma_sprom_extract_s8(false, data,
> +					BCMA_SROM8_RXPO5G,
> +					BCMA_SROM8_RXPO5G_MASK);
> +	sprom->txchain = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_TXCHAIN,
> +					BCMA_SROM8_TXCHAIN_MASK);
> +	sprom->rxchain = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_RXCHAIN,
> +					BCMA_SROM8_RXCHAIN_MASK);
> +	sprom->antswitch = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_ANTSWITCH,
> +					BCMA_SROM8_ANTSWITCH_MASK);
> +	sprom->tssipos2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TSSIPOS2G,
> +					BCMA_SROM8_TSSIPOS2G_MASK);
> +	sprom->extpagain2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_EXTPAGAIN2G,
> +					BCMA_SROM8_EXTPAGAIN2G_MASK);
> +	sprom->pdetrange2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PDETRANGE2G,
> +					BCMA_SROM8_PDETRANGE2G_MASK);
> +	sprom->triso2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRISO2G,
> +					BCMA_SROM8_TRISO2G_MASK);
> +	sprom->antswctl2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_ANTSWCTL2G,
> +					BCMA_SROM8_ANTSWCTL2G_MASK);
> +	sprom->tssipos5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TSSIPOS5G,
> +					BCMA_SROM8_TSSIPOS5G_MASK);
> +	sprom->extpagain5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_EXTPAGAIN5G,
> +					BCMA_SROM8_EXTPAGAIN5G_MASK);
> +	sprom->pdetrange5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PDETRANGE5G,
> +					BCMA_SROM8_PDETRANGE5G_MASK);
> +	sprom->triso5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRISO5G,
> +					BCMA_SROM8_TRISO5G_MASK);
> +	sprom->antswctl5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_ANTSWCTL5G,
> +					BCMA_SROM8_ANTSWCTL5G_MASK);
> +	sprom->ccode = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_CCODE,
> +					BCMA_SROM8_CCODE_MASK);
> +	bcma_sprom_extract_ether(sprom->macaddr, data, BCMA_SROM8_MACADDR);
> +	sprom->leddc = bcma_sprom_extract_u16(true, data,
> +					BCMA_SROM8_LEDDC,
> +					BCMA_SROM8_LEDDC_MASK);
> +	sprom->tempthresh = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPTHRESH,
> +					BCMA_SROM8_TEMPTHRESH_MASK);
> +	sprom->tempoffset = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPOFFSET,
> +					BCMA_SROM8_TEMPOFFSET_MASK);
> +	sprom->rawtempsense = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_RAWTEMPSENSE,
> +					BCMA_SROM8_RAWTEMPSENSE_MASK);
> +	sprom->measpower = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_MEASPOWER,
> +					BCMA_SROM8_MEASPOWER_MASK);
> +	sprom->tempsense_slope = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPSENSE_SLOPE,
> +					BCMA_SROM8_TEMPSENSE_SLOPE_MASK);
> +	sprom->tempcorrx = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPCORRX,
> +					BCMA_SROM8_TEMPCORRX_MASK);
> +	sprom->tempsense_option = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPSENSE_OPTION,
> +					BCMA_SROM8_TEMPSENSE_OPTION_MASK);
> +	sprom->freqoffset_corr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_FREQOFFSET_CORR,
> +					BCMA_SROM8_FREQOFFSET_CORR_MASK);
> +	sprom->iqcal_swp_dis = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_IQCAL_SWP_DIS,
> +					BCMA_SROM8_IQCAL_SWP_DIS_MASK);
> +	sprom->hw_iqcal_en = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_HW_IQCAL_EN,
> +					BCMA_SROM8_HW_IQCAL_EN_MASK);
> +	sprom->elna2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_ELNA2G,
> +					BCMA_SROM8_ELNA2G_MASK);
> +	sprom->elna5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_ELNA5G,
> +					BCMA_SROM8_ELNA5G_MASK);
> +	sprom->phycal_tempdelta = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PHYCAL_TEMPDELTA,
> +					BCMA_SROM8_PHYCAL_TEMPDELTA_MASK);
> +	sprom->temps_period = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPS_PERIOD,
> +					BCMA_SROM8_TEMPS_PERIOD_MASK);
> +	sprom->temps_hysteresis = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPS_HYSTERESIS,
> +					BCMA_SROM8_TEMPS_HYSTERESIS_MASK);
> +	sprom->measpower1 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_MEASPOWER1,
> +					BCMA_SROM8_MEASPOWER1_MASK);
> +	sprom->measpower2 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_MEASPOWER2,
> +					BCMA_SROM8_MEASPOWER2_MASK);
> +	sprom->cck2gpo = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_CCK2GPO,
> +					BCMA_SROM8_CCK2GPO_MASK);
> +	sprom->ofdm2gpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM8_OFDM2GPO,
> +					BCMA_SROM8_OFDM2GPO_MASK);
> +	sprom->ofdm5gpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM8_OFDM5GPO,
> +					BCMA_SROM8_OFDM5GPO_MASK);
> +	sprom->ofdm5glpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM8_OFDM5GLPO,
> +					BCMA_SROM8_OFDM5GLPO_MASK);
> +	sprom->ofdm5ghpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM8_OFDM5GHPO,
> +					BCMA_SROM8_OFDM5GHPO_MASK);
> +	sprom->mcs2gpo0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS2GPO0,
> +					BCMA_SROM8_MCS2GPO0_MASK);
> +	sprom->mcs2gpo1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS2GPO1,
> +					BCMA_SROM8_MCS2GPO1_MASK);
> +	sprom->mcs2gpo2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS2GPO2,
> +					BCMA_SROM8_MCS2GPO2_MASK);
> +	sprom->mcs2gpo3 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS2GPO3,
> +					BCMA_SROM8_MCS2GPO3_MASK);
> +	sprom->mcs2gpo4 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS2GPO4,
> +					BCMA_SROM8_MCS2GPO4_MASK);
> +	sprom->mcs2gpo5 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS2GPO5,
> +					BCMA_SROM8_MCS2GPO5_MASK);
> +	sprom->mcs2gpo6 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS2GPO6,
> +					BCMA_SROM8_MCS2GPO6_MASK);
> +	sprom->mcs2gpo7 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS2GPO7,
> +					BCMA_SROM8_MCS2GPO7_MASK);
> +	sprom->mcs5gpo0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GPO0,
> +					BCMA_SROM8_MCS5GPO0_MASK);
> +	sprom->mcs5gpo1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GPO1,
> +					BCMA_SROM8_MCS5GPO1_MASK);
> +	sprom->mcs5gpo2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GPO2,
> +					BCMA_SROM8_MCS5GPO2_MASK);
> +	sprom->mcs5gpo3 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GPO3,
> +					BCMA_SROM8_MCS5GPO3_MASK);
> +	sprom->mcs5gpo4 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GPO4,
> +					BCMA_SROM8_MCS5GPO4_MASK);
> +	sprom->mcs5gpo5 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GPO5,
> +					BCMA_SROM8_MCS5GPO5_MASK);
> +	sprom->mcs5gpo6 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GPO6,
> +					BCMA_SROM8_MCS5GPO6_MASK);
> +	sprom->mcs5gpo7 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GPO7,
> +					BCMA_SROM8_MCS5GPO7_MASK);
> +	sprom->mcs5glpo0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GLPO0,
> +					BCMA_SROM8_MCS5GLPO0_MASK);
> +	sprom->mcs5glpo1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GLPO1,
> +					BCMA_SROM8_MCS5GLPO1_MASK);
> +	sprom->mcs5glpo2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GLPO2,
> +					BCMA_SROM8_MCS5GLPO2_MASK);
> +	sprom->mcs5glpo3 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GLPO3,
> +					BCMA_SROM8_MCS5GLPO3_MASK);
> +	sprom->mcs5glpo4 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GLPO4,
> +					BCMA_SROM8_MCS5GLPO4_MASK);
> +	sprom->mcs5glpo5 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GLPO5,
> +					BCMA_SROM8_MCS5GLPO5_MASK);
> +	sprom->mcs5glpo6 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GLPO6,
> +					BCMA_SROM8_MCS5GLPO6_MASK);
> +	sprom->mcs5glpo7 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GLPO7,
> +					BCMA_SROM8_MCS5GLPO7_MASK);
> +	sprom->mcs5ghpo0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GHPO0,
> +					BCMA_SROM8_MCS5GHPO0_MASK);
> +	sprom->mcs5ghpo1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GHPO1,
> +					BCMA_SROM8_MCS5GHPO1_MASK);
> +	sprom->mcs5ghpo2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GHPO2,
> +					BCMA_SROM8_MCS5GHPO2_MASK);
> +	sprom->mcs5ghpo3 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GHPO3,
> +					BCMA_SROM8_MCS5GHPO3_MASK);
> +	sprom->mcs5ghpo4 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GHPO4,
> +					BCMA_SROM8_MCS5GHPO4_MASK);
> +	sprom->mcs5ghpo5 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GHPO5,
> +					BCMA_SROM8_MCS5GHPO5_MASK);
> +	sprom->mcs5ghpo6 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GHPO6,
> +					BCMA_SROM8_MCS5GHPO6_MASK);
> +	sprom->mcs5ghpo7 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_MCS5GHPO7,
> +					BCMA_SROM8_MCS5GHPO7_MASK);
> +	sprom->cddpo = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_CDDPO,
> +					BCMA_SROM8_CDDPO_MASK);
> +	sprom->stbcpo = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_STBCPO,
> +					BCMA_SROM8_STBCPO_MASK);
> +	sprom->bw40po = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_BW40PO,
> +					BCMA_SROM8_BW40PO_MASK);
> +	sprom->bwduppo = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_BWDUPPO,
> +					BCMA_SROM8_BWDUPPO_MASK);
> +	/*
> +	 * extract per-path variables
> +	 */
> +	for (path = 0; path < 4; path++) {
> +		sprom->path[path].maxp2ga = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_MAXP2GA,
> +					BCMA_SROM8_MAXP2GA_MASK);
> +		sprom->path[path].itt2ga = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_ITT2GA,
> +					BCMA_SROM8_ITT2GA_MASK);
> +		sprom->path[path].itt5ga = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_ITT5GA,
> +					BCMA_SROM8_ITT5GA_MASK);
> +		sprom->path[path].pa2gw0a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA2GW0A,
> +					BCMA_SROM8_PA2GW0A_MASK);
> +		sprom->path[path].pa2gw1a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA2GW1A,
> +					BCMA_SROM8_PA2GW1A_MASK);
> +		sprom->path[path].pa2gw2a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA2GW2A,
> +					BCMA_SROM8_PA2GW2A_MASK);
> +		sprom->path[path].maxp5ga = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_MAXP5GA,
> +					BCMA_SROM8_MAXP5GA_MASK);
> +		sprom->path[path].maxp5gha = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_MAXP5GHA,
> +					BCMA_SROM8_MAXP5GHA_MASK);
> +		sprom->path[path].maxp5gla = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_MAXP5GLA,
> +					BCMA_SROM8_MAXP5GLA_MASK);
> +		sprom->path[path].pa5gw0a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GW0A,
> +					BCMA_SROM8_PA5GW0A_MASK);
> +		sprom->path[path].pa5gw1a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GW1A,
> +					BCMA_SROM8_PA5GW1A_MASK);
> +		sprom->path[path].pa5gw2a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GW2A,
> +					BCMA_SROM8_PA5GW2A_MASK);
> +		sprom->path[path].pa5glw0a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GLW0A,
> +					BCMA_SROM8_PA5GLW0A_MASK);
> +		sprom->path[path].pa5glw1a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GLW1A,
> +					BCMA_SROM8_PA5GLW1A_MASK);
> +		sprom->path[path].pa5glw2a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GLW2A,
> +					BCMA_SROM8_PA5GLW2A_MASK);
> +		sprom->path[path].pa5ghw0a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GHW0A,
> +					BCMA_SROM8_PA5GHW0A_MASK);
> +		sprom->path[path].pa5ghw1a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GHW1A,
> +					BCMA_SROM8_PA5GHW1A_MASK);
> +		sprom->path[path].pa5ghw2a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GHW2A,
> +					BCMA_SROM8_PA5GHW2A_MASK);
> +	}
> +}
> +
> +/*
> + * srom data extractor for rev 9
> + */
> +void bcma_sprom_extract_rev9(struct bcma_sprom *sprom, u16 *data)
> +{
> +	u16 path_offset[] = { BCMA_SROM_PATH0, BCMA_SROM_PATH1,
> +			      BCMA_SROM_PATH2, BCMA_SROM_PATH3 };
> +	uint path;
> +
> +	/*
> +	 * extract variables
> +	 */
> +	sprom->devid = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_DEVID,
> +					BCMA_SROM8_DEVID_MASK);
> +	sprom->boardrev = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_BOARDREV,
> +					BCMA_SROM8_BOARDREV_MASK);
> +	sprom->boardflags = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM8_BOARDFLAGS,
> +					BCMA_SROM8_BOARDFLAGS_MASK);
> +	sprom->boardflags2 = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM8_BOARDFLAGS2,
> +					BCMA_SROM8_BOARDFLAGS2_MASK);
> +	sprom->boardtype = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_BOARDTYPE,
> +					BCMA_SROM8_BOARDTYPE_MASK);
> +	sprom->boardnum = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_BOARDNUM,
> +					BCMA_SROM8_BOARDNUM_MASK);
> +	sprom->regrev = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_REGREV,
> +					BCMA_SROM8_REGREV_MASK);
> +	sprom->ledbh0 = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_LEDBH0,
> +					BCMA_SROM8_LEDBH0_MASK);
> +	sprom->ledbh1 = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_LEDBH1,
> +					BCMA_SROM8_LEDBH1_MASK);
> +	sprom->ledbh2 = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_LEDBH2,
> +					BCMA_SROM8_LEDBH2_MASK);
> +	sprom->ledbh3 = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_LEDBH3,
> +					BCMA_SROM8_LEDBH3_MASK);
> +	sprom->pa0b0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA0B0,
> +					BCMA_SROM8_PA0B0_MASK);
> +	sprom->pa0b1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA0B1,
> +					BCMA_SROM8_PA0B1_MASK);
> +	sprom->pa0b2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA0B2,
> +					BCMA_SROM8_PA0B2_MASK);
> +	sprom->pa0itssit = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA0ITSSIT,
> +					BCMA_SROM8_PA0ITSSIT_MASK);
> +	sprom->pa0maxpwr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA0MAXPWR,
> +					BCMA_SROM8_PA0MAXPWR_MASK);
> +	sprom->opo = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_OPO,
> +					BCMA_SROM8_OPO_MASK);
> +	sprom->aa2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AA2G,
> +					BCMA_SROM8_AA2G_MASK);
> +	sprom->aa5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AA5G,
> +					BCMA_SROM8_AA5G_MASK);
> +	sprom->ag0 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AG0,
> +					BCMA_SROM8_AG0_MASK);
> +	sprom->ag1 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AG1,
> +					BCMA_SROM8_AG1_MASK);
> +	sprom->ag2 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AG2,
> +					BCMA_SROM8_AG2_MASK);
> +	sprom->ag3 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_AG3,
> +					BCMA_SROM8_AG3_MASK);
> +	sprom->pa1b0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1B0,
> +					BCMA_SROM8_PA1B0_MASK);
> +	sprom->pa1b1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1B1,
> +					BCMA_SROM8_PA1B1_MASK);
> +	sprom->pa1b2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1B2,
> +					BCMA_SROM8_PA1B2_MASK);
> +	sprom->pa1lob0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1LOB0,
> +					BCMA_SROM8_PA1LOB0_MASK);
> +	sprom->pa1lob1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1LOB1,
> +					BCMA_SROM8_PA1LOB1_MASK);
> +	sprom->pa1lob2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1LOB2,
> +					BCMA_SROM8_PA1LOB2_MASK);
> +	sprom->pa1hib0 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1HIB0,
> +					BCMA_SROM8_PA1HIB0_MASK);
> +	sprom->pa1hib1 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1HIB1,
> +					BCMA_SROM8_PA1HIB1_MASK);
> +	sprom->pa1hib2 = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_PA1HIB2,
> +					BCMA_SROM8_PA1HIB2_MASK);
> +	sprom->pa1itssit = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA1ITSSIT,
> +					BCMA_SROM8_PA1ITSSIT_MASK);
> +	sprom->pa1maxpwr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA1MAXPWR,
> +					BCMA_SROM8_PA1MAXPWR_MASK);
> +	sprom->pa1lomaxpwr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA1LOMAXPWR,
> +					BCMA_SROM8_PA1LOMAXPWR_MASK);
> +	sprom->pa1himaxpwr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PA1HIMAXPWR,
> +					BCMA_SROM8_PA1HIMAXPWR_MASK);
> +	sprom->bxa2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_BXA2G,
> +					BCMA_SROM8_BXA2G_MASK);
> +	sprom->rssisav2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISAV2G,
> +					BCMA_SROM8_RSSISAV2G_MASK);
> +	sprom->rssismc2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISMC2G,
> +					BCMA_SROM8_RSSISMC2G_MASK);
> +	sprom->rssismf2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISMF2G,
> +					BCMA_SROM8_RSSISMF2G_MASK);
> +	sprom->bxa5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_BXA5G,
> +					BCMA_SROM8_BXA5G_MASK);
> +	sprom->rssisav5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISAV5G,
> +					BCMA_SROM8_RSSISAV5G_MASK);
> +	sprom->rssismc5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISMC5G,
> +					BCMA_SROM8_RSSISMC5G_MASK);
> +	sprom->rssismf5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_RSSISMF5G,
> +					BCMA_SROM8_RSSISMF5G_MASK);
> +	sprom->tri2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRI2G,
> +					BCMA_SROM8_TRI2G_MASK);
> +	sprom->tri5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRI5G,
> +					BCMA_SROM8_TRI5G_MASK);
> +	sprom->tri5gl = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRI5GL,
> +					BCMA_SROM8_TRI5GL_MASK);
> +	sprom->tri5gh = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRI5GH,
> +					BCMA_SROM8_TRI5GH_MASK);
> +	sprom->rxpo2g = bcma_sprom_extract_s8(false, data,
> +					BCMA_SROM8_RXPO2G,
> +					BCMA_SROM8_RXPO2G_MASK);
> +	sprom->rxpo5g = bcma_sprom_extract_s8(false, data,
> +					BCMA_SROM8_RXPO5G,
> +					BCMA_SROM8_RXPO5G_MASK);
> +	sprom->txchain = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_TXCHAIN,
> +					BCMA_SROM8_TXCHAIN_MASK);
> +	sprom->rxchain = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_RXCHAIN,
> +					BCMA_SROM8_RXCHAIN_MASK);
> +	sprom->antswitch = bcma_sprom_extract_u8(true, data,
> +					BCMA_SROM8_ANTSWITCH,
> +					BCMA_SROM8_ANTSWITCH_MASK);
> +	sprom->tssipos2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TSSIPOS2G,
> +					BCMA_SROM8_TSSIPOS2G_MASK);
> +	sprom->extpagain2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_EXTPAGAIN2G,
> +					BCMA_SROM8_EXTPAGAIN2G_MASK);
> +	sprom->pdetrange2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PDETRANGE2G,
> +					BCMA_SROM8_PDETRANGE2G_MASK);
> +	sprom->triso2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRISO2G,
> +					BCMA_SROM8_TRISO2G_MASK);
> +	sprom->antswctl2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_ANTSWCTL2G,
> +					BCMA_SROM8_ANTSWCTL2G_MASK);
> +	sprom->tssipos5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TSSIPOS5G,
> +					BCMA_SROM8_TSSIPOS5G_MASK);
> +	sprom->extpagain5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_EXTPAGAIN5G,
> +					BCMA_SROM8_EXTPAGAIN5G_MASK);
> +	sprom->pdetrange5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PDETRANGE5G,
> +					BCMA_SROM8_PDETRANGE5G_MASK);
> +	sprom->triso5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TRISO5G,
> +					BCMA_SROM8_TRISO5G_MASK);
> +	sprom->antswctl5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_ANTSWCTL5G,
> +					BCMA_SROM8_ANTSWCTL5G_MASK);
> +	sprom->ccode = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_CCODE,
> +					BCMA_SROM8_CCODE_MASK);
> +	bcma_sprom_extract_ether(sprom->macaddr, data, BCMA_SROM8_MACADDR);
> +	sprom->leddc = bcma_sprom_extract_u16(true, data,
> +					BCMA_SROM8_LEDDC,
> +					BCMA_SROM8_LEDDC_MASK);
> +	sprom->tempthresh = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPTHRESH,
> +					BCMA_SROM8_TEMPTHRESH_MASK);
> +	sprom->tempoffset = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPOFFSET,
> +					BCMA_SROM8_TEMPOFFSET_MASK);
> +	sprom->rawtempsense = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM8_RAWTEMPSENSE,
> +					BCMA_SROM8_RAWTEMPSENSE_MASK);
> +	sprom->measpower = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_MEASPOWER,
> +					BCMA_SROM8_MEASPOWER_MASK);
> +	sprom->tempsense_slope = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPSENSE_SLOPE,
> +					BCMA_SROM8_TEMPSENSE_SLOPE_MASK);
> +	sprom->tempcorrx = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPCORRX,
> +					BCMA_SROM8_TEMPCORRX_MASK);
> +	sprom->tempsense_option = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPSENSE_OPTION,
> +					BCMA_SROM8_TEMPSENSE_OPTION_MASK);
> +	sprom->freqoffset_corr = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_FREQOFFSET_CORR,
> +					BCMA_SROM8_FREQOFFSET_CORR_MASK);
> +	sprom->iqcal_swp_dis = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_IQCAL_SWP_DIS,
> +					BCMA_SROM8_IQCAL_SWP_DIS_MASK);
> +	sprom->hw_iqcal_en = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_HW_IQCAL_EN,
> +					BCMA_SROM8_HW_IQCAL_EN_MASK);
> +	sprom->elna2g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_ELNA2G,
> +					BCMA_SROM8_ELNA2G_MASK);
> +	sprom->elna5g = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_ELNA5G,
> +					BCMA_SROM8_ELNA5G_MASK);
> +	sprom->phycal_tempdelta = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_PHYCAL_TEMPDELTA,
> +					BCMA_SROM8_PHYCAL_TEMPDELTA_MASK);
> +	sprom->temps_period = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPS_PERIOD,
> +					BCMA_SROM8_TEMPS_PERIOD_MASK);
> +	sprom->temps_hysteresis = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_TEMPS_HYSTERESIS,
> +					BCMA_SROM8_TEMPS_HYSTERESIS_MASK);
> +	sprom->measpower1 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_MEASPOWER1,
> +					BCMA_SROM8_MEASPOWER1_MASK);
> +	sprom->measpower2 = bcma_sprom_extract_u8(false, data,
> +					BCMA_SROM8_MEASPOWER2,
> +					BCMA_SROM8_MEASPOWER2_MASK);
> +	sprom->cckbw202gpo = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM9_CCKBW202GPO,
> +					BCMA_SROM9_CCKBW202GPO_MASK);
> +	sprom->cckbw20ul2gpo = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM9_CCKBW20UL2GPO,
> +					BCMA_SROM9_CCKBW20UL2GPO_MASK);
> +	sprom->legofdmbw202gpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_LEGOFDMBW202GPO,
> +					BCMA_SROM9_LEGOFDMBW202GPO_MASK);
> +	sprom->legofdmbw20ul2gpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_LEGOFDMBW20UL2GPO,
> +					BCMA_SROM9_LEGOFDMBW20UL2GPO_MASK);
> +	sprom->legofdmbw205glpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_LEGOFDMBW205GLPO,
> +					BCMA_SROM9_LEGOFDMBW205GLPO_MASK);
> +	sprom->legofdmbw20ul5glpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_LEGOFDMBW20UL5GLPO,
> +					BCMA_SROM9_LEGOFDMBW20UL5GLPO_MASK);
> +	sprom->legofdmbw205gmpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_LEGOFDMBW205GMPO,
> +					BCMA_SROM9_LEGOFDMBW205GMPO_MASK);
> +	sprom->legofdmbw20ul5gmpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_LEGOFDMBW20UL5GMPO,
> +					BCMA_SROM9_LEGOFDMBW20UL5GMPO_MASK);
> +	sprom->legofdmbw205ghpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_LEGOFDMBW205GHPO,
> +					BCMA_SROM9_LEGOFDMBW205GHPO_MASK);
> +	sprom->legofdmbw20ul5ghpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_LEGOFDMBW20UL5GHPO,
> +					BCMA_SROM9_LEGOFDMBW20UL5GHPO_MASK);
> +	sprom->mcsbw202gpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW202GPO,
> +					BCMA_SROM9_MCSBW202GPO_MASK);
> +	sprom->mcsbw20ul2gpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW20UL2GPO,
> +					BCMA_SROM9_MCSBW20UL2GPO_MASK);
> +	sprom->mcsbw402gpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW402GPO,
> +					BCMA_SROM9_MCSBW402GPO_MASK);
> +	sprom->mcsbw205glpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW205GLPO,
> +					BCMA_SROM9_MCSBW205GLPO_MASK);
> +	sprom->mcsbw20ul5glpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW20UL5GLPO,
> +					BCMA_SROM9_MCSBW20UL5GLPO_MASK);
> +	sprom->mcsbw405glpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW405GLPO,
> +					BCMA_SROM9_MCSBW405GLPO_MASK);
> +	sprom->mcsbw205gmpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW205GMPO,
> +					BCMA_SROM9_MCSBW205GMPO_MASK);
> +	sprom->mcsbw20ul5gmpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW20UL5GMPO,
> +					BCMA_SROM9_MCSBW20UL5GMPO_MASK);
> +	sprom->mcsbw405gmpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW405GMPO,
> +					BCMA_SROM9_MCSBW405GMPO_MASK);
> +	sprom->mcsbw205ghpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW205GHPO,
> +					BCMA_SROM9_MCSBW205GHPO_MASK);
> +	sprom->mcsbw20ul5ghpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW20UL5GHPO,
> +					BCMA_SROM9_MCSBW20UL5GHPO_MASK);
> +	sprom->mcsbw405ghpo = bcma_sprom_extract_u32(false, data,
> +					BCMA_SROM9_MCSBW405GHPO,
> +					BCMA_SROM9_MCSBW405GHPO_MASK);
> +	sprom->mcs32po = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM9_MCS32PO,
> +					BCMA_SROM9_MCS32PO_MASK);
> +	sprom->legofdm40duppo = bcma_sprom_extract_u16(false, data,
> +					BCMA_SROM9_LEGOFDM40DUPPO,
> +					BCMA_SROM9_LEGOFDM40DUPPO_MASK);
> +	/*
> +	 * extract per-path variables
> +	 */
> +	for (path = 0; path < 4; path++) {
> +		sprom->path[path].maxp2ga = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_MAXP2GA,
> +					BCMA_SROM8_MAXP2GA_MASK);
> +		sprom->path[path].itt2ga = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_ITT2GA,
> +					BCMA_SROM8_ITT2GA_MASK);
> +		sprom->path[path].itt5ga = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_ITT5GA,
> +					BCMA_SROM8_ITT5GA_MASK);
> +		sprom->path[path].pa2gw0a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA2GW0A,
> +					BCMA_SROM8_PA2GW0A_MASK);
> +		sprom->path[path].pa2gw1a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA2GW1A,
> +					BCMA_SROM8_PA2GW1A_MASK);
> +		sprom->path[path].pa2gw2a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA2GW2A,
> +					BCMA_SROM8_PA2GW2A_MASK);
> +		sprom->path[path].maxp5ga = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_MAXP5GA,
> +					BCMA_SROM8_MAXP5GA_MASK);
> +		sprom->path[path].maxp5gha = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_MAXP5GHA,
> +					BCMA_SROM8_MAXP5GHA_MASK);
> +		sprom->path[path].maxp5gla = bcma_sprom_extract_u8(false, data,
> +					path_offset[path] + BCMA_SROM8_MAXP5GLA,
> +					BCMA_SROM8_MAXP5GLA_MASK);
> +		sprom->path[path].pa5gw0a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GW0A,
> +					BCMA_SROM8_PA5GW0A_MASK);
> +		sprom->path[path].pa5gw1a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GW1A,
> +					BCMA_SROM8_PA5GW1A_MASK);
> +		sprom->path[path].pa5gw2a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GW2A,
> +					BCMA_SROM8_PA5GW2A_MASK);
> +		sprom->path[path].pa5glw0a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GLW0A,
> +					BCMA_SROM8_PA5GLW0A_MASK);
> +		sprom->path[path].pa5glw1a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GLW1A,
> +					BCMA_SROM8_PA5GLW1A_MASK);
> +		sprom->path[path].pa5glw2a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GLW2A,
> +					BCMA_SROM8_PA5GLW2A_MASK);
> +		sprom->path[path].pa5ghw0a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GHW0A,
> +					BCMA_SROM8_PA5GHW0A_MASK);
> +		sprom->path[path].pa5ghw1a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GHW1A,
> +					BCMA_SROM8_PA5GHW1A_MASK);
> +		sprom->path[path].pa5ghw2a = bcma_sprom_extract_u16(false, data,
> +					path_offset[path] + BCMA_SROM8_PA5GHW2A,
> +					BCMA_SROM8_PA5GHW2A_MASK);
> +	}
> +}
> +
>  /**************************************************
>   * R/W ops.
>   **************************************************/
> @@ -21,7 +1318,7 @@
>  static void bcma_sprom_read(struct bcma_bus *bus, u16 offset, u16 *sprom)
>  {
>  	int i;
> -	for (i = 0; i < SSB_SPROMSIZE_WORDS_R4; i++)
> +	for (i = 0; i < BCMA_SPROM_SIZE_WORDS_R4; i++)
>  		sprom[i] = bcma_read16(bus->drv_cc.core,
>  				       offset + (i * 2));
>  }
> @@ -75,11 +1372,11 @@ static u8 bcma_sprom_crc(const u16 *sprom)
>  	int word;
>  	u8 crc = 0xFF;
>  
> -	for (word = 0; word < SSB_SPROMSIZE_WORDS_R4 - 1; word++) {
> +	for (word = 0; word < BCMA_SPROM_SIZE_WORDS_R4 - 1; word++) {
>  		crc = bcma_crc8(crc, sprom[word] & 0x00FF);
>  		crc = bcma_crc8(crc, (sprom[word] & 0xFF00) >> 8);
>  	}
> -	crc = bcma_crc8(crc, sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & 0x00FF);
> +	crc = bcma_crc8(crc, sprom[BCMA_SPROM_REVISION - 1] & 0x00FF);
>  	crc ^= 0xFF;
>  
>  	return crc;
> @@ -92,8 +1389,8 @@ static int bcma_sprom_check_crc(const u16 *sprom)
>  	u16 tmp;
>  
>  	crc = bcma_sprom_crc(sprom);
> -	tmp = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & SSB_SPROM_REVISION_CRC;
> -	expected_crc = tmp >> SSB_SPROM_REVISION_CRC_SHIFT;
> +	tmp = sprom[BCMA_SPROM_REVISION] & BCMA_SPROM_REVISION_CRC_MASK;
> +	expected_crc = tmp >> BCMA_SPROM_REVISION_CRC_SHIFT;
>  	if (crc != expected_crc)
>  		return -EPROTO;
>  
> @@ -109,7 +1406,7 @@ static int bcma_sprom_valid(const u16 *sprom)
>  	if (err)
>  		return err;
>  
> -	revision = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & SSB_SPROM_REVISION_REV;
> +	revision = sprom[BCMA_SPROM_REVISION] & BCMA_SPROM_REVISION_REV_MASK;
>  	if (revision != 8 && revision != 9) {
>  		pr_err("Unsupported SPROM revision: %d\n", revision);
>  		return -ENOENT;
> @@ -118,134 +1415,6 @@ static int bcma_sprom_valid(const u16 *sprom)
>  	return 0;
>  }
>  
> -/**************************************************
> - * SPROM extraction.
> - **************************************************/
> -
> -#define SPOFF(offset)	((offset) / sizeof(u16))
> -
> -#define SPEX(_field, _offset, _mask, _shift)	\
> -	bus->sprom._field = ((sprom[SPOFF(_offset)] & (_mask)) >> (_shift))
> -
> -static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
> -{
> -	u16 v, o;
> -	int i;
> -	u16 pwr_info_offset[] = {
> -		SSB_SROM8_PWR_INFO_CORE0, SSB_SROM8_PWR_INFO_CORE1,
> -		SSB_SROM8_PWR_INFO_CORE2, SSB_SROM8_PWR_INFO_CORE3
> -	};
> -	BUILD_BUG_ON(ARRAY_SIZE(pwr_info_offset) !=
> -			ARRAY_SIZE(bus->sprom.core_pwr_info));
> -
> -	bus->sprom.revision = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] &
> -		SSB_SPROM_REVISION_REV;
> -
> -	for (i = 0; i < 3; i++) {
> -		v = sprom[SPOFF(SSB_SPROM8_IL0MAC) + i];
> -		*(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
> -	}
> -
> -	SPEX(board_rev, SSB_SPROM8_BOARDREV, ~0, 0);
> -
> -	SPEX(txpid2g[0], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G0,
> -	     SSB_SPROM4_TXPID2G0_SHIFT);
> -	SPEX(txpid2g[1], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G1,
> -	     SSB_SPROM4_TXPID2G1_SHIFT);
> -	SPEX(txpid2g[2], SSB_SPROM4_TXPID2G23, SSB_SPROM4_TXPID2G2,
> -	     SSB_SPROM4_TXPID2G2_SHIFT);
> -	SPEX(txpid2g[3], SSB_SPROM4_TXPID2G23, SSB_SPROM4_TXPID2G3,
> -	     SSB_SPROM4_TXPID2G3_SHIFT);
> -
> -	SPEX(txpid5gl[0], SSB_SPROM4_TXPID5GL01, SSB_SPROM4_TXPID5GL0,
> -	     SSB_SPROM4_TXPID5GL0_SHIFT);
> -	SPEX(txpid5gl[1], SSB_SPROM4_TXPID5GL01, SSB_SPROM4_TXPID5GL1,
> -	     SSB_SPROM4_TXPID5GL1_SHIFT);
> -	SPEX(txpid5gl[2], SSB_SPROM4_TXPID5GL23, SSB_SPROM4_TXPID5GL2,
> -	     SSB_SPROM4_TXPID5GL2_SHIFT);
> -	SPEX(txpid5gl[3], SSB_SPROM4_TXPID5GL23, SSB_SPROM4_TXPID5GL3,
> -	     SSB_SPROM4_TXPID5GL3_SHIFT);
> -
> -	SPEX(txpid5g[0], SSB_SPROM4_TXPID5G01, SSB_SPROM4_TXPID5G0,
> -	     SSB_SPROM4_TXPID5G0_SHIFT);
> -	SPEX(txpid5g[1], SSB_SPROM4_TXPID5G01, SSB_SPROM4_TXPID5G1,
> -	     SSB_SPROM4_TXPID5G1_SHIFT);
> -	SPEX(txpid5g[2], SSB_SPROM4_TXPID5G23, SSB_SPROM4_TXPID5G2,
> -	     SSB_SPROM4_TXPID5G2_SHIFT);
> -	SPEX(txpid5g[3], SSB_SPROM4_TXPID5G23, SSB_SPROM4_TXPID5G3,
> -	     SSB_SPROM4_TXPID5G3_SHIFT);
> -
> -	SPEX(txpid5gh[0], SSB_SPROM4_TXPID5GH01, SSB_SPROM4_TXPID5GH0,
> -	     SSB_SPROM4_TXPID5GH0_SHIFT);
> -	SPEX(txpid5gh[1], SSB_SPROM4_TXPID5GH01, SSB_SPROM4_TXPID5GH1,
> -	     SSB_SPROM4_TXPID5GH1_SHIFT);
> -	SPEX(txpid5gh[2], SSB_SPROM4_TXPID5GH23, SSB_SPROM4_TXPID5GH2,
> -	     SSB_SPROM4_TXPID5GH2_SHIFT);
> -	SPEX(txpid5gh[3], SSB_SPROM4_TXPID5GH23, SSB_SPROM4_TXPID5GH3,
> -	     SSB_SPROM4_TXPID5GH3_SHIFT);
> -
> -	SPEX(boardflags_lo, SSB_SPROM8_BFLLO, ~0, 0);
> -	SPEX(boardflags_hi, SSB_SPROM8_BFLHI, ~0, 0);
> -	SPEX(boardflags2_lo, SSB_SPROM8_BFL2LO, ~0, 0);
> -	SPEX(boardflags2_hi, SSB_SPROM8_BFL2HI, ~0, 0);
> -
> -	SPEX(country_code, SSB_SPROM8_CCODE, ~0, 0);
> -
> -	/* Extract cores power info info */
> -	for (i = 0; i < ARRAY_SIZE(pwr_info_offset); i++) {
> -		o = pwr_info_offset[i];
> -		SPEX(core_pwr_info[i].itssi_2g, o + SSB_SROM8_2G_MAXP_ITSSI,
> -			SSB_SPROM8_2G_ITSSI, SSB_SPROM8_2G_ITSSI_SHIFT);
> -		SPEX(core_pwr_info[i].maxpwr_2g, o + SSB_SROM8_2G_MAXP_ITSSI,
> -			SSB_SPROM8_2G_MAXP, 0);
> -
> -		SPEX(core_pwr_info[i].pa_2g[0], o + SSB_SROM8_2G_PA_0, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_2g[1], o + SSB_SROM8_2G_PA_1, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_2g[2], o + SSB_SROM8_2G_PA_2, ~0, 0);
> -
> -		SPEX(core_pwr_info[i].itssi_5g, o + SSB_SROM8_5G_MAXP_ITSSI,
> -			SSB_SPROM8_5G_ITSSI, SSB_SPROM8_5G_ITSSI_SHIFT);
> -		SPEX(core_pwr_info[i].maxpwr_5g, o + SSB_SROM8_5G_MAXP_ITSSI,
> -			SSB_SPROM8_5G_MAXP, 0);
> -		SPEX(core_pwr_info[i].maxpwr_5gh, o + SSB_SPROM8_5GHL_MAXP,
> -			SSB_SPROM8_5GH_MAXP, 0);
> -		SPEX(core_pwr_info[i].maxpwr_5gl, o + SSB_SPROM8_5GHL_MAXP,
> -			SSB_SPROM8_5GL_MAXP, SSB_SPROM8_5GL_MAXP_SHIFT);
> -
> -		SPEX(core_pwr_info[i].pa_5gl[0], o + SSB_SROM8_5GL_PA_0, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_5gl[1], o + SSB_SROM8_5GL_PA_1, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_5gl[2], o + SSB_SROM8_5GL_PA_2, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_5g[0], o + SSB_SROM8_5G_PA_0, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_5g[1], o + SSB_SROM8_5G_PA_1, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_5g[2], o + SSB_SROM8_5G_PA_2, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_5gh[0], o + SSB_SROM8_5GH_PA_0, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_5gh[1], o + SSB_SROM8_5GH_PA_1, ~0, 0);
> -		SPEX(core_pwr_info[i].pa_5gh[2], o + SSB_SROM8_5GH_PA_2, ~0, 0);
> -	}
> -
> -	SPEX(fem.ghz2.tssipos, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_TSSIPOS,
> -	     SSB_SROM8_FEM_TSSIPOS_SHIFT);
> -	SPEX(fem.ghz2.extpa_gain, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_EXTPA_GAIN,
> -	     SSB_SROM8_FEM_EXTPA_GAIN_SHIFT);
> -	SPEX(fem.ghz2.pdet_range, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_PDET_RANGE,
> -	     SSB_SROM8_FEM_PDET_RANGE_SHIFT);
> -	SPEX(fem.ghz2.tr_iso, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_TR_ISO,
> -	     SSB_SROM8_FEM_TR_ISO_SHIFT);
> -	SPEX(fem.ghz2.antswlut, SSB_SPROM8_FEM2G, SSB_SROM8_FEM_ANTSWLUT,
> -	     SSB_SROM8_FEM_ANTSWLUT_SHIFT);
> -
> -	SPEX(fem.ghz5.tssipos, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_TSSIPOS,
> -	     SSB_SROM8_FEM_TSSIPOS_SHIFT);
> -	SPEX(fem.ghz5.extpa_gain, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_EXTPA_GAIN,
> -	     SSB_SROM8_FEM_EXTPA_GAIN_SHIFT);
> -	SPEX(fem.ghz5.pdet_range, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_PDET_RANGE,
> -	     SSB_SROM8_FEM_PDET_RANGE_SHIFT);
> -	SPEX(fem.ghz5.tr_iso, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_TR_ISO,
> -	     SSB_SROM8_FEM_TR_ISO_SHIFT);
> -	SPEX(fem.ghz5.antswlut, SSB_SPROM8_FEM5G, SSB_SROM8_FEM_ANTSWLUT,
> -	     SSB_SROM8_FEM_ANTSWLUT_SHIFT);
> -}
> -
>  /*
>   * Indicates the presence of external SPROM.
>   */
> @@ -364,7 +1533,7 @@ int bcma_sprom_get(struct bcma_bus *bus)
>  			return -ENOENT;
>  	}
>  
> -	sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
> +	sprom = kcalloc(BCMA_SPROM_SIZE_WORDS_R4, sizeof(u16),
>  			GFP_KERNEL);
>  	if (!sprom)
>  		return -ENOMEM;
> @@ -382,7 +1551,18 @@ int bcma_sprom_get(struct bcma_bus *bus)
>  	if (err)
>  		goto out;
>  
> -	bcma_sprom_extract_r8(bus, sprom);
> +	bus->sprom.revision = sprom[BCMA_SPROM_REVISION] & BCMA_SPROM_REVISION_REV_MASK;
> +	switch (bus->sprom.revision) {
> +	case 8:
> +		bcma_sprom_extract_rev8(&bus->sprom, sprom);
> +		break;
> +	case 9:
> +		bcma_sprom_extract_rev9(&bus->sprom, sprom);
> +		break;
> +	default:
> +		err = -EINVAL;
> +		goto out;
> +	}
>  
>  out:
>  	kfree(sprom);
> diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
> index b9f65fb..78dd32b 100644
> --- a/include/linux/bcma/bcma.h
> +++ b/include/linux/bcma/bcma.h
> @@ -7,7 +7,7 @@
>  #include <linux/bcma/bcma_driver_chipcommon.h>
>  #include <linux/bcma/bcma_driver_pci.h>
>  #include <linux/bcma/bcma_driver_mips.h>
> -#include <linux/ssb/ssb.h> /* SPROM sharing */
> +#include <linux/bcma/bcma_sprom.h>
>  
>  #include "bcma_regs.h"
>  
> @@ -202,9 +202,8 @@ struct bcma_bus {
>  	struct bcma_drv_pci drv_pci;
>  	struct bcma_drv_mips drv_mips;
>  
> -	/* We decided to share SPROM struct with SSB as long as we do not need
> -	 * any hacks for BCMA. This simplifies drivers code. */
> -	struct ssb_sprom sprom;
> +	/* extracted sprom */
> +	struct bcma_sprom sprom;
>  };
>  
>  static inline u32 bcma_read8(struct bcma_device *core, u16 offset)
> diff --git a/include/linux/bcma/bcma_sprom.h b/include/linux/bcma/bcma_sprom.h
> new file mode 100644
> index 0000000..730df10
> --- /dev/null
> +++ b/include/linux/bcma/bcma_sprom.h
> @@ -0,0 +1,201 @@
> +#ifndef BCMA_SPROM_H
> +#define BCMA_SPROM_H
> +
> +#include <linux/if_ether.h>
> +
> +#define BCMA_SPROM_SIZE_WORDS_R4		220
> +#define BCMA_SPROM_REVISION			(BCMA_SPROM_SIZE_WORDS_R4 - 1)
> +#define BCMA_SPROM_REVISION_CRC_MASK		0xFF00
> +#define BCMA_SPROM_REVISION_CRC_SHIFT		8
> +#define BCMA_SPROM_REVISION_REV_MASK		0x00FF
> +
> +struct bcma_sprom_path {
> +	/*
> +	 * srom per-path fields for rev 8, and 9.
> +	 */
> +	u8 maxp2ga;
> +	u8 itt2ga;
> +	u8 itt5ga;
> +	u16 pa2gw0a;
> +	u16 pa2gw1a;
> +	u16 pa2gw2a;
> +	u8 maxp5ga;
> +	u8 maxp5gha;
> +	u8 maxp5gla;
> +	u16 pa5gw0a;
> +	u16 pa5gw1a;
> +	u16 pa5gw2a;
> +	u16 pa5glw0a;
> +	u16 pa5glw1a;
> +	u16 pa5glw2a;
> +	u16 pa5ghw0a;
> +	u16 pa5ghw1a;
> +	u16 pa5ghw2a;
> +};
> +
> +struct bcma_sprom {
> +	u8 revision;
> +	/*
> +	 * srom fields for rev 8, and 9.
> +	 */
> +	u16 devid;
> +	u16 boardrev;
> +	u32 boardflags;
> +	u32 boardflags2;
> +	u16 boardtype;
> +	u16 boardnum;
> +	u8 regrev;
> +	u8 ledbh0;
> +	u8 ledbh1;
> +	u8 ledbh2;
> +	u8 ledbh3;
> +	u16 pa0b0;
> +	u16 pa0b1;
> +	u16 pa0b2;
> +	u8 pa0itssit;
> +	u8 pa0maxpwr;
> +	u8 opo;
> +	u8 aa2g;
> +	u8 aa5g;
> +	u8 ag0;
> +	u8 ag1;
> +	u8 ag2;
> +	u8 ag3;
> +	u16 pa1b0;
> +	u16 pa1b1;
> +	u16 pa1b2;
> +	u16 pa1lob0;
> +	u16 pa1lob1;
> +	u16 pa1lob2;
> +	u16 pa1hib0;
> +	u16 pa1hib1;
> +	u16 pa1hib2;
> +	u8 pa1itssit;
> +	u8 pa1maxpwr;
> +	u8 pa1lomaxpwr;
> +	u8 pa1himaxpwr;
> +	u8 bxa2g;
> +	u8 rssisav2g;
> +	u8 rssismc2g;
> +	u8 rssismf2g;
> +	u8 bxa5g;
> +	u8 rssisav5g;
> +	u8 rssismc5g;
> +	u8 rssismf5g;
> +	u8 tri2g;
> +	u8 tri5g;
> +	u8 tri5gl;
> +	u8 tri5gh;
> +	s8 rxpo2g;
> +	s8 rxpo5g;
> +	u8 txchain;
> +	u8 rxchain;
> +	u8 antswitch;
> +	u8 tssipos2g;
> +	u8 extpagain2g;
> +	u8 pdetrange2g;
> +	u8 triso2g;
> +	u8 antswctl2g;
> +	u8 tssipos5g;
> +	u8 extpagain5g;
> +	u8 pdetrange5g;
> +	u8 triso5g;
> +	u8 antswctl5g;
> +	u16 ccode;
> +	u8 macaddr[ETH_ALEN];
> +	u16 leddc;
> +	u8 tempthresh;
> +	u8 tempoffset;
> +	u16 rawtempsense;
> +	u8 measpower;
> +	u8 tempsense_slope;
> +	u8 tempcorrx;
> +	u8 tempsense_option;
> +	u8 freqoffset_corr;
> +	u8 iqcal_swp_dis;
> +	u8 hw_iqcal_en;
> +	u8 elna2g;
> +	u8 elna5g;
> +	u8 phycal_tempdelta;
> +	u8 temps_period;
> +	u8 temps_hysteresis;
> +	u8 measpower1;
> +	u8 measpower2;
> +	/*
> +	 * srom fields for rev 8.
> +	 */
> +	u16 cck2gpo;
> +	u32 ofdm2gpo;
> +	u32 ofdm5gpo;
> +	u32 ofdm5glpo;
> +	u32 ofdm5ghpo;
> +	u16 mcs2gpo0;
> +	u16 mcs2gpo1;
> +	u16 mcs2gpo2;
> +	u16 mcs2gpo3;
> +	u16 mcs2gpo4;
> +	u16 mcs2gpo5;
> +	u16 mcs2gpo6;
> +	u16 mcs2gpo7;
> +	u16 mcs5gpo0;
> +	u16 mcs5gpo1;
> +	u16 mcs5gpo2;
> +	u16 mcs5gpo3;
> +	u16 mcs5gpo4;
> +	u16 mcs5gpo5;
> +	u16 mcs5gpo6;
> +	u16 mcs5gpo7;
> +	u16 mcs5glpo0;
> +	u16 mcs5glpo1;
> +	u16 mcs5glpo2;
> +	u16 mcs5glpo3;
> +	u16 mcs5glpo4;
> +	u16 mcs5glpo5;
> +	u16 mcs5glpo6;
> +	u16 mcs5glpo7;
> +	u16 mcs5ghpo0;
> +	u16 mcs5ghpo1;
> +	u16 mcs5ghpo2;
> +	u16 mcs5ghpo3;
> +	u16 mcs5ghpo4;
> +	u16 mcs5ghpo5;
> +	u16 mcs5ghpo6;
> +	u16 mcs5ghpo7;
> +	u16 cddpo;
> +	u16 stbcpo;
> +	u16 bw40po;
> +	u16 bwduppo;
> +	/*
> +	 * srom fields for rev 9.
> +	 */
> +	u16 cckbw202gpo;
> +	u16 cckbw20ul2gpo;
> +	u32 legofdmbw202gpo;
> +	u32 legofdmbw20ul2gpo;
> +	u32 legofdmbw205glpo;
> +	u32 legofdmbw20ul5glpo;
> +	u32 legofdmbw205gmpo;
> +	u32 legofdmbw20ul5gmpo;
> +	u32 legofdmbw205ghpo;
> +	u32 legofdmbw20ul5ghpo;
> +	u32 mcsbw202gpo;
> +	u32 mcsbw20ul2gpo;
> +	u32 mcsbw402gpo;
> +	u32 mcsbw205glpo;
> +	u32 mcsbw20ul5glpo;
> +	u32 mcsbw405glpo;
> +	u32 mcsbw205gmpo;
> +	u32 mcsbw20ul5gmpo;
> +	u32 mcsbw405gmpo;
> +	u32 mcsbw205ghpo;
> +	u32 mcsbw20ul5ghpo;
> +	u32 mcsbw405ghpo;
> +	u16 mcs32po;
> +	u16 legofdm40duppo;
> +	/*
> +	 * per-path parameters
> +	 */
> +	struct bcma_sprom_path path[4];
> +};
> +
> +#endif /* BCMA_SPROM_H */

