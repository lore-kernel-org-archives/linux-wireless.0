Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZC0VQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:16:08 -0400
Subject: Re: rfkill get_state
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <20090327150824.GC24288@khazad-dum.debian.net>
References: <1238161210.4452.8.camel@johannes.local>
	 <20090327150824.GC24288@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2tZPAZEqEx9OTCyOa52I"
Date: Fri, 27 Mar 2009 22:16:03 +0100
Message-Id: <1238188563.4452.21.camel@johannes.local> (sfid-20090327_221612_076111_5D7A4C63)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2tZPAZEqEx9OTCyOa52I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 12:08 -0300, Henrique de Moraes Holschuh wrote:

> > It seems to me it'll only get called=20
> >  * when you read sysfs
> >  * on resume
> >  * on epo
>=20
> Yes.  It is mostly something that the rfkill core uses to get an up-to-da=
te
> state when it knows it needs one, and it is not good for anything else.

Ouch, ok.

> > How do we ever react to a button press then to make a uevent?
>=20
> rfkill-related uevents exist to signal change in state of the rfkill
> switches, REGARDLESS of the reason.  So they are NOT related to button
> presses, except in-so-far that a button press might have changed a rfkill
> switch state.

STOP WRITING ALL CAPS PLEASE. Look, I know that rfkill is related to the
button press, if that button affects the hw kill state.

> So, the short answer is: rfkill_force_state().  Call it when the radio
> rfkill state changed, and the core will generate uevents.

You do realise though that none of the platform drivers actually call
that, right?

> The core doesn't have any helpers for this, so if you need polling, for
> example, you do it in your driver and call rfkill_force_state() as needed=
.

OK -- IMHO the only reasonable thing is to actually add polling if
get_state is assigned -- anything else is pointless. I also don't see
how get_state is actually needed, drivers can just use force_state after
suspend/resume etc.

> Where does the button press enters the picture in your driver?  Knowing
> that, I can illustrate how it would plug to rfkill core, or to the input
> device core (I am yet to see a case where it should be plugged to both).

I'm not actually interested in a driver. I need to integrate rfkill into
mac80211, and for that I need to rewrite it to have a usable API.

johannes

--=-2tZPAZEqEx9OTCyOa52I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzUIRAAoJEKVg1VMiehFYEiIP+wUC3bGZ/Gpjkt3nSmka9tin
ailJpErwWHMZCWQ+sHrJY4ucy6J9VI6ijI+dpPK2tbfVv99zrRRMCdOkGrL69IVQ
ZmDwKBjt+gQ/MOBK8gY1bqrkxKD+X0ibbay5nWXHSC8f/5LdWnEeOiZk79au1XK2
3AjwaXhkmJUQz5P5CwRfFjwLC+TLmUiLDxZch1ImCfgpSxHQ6rntt1FhoPkkJOHv
b0kpNoFYysywCqN92MNGIVyTmgQ0pjWurMI2Gnl4JPPJeP4SVOTyKQ9pVPhEbwRC
9Rq2zZms4W7cYEOruNWPiRi78FhE1HdQsiaLWhf46cp2cZqsx83yaPnH+U6Dmj7D
uIQCcpenaV/Kc62RzhT16WdOUlBNEkpSjmZ+DqbyxSarXE+PWbVW/VuAOFSSrk9n
Exe0hTy8Y5k1IwxU5uyOCQFTLw61bixjjvFbohBwOS9o44gKLu3iS3HBc33KV+K1
pw6BvtgWb0H8CyvG9eGXdo41l8OIDT4B2+e7XB/FGY2M274ZxdFsQYputwWJ62Cl
kNhoQzqkthYwRgoksmzBGieePP/Xv3JRdmk8nO2USIsFNrjNj7aOagmb+W26vEja
IP2BfXOr8/lmsulSDi16rRXL+TV9PelOEjGTHJtw2bNGEbaruUE5LxKK5HFJg5hT
NbcO0s2NeNmpto96bMFJ
=rNDS
-----END PGP SIGNATURE-----

--=-2tZPAZEqEx9OTCyOa52I--

