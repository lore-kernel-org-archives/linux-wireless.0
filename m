Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbYI2KZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 06:25:28 -0400
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20080929102021.GE10429@jm.kir.nu>
References: <48E0A65A.2060102@gmail.com>
	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+XdlcdhlM02l6X7ozn/E"
Date: Mon, 29 Sep 2008 12:25:23 +0200
Message-Id: <1222683923.7064.18.camel@johannes.berg> (sfid-20080929_122532_241162_27D0B6E7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+XdlcdhlM02l6X7ozn/E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-29 at 13:20 +0300, Jouni Malinen wrote:
> On Mon, Sep 29, 2008 at 12:01:20PM +0200, Johannes Berg wrote:
>=20
> > > I've found out, that NL80211_CMD_GET_WIPHY reply doesn't fit into a m=
essage
> > > socket buffer now. Used driver is ath5k.
> >=20
> > Ok, humm, I have no idea what to do. I guess we'll somehow have to make
> > it possible to split it up on band or channel boundaries. But since
> > those are nested it seems somewhat weird to me. Any ideas?
>=20
> Isn't ath5k reporting quite a large set of channels that would never
> really be used? 26 channels on 2.4 GHz and 194(huh!) on 5 GHz.. First
> workaround could be to just limit those to somewhat more common set of
> channels.

Well, this is what the hw supports I guess, most channels will actually
reported to userspace with the DISABLED flag set.

> Sure, it would be nice to be able to handle long enough replies, but in
> this particular case, I'm not sure whether the reply is that realistic.
> Split on band boundary would not be enough here since the 5 GHz band
> alone would probably have went beyond the size limit.

Heh, ok, split on channels it is then I guess. No big deal, but I don't
know how to handle that at all.

> > > There is also a bug in hostapd which waits for ACK forever when this =
error occur
> > > in i802_get_hw_feature_data().
> >=20
> > I should replace all the code there with the current code from iw, it's
> > much better and actually handles all the corner cases.
>=20
> I have following (completely untested) patch.. Does it look correct or
> do you have something more complete that should be used here?

I recently rewrote the handling in iw completely to make it easier to
follow, will post an equivalent patch for hostapd in a minute.

Jiri, can you tell me what happens with iw? iw phy phy0 info or
something.

johannes

--=-+XdlcdhlM02l6X7ozn/E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4K0PAAoJEKVg1VMiehFYkqAP/2rrtgiLeQHhGTb59BTQBU5J
WV9gInd/ztI0Ntt0BtoWLHIfaZdTzSeKCEGX+ufLEbfOW7PaQnCp3RgNdV3xJUQC
nYP1lIR3+a+YY0NN/fYNG83iBGKzlpcPdh8FUKTnFxEtE/r5iMHeR/s0NTJZrwD1
ACQm4S5sbGbTVXH6GbBgIsd5sOlU0U9DiNv2HTv8PJOKFgjJsNBxHy25VzgeExZp
2xlonUYQfgIrEzyBfxB62mIh6aiWOO9NVyC16/HuM027pqO1tR1KeozztyjqvpqL
3qihjYUzEWu88XDHVPaPyu0gUpa8tMzUaw2XCdAposZnUU9gXx8atod+mhpwjFrL
vHHCT70LUnzRtM0Cjx7DLAajGnxj0r/ciFxFWP6aJkV/9JggqbYu4AIfd9dD2J5B
pcz4Wry0wDubLJoeLBJeD4aew3CZ3h2LrrcuNNiC37jIMSEvO1P2inepWlloayO2
TJcyWgBPPMHWmaBDFDFOXlVGaZ05lZ7dRYq1hpJRTKIhgmX1U2oqadMdR/dngUiX
9LS4cc1N2eb/EUBHNp8ZQDuIqEMfxDdq2g8lG8HExkV0Jv3+7iki7ARTy42o7Ldl
K0lXv/aSZdOQqGJTVOPJy+xMjh76QyWsBN8UyR7K5cgRvmmm+ncULcCbtQs5ht1U
0a7uCEBL3BNzNk4nbahM
=c3P0
-----END PGP SIGNATURE-----

--=-+XdlcdhlM02l6X7ozn/E--

