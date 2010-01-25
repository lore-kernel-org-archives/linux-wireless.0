Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab0AYUGP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 15:06:15 -0500
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <43e72e891001251155l504a74fcpf20942682ca340c1@mail.gmail.com>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	 <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	 <1264189560.2593.14.camel@johannes.local>
	 <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
	 <1264205494.7208.7.camel@wwguy-ubuntu>
	 <43e72e891001221623v477b9fady32237c1a3aededda@mail.gmail.com>
	 <1264206170.7208.8.camel@wwguy-ubuntu>
	 <1264250814.2593.25.camel@johannes.local>
	 <43e72e891001251018h1a62e1ccn4a7d1411fa2c0615@mail.gmail.com>
	 <1264444418.23766.53.camel@johannes.local>
	 <43e72e891001251155l504a74fcpf20942682ca340c1@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PgRtomAhcgXiy6mKQR/C"
Date: Mon, 25 Jan 2010 21:06:09 +0100
Message-ID: <1264449969.23766.59.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PgRtomAhcgXiy6mKQR/C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-25 at 11:55 -0800, Luis R. Rodriguez wrote:

> > Although Bob has a point, we could change the way we pass the DTIM
> > period to the driver, only pass it in the powersave callbacks, and then
> > we could associate without it and just enable powersave only after
> > receiving a beacon. That assumes that drivers don't use it for anything
> > else though, of course, but I don't see anything else you could use it
> > for really.
>=20
> Neat -- but that would mean doing the same for other beacon-sync IE
> information. What other stuff goes out in beacons that does not go
> into probe responses? I think I read a thread the other day about some
> WPS information.

Ah, yes, but that's a userspace thing -- and before association too.

I'll need to analyse this in more detail, and also what drivers do.

Kalle, could wl12x1 deal with getting the DTIM only when enabling PS?

johannes

--=-PgRtomAhcgXiy6mKQR/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXfmuAAoJEODzc/N7+QmaosQQAKbsIceI9qRKpZIxaMmXL8Ma
3Daz3f7TpOJrWtW9zwz5TQc5bJbRYv6cE++YwzCBs3P52Wc65DHpj/fcmj5FgI8s
GjRs0sdoH0cF5XS9vydCzhdEReQ8CM7jKsSPluiayzoCCTNYRZVK2pXAeyKGTPh4
sqb6viXsE85SbLd6mRNNI/5KJgMAXDzgeRvxCqF+UxG/hpb3URi4ELVw4FPcw5dF
j39s315rqEBNGLNd0NeMoro9NrtIlVQSdsTgQOhUQZ1fcbqv6BrulPrb3i7aLvKg
HsbsFInFNVLPUlcQ9J9uqm567nu67YsUFESHlzfJSVq9wZyAmWl5zdNaYqsL0NjZ
nMBHJrPiicKX+R7uAsOwV7mk35nNfHDYx5X1gwHc7m4Ll9DYEbGnAPeVmOfZwEfc
MtxbWuzEigNWSmt3TBxi7uVc6sZxOIW8L+2mtIAGOX0Z3KUmcrHM0U4n+1yC/XZ6
kUgEdsCuFUKXlC2eaLtyrEIP4LqVoFnTcmRMtXocaSnR8mRPTcOu63OdaE4K6rwL
vesGmOChaTPmMsTvEAXhdwzy/BbYpKhUXB+hoA6i706jBLcVL6SBIw1lGPzaMtYV
cgKkg5B1fxm+OdjFRCSW+1YyTU5haDtNmemDaPSuWHgCXz+5o3+lDX417N7OjFX4
I5BMklCk5lBskFcGOGvT
=kCak
-----END PGP SIGNATURE-----

--=-PgRtomAhcgXiy6mKQR/C--

