Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57026 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0CaTUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 15:20:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH V2] ssb: do not read SPROM if it does not exist
Date: Wed, 31 Mar 2010 20:20:02 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <1270059662-568-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1270059662-568-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003312120.02331.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 31 March 2010 20:21:02 Rafał Miłecki wrote:
> Attempting to read registers that don't exist on the SSB bus can cause
> hangs on some boxes.  At least some b43 devices are 'in the wild' that
> don't have SPROMs at all.  When the SSB bus support loads, it attempts
> to read these (non-existant) SPROMs and causes hard hangs on the box --
> no console output, etc.
> 
> This patch adds some intelligence to determine whether or not the SPROM
> is present before attempting to read it.  This avoids those hard hangs
> on those devices with no SPROM attached to their SSB bus.  The
> SSB-attached devices (e.g. b43, et al.) won't work, but at least the box
> will survive to test further patches. :-)
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Michael Buesch <mb@bu3sch.de>
> ---
> V2: adapt to updated specs, drop some warning-causing braces
> 
> Do I understand correctly this patch can be applied even without fix for
> location of SPROM? AFAIU that is separated issue and we do not support
> SPROM with recently discovered location anyway. However this should fix
> hangs on boards without SPROM, right?
> 
> John: I searched for explaination of Signed-off-by and found info it shows
> people involved in creating patch. As this one is mostly based on yours, I
> have kept your S-o-b line. Is that OK? Is this also OK I added myself, even
> if my involvement is much lower than yours?
> 
> Please do not irritate if I done this incorrectly :)
> 
> So finally: can someone test this, please? John?
> ---
>  drivers/ssb/driver_chipcommon.c           |    2 +
>  drivers/ssb/pci.c                         |    5 ++++
>  drivers/ssb/sprom.c                       |   30 +++++++++++++++++++++++++++++
>  include/linux/ssb/ssb.h                   |    3 ++
>  include/linux/ssb/ssb_driver_chipcommon.h |   15 ++++++++++++++
>  5 files changed, 55 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ssb/driver_chipcommon.c b/drivers/ssb/driver_chipcommon.c
> index 59c3c0f..59ae76b 100644
> --- a/drivers/ssb/driver_chipcommon.c
> +++ b/drivers/ssb/driver_chipcommon.c
> @@ -233,6 +233,8 @@ void ssb_chipcommon_init(struct ssb_chipcommon *cc)
>  {
>  	if (!cc->dev)
>  		return; /* We don't have a ChipCommon */
> +	if (cc->dev->id.revision >= 11)
> +		cc->status = chipco_read32(cc, SSB_CHIPCO_CHIPSTAT);
>  	ssb_pmu_init(cc);
>  	chipco_powercontrol_init(cc);
>  	ssb_chipco_set_clockmode(cc, SSB_CLKMODE_FAST);
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 9e50896..a4b2b99 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -620,6 +620,11 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
>  	int err = -ENOMEM;
>  	u16 *buf;
>  
> +	if (!ssb_is_sprom_available(bus)) {
> +		ssb_printk(KERN_ERR PFX "No SPROM available!\n");
> +		return -ENODEV;
> +	}
> +
>  	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
>  	if (!buf)
>  		goto out;
> diff --git a/drivers/ssb/sprom.c b/drivers/ssb/sprom.c
> index d0e6762..fbaa68c 100644
> --- a/drivers/ssb/sprom.c
> +++ b/drivers/ssb/sprom.c
> @@ -175,3 +175,33 @@ const struct ssb_sprom *ssb_get_fallback_sprom(void)
>  {
>  	return fallback_sprom;
>  }
> +
> +bool ssb_is_sprom_available(struct ssb_bus *bus)
> +{
> +	if (bus->bustype == SSB_BUSTYPE_PCI) {
> +		if (bus->chipco.dev->id.revision >= 31)
> +			return bus->chipco.capabilities & SSB_CHIPCO_CAP_SPROM;
> +	} else if (bus->bustype == SSB_BUSTYPE_PCMCIA) {

Please note that this whole PCMCIA branch will be dead and never be executed.
We do not access the SPROM directly on PCMCIA. We use the PCMCIA tuples
for fetching the information.

> +		/* status register only exists on chipcomon rev >= 11 */
> +		if (bus->chipco.dev->id.revision < 11)
> +			return true;
> +
> +		switch (bus->chip_id) {
> +		case 0x4312:
> +			return SSB_CHIPCO_CHST_4312_SPROM_PRESENT(
> +							bus->chipco.status);
> +		case 0x4322:
> +			return SSB_CHIPCO_CHST_4322_SPROM_PRESENT(
> +							bus->chipco.status);
> +		case 0x4325:
> +			return SSB_CHIPCO_CHST_4325_SPROM_PRESENT(
> +							bus->chipco.status);
> +		default:
> +			break;
> +		}
> +
> +		if (bus->chipco.dev->id.revision >= 31)
> +			return bus->chipco.capabilities & SSB_CHIPCO_CAP_SPROM;
> +	}
> +	return true;
> +}

-- 
Greetings, Michael.
