Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190AbZD2I2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 04:28:44 -0400
Subject: Re: 2.6.30-rc3: iwlagn probe timeouts (regression)
From: Johannes Berg <johannes@sipsolutions.net>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <49F78F40.1060904@gmail.com> (sfid-20090429_012115_069726_86F3227D)
References: <49F4F5B1.4020201@gmail.com> <1240852777.29221.6.camel@rc-desk>
	 <49F76DF2.5070704@gmail.com>
	 (sfid-20090428_225846_755730_3AFA4A12)  <1240954959.593.5.camel@johannes.local>
	 (sfid-20090428_234319_487972_6219E84E) <1240955255.593.7.camel@johannes.local>
	 <49F78F40.1060904@gmail.com> (sfid-20090429_012115_069726_86F3227D)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-kt3JHYCnkO3dOqKl0JMx"
Date: Wed, 29 Apr 2009 10:28:08 +0200
Message-Id: <1240993688.593.16.camel@johannes.local> (sfid-20090429_102850_844911_D5B6BAEE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kt3JHYCnkO3dOqKl0JMx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-29 at 01:20 +0200, Niel Lambrechts wrote:

> Thanks for the help, reverting the commit did indeed fix things for me -
> I tested that earlier this evening with the latest git kernel...

Ok, thanks.

> > Scratch that, try this patch instead. Sorry, stupid mistake! mac80211
> > never asks the driver to set a txpower level, and keeps the variable se=
t
> > to 0, but the driver looks at it anyway. Bug on both accounts, I guess,
> > but mac80211 should set the variable and tell the driver anyway.
> >  =20
> and so does your patch, although I had to patch by hand, as my version
> of the file still looked like this:
>=20
>    local->hw.conf.long_frame_max_tx_count =3D 4;
>    local->hw.conf.short_frame_max_tx_count =3D 7;
>    local->hw.conf.radio_enabled =3D true;
> +   local->user_power_level =3D -1;
>=20
> Can I more or less bargain that this fix will make in in time before the
> final 2.6.30 kernel is released?

Yes. Thanks for testing that too. I'm sorry that it was such a stupid
bug and you spent so much time hunting it.

johannes

--=-kt3JHYCnkO3dOqKl0JMx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+A+VAAoJEKVg1VMiehFYdsUP/jPjWLY0JSzlBLLhvIvkUNFp
u98hGeBmTA/UyEW0SnYv9jRN4Db4GeTE6sMpZbqLC8fZHlcyv/bxjgNmoR/BcITb
mA7LvPxsIsknxmtPNoW8UcsIFT2CsPy2HS+52K8n7ljd/KMRRmwpoqmXTN6GEzZQ
PqMYAIXC7tWZn/m9sGFjpevEI2rpuBtvZskf1awb+vdy/JZg1RuqLY58M3G8JdQg
Wx8QbeK+HFFwVEl2f9cv+Tlk6fFux1o2tRZV4pUfWGU6VpjJvrTUFcI6Bnv1arTH
hLBDbhrKwFx9X7EDVqtHOVfbVHAA0Shni5fahvaruaTpRqrjmi4tKX/rCyidxonb
9PGXag8Nx2NuUU5kHZtzMbCKdA5lQLwk1BhRcmnS8zEy33yTmusb609ipTj6GUCK
l0JP9zbcwnd4qyxj5GNOvZVdliR0TXJMKJcYJE36fBJ3iVcS5a/UjuhKLDa9nQrh
StJz8inazizOfK8oJ07KnnBixXnTeCY7PLok0ctRzk/wsTbOvDUbFI+cWi8O1odq
Bf6R0HCzwQ2KFDBjbNJw/rd5bqRVTAXNvd+PkjlHZMVz07DABirvAJZO/5Adt9yL
tCON6NjNpoLiAB6ifyqK11Rlt8kOz9ve95Bm3f+6mmU4m8FRqbwv2KIW2MbXYa3F
sYZbHE/fJZ2Ei/Vt3S3g
=t7cN
-----END PGP SIGNATURE-----

--=-kt3JHYCnkO3dOqKl0JMx--

