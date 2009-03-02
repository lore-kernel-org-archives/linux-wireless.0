Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:37505 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbZCBWoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 17:44:10 -0500
Received: by rv-out-0506.google.com with SMTP id g37so2474171rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 14:44:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090302222948.76770@gmx.net>
References: <20090302222948.76770@gmx.net>
Date: Mon, 2 Mar 2009 17:44:07 -0500
Message-ID: <b6c5339f0903021444m1f139f63p374cf41194ac2b62@mail.gmail.com> (sfid-20090302_234415_120657_83154D35)
Subject: Re: [PATCH] ath5k: Set TSF fix
From: Bob Copeland <me@bobcopeland.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 2, 2009 at 5:29 PM, Alina Friedrichsen <x-alina@gmx.net> wr=
ote:
> The old code doesn't work correctly e.g. on newer chipsets like AR541=
8+AR2122 and AR5416+AR2133.
>
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> diff -urN wireless-testing.orig/drivers/net/wireless/ath5k/pcu.c wire=
less-testing/drivers/net/wireless/ath5k/pcu.c
> --- wireless-testing.orig/drivers/net/wireless/ath5k/pcu.c =A0 =A0 =A0=
2009-01-23 22:54:07.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/ath5k/pcu.c =A0 2009-01-24 =
08:47:16.000000000 +0100
> @@ -657,9 +657,8 @@
> =A0{
> =A0 =A0 =A0 =A0ATH5K_TRACE(ah->ah_sc);
>
> - =A0 =A0 =A0 ath5k_hw_reg_write(ah, 0x00000000, AR5K_TSF_L32);
> - =A0 =A0 =A0 ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K=
_TSF_U32);
> =A0 =A0 =A0 =A0ath5k_hw_reg_write(ah, tsf64 & 0xffffffff, AR5K_TSF_L3=
2);
> + =A0 =A0 =A0 ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K=
_TSF_U32);
> =A0}

It's in the original so I guess it's ok, but it'd be nice to have a ver=
sion
without the unnecessary "& 0xffffffff" part.  Also can you use the -p o=
ption
to diff in the future?

Otherwise,

Acked-by: Bob Copeland <me@bobcopeland.com>

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
