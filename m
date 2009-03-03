Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:50293 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945AbZCCEbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 23:31:09 -0500
MIME-Version: 1.0
In-Reply-To: <20090303034600.GA3757@hash.localnet>
References: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>
	 <20090226230338.M86894@bobcopeland.com> <49A7236E.2020807@gmail.com>
	 <b6c5339f0902261528i7b581125k29927c3c5ac4fe4c@mail.gmail.com>
	 <49A726A7.6090809@gmail.com> <20090227022704.GA29850@hash.localnet>
	 <20090227023912.GF13456@tesla> <20090227030608.GA29974@hash.localnet>
	 <1235884912.9224.26.camel@mj> <20090303034600.GA3757@hash.localnet>
Date: Tue, 3 Mar 2009 06:31:05 +0200
Message-ID: <40f31dec0903022031l20ecc3dcx9ba7859cb24fa5ae@mail.gmail.com> (sfid-20090303_053118_311360_5FD0F6A7)
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix hw rate index condition
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	"ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/3 Bob Copeland <me@bobcopeland.com>:
> On Sun, Mar 01, 2009 at 12:21:52AM -0500, Pavel Roskin wrote:
>> I would prefer that we don't hide problems.
>>
>> If we don't know why we cannot get a valid rate, we should use WARN_=
ON
>> and find out why and when it happens. =C2=A0I'm fine with using a bo=
gus rate
>> with WARN_ON.
>
> So here is at least stage one of this, not yet the global "unknown ra=
te"
> infrastructure, but hopefully it will allow us to track down the issu=
e.
>
> It makes hw_to_driver_rix a little uglier, but oh well. =C2=A0Thought=
s?
>
> From: Bob Copeland <me@bobcopeland.com>
> Date: Mon, 2 Mar 2009 21:55:18 -0500
> Subject: [PATCH] ath5k: warn and correct rate for unknown hw rate ind=
exes
>
> ath5k sets up a mapping table from the hardware rate index to
> the rate index used by mac80211; however, we have seen some
> received frames with incorrect rate indexes. =C2=A0Such frames
> normally get dropped with a warning in __ieee80211_rx(), but the
> warning doesn't include enough context to track down the error.
>
> This patch adds a warning to hw_to_driver_rix for any lookups
> that result in a rate index of -1, then returns a valid rate so
> the frame can be processed.
>
> This also includes the bug fix suggested by Pavel Roskin, in which
> the mapping table is made signed, so rates initialized to -1 stay
> that way.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> =C2=A0drivers/net/wireless/ath5k/base.c | =C2=A0 15 ++++++++++++---
> =C2=A0drivers/net/wireless/ath5k/base.h | =C2=A0 =C2=A02 +-
> =C2=A02 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless=
/ath5k/base.c
> index f7c424d..8d4b11c 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1100,9 +1100,18 @@ ath5k_mode_setup(struct ath5k_softc *sc)
> =C2=A0static inline int
> =C2=A0ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
> =C2=A0{
> - =C2=A0 =C2=A0 =C2=A0 WARN(hw_rix < 0 || hw_rix >=3D AR5K_MAX_RATES,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "hw_rix out of bounds: %x\n", hw_rix);
> - =C2=A0 =C2=A0 =C2=A0 return sc->rate_idx[sc->curband->band][hw_rix]=
;
> + =C2=A0 =C2=A0 =C2=A0 int rix;
> +
> + =C2=A0 =C2=A0 =C2=A0 /* return base rate on errors */
> + =C2=A0 =C2=A0 =C2=A0 if (WARN(hw_rix < 0 || hw_rix >=3D AR5K_MAX_RA=
TES,
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "hw_rix out of bounds: %x\n", hw_rix))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 rix =3D sc->rate_idx[sc->curband->band][hw_rix=
];
> + =C2=A0 =C2=A0 =C2=A0 if (WARN(rix < 0, "invalid hw_rix: %x\n", hw_r=
ix))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rix =3D 0;
> +
> + =C2=A0 =C2=A0 =C2=A0 return rix;
> =C2=A0}
>
> =C2=A0/***************\
> diff --git a/drivers/net/wireless/ath5k/base.h b/drivers/net/wireless=
/ath5k/base.h
> index 20e0d14..8229561 100644
> --- a/drivers/net/wireless/ath5k/base.h
> +++ b/drivers/net/wireless/ath5k/base.h
> @@ -112,7 +112,7 @@ struct ath5k_softc {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ieee80211_supported_band sbands[IEE=
E80211_NUM_BANDS];
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ieee80211_channel channels[ATH_CHAN=
_MAX];
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ieee80211_rate =C2=A0 rates[IEEE802=
11_NUM_BANDS][AR5K_MAX_RATES];
> - =C2=A0 =C2=A0 =C2=A0 u8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_R=
ATES];
> + =C2=A0 =C2=A0 =C2=A0 s8 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rate_idx[IEEE80211_NUM_BANDS][AR5K_MAX_R=
ATES];
> =C2=A0 =C2=A0 =C2=A0 =C2=A0enum nl80211_iftype =C2=A0 =C2=A0 opmode;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ath5k_hw =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 *ah; =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Atheros HW */
>
> --
> 1.6.0.6
>

Another thought...

According to docs the rate field is only valid if more flag is clear
(we have the last descriptor) and only if the receive ok flag is set
or both receive ok and phy error flags are cleared. We never do such
checks so we might actually try to process this field when we already
know we shouldn't...

Also the following rate codes are reserved (except XR codes that we
already know):

0x00
0x04 -> the short preamble flag
0x05
0x10 - 0x17
0x1f

and i don't believe i've ever seen them, so we can warn on them too
and print something like "Reserved rate code: %x", also it would be
nice to warn on XR rates (1,2,3,6,7) in case we want to debug this in
the future.


--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
