Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZHZI60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 04:58:26 -0400
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <3ace41890908251943n4affc955n61768e2ce98d0c94@mail.gmail.com>
References: <950315.98615.qm@web23105.mail.ird.yahoo.com>
	 <1251192477.10667.3.camel@johannes.local>
	 <3ace41890908251943n4affc955n61768e2ce98d0c94@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-poNK4oHfB11QueLUeC4X"
Date: Wed, 26 Aug 2009 10:57:43 +0200
Message-Id: <1251277063.10667.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-poNK4oHfB11QueLUeC4X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-26 at 03:43 +0100, Hin-Tak Leung wrote:

> The rfkill event hard just goes 1 and 0 whenever I slide the switch,
> regardless of what NM does . e.g. NM set to disable networking has no
> effect on the 1/0 switch (it happens just depending on the slide
> switch and nothing else), and nothing changes when NM noticed
> rfkill'ed if down & decided to if'up and reassociate.

Right, I just wanted to make sure the switch could be correctly read
while the interface is down.

> Basically the rfkill event state just depends on the slide switch,
> regardless of NM (if it is set to enable wireless networking, it just
> if up the device again; if it is set to disable, it just stayed
> disable & the device stay down, but the event state continues to
> respond to the slide switch).

Ok. But this isn't making a lot of sense to me, since cfg80211 should
refuse to UP the device when it's rfkilled.

Or wait ... are you using compat-wireless?

johannes

--=-poNK4oHfB11QueLUeC4X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKlPkDAAoJEODzc/N7+QmaOnYP/3A/7b/GOKdXEvz/tmJ0CAzp
1prVnc2Rf3VwT92MYYmrNZ/OHUAFKYykJ0CjwdAJBesD7bH9wmyDgBxoZVd35QBI
14FFkem/b/zlegcnabfIs3bf4mgrRtvDibjhEUndvKevpqcOcixNCIKD7ZJFhbSm
qeT+mjmTI7aq9nMVnw6ocdG1/vNaggtuNVI0S05bFwz71jn/S2bb3mQpXjgO8bcW
HXk/dg4yfrdowbOuW7RZZGvdqsP0508csDAmmAyCCxY9Mpj3K3BMvbJJ9v4M0Do8
3+av1bVF2zKpYNeae6N8r90VzTD7v/303HeLEiWumaaDdmaGZaiiRcJR2Q1gVJhm
h/U5sa2A76egeS4gnFXvG78cCfyaVfWjNxpGqdzEeMfxQtyXtYVQ19kxqRXBE0Xi
2y1B0mpkx39/IfWghLdbqB8b2UkGLseX1Tfvwq/8+/OizgnqXvwIa5eUdc9rYxW7
s71P0LrxHOjFwPLn7ulwHetXohgXK0rq2/AtZ+V0FQj9tMGUB7RlBUuJlSusA9lT
dgFcmgh/BRPsarXB6cTUkRDSiQXi/KcdBIJXqb50YpbcALitFk7p68dXHAGLwux4
hhyoHvC1UivFXnhjZtVAbMJt6hHbCoGyzgt+eLtGlpniTLf0H0sm1neOXbrE6OSR
FcZ7tvXH8u3QJgNMBvLH
=PItq
-----END PGP SIGNATURE-----

--=-poNK4oHfB11QueLUeC4X--

