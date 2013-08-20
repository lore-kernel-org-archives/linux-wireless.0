Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62260 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3HTJBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 05:01:46 -0400
Message-ID: <52133070.2050301@blackshift.org> (sfid-20130820_110150_178066_94A39D97)
Date: Tue, 20 Aug 2013 11:01:36 +0200
From: Marc Kleine-Budde <mkl@blackshift.org>
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: linux-wireless@vger.kernel.org, linux@rempel-privat.de,
	ath9k-devel@lists.ath9k.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH v2] ath9k_htc: Restore skb headroom when returning skb
 to mac80211
References: <1376681980-27831-1-git-send-email-mkl@pengutronix.de>
In-Reply-To: <1376681980-27831-1-git-send-email-mkl@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6pWaPnNq6wlUIPmR6MwUuvAuOfwSlauvK"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6pWaPnNq6wlUIPmR6MwUuvAuOfwSlauvK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/16/2013 09:39 PM, Marc Kleine-Budde wrote:
> From: Helmut Schaa <helmut.schaa@googlemail.com>
>=20
> ath9k_htc adds padding between the 802.11 header and the payload during=

> TX by moving the header. When handing the frame back to mac80211 for TX=

> status handling the header is not moved back into its original position=
=2E
> This can result in a too small skb headroom when entering ath9k_htc
> again (due to a soft retransmission for example) causing an
> skb_under_panic oops.
>=20
> Fix this by moving the 802.11 header back into its original position
> before returning the frame to mac80211 as other drivers like rt2x00
> or ath5k do.
>=20
> Reported-by: Marc Kleine-Budde <mkl@blackshift.org>
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> Tested-by: Marc Kleine-Budde <mkl@blackshift.org>
> Signed-off-by: Marc Kleine-Budde <mkl@blackshift.org>
> ---
> Hello Helmut,
>=20
> I've change the patch a bit, I've used ieee80211_get_hdrlen_from_skb() =
instead
> of open coding it.
>=20
> Tested in ARMv5 with USB device
>   "ID 0cf3:7015 Atheros Communications, Inc. TP-Link TL-WN821N v3 802.1=
1n [Atheros AR7010+AR9287]"
> for four weeks. Without that patch the kernel oopes after about one wee=
k.
>=20
> I think this is a candidate for stable, can you add stable to Cc?

ping

Marc


--6pWaPnNq6wlUIPmR6MwUuvAuOfwSlauvK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Icedove - http://www.enigmail.net/

iQIbBAEBAgAGBQJSEzBwAAoJECte4hHFiupUPBcP+Pl+8x4OwEXPh20MbZhNdldE
9AHXLGRhPPpDl9BxBi1bVazxnhX89OCKEnWdzuicpP/M3YV7D4AJKBILl64xD3rb
zVKDRjfQ5Yo5yDXbB162tvGDSvgW451oEwkUoH7LQlYtcPMZ4qE6+aWqoxALpGCR
VK94L0LPWrpZ+EdSRbf8ylccyzBEc3SxcTyYZUxhzRUpfkejT7I/DCeW1YAlbKMi
EHou5RoIVZ3ViQp2krtz+C+4e4JEa9J+1+7fs4eV3RluCROJOtOd+fmT8DutK6S2
z9s6ga2/BCHKhi7jkrLKUt39wsglY4Fi7IBHBojTmPtOHP1jX3F4PPod+x1+h7fE
HLLfA/zGHYruTKGYzyh89S8Sp7uxp/gAHcaTRU4eBT536ZxjbarhUlQzUMhHQpzX
PMuzdWZRrX3oM0oxEfKaqtHyE4xatMoflJes7FjPn+nlrX26kk+tevLDZt0XABru
wp3Jr5VLNZ8i97a5bTTl7Aey2Q8RcVl6O2VdNe0CMbWv8uW0Q7/g2OIsXdg36Bjt
NbKqDh128O8toy84Dz2qLM+gXh15CcEmPQJCaeUvkmgSgmR4o+h/VgsFwtY5XfX+
JMHAHlCuqUl134DvahE8SQ4dJrNCeLLVCHm3pD2dS4Sjb+ORUfVelIfEaUYv0Y3P
/nyxOB3fGbEku6gEsCo=
=HZQn
-----END PGP SIGNATURE-----

--6pWaPnNq6wlUIPmR6MwUuvAuOfwSlauvK--
