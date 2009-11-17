Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49453 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbZKQRB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 12:01:58 -0500
Subject: Re: [PATCH 06/16] wl1251: fix deadlock with ieee80211 beacon
 filter calls
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20091117164852.2236.24891.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
	 <20091117164852.2236.24891.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Yv+koIjsxg4s7+g1oKuA"
Date: Tue, 17 Nov 2009 18:01:28 +0100
Message-ID: <1258477288.21197.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Yv+koIjsxg4s7+g1oKuA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-17 at 18:48 +0200, Kalle Valo wrote:
> From: Vidhya Govindan <vidhya.govindan@nokia.com>
>=20
> Lockdep shows that there is a deadlock when calling ieee80211_rssi_change=
d()
> under wl->mutex. Fix it by releasing mutex before calling mac80211 functi=
ons.
> This patch is based on Work-In-Progress patch sent by Kalle Valo.

>  	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID && wl->psm) {
>  		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
> +		/* need to unlock mutex to avoid deadlocking with rtnl */
> +		mutex_unlock(&wl->mutex);
> =20
>  		/* indicate to the stack, that beacons have been lost */
>  		ieee80211_beacon_loss(wl->vif);
> +		mutex_lock(&wl->mutex);

That can't be true, ieee80211_beacon_loss() only calls
ieee80211_queue_work().

johannes

--=-Yv+koIjsxg4s7+g1oKuA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLAtblAAoJEODzc/N7+QmaSOoP/3R6peChwJaoTmSRXDrC7xfw
46UG3Ukope2jPSqxp7Y5l4p01lSKDh1fiJzUp80l2Ge+bvUk7vFsW1Ox03lB47wK
HryRailk8IN8le2kLK5/jetmGH13EYtkYLepx7tKXb8hmBh+pweUAImIcxOf3vMV
f4hAOTUxbsDXHaP4boPKEP9+u2mKHBTaR8lZtfGlLUSkf8FTLX7tzGkdY0RwJHFD
LMa63LfCQwccc0C+EAD1wOhZhH7YKYGxaYvkImjTGoJqv9W2LQ0gyNUZ8jRXTiRa
rZxSIr5XzmEbSucvl3GvjLSr8ITtjsv2P9MCv61pWleSdktL9bzjhvptfASVlzjW
Ead1t2DSq73FuRjA+UfZFymFBwPIxu8Sz5yylH7gxruB8RFyKsJ2/J1QIxPacd1/
8hhcUL+DeUaF/9W6rJJdKz6FmxIC7NOEP0BpOgOfN/FiSFpKDT//k9P4XfP+DCRp
AXByiTy0zVmLRQ+8LmlRV9q9yK1S0xu5m5993i8ljMFfiCLuo3EtqrjQha12JWeC
xkOs1PjdlLEjAI7Yf+gTLLfj4ZmjRimku0lV5DefT3swrKeyXtg1ChtqXGrc2FZA
AQcI8TlY/K5dgkebFwGJOWE2u9BzgLhWRzAuZEcHB3R/wWZ6MtSwdq9KCCNoSiJN
/QmcKCkjlPrCrJPgLgDE
=3xr9
-----END PGP SIGNATURE-----

--=-Yv+koIjsxg4s7+g1oKuA--

