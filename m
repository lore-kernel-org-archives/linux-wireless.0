Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbXFPMRN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 08:17:13 -0400
Subject: Re: more nl80211/iw tool code comments
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lamparter <lists@diac24.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070614142925.GA24414@charon.n2.diac24.net>
References: <1181759017.29767.117.camel@johannes.berg>
	 <20070614142925.GA24414@charon.n2.diac24.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dJL/8cQw+VBfJtShz4EF"
Date: Sat, 16 Jun 2007 14:17:36 +0200
Message-Id: <1181996257.9058.33.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dJL/8cQw+VBfJtShz4EF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi David,

> The entire iw tool is really just a hack btw...

doesn't look too bad to me, unlike my python tool... :)

> > iw phy set      [ phy ] DEVICE [ CHANSPEC ] [ name NEWNAME ]
> >=20
> > and we discussed on IRC that it might make sense to have the same for
> > nl80211. On the surface, that makes sense, however, it does add a
> > complication in that we need to either specify that you cannot combine
> > some attributes (which doesn't really make sense),=20
> Hmm, I can't come up with any example other than using some 11n attribute
> with a 11abg phymode... care to hit me with a hint?

I was thinking of the name vs. phy parameters.

> 	if (err < 0 && modified && net_ratelimit())
> 		printk(KERN_WARNING "A link change request failed with "
> 		       "some changes comitted already. Interface %s may "
> 		       "have been left with an inconsistent configuration, "
> 		       "please check.\n", dev->name);
>=20
> So, if rtnetlink doesn't bother too much about "transaction safety" eithe=
r,
> why should we?

Heh, dunno, I just like to think that one thing posted to the kernel is
done atomically. We can drop that requirement and document it, but that
won't be easy since we'd have to document exactly what is done
atomically.

> If an app wants to know what failed, it can still send SET
> requests broken down into pieces, so they will know which piece failed.
> Obviously they need to leave some stuff grouped (e.g. PHYMODE and CHANNEL=
),
> but I don't think it's useful to force them do so by breaking stuff into
> multiple commands...
>=20
> (There is no difference really between
> 	CMD_SET_PHY name=3Dmyphy
> 	CMD_SET_PHY phymode=3Da channel=3D1
> and
> 	CMD_SET_PHYNAME name=3Dmyphy
> 	CMD_SET_CHANNEL phymode=3Da channel=3D1
> but the former allows, if we don't care, to just batch it.)

True. I guess we can leave it as-is and see if we run into problems with
some software or something and if we do document it better ;)

johannes

--=-dJL/8cQw+VBfJtShz4EF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGc9Tg/ETPhpq3jKURAmrZAJ4lWqxps34x6gDQMFeBQylEtKZtBQCfdIYi
VdFq/c9M9dQa622CMwW2mtU=
=ZRBt
-----END PGP SIGNATURE-----

--=-dJL/8cQw+VBfJtShz4EF--

