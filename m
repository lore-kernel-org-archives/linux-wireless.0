Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51419 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYLAMFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 07:05:24 -0500
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
From: Johannes Berg <johannes@sipsolutions.net>
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org, Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <20081202011754.GA9382@myhost.users.atheros.com> (sfid-20081201_124427_646417_122C4B13)
References: <20081202011754.GA9382@myhost.users.atheros.com>
	 (sfid-20081201_124427_646417_122C4B13)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Pq+2VDmMZgKdRPAd2Czz"
Date: Mon, 01 Dec 2008 13:05:21 +0100
Message-Id: <1228133121.3478.27.camel@johannes.berg> (sfid-20081201_130529_154432_04C33971)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pq+2VDmMZgKdRPAd2Czz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-01 at 17:17 -0800, Vivek Natarajan wrote:
> This patch is based on Kalle's initial RFC patches on dynamic power save.
> Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
> frame, it is appropriate to do it from mac80211.=20
> This patch enables mac80211 to send a null frame and also to
> check for tim in the beacon if power save is enabled.

One thing I forgot, do we need a special iwlwifi flag to turn this off?
Or can iwlwifi be programmed to let the host handle this (*), which
might be beneficial for interoperability and uniformity purposes?

johannes

(*) it would need to implement a beacon filter that passes up only
modified beacons (where modified doesn't take into account the TIM IE
except for the own AID/bcast bits), and turns off the null function
stuff in firmware

--=-Pq+2VDmMZgKdRPAd2Czz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJM9L9AAoJEKVg1VMiehFYJcAQAKElOSCtVFHtYI//7j8lHF48
Pw7Pw7mZIXluOhff8vULmLlSOTmwTHP8ipYYPGWFIitcv8GrCMBdNJcEorJhebAK
SLX5SMi604U66QnwpcfGnAqTi/9R4VdAnENm4RKI5fIUV5l+rdAGTAWdVoK+uAdJ
Cgi/5A4h0C6eur9x35ntqdOvxWUwkEFuK2ZiHERdMS7znS/ntJyiaucJCfgVlQWj
S8AER+ZjLs1NshoR9Rk8wlHUyceCu4tIbPG5mErSyGlHGEFxCFEiXvyezbKkkMmD
kGJ3BOjbBf9R19pOfkJefEl7lZ0PlPywOJk9/UJ0BT/b7uMlbMEPrw5kCINVGIr9
HeYqlTMZy4hHv5kEYkhj9OqbCzRywY4Xl3TwnVLcUVwGTYfOx4Gk7C6uRMoBxeQb
MSgjaDn06UqeuxraQ0u6H6mY0BcWt6tzQp5BMmjXHi38RHhcEtGE3H6IGfe0CjY7
tAI+7jgBn5adwO6qt6rUnwPjnl+zDI/DcIqJtRCxYTLGDkrcESy/YieR/cBYB7HC
1gjAauk/6wW1f3mBASs0LkFEv2ovk/PnQFW7yXo8P46Pvr8W3C4u5Ts8r/lcA/n7
sbKmykYRxiaQfaWTmigtPM25KFOCl+4X7TKeo1wKtCNfli2Lrw9mhlKLsLW+i+I+
DgIIwE4l7NSnCtl2+Wiq
=iI6o
-----END PGP SIGNATURE-----

--=-Pq+2VDmMZgKdRPAd2Czz--

