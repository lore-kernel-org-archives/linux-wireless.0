Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57155 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105AbYBQJxh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 04:53:37 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <bruno@thinktube.com>
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
In-Reply-To: <20080216022918.18775.59888.stgit@one>
References: <1203088151.8931.197.camel@johannes.berg>
	 <20080216022918.18775.59888.stgit@one>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3/TgtpQbim0XbPkADrOy"
Date: Sun, 17 Feb 2008 10:11:43 +0100
Message-Id: <1203239503.12783.22.camel@johannes.berg> (sfid-20080217_095346_151600_140DB71D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3/TgtpQbim0XbPkADrOy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sat, 2008-02-16 at 11:29 +0900, Bruno Randolf wrote:
> enable IBSS cell merging. if an IBSS beacon with the same channel, same E=
SSID
> and a TSF higher than the local TSF (mactime) is received, we have to joi=
n its
> BSSID. while this might not be immediately apparent from reading the 802.=
11
> standard it is compliant and necessary to make IBSS mode functional in ma=
ny
> cases. most drivers have a similar behaviour.

> [...]

Looks good, thanks for your patience. I have two minor comments still,
sorry for the lack of focus in earlier review.

> +		} else if (local && local->ops && local->ops->get_tsf)
> +			/* second best option: get current TSF */
> +			rx_timestamp =3D local->ops->get_tsf(local_to_hw(local));

This is assuming that we don't manage to process the frame within 192
usecs. I guess that will be true since we defer it to a tasklet, but do
we want to bet on it in the future or should we simply widen the window
where the merge *won't* happen because the driver doesn't provide enough
info and also add the 24 bytes offset here?

Also something else that just occurred to me... You wrote in the
description:

> * to enable this we have to let all beacons thru in IBSS mode, even if
> they have a different BSSID.

which I think refers to the last hunk of your patch. However, hardware
also has such filters, so I think we also should set the
FIF_BCN_PRBRESP_PROMISC filter flag when IBSS is enabled, we don't want
to force drivers to do this implicitly when IBSS interfaces are added.

Again, thanks for your patience, and if you want this patch merged now
here's my

Acked-by: Johannes Berg <johannes@sipsolutions.net>

and we can address these remaining two points in follow-up patches
instead of respinning this all the time.

johannes

--=-3/TgtpQbim0XbPkADrOy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7f6TqVg1VMiehFYAQILDA/+KyrIBToEGXVdoBaKU9FSPGFCMb7DrePK
TsqzZ2BZciC3dW6amwLcIEG+m71ReKP+bMZGLja9crFyfwo9yTQep4eHaPuJ8BTM
dHHwJhzzOqQjJaCQL4WYJ2U6M/PhQe3wKZUgQ2fSKqIMlJE2yPJmVM9/sDRluuu0
f5GTOch+JPWOiTiaFm9EfkbvnaHbYRPiiL1TQXm2qANycbfnOgoieHNINQIYg3rN
VwX8nLrBcyswTVSMDioma1IqKeZsHTG8KlImyqzzy48OBQ/QOTh0lp1i+0icW/9P
cBoNkzSYxbQutGjMS2VoXZuxHNKcKxLRACU7wovLBauXRL8ngynfUshLSkpTMlMe
SayIl0QfTKCLJ5PPXnr8O01RA6UW/6Cwjxx3WQ2lbscmr2C4PWGs7gpoijqbme2U
swPYcy85p/e/JWAuVOUCSlPBFJiOq7OiE3I+Yx+ldMdJUBLnNbqv6V7FLSJ7wNVe
nh4vhguNYShI3/Q2qYzm2OdL5f1UN9sRwpIqKckviQv2CWsPhf9FT4s/RFtt+bsC
RP7JD7eO5u25bmEumTGgFD/WGQtGTMon5UxtH7qfMhJTLbZA9Bir3PigqEoiJfVQ
Kyg2qZEz0t5YiLp8yKBBLQFkQHuECKc/GCMi84l+8vE7pqNI3hgbqDs4WSrcneSQ
DbAjsjP9l6w=
=hTB4
-----END PGP SIGNATURE-----

--=-3/TgtpQbim0XbPkADrOy--

