Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53676 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbZBPKSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 05:18:25 -0500
Subject: Re: [PATCH 09/10] cfg80211: move regulatory hints to workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902160209q2106331ds540a711e9badfa3f@mail.gmail.com> (sfid-20090216_111011_271337_5C2D5B4D)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-10-git-send-email-lrodriguez@atheros.com>
	 <1234696212.4219.60.camel@johannes.local>
	 <43e72e890902160148n5a383a96t8e20dc4bc9d10687@mail.gmail.com>
	 <1234778113.4219.117.camel@johannes.local>
	 <43e72e890902160209q2106331ds540a711e9badfa3f@mail.gmail.com>
	 (sfid-20090216_111011_271337_5C2D5B4D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8D66JyprLBUN/cTR/HUq"
Date: Mon, 16 Feb 2009 11:18:18 +0100
Message-Id: <1234779498.4219.122.camel@johannes.local> (sfid-20090216_111829_085192_C34B8E7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8D66JyprLBUN/cTR/HUq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 02:09 -0800, Luis R. Rodriguez wrote:

> > Maybe just use a spinlock for the list, and do the loop manually like i=
n
> > mac80211/key.c then?
> >
> >        spin_lock(&todo_lock);
> >        while (!list_empty(&todo_list)) {
> >                key =3D list_first_entry(&todo_list, struct ieee80211_ke=
y, todo);
> >                list_del_init(&key->todo);
> >                spin_unlock(&todo_lock);
> > ........
> >                spin_lock(&todo_lock);
> >        }
> >        spin_unlock(&todo_lock);
>=20
> Sure, is the benefit you see that we won't contend userspace longer if
> the workqueue is busy?

No, just that it's simpler because we truly only use the spinlock for
list accesses rather than holding a reg_mutex around the cfg80211 mutex.

Thus we can queue things without needing the cfg80211 mutex, but dequeue
needs to run under it.

johannes

--=-8D66JyprLBUN/cTR/HUq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmT1nAAoJEKVg1VMiehFYxO8P/A07aSbAq01srqeXHxE1owco
9dZxutA+OtHjd/jR9OeqFbTchShJ0tZoDnKk4w0e3XO6E0mVyTWfieUZtBaa1J6l
5ztUyQaNAOKwuKEOeNrHsNzwLAI9ebWZEWtNplKdjgC07pYQ7odh2VNdfF6MBlCp
fkOo8qkErdU70/44VJ6/X2XL/LbkM7cavtDceUzlH4E3a+EOatOWORHc1v75/id/
G54JFhqvHzxYm0fLGqPSoelwlUsEOpgQJV5rG0TIywbsOzBV1pATJtOhZmdf6REo
jchqjMhGGkiDq/TvySK1WhuKPiWWs9TiXbl1ulMc3doAnw2Yet0OXD+KsUvLCTMw
cVxoI12JYw/ckgypTbU1MZ0J9LXdjCQuRX44pAWoJXWrYkIHgOaywaPKQydgsLyr
ERRh7SmC5Exo0Tzq8JpDwf42EjMDIYt772ER4ljEx2LE0uXmP0SGWKqVUQkx4Qyl
DWXP2tBr779a3B68duxgMk3Eb/6GRbN/f1hq7IHv8LZmy6XFHXcaubjQ9zVfsTue
0eTiJqjgB6QXos1L+8Bj8V/QiEsOZ34oa2ZSZv7qeeeWtYlXV7OVXK4mVuHeG035
4lx0wk8B8RaKhswGIXBAOdnCts27Bea1boGCT9cKEYw3R35tfdmkN/MSMNSvEuO6
/P96urZfSlth3qM/IzI7
=P66i
-----END PGP SIGNATURE-----

--=-8D66JyprLBUN/cTR/HUq--

