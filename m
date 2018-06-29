Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41230 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbeF2HaO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 03:30:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 13/14] rtlwifi: access skb->data to get C2H data by macro
References: <20180518093007.23594-1-pkshih@realtek.com>
        <20180518093007.23594-14-pkshih@realtek.com>
        <87po1fhwfd.fsf@purkki.adurom.net>
        <1527732798.8418.7.camel@realtek.com>
Date: Fri, 29 Jun 2018 10:30:08 +0300
In-Reply-To: <1527732798.8418.7.camel@realtek.com> (pkshih@realtek.com's
        message of "Thu, 31 May 2018 02:13:35 +0000")
Message-ID: <87sh56f3sv.fsf@codeaurora.org> (sfid-20180629_093018_333953_910D4CF2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkshih <pkshih@realtek.com> writes:

> On Tue, 2018-05-29 at 08:18 +0300, Kalle Valo wrote:
>> <pkshih@realtek.com> writes:
>>=C2=A0
>> > From: Ping-Ke Shih <pkshih@realtek.com>
>> >
>> > The format of C2H data is ID(1 byte) + Length(1 byte) + value, and it =
is
>> > more readable to use macros to access C2H data.
>> >
>> > Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>>=C2=A0
>> [...]
>>=C2=A0
>> > --- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
>> > +++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
>> > @@ -177,6 +177,11 @@ enum rtl_c2h_evt_v2 {
>> >=C2=A0=C2=A0	C2H_V2_CCX_RPT =3D 0x0F,
>> >=C2=A0=C2=A0};
>> >=C2=A0=C2=A0
>> > +#define GET_C2H_CMD_ID(c2h)	({u8 *__c2h =3D c2h; __c2h[0]; })
>> > +#define GET_C2H_SEQ(c2h)	({u8 *__c2h =3D c2h; __c2h[1]; })
>> > +#define C2H_DATA_OFFSET		2
>> > +#define GET_C2H_DATA_PTR(c2h)	({u8 *__c2h =3D c2h; &__c2h[C2H_DATA_OF=
FSET]; })
>>=C2=A0
>> These macros are not really pretty, a proper static inline function
>> would be a much better choise. But I'm planning to apply this patch
>> anyway, I don't think it's a blocker but a good idea to cleanup later.
>>=C2=A0
>> And rtlwifi really should get away with this foo[0] and foo[1] style of
>> buffers and switch to proper structs (foo->bar and foo->koo).
>
> Thanks for your review and suggestion.
>
> Because C2H data is little endian order, the struct will look like
> struct foo {
> #ifdef=C2=A0__LITTLE_ENDIAN
> 	u8 bar:4;
> 	u8 koo:4;
> #else
> 	u8 koo:4;
> 	u8 bar:4;
> #endif
> }

With u8 you don't need endian check, right? I would assume that with
both little and big endian bar and koo would be in the same place.

> Is this a linux convention?

Earlier bitfields were disliked but nowadays they seem to be have become
more acceptable. But I think the preferred way still is something like
this (using u32 and 16 bit fields):

struct foo {
        __le32 koobar;
}

#define RTLWIFI_BAR_MASK GENMASK(15, 0)
#define RTLWIFI_KOO_MASK GENMASK(31, 16)

bar =3D FIELD_GET(RTLWIFI_BAR_MASK, __le32_to_cpu(foo->koobar));
koo =3D FIELD_GET(RTLWIFI_KOO_MASK, __le32_to_cpu(foo->koobar));

Of course there can be other good ways to do the same, others can chime
in about those, but this is how I would do it.

--=20
Kalle Valo
