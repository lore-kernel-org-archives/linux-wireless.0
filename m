Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757566AbZC0VLl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:11:41 -0400
Subject: Re: rfkill-input madness
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090327143007.GA24288@khazad-dum.debian.net>
References: <1238159196.4452.1.camel@johannes.local>
	 <20090327143007.GA24288@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TCGWYFITccBkN2maI7Yb"
Date: Fri, 27 Mar 2009 22:10:37 +0100
Message-Id: <1238188237.4452.17.camel@johannes.local> (sfid-20090327_221144_293089_5261B8F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TCGWYFITccBkN2maI7Yb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 11:30 -0300, Henrique de Moraes Holschuh wrote:

> I think rephrasing that warning to: "set user_claim to 1 on any switches
> that you're going to mess with in response to rfkill input events" would =
be
> a LOT better.  I should have written it that way.

Indeed, but that's useless since almost all drivers disable userspace
claiming... I'll re-implement it later for only the software state.

> The truth is that userspace doestn't have to care about rfkill-input, unl=
ess
> it is trying to do what rfkill-input is supposed to (i.e. listening to in=
put
> events and then trying to update switches), and if it is going to do that=
,
> it needs stuff that I never sent in for review.

Care to explain?

> Anyway, I got sidetracked because I was Not Happy with the userspace ABI =
but
> couldn't come up with anything better. =20

It's not like we can change it now...

> Better at least get those patches
> into the open.  I just pushed a rebased version of the patches to somewhe=
re
> public.
>=20
> It is at:
> git://repo.or.cz/linux-2.6/linux-acpi-2.6/ibm-acpi-2.6.git rfkill
>=20
> Please take a look and tell me what you think, and whether there is anyth=
ing
> worth bothering with in there (FWIW, the patchset worked just fine last t=
ime
> I checked).

Ok, when I get online again :)

> As for your second question, I have been looking at the issues re. input
> devices and X.org evdev in the last two days, and the fact is that: it wi=
ll
> have to be handled in userspace on most non-embedded scenarios, if things
> don't change in userspace soon.
>=20
> The problem is that X.org will exclusive-grab any input devices you let i=
t
> touch, and rfkill_input will never see any events, anyway.   So, right no=
w,
> for the vast majority of the users, either an input device is not in use,=
 or
> it is in exclusive-grab mode feeding X.org evdev.
>=20
> At this point, I don't have a clue on what would be the best way to go ab=
out
> addressing this issue, that is causing problems not only to rfkill_input,
> but also to anyone who would like to have hotkey handling outside of X.or=
g
> in a system daemon, but still have x.org see the keys (without ugly 'even=
t
> repeater' hacks).
>=20
> I have no idea if we should talk to the X.org people to see if we can dro=
p
> that exclusive grab?  Allow kernel-side input handlers to ignore exclusiv=
e
> grabs?  Have rfkill-input be a you-want-it-in-the-kernel solution and sim=
ply
> don't care at all about userspace interfering with it?
>=20
> I was about to try to locate someone that deals with evdev to ask his ide=
as
> on the subject.

Indeed, but that means *X* needs to implement all this, or something
running in X, which is undesirable... Other things are sure to run afoul
of this too, for example some hal button handlers.

johannes

--=-TCGWYFITccBkN2maI7Yb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzUDLAAoJEKVg1VMiehFYIsoP/1BhEih6xDqH+dOatzW+kCNC
lQsSGoT+zlRLDIlmCxTRPzrj51xndlxgPOSSUwtq7d2fm8BFy7XjaT1H3I7NrXJj
kviM/u2QrYt89FU+R+5Odf0LTSqkqhb5wjBROc08aCRBFe6XZQxhgXBMZ1SRXlRM
h4dOmLITupiYIck68XqYaPkT31NKq7Ta14UQnfm8UiU+Tg4mklX1H7sI7N/4XXKk
QK6yXL1vj/alpAj81ftHos5cVoCy+Pkgd56sZ/ohafL7zQqgLAfCLeZBvTAI69sT
3ZgGHC+d7aqkPqfaAJNmR0AijfOe6Jmmi2dThh1ziuULZVlWI8kY0sRA6YyCDmUT
etag6LJJwPPiY1CT6fUGnVZamvURqi98oEwO+dZd7qnbvZdcyGOjEg1meR8KMSCV
kzneeSfFCrBPnHEZ6W8K5ZDBs70c5M4h+UNjrnZiNfXnXrX4Vk2CyC8KWz6pg69v
qL69OtCbCNAZJiLTfiTgxy3CRuPSMeBuxWaZNgVvluoDSYN8SD742/VwOAc4TMS6
d2IU+UEIg6ikY0S0vBuX2ep0HytQ9t2e8PN9dXfiNsVivjo7x3GSSd9ux40CNjy0
fcoMEJXlVbugyH4GQP/fxD8c/vXqzxWieg6TEh0Fnz2Q8metnFmPyR1SHH0fReQH
bM9JKkE7CY8Oh/IYMbjJ
=7b58
-----END PGP SIGNATURE-----

--=-TCGWYFITccBkN2maI7Yb--

