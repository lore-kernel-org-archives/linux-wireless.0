Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46032 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab0KPV3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 16:29:54 -0500
Date: Tue, 16 Nov 2010 16:23:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Michael =?iso-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] ssb: fail registration for unknown SPROM revision
Message-ID: <20101116212321.GF10774@tuxdriver.com>
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
 <1288823326-9686-2-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1288823326-9686-2-git-send-email-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 03, 2010 at 11:28:46PM +0100, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> As noticed my Michael we have this left from old times of limited amount of
> revisions. It's not reliable to treat unknown as rev1.
> 
> Michael: would you like to add Reported-by?
> 
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

I think this is going to make my b43 PCI-E card not work...I'll try
it and get back to you...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
