Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZALOsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 09:48:25 -0500
Subject: Re: [RFC] nl80211: New command for adding extra IE(s) into
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090112142646.GB12109@jm.kir.nu>
References: <20090112122605.GB9153@jm.kir.nu>
	 <1231765724.2998.10.camel@home.berg>  <20090112142646.GB12109@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-swJzW9v/I/EIUzePuvkb"
Date: Mon, 12 Jan 2009 15:48:22 +0100
Message-Id: <1231771702.3591.2.camel@johannes> (sfid-20090112_154828_571002_F7004468)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-swJzW9v/I/EIUzePuvkb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-12 at 16:26 +0200, Jouni Malinen wrote:

> +	/* Extra IE data for management frames */
> +	u8 *ie_probereq;
> +	size_t ie_probereq_len;
> +	u8 *ie_proberesp;
> +	size_t ie_proberesp_len;
> +	u8 *ie_auth;
> +	size_t ie_auth_len;
> +	u8 *ie_assocreq;
> +	size_t ie_assocreq_len;
> +	u8 *ie_reassocreq;
> +	size_t ie_reassocreq_len;
> +	u8 *ie_deauth;
> +	size_t ie_deauth_len;
> +	u8 *ie_disassoc;
> +	size_t ie_disassoc_len;

It'd be more memory efficient on 64-bit to not alternate between 64 and
32 bit values, but I don't really care too much in this struct.

Should we sanity-check the input? E.g. in nl80211, ensure that it's
(<type><len><data...>)* with <len> being correct and no final padding?
And maybe that there isn't anything in those IEs that we've already
added, like an SSID?

johannes

--=-swJzW9v/I/EIUzePuvkb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJa1gzAAoJEKVg1VMiehFYscYP+gK5o6gfuXPWSUpejFCw9YMk
fNNxAAZ5rlWs252IROLP+5W/R6kkX6m0aO+Ylm/L8WW3yoEFQGzMjQWg90yFL7US
WAprDnf0K63upnkl0cyusYkdlYCfmUL9ehmW1ZwmIdReJjexFXukAqhRNCg9QwSE
0iv3KkKuzEQMHhKaKuhO1LpZ+l6iR2Ux+Ek5QkP28cRKyvgvDD08ZradoxdPJIFg
wyE3ZfdiYmX4kx6ECiPSVqi3ybFx0njmwVWscXG5kvZonTJAwfykAs9LEYeJ2WtK
nZHOpwTE1uayKanaBnLnntfj7M02FmoZHsL5KothIzCbgyeoxuEtytrabgeeGbTx
z9eqae+J0lpdhVTpEK+d+filrePgA5EKxU4EYgUwjQIz2+41ewSPznxmI8dSvi9z
DSnLVMCMO+JeZ+iq6J/BdTRIzZ6k8xfSAqQBj+hgcYfivDKElDN376zAmS6HOX8H
mUPsnvOz8+VitOJgVFrgreYQvi6U5dPx4tpGgbIt41u6Mgzun8sXm+oT5+PHOM5u
BYlS95tOnbGHiNCJXJhlEYMXMZM6bN6w9U4CpuB7XBEu5Mn3kg/g7vqh+9ZAeOaN
uTuoIkaTQitI5vK97dvpwfxiLzF1C8GveQo1Hjs2prBIYD2fyKz2G4/J7/+GHUz/
9IF1Ls0lGVQOdt5g6UIS
=mcjV
-----END PGP SIGNATURE-----

--=-swJzW9v/I/EIUzePuvkb--

