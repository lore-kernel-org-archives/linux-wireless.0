Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:36028 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbZC2XLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 19:11:08 -0400
Received: by ewy9 with SMTP id 9so1839116ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 16:11:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090327214727.28989.90735.stgit@mj.roinet.com>
References: <20090327214727.28989.90735.stgit@mj.roinet.com>
Date: Mon, 30 Mar 2009 02:11:04 +0300
Message-ID: <40f31dec0903291611g3c783032qd84881148de6b4bb@mail.gmail.com> (sfid-20090330_011119_634049_0F62A85E)
Subject: Re: [PATCH] ath5k: fix scanning in AR2424
From: Nick Kossifidis <mickflemm@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/27 Pavel Roskin <proski@gnu.org>:
> AR5K_PHY_PLL_40MHZ_5413 should not be ORed with AR5K_PHY_MODE_RAD_RF5=
112
> for 5 GHz channels.
>
> The incorrect PLL value breaks scanning in the countries where 5 GHz
> channels are allowed.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>
> =C2=A0drivers/net/wireless/ath5k/reset.c | =C2=A0 =C2=A02 +-
> =C2=A01 files changed, 1 insertions(+), 1 deletions(-)
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
