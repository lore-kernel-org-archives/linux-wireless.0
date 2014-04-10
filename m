Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:40413 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934688AbaDJHBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 03:01:14 -0400
Message-ID: <53464190.1030202@meshcoding.com> (sfid-20140410_090117_572627_70B12412)
Date: Thu, 10 Apr 2014 09:00:32 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
CC: stefan.pietsch@lsexperts.de,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2/2] cfg80211: ignore invalid BSSIDs when looking for
 BSSes
References: <1397075965-2684-1-git-send-email-johannes@sipsolutions.net> <1397075965-2684-2-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1397075965-2684-2-git-send-email-johannes@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IVA29B9lMCrER6MAuqrbEiUEsKCnre7JS"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IVA29B9lMCrER6MAuqrbEiUEsKCnre7JS
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 09/04/14 22:39, Johannes Berg wrote:
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 7d09a712cb1f..746c56ebd66c 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -540,6 +540,8 @@ struct cfg80211_bss *cfg80211_get_bss(struct wiphy =
*wiphy,
>  			continue;
>  		if (channel && bss->pub.channel !=3D channel)
>  			continue;
> +		if (!is_valid_ether_addr(bss->pub.bssid))
> +			continue;

Wouldn't it be better to prevent such entry to end up in the bss list at
all? (i.e. filtering during the scan?)


Cheers,


--=20
Antonio Quartulli


--IVA29B9lMCrER6MAuqrbEiUEsKCnre7JS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTRkGZAAoJEEKTMo6mOh1VJLEP/3orC8tcVDulhfkXzV9Yspdh
GS3T4gitmeiBB1XULHOgPqF1dAiOkM9kdZZdwppY/yzSyjhUK1yjPSsXJ+bfbkMh
wVa2BqUaKH6qDUW2rh6RWFWUc7obKwL1H0C/gIaQOu9im+TYJQjjEtxlaVrgjcHh
buXVtrW6w1j2fh5O+16nc3ESyZGfvrkTcLtbHurwFC3p3LMCjiuoZXichvyNO7Hz
zJKNmlAaZejRx+2LD4CobqvTIIR1Idszd6jdkvs5d1JpYLB6AuDHExT7jnowXil9
ExHet1WBIyADjnDJ3SFWrdt3vfNtwbVp+xivtsHl0C/SRMzybD+FHwC9EizLtDyB
gRw1y/7ZjIkRR7r593Q+wCSkAKaABAGMnAVLsaOslRoidTDsHCnDc/EaDoykoorl
T+TFziypUJC3j1aQXioNp+uhtRK/a2vjcrZq0fORDR6EgpyU+iumV2Yp+3c8HUnZ
kOdS11GzyDs7+T3T3AUpk37OFedjnfOxmO4Y+mJO++XaMcex5qYV2gAgOZeiU0Cr
+D4i1HUnkW35Rbag7PUIClKt5DEeKIxokT3KFmhsXRmUxXE6gWCbgPkdIcrIFC+U
XxYrtyWZ0QYaVW3Jp9rlA7SXr5fjfM0PZXLOuAIK/mG5uswOLHGPZI4FTYvabO5O
ULiaQRjcWpx4hPzGZsQc
=I3/S
-----END PGP SIGNATURE-----

--IVA29B9lMCrER6MAuqrbEiUEsKCnre7JS--
