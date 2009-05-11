Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZEKOJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 10:09:32 -0400
Subject: Re: [PATCH] cfg80211: implement wext key handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	Samuel Ortiz <sameo@linux.intel.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242049846.28322.12.camel@localhost.localdomain>
References: <1242042898.18637.0.camel@johannes.local>
	 <1242049846.28322.12.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1Wg3ZtwM4c2J05TzYGiK"
Date: Mon, 11 May 2009 16:09:22 +0200
Message-Id: <1242050962.29777.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1Wg3ZtwM4c2J05TzYGiK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 09:50 -0400, Dan Williams wrote:

> I modified the meaning of RESTRICTED/OPEN a few years ago to control the
> WEP auth mode, for a few reasons...  First, some fullmac drivers already
> used it to mean WEP auth mode.  Second, there was no other mechanism to
> control WEP auth mode at the time, and there were a lot of Shared Key
> installations around.  Third, WE-18/WPA was nowhere near being landed,
> and it was only supported by one driver (hostap), and it was the only
> thing that would plausibly support WEP auth mode via SIWAUTH.  Fourth,
> only hostap and maybe airo really implemented the refuse-non-encoded
> anyway.

But didn't update the header file ;)

> TBH, SK is nice because it tells you that the WEP key is wrong
> *immediately*, and the only reason NM doesn't use SK by default (and
> then fall back to OS) like the original Mac Airport drivers did is that
> WEXT simply cannot return reliable association error information.

Hah. Well, we could have that now, but I suspect SK is no longer common
enough to put a lot of work into it.

> But in the end, we still need a mechanism with WEXT to be able to set SK
> auth when associating.

We still have that, with WE18, in IW_AUTH_80211_AUTH_ALG. And mac80211
never actually supported _setting_ the WEP auth mechanism with
RESTRICTED/OPEN, only _getting_ that information.

johannes


--=-1Wg3ZtwM4c2J05TzYGiK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCDGOAAoJEODzc/N7+QmaBywQAMfF/rLFrQqzafoY3mkKakhn
4nVSQ2beABb/xv/Ys6iIBlHbZW9bss5Mz5NHT1dc3FmvPcQz6VwagqilPrUX6fwd
nqJA/puB3MFkWZUVtQtHakK6vReG1bc+sB/aO03ARKMlHgn6YQs+8TID+xMWOJ6j
WCRcgfW6/WLm5K8PLqpQ0gWpT+1yWYo89qjUvwrTkI8ICGxQz7Q6KmC6xZDhC7qA
IntGiIrML5gGSb/buzOGropHW/Q/YS59EwbiUx721vP6aEnEAPnz1s09b/bctl8e
jTiNlAq+HNwYt0eUcn9VBXmtm25iuZX0NTmn5RP1zzI3CRgWfw5gSdqM9bNWC04G
dtCuzPOYBaMAvGB/vTjER5KkSRe+DarfyhoIQuEqp2M+VoAVkbIPTu/pTMZJwlpV
xokIPzkXiD0MM1FDsqkBsYzXWf/P9pqiRgvQUMh8QAV0GD6UOEflpwz4TvPEayox
ZqvQR9VoeB1JbOjnPFYeq+QTLTzgqB3vVBvqN3/D3V/kfMOq78rgA5XFuYAaXkSd
defIk9x6MbRjRxK3F5Vdr2YCMVwAOG7FOazBud0iGqaRmdVBEDwhJxdcdMzuklCv
q4dhPC79vdfmSZ2oDG+v/cDs3+zO055GfHNiRF0QZcex5ErTyYFm6mFWEFJACgCf
VFuamm2I6wi+O5Qn8fcW
=9i53
-----END PGP SIGNATURE-----

--=-1Wg3ZtwM4c2J05TzYGiK--

