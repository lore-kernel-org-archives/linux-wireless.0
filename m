Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38066 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbYLFP7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 10:59:39 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Henning Rogge <rogge@fgan.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <200812061646.36044.hrogge@googlemail.com> (sfid-20081206_164640_445951_82A87A7B)
References: <200811252131.30161.hrogge@googlemail.com>
	 <1228575081.16752.8.camel@johannes.berg>
	 <200812061603.21930.hrogge@googlemail.com>
	 <200812061646.36044.hrogge@googlemail.com>
	 (sfid-20081206_164640_445951_82A87A7B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+tlwKDXCwxtZCckGZ7R3"
Date: Sat, 06 Dec 2008 16:59:32 +0100
Message-Id: <1228579172.16752.21.camel@johannes.berg> (sfid-20081206_165943_925411_4E3DE63D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+tlwKDXCwxtZCckGZ7R3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-06 at 16:46 +0100, Henning Rogge wrote:
> On Saturday 06 December 2008 16:03:16 Henning Rogge wrote:
> > > I'd rename _TOTAL to _LEGACY and remove the calculation for MCS rates=
,
> > > that way it's obviously clear what you're getting in userland.
> Okay, after reading your mail a second time I understood you...=20
>=20
> I think with removing the total bitrate for 802.11n we will just make the=
=20
> userspace interface more complex. You will have to look at four different=
=20
> things (flags, MCS, guard interval, legacy) just to get the bitrate, whic=
h=20
> will be the typical information the user wants to know. Is there anything=
=20
> nl80211 will gain if we don't put this value inside for all 802.11 ? We c=
annot=20
> drop it because of 802.11abg, so why not fill it with useful data ?

For one, I'm a bit concerned that the calculation is fairly complex, and
may not always be necessary; especially divisions can be expensive on
some CPUs.

Also, there are duplicate numbers possible, so just the pure bitrate
will _not_ actually be "the typical information" because it's not
specific enough, when debugging, for example, you will probably need to
know whether it's short-gi or not.

johannes

--=-+tlwKDXCwxtZCckGZ7R3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJOqFhAAoJEKVg1VMiehFYMZgP/R74Z5P/mLAI69byotdbWhAr
ttjuXFFxEghY68ruTR4ZEHrh2acwJRGWPzOJBnVObfhpOetOhVTxVc4gL/rcRUa6
BGfpdaDNS0WxMw/v071cspB96i1+ZZ8u4TrsymmSoSffehX5wywh16w7olB/n9NE
qB0WeE+QS6sM4Kf7L/j2exa5XXPJJJKxIIeVMd0ylXDjKBfML2IMm3sk/TT15xvD
qWAvZqfBKuexAHBId5JroRg3AmkGpfS+qa9dsfzDkNbhheams1Krz+i4UYm+H8sI
3Qhq/RQ/McrxiULeU9Vy6bZZ7/lIpZUKLb5JTfUvvWPMR80h7ntO2Q5HUcPGz0yj
0uxfPcXsz2ZQ5CA+ZmqQ9t8wpgfUTfUuAQ1nm+mEZvgRvFOIeoicyDSTbJ6ans09
8VeSn2SO1Um37+MdaNPEMOrhW3ZGbhrOLuPGaWMZ8IssPkd39BYfqus/vFOx7gv8
k7+8rAWvMZT/o4qWKUMtQN9Rc8CraumIVDye6smosoUzpCHDuZqg8ZC/w2QItdZw
Pta7nOsjh8fChaxw2WF5obGiltTLLowD2tM4plJNA9e5VTo9U5/RiyBPqCuByMXr
6FVjouDTEx3rxgSYU8K6oISfw+7JFGixkZyVK706nkdg62UXr2SXHJN53mTQzd4i
IM2012pCB3dwbFTQ8W5t
=RBus
-----END PGP SIGNATURE-----

--=-+tlwKDXCwxtZCckGZ7R3--

