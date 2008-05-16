Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYEPKkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 06:40:12 -0400
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
	mb@bu3sch.de, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, ron.rindjunsky@intel.com, tomasw@gmail.com,
	ivdoorn@gmail.com, peter.p.waskiewicz.jr@intel.com
In-Reply-To: <200805162032.48469.rusty@rustcorp.com.au> (sfid-20080516_123407_138874_003A5D7F)
References: <20080508032208.GA401@gondor.apana.org.au>
	 <200805161201.48835.rusty@rustcorp.com.au>
	 <20080515.215823.28841530.davem@davemloft.net>
	 <200805162032.48469.rusty@rustcorp.com.au>
	 (sfid-20080516_123407_138874_003A5D7F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VZds1be4maOlaCNsOgfd"
Date: Fri, 16 May 2008 12:38:58 +0200
Message-Id: <1210934338.4000.24.camel@johannes.berg> (sfid-20080516_124101_902959_226C9024)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VZds1be4maOlaCNsOgfd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I put a patch in to do exactly that at Herbert's prompting, for 2.6.26, b=
ut=20
> it's buggy in (at least) two ways.  I have a fix for this, which adds a n=
ew=20
> tasklet to xmit the packet.  There's still some subtle race, however, sin=
ce=20
> I'm still seeing a stuck packet.  I'll have to revert to TX_BUSY for 2.6.=
26=20
> if I can't find it (unlikely).

Incidentally, mac80211 has a tasklet for this as well, and I'm pretty
sure it's also buggy in the corner cases (rather than inefficient or
something)

johannes

--=-VZds1be4maOlaCNsOgfd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC1kQaVg1VMiehFYAQKEvg/+IsfkpctQ26S9HoVt4QDI2aeZAHLcQird
PcUmSemFb2uiu4LWey+7ia7D841XYLyrAfV/JmRP+HP68TF2x5SbeXV2AxaNMb96
oitVUqh+SMctAbJ28gF/eekeJ4/7WQ2Iv3I7ywWv+1ZfxREellRjZpe2ix3AVoCc
Ak9bkASOkY7PER7S+gE3+MQlbUQLuCJvQTdc3hAHsGHAv33xKHHnLf4xykKOqq3h
MkFErN4t+XIlV9PCeJEiXcOFFXbfHidDImGA5RUiqBdMAMCD6EVe3ISZoJeRIGSW
wMFEsWBceSpy+ykHkEJn9uo9oDWDTL2CGVMWav1Y20NJSCQyaRh+GNV1kjQTLueF
+6RRIknEvfN3MabU2Uv7pfIMeo1pLPBIDDDeVKfVuC/l6EH+1ywODHrx9ziePyJZ
ljuut5roCMjQAPBU+ZwOe9sEfi78ahFeiHTnKcG1KpFUZ/vUUD3JWvCGbiYgZmI6
qjcN42x2wn9L+xAJuZEvei0HgS9/P/owkq/ybVlPy+IofScV36sXeut8EyN+oLxG
U9hdN4aYltsDq9Kt65D7i6cDmW4R2rb5aTuaf4HWMicfC74OcclvD3DhIPv/xl60
bMdhpZTqj79nh4iArI4GE1YrinBVL05O9UTe5OuxZlztFmjk/gj4zKJze+sRYP+o
b1i39aOtDm4=
=JmTb
-----END PGP SIGNATURE-----

--=-VZds1be4maOlaCNsOgfd--

