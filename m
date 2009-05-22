Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f103.google.com ([209.85.216.103]:57780 "EHLO
	mail-px0-f103.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228AbZEVALX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 20:11:23 -0400
Received: by pxi1 with SMTP id 1so994175pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 17:11:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090521235742.GA7684@tesla>
References: <4A0802B0.9070206@gmx.de> <20090511190602.GC18696@tesla>
	<618D4DE9D5223A45A46C48063FD640451098774889@TAEXMB-01.global.atheros.com>
	<20090521171619.GB28691@tesla> <4A15E219.7040908@gmx.de> <20090521235742.GA7684@tesla>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 21 May 2009 17:11:04 -0700
Message-ID: <43e72e890905211711p5dc29b52n778dd384915a2f1@mail.gmail.com>
Subject: Re: ath/regd.c: regdomain 0x8000 fails to retrieve a regulatory
	domain pair
To: Joerg Albert <jal2@gmx.de>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>, David.Quan@atheros.com,
	Tony Yang <Tony.Yang@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 4:57 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, May 21, 2009 at 04:22:01PM -0700, Joerg Albert wrote:
>> On 05/21/2009 07:16 PM, Luis R. Rodriguez wrote:
>>
>> > Joerg, can you please try this patch, its just informative and I would
>> > like to see the output. A regulatory domain in the EEPROM set to 0x8000
>> > should be cought, as you indicated, in this code:
>> >
>> >         if (reg->country_code == CTRY_DEFAULT &&
>> >             regdmn == CTRY_DEFAULT)
>> >                 reg->country_code = CTRY_UNITED_STATES;
>> >
>> > The debug prints should help.
>>  > ...
>> With the patch I get:
>>
>> usb 1-5: firmware: requesting ar9170-2.fw
>> ath: EEPROM indicates we should expect a country code
>> ath: No regulatory domain pair found, cannot continue
>> ar9170usb: probe of 1-5:1.0 failed with error -22
>>
>> IMHO the in the above if-statement regdmn == 0x8000 (as read from
>> the EEPROM by ath_regd_get_eepromRD), but CTRY_DEFAULT is defined as
>> zero, so reg->country_code isn't set.
>> Shouldn't we say "regdmn == (CTRY_DEFAULT|COUNTRY_ERD_FLAG)",because
>> without the ERD flag set we cannot compare a regdomain with a
>> country code?
>
> I agree, regdmn is set from calling ath_regd_get_eepromRD() which
> returns:
>
>        reg->current_rd & ~WORLDWIDE_ROAMING_FLAG
>
> This is:
>
>        reg->current_rd & ~0x4000
>
> And _not_
>
>        reg->current_rd & ~COUNTRY_ERD_FLAG
>
> which would be:
>
>        reg->current_rd & ~0x8000
>
> This _does_ explain why you end up where you do, and we don't
> let the driver continue. However, it does seem that 0x8000 is in fact
> not a valid regulatory domain code which should be used. Problem
> with using CTRY_UNITED_STATES or 0x64 (or another custom atheros
> world regulatory domain) for this case is non properly calibrated
> data may be used, specifically for the CTL indexes. We'll check on
> this internally, regardless we need a solution for you.

BTW is this a dual band (2.4 GHz and 5 GHz) device or a single band (2.4 GHz) ?

  Luis
