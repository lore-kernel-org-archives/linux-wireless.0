Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYIPV5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 17:57:00 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221601739.17084.22.camel@dv>
References: <1221596962.9262.12.camel@johannes.berg>
	 <1221598208.17084.11.camel@dv>  <1221599460.9262.16.camel@johannes.berg>
	 (sfid-20080916_231152_167035_625A9793)  <1221599757.9262.19.camel@johannes.berg>
	 <1221600232.17084.16.camel@dv>  <1221601136.9262.23.camel@johannes.berg>
	 <1221601739.17084.22.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E00AClj9Cfe5K6qghBVp"
Date: Tue, 16 Sep 2008 23:56:04 +0200
Message-Id: <1221602164.9262.28.camel@johannes.berg> (sfid-20080916_235712_566446_6F909BE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-E00AClj9Cfe5K6qghBVp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 17:48 -0400, Pavel Roskin wrote:

> $ nm iw | grep __cmd |sort
> 0000000000403d20 A __start___cmd
> 0000000000403d20 r __cmd_handle_infoNL80211_CMD_GET_WIPHYCIB_NONE
> 0000000000403d60 r __cmd_handle_infoNL80211_CMD_GET_WIPHYCIB_PHY
> 0000000000403da0 r __cmd_handle_nameNL80211_CMD_SET_WIPHYCIB_PHY
> ...
>=20
> The next command is at 0x403d60, but the code expects it at 0x403d50.

I suspected as much, but right now I don't know how to fix that. I'd
have thought the rules here would be just like in an array but clearly I
was wrong.

This would probably "fix" it, but it's ugly:

--- a/iw.h
+++ b/iw.h
@@ -35,6 +35,7 @@ struct cmd {
        int (*handler)(struct nl_cb *cb,
                       struct nl_msg *msg,
                       int argc, char **argv);
+       void *dummy[0] __attribute__((__aligned__(0x40)));
 };
=20
 #define __COMMAND(sect, name, args, nlcmd, flags, idby, handler)       \


johannes

--=-E00AClj9Cfe5K6qghBVp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0CtwAAoJEKVg1VMiehFY7rEP/RZyLv+t/BxN3Beg1lHUG95J
mtetZWsawQReusmGBIX+DDAsMc2O/dU4XGd01GFj7V+L5Zsm1PEju0MZQHcrEE0N
irKwCIHW+px6gdNvqqRmkrPZ9NK21K7R400QxVY98CeA3UgB9Iwwr7Km0B4IP8a/
7fomdSSW5zRlGaVmK1TMTGXeKW7AWsjvDlDUCyt46xQkTZhMIFLplbPw40qJKUZo
lfg/EQ9mfE3oiBQi4HjQftT9oKbXywHdKwxmmai+VF58Jh+6iBaWURn6PHkUnw6m
slj4MxZY9OBhd+Fkipp/u/pyA3P2XfBXMmt3wATYF52Nicd02HsFftahIAf/weoO
U0T5prgjGtmrCU0zaZAqXvHgVVJLXkplj0SLoiTj+w2f0tVXHFEZX9T/US5Bjw+R
/GEEdmUmO6fmu5UXAs/JwzpSFf9tm1o9nAsdEpZH9xtbJAv6phUfPOe6k2CqhQbV
MN7k3oru5P3l8MV10+T9keNw8Gw+GuuK8bT6DRhASHxtT+oFw74P/pvD750d023v
xKw/Y++7uq1kD4iRhDrKnw0VeptvAZeYy3FjgJtFRoWGvdLsUiFDdAXwSYfWc7/q
JoSrTOpruCDMZDZqXdVOf8bzPQoQ5oVKAPBu7DMCE2FtlPAkFuc4yF0MA0qVSOIc
KQFYjvKM63XjeaM+DRDN
=H1VR
-----END PGP SIGNATURE-----

--=-E00AClj9Cfe5K6qghBVp--

