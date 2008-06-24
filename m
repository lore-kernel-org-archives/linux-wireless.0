Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYFXR30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 13:29:26 -0400
Subject: Re: [PATCH] mac80211: Add RTNL warning for workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200806241923.36230.IvDoorn@gmail.com> (sfid-20080624_192311_350711_BF3DEAAB)
References: <200806241923.36230.IvDoorn@gmail.com>
	 (sfid-20080624_192311_350711_BF3DEAAB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XBH63ySrHsX5onAOsHS9"
Date: Tue, 24 Jun 2008 19:28:46 +0200
Message-Id: <1214328526.8967.292.camel@johannes.berg> (sfid-20080624_192929_801113_8F555602)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XBH63ySrHsX5onAOsHS9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-24 at 19:23 +0200, Ivo van Doorn wrote:
> The workqueue provided by mac80211 should not be used for
> scheduled tasks that acquire the RTNL lock. This could be done
> when the driver uses the function ieee80211_iterate_active_interfaces()
> within the scheduled work. Such behavior will end in locking
> dependencies problems when an interface is being removed.
>=20
> This patch will add a notification about the RTNL locking and
> the mac80211 workqueue to prevent driver developers from
> blindly using it.
>=20
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> ---
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 19f1e41..02c79e6 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -738,8 +738,11 @@ enum ieee80211_hw_flags {
>   * @conf: &struct ieee80211_conf, device configuration, don't use.
>   *
>   * @workqueue: single threaded workqueue available for driver use,
> - *	allocated by mac80211 on registration and flushed on
> - *	unregistration.
> + *	allocated by mac80211 on registration and flushed when an
> + *	interface is removed.

Interesting point. Should it be there or rather be moved down a bit so
that it is actually only flushed when _all_ interfaces are stopped, i.e.
before ->stop is invoked?

johannes

--=-XBH63ySrHsX5onAOsHS9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYS7KAAoJEKVg1VMiehFYneoQAKHYwPJ06RAkaxfczt8XO6jb
jpqycVveZi7RAXGYJ6x5ZpAubNzuxZ7sBSacU1V/XmDKjAssqcCvUArunKA7fcSW
XPzBLdU4IwkaQENKdTX+82ERy4a0VwyzOe74MLyfW64T+jTM5AcBFiJqRrbxbFv+
40Ms/R6chFQQBvDeJbWMF7tuJ05dgzbPdwuaWgXQbEm703Bk7CyUc7+r6F02tb7K
GqpQbgkKRg0fEb3SgppjBm1+ZPbb9eFvotgR93tU3vEMAsEap4vDoQVzLC2bFYop
OvNCGmz8z4vm7D6TE8hFy2c5/7ul10cPtccaOxZRx/AzBf7tmXKHEcTDrof2pepc
2MRPn1BmN6qH72SScu3KC2fWU0aWZM464rbxngTS4spEUFeZq+bY6rMO+e77v9UZ
4hEdA4Vlku4NKQSHUBRiEkqRh+RmHh76OhxZ+UoJP7UK8Hhy3vDqTy2bCnqDJM87
2ecUS6Z7QOrbZVyycT4fuyUH6VFxqgdCCI6bCzTj0fDeAYiACKYQg65A8OaaE27A
TAJfFI4ymwKOqw2rXdnvJOYQZ1wePeF8rWv+xSt2nzIQuQCdGQatF2APaGyyUZSN
hghwNAtRU6jNiZ0c4ErwQUy5EQ9sXFoQg33MvA2C1oILBDDOkj2fDc3DMmQ7kwfH
SeG6xXRo0y4I4h7mh00s
=CL/f
-----END PGP SIGNATURE-----

--=-XBH63ySrHsX5onAOsHS9--

