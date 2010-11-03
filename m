Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:34650 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab0KCWgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 18:36:11 -0400
Subject: Re: [PATCH] ssb: fail registration for unknown SPROM revision
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1288823326-9686-2-git-send-email-zajec5@gmail.com> (sfid-20101103_232940_908175_FFFFFFFF9E534A4F)
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
	 <1288823326-9686-2-git-send-email-zajec5@gmail.com>
	 (sfid-20101103_232940_908175_FFFFFFFF9E534A4F)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 23:36:06 +0100
Message-ID: <1288823766.7368.120.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-03 at 23:28 +0100, Rafał Miłecki wrote: 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> As noticed my Michael we have this left from old times of limited amount of
> revisions. It's not reliable to treat unknown as rev1.
> 
> Michael: would you like to add Reported-by?

Isn't that only for bugs? This isn't a bug.
But you can add my acked-by, if that's desired.

> John: it's for 2.6.38.
> ---
>  drivers/ssb/pci.c |    8 +++-----
>  1 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index b5343ac..41a7337 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -600,11 +600,9 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
>  		sprom_extract_r8(out, in);
>  		break;
>  	default:
> -		ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
> -			   "  revision %d detected. Will extract"
> -			   " v1\n", out->revision);
> -		out->revision = 1;
> -		sprom_extract_r123(out, in);
> +		ssb_printk(KERN_ERR PFX "Unsupported SPROM revision %d"
> +			   " detected\n", out->revision);
> +		return -EINVAL;
>  	}
>  
>  	if (out->boardflags_lo == 0xFFFF)


-- 
Greetings Michael.

