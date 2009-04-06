Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbZDFKZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Apr 2009 06:25:35 -0400
Subject: Re: b43 WARN_ON
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200904061212.10398.mb@bu3sch.de>
References: <49D97CF5.4040808@lwfinger.net>
	 <200904061212.10398.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AG6c6oFSEO/2Yk2GUmGW"
Date: Mon, 06 Apr 2009 12:25:29 +0200
Message-Id: <1239013529.13407.6.camel@johannes.local> (sfid-20090406_122538_596553_AC1A0350)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AG6c6oFSEO/2Yk2GUmGW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-06 at 12:12 +0200, Michael Buesch wrote:
> On Monday 06 April 2009 05:54:29 Larry Finger wrote:
> > Using the latest rfkill patches posted by Johannes, I am hitting the fo=
llowing
> >=20
> >         if (WARN_ON(!wl->rfkill.registered))
> >                 return -EINVAL;
>=20
> I think we should simply remove the warning.
> In the previous rfkill implementation I had a reason to _not_ warn here.
> (It had one valid codepath where it was called. I don't remember the deta=
ils...)
>=20
> Anyway, please feel free to do a patch that removes the warning (but not =
the check).

Actually, I think the check is invalid, or rather, rfkill.registered
needs to be set before registering the rfkill struct.

See, right now, and I'm not entirely happy with this, during
rfkill_register I call the set_block callback. The reason I'm not really
happy with that is that I said calling driver -> rfkill -> driver is
bad, but on the other hand due to locking constraints across the
subsystems the driver cannot take the same locks around rfkill_register
as in the callbacks.

Additionally, the driver must be ready to service rfkill calls _before_
rfkill_register() is called, everything else results in a race
condition. Compare with the shared interrupt handlers, for instance.

The reason I call it during rfkill_register is that I need to sync the
software state to the driver's block state, and that needs to be done
somewhere. Doing that from a work struct would be possible, but wouldn't
solve the locking constraints nor would it actually help since
rfkill_register can potentially sleep, so the work could still be
executed before rfkill_register returns -- the driver still needs to be
able to handle rfkill callbacks before rfkill_register returns.

Therefore, the warning is spurious, but because of a driver bug
elsewhere -- I think the rfkill.registered =3D 1 assignment should be
moved up to before rfkill_register() (and be =3D 0 again if that fails
unexpectedly); I'll do that in my patch.

johannes

--=-AG6c6oFSEO/2Yk2GUmGW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ2diWAAoJEKVg1VMiehFYKycP/2qnl+mRlgxilTJaLrcGP07M
tc6nQiWq+KM2ISF4HicMQpVifOpGV9SFTxMorPVYbd8iWAW5bk66P5oWRxZ1Z56U
j5ExH1r336y0laMCXWWOkEoU6TsCerBNucIbVx8OGpJmZwKfvfPgcGO3zsvWt/4A
iOX/E1kNlkqyzxTkjrt4hU3x9H82/Btmnmr8t/gZVHy/Gb/RkSbKfmkDTnRoapl3
hn7zcXBt2TO3Qi1VfAQbSVgahOMSlGFCRDczPYN0+YUQGA1HVmtJsrptCiBQQU70
6zKurfaTTRiRChAAyt1/E3H6MmpmnzqYPiDs44kKYxM9UXyRSCMVY3PSx7btVRcB
pHXJh03AeVCqV1YnaQeV42XIpJiRTxlXUbOp87ccyhjtCmNeWyCH60dJZE6jXrYc
p6wlGAihk8c+8Qav9Gh2nRqxWPOjrhfIun1yjnqPpsLbBlgJhXle/obPg8ukQST0
atDX+xui7GPrS2jg6iNMAZr4fZBdkIVeWNoVqV9E6GzXQdJsKYnG6+/iztf6tXKg
tke6oFovjJ13rN9F7xsBKDlovQIEJ9dLm/1loFkEWADYrP6tBDQSGfkPEGvmjTe7
+VvJQWZZYiSOzcGnavFWktfo2+82rCeodZeoeBG7jgEO+0qPdYc4q213mlnJYrp8
nNoMT6z7bIZUJH2Z03Ji
=UBDR
-----END PGP SIGNATURE-----

--=-AG6c6oFSEO/2Yk2GUmGW--

