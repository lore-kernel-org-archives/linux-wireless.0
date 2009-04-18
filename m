Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbZDRP5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 11:57:14 -0400
Subject: Re: rfkill rewrite bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49E9F677.80109@tuffmail.co.uk> (sfid-20090418_174945_153562_3F1E7019)
References: <49DCA88E.6060400@tuffmail.co.uk>
	 (sfid-20090408_153722_059382_FB44D658) <1239204090.16477.1.camel@johannes.local>
	 <49DCDD2E.80705@tuffmail.co.uk>  <49E38BBC.5010708@tuffmail.co.uk>
	 (sfid-20090413_205524_915082_56358705) <1239741968.4205.1.camel@johannes.local>
	 <49E98C86.2040308@tuffmail.co.uk>
	 (sfid-20090418_101208_980691_83127E2F) <1240043283.5792.0.camel@johannes.local>
	 <49E9A0C7.8040602@tuffmail.co.uk>
	 (sfid-20090418_114338_695917_3CBF9024) <1240057470.4755.7.camel@johannes.local>
	 <49E9F677.80109@tuffmail.co.uk> (sfid-20090418_174945_153562_3F1E7019)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ETApYtU78dGSxm1GArTt"
Date: Sat, 18 Apr 2009 17:57:10 +0200
Message-Id: <1240070230.2978.2.camel@johannes.local> (sfid-20090418_175718_226328_E0C78F92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ETApYtU78dGSxm1GArTt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 16:49 +0100, Alan Jenkins wrote:

> > That's odd, I thought I added a set_sw_state() to rfkill which would
> > disable that rfkill. But there's rfkill_set_global_sw_state() which
> > should do what you want -- can you try replacing the EEE set_sw_state
> > call with that?
> >
> > johannes
> >  =20
>=20
> Well, I think the problem is clear :-P.
>=20
>     if (!(rfkill_states_default_locked & BIT(rfkill->type))) {
>         /* first of its kind */
>         BUILD_BUG_ON(NUM_RFKILL_TYPES >
>             sizeof(rfkill_states_default_locked) * 8);
>         rfkill_states_default_locked |=3D BIT(rfkill->type);
>         rfkill_global_states[rfkill->type].cur =3D
>             rfkill_global_states[rfkill->type].def;
>     }
>=20
> One would expect to see a reference to rfkill->blocked in here.

No, that's done asynchronously in rfkill_sync_work(). But actually, heh,
that means set_sw_state can _not_ work before registering.

johannes

--=-ETApYtU78dGSxm1GArTt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6fhTAAoJEKVg1VMiehFYh7wP/2yPCLF2uKLljuzuC/g8e6o7
ULpelP20TSA/uqkVhCWVfK8FKr78mLVmc7U4hQj0k1RFcl1jbx9UoHgWwhasTjup
oi+E1OMmEp0lK1D4hzGB6jBrf1HKIEZUM/YKT2ZTknKhlPtjezntjW5EinI5FhGJ
MFKh0La24iglWpHCSK9ijd3NGLrW+ppewSTXlmoY04KtOAUmxf2yBtPtfIUr0nrV
F0DIdAI0NmwnRMGvL8uZ7WkfnQY7mTfoVR3LAiF+zPQX7rPs5+VPNr7yBVtSsyfJ
L2Jz/s6RJ3bzgQ5B6dcCrHmZDfNx0LYHE8mdV0y/FeIgUKZS/i7N5Q1NL20UXcPg
qxdC1PPI3ZvgI3Q3P1z1GtDfc4yIO5hbHAqQMTOpByKp4qW7E28X3HX/hNYRod4/
xPYUpptm7TYn1NCR1LuFDJ3SCTltW3Uro9oNZRpC4jDcGIHu0lv2mZMl2zhqGIZQ
7XRAKKXmHaCVAI7/XkjzIsLIzb6wvYS4h8igRjX54Yvxp+3v7fJBQk2PdbP2Io4g
7mc4ZYYeE5x0/vdL2R9IK8nRgeVLNCHWM0vvLdAjzQojJAHJVQzo931WmmDNfZmw
j+jFo735gTP0tFgSJcVMDrHnZBRcCpKEjTK7jJHuhTazZZxhj5FY6TmWmURanTMT
Jwi4TaZo7E7XRMz3fi9f
=eVfl
-----END PGP SIGNATURE-----

--=-ETApYtU78dGSxm1GArTt--

