Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbYKCHjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:39:37 -0500
Subject: Re: Alignment issue with 4965 and 2.6.28-rc3
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: marcel@holtmann.org, linux-wireless@vger.kernel.org
In-Reply-To: <20081102.233528.91273615.davem@davemloft.net>
References: <DFAA4A8C-F8D5-4D08-9C6E-8BB65E3BCFC2@holtmann.org>
	 <1225697100.3619.21.camel@johannes.berg>
	 <20081102.233528.91273615.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZXXUo8XMx88Spud2A//R"
Date: Mon, 03 Nov 2008 08:39:37 +0100
Message-Id: <1225697977.3619.28.camel@johannes.berg> (sfid-20081103_083942_166700_022A0898)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZXXUo8XMx88Spud2A//R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-02 at 23:35 -0800, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Mon, 03 Nov 2008 08:25:00 +0100
>=20
> > I've tried sending a patch to add
> > CONFIG_HAVE_EFFICIENT_ALIGNED_ACCESS or something like that so that
> > we can fix it up if that is unset or make the driver depend on it,
> > but it hasn't stuck so far, so for now, ignore the warning and don't
> > try to use Intel wireless hw on platforms that don't like unaligned
> > loads.
>=20
> What are you smoking? ;-)
>=20
> arch/Kconfig:config HAVE_EFFICIENT_UNALIGNED_ACCESS
> arch/powerpc/Kconfig:	select HAVE_EFFICIENT_UNALIGNED_ACCESS
> arch/x86/Kconfig:	select HAVE_EFFICIENT_UNALIGNED_ACCESS

Woah, it _has_ stuck. And during .27 even, I totally missed that, not
sure why. Thanks for pointing it out, I'll go fix up alignment issues in
mac80211 then or something.

johannes

--=-ZXXUo8XMx88Spud2A//R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDqq2AAoJEKVg1VMiehFYxyQP/2nrP3CiItkee+2aPFOytZ0A
cmOFLSC/vcjzac0GF9nKDk9jBFDOTu7iFcXgkhM+m70F64uMw7DqhszKLjX0YAG+
MXCot4Kx2cEO28vbUM6Ly5/XrCWTxJqeYJORYgDVUntlBh1cnqhzFIf3Dzr8AtX8
XgM2H7Zoc4D2Y23vRQLJ4Pk5OWELcDhZV0FmKPq6LTZnZLRDwoVgGMHBy2uw6jgB
mf44nNNoEIYjlJErh/riwitnOwKAw5KrKUMK6/mSGiVW3u3r7DA5jDorpkUWoD1o
hZ3ggp0JqNxRdH0JZ8wYI1OqBfvpgq8AcKyyRV4DV5Jbrdllm0Sr6caPNc31qhyO
EgV6KkOp+jgaoFe/Z6gS6KN/b6gIMWGNzyT+fQQND74SCGu1q9l+YPm2fBR0lBGk
4MxoKGKkIa33kOMIZVwSWRheSWJwBqMvESrMkPLAXUVBkHAPdLbGY6cLqMVykoXQ
W0s3E9UKbUxEgQRYJEdzPa3347bO1XLf9EraPg9yqbinqvwwLoGf7+TuKum3vvRp
RcJx+LKYz3awxSA2VUE+ZsFFsct0npFfjpnWgDtUeevoEV7CjDrg445ZanakZHUz
e9bVZehpsVRolP+EwwXReE0SipiTvF+jAcuwyn5uyn7PHxDTO20Y9cHxGUJNJup3
qwi6UbRsib9FCLqRIRGP
=lVK0
-----END PGP SIGNATURE-----

--=-ZXXUo8XMx88Spud2A//R--

