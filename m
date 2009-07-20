Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49276 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbZGTP1H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 11:27:07 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2009 08:27:08 -0700
Date: Mon, 20 Jul 2009 08:27:06 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Joerg Albert <jal2@gmx.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	David Quan <David.Quan@Atheros.com>,
	Tony Yang <Tony.Yang@Atheros.com>
Subject: Re: [PATCH] ath: add support for special 0x8000 regulatory domain
Message-ID: <20090720152706.GA4734@mosca>
References: <1247779124-29204-1-git-send-email-lrodriguez@atheros.com>
 <4A631321.8070500@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A631321.8070500@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 19, 2009 at 05:35:45AM -0700, Joerg Albert wrote:
> On 07/16/2009 11:18 PM, Luis R. Rodriguez wrote:
> > Two users of ar9170 devices have now reported their cards
> > have been programmed with a regulatory domain of 0x8000.
> > This is not a valid regulatory domain as such these users were
> > unable to use these devices. Since this doesn't seem to be
> > a device EEPROM corruption we must treat it specially.
> >
> > We default these devices to the default Atheros 0x64 world
> > regulatory domain.
> > ...
> > David, or Joerg, can you please test this patch.
> 
> Hi Luis,
> 
> this patch doesn't work, I still get:
> 
> ath: EEPROM regdomain: 0x8000
> ath: EEPROM indicates we should expect a country code
> ath: No regulatory domain pair found, cannot continue
> ar9170usb: probe of 1-1:1.0 failed with error -22
> 
> I guess that's due to reg->current_rd == 0x8000, while CTRY_DEFAULT
> == 0 in ath_regd_sanitize().
> 
> Applying
> 
> diff --git a/drivers/net/wireless/ath/regd.c
> b/drivers/net/wireless/ath/regd.c
> index 62aa270..eae9a58 100644
> --- a/drivers/net/wireless/ath/regd.c
> +++ b/drivers/net/wireless/ath/regd.c
> @@ -483,7 +483,7 @@ ath_regd_init_wiphy(struct ath_regulatory *reg,
>    */
>   static void ath_regd_sanitize(struct ath_regulatory *reg)
>   {
> -       if (reg->current_rd != CTRY_DEFAULT)
> +       if (reg->current_rd != (CTRY_DEFAULT|COUNTRY_ERD_FLAG))

Ah yes, it was the ERD flag.. will send another one.

>                  return;
>          printk(KERN_DEBUG "ath: EEPROM regdomain sanitized\n");
>          reg->current_rd = 0x64;
> 
> on top of your patch worked:
> 
> ath: EEPROM regdomain sanitized
> ath: EEPROM regdomain: 0x64
> ath: EEPROM indicates we should expect a direct regpair map
> ath: Country alpha2 being used: 00
> ath: Regpair used: 0x64
> 
> Why do we handle a regdomain of 0x8000 differently from a regdomain
> of 0?

IMHO we should just be treating it as 0 as I believe that was the
manufacturer's intention but since we cannot get confirmation
of that in any way we have no other option but to treat this
as one of our world regulatory domain SKUs.

Will include this as part of the commit log.

> 0x8000 leads to regdomain 0x64 in ath_regd_sanitize() while 0 is
> mapped into country code CTRY_UNITED_STATES.

Right.

> With the above patch I don't see channels 12,13,100-140 in "iwlist
> wlan0 channel", which are allowed in DE, but I guess that's due to
> using regdomain WOR4_WORLD (0x64).

Yeap.

> Do calibration data in the EEPROM really depend on the regdomain,
> i.e. do manufacturers calibrate only for a subset of channels due to
> the regdomain the device will be programmed with?

Yeap, that is the idea.

> BTW, I bought this device refurbished in an U.K. webshop.

Good to know thanks, if we ever do get some sort of confirmation
from the vendor then this can be re-arranged, until then this
is what we will have to use.

 Luis
