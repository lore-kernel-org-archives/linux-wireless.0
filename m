Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55375 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZIHRRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 13:17:52 -0400
Subject: Re: driver_nl80211 broken again
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1252116503.2398.26.camel@maxim-laptop>
References: <1251117161.22951.4.camel@maxim-laptop>
	 <1251122885.12007.12.camel@johannes.local>
	 <1251144381.9374.4.camel@maxim-laptop>
	 <1251147515.20161.3.camel@johannes.local>
	 <1252116503.2398.26.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hJs+LUTxOlEasZFdrM+X"
Date: Tue, 08 Sep 2009 17:29:29 +0200
Message-Id: <1252423769.3806.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hJs+LUTxOlEasZFdrM+X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-09-05 at 05:08 +0300, Maxim Levitsky wrote:

> 1 - when connecting again to the access point (same or another),=20
> wpa_supplicant does the following:
>=20
> deassoc
> auth
> assoc
>=20
> So it assumes that deassoc command disconnects completely, but it not
> longer true.
> Yet, I have tried to make its dissassoc function do both, but it failed.
> I used following patch:
>=20
>=20
> diff --git a/wpa_supplicant/wpa_supplicant.c b/wpa_supplicant/wpa_supplic=
ant.c
> index c68dd82..50afeeb 100644
> --- a/wpa_supplicant/wpa_supplicant.c
> +++ b/wpa_supplicant/wpa_supplicant.c
> @@ -1278,8 +1278,10 @@ void wpa_supplicant_disassociate(struct wpa_suppli=
cant *wpa_s,
>         if (!is_zero_ether_addr(wpa_s->bssid)) {
>                 if (wpa_s->drv_flags & WPA_DRIVER_FLAGS_USER_SPACE_MLME)
>                         ieee80211_sta_disassociate(wpa_s, reason_code);
> -               else
> +               else {
>                         wpa_drv_disassociate(wpa_s, wpa_s->bssid, reason_=
code);
> +                       wpa_drv_deauthenticate(wpa_s, wpa_s->bssid, reaso=
n_code);
> +               }
>                 addr =3D wpa_s->bssid;
>         }
>         wpa_clear_keys(wpa_s, addr);

Right, this is a known problem. I still think it should be handled in
wpa_s, but I'm not sure whether that patch should have worked or not.

> EAPOL: startWhen --> 0
> EAPOL: disable timer tick
> wpa_driver_nl80211_disassociate
> wpa_driver_nl80211_deauthenticate
> nl80211: MLME command failed: ret=3D-67 (Link has been severed)

Ok so it was called, but got -ENOLINK? That's rather odd. But I suspect
that it had already internally cleared the BSSID, so that it was asking
to deauth from 00:...:00 -- could you check that?

> 2 - independent of the above, the ieee80211_set_disassoc
> doesn't work right if deauth=3D=3Dfalse.
>=20
>=20
> If it is, then a work item is added to station work thread, and it is
> never removed:
>=20
> 	} else {
> 		struct ieee80211_mgd_work *wk =3D ifmgd->old_associate_work;
>=20
> 		wk->state =3D IEEE80211_MGD_STATE_IDLE;
> 		list_add(&wk->list, &ifmgd->work_list);
> 	}
>=20
>=20
> iee80211_sta_work just ignores the IEEE80211_MGD_STATE_IDLE, thus it
> work item remains forever.
>=20
> This breaks scanning, since __ieee80211_start_scan will refuses to run
> until, ifmgd->work_list is empty.

That's intentional, that work item represents the authentication state
we still have -- the required cleanup should be done by cfg80211 or
wpa_supplicant.

Can you try to figure out what the parameters are that
wpa_drv_deauthenticate() is sending to the kernel, and why it's getting
-ENOLINK?

johannes


--=-hJs+LUTxOlEasZFdrM+X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKpnhVAAoJEODzc/N7+Qma+mkP/3y61BRqMLavFo0/jl7sk9K1
uchKopfK0NuV0AJdxqlGtQk29MG7iOt28ttaKg5iIp91E8KS57D/hv8yAO7SKXf0
E9zX9oQZ3NSFM73Fq+DsiQQCRFSHvvKkyyvU0QufuEaJJzor6qT6JvX1LDWm6lsh
mGoq9omXmSXqOoHq+33c3UjXN30DAxJiDnWlU1RKJ0S3xSzAZLMJUrJsWKSgQWBt
Y4K19/hxiGBlD3kiMMfbLSEXaeBvrZSYaAlTF7lhV/pF3mi3oa1EMqX9lQqlW7IS
HKGVz37jbabNxjLg8I9yLydNnFJYMTSoHm6VUXHzQHZb7MI7DYfjslkoDXUCv+zP
Irpm4YMrgxdagzuEpvFJ11TPQM1BrVJXgvKUCmmEJFSzyRACKrz4uc5h7vV1l43t
Sqr13AoghFER9Jct+2SLrkfuLy01GEEb33jWqCnbhIZsTYIt4QoJr6FG08QdrHs6
AAj6mfwy1L4Rfc7ciUb5wbq5Iv1Dpj25wjUFRJ6O/oeIPm5eABCwJI/XT4VQNlYS
hwUvaG6+EqAGsPoEstJUZnBnhZeM7oasxvv3Hn6BQkRRbA5oM+FsHQ/tX5LO8Osg
3b/6RxXmyfhgkrdbTDC6Z0mvfdZrnhYBj2+4105iIm1spVMg0j/QGesuXbso/7Iq
BAQljhUSL2YlOA+ZoUVv
=tzvj
-----END PGP SIGNATURE-----

--=-hJs+LUTxOlEasZFdrM+X--

