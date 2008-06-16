Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383AbYFPQpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 12:45:24 -0400
Subject: Re: Management frame protection and packet injection from hostapd
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080616153421.GC18479@jm.kir.nu>
References: <20080616143308.GB18479@jm.kir.nu>
	 <1213627991.3803.38.camel@johannes.berg> <20080616153421.GC18479@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LOvZR/iWRCdoy9XecMUQ"
Date: Mon, 16 Jun 2008 18:44:44 +0200
Message-Id: <1213634684.3803.43.camel@johannes.berg> (sfid-20080616_184528_507886_E873544D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LOvZR/iWRCdoy9XecMUQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Yes, as long as the STA entry is found (and it should, in this case),
> the pairwise CCMP key is used both for data and management frames. I
> haven't done full testing yet, but I would expect this to work even when
> the unicast management frames comes from hostapd.

Yeah, it should.

> Broadcast/multicast management frames are protected with BIP using IGTK.
> This is similar to how GTK is used with TKIP/CCMK for broadcast data
> frames, i.e., there is a default TX key index that the AP uses for the
> frames. Indexes 1..3 are used for data frames and 802.11w is using 4..5
> for BIP (even though the key index space is actually completely separate
> from the one used with data frames).

Ok, thanks for the explanation.

> > Yeah that sounds like a hack. I guess it should work just like when we
> > submit a unicast frame via monitor with the radiotap flag to indicate
> > that we want encryption, only we should add logic to look up the defaul=
t
> > key to use if there is no peer/unicast key by the outgoing MAC address?
>=20
> Yes, we already look for STA entry for unicast and that should work as
> long as the STA table is not per netdev, i.e., both data and monitor
> interface end using the same STA table. If no STA entry is found
> (multicast/broadcast), we look for a default TX key, but this is only
> done for the netdev that was used to send the frame (which is different
> between normal data interface and packet injection via monitor
> interface).

Good point about the STA tables there. I guess we really do need to bind
the frame to a certain outgoing device to use that sdata state struct.

> If the monitor interface were to look for the default key (or well,
> keys, since there are now two; one for data, one for mgmt) from the data
> interface (somehow bound to the monitor iface?), that should work here.
>=20
> > OTOH, that would break for multi-SSID/single-BSSID scenarios I guess, s=
o
> > we probably need a way to indicate "this frame belongs to interface
> > index N"?
>=20
> Yes, either the frame or maybe more easily the monitor interface would
> need to be bound to the interface that is used for key configuration.

Yeah, either would work, for per-frame we'd have to extend radiotap but
it would probably be better as it would allow hostapd to use the same
mon.wlan0 interface for all BSSes.

> > I don't see any such problems, but if I were to venture a guess it's
> > because of configuring keys on a monitor interface. It sounds like
> > something sticks around within the netdev:mon.wlan0 subdirectory, then
> > the code tries to delete the directory and only afterwards is the entry
> > removed, leaving the directory (and the parent, of course) hanging
> > there.
>=20
> Yes, that sounds likely since the changes I did for debugfs were very
> trivial copies from CCMP/data-default-key processing. I'll debug this
> more and try to figure if there is need to re-order something or make
> the debugfs entry removal able to handle such a case.

Ok. I don't know right now, and it does seem to work correctly here, but
maybe it doesn't when the application doesn't explicitly remove the key
or something, I'll take a look.

johannes

--=-LOvZR/iWRCdoy9XecMUQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIVph4AAoJEKVg1VMiehFYZTQQAKCutL6fJbaRIk81oM1byqCH
7Dw1jQhSezp6aMdki1LqRrNDz5zu6o9O7S/th3Y+zO8XFPiTlGPEb9IVZKWMJjhM
kjXk+UEEQ0Ykxu8APmi7d/C7j3O0Wzy/lq+dsntEi32TfL/U5EkmX3s+taZWgsP0
3m80boo1WKdF8QokmYLAxk5uzdEvc7F1UJcGjAcGOxj1prl6K/9xlAiJgt1u6Hsd
GO4mfcmmh43P7DzuGGp8pAWR9VfaIO+Bh9Dr/gkLn3MwPKCdObT5EW2hLqSGWo8U
30TQXCJBB8sLmZxKKxtQhW1emcB6u/ku1OT0A1kQDCB0N0aFwffLF0xGlOClRMZY
PV1ClcnLuunVrBOQeT/Pj2FEt84RJNxISMwfvDORJTC4kj86n+DU6uc/xLVEHSBc
MlITRojAokMWxK74avIlnojvBhFNP1EKkwhVKy1Ihj0BFXtk4olvAw0yZzIOga1o
q7R6QWp9PBAHao39QrjETXLnKhGTveTrzyta99RhNuC/so1jH4szE+sF8jtBPLM0
LJoQnVEU1k4IfJ7D+5OIvNmuqqzKDv/Gzi1r9Y9mND9VrUrcAn7G/LQPcq4e/yTb
Txqqi5taugaS5IeOXZ0X8NoMcFvSI3XbUjn2FZxmbLi4DmOrk0wQdX5xnJ1K2/3m
9wR7Y9hwkTL1ZRQfhY+j
=rkev
-----END PGP SIGNATURE-----

--=-LOvZR/iWRCdoy9XecMUQ--

