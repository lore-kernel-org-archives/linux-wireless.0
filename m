Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbZEMWfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 18:35:53 -0400
Subject: Re: [PATCH 4/4] cfg80211: fix race between core hint and driver's
 custom apply
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org
In-Reply-To: <43e72e890905131529s5e8d6421pde9b80a92f807160@mail.gmail.com>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
	 <1242248682-22051-5-git-send-email-lrodriguez@atheros.com>
	 <1242252539.10076.2.camel@johannes.local>
	 <43e72e890905131529s5e8d6421pde9b80a92f807160@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-S8S0zGDPokYxI+hMMa3H"
Date: Thu, 14 May 2009 00:35:21 +0200
Message-Id: <1242254121.10076.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S8S0zGDPokYxI+hMMa3H
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-05-13 at 15:29 -0700, Luis R. Rodriguez wrote:

> >>       queue_regulatory_request(request);
> >>
> >> +     /*
> >> +      * This ensures last_request is populated once modules
> >> +      * come swinging in and calling regulatory hints and
> >> +      * wiphy_apply_custom_regulatory().
> >> +      */
> >> +     flush_scheduled_work();
> >> +
> >
> > Umm, this is a little stupid, first you queue it and then you flush the
> > workqueue... Why not call the function that runs off the workqueue
> > directly?
>=20
> That was the original approach -- but then we went on a bagwagon on
> getting all these regulatory hints through the workqueue. I can
> address for for wireless-testing but not sure what path we prefer for
> stable. The above one liner seems small enough and would be nice to
> get confirmation from a user on stable.

Yeah definitely the way to go for stable, and we can als put it into
wireless-testing. But I think ultimately we should just refactor what is
necessary and just call the function that would otherwise run off the
workqueue. Can do that after this patch though.

johannes

--=-S8S0zGDPokYxI+hMMa3H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC0siAAoJEODzc/N7+Qma9UgP/0nY8h332LzOL9DbPevF/iOS
WRMIVvXy00Ey/nokrIFGjmPSFZ/EpktJhJ+zetoO4PRSkYoi6pfMzcbeSc5xmJfH
wRodk4i1FTGDezWvFW2Ll7GPmBoubxj92iYg/nRPWE7cmsVOolvPZvg3f6I/Z/Pc
lgDHk66lnCIhUG+zoiR66z5vgKeSCnfqG/Qoy084T0sj2TZrttsOtaHWlPGOE4OH
nSswrjvdfhEfNcFljCPKj3SvulkxQzgovL8YoEzgyJKU+yhJyZRvcvHibOTfihbh
TPx/w+YflDl9Gyo3NbtR1mbPjQFhLAKdylqI5VD7FuZtOraZp4BQA5650cOAz4Zb
eq/sAJ4Xe+DuTC5AyM+cmnkEghoKdn1YMujIHPQA4BRBnDhsos6HE1hn/pTrqDnQ
TjlspCg6Ibj9Etu6QuECUh4f0GwSM5ElyisWcs7GegQOpVJVB/MNWv8Xi3hqB7ZM
7wLCjY75uaZue7dFn+F94rLhGI1o3ZwAVUOAnosA2U+8am4otenCUAMG+zuGaNG0
9FdPExzz5R8HJLnteBQ2598rL+UidxFuDLN+GizyTUrpoF0s08/Aq1WYilH7ljF5
TiyXYfyMUlVAhCFdCGtdPiQ5QjOobcQwzohm93WjaJH6GouOYE4WkiIiALdtLNsp
VCvS4L8mTFZLYngyKdd0
=sMrR
-----END PGP SIGNATURE-----

--=-S8S0zGDPokYxI+hMMa3H--

