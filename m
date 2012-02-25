Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45521 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2BYMw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Feb 2012 07:52:58 -0500
Message-ID: <4F48D997.1060400@hauke-m.de> (sfid-20120225_135332_434742_5E425509)
Date: Sat, 25 Feb 2012 13:52:39 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linux-wireless@vger.kernel.org,
	"Saul St. John" <saul.stjohn@gmail.com>,
	Rafal Milecki <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for SPROM
 storage
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1330033977-5741-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/23/2012 10:52 PM, Arend van Spriel wrote:
> Wireless Broadcom chips can have either their SPROM data stored
> on either external SPROM or on-chip OTP memory. Both are accessed
> through the same register space. This patch adds support for the
> on-chip OTP memory.
> 
> Tested with:
> BCM43224 OTP and SPROM
> BCM4331 SPROM
> BCM4313 OTP

Does bcma now support the same features regarding sprom and otp as
brcmsamc expect it does not read out all the attributes brcmsmac reads
out or are there any features still missing? I am just asking because
the code used in brcmsmac is ~4 times longer.

> This patch is in response so gmane article [1].
> 
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/85426
> 
> Cc: Saul St. John <saul.stjohn@gmail.com>
> Cc: Rafal Milecki <zajec5@gmail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Determining the offset for OTP sprom data turned out to be
> easier as it boils down to reading a register. This change
> collides with patch posted by Hauke:

I will test you patch on my device soon and will report if something is
wrong. If you are sending a non RFC patch in the next days I would
rebase my patch onto yours. The code searching in the SoCs flash chip
will be added to run if bcma_sprom_onchip_available() returns false.

> bcma: add support for sprom not found on the device.
> 
> Now working on changes in brcmsmac to start using the sprom
> data stored in struct bcma_bus. Feel free to comment this patch.
> 
> Gr. AvS
> ---
>  drivers/bcma/sprom.c                        |  118 ++++++++++++++++++++++++---
>  include/linux/bcma/bcma_driver_chipcommon.h |    9 ++
>  2 files changed, 115 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
> index ca77525..4dd537c 100644
> --- a/drivers/bcma/sprom.c
> +++ b/drivers/bcma/sprom.c
> @@ -246,22 +246,121 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
>  	     SSB_SROM8_FEM_ANTSWLUT_SHIFT);
>  }
>  
> +/*
> + * Indicates the presence of external SPROM.
> + */
> +static bool bcma_sprom_ext_available(struct bcma_bus *bus)
> +{
> +	u32 chip_status;
> +	u32 srom_control;
> +	u32 present_mask;
> +
> +	if (bus->drv_cc.core->id.rev >= 31) {
> +		if (!(bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM))
> +				return false;
> +
> +		srom_control = bcma_read32(bus->drv_cc.core,
> +					   BCMA_CC_SROM_CONTROL);
> +		return !!(srom_control & BCMA_CC_SROM_CONTROL_PRESENT);
> +	}
> +
> +	/* older chipcommon revisions use chip status register */
> +	chip_status = bcma_read32(bus->drv_cc.core, BCMA_CC_CHIPSTAT);
> +	switch (bus->chipinfo.id) {
> +	case 0x4313:
> +		present_mask = BCMA_CC_CHIPST_4313_SPROM_PRESENT;
> +		break;
> +
> +	case 0x4331:
> +		present_mask = BCMA_CC_CHIPST_4331_SPROM_PRESENT;
> +		break;
> +
> +	default:
> +		return true;
> +	}
> +
> +	return (chip_status & present_mask) == present_mask;
> +}
> +
> +/*
> + * Indicates that on-chip OTP memory is present and enabled.
> + */
> +static bool bcma_sprom_onchip_available(struct bcma_bus *bus)
> +{
> +	u32 chip_status;
> +	u32 otpsize = 0;
> +	bool present;
> +
> +	chip_status = bcma_read32(bus->drv_cc.core, BCMA_CC_CHIPSTAT);
> +	switch (bus->chipinfo.id) {
> +	case 0x4313:
> +		present = chip_status & BCMA_CC_CHIPST_4313_OTP_PRESENT;
> +		break;
> +
> +	case 0x4331:
> +		present = chip_status & BCMA_CC_CHIPST_4331_OTP_PRESENT;
> +		break;
> +
> +	case 43224:
> +	case 43225:
> +		/* for these chips OTP is always available */
> +		present = true;
> +		break;
> +
> +	default:
> +		present = false;
> +		break;
> +	}
> +
> +	if (present) {
> +		otpsize = bus->drv_cc.capabilities & BCMA_CC_CAP_OTPS;
> +		otpsize >>= BCMA_CC_CAP_OTPS_SHIFT;
> +	}
> +
> +	return otpsize != 0;
> +}
> +
> +/*
> + * Verify OTP is filled and determine the byte
> + * offset where SPROM data is located.
> + *
> + * On error, returns 0; byte offset otherwise.
> + */
> +static int bcma_sprom_onchip_offset(struct bcma_bus *bus)
> +{
> +	struct bcma_device *cc = bus->drv_cc.core;
> +	u32 offset;
> +
> +	/* verify OTP status */
> +	if ((bcma_read32(cc, BCMA_CC_OTPS) & BCMA_CC_OTPS_GU_PROG_HW) == 0)
> +		return 0;
> +
> +	/* obtain bit offset from otplayout register */
> +	offset = (bcma_read32(cc, BCMA_CC_OTPL) & BCMA_CC_OTPL_GURGN_OFFSET);
> +	return BCMA_CC_SPROM + (offset >> 3);
> +}
> +
>  int bcma_sprom_get(struct bcma_bus *bus)
>  {
> -	u16 offset;
> +	u16 offset = BCMA_CC_SPROM;
>  	u16 *sprom;
> -	u32 sromctrl;
>  	int err = 0;
>  
>  	if (!bus->drv_cc.core)
>  		return -EOPNOTSUPP;
>  
> -	if (!(bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM))
> -		return -ENOENT;
> +	if (!bcma_sprom_ext_available(bus)) {
> +		/*
> +		 * External SPROM takes precedence so check
> +		 * on-chip OTP only when no external SPROM
> +		 * is present.
> +		 */
> +		if (!bcma_sprom_onchip_available(bus))
> +			return -ENOENT;
>  
> -	if (bus->drv_cc.core->id.rev >= 32) {
> -		sromctrl = bcma_read32(bus->drv_cc.core, BCMA_CC_SROM_CONTROL);
> -		if (!(sromctrl & BCMA_CC_SROM_CONTROL_PRESENT))
> +		/* determine offset */
> +		offset = bcma_sprom_onchip_offset(bus);
> +		if (!offset)
>  			return -ENOENT;
>  	}
>  
> @@ -273,11 +372,6 @@ int bcma_sprom_get(struct bcma_bus *bus)
>  	if (bus->chipinfo.id == 0x4331)
>  		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, false);
>  
> -	/* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
> -	 * According to brcm80211 this applies to cards with PCIe rev >= 6
> -	 * TODO: understand this condition and use it */
> -	offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
> -		BCMA_CC_SPROM_PCIE6;
>  	pr_debug("SPROM offset 0x%x\n", offset);
>  	bcma_sprom_read(bus, offset, sprom);
>  
> diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
> index e72938b..d963510 100644
> --- a/include/linux/bcma/bcma_driver_chipcommon.h
> +++ b/include/linux/bcma/bcma_driver_chipcommon.h
> @@ -56,6 +56,9 @@
>  #define	 BCMA_CC_OTPS_HW_PROTECT	0x00000001
>  #define	 BCMA_CC_OTPS_SW_PROTECT	0x00000002
>  #define	 BCMA_CC_OTPS_CID_PROTECT	0x00000004
> +#define  BCMA_CC_OTPS_GU_PROG_IND	0x00000F00	/* General Use programmed indication */
> +#define  BCMA_CC_OTPS_GU_PROG_IND_SHIFT	8
> +#define  BCMA_CC_OTPS_GU_PROG_HW	0x00000100	/* HW region programmed */
>  #define BCMA_CC_OTPC			0x0014		/* OTP control */
>  #define	 BCMA_CC_OTPC_RECWAIT		0xFF000000
>  #define	 BCMA_CC_OTPC_PROGWAIT		0x00FFFF00
> @@ -72,6 +75,8 @@
>  #define	 BCMA_CC_OTPP_READ		0x40000000
>  #define	 BCMA_CC_OTPP_START		0x80000000
>  #define	 BCMA_CC_OTPP_BUSY		0x80000000
> +#define BCMA_CC_OTPL			0x001C		/* OTP layout */
> +#define  BCMA_CC_OTPL_GURGN_OFFSET	0x00000FFF	/* offset of general use region */
>  #define BCMA_CC_IRQSTAT			0x0020
>  #define BCMA_CC_IRQMASK			0x0024
>  #define	 BCMA_CC_IRQ_GPIO		0x00000001	/* gpio intr */
> @@ -79,6 +84,10 @@
>  #define	 BCMA_CC_IRQ_WDRESET		0x80000000	/* watchdog reset occurred */
>  #define BCMA_CC_CHIPCTL			0x0028		/* Rev >= 11 only */
>  #define BCMA_CC_CHIPSTAT		0x002C		/* Rev >= 11 only */
> +#define  BCMA_CC_CHIPST_4313_SPROM_PRESENT	1
> +#define  BCMA_CC_CHIPST_4313_OTP_PRESENT	2
> +#define  BCMA_CC_CHIPST_4331_SPROM_PRESENT	2
> +#define	 BCMA_CC_CHIPST_4331_OTP_PRESENT	4
>  #define BCMA_CC_JCMD			0x0030		/* Rev >= 10 only */
>  #define  BCMA_CC_JCMD_START		0x80000000
>  #define  BCMA_CC_JCMD_BUSY		0x80000000

What is the correct way to format this file? BCMA_CC_JCMD_BUSY uses two
spaces after the define and BCMA_CC_OTPS_CID_PROTECT uses a tabulator
and a space, what is the correct or intended way to format this? This
does not have directly something to do with this patches as both ways
are currently coded in this file.
