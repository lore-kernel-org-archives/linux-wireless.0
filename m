Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbZKNJXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2009 04:23:24 -0500
Subject: Re: [PATCH] mac80211: reduce the amount of unnecessary traffic on
 cooked monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4AFE1612.5070805@openwrt.org>
References: <4AFE1612.5070805@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VivDukhgfTkN0JG4MGrR"
Date: Sat, 14 Nov 2009 10:23:27 +0100
Message-ID: <1258190607.6167.33.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VivDukhgfTkN0JG4MGrR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-14 at 03:29 +0100, Felix Fietkau wrote:
> In order to handle association and authentication in AP mode,
> hostapd needs access to the tx status info of its own frames
> through a cooked monitor interface. Without this patch the
> cooked monitor interfaces also passed on tx status information
> for packets from other virtual interfaces. This creates a
> significant performance issue on embedded system. Hostapd
> tries to work around this by installing a Linux Socket Filter
> that only captures the frames it's interested in, however
> data duplication and socket filter matching still uses up
> enough CPU cycles to be very noticeable on small systems.
> This patch ensures that tx status information of non-injected
> frames does not make it to cooked monitor interfaces.
>=20
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

> +			if ((sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) &&
> +			    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
> +			    (type =3D=3D IEEE80211_FTYPE_DATA))
> +				continue;
> +

This patch also breaks IEEE 802.11 compliance. :)

johannes

--=-VivDukhgfTkN0JG4MGrR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/ncLAAoJEODzc/N7+Qma3VgQAL6ayIrh2DaH0nd+DrvOCQg0
mni3RY5rdMETZzNQnfZFukYMFc8kg4SjlGfybSeHtETHyVondUm07Sq+jtvBjJvy
xJEhtFdrRRmF9lTPwOHlA2A8bZW88hJJmgOAZaCoZ9dhfV59aBt1oK6G5Dr+hCXG
hDfVFLrYDtMWAMlNLpJfndT0DnTFJwHMOCZZl+LZ2Px7xFdkXGQ/iu7W9xklCp5E
7L9QpSMa0Zs0ZODuwvWnb4+QxRCTazTEV/ZIQwKyLkFAMTU+gilJneAc7gdAE2JH
AXJh+fEmp90LCFhNRprZ5eoZytS5FPFyFfGH3vXZN4AticUWJOSFSyViex+I8Tf7
w8CUl97iuKd5inmiiJImszzKdTx1fOiyg/7z5HyDnqkbArTXkNQV73b/RfuZSKEN
HSuW8OyQOwcVRPlqSAjyErp2ts5zFRq+qTsm7FL82MZt7v47HpGVAIy/DBgwTBB2
IW6uvo7zCmcylXYg6D8oGxNEF/9ZnPViPb4n45a6aC08Q+NrTOVkkKa8jhC4wjdV
RshJg5ZeVXhuN3FW77vPSqTp9JK2bjm8jJPk6bpG6dDSlmyhTLuhR+zAeAOzl07w
10tCVNZRzhVJkVTLFY5r1hYhXJWI/YzPPmodwiDGIA35C8YTwaxL421utBlwx55b
sgH+0mj74UIypnquLUof
=dB7k
-----END PGP SIGNATURE-----

--=-VivDukhgfTkN0JG4MGrR--

