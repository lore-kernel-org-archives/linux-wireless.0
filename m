Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:55671 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbZC2XNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 19:13:32 -0400
Received: by ewy9 with SMTP id 9so1839569ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 16:13:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090328163929.GA24075@hash.localnet>
References: <200903241938.47155.chunkeey@web.de>
	 <b6c5339f0903241159x505fc88ap4d9850fa74733156@mail.gmail.com>
	 <20090324184100.GA29268@tesla>
	 <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com>
	 <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com>
	 <1237926664.4320.131.camel@johannes.local>
	 <43e72e890903241504u4dfb5c76kbcb11a096bba72fc@mail.gmail.com>
	 <20090328163929.GA24075@hash.localnet>
Date: Mon, 30 Mar 2009 02:13:28 +0300
Message-ID: <40f31dec0903291613w6b6520a5ucf8daeede7a6ae0@mail.gmail.com> (sfid-20090330_011340_093577_9C9D6D47)
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/28 Bob Copeland <me@bobcopeland.com>:
> On Tue, Mar 24, 2009 at 03:04:59PM -0700, Luis R. Rodriguez wrote:
>> >> > Channel list is a good hint, maybe
>> >> > it's time to fix iw/nl80211 to send back all the channels :)
>> >
>> > I looked into yesterday actually, and it's completely non-trivial =
and
>> > requires userspace interface changes.
>>
>> Heh, there goes that idea then. Then in that case I'd advocate even
>> more trimming the channels down.
>
> Nick, what do you think of this? =C2=A0I think it's the best compromi=
se
> for now - people can still get all the channels, normal users get a
> nice speedup in the default case.
>
> --------------------
> From 7289f60a3acf3bb1cfcc2a7ef7c4d88ffd0e13f1 Mon Sep 17 00:00:00 200=
1
> From: Bob Copeland <me@bobcopeland.com>
> Date: Sat, 28 Mar 2009 12:27:31 -0400
> Subject: [PATCH] ath5k: reduce exported channel list
>
> Claiming every available 5 ghz channel has a couple of negative
> side-effects: scanning takes a long time, and the channel list
> overflows the available buffer space for netlink commands,
> resulting in:
>
> =C2=A0 =C2=A0$ iw phy phy0 info
> =C2=A0 =C2=A0command failed: No buffer space available (-105)
>
> This patch adds a modparam so people who want to see all the channels
> can do so by passing all_channels=3D1. =C2=A0By default users will se=
e a
> smaller list of channels that works with iw. =C2=A0This also halves s=
can
> time, from 10 seconds down to less than 5.
>
> Changes-licensed-under: 3-Clause-BSD
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> =C2=A0drivers/net/wireless/ath5k/base.c | =C2=A0 21 +++++++++++++++++=
++++
> =C2=A01 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless=
/ath5k/base.c
> index 5d57d77..a018106 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -64,6 +64,10 @@ static int modparam_nohwcrypt;
> =C2=A0module_param_named(nohwcrypt, modparam_nohwcrypt, int, 0444);
> =C2=A0MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
>
> +static int modparam_all_channels;
> +module_param_named(all_channels, modparam_all_channels, int, 0444);
> +MODULE_PARM_DESC(all_channels, "Expose all channels the device can u=
se.");
> +
>
> =C2=A0/******************\
> =C2=A0* Internal defines *
> @@ -862,6 +866,20 @@ ath5k_ieee2mhz(short chan)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 2212 + =
chan * 20;
> =C2=A0}
>
> +/*
> + * Returns true for the channel numbers user without all_channels mo=
dparam.
> + */
> +static bool ath5k_is_standard_channel(short chan)
> +{
> + =C2=A0 =C2=A0 =C2=A0 return ((chan <=3D 14) ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* UNII 1,2 */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((chan & 3) =3D=3D=
 0 && chan >=3D 36 && chan <=3D 64) ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* midband */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((chan & 3) =3D=3D=
 0 && chan >=3D 100 && chan <=3D 140) ||
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* UNII-3 */
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((chan & 3) =3D=3D=
 1 && chan >=3D 149 && chan <=3D 165));
> +}
> +
> =C2=A0static unsigned int
> =C2=A0ath5k_copy_channels(struct ath5k_hw *ah,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ieee802=
11_channel *channels,
> @@ -899,6 +917,9 @@ ath5k_copy_channels(struct ath5k_hw *ah,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!ath5k_cha=
nnel_ok(ah, freq, chfreq))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0continue;
>
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!modparam_all_=
channels && !ath5k_is_standard_channel(ch))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 continue;
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Write chann=
el info and increment counter */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0channels[count=
].center_freq =3D freq;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0channels[count=
].band =3D (chfreq =3D=3D CHANNEL_2GHZ) ?

Seems fine ;-)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
