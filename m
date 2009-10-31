Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41005 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZJaI4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 04:56:09 -0400
Subject: Re: ieee80211_tx_status: headroom too small
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Nikolai ZHUBR <zhubr@mail.ru>, linux-wireless@vger.kernel.org
In-Reply-To: <200910310951.30016.IvDoorn@gmail.com>
References: <1094614475.20091030230028@mail.ru>
	 <7111590175.20091031005644@mail.ru>
	 <1256967967.3555.71.camel@johannes.local>
	 <200910310951.30016.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IIfdre/l0wvo7z5MElmA"
Date: Sat, 31 Oct 2009 09:56:10 +0100
Message-ID: <1256979370.3555.91.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IIfdre/l0wvo7z5MElmA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-10-31 at 09:51 +0100, Ivo van Doorn wrote:

> > Ok. I looked at the problem and it's a very odd problem -- mac80211
> > should always reserve enough headroom in buffers it passes to the
> > driver. Does rt61pci somehow realloc frames?
>=20
> It does use skb_push. but will/should always stay within the limits
> of rt2x00dev->hw->extra_tx_headroom. Although I just realize there
> might be a situation where it needs to align the frame to a 4-byte bounda=
ry,
> it could exceed that amount. :(

extra_tx_headroom is set to max_t(driver, mac80211) so that there's
always some headroom. This doesn't take into account alignment though.
Should we simply add 2 to that value?

johannes

--=-IIfdre/l0wvo7z5MElmA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK6/unAAoJEODzc/N7+QmagDUP/3q85+WV/UPB86mKdNIIy17+
lbiO0lplxH1PUpnwM5Uq7CJAYyxFfleHaPtqY234jkly8fOgfZVpA4S8hyZNj6Gq
HyPsNdXS2GTnukyZ01unYIQJTqBgE8iesCNWjTc4s7vhGTbx/34gBGuPNVckW94G
n7JGsV9fZ2u0OV8ht79gVTl1jZHzO+/VjuUqcWY6wkwlhEDZKAEiIV4qxK+IrNZt
BQk9Qi5GHBlac5h3DvrGZRpaLyVXkhcQcrtvLwF+vrbSUrn285Ibg3Da0JfBFZJE
up7mttOy7GixphB+AlkJ07QGknX8VRkCLEZba8fKuTvezLdQk3VFvlhNL6mkH2bp
5XJdVt+T5slK8DDtm3ZQFlMn2j1LK0zxy1qmt8himC12E/Gz73v+Es3orxWP44zK
FdedeUEoeJTeACUdYA8/dmmPJBKA61C1B2UMliLrhcCdFg8WuSYtjdsqq1Rf2cTT
AkFOOuOiWxoD2MKsx1s95PI/XEg/HJZKKUmeFAkLC3GmRrRuYrHaKrvoStIebi8/
IeCgycfscCpDMmf3UTEfiRcwB2hXowokGoFVfGLMcuYbN9jMiPJP7n/YkClkAajD
IdOtDK1xkQF/uXuYJe3NkVX42RCjTYJU2qhYmteV8MNSfEqZN0+hGltVnjo+YWPj
dgxVLcPSce85Vr9VdRvP
=yS51
-----END PGP SIGNATURE-----

--=-IIfdre/l0wvo7z5MElmA--

