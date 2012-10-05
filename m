Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:53409 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab2JENHO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 09:07:14 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL on AR9003
Date: Fri, 05 Oct 2012 15:07:10 +0200
Message-ID: <2475573.rN7d8lielt@bentobox> (sfid-20121005_150718_513161_A687869B)
In-Reply-To: <506ED3D4.7050107@openwrt.org>
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <2629427.e28b8DS3gI@bentobox> <506ED3D4.7050107@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2234550.NCOu3RxbZZ"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart2234550.NCOu3RxbZZ
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Friday 05 October 2012 14:34:28 Felix Fietkau wrote:
> On 2012-10-05 1:08 PM, Sven Eckelmann wrote:
[...]
> Please try this patch to see if it gets rid of these interrupts:
> ---
> --- a/drivers/net/wireless/ath/ath9k/ani.c
> +++ b/drivers/net/wireless/ath/ath9k/ani.c
> @@ -307,7 +307,8 @@ void ath9k_ani_reset(struct ath_hw *ah,
>  		if (IS_CHAN_2GHZ(chan)) {
>  			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
>  					    ATH9K_ANI_FIRSTEP_LEVEL);
> -			if (AR_SREV_9300_20_OR_LATER(ah))
> +			if (AR_SREV_9300_20_OR_LATER(ah) &&
> +			    ah->caps.rx_chainmask != 1)
>  				ah->ani_function |= ATH9K_ANI_MRC_CCK;
>  		} else
>  			ah->ani_function = 0;

Looks partially good. At least this patch fixed parts my friday :D

I have more similar bugs, but at least this one is related to a bandwidth 
problem which I also wanted to check today. But it didn't fix _this_ invalid 
register access on the client device (but I don't see it anymore on the AP 
device).

Kind regards,
	Sven
--nextPart2234550.NCOu3RxbZZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQbtt+AAoJEF2HCgfBJntGmVoQAJoWUSMVIZO10651jCpgM1fW
bzj9aEDWFK70jocY4Sp6J3UCvrJ7X31AvVnRYI8MAu/asUkd+z7okvT1PHDPY/M3
xBwsaTAcMmTzKIDJC6sxNZh3fxuHAJkEY5Uc5g3vZFZp4UrOa/axTVYK6Mxn1us5
vMwZM0RamRZonOzKmDJeQvL1GKSlG2pzRf7sr+/9GFDfF9u/KIaewNjkSZTWQ+Yo
tt0rgmPd8rcR3CHB3aOuQ1gpvhu+NQRmniQNv7Qt60Tgv0Tmu8eKov/0LcXvVFPs
cxVP0B/ZoMT0AWJdtVqezACVVXGWSLDEWya7YIyD6Ft96VWjwDFmRB2H1+4D+BeN
u49Fvgz2uTHWufShNUJy8vW8ajieqn6hb2kmp+U8EN8Qm4sUWgd84f6u0VIZwoeU
U52m9lvgVxv3t+eRCSC1DEY6XBVcwaXvao/mes7JPL/mmOl77gw/mRwjc3U/sEOY
hjcYJJpL+E6OWz/ba/bLEmwefK89OlsO2PPoSw9PljAxF6fH1y2NlNy9Lq60fS3F
SFSrpnkVf3o3aCU+zGyrklGbQyxEI98QweQKdCXvgRUs+7uyH/aUq36FAieyudRJ
WB6Rvm4B86X5HnOkAy059XxksnoKPf/GGSeoqxp/SFLIXk/7n6rsBorsmna/S1LQ
+A7vNBNxCL34ds9P4UvQ
=aHJW
-----END PGP SIGNATURE-----

--nextPart2234550.NCOu3RxbZZ--

