Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:51285 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZEUSTW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 14:19:22 -0400
Received: by bwz22 with SMTP id 22so1179480bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 11:19:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090521171619.GB28691@tesla>
References: <4A0802B0.9070206@gmx.de> <20090511190602.GC18696@tesla>
	<618D4DE9D5223A45A46C48063FD640451098774889@TAEXMB-01.global.atheros.com>
	<20090521171619.GB28691@tesla>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 21 May 2009 20:19:02 +0200
Message-ID: <69e28c910905211119l1a0e0e31u914cfd609afd295b@mail.gmail.com>
Subject: Re: ath/regd.c: regdomain 0x8000 fails to retrieve a regulatory
	domain pair
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Stephen Chen <Stephen.Chen@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Joerg Albert <jal2@gmx.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 7:16 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
>> On Mon, May 11, 2009 at 03:49:20AM -0700, Joerg Albert wrote:
>> > Plugging in a WNDA3100 (ar9170usb) I get the error
>> >
>> > ath: No regulatory domain pair found, cannot continue
>> >
>> > Seems like the EEPROM of the stick initializes regulatory.current_rd
>> > to 0x8000, current_rd_ext to 0. Is this a valid setting?
>> >
>> > Looked into ath/regd.c, ath_regd_init():
>> >
>> > ath_get_regpair(regdmn)
>> >
>> > is called with regdmn == 0x8000 and returns NULL.
>> >
>> > Shall that regdmn value be dealt with by
>> >
>> >          if (reg->country_code == CTRY_DEFAULT &&
>> >              regdmn == CTRY_DEFAULT)
>> >                  reg->country_code = CTRY_UNITED_STATES;
>> > ?

Why CTRY_UNITED_STATES? Is there no CTRY_WORLD? Or is 0x8000 US-specific?

>> >
>> > wireless-testing is git v2.6.30-rc4-22735-gbd48c47, I run
>> > compat-wireless with a 2.6.29.2 kernel.
>>
>> Thanks for reporting this.
>>
>> Stephen do ar9170 cards get sold with a regulatory domain set to 0x8000?
>> If so we need to deal with this in the common ath.ko module and set the regulatory
>> domain as intended.
>>
>> If we are not sure we can simply default to one of the world regulatory domains for
>> this specific case, 0x64, for example.
>
> Joerg, can you please try this patch, its just informative and I would
> like to see the output. A regulatory domain in the EEPROM set to 0x8000
> should be cought, as you indicated, in this code:
>
>        if (reg->country_code == CTRY_DEFAULT &&
>            regdmn == CTRY_DEFAULT)
>                reg->country_code = CTRY_UNITED_STATES;
>
> The debug prints should help.
>
>  Luis
>
> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> Subject: [PATCH] ath: make regulatory initialization more informative
>
> This should help debugging. This has no functional change.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  drivers/net/wireless/ath/regd.c |   22 +++++++++++++++++++---
>  1 files changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
> index 7a89f9f..556e252 100644
> --- a/drivers/net/wireless/ath/regd.c
> +++ b/drivers/net/wireless/ath/regd.c
> @@ -366,11 +366,17 @@ static bool ath_regd_is_eeprom_valid(struct ath_regulatory *reg)
>        if (rd & COUNTRY_ERD_FLAG) {
>                /* EEPROM value is a country code */
>                u16 cc = rd & ~COUNTRY_ERD_FLAG;
> +               printk(KERN_DEBUG
> +                      "ath: EEPROM indicates we should expect "
> +                       "a country code\n");
>                for (i = 0; i < ARRAY_SIZE(allCountries); i++)
>                        if (allCountries[i].countryCode == cc)
>                                return true;
>        } else {
>                /* EEPROM value is a regpair value */
> +               if (rd != CTRY_DEFAULT)
> +                       printk(KERN_DEBUG "ath: EEPROM indicates we "
> +                              "should expect a direct regpair map\n");
>                for (i = 0; i < ARRAY_SIZE(regDomainPairs); i++)
>                        if (regDomainPairs[i].regDmnEnum == rd)
>                                return true;
> @@ -486,20 +492,30 @@ ath_regd_init(struct ath_regulatory *reg,
>        reg->country_code = ath_regd_get_default_country(regdmn);
>
>        if (reg->country_code == CTRY_DEFAULT &&
> -           regdmn == CTRY_DEFAULT)
> +           regdmn == CTRY_DEFAULT) {
> +               printk(KERN_DEBUG "ath: EEPROM indicates default "
> +                      "country code should be used\n");
>                reg->country_code = CTRY_UNITED_STATES;
> +       }
>
>        if (reg->country_code == CTRY_DEFAULT) {
>                country = NULL;
>        } else {
> +               printk(KERN_DEBUG "ath: doing EEPROM country->regdmn "
> +                      "map search\n");
>                country = ath_regd_find_country(reg->country_code);
>                if (country == NULL) {
>                        printk(KERN_DEBUG
> -                               "ath: Country is NULL!!!!, cc= %d\n",
> +                               "ath: no valid country maps found for "
> +                               "country code: 0x%0x\n",
>                                reg->country_code);
>                        return -EINVAL;
> -               } else
> +               } else {
>                        regdmn = country->regDmnEnum;
> +                       printk(KERN_DEBUG "ath: country maps to "
> +                              "regdmn code: 0x%0x\n",
> +                              regdmn);
> +               }
>        }
>
>        reg->regpair = ath_get_regpair(regdmn);
> --
> 1.5.6.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
