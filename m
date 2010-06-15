Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56429 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218Ab0FORlK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 13:41:10 -0400
Received: by fxm10 with SMTP id 10so327018fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jun 2010 10:41:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinEMAQu33Tlv81-Cdx9fLZK-a-7uJlbAo7te2_w@mail.gmail.com>
References: <20100613.145200.1459063883179763823.kou@clear-code.com>
	<AANLkTinEMAQu33Tlv81-Cdx9fLZK-a-7uJlbAo7te2_w@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 15 Jun 2010 19:40:48 +0200
Message-ID: <AANLkTimxIlLYrNnXJ6mIvmBYGAL7Fv9T0uCY_2yszRQ2@mail.gmail.com>
Subject: Re: [PATCH] zd1211rw: ignore unknown regulatory domain.
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kouhei Sutou <kou@clear-code.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	linux-wireless@vger.kernel.org,
	Michael Green <Michael.Green@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 13, 2010 at 10:23 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> Note: this e-mail is on a public mailing list!
>
> On Sat, Jun 12, 2010 at 10:52 PM, Kouhei Sutou <kou@clear-code.com> wrote:
>> Hi,
>>
>> I'm using PLANEX GW-US54GXS (2019:5303) and it works with
>> the attached patch. Could you consider to merge the attached
>> patch?
>>
>> Problem: GW-US54GXS uses zd1211rw but zd1211rw doesn't have
>> a regulatory domain reported by GW-US54GXS (0x49).
>>
>> Solutions:
>>
>>  (1) add a new regulatory domain (0x49). Here is a patch to
>>      use the approach:
>
> Stephen, David, does 0x49 map to JP for zd1211 ? Are there other ones?
> Here is our list so far:
>
> #define ZD_REGDOMAIN_FCC        0x10
> #define ZD_REGDOMAIN_IC         0x20
> #define ZD_REGDOMAIN_ETSI       0x30
> #define ZD_REGDOMAIN_SPAIN      0x31
> #define ZD_REGDOMAIN_FRANCE     0x32
> #define ZD_REGDOMAIN_JAPAN_ADD  0x40
> #define ZD_REGDOMAIN_JAPAN      0x41
>
> This is what they map to:
>
> static struct zd_reg_alpha2_map reg_alpha2_map[] = {
>        { ZD_REGDOMAIN_FCC, "US" },
>        { ZD_REGDOMAIN_IC, "CA" },
>        { ZD_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */

Note: This one is causing me problems here in Hungary, as it keeps
resetting my regdomain to Germany. I believe we should implement
allowing the user to choose regdomain in this case, but allowing only
regdomains in ETSI.

>        { ZD_REGDOMAIN_JAPAN, "JP" },
>        { ZD_REGDOMAIN_JAPAN_ADD, "JP" },
>        { ZD_REGDOMAIN_SPAIN, "ES" },
>        { ZD_REGDOMAIN_FRANCE, "FR" },
> };
>
> Kouhei, if no regulatory domain is found, instead we should world
> roam, we cannot allow letting the user change regulatory domains at
> their whim. We can, however let them choose one to help compliance,
> but you can only help compliance once you know your actual regulatory
> domain.
>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
