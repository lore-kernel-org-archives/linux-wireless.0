Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYIPVQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 17:16:46 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221599460.9262.16.camel@johannes.berg> (sfid-20080916_231152_167035_625A9793)
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221598208.17084.11.camel@dv>  <1221599460.9262.16.camel@johannes.berg>
	 (sfid-20080916_231152_167035_625A9793)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OAwl+25vD2/t+x2bKoaR"
Date: Tue, 16 Sep 2008 23:15:57 +0200
Message-Id: <1221599757.9262.19.camel@johannes.berg> (sfid-20080916_231649_769237_944A897E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OAwl+25vD2/t+x2bKoaR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 23:11 +0200, Johannes Berg wrote:

> > 83              for (cmd =3D &__start___cmd; cmd < &__stop___cmd; cmd++=
) {
> > (gdb) p __start___cmd
> > $1 =3D {section =3D 0x0, name =3D 0x403d02 "info", args =3D 0x0, cmd =
=3D NL80211_CMD_GET_WIPHY,=20
> >   nl_msg_flags =3D 0, idby =3D CIB_PHY, handler =3D 0x402403 <handle_in=
fo>}
> > (gdb) p *(&__start___cmd + 1)
> > $2 =3D {section =3D 0x0, name =3D 0x0, args =3D 0x0, cmd =3D 4209927, n=
l_msg_flags =3D 0, idby =3D CIB_NONE,=20
> >   handler =3D 0x30000000001}
> > (gdb)
> >=20
> > That means, __start___cmd points to "info".  The next command has no
> > name (and appears to be a complete mess).  The clever section trick
> > doesn't seem to work properly.

Hmm. can you send the output of

nm iw | grep __cmd

objdump -h iw
(only the __cmd section part is fine)

and
objdump -j __cmd -s iw

johannes

--=-OAwl+25vD2/t+x2bKoaR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0CIJAAoJEKVg1VMiehFYgZ0QALovwVZmWvnc0zs/1RtJn5fn
G0UM5JDwbrAcpG7CbVte0grDAkrROnOaV5Lfb0MY2E5N4q+ugPBEYf2fsRuzNrlQ
J2H/H0K1wIEPhT+K8HZ1y5+K4MA5YS8Ey9W7/G9fXnb2C2QV2JIqWYBAnKclLaXv
CJKf+b3luNTrMouiBKV5zBRk0vDiYtQ9Z6+vT4BIMJ7CokLsq8lUUAEHXEtD6MJq
4ZuTmcaUphMPZfWcBTpRvygIS2AhB3NxXLdr1p6U8k0eI4wuBSJSWl/bc2ZjaRlw
7ZMyVtqqYeoVb6HTI6j+5ABGnqDXqZiQCfdPv/XmO5L63S3jtLkIW+7pXsmSI/EP
5snzdd1H/T+ybnUix/6WBpebJ5Q/tPhbk8cQALESCq1G0bJbf5NMYfYKyy5J4vlI
EMokUISfnxJ9ECM1vNCnDGlSm+XK3omo97NGi5rbdqCtT5yVHhcXz45F4gayQyka
0rE1ZT7mEWxv018Gcg7Qn2iNYHoER0qmhTbkxGFT2HM05jSyX5n8J0lamih5GQUp
eX3tEMsKwE6Imcz76Gqskq4BLMOc9peA+0ov9B4XetPjeT6UIpbei3IBuVvUi6em
T/2YcBN5zR4+TkCKoO+dQ8EL1GS1qMp0lNRWuUpd71FbvpHy++XuK8n4Q3D/smBY
vYwaaEvU59qH8yU71DSa
=COEg
-----END PGP SIGNATURE-----

--=-OAwl+25vD2/t+x2bKoaR--

