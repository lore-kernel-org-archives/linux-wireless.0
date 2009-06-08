Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51981 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZFHG3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 02:29:10 -0400
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
References: <83a869cd0906071445i13a5398y5e94ea3d91123c3b@mail.gmail.com>
	 <83a869cd0906071449u4ae8832bu168322ae4a7cd2a3@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ONM7psanqdFObURFsWbO"
Date: Mon, 08 Jun 2009 08:29:09 +0200
Message-Id: <1244442549.11006.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ONM7psanqdFObURFsWbO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-07 at 21:49 +0000, gregor kowski wrote:
> The mac80211 tkip code won't call update_tkip_key, if some rx packets
> get received without KEY_FLAG_UPLOADED_TO_HARDWARE. This can happen on
> first packet because the hardware key stuff is called asynchronously
> with=20
> todo workqueue.
>=20
> This patch workaround that by always calling update_tkip_key if
> the packet wasn't decrypted by the hardware.
>=20
> Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>
> Index: linux-2.6/net/mac80211/tkip.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/net/mac80211/tkip.c  2009-06-07 19:32:26.000000000
> +0000
> +++ linux-2.6/net/mac80211/tkip.c       2009-06-07 21:31:31.000000000
> +0000
> @@ -298,19 +298,19 @@
>                         printk("\n");
>                 }
>  #endif
> -               if (key->local->ops->update_tkip_key &&
> -                       key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
> -                       u8 bcast[ETH_ALEN] =3D
> -                               {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> -                       u8 *sta_addr =3D key->sta->sta.addr;
> +       }
> +       if (key->local->ops->update_tkip_key &&
> +               key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
> +               u8 bcast[ETH_ALEN] =3D
> +                       {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
> +               u8 *sta_addr =3D key->sta->sta.addr;

There's a quite obvious disconnect between what your patch does and what
your description says, please fix one of them. As it is, the patch only
skips the IV rollover which is *completely* wrong because it will call
the function for *every* packet.

johannes

--=-ONM7psanqdFObURFsWbO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKLK+yAAoJEODzc/N7+QmatOsQAKBzYaDerfwUQ6tf0qjQnxVC
bmJWpHWUa1//6snO3BUsLbn4a2FD40u4AnZ8HGnBMLhEoAoLDtngPUtsXnH4tvkV
GV/fk+ck0/cmbl08ry2JCiMmbo/74ahSeDeslCGrEKRWV3khLddUmb0FbE1gvTK8
v1eNlpijYtnANqUZ4pkcJVY8vskdIdFaxqz84uTMIjb5IFFPtfROPuFHeHuMfvbS
p/nGz2qmj6ON8cVW8beRlgrtJh2NkOOW7+pSFS47bjmDy75tJT4cxwaD9M8f/OEQ
gS8mSHwyKfDLfI6cclQRbFqO0/HLmUXNJ+xyTqBOYt8qCFeM2XHXiP+/xA0YXsCa
VoSN8TGwp8Qs1fdP2J5NSI5H5Qfy1C67PH/a9/MVCNm3qSn/RCURGQGFpW3K1kcW
qgmicXVbSaJY8Ckkzk4YmzPxF2LfoD6NF+2GNxGCjC1ocNIVSlTkjFaUq8i3VeU9
GHedZ8JvfV5WFp9tpLXJqnYSAnzgvfWNXcgMH6F0tzcO5LccIQqrU4bNp61O75RW
YUadMy8INgADl7RJiFSbQ2ytWvgW0gW+Z07jxJl9xV5HhHn29liTw9IUSBJOgLZV
VbPlOUtwjA+tg/2Y0nGoKrj/ZjvMPK55F2B3y6LyDmeMwvlO4tP9993rl2U8gbRV
rW8RJj+4tjYB7OK3bl5R
=kVOA
-----END PGP SIGNATURE-----

--=-ONM7psanqdFObURFsWbO--

