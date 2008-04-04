Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbYDDOqg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 10:46:36 -0400
Subject: Re: [PATCH] mac80211: notify mac from low level driver (iwlwifi)
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mabbas@linux.intel.com>
In-Reply-To: <1207264130-25437-2-git-send-email-reinette.chatre@intel.com>
References: <1207264130-25437-1-git-send-email-reinette.chatre@intel.com>
	 <1207264130-25437-2-git-send-email-reinette.chatre@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N0XWrX6iRtEPqJ1JUpYc"
Date: Fri, 04 Apr 2008 16:46:29 +0200
Message-Id: <1207320389.19189.30.camel@johannes.berg> (sfid-20080404_154640_330295_9FBC992D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-N0XWrX6iRtEPqJ1JUpYc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> + * This function must be called by low level driver to inform mac80211 o=
f
> + * low level driver status change or force mac80211 to re-assoc for low
> + * level driver internal error that require re-assoc. A good example to =
use
> + * this notification to call mac80211 after suspend/resume, some NIC req=
uire
> + * re-assoc.

I think the suspend/resume text should be dropped since IMHO that
requires more work, reprogramming all the hardware crypto keys for
example.

> +			/* No need to wake the master device. */
> +			if (sdata->dev =3D=3D local->mdev)
> +				continue;

That looks like a copy&paste bug, we're not waking it in any way. Also,
it's of IF_TYPE_AP so it's not necessary to test this at all.

johannes

--=-N0XWrX6iRtEPqJ1JUpYc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/Y/RKVg1VMiehFYAQLWfw/9G4ds5EwE3KMoGyOUYxFR642CG57vyy4n
r4yx+w/fXOmejbUSmHfDKy0T7c5wgWstnHM3sRr5bKpUMR6aRAmB0kc5W69IFMKF
LNlTC5IRdBfX5wJKF442VyzHtuumn/yjNxJcMG+DIqYAicHUuzpxjdISjnGeRM+z
XFL51AbYulWUGiW45lOGdE2L7kuJt6FHF76AelcIhijInywjRRkZ4DuwTD+HrBqK
FsA2dzXPE401JunUyXsvq0K4TiqQiSrr+Z5pL8pjjNg3pJ4ETkzY2e4eYeMIeWL0
ofzDGdfWuUJcDyS1YLZIDkWjmTsxDAHIWX2UeP/6QUiVP//8D7peJu09Bi5Qg+pe
SX3ZzewSB2gK/CR11oXn3gn1sFd43BsHQpM7RNbeu2xYpvzpewEJ4kh0XeDi/gP2
4mg3U+WYuy5P4F0SQ+Vyw3ARSQgxCZwcEX3AWFT8OwnhatkblGS639ihLQ1isp9V
27iy1bMthLSU0AsoH6jgxp2rvFZV2kqu7DDN8xOh4UDl2Bbr6zytQmb66xctSY3z
jtUl2bemeEw1SZOLfhBdctRgJ4hlMTx6IQvg5h8UG0yMn3CK/6wACrFl7/LWLm6g
LpMs73+169wtHZR8RFgf9ilPWZpK9iqMP9wvZqddLazXeBV9z9jFnLRWyx8nwwQS
y9r+U3tWiCo=
=1/q8
-----END PGP SIGNATURE-----

--=-N0XWrX6iRtEPqJ1JUpYc--

