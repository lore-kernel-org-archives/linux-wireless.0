Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50468 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbZFCOzQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 10:55:16 -0400
Subject: Re: [PATCH] rfkill: always init poll delayed work
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <4A268DAC.4010805@lwfinger.net>
References: <1244015729.7176.28.camel@johannes.local>
	 <4A268DAC.4010805@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2g9Qqu8lDRB/sXAjW0uq"
Date: Wed, 03 Jun 2009 16:55:13 +0200
Message-Id: <1244040913.4862.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2g9Qqu8lDRB/sXAjW0uq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 09:50 -0500, Larry Finger wrote:

> This patch fixed to kernel BUG_ON, but there are still problems. This
> has been tested with b43.

Thanks.

> 1. A minor one - the radio LED switch never comes on. Module led-class
> is loaded.

Hmm, that's odd, but I linked it to mac80211's radio LED trigger now, I
think. Can you verify that?

> 2. Much more serious - When the radio kill switch is turned off, the
> radio is killed just as expected, but it is not restored when the
> switch is turned on. The only way to restore the radio is to
> rmmod/insmod b43. Similarly, if the module is loaded with the switch
> off, it is not possible to turn the radio on. An unload/load resquence
> is then needed.

I suspected that much. And you can't recover that since you can't set
the interface UP. This is because polling doesn't work while the
interface is set down. As I said previously, I think that's previously
been buggy too, if you did
 1) hard kill
 2) set interface down
 3) hard unkill

then step 3) would not trigger an event to userspace until you set the
interface up again, afaict.

We probably need to bring up the core to poll it, if possible?

johannes

--=-2g9Qqu8lDRB/sXAjW0uq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJo7OAAoJEODzc/N7+Qma4GcP/2ibxuwf69ltHPGLWyIljeqi
Fu0O7DfZ4eufVBSHYVw+wtD8Gtc/wYukHuxzp8Dwd9YyfnHKY2ScbuSs5yL/ky2Z
UVzyhk4EGadBW7vD8LmPfKqz+o8pshTIKymGaJ/frld1iUwDZkIO3ZIpXxIMrf4v
1jVD3/0gOK30Q0CUELkHy7oExoxh6swxfgmOfkikN/hg2KCi/ecM85BTYkBXHJEg
j86IX1H5GrCpIWMm0z6JonMbgOiqT1WjdWWkMsIZBmHsPG8vMjN/grB+Kzxk4U17
QoN1U8YDJrgzbnTTObsV7zrVD5rfCPa03dqyrkGMelz0pDieCG/OiE/B9VhtzMTp
y/AsRd8yX6y+wokYs+NoL6Q1PoQnBM6L/Th/1KMbGnqgnmUuhBVAu+w/c/Tdk8aU
jOz2DPK/TsQTz7szDgeSm1avzHd9MhsFgfM+F1XT8+n1hCIRtPpDtCBBs7X+oLE8
Ohex/tKId3XkffumWPPV9TVbnv6XnseoW1D0BDa37Wk3kPcd0678B+xWVuiSgag+
HmvDXtdODkTI+xWT6aLpcPbw4wqq90lAQEy1zQfOUzAICsXqcoGnMmJZWqv0CtGF
hJ77eUWR575GUOTmKWPAtZE0r6lmRS/tbmS+Kh+ji358Grae20Cr5FOHwIg94+x3
6Z4GfoCUohM+a5y8EoiB
=1ab4
-----END PGP SIGNATURE-----

--=-2g9Qqu8lDRB/sXAjW0uq--

