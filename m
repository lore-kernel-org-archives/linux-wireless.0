Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:22675 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZDUNOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 09:14:42 -0400
Received: by mu-out-0910.google.com with SMTP id g7so908555muf.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Apr 2009 06:14:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090419144640.GC866@hash.localnet>
References: <20090416002220.GA4138@makis> <20090419144640.GC866@hash.localnet>
Date: Tue, 21 Apr 2009 16:14:39 +0300
Message-ID: <40f31dec0904210614se4c3e3asd47daa2109c4a07b@mail.gmail.com> (sfid-20090421_151446_692929_0BBBD451)
Subject: Re: [ath5k-devel] [PATCH 1/7] ath5k: Allow user/driver to set txpower
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/19 Bob Copeland <me@bobcopeland.com>:
> On Thu, Apr 16, 2009 at 03:22:20AM +0300, Nick Kossifidis wrote:
>> =C2=A0* Now that we have regulatory control enable the driver to set=
 txpower on hw
>
> I assume this needs my patch for the CTLs (reproduced below). =C2=A0A=
ny
> objections to it?
>
> From: Bob Copeland <me@bobcopeland.com>
> Subject: [PATCH] ath5k: use ctl settings based on current regdomain
>
> Update ath5k to use the ctl settings for tx power based on current
> regulatory domain.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
> =C2=A0drivers/net/wireless/ath/ath5k/phy.c | =C2=A0 19 +++++++-------=
-----
> =C2=A01 files changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wirel=
ess/ath/ath5k/phy.c
> index 9e2faae..0ecd16f 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1743,8 +1743,6 @@ done:
> =C2=A0* Get the max edge power for this channel if
> =C2=A0* we have such data from EEPROM's Conformance Test
> =C2=A0* Limits (CTL), and limit max power if needed.
> - *
> - * FIXME: Only works for world regulatory domains
> =C2=A0*/
> =C2=A0static void
> =C2=A0ath5k_get_max_ctl_power(struct ath5k_hw *ah,
> @@ -1760,26 +1758,23 @@ ath5k_get_max_ctl_power(struct ath5k_hw *ah,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u8 ctl_idx =3D 0xFF;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0u32 target =3D channel->center_freq;
>
> - =C2=A0 =C2=A0 =C2=A0 /* Find out a CTL for our mode that's not mapp=
ed
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* on a specific reg domain.
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0*
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* TODO: Map our current reg domain to on=
e of the 3 available
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0* reg domain ids so that we can support =
more CTLs. */
> + =C2=A0 =C2=A0 =C2=A0 ctl_mode =3D ath_regd_get_band_ctl(&ah->ah_reg=
ulatory, channel->band);
> +
> =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (channel->hw_value & CHANNEL_MODES)=
 {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case CHANNEL_A:
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode =3D AR5K_=
CTL_11A | AR5K_CTL_NO_REGDOMAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode |=3D AR5K=
_CTL_11A;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case CHANNEL_G:
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode =3D AR5K_=
CTL_11G | AR5K_CTL_NO_REGDOMAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode |=3D AR5K=
_CTL_11G;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case CHANNEL_B:
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode =3D AR5K_=
CTL_11B | AR5K_CTL_NO_REGDOMAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode |=3D AR5K=
_CTL_11B;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case CHANNEL_T:
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode =3D AR5K_=
CTL_TURBO | AR5K_CTL_NO_REGDOMAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode |=3D AR5K=
_CTL_TURBO;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case CHANNEL_TG:
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode =3D AR5K_=
CTL_TURBOG | AR5K_CTL_NO_REGDOMAIN;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ctl_mode |=3D AR5K=
_CTL_TURBOG;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0case CHANNEL_XR:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Fall throug=
h */


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
