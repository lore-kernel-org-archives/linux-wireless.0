Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZC2STl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 14:19:41 -0400
Subject: Re: [RFC] b43: rework rfkill code
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <1228927898.19553.164.camel@violet.holtmann.net> (sfid-20081210_175153_795919_88125CBB)
References: <20081210150935.GA10927@srcf.ucam.org>
	 (sfid-20081210_160955_698729_A777A57C)  <1228922997.15837.6.camel@johannes.berg>
	 <1228927898.19553.164.camel@violet.holtmann.net>
	 (sfid-20081210_175153_795919_88125CBB)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-46iDqoY735xsE3ZYCpOZ"
Date: Sun, 29 Mar 2009 20:19:31 +0200
Message-Id: <1238350771.24972.11.camel@johannes.local> (sfid-20090329_201944_361714_1B1E1532)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-46iDqoY735xsE3ZYCpOZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Marcel,

> > We're going to have to integrate rfkill with mac80211, but nobody cares=
.
>=20
> if you figured out on how to do it the best way, then let me know,
> because I have to do the same thing for Bluetooth.

I've now rewritten rfkill [beep] to [beep] -- the plan for mac80211 now
is to have _it_ register the rfkill struct, and let the driver only
provide the hard-block state (or a function to poll it where necessary),
and handle everything else via the regular config call in mac80211 with
radio_enabled. Then mac80211 can also react on unblock by reassociating
or whatever.

johannes

--=-46iDqoY735xsE3ZYCpOZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJz7uwAAoJEKVg1VMiehFYxiAP/0UIAzUdbtrcYboGw3aExYKg
1an+fOcW0XDYNNURfeLH8jLOp9FnSy1ls5b4EgNHHRIApLQaHstPP+FKzm2Xdy5x
K9PZ2jR8CudoCxbxmiAo7vZETWCTD2wfbsQYyDdaJ4lBqPpyd13riRNBmIwLA5t4
niC0VUK0nHbpjGPAnccgZitdZELhfjqUUf/nEeAMDkQdXCczlgG7KVQeBFXVvisl
inG6lnaiSCLlqWraDCwrCoSX+0XgzIjZgEylYLkYVyJZpM0K3dTl+yT5UDbye6NQ
iMABTagdbpIbsKQfNni37Oat8LwAPGq7qG++TaTFGp147FT+JTeQ9f3LjLGZ4X+4
FVv9XaAThWPzT5hN2Fw+DhjvZ+3iP6U5yD/elduBMk8Q4H1L/eSDwoXdvDpJNqJJ
xOwB4pmysyb9J5GN9fumpitsHGzpY+M0U1IcsJwg1FI2ufI/HQJrdo0l4Sk6O5Pk
Hvz5uXni+AzlyqWXvPF1F4cX4YqqXPdblSb1Wc2ieKUlZgk2EvJ1B94S8wg2+UU3
WaWwzFJikRTfzLLU6q69KVdI+niUMZOskCZ31/xAK84ZGpuMwWAdrky/z2afYvu1
RIevJDhSKOsoHLHvrehKEopyT0liBS2+B6acirulxMtFIiGdIlv62R44pixpo7l1
18kb9Qa8r01J/Ik65g+u
=GV22
-----END PGP SIGNATURE-----

--=-46iDqoY735xsE3ZYCpOZ--

