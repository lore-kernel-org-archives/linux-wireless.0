Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:46873 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713AbYJ0Sg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 14:36:28 -0400
From: Nils <linuxuser@knabber.homelinux.net>
To: Elias Oltmanns <eo@nebensachen.de>,
	"Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
Date: Mon, 27 Oct 2008 19:36:17 +0100
References: <87prlr9mna.fsf@denkblock.local> <40f31dec0810251621l3d720a69mf21b5253e9135010@mail.gmail.com> <87abcrtfa8.fsf@denkblock.local>
In-Reply-To: <87abcrtfa8.fsf@denkblock.local>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810271936.17807.linuxuser@knabber.homelinux.net> (sfid-20081027_193643_194363_FA00E13A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> [Bcc'ing Nils who has reported similar issues with ath5k on 2.6.27.
> Nils, can you perhaps test my patch below and report back? ]

Yes! I test the patch with 2.6.27.4 and everything works fine.

"iwlist ath0 scan" shows all wireless LANs at my location and I can connect to 
my accesspoint.

Thanks,
Nils


> "Nick Kossifidis" <mickflemm@gmail.com> wrote:
> > 2008/10/23 Elias Oltmanns <eo@nebensachen.de>:
> >> Take care to handle register 0xa228 exactly as in the HAL released by
> >>
> >> Atheros. This change is required to make ath5k work again on my system
> >> since commit 2203d6be (ath5k: Misc hw_reset updates), thus fixing a
> >> regression in 2.6.27 and therefore hopefully eligible for inclusion into
> >> a stable release.
> >>
> >> Cc: stable <stable@kernel.org>
> >> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> >> ---
> >> Applies to 2.6.27. Please let me know if I should do something
> >> differently and resend.
> >>
> >>  drivers/net/wireless/ath5k/hw.c       |    1 +
> >>  drivers/net/wireless/ath5k/initvals.c |    2 ++
> >>  2 files changed, 3 insertions(+), 0 deletions(-)
> >
> > Current code works fine on my CM6 (AR5212 + RF5111) and i see nothing
> > like
> >
> > data |= 0x00000800
> >
> > on the HAL Atheros released
>
> Let me quote from legacy-hal:
>
> ar5212/ar5212_reset.c:
> 373:		OS_REG_RMW_FIELD(ah, AR_PHY_DAG_CTRLCCK,
> 374:			AR_PHY_DAG_CTRLCCK_RSSI_THR, 2);
>
> ah_internal.h:
> 598:	#define OS_REG_RMW_FIELD(_a, _r, _f, _v) \
> 599:	    OS_REG_WRITE(_a, _r, \
> 600:	        (OS_REG_READ(_a, _r) &~ _f) | (((_v) << _f##_S) & _f))
>
> Please note the last argument to OS_REG_RMW_FIELD() which is 2 in this
> case. Unless I've made a mistake, this translates into the
>
> data |= 0x00000800;
>
> in my patch.
>
> There definitely is no way for me to connect to an ap (or even get a
> list of aps) with current 2.6.27.4. Perhaps we'll hear something from
> Nils on that matter too.
>
> > Problem is that we are updating 0xa228 (RSSI threshold in this case)
> > for all AR5212 based cards and we are not checking right now for BB
> > revision. These settings according to Atheros HAL are only for BB
> > revisions > 2. I'm going to update reset.c this week hopefully.
> >
> > BTW can you please run latest ath_info on your card ? Let's see what's
> > the rssi threshold stored on EEPROM and how much different is from my
> > card.
>
> Well, I don't see how to get that information from the dump. Please have
> a look for yourself, I'm going to send you my dump by pm.
>
> Since my original email has not appeared on linux-wireless (due to a
> mistake of mine), I'm attaching the patch again, so others can have a
> look at it and, more importantly, Nils can test it.
>
> Regards,
>
> Elias
>
> --------
> From: Elias Oltmanns <eo@nebensachen.de>
> Subject: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111
> in particular
>
> Take care to handle register 0xa228 exactly as in the HAL released by
> Atheros. This change is required to make ath5k work again on my system
> since commit 2203d6be (ath5k: Misc hw_reset updates), thus fixing a
> regression in 2.6.27 and therefore hopefully eligible for inclusion into
> a stable release.
>
> Cc: stable <stable@kernel.org>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> ---
>
>  drivers/net/wireless/ath5k/hw.c       |    1 +
>  drivers/net/wireless/ath5k/initvals.c |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/hw.c
> b/drivers/net/wireless/ath5k/hw.c index ad1a5b4..f1a7f71 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -858,6 +858,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum
> ieee80211_if_types op_mode,
>
>  			data = ath5k_hw_reg_read(ah, 0xa228);
>  			data &= 0xfffe03ff;
> +			data |= 0x00000800;
>  			ath5k_hw_reg_write(ah, data, 0xa228);
>  			data = 0;
>
> diff --git a/drivers/net/wireless/ath5k/initvals.c
> b/drivers/net/wireless/ath5k/initvals.c index 2806b21..cf7ebd1 100644
> --- a/drivers/net/wireless/ath5k/initvals.c
> +++ b/drivers/net/wireless/ath5k/initvals.c
> @@ -810,6 +810,8 @@ static const struct ath5k_ini_mode
> ar5212_rf5111_ini_mode_end[] = { { 0x00000000, 0x00000000, 0x00000000,
> 0x00000000, 0x00000000 } }, { AR5K_PHY(642),
>  		{ 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
> +	{ 0xa228,
> +		{ 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5 } },
>  	{ 0xa23c,
>  		{ 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af } },
>  };
