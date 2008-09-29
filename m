Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYI2L4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 07:56:08 -0400
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <48E0C185.6070705@gmail.com> (sfid-20080929_135242_032949_BF501638)
References: <48E0A65A.2060102@gmail.com>
	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu>
	 <1222683923.7064.18.camel@johannes.berg> <48E0C185.6070705@gmail.com>
	 (sfid-20080929_135242_032949_BF501638)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SryZlpMfdwOuMc7i3VyJ"
Date: Mon, 29 Sep 2008 13:55:40 +0200
Message-Id: <1222689340.7064.26.camel@johannes.berg> (sfid-20080929_135611_974559_2139CF32)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SryZlpMfdwOuMc7i3VyJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-29 at 13:52 +0200, Jiri Slaby wrote:

> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -246,16 +246,26 @@ static int nl80211_get_wiphy(struct sk_buff *skb, s=
truct
> genl_info *info)
>  {
>         struct sk_buff *msg;
>         struct cfg80211_registered_device *dev;
> +       size_t bufsize =3D NLMSG_GOODSIZE;
> +       unsigned int tries =3D 0;
> +       int ret;
>=20
>         dev =3D cfg80211_get_dev_from_info(info);
>         if (IS_ERR(dev))
>                 return PTR_ERR(dev);
>=20
> -       msg =3D nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +retry:
> +       msg =3D nlmsg_new(bufsize, GFP_KERNEL);
>         if (!msg)
>                 goto out_err;
>=20
> -       if (nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, dev)=
 < 0)
> +       ret =3D nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, =
dev);
> +       if (ret =3D=3D -EMSGSIZE && ++tries < 2) {
> +               bufsize *=3D 2;
> +               nlmsg_free(msg);
> +               goto retry;
> +       }
> +       if (ret < 0)
>                 goto out_free;
>=20
>         cfg80211_put_dev(dev);
>=20

Works for me. Not the greatest way to do this I guess, but hey, it
works.

johannes

--=-SryZlpMfdwOuMc7i3VyJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4MI4AAoJEKVg1VMiehFY7W0P/RvVLHZXjW5tGLCZSxc2dGSv
I/qxjOo44Lx8lO03+OCaQpHEDNhlf/iwcHS65GRuCUhC1mCH+6ng2Ej/IKi6Urxx
Id3bAs2xIdAph2xTxQgADcakHcHkbEG1lmw6pfqTen9FXyIQtS178InUAhp0Ct88
+8yovD8WB59IZY0pOhHTzqdxMazFAAmM+/rUPkm5FZKrFmV+Ti+NZ8xi/UCoJMHS
ZCoJRAFdqR/LWYAo8fxPOXmzm5YWCGMsAJpGbw+Z9jZH0DUSH3A0oAtFokMPWuch
Ebcsj8VGZqorCmszFkjx4TmAp6t3bYT33h56RzJuCMzremyPsoCYOnt5Vu7joCQB
YN2PmvOfmDaNamARaHJy/5wrckYS7rkypQGtTG4pzDSRT5uAb6i/UnJ6wAHNRgno
g4shOErcc8yFMSDk+uZ39K1YYSsW8tm5PFMKpj6EpAEMsIwgUZ5cJ0HNRL0SUGkg
M2yTonhDLvhyUgqHlPLcqE9VVetgsTEa7k5AttzrYWjqBtdrHwmB1Qt6iPdVlatp
X7GH9tfsi09gRdGkOjcUG6hqbStatzIcnnnjF8XMMsyQNp2q8l43yfPSWdmYE47r
70qf0KTqLqX34nV9A18Ik3Frn+bfY+AfqFrhBKqoOoEusWLfDZFlf8KIwrH9yvpg
m65jMGrd8xA0oD4BiVF0
=DcQM
-----END PGP SIGNATURE-----

--=-SryZlpMfdwOuMc7i3VyJ--

