Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42921 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYJFNFK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 09:05:10 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223298090.11272.167.camel@violet.holtmann.net>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 (sfid-20080912_041007_653566_F8146EC3)  <1223296221.15196.6.camel@johannes.berg>
	 <1223296592.11272.163.camel@violet.holtmann.net>
	 <1223296783.15196.13.camel@johannes.berg>
	 <1223298090.11272.167.camel@violet.holtmann.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jY0v7xshbDkk6w/1MEaz"
Date: Mon, 06 Oct 2008 15:04:38 +0200
Message-Id: <1223298278.15196.16.camel@johannes.berg> (sfid-20081006_150515_048975_9E036112)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jY0v7xshbDkk6w/1MEaz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 15:01 +0200, Marcel Holtmann wrote:

> > I have a different interpretation of the original issue, since afaik th=
e
> > value it was doing a BUG_ON on is a value that is only passed in by the
> > driver and copied by the ucode to the response, hence it shouldn't
> > actually crash unless the driver is passing bogus stuff in or, as it
> > seems to be the case here, the DMA programming is completely fucked and
> > the ucode just goes to write to random memory locations.
>=20
> that patch wasn't enough, but neverless we shouldn't crash the whole
> kernel based on this.

Well, I am undecided on yet; it appears that when the issue happens then
the ucode may have written to arbitrary memory locations, if you don't
have an iommu catching it then it may have corrupted anything in your
kernel, so just crashing may be the only way to reasonably recover... I
actually wrote the patch though to make it not crash, so I can hardly
claim I didn't think it was a good idea to change that. But I think I've
changed my mind based on further debugging of the issue.

> In addition they were working on some IOMMU stuff and that explains what
> you are seeing. I never got that far at all. My machine just dies on me.

Well, yes, without the patch my machine dies when loading iwlagn.

> > > However there seems to be some other issues with me
> > > running a 64-bit OS and connecting to an N-capable access point.
> >=20
> > Strange. My test AP isn't N capable though.
>=20
> We had some discussion about the fact the different firmware versions
> might be causing this. Don't have my X61 handy at the moment.

I don't even know which one I'm using, I think it's some firmware Tomas gav=
e me.

johannes

--=-jY0v7xshbDkk6w/1MEaz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6gziAAoJEKVg1VMiehFYlo0QAMIpI0RzsJVMd0XPp6PGaOR1
uzEKf+dwtl87arYrsKCZf042Rh7fk0/R6uOOG9OpUjTNYr/i6LN9Dg5qew5M9rwF
JwiR9WFBtoicLbjc2qAXu2naoslFHsjFLcwFYxIyped+I80Kp3iYnt70IDbf6fEx
ene0stEv5pFom4VTe8P+eaQVfkVnSp/Iudrtf7axDKOxVO7qhv0IgqXvuA99TreX
xjaaAAJylp1HTeu0kFySsPIGRu6omVQEbklOl0X/4HmAUJleFDgHT14Z9ozvL1hB
dz4NObm5d5S6ljZVGRQt8xscj+xInVC45j880sElEB1Zsfz+0rM9F0rcunF7v7ax
8bejKhzfz4ZqHg4N2I6CYE4fEL7dsi6XSE+unu0C3bJwM71P9Ln+uLHiNz6u+lF7
/DxEZJ/iHtCEe0jhu9/y+TeDYYzIM+JpBQiXHSDLFfHj9BH2acvyUax+KYEhs74R
DiDeFOyVJUUWg9CNi0/IfA367yMed9eHhoXiiTvo5KDMG/IZC0q7GigNAkjE18Sv
N0dyjrNXcsf1TGBJAoj7uy0kUq8MLQxtYP9dssRfC8lDo3s1Kz5pA8R4n0pNxQzN
z/ddwd0sKshr/5HV+0h+6HX3uISYRZ3GI6PayV1X8rDeqtr0EGKnpJsr5TfOUwvg
q+EjoTNvPHy+TlH+e/O1
=IUXk
-----END PGP SIGNATURE-----

--=-jY0v7xshbDkk6w/1MEaz--

