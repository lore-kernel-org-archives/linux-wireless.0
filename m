Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57466 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751046AbeC0ORq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 10:17:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 12/15] rtlwifi: btcoex: Add 8822b 1ant/2ant coex files
References: <20180228030718.19510-1-pkshih@realtek.com>
        <20180228030718.19510-13-pkshih@realtek.com>
        <87h8p2otxh.fsf@purkki.adurom.net>
        <1522143176.19618.14.camel@realtek.com>
Date: Tue, 27 Mar 2018 17:17:40 +0300
In-Reply-To: <1522143176.19618.14.camel@realtek.com> (pkshih@realtek.com's
        message of "Tue, 27 Mar 2018 09:32:56 +0000")
Message-ID: <87tvt1ppq3.fsf@kamboji.qca.qualcomm.com> (sfid-20180327_161749_526627_2B1E6BCF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkshih <pkshih@realtek.com> writes:

> On Tue, 2018-03-27 at 10:32 +0300, Kalle Valo wrote:
>> <pkshih@realtek.com> writes:
>>=20
>> > From: Ping-Ke Shih <pkshih@realtek.com>
>> >
>> > There are two or three physical antenna in 8822be WiFi modules, so btc=
oex
>> > introduce two coex files to handle these two cases.
>> >
>> > Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>> > ---
>> >=C2=A0=C2=A0.../realtek/rtlwifi/btcoexist/halbtc8822b1ant.c=C2=A0=C2=A0=
=C2=A0=C2=A0| 5327 +++++++++++++++++++
>> >=C2=A0=C2=A0.../realtek/rtlwifi/btcoexist/halbtc8822b1ant.h=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0413 ++
>> >=C2=A0=C2=A0.../realtek/rtlwifi/btcoexist/halbtc8822b2ant.c=C2=A0=C2=A0=
=C2=A0=C2=A0| 5370 ++++++++++++++++++++
>> >=C2=A0=C2=A0.../realtek/rtlwifi/btcoexist/halbtc8822b2ant.h=C2=A0=C2=A0=
=C2=A0=C2=A0|=C2=A0=C2=A0434 ++
>> >=C2=A0=C2=A04 files changed, 11544 insertions(+)
>>=20
>> Huge patches like this are pain to review. I'm going to split this into
>> two sets, patches 1-11 and patches 12-15.
>>=20
> Do I need to split the four files into four patches?

At least two patches would make it a bit less painful, like one patch
for halbtc8822b1ant.[c|h] and the other for halbtc8822b2ant.[c|h].

>> > +static struct coex_dm_8822b_1ant	glcoex_dm_8822b_1ant;
>> > +static struct coex_dm_8822b_1ant	*coex_dm =3D &glcoex_dm_8822b_1ant;
>> > +static struct coex_sta_8822b_1ant	glcoex_sta_8822b_1ant;
>> > +static struct coex_sta_8822b_1ant	*coex_sta =3D &glcoex_sta_8822b_1an=
t;
>> > +static struct rfe_type_8822b_1ant	gl_rfe_type_8822b_1ant;
>> > +static struct rfe_type_8822b_1ant	*rfe_type =3D &gl_rfe_type_8822b_1a=
nt;
>> > +
>> > +static const char *const glbt_info_src_8822b_1ant[] =3D {
>> > +	"BT Info[wifi fw]",
>> > +	"BT Info[bt rsp]",
>> > +	"BT Info[bt auto report]",
>> > +};
>> > +
>> > +static u32 glcoex_ver_date_8822b_1ant =3D 20180112;
>> > +static u32 glcoex_ver_8822b_1ant =3D 0x59;
>> > +static u32 glcoex_ver_btdesired_8822b_1ant =3D 0x56;
>>=20
>> Having static variables like this means that this will not work if there
>> are two or more device per host, right? IIRC we discussed this before,
>> so what's the plan to solve that?=C2=A0
>>=20
>> In upstream drivers there should not be artificial limitations like one
>> device per host. Is that even checked anywhere or will it just be buggy
>> if there are more than one device?
>>=20
>
> The variables=C2=A0coex_dm/coex_sta/rfe_type should move to struct btcoex=
ist, but
> other btcoex files also use this style. So, my plan is to keep static var=
iables
> in this patch, and use another patch to remove all of them. Since this ta=
kes
> a little time to discuss with our btcoex guys, could I send patches
> 12-15 first?

That sounds like a good plan to me.

> The version related variables are used to display in debug message, so th=
ey
> work on multiple devices.=C2=A0

Ok.

--=20
Kalle Valo
