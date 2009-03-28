Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbZC1Umr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 16:42:47 -0400
Subject: Re: [PATCH 7/8] mac80211: fix aggregation to not require queue stop
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <43e72e890903281326j1bba2456j3b82bf3831b614f6@mail.gmail.com> (sfid-20090328_212634_253188_D4B2DE50)
References: <20090323162834.154525349@sipsolutions.net>
	 <20090323163053.344441542@sipsolutions.net>
	 <20090328045529.GF5543@bombadil.infradead.org>
	 <1238262118.4217.13.camel@johannes.local>
	 <43e72e890903281218s6b4eeb9eu4a97aa3e87c5a3a6@mail.gmail.com>
	 <1238269957.4217.24.camel@johannes.local>
	 <43e72e890903281326j1bba2456j3b82bf3831b614f6@mail.gmail.com>
	 (sfid-20090328_212634_253188_D4B2DE50)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LaZuCRhzBq5Lt5w5+caE"
Date: Sat, 28 Mar 2009 21:42:37 +0100
Message-Id: <1238272957.4217.28.camel@johannes.local> (sfid-20090328_214250_920055_0751DFFD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LaZuCRhzBq5Lt5w5+caE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-28 at 13:26 -0700, Luis R. Rodriguez wrote:

> >> > I think it also makes more _sense_ to not ask the driver to handle t=
hese
> >> > frames, because we won't set the AMPDU flag correctly if the session
> >> > start is declined.
> >>
> >> Hm, wouldn't we send them as normal frames if its declined here eventu=
ally?
> >
> > Yes, we take them off the sta->pending, put them through TX processing
> > and send them as normal frames.
>=20
> OK so you're not suggesting we change this more, just stating that
> this makes sense.

Yes; I don't see why we should change it. Otherwise the driver needs to
ignore the TXCTL_AMPDU flag and do its own processing, would would seem
odd. By the way ath9k does it, it probably does it automatically though,
but I don't see why we should require it.

> >> OK I see that but I am not sure of what's done to the skb in the old
> >> case if the session is note complete yet, nor now if the session gets
> >> declined. I can check later, right now I'm feeling lazy.
> >
> > Before my patch the skb is still passed to the driver, which would need
> > to be able to handle it (it =3D=3D session being stopped). I'm not enti=
rely
> > sure ath9k handles it properly but I suspect it does.
>=20
> Not sure, this begs the question when you were seeing the received
> addba response come up first. SInce both iwlagn and ath9k use the irq
> safe aggregation cb I was suspecting this would happen in general on
> UP boxen and probably even less likely to happen on ath9k as we don't
> have to talk to the firmware during the ampdu start action.

No, it can only happen when the remote station is faster to reply than
the driver.

> >> > Ok that might make some sense, though as a parameter you can easily =
see
> >> > where it's coming from, I think :) I agree that the entire code is a
> >> > little brain twister...
> >>
> >> Yeah.. I had to re-read aggregation code again to get the hang of it.
> >> Anything we can do to make
> >> it easier for people to pick would be nice. I think I'll go patch up
> >> the aggr-tx kdoc too now, unless we
> >> plan on nuking some stuff soon again. I suspect the next big change
> >> will be to move software based
> >> aggregation queue handling and mapping to ACs within mac80211 for that
> >> type of hardware which
> >> we'll need for ar9170, ralink stuff, broadcom (if that ever happens)
> >> and our next generation 11n USB
> >> driver.
> >
> > Right -- but I don't expect to be working on it any time soon myself.
>=20
> I didn't expect you to. We may have the need first unless chr gets to
> ar9170 stuff first.

Ok, makes sense.

johannes

--=-LaZuCRhzBq5Lt5w5+caE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzou7AAoJEKVg1VMiehFYHDkQAKSGj3VSJ9C3P1DhKpiJxUIO
Rc3NanV+ESBp2vtev6KwAmsmiVkvu+5Xv5c+YqPhiddPycbW77XepaKvwz5ul4FK
6NfvtzzJJGWGZjsMSX0bbpWARbVRk9GaxVjfeQ/63sKd6kYZuQsuQjosni/mWqn6
/7mCoYyvMnB5ANJpq+NwiAVlB9s777k8CyPo9gMKYuxSbnLblxF7rxbK0PpoEaPx
8mwcYMBOJGGI0IZAxAC2bkqmUhAx3umIUVBOu9Qt40mCUWx7irPiQUCr15uB5zu+
Z/nE9e36+OCaoSOE6BqTls+Kfj/QHj+yVHLYGgxlc+3bKR//pHeIi2t/OZWM5buM
Hdx47lU0A92sT+FcFyE17vqhby2NqD1RsCiK/Ww8ZHrT1p2BU77axdT4a2gbBOMw
1aApow8O9UbYMt6WHBeCoUx0XC5JoMh0CoelsDIlPBbyk+3mF3zA76hOjYQ2e6IR
4MzXqbjpI8WRIoGOXz9vfA9eZH13ThjTZoE/3sg3G0PidsSPcb+RgTlmKYI0kPy0
EJ1Z4nIlJQdLVReaGrTsgYY9r7/ehelY5JGQuZcwf2Y6neZJfcrSTQoUfrucnmko
UpPpFQ6B0MeIV25O06CrmkCzIXgKa4KfTBqvs8qAwk2F2+XmT+965Ds3JDvMo+MZ
j/uUrNPr7R8KspXJquJV
=cfsG
-----END PGP SIGNATURE-----

--=-LaZuCRhzBq5Lt5w5+caE--

