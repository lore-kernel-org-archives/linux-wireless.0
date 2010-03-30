Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50946 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0C3WL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 18:11:28 -0400
Received: by fxm27 with SMTP id 27so940767fxm.28
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 15:11:26 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: CRDA and ath5k with no country code in EEPROM
Date: Wed, 31 Mar 2010 00:11:16 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <m3tys0tbhk.fsf@intrepid.localdomain> <201003302049.24231.chunkeey@googlemail.com> <m3mxxpo8h6.fsf@intrepid.localdomain>
In-Reply-To: <m3mxxpo8h6.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003310011.16906.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 30 March 2010 22:33:25 Krzysztof Halasa wrote:
> Christian Lamparter <chunkeey@googlemail.com> writes:
> 
> > Are you sure, you (or the hw manufacturer for that matter) didn't confuse
> > the country code with regdomain code?
> >
> > because while they have more or less the same function, they do have different
> > mappings. The 0x00 country code is reserved for the FCC (US), while the 0x00
> > regdomain code is a described as "debug" with supposedly no limitations?!
> 
> I meant regdomain, is the country code (two letters) stored in the
> EEPROM as well?

There's a 16-bit space for either (custom) regdomain pair, or country code.
(There's also another 16-bit _extension_, but this feature is 
 currently unused...)

But I think, I've to _correct_ myself... ;)
I was a confused, but let me tell why:

Country codes consists of a flag 0x8000 which is OR'd
to the ISO 3166-1 numeric value of (your) country.

Regdomains pairs on the other hand don't have any "precise definition".
It's up to the vendor/manufacture to decide what is what and
this _mapping_ has changed between madwifi and ath5k/ath9k.

Here's the example: 
The old legacy madwifi project 
(http://madwifi-project.org/wiki/UserDocs/CountryCode
 Note the: "This is by no means a valid or complete list and should be revised and added to. " )

lists your regdomain setting (0x0000) as a wild-card.
However, the kernel code regd.c (which is from ath9k) uses a completely
different range (0x006x) for "wild-cards" (or world wide roaming).

And here is the REAL twist: 0x0000 regdomain becomes the country code 0x8348 => "US",
whereas country code 0x8000 will be _sanitized_ to 0x0064 regdomain (world wide roaming).

so...
what about some extra madwifi compat code for ath5k (only)?
All we need to do is to convert those 0x00 && 0xff legacy
regdomain pairs to the new WWR 0x0064?

> If so and if others were talking about it instead of
> regdomain, then I was/am really confused.
> 
> ath: EEPROM regdomain: 0x0
> ath: EEPROM indicates default country code should be used
> ath: doing EEPROM country->regdmn map search
> ath: country maps to regdmn code: 0x3a
> ath: Country alpha2 being used: US
> ath: Regpair used: 0x3a
> 
> (This is for other, old card but I think the ones I need to use produce
> the same output).
> 
> Then again: does the regdomain = 0 means "US" or "default country" (or
> something completely different), according to Atheros' docs?

Well, there's another pov: Mikrotik HW is surprisingly cheap
and widely available. I'm suspecting they are are subsidizing their HW
and squeezing an extra penny form their software product sales.
(which of course works out-of-the-box)

Regards,
	Chr
