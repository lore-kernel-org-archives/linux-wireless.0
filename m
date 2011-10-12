Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59427 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab1JLXYd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 19:24:33 -0400
Subject: Re: Bug#645055: realtek 8188CE ad-hoc mode not supported
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: 645055@bugs.debian.org,
	Antoine =?ISO-8859-1?Q?Beaupr=E9?= <anarcat@koumbit.org>
Date: Thu, 13 Oct 2011 00:24:12 +0100
In-Reply-To: <20111012160135.GK3366@decadent.org.uk>
References: <20111012052940.17383.59248.reportbug@localhost>
	 <1318424918.4024.180.camel@deadeye> <87pqi2s0cg.fsf@marcos.anarcat.ath.cx>
	 <20111012160135.GK3366@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xxlrx9u3BY0QHIIA/FoD"
Message-ID: <1318461858.4024.197.camel@deadeye> (sfid-20111013_012437_392459_F7606C75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xxlrx9u3BY0QHIIA/FoD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-10-12 at 17:01 +0100, Ben Hutchings wrote:
> On Wed, Oct 12, 2011 at 11:20:31AM -0400, Antoine Beaupr=C3=A9 wrote:
> > On Wed, 12 Oct 2011 14:08:32 +0100, Ben Hutchings <ben@decadent.org.uk>=
 wrote:
> > > Can you create an ad-hoc interface like this:
> > >=20
> > >     iw dev wlan0 interface add wlan1 type adhoc
> > >=20
> > > (you'll need the iw package).
> >=20
> > Interesting - this works. Didn't know of the iw tool. But this creates =
a
> > separate interface, kind of odd!
> >=20
> > The adhoc mode works like that. I am not sure I understand why it
> > doesn't work with iwconfig, can you enlighten me?
>=20
> iwconfig uses the original WEXT (wireless extensions) configuration
> interface.  This interface was never very well specified and was
> implemented in inconsistent ways by different drivers.
>=20
> The newer configuration interface used by iw, Network Manager and
> other tools is nl80211 (netlink for IEEE 802.11).
[...]

I looked a little further and saw that nl80211 does support changing
interface type (mode).  But this driver (rtl8192ce) only supports
creating new interfaces, not changing their type.

Should mac80211 drivers generally support changing interface type
(change_interface operation)?

Ben.

--=20
Ben Hutchings
Quantity is no substitute for quality, but it's the only one we've got.

--=-xxlrx9u3BY0QHIIA/FoD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATpYhnOe/yOyVhhEJAQreYg//Rxa5KxvXQYh2hhU1+/9VhbWnBh10xqvs
zB30s9DiJLejShUSZ4JDueFQNwdiVNbsOlLADAapvXkdIkU5NUViRFofHYkvnQ9J
MnfcAIcAlgCzZyxnBXCmkoJ6m1xt8E8fH9j/JzU2jOH8Am41HrLLFl8brLeXncoP
6K0ahJV1m8QBlkgDQQ0VK3ZmJ7Rfgy7JwsfaDtw3iD2koFgq5CY/AV+2qqMGkA5o
I+D4sMvWPZ8KQX1J3xBs+3SJsDzsOlcAHYuBhf6r9TlqavkbySA4Z9qUzDMpVFW2
vDaP63gFydR6GUFrLFEfbLa/HGpikxtH1H5VAq3fMqsrofYUJoZ1Oex4vtsrmn1w
l/JILz3sXab19koyg2pHDK9hFletEIZNCZ4WI6ntxlqkDIh14RRqQBpzCPu/VUWK
dky/N/bBxhZBGgZQPTmeR7Za41vAAIdUVLCyy8ZDSUoo50MDwBwpY6/EXLWOdUeq
CI8qEISopEDlIbX+yPsS+utQSObkaFvG/XDA1hvvqz1KaXJ+oW6P2s0bMUcLpDz1
R1IdhJr/5N+1acrpgguAj4/WmItxJk/T0dc9ZxKDtR51Em6onPwMhYfZTTE9fBo6
pr+rlfaGcAVnpTq2LXAcQZ+6uHRk82s4H+bK0sKNPo3O+JhgeY3sJmynjq5tk80G
CX1Erslu0x8=
=Rhu/
-----END PGP SIGNATURE-----

--=-xxlrx9u3BY0QHIIA/FoD--
