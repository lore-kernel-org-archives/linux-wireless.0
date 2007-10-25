Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbXJYNW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:59 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2fn-0000f2-8e
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:56 +0100
Subject: Re: [patch 4/9] cfg80211/nl80211: add beacon settings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20071025093715.724036000@sipsolutions.net>
References: <20071025093618.440937000@sipsolutions.net>
	 <20071025093715.724036000@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zKcIYSchHMr59nqe7ctB"
Date: Thu, 25 Oct 2007 11:42:37 +0200
Message-Id: <1193305357.6092.9.camel@johannes.berg> (sfid-20071025_142304_570494_6DEC6550)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zKcIYSchHMr59nqe7ctB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-25 at 11:36 +0200, Johannes Berg wrote:
> =20
> +	NL80211_CMD_GET_BEACON, /* ? */
> +	NL80211_CMD_SET_BEACON,
> +	NL80211_CMD_NEW_BEACON, /* ? */
> +	NL80211_CMD_DEL_BEACON, /* ? */

As you can see, I currently only support SET_BEACON. DEL_BEACON might
make sense as well, and NEW_BEACON could be used when no beacon is
configured (SET_BEACON would fail in that case). Right now you can stop
beaconing by removing the beacon head which admittedly is kinda nasty.
If I did del_beacon/add_beacon then set_beacon would fail with no beacon
head, is that better? Further thoughts?

johannes

--=-zKcIYSchHMr59nqe7ctB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyBlDKVg1VMiehFYAQIs/Q//Xn+LVHFBIjNaCE2FMLsgC7ZrP+igvijH
eFL668Hwceguu9d8Qt0F7eq5brAZD7dwRT7b2MYW8HmSI8OixLgzOdAK2rTVyk3X
eco0BpG/RZWiao7aR+Rk2ORtR3EaFJAc5R6AmnCFY+qwSETl+He8SSjaRhdvxn6i
idOz3z6hrMlR1MSfSOmw51VMpNY+s7kn3btxq4uKFyT1O6ezlI9StvDsz0bKaLfa
Xlvf0aTvo1lby/A7u/oOEywAv8yiFBaSX7m1Pjsbq2Z2NnAvAN/x5UfJzzlViSsq
ylPDNk3R6rJUR2fp7lculLjfrSDPbD3UaY6H0F4fwo0MkBofAnJXtDCogHPSBBuL
NoxK6DiEMo92yAJMc1gUBuLMjOKONac4o9G01Zt70DIlBTkztvrDX1Y6+lsXHiOp
wZYipUuyUQwbtkN/3nDIq2+eAKD8YzzheWQPUx+OrX2bAcaYaJHGKveE6Y+lofgN
21v8hxBGRlRyAxqtlYY7lvhVbzj4sBkrdeW8HGFhdJ8o40ubJfGv6ABFoZD4o0O9
78goLt3lOTS9bE0BvS/EEIm7t37bKQz+sWUcQbfWQN3UxWYb+Ect6mmB5iy/+2fB
1wF3t9ThrOda30jTdmmcG44LckEWxhJjHxuyRk52/iNco4NlYVDF4RXvOaZ2xhNe
fSA+FVGJolA=
=xKma
-----END PGP SIGNATURE-----

--=-zKcIYSchHMr59nqe7ctB--

