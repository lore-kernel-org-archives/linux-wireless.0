Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47645 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYBYXXq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 18:23:46 -0500
Subject: Re: mac80211: sta info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>
In-Reply-To: <1ba2fa240802251512k15b40d65oee774acebdb953e0@mail.gmail.com> (sfid-20080225_231210_051095_E46CAEAF)
References: <1203677069.26341.52.camel@johannes.berg>
	 <20080222143745.GB3067@tuxdriver.com>
	 <1203693409.7082.30.camel@johannes.berg>
	 <20080222155704.GD3067@tuxdriver.com>
	 <1203972413.13162.163.camel@johannes.berg>
	 <1ba2fa240802251450x4ee13b94yb93e64fd9ebfcec8@mail.gmail.com>
	 <1203980105.13162.182.camel@johannes.berg>
	 <1ba2fa240802251512k15b40d65oee774acebdb953e0@mail.gmail.com>
	 (sfid-20080225_231210_051095_E46CAEAF)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S4OlpTpe9iFxLVzKpowH"
Date: Tue, 26 Feb 2008 00:23:32 +0100
Message-Id: <1203981812.13162.187.camel@johannes.berg> (sfid-20080225_232351_221938_634844AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S4OlpTpe9iFxLVzKpowH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  > The problem is that RX a TX BA establishments usually happens
> >  > concurrently for single STA, those are independent state machines.  =
We
> >  > have to review this carefully before spinlokcs are removed.
> >
> >  I wouldn't want to remove them, but it seems overkill two have two
> >  spinlocks. What I'd like to do is remove the ampdu tx, ampdu rx and me=
sh
> >  spinlocks and instead use just a single one for all three uses, and th=
en
> >  use that one to protect the flags as well.
> >
> >  It seems to me that even if the RX/TX BA establishment is happening
> >  concurrently then it's still serialized by the frames on the air so
> >  ultimately can't actually happen on different CPUs so the lock won't b=
e
> >  contended.
>=20
> I'm not sure about this, this is quite gentle and requires heavy
> testing.  I'll try to review this with Ron tomorrow and all other
> changes you've suggested.

Thanks. Yes, I do realize that this is a bit intrusive. On the other
hand, I can't see the code holding the spinlock for longer code/periods
of time (nor should it). Or do you think the driver is allowed to call
into the AMPDU TX setup path while being called from the AMPDU RX setup
path? That would be a bit weird.

> Do you have any setup to check your these changes?

Unfortunately not quite yet. I have an 11n AP now though, but broke of
one of the antennas, I'll need to see how well it works.

> Currently there is known possible deadlock when unloading driver while
> heavy HT traffic. This is happening while treering down BA session. I
> need to solve this as well.

Interesting, where does it deadlock?

johannes

--=-S4OlpTpe9iFxLVzKpowH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8NN86Vg1VMiehFYAQLiog//a0O8gmfniRNFlN6jUzQ5irW2KIJ7wzd3
Il+LNEioaZRwvWA8wMvEIaeKOxNsmCkGrM+TcVFbfgPXOpTyz/D9atlxKQGs1plK
2VSHRRZU+BlgZdMMeWtUzU5RgRm6I1CapSPGF0SwvOoInog8PJzrzsnbYsDhR1LH
q/zeVeFCL9OcOn84UWfa+2sBYXrAdu+QcPlxmA67S/JpYsLuR3RsVALIhMYTHdek
V2aAujh93sK20enXiodWu6bRmvFH13wJv+YWiFhmoOsUHW6tcNz24Jtre5h5KTxw
oODe3hwOLGLzev9iL15AXmcwrgrdD1Ki8xJImlKCUjo3fS/2rqG1mpmtFJPeNeSq
i4yy5ZuZabQ1M46TtSrSpeanMfIrPx4mjyh4OvPoBkYVV8OXUR+NF9V2X/VrQsgu
7wCUjq8ldp8WEQF+k677m+hiUM7COlXWAiMup2IWv0X9lk5bbKN4g+o/rzFmMJ6A
I9SleZk5N+c+JGnGAU6MQ1GvKZGNRHbYvbczlUo+BBDUeHFFCHAQ1Zo5oCaAKAhb
K3JCqvo1LLNPVK4jlaUwSK+NZ5hcZLLOdyFxGjduvPOohbqnepd65wHEzIMQ3Jur
AucWCLW8pnjw99HKKLOiThOv1q1GaVX+Ds4up3uz4Gcxe/lMWONlZITkbRqb7Qwx
7B1ZsSFWSRc=
=IQ6d
-----END PGP SIGNATURE-----

--=-S4OlpTpe9iFxLVzKpowH--

