Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbXI1Ic5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 04:32:57 -0400
Subject: Re: A-MSDU deaggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Tomas Winkler <tomasw@gmail.com>,
	mohamed salim abbas <mabbaswireless@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <20070928013956.GK27241@jm.kir.nu>
References: <1189354526.4506.25.camel@johannes.berg>
	 <1ba2fa240709100441o421653fbre410df615e7d9e10@mail.gmail.com>
	 <1190747966.18521.320.camel@johannes.berg>
	 <1ba2fa240709251624ycb516c4t90bcb6846800b18@mail.gmail.com>
	 <1190792394.18521.354.camel@johannes.berg>
	 <20070928013956.GK27241@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cJ73BB9pZWbdEBiLo6/a"
Date: Fri, 28 Sep 2007 10:34:10 +0200
Message-Id: <1190968450.5021.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-cJ73BB9pZWbdEBiLo6/a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-27 at 18:39 -0700, Jouni Malinen wrote:
> On Wed, Sep 26, 2007 at 09:39:54AM +0200, Johannes Berg wrote:
>=20
> > So any STA can actually send EAPOL frames with an arbitrary destination
> > MAC address except our own into our 802.3 interface. Hence, it looks
> > like the first case above is only for having eapol on mgmt iface.
>=20
> EAPOL ethertype is not supposed to be bridged, so it would be perfectly
> fine dropping these wherever it is most convenient to do.

Not sure I understand. If it's not supposed to be bridged then I hope
the bridging code knows about this. Otherwise, we can fix it. But I
don't understand the second part of your sentence, I was actually
proposing not doing anything special to EAPOL packets at all except
accepting them unencrypted.

> > The only problem I see with not doing this is that hostapd will have to
> > listen for EAPOL frames on all VLAN interfaces but I suppose that is
> > doable.
>=20
> That's fine. This should be doable with just one packet socket that is
> not bound to any interface or alternatively with multiple sockets (one
> per interface).

Good point.

>  I wouldn't be too concerned about the extra cost here as
> long as the other EAPOL related silliness (e.g., the difference in
> encryption of re-keying packets in 802.1X with dynamic WEP vs. WPA).

That sentence seems unfinished?

johannes

--=-cJ73BB9pZWbdEBiLo6/a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG/LyC/ETPhpq3jKURAoFbAJ9BdmZtg+fjSaUIPOUuwuOd/R+ClACfRfEU
/z5bzyh0i+r4QXM1t5GMHKA=
=VYKR
-----END PGP SIGNATURE-----

--=-cJ73BB9pZWbdEBiLo6/a--

