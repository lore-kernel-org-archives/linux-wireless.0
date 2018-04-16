Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:33752 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750884AbeDPNEu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:04:50 -0400
From: Sven Eckelmann <sven@narfation.org>
To: miaoqing@codeaurora.org
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, sssa@qti.qualcomm.com,
        simon.wunderlich@openmesh.com
Subject: Re: [PATCH 2/2] ath9k: fix tx99 bus error
Date: Mon, 16 Apr 2018 14:57:20 +0200
Message-ID: <5841149.Pfrk1JVkns@bentobox> (sfid-20180416_150454_747137_93E2588D)
In-Reply-To: <1497921220-12940-2-git-send-email-miaoqing@codeaurora.org>
References: <1497921220-12940-1-git-send-email-miaoqing@codeaurora.org> <1497921220-12940-2-git-send-email-miaoqing@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2230415.cd2rnGMftr"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2230415.cd2rnGMftr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Dienstag, 20. Juni 2017 09:13:40 CEST miaoqing@codeaurora.org wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> The hard coded register 0x9864 and 0x9924 are invalid
> for ar9300 chips.
[...]
> -	REG_SET_BIT(ah, 0x9864, 0x7f000);
> -	REG_SET_BIT(ah, 0x9924, 0x7f00fe);

Sorry that this messages comes so later after the patch was accepted. But what 
were these things expected to do? My guess is that 0x9864 is AR_PHY_CCA and 
the other one is something else (AR_PHY_TIMING5?). But yes, these would be ar9002
and not AR9003.

What are the problems that we would expect when the CCA threshold and the CYCPWR 
threshold are no longer be set to the highest possible value? Are we now expecting 
that the device is not transmitting at 99% when it sees other signals?

Btw. why are you writing that ar9300 chips don't have this? It looks to me 
like the original code was taken from QCA's 9300 code [1]. Was it always broken
in the AR9300 hal and how was it now fixed with with the newer HALs?

Could it be that newer chips just have it mapped to a different location? AGC 
on the 9300 seems to be at 0x9e00 and maybe the cca register should have been 
0x9e1c (AR_PHY_CCA_0) and should be set to AR_PHY_CCA_THRESH62? And there is 
also a AR_PHY_TIMING5 (0x9810) which might have to be set to 
AR_PHY_TIMING5_CYCPWR_THR1 | AR_PHY_TIMING5_CYCPWR_THR1A. Of course, I have 
absolutely no idea whether these registers actually control the 
same thing and whether the settings are correct.

Kind regards,
	Sven

[1] https://github.com/freebsd/freebsd/blob/386ddae58459341ec567604707805814a2128a57/sys/contrib/dev/ath/ath_hal/ar9300/ar9300_tx99_tgt.c#L502

--nextPart2230415.cd2rnGMftr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlrUnbAACgkQXYcKB8Em
e0azeA//TgIKnHF90emJubcVeZG7Fci1K5o76Y/GAL7L82ryQQURx92CGZg13Y4z
T7NJNVLQZxnshu4nqqC5UxDPvL9dgxSUlz7Xf83HreWDCJd/HXXx2yQtDL5ZD9KO
1+TezyEx0SGywstDFVzU1w37lTBixN41q9ucEDXuQvvtzc91J0o1mfPKXvw+v/pc
97x5UWFYWhZGjcqjzl3LiCjc3Zl5+07OGM1ltS624xxLYMvK+UFAYdNnd1xpa5e/
W97f5A6Jx+aRl2U0svWXP+ScaHfHmXgNMbRC1gDW+M1bYO83eC3j7CuCLLDlr3ER
7OxKFGnPAZVMO+odHedydgUAR3zWWEELOFPLz3AWFPzW9mzOfkwywoJFD+esb52m
ahxtG7X/y/Bbhxg7szwzqu/kjkuRlPJz859A+8J7s/oO/txIae0/TNqXmNqtJXVA
bqiOoN5Wk+h1qPiWdEkgOh/vxPydDCaw4SSGe5Y4/jOQ4TbAWv3XdrvAYF19wjyL
yJtK0pdGZcbjgtg33W/MTqO/9BaoLyoLFhl440OQZbn80v53/HN+etI5Y6fedoae
3INgHVW5eifSriwTXTYI+F9vOqO/j/ux0lpVG/f89jVP5sBJNT1n8pAO8Ysam8PW
EmokUZYbY1xPAQysRCRc4ZDPRGeza5nurwBddwZXZRSCbXWpb24=
=/q42
-----END PGP SIGNATURE-----

--nextPart2230415.cd2rnGMftr--
