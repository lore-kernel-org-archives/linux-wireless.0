Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbYIVWLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 18:11:55 -0400
Subject: Re: Progress on aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890809221233l4dc446e9hdf71fc94270020dc@mail.gmail.com> (sfid-20080922_213349_977364_DF7C63D6)
References: <20080922174103.GF6048@tesla>
	 <43e72e890809221233l4dc446e9hdf71fc94270020dc@mail.gmail.com>
	 (sfid-20080922_213349_977364_DF7C63D6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Mpk73CApmrvZehb/WgmM"
Date: Tue, 23 Sep 2008 00:11:07 +0200
Message-Id: <1222121467.3023.89.camel@johannes.berg> (sfid-20080923_001200_276551_BBDEE926)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Mpk73CApmrvZehb/WgmM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-22 at 12:33 -0700, Luis R. Rodriguez wrote:
> On Mon, Sep 22, 2008 at 10:41 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > Just a quick note on the progress of aggregation. It works but we still
> > need to hanld the rtnl_lock() in a sane way. Johannes we proposing we
> > use a workqueue for this.
> >
> > * iwl4965 has been tested to work
> > * ath9k *does* xmit aggregate frames but throughput is low
> >
> > Since ath9k still needs some work we are looking into it.
> > Tomas, have you had a chance to consider the workqueue usage
> > for the rtnl_lock()? I figure to leave that to you as we
> > are still looking into the throughput issues with aggreation with
> > ath9k.
>=20
> Also, we currently handle aggregation buffering internally in our
> driver so the whole amdpu_queue stuff is not required for us as we
> don't have internal aggregation schedulers in hardware. For now we'll
> use it though as we just want to get it working and for 2.6.27 we have
> not alternative. For us, what will the ampdu_queues represent then? We
> don't exactly have a limit on this except for the standard limitations
> of 16 TIDs per station so what do you recommend to set this to?

You've only enabled STA mode (and maybe IBSS but there it rarely
matters) so anything like 8-16 would probably be fine.

johannes

--=-Mpk73CApmrvZehb/WgmM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2Bf4AAoJEKVg1VMiehFYLIUP/0vpGcem09UqBwkFTBKNgBNH
+I7m4NSKuKGItc8ErZphp+q3qvofZUJlng3x/D0qjz9D/0gIW91WboK5QH3dnjXo
7YmuzP0BJimlIYcnN4PPcByg8mEQznWv/iRS91k8z/tCUy2boCGO8Y5EJXfLC2nu
EFE4oMGkNo6s7asFBLNARTbIJ40PnM4Uyjbl/9uKkd21bfDdeSN+ehDcZ0rcQ2l7
KvhY49sq1GldDDzebai8fMuh1YM4Iup2ob7zl2oXyNZVIDrAeIePQiDDIEDTpV5k
zbS3KDp6NXverM44m5mcMkvs9CFd+Of4MRVeb+NdL8o8T1wqYHlq35syx18Cfrcq
qsFv0vjDbPKRzuoyL8VeDlem5/+mzaq85xwMBuG9Bq1ugsvPJRJUBUym8A/VALYG
WpwXK2Df9KpZmMoyomFGlgZfqDzhXZP9vSbh520K8YOnYnZP6LjilRL9fczifwDj
KcKMltDhcFm6NGJ36vfIJWoLfDZRIJeN2z7Fb7slwplq6N6SyVm/vX5IkaKPyv+1
ZQfhhzJ5Sb+i9uODK7An6KMTkTcoy0bMECT8+8nt8+xYFSGtT3mYDRBVJc6gBRvK
BjuzxSbamdWFknKMJv6KOU4l7nzAIQdoRHrofFO82pJdgEaWIQzqiT9DLseQJVOi
SSabuWnZpFn9F88rJRsq
=HsLg
-----END PGP SIGNATURE-----

--=-Mpk73CApmrvZehb/WgmM--

