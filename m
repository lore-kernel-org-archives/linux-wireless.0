Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58010 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbZEUX5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 19:57:39 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 16:57:42 -0700
Date: Thu, 21 May 2009 16:57:42 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Joerg Albert <jal2@gmx.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>,
	<David.Quan@atheros.com>, Tony Yang <Tony.Yang@Atheros.com>
Subject: Re: ath/regd.c: regdomain 0x8000 fails to retrieve a regulatory
	domain pair
Message-ID: <20090521235742.GA7684@tesla>
References: <4A0802B0.9070206@gmx.de> <20090511190602.GC18696@tesla> <618D4DE9D5223A45A46C48063FD640451098774889@TAEXMB-01.global.atheros.com> <20090521171619.GB28691@tesla> <4A15E219.7040908@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A15E219.7040908@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 04:22:01PM -0700, Joerg Albert wrote:
> On 05/21/2009 07:16 PM, Luis R. Rodriguez wrote:
> 
> > Joerg, can you please try this patch, its just informative and I would
> > like to see the output. A regulatory domain in the EEPROM set to 0x8000
> > should be cought, as you indicated, in this code:
> >
> >         if (reg->country_code == CTRY_DEFAULT &&
> >             regdmn == CTRY_DEFAULT)
> >                 reg->country_code = CTRY_UNITED_STATES;
> >
> > The debug prints should help.
>  > ...
> With the patch I get:
> 
> usb 1-5: firmware: requesting ar9170-2.fw
> ath: EEPROM indicates we should expect a country code
> ath: No regulatory domain pair found, cannot continue
> ar9170usb: probe of 1-5:1.0 failed with error -22
> 
> IMHO the in the above if-statement regdmn == 0x8000 (as read from
> the EEPROM by ath_regd_get_eepromRD), but CTRY_DEFAULT is defined as
> zero, so reg->country_code isn't set.
> Shouldn't we say "regdmn == (CTRY_DEFAULT|COUNTRY_ERD_FLAG)",because
> without the ERD flag set we cannot compare a regdomain with a
> country code?

I agree, regdmn is set from calling ath_regd_get_eepromRD() which
returns:

	reg->current_rd & ~WORLDWIDE_ROAMING_FLAG

This is:

	reg->current_rd & ~0x4000

And _not_ 

	reg->current_rd & ~COUNTRY_ERD_FLAG

which would be:

	reg->current_rd & ~0x8000

This _does_ explain why you end up where you do, and we don't
let the driver continue. However, it does seem that 0x8000 is in fact
not a valid regulatory domain code which should be used. Problem
with using CTRY_UNITED_STATES or 0x64 (or another custom atheros
world regulatory domain) for this case is non properly calibrated
data may be used, specifically for the CTL indexes. We'll check on
this internally, regardless we need a solution for you.

  Luis
