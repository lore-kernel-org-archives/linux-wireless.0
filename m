Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:33238 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756472Ab0CaT3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 15:29:21 -0400
Received: by qw-out-2122.google.com with SMTP id 8so147333qwh.37
        for <linux-wireless@vger.kernel.org>; Wed, 31 Mar 2010 12:29:20 -0700 (PDT)
Message-ID: <4BB3A28C.3070404@lwfinger.net>
Date: Wed, 31 Mar 2010 14:29:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH V2] ssb: do not read SPROM if it does not exist
References: <1270059662-568-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1270059662-568-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/31/2010 01:21 PM, Rafał Miłecki wrote:
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

It is separate from the SPROM location change.

> John: I searched for explaination of Signed-off-by and found info it shows
> people involved in creating patch. As this one is mostly based on yours, I
> have kept your S-o-b line. Is that OK? Is this also OK I added myself, even
> if my involvement is much lower than yours?
> 
> Please do not irritate if I done this incorrectly :)
> 
> So finally: can someone test this, please? John?

The usual way to do this is to include a From: line as the first thing
in the patch. That indicates that the patch is not from the person that
actually submitted it, and it implies a sighed-off-by.

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
> +		/* status register only exists on chipcomon rev >= 11 */
> +		if (bus->chipco.dev->id.revision < 11)
> +			return true;
> +

I works as is, but seeing the above if caused me to revise the specs a
little. The test for chip common revision < 11 should be first.

Larry
