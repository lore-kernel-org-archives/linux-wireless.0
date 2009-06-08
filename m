Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbZFHLOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 07:14:11 -0400
Subject: Re: [RFC] rfkill: remove set_global_sw_state()
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Marcel Holtmann <marcel@holtmann.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>
In-Reply-To: <4A2CF18D.4080305@tuffmail.co.uk>
References: <1243885494.3015.29.camel@localhost.localdomain>
	 <4A24559D.7010201@tuffmail.co.uk>
	 <1243928308.3192.38.camel@localhost.localdomain>
	 <1243929706.20064.7.camel@johannes.local>
	 <1243930703.3192.59.camel@localhost.localdomain>
	 <20090603040315.GA10464@khazad-dum.debian.net>
	 <1244008652.4145.7.camel@localhost.localdomain>
	 <20090603213340.GB22809@khazad-dum.debian.net>
	 <1244088806.4145.24.camel@localhost.localdomain>
	 <9b2b86520906070538s7def28f0nb269914e03207228@mail.gmail.com>
	 <20090607125715.GC3340@khazad-dum.debian.net>
	 <1244394963.12956.1.camel@johannes.local> <4A2BF833.1050906@tuffmail.co.uk>
		 <4A2CE4A2.2090308@tuffmail.co.uk>
	 <1244457159.18863.7.camel@johannes.local> <4A2CF18D.4080305@tuffmail.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-aOCEE8YBBuVO9DNLNram"
Date: Mon, 08 Jun 2009 13:13:38 +0200
Message-Id: <1244459618.18863.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aOCEE8YBBuVO9DNLNram
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-08 at 12:10 +0100, Alan Jenkins wrote:

> >> -		rfkill_set_sw_state(wwan_rfkill, hp_wmi_wwan_state());
> >>  		err =3D rfkill_register(wwan_rfkill);
> >>  		if (err)
> >>  			goto register_wwan_err;
> >>    =20
> >
> > Hmm. Anyone know anything about HP? That kinda looks persistent too.
> >  =20
>=20
> Quite possibly.  I just don't know, and it's never been treated that way
> before.  The old core, when I first read it, you were supposed to report
> the initial state so that it knew whether it differed from the default
> state.  So the core could "optimise away" the initialization if the
> current state was the same.  Then rfkill_set_default() was added, but it
> was only used in tp-acpi and then eeepc-laptop.

Oh, good point. Then maybe that was just to avoid the core
initialisation that I just always did for ease of use.

> The counter is the sony-laptop case.  That driver also hits ACPI to
> query it's current state.  But apparently it doesn't always power up in
> a useful state, because there's a specific git commit which forces the
> radios to unblock at load time.
>=20
>=20
> I think this patch should preserve the existing behaviour.  But the
> rfkill rewrite as a whole is a good opportunity to re-check this issue.=20
> There's only a few maintainers to contact so I don't mind doing it -
> unless you were going to check with them about the rewrite anyway?

I wasn't planning on doing anything more than before -- where I had
copied hopefully all maintainers on the rewrite patch.


> > Ah, this is the quirky backward compat code you're talking about. I
> > guess we need it, although I don't particularly like it.
> >  =20
>=20
> I don't like it either.  The patch as a whole only makes sense because
> rfkill-input is going away, so the global states will become less
> important.  When you use rfkill-input, you really want the individual
> states to match the global ones, otherwise your user experience
> suffers.  When you don't use rfkill-input, the "global" states will just
> be load-time defaults (once suspend is fixed).

Yeah. Want to fix suspend too? I would now, but I really need to get
lunch first :)

johannes

--=-aOCEE8YBBuVO9DNLNram
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLPJfAAoJEODzc/N7+QmabzIP/jIAmESacuVK9JKgn4Lr97Ja
xGb6igV39TvXIEiLWWZhWiiRiSW7FTp73AAukHmsGHGmLHZKsqh9dAgs3Z1M48sR
w3Slm/vOfAB9tXblXc6QgRJ2SLdU3/pyQyp1S6l1SDU08/frGl/TnwjMX4Kigs/g
7lk7weoUdheTVfefgbCpbKNT82ggG0auR99Dy/7b1SVgfZNLZm+JwO2xydnhZcad
J8apRhjgtDCUc6Zcbpm6M1mVZ26hLr1/n0r3r0PN+87c4ddL/IGT/n1EBg1v2b/j
mrfXmh6Wkd4NrGYel4gaa2w7fBjKGn3zAUoZWDaDpBxr2QMIFjB/7s3MRSFv+iD8
041RKUVgmxRQOY03ztyXoB6Ne/TyxCmxRkURjS1l5R4E6PauoGu14fq9y488u0g9
a5ImXwP0VSr3c6rX0OrwoIxbxmKw06vNYEPhklkAyXCTCtDf+8f29+Lg4eJfT0S9
YjHQ5DeJgs6xm03ENvEZ/S1tV9MZiqc4Lv3DUIwZQ9kVHeRsm0Mar2DZabdNNwU1
KDaZm58Fgbf0DwEfluuq9gnJlMF5ldGMXy3JEKorLpNRQNvailOS9RUsiigpHBgd
D9ol4jR5oGSfMCyRWlVq4Ov5w6MQ6mOLUEAulzlg2zpFFIJbFZhI6uqFPhhEpMq5
G8asicaYQBOKVf4z8eOg
=EE8g
-----END PGP SIGNATURE-----

--=-aOCEE8YBBuVO9DNLNram--

