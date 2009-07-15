Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325AbZGOQGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 12:06:01 -0400
Subject: Re: [PATCH 3/5] cfg80211: add WoW support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <20090715151425.GC5682@mosca>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
	 <1247617320-20163-4-git-send-email-lrodriguez@atheros.com>
	 <1247658322.2302.1.camel@johannes.local>  <20090715151425.GC5682@mosca>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-x8PfWYzBX8mT9GQXNFHx"
Date: Wed, 15 Jul 2009 18:05:06 +0200
Message-Id: <1247673906.10754.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x8PfWYzBX8mT9GQXNFHx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 08:14 -0700, Luis R. Rodriguez wrote:

> Will change it, thanks. I see NLMSG_DEFAULT_SIZE is smaller than
> NLMSG_GOODSIZE (it removes the NLMSG_HDRLEN), but no documentation
> for either, when should I use either?

I don't know, but GOODSIZE is larger than a page or something, iirc.
There was a patch recently changing all the users.

> > > +	if (!(wiphy->wow_triggers_supported & triggers_requested)) {
> > > +		err =3D -EOPNOTSUPP;
> > > +		goto out;
> >=20
> > This seems wrong, should be "requested & supported !=3D requested", I
> > think.
>=20
> The above one won't return -EOPNOTSUPP when you add additional junk, you'=
re
> right, better to just inform userspace of that.

Your version also disallows turning off WoW again, afaict.

johannes

--=-x8PfWYzBX8mT9GQXNFHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKXf4vAAoJEODzc/N7+QmauzkQAIatniMuxVVR+pWO08DpAtNF
tdAq2b4tpfXNOjkZiI8xRhqntHSN8cOBUO1/tHu+nfGi4FAxBgV/YMk9s9DFDGr5
+Os1Oiuy5mILizskyqhhIKcJRZ1Bz95XGqBUz//bnocxS7zcqxNcKt1Bejwt2Zmq
rOQPd3k3/7FZo+Y6iGBJqI4h1KCFyiUi7FF61YbkClUwmQmqN41nSNDvwEsfRupX
vk8j9Cd7luvCot+HBd5SAOzTxKIefFTXeeVGV4YOxZNf+M2lP8r4UpFU85qj318e
q0/RVJ3u5S0NJBWUZB93a5GBeS51wzSBJ80phncfaNhYQ9yTt5RG/cwPvHF5aRi8
KUlogcc7P4GTSBHQIP8limUsX3Ycnor0ak6okKYbc0P2aqUdipbHecOBWvfNBq51
xB3NpJA2H2rVKgfL1Dh7J/S4orSzdbdJFRf+g4Vo7Iqo3c7KR5FFEipvSK8v2YQi
7a6Tm6V+LEDbWBaf0hk/prlfUcXyCf1f/pqqfW3W6M/vjBVdyyw1+NGvjiMmDeOS
c5fYCbT1QaDEQjmAMVJaWDIgsih23aBxQkiTpDGHLfiQcINp82i7B7IeClnizFJE
/iI3D6+Dcn1J9hCwgtuGObGrXCdmWnYALNWA6rUQZHityFIKlXK3zR2HCmrf+EZr
xw7FP567CnsP5kIeh7zt
=cws4
-----END PGP SIGNATURE-----

--=-x8PfWYzBX8mT9GQXNFHx--

