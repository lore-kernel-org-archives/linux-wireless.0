Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZEQLVj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 07:21:39 -0400
Subject: Re: some wireless suspend thoughts
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <43e72e890905161507r664cafd2i8815f400a5158b04@mail.gmail.com>
References: <1242397016.5799.102.camel@johannes.local>
	 <43e72e890905161507r664cafd2i8815f400a5158b04@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1ddYne5nYseBLy4+zmVs"
Date: Sun, 17 May 2009 13:21:36 +0200
Message-Id: <1242559296.28127.67.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1ddYne5nYseBLy4+zmVs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-16 at 15:07 -0700, Luis R. Rodriguez wrote:

> > --- wireless-testing.orig/net/mac80211/pm.c     2009-05-15 15:17:08.851=
827827 +0200
> > +++ wireless-testing/net/mac80211/pm.c  2009-05-15 15:17:09.891708511 +=
0200
> > @@ -16,6 +16,17 @@ int __ieee80211_suspend(struct ieee80211
> >
> >        ieee80211_scan_cancel(local);
> >
> > +       local->ps_before_suspend =3D !!(local->hw.conf.flags & IEEE8021=
1_CONF_PS);
> > +       local->hw.conf.flags &=3D ~IEEE80211_CONF_PS;
>=20
> Why clear it? Wasn't the goal to go to PS mode during suspend? Also if
> we're already in PS mode no point in calling hw_config.
>=20
> I take it we don't want to go to PS mode when we don't have WoW
> enabled then, because as you noted you're going to disassoc pretty
> quickly otherwise, unless your AP has long idle detection times. PS
> mode requires you to be able to be up at least every DTIM it would
> seem better to just disassoc unless wow is enabled.

Yes, I don't really know why I did that, I think I only did because I
wanted to be able to control what the AP thought by sending that
nullfunc frame in mac80211. We probably should do the reverse and enable
CONF_PS if supported and not active yet, and only if not supported send
the nullfunc frame 'manually'.

But note that for the AP we are in PS anyway since I send the nullfunc
frame.

> We need to consider ahb as well but that's a quick fix.

Yes, of course. Like I said -- a hack.

> I noticed you nuked pci_save_state() and pci_restore_state(), that
> saves PCI config space so seems required, so we'll have to still
> inform drv_stop of the suspend case -- and not sure that is worth it.

Yeah I wasn't sure about that myself. I suspect moving
* pci cache line adjustment,
* pci latency timer thing,
* and pci_set_master
into ->start would be sufficient instead of using
save_state/restore_state.

> What we save here is more control in mac80211 / cfg80211 but the
> things we need to added makes me wonder if its worth it in this case.

Yeah, not sure really. I was just playing with the code mostly tbh. I
thought it was nice that I didn't need code in two places in the driver,
only in ->start/->stop rather than the PCI resume hooks too.

Also, because I decided to use ->shutdown in cfg80211 so we could in
theory have WoW while the machine is off... of course, that doesn't
really work since wpa_supplicant will long have been killed thereby
deconfiguring the interface and userspace will have taken the interface
down itself. Of course, the immediate reason I added a shutdown hook was
that quirk with my platform where the wireless card would have woken up
for writing the hibernate image, but then never told the AP it's going
to PS again because the machine just turns off after that...

johannes


--=-1ddYne5nYseBLy4+zmVs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKD/M6AAoJEODzc/N7+QmaUR0P/2F/JRnpv1Be9uFHYaCTqSeS
7o9FVEiN1rx2qTwLTAbpFvUqFAOyOPsD2xQL+0MzXUxDDdPRZctaUpzHqfONyPtg
IFziVZB5VoTN2i+SZtyul38VjEbtWrmS+7KJAoe4QFt5AFWMtkTdi4doOsnpn4qu
N4Dyxco7U9h2h2kNZwwi9GTqGnxKYrAKYAXfqNb+iAnZGrjkS6P+DIZyLX//GYz+
w4kAxFpO4QEFsOUrqXNf0wMCPK49lhm9J/y9NNDog/pLZurr6BVl6UXUBVjoH6VD
S3x47fKT/ArYNosXujumZJx1FfTeEpv4SpHEKVjiXGn4gOEGyF7QqVk+Is/DbDMr
HTH6qajAiEHovz9UX/ofawBwo2XCQsFzmyMK4UbUAU3PRE2eL6KnvdHs8QHJgXSB
zX29MG6t64BQ3Xw3fU8Ww6fQf9O7R1A/ABEXm1pL0o3+9w1Km8Y79AyIJXmynqh0
7PwSHSvgzle6ES+GU6Ad2UeOE7ylrPTrZKBi1ZZ8lLf5FnVRV/ezg8qoP1lG/1Fq
aGAv407ylkCu+oDPe6/eTQvNan3baELmkMtk/Jaqd16VRXMIH3Ci/pj4bV1mVRd3
UMzUuJfNwWg0mP6VIZSBDnzEXts2n0c+1tQJusr6Hu7+L19FNnjvNnqlproXPLtH
RD2PV2o1RNo6bnIaAFTc
=yELm
-----END PGP SIGNATURE-----

--=-1ddYne5nYseBLy4+zmVs--

