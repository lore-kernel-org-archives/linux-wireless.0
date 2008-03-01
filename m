Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36988 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbYCAMrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2008 07:47:40 -0500
Subject: Re: FIF_ filter flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200803011155.57958.linux@baker-net.org.uk>
References: <200802292339.27174.linux@baker-net.org.uk>
	 <1204330161.3938.55.camel@johannes.berg>
	 <200803011155.57958.linux@baker-net.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fIurThBQfb/olfKo6A8j"
Date: Sat, 01 Mar 2008 13:47:29 +0100
Message-Id: <1204375649.3938.87.camel@johannes.berg> (sfid-20080301_124754_063414_2FDC304C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fIurThBQfb/olfKo6A8j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Interesting. I don't think I have an opinion right now. I wanted to be
> > strict about clearing the flags so that you don't end up with a flag
> > that we never get traffic for, but I can't imagine any check where you'=
d
> > want to know "do I get traffic XY".
>=20
> The only way I think it might be useful is if it allows mac80211 to not b=
other=20
> with checks that it would otherwise do, for example if mac80211 didn't wa=
nt=20
> to pass multicast packets that were not for us up to the higher stack lay=
ers=20
> it would know that if FIF_ALLMULTI got set it needed to do some filtering=
 but=20
> if it wasn't set the hardware had a working multicast address filter.

True, but that particular example is just more code and I don't think
it'd be worth it.

We also should use the flags for monitor flags, i.e. when the user
requests control frames but the hw can't give them, the user should be
able to query the current flags. That works the other way around too, I
guess, if the user requests other-bss frames but the hw can only do that
together with control frames, the user should know that.

> rt2x00 ignores the changed_flags passed from mac80211 and keeps track for=
=20
> itself of what filter it is applying so it will always recalculate it's o=
wn=20
> filter based on total_flags and reconfigure the hardware if it changes.=20

Ok.

> This=20
> does assume that mac80211 recalculates what it wants total_flags to be ea=
ch=20
> time configure_filter is called rather than just changing the value it go=
t=20
> back last time but that appears to be a valid assumption.

Right, mac80211 does that and it has to anyway because of multiple
virtual interfaces, so that assumption is indeed valid.

If the driver is capable of juggling the flags properly then I'd think
adding flags is fine.

johannes

--=-fIurThBQfb/olfKo6A8j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8lQYKVg1VMiehFYAQIGJQ/8D3FnjyS6d1SL0/9aH/SzatDHZzKs54qS
Cdx75ndhGgaba2o6TIOUQbY9OJbRllYeEKxOXQcY5QvsCBr1KAmf73dcwMJ/1PTK
d5t6wbL996ZF2RkOJZFOOc5H1g7ACaEFLHlovQGYxNrjyc+bm+jHH9pferMReOb+
yi5tQfHkohtvvuuUCB66GM8uSOjPu0mqbE8U3A156d19qjbePUC3w6KtYfQbiGDV
kl5F0BVLcZlcZzyo7WGfSq0Y7UBTLAUam6J5zedT1fp74SoeKNAx7mJI14CZavJv
yO9YQ85ATLjN3OQRe0RdsppAQivVF70vmuqBvxbweTz8ErTDo8sx4V6vggb3wyqS
/F9eE1b7SgAppFXejaoNpZwSCd/9EjcxlZUUihtngVGYgHp0IiLh+QpslmhRY9XR
oio7Ubvcn6cOmu6SCkw2igfyUzAlMii+ZcZIEoAzg3D6Y11dUrWGxq1cq7P0dCOw
s1ytpwtz48Rfx60iFc9t3qty3FYxYywaQ/n+6Fc+b5apzk9mgF6B0bSE/Pdm5UYm
MJlei3TqCJro/5v6qKxyrDP8u0hn+hS9VmzwM+FThdfLtD3VFnWGS16nsIMjWYhG
6WdmjFiV+Pqebu78Lk91mUceE+wb1p2nO0IaCvu9AaqDmvk6rIPdNXkyuoEmq8cv
77e3ELM9xUU=
=aeBr
-----END PGP SIGNATURE-----

--=-fIurThBQfb/olfKo6A8j--

