Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbYLAUSh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 15:18:37 -0500
Subject: Re: [PATCH] mac80211: deauth when interface is marked down
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com
In-Reply-To: <1228161724-19771-1-git-send-email-linville@tuxdriver.com>
References: <>  <1228161724-19771-1-git-send-email-linville@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ap38oZGcJ3cUZ5HIxo+i"
Date: Mon, 01 Dec 2008 21:18:33 +0100
Message-Id: <1228162713.10627.45.camel@johannes.berg> (sfid-20081201_211840_967743_83301703)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ap38oZGcJ3cUZ5HIxo+i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-01 at 15:02 -0500, John W. Linville wrote:
> It seems like proper etiquette to let other stations know when we are
> going down in either STA or IBSS mode.  This also notifies userland, so
> wpa_supplicant doesn't get confused.
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/mac80211/iface.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 4608212..b557250 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -435,6 +435,9 @@ static int ieee80211_stop(struct net_device *dev)
>  		break;
>  	case NL80211_IFTYPE_STATION:
>  	case NL80211_IFTYPE_ADHOC:
> +		/* Announce that we are leaving the network. */
> +		ieee80211_sta_deauthenticate(dev, WLAN_REASON_DEAUTH_LEAVING);
> +

Ack, but I think it should check whether we're authenticated/associated
at all.

johannes

--=-Ap38oZGcJ3cUZ5HIxo+i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJNEaVAAoJEKVg1VMiehFYd6YP/3qqnlo/ibQufsGWmPZJ5GR4
X61Eu7Mt4rZreGXsZVa8JDYV1PfotqTN56HGk0cahm3IbrSAP6MRTBBQau4MPFjC
hh+qcFyQC3VKRBeK6OsOvv2aKAG4sInl4S2vzycklhFerHgNeROQsbNR5awM38f5
7UCgLu6M4crpHVwFO7BKHvku2Xz2KHKw2B6phQncsOX4YcYgxv+5FIuNVyt0Bl6U
fFaCrA/CK8BTQWOOIPwlJXu0FdaBYV9wExKuZlAZ9aCgWEIyf5RwcZ7L07dlGUaK
evLjTvZs4qgt1uz0x/3mA3Jqjq1kRBogo0GQHuoJlE1KtepA9+vx/C4g6POLvJXV
IyQ07dSHf6sK8cTLSAFn2ZagixV+D3x6r3y36q4T5PcNxQt2GmvGc9HCw7Y9EiYT
0dvzMkRTXKe56NObqa6Z+t+yLXJPuKem9oqAGwQObGd1EPJGwowcCOeypvEXvHi7
8+gcY3eGRVDDdquFBHjnUgDLiaCBSn9qMSwLpcemXDjUb1T2FOmvk3fdTpc3hS+d
VWi1lV/idiY5Mf1XiDKsx/Xzlf8teKsnp+xdTRjGLL1d4CUNCJKMVB6TNqXk/Bry
0/XGeYONixMAXs1YxdUlKLI/0fpE7u0w26LSreuljCQB5SuyVfO+jQACkosfqKNf
VUwBf+zsJ0TDYFcXE8aC
=2reE
-----END PGP SIGNATURE-----

--=-Ap38oZGcJ3cUZ5HIxo+i--

