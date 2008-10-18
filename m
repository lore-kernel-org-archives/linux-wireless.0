Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYJRMV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 08:21:56 -0400
Subject: Re: [PATCH 2/3 v2] p54: put broadcast frames into the right queues
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
In-Reply-To: <200810170354.25392.chunkeey@web.de>
References: <200810170115.38317.chunkeey@web.de>
	 <200810170354.25392.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lfOdW0o0lamFl4xIuqND"
Date: Sat, 18 Oct 2008 14:21:51 +0200
Message-Id: <1224332511.6324.3.camel@johannes.berg> (sfid-20081018_142204_465351_A290278C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lfOdW0o0lamFl4xIuqND
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-17 at 03:54 +0200, Christian Lamparter wrote:

> +	case NL80211_IFTYPE_AP:
> +		if (is_multicast_ether_addr(hdr->addr1)) {
> +			*aid =3D 0;
> +			*queue =3D 3;
> +			return 0;
> +		}

Are you sure this is right? I think you should use the mac80211 flag
IEEE80211_TX_CTL_SEND_AFTER_DTIM maybe?

Also, there's a flag for IEEE80211_TX_CTL_ASSIGN_SEQ (inverted in
firmware) that you should use.

johannes

--=-lfOdW0o0lamFl4xIuqND
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI+dTbAAoJEKVg1VMiehFYO0oP/iq905l3Q85zl4VbEQt2AD0d
Q6bxNwqtzf1LOkqmhGN00rK/6WY7HYO4m48rrPCmj7eg/u4x5T3gB+ipuQ12wrH9
t7BLOIoZ40EFLul/AI7ePqO75lG20UXNHLnWARErUtRmTUqZkfTT+AsHJ4SfS3ib
/vqMk2l6bXK4xS4MGjZ2IuowWF4AieWTmHkvORE6SvoffW5DU2SPB4mo/vPxdgOt
8lBVgWZdRfbuCbfh6l5NstANEQo78021Z+Hq5qjJG4luqQ+wrRGa8ASOXj6oYf7C
yQjPvHtIkGuGYqJyPo1LeK9euRYQ6yTZGaV3Mvw8AAYWNihlGFv8+U1VsJcFx7T/
hpsoFhCdHgWdjnz/RtO1CzsamalU4elmAYnc1woT+Jh0PYeoj+pcbeEq+hkQ4l7H
CoVl42OQZsfYvG5ogRjt1FejTA58vRvnWbdKiU86vg3unnguqcR4TZa8vbQD0+2y
Sa2U0SzdwglvZ7VHaM8JPXrxwNMfWEJZl0v4NK2I1ACAP2q1ZEcjo03Fh8YRmYCg
RnK/MhdZQE5ifmQCQx7BDk2d5LYUv5CX/B79HDfMVIGVtF96xoRXXuImgvrAaUIe
PTifBge9lGSkYYBOzEeh5UWcp5RDblx6ruhWOQ2lp4xCekGqAZuFsj6K1tgCgEGA
d5CBYHawrGiSRiCxIUrB
=cNLH
-----END PGP SIGNATURE-----

--=-lfOdW0o0lamFl4xIuqND--

