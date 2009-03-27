Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:63758 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbZC0OEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 10:04:39 -0400
Received: by ewy9 with SMTP id 9so1067961ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 07:04:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238126849.20768.12.camel@mj>
References: <1238020625.15025.15.camel@mj>
	 <40f31dec0903251847p260446bfi22a1b4c587dc41cc@mail.gmail.com>
	 <1238126849.20768.12.camel@mj>
Date: Fri, 27 Mar 2009 16:04:36 +0200
Message-ID: <40f31dec0903270704l52887eabw58ec893e3f3b7701@mail.gmail.com> (sfid-20090327_150442_666606_510EE9D3)
Subject: Re: [ath5k-devel] [BISECTED] AR5414 fails to scan after "ath5k:
	Update reset code"
From: Nick Kossifidis <mickflemm@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/27 Pavel Roskin <proski@gnu.org>:
> On Thu, 2009-03-26 at 03:47 +0200, Nick Kossifidis wrote:
>
>> That's weird, I've tested this with my 5413 and it works just fine. =
It
>> seems that 5424 (pci-e version of 5413) still has some issues. Have
>> you tried monitor mode ?
>
> I have reduced the patch to the clock setting in ath5k_hw_nic_wakeup(=
).
>
> Testing with madwifi-free shows that the clock register for 802.11a
> channels for RF5413 should be 0x04. =C2=A0ath5k uses 0x44
> (AR5K_PHY_PLL_40MHZ_5413 | AR5K_PHY_PLL_RF5112). =C2=A0The value befo=
re the
> patch that broke scanning was 0xea (AR5K_PHY_PLL_40MHZ |
> AR5K_PHY_PLL_RF5112).
>
> With the following patch, scanning works for both 2.4 GHz and 5 GHz
> bands. =C2=A0Please test with your hardware. =C2=A0If it works, I'll =
submit it.
>
>
> ath5k: fix scanning in AR2424
>
> AR5K_PHY_PLL_40MHZ_5413 shouldn't be ORed with AR5K_PHY_MODE_RAD_RF51=
12.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>
> =C2=A0drivers/net/wireless/ath5k/reset.c | =C2=A0 =C2=A02 +-
> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
>
>
> diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireles=
s/ath5k/reset.c
> index 7a17d31..faede82 100644
> --- a/drivers/net/wireless/ath5k/reset.c
> +++ b/drivers/net/wireless/ath5k/reset.c
> @@ -359,7 +359,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int =
flags, bool initial)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0mode |=3D AR5K_PHY_MODE_FREQ_5GHZ;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (ah->ah_radio =3D=3D AR5K_RF5413)
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 clock |=3D AR5K_PHY_PLL_40MHZ_5413;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 clock =3D AR5K_PHY_PLL_40MHZ_5413;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0clock |=3D AR5K_PHY_PLL_40MHZ=
;
>
>
>
> --
> Regards,
> Pavel Roskin
>

Nice catch ;-)

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
