Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbZBPKUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 05:20:30 -0500
Subject: Re: [PATCH 08/10] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902160211p683bef08g5643ccb787cbf725@mail.gmail.com> (sfid-20090216_111158_948581_8300960E)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-9-git-send-email-lrodriguez@atheros.com>
	 <1234695858.4219.54.camel@johannes.local>
	 <43e72e890902160155j402e887an9c5ea3ca9b9f64f3@mail.gmail.com>
	 <1234778566.4219.120.camel@johannes.local>
	 <43e72e890902160211p683bef08g5643ccb787cbf725@mail.gmail.com>
	 (sfid-20090216_111158_948581_8300960E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-znyCmwaxpJ07lqKX6pFk"
Date: Mon, 16 Feb 2009 11:20:25 +0100
Message-Id: <1234779625.4219.125.camel@johannes.local> (sfid-20090216_112034_217750_2C49E2D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-znyCmwaxpJ07lqKX6pFk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 02:11 -0800, Luis R. Rodriguez wrote:

> >> * Driver hints which never have the wiphy NULL
> >> * __regulatory_hint: called from 11d hints, and from the workqueue
> >> that processes the pending requests (which can come from userspace or
> >> from drivers right now).
> >
> > Ok, but in the first case you can't have NULL, and in the second you
> > could just inline it. It's not an operation that requires an inline her=
e
> > for it.
>=20
> Sure, its just called twice

Yeah but the first call is entirely pointless since wiphy cannot be NULL
there. I don't want to encourage random error-checking accessors where
writing wiphy->wiphy_idx is perfectly fine.

>  and I think it makes the code more
> readable to use a routine, what if I just move it to core.c or reg.c.

If you really think it makes the code that much more readable then
please just use it once in the case where a NULL argument can happen
(the workqueue), and move it to that code.

johannes

--=-znyCmwaxpJ07lqKX6pFk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmT3mAAoJEKVg1VMiehFYTOIQAJbdeubMregGShKqxxwPyP/q
FQTrZaaZ/v0eeHHwKg7KWG96nnvXXfxM9VcfPEQrdH+EI6Wj/SH45HfjneQ4kYGI
rEJNm7Ebio+5k4p0axzFLI5Sx4zBiq7rKRx8fDjH6PED9jW6Pahtr/snSHiar5ci
yhHTpdPbdBTq59RMtylkL1RtPgYa3+PW4eDf45ylcxdLH65oxpGGE3vFdGXSVleE
Lrzk9xkFUUGE/0ltdol670HNHYly+WOkPZWgm69FvX4za7Qdo1h4I5tr4Nv+5n8j
6YUf2cgRoEEVQtoN8bD2VQmBAPXXziBIY9E1ZhE9SMFBIj1cYztRaHuZDTT0jAiZ
+WE/fAhg/JqC14rBuP/07b6VQGEcXDyJDobAvBw3kBT6d96MtMTBpaQhtiAFVBW9
IWji5NqzKAPsVtMBZyLTPxUomm4JJgiecaDnY3ZuexgR9oSrW4ZIRLhumUCF0876
X6erg37rPU1xFZsWMYfaZsb2/S96FSIzn4GpuEIqHhyWPxN24tFrCOnpTIa48UZW
erx6VcesnSlpHrJ586rCNguan7yWNXs4NhOtd8Det3FkIScxhXfhVLI6FrOwdc2d
aSzX3jIpegB/yLVCBU6kX33MptzfAbORSu6kPx4kt0er1e47pigZQq0WDu8IFZe1
e3tWaE76kz4NcV+NUvMK
=b6u9
-----END PGP SIGNATURE-----

--=-znyCmwaxpJ07lqKX6pFk--

