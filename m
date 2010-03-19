Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45299 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0CSVM6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:12:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v3] ssb: do not read SPROM if it does not exist
Date: Fri, 19 Mar 2010 22:12:55 +0100
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>, stable@kernel.org
References: <1269030785-5347-1-git-send-email-linville@tuxdriver.com> <1269031309-23297-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1269031309-23297-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201003192212.55680.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 March 2010 21:41:49 John W. Linville wrote:
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
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: stable@kernel.org
> ---
> Version 3, add missing semi-colon... :-(
> Version 2, check the correct place for ChipCommon core revision... :-)
> 
>  drivers/ssb/pci.c                         |    3 +++
>  drivers/ssb/scan.c                        |    4 ++++
>  drivers/ssb/sprom.c                       |   22 ++++++++++++++++++++++
>  include/linux/ssb/ssb.h                   |    3 +++
>  include/linux/ssb/ssb_driver_chipcommon.h |   15 +++++++++++++++
>  5 files changed, 47 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index 9e50896..2f7b16d 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -620,6 +620,9 @@ static int ssb_pci_sprom_get(struct ssb_bus *bus,
>  	int err = -ENOMEM;
>  	u16 *buf;
>  
> +	if (!ssb_is_sprom_available(bus))
> +		return -ENODEV;
> +
>  	buf = kcalloc(SSB_SPROMSIZE_WORDS_R123, sizeof(u16), GFP_KERNEL);
>  	if (!buf)
>  		goto out;
> diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
> index 0d6c028..6d51895 100644
> --- a/drivers/ssb/scan.c
> +++ b/drivers/ssb/scan.c
> @@ -306,6 +306,10 @@ int ssb_bus_scan(struct ssb_bus *bus,
>  		}
>  		tmp = scan_read32(bus, 0, SSB_CHIPCO_CAP);
>  		bus->chipco.capabilities = tmp;
> +		if (bus->chipco.dev->id.revision >= 11) {
> +			tmp = scan_read32(bus, 0, SSB_CHIPCO_CHIPSTAT);
> +			bus->chipco.status = tmp;
> +		}

Hm, Ok. There's another issue here. We're that early in the scan that
id.xxxx is not assigned, yet. I think chipco.dev might even be NULL here, so
it'd crash.
This gets a little bit ugly. The revisions are read later in the scan function.
And as you can see there the actual read is pretty ugly, too.

What if we do not read the status _that_ early? We're really very very
early here. If you move the read into the chipcommon driver init, it will be much
easier.

-- 
Greetings, Michael.
