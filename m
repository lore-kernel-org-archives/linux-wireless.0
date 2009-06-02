Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbZFBIBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 04:01:51 -0400
Subject: Re: [PATCH] rfkill: create useful userspace interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1243928308.3192.38.camel@localhost.localdomain>
References: <1243524688.10632.0.camel@johannes.local>
	 <9b2b86520905310213n7be56260lc0c2cf3c109fe065@mail.gmail.com>
	 <1243763887.19302.29.camel@johannes.local>
	 <1243796509.6570.35.camel@localhost.localdomain>
	 <1243841639.5299.8.camel@johannes.local> <4A238EA2.4040106@tuffmail.co.uk>
	 <1243858256.5299.14.camel@johannes.local>
	 <1243867620.3015.17.camel@localhost.localdomain>
	 <4A23FD91.8020200@tuffmail.co.uk>
	 <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-rgZ9LSnCSz5bDWhzTNrN"
Date: Tue, 02 Jun 2009 10:01:46 +0200
Message-Id: <1243929706.20064.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rgZ9LSnCSz5bDWhzTNrN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 09:38 +0200, Marcel Holtmann wrote:

> If you really don't wanna have rfkilld _not_ impose a policy on cold
> boot, then we can certainly add that. However that is part of rfkilld
> and not the kernel.
>=20
> For global states, I am questioning the platform that actually has
> storage for global states. All platforms that I have seen so far store
> individual per device based states and not the global one.

Yeah, unfortunately the platform drivers do store/restore global state.
And in a sense that makes (made) sense since the default rfkill-input
policy was to toggle everything based on the platform button. It's icky
though.

The problem with not telling rfkilld about this though is that the
kernel will suddenly impose a hotplug policy that rfkilld doesn't know
about. This might not even matter though since the _ADD will be sent
with that policy already applied, and if it wants to change the policy
rfkilld will do _CHANGE_ALL.

> If you wanna just accept what the BIOS (or other OS) tells you then that
> is an acceptable policy. So rfkilld will just map key input events in
> that case. Fine by me. Question is if we can't do that right now? I
> think we just can.

Yes, we probably can do that right now, by making rfkilld start up
without setting a policy (CHANGE_ALL). It just doesn't know what the
policy is, then.

> Question is if we really have a global state here. I doubt it since all
> of these are device specific states. And having the BIOS or ACPI dictate
> what state my external Bluetooth or WiFi device is in is pointless and a
> total broken concept.

Unfortunately that's how it worked before, it's part of the rfkill
legacy that it seems we'll have to accept. I guess we have only
ourselves to blame for not reviewing Henrique's rfkill implementation...

> > You propose to exclude a feature that currently works, on the grounds=20
> > that it is inherently broken.  But you haven't said that this has ever=20
> > caused incorrect behavior.  All you have said so far is that it is a ha=
ck.
>=20
> This never worked so far. The mac80211 or Bluetooth subsystems have no
> RFKILL state and thus global states are not enforced. An external dongle
> without RFKILL support is not taken into account. You are not talking
> about global states here. They are all device specific. The device just
> happens to be a platform device builtin the system.

Right, but rfkill does actually have a function to set the global policy
state (rfkill_set_global_sw_state) which some platform drivers insist on
calling.

The only reason we would need the NVS_REPORT then is to detect whether
or not anything in the kernel called rfkill_set_global_sw_state(). If we
can live with just configuring rfkilld for the (arguably broken) case
where somebody cares about this, I'm happy with removing it.

Hope that helps clear up your confusion.

johannes

--=-rgZ9LSnCSz5bDWhzTNrN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJNxlAAoJEODzc/N7+QmaqD8P/2MVq+Kamey3L5GNKM4mpSF5
JuPeSQsssl18K3F88WRRF4H9oJ1QN1u+LIyWAtFtsiprevFJz2aps8L3jbF4yWiO
1DvtnK28csA0hpNqBIU124mP0XOFOaOjFR3fBJzWpAjCKXcjQ7XHbJCfIw0sVgvl
z3JDLnR/zbtYLCXCBnvKOHLQSGXDW68yWW7sc98ZY5tFRFO3/G3YCDjSoSaIjvb+
9EqmEbsiG7Y3cjJe0EqMh10cZE+H+Qcwo2Ettbk+hQrCqUrq9PmmjOaOpTyZ1Vso
3BhBOjVM8xVtpNrtqYyNyHgX7I+8c/YNALE5DZs2SQHPzz5YV5y4jDK1KBxJi60x
AJYLdz6+uWTG9rcD8lHiiRGSVYTydYpqAwXMhLxESZs7g6jklf+Mptcw0G7gsE1X
Uwhy+f4+l9yjEpPM8dz7g5URNHosv3PZ6kNOfBj8nKifSnKgvaEZMhGqEm+hWHIO
5SrMlhG4oJIgcyrW6G8zRIkAtz332StiBbbVvmBR4B1IUOqciQfqwpBwFFmcgX0J
qyiwmz/QLkDThbp/kysIwpf+Khn+zVbeyDD2t6mgf8j22bIlCCMS2FIwQvetAqrO
c5iUjjGgL7EDD6UNxV1NvtCi85ZpqQ27CiDob1T+jUmX0yFzLX5AnpcuhGWwwf4l
8aSO6FQ5mFkoxdKX2KzA
=VCx9
-----END PGP SIGNATURE-----

--=-rgZ9LSnCSz5bDWhzTNrN--

