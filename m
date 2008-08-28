Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33940 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbYH1O33 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 10:29:29 -0400
Subject: Re: [RFC] mac80211: Reorder debugfs calls during netdev deinit
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080828135651.GE4863@jm.kir.nu> (sfid-20080828_155804_821695_2192C1D1)
References: <20080828135651.GE4863@jm.kir.nu>
	 (sfid-20080828_155804_821695_2192C1D1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zL63Jpocj6XVwOa/hlgT"
Date: Thu, 28 Aug 2008 16:28:54 +0200
Message-Id: <1219933734.25321.16.camel@johannes.berg> (sfid-20080828_162931_313852_5EF4B41F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zL63Jpocj6XVwOa/hlgT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> It looks like someone has cleaned up the netdev uninit sequence (which
> was quite a mess at the time I looked at it last and ended up just
> delaying the fix till now..) and that seems to make it trivial to fix
> the deinit order issue.

Yeah, that was me, I mostly rewrote the junk in iface.c.

> ieee80211_free_keys() must be called before
> ieee80211_debugfs_remove_netdev() in order to make sure that the
> possible default_key symlink is removed before the netdev debugfs
> directory is removed.
>=20
> This fixes an issue where a monitor interface may be left behind when
> being removed if there is a key symlink in it. This does not happen
> with the current mac80211 code, but could happen in future after IEEE
> 802.11w (management frame protection) is added with its additional
> default_mgmt_key symlink.
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
>=20
>=20
> Index: wireless-testing/net/mac80211/iface.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/iface.c
> +++ wireless-testing/net/mac80211/iface.c
> @@ -31,11 +31,11 @@ static void ieee80211_teardown_sdata(str
>  	int flushed;
>  	int i;
> =20
> -	ieee80211_debugfs_remove_netdev(sdata);
> -
>  	/* free extra data */
>  	ieee80211_free_keys(sdata);
> =20
> +	ieee80211_debugfs_remove_netdev(sdata);
> +
>  	for (i =3D 0; i < IEEE80211_FRAGMENT_MAX; i++)
>  		__skb_queue_purge(&sdata->fragments[i].skb_list);
>  	sdata->fragment_next =3D 0;

Seems sane to me.

Not that I like the workaround of setting keys on the monitor, in fact,
I think it shouldn't be allowed ;)

johannes

--=-zL63Jpocj6XVwOa/hlgT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJItrYjAAoJEKVg1VMiehFYnSMP/3xcxR5XlcKrLNTGNWs256XI
6Q0ES5eICkYPwRaxRwsFMhS+A+viw460322ImXNkLr5jiKPYq96ee3v42ApdWebP
wzjq1Z6hzdgJihkYUwge/2CWFmiWVL9KhP3RtS+Gt91k0r2lMXOsJ7NJpwJEo/kJ
aM2jQhbsyFYe9x0LmQUgedLQdIGipJs2xOPnUs4JT/djGWnJqfSAwwgENn3WqVbn
LEHPQnEP0N/xyl+BHv+MNGZzdu66quNyFoK0nP7VzzIcBJ208g+hLfJjQHixZqG2
e9TYju//Tx9RJrb8m6KNXe9QAHR9a6sqtXCVV74HbjUytcg3L244DKk2b1/LDinI
kgpVUtdZDUMKo7YGjvNdfBRnLgEzqzOgZY29qfojTB2gsDnsq/SjNcjcCYw+68Bm
7oGm7Pyjta2osz0J5cJnYDaPb5HZCpFsgdfvfaZSDN4G/C0KFFFophPQpqreYBMw
qEgKbwvG7mzXx5mqjaoq1IQyyiWRxhFRAS89rb1P2y12uau2m6DtnPP+3BDqA75x
BoXU4lca4vs282bTwTYjFuHJEIkAP4qtNHx71nNq7TFF2lUeaXNxM+XAqBIaaUiB
zfz2FMXA6Uw2bpPnHiKGykNSGV4NZjJsnDznYR5HyBOvR5HAPqNS9e8KDE6dOhtw
/opwSeIJ836pdig35gw/
=KdDO
-----END PGP SIGNATURE-----

--=-zL63Jpocj6XVwOa/hlgT--

