Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbYFJIHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 04:07:46 -0400
Subject: Re: [RFC-PATCH] mac80211: eliminate cached fc from struct
	ieee80211_{tx|rx}_data
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213057737.5974.118.camel@brick> (sfid-20080610_022903_151933_8E439F92)
References: <1213057737.5974.118.camel@brick>
	 (sfid-20080610_022903_151933_8E439F92)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OaiV/Z5AWQ77d4uiIQnS"
Date: Tue, 10 Jun 2008 10:07:01 +0200
Message-Id: <1213085221.22220.32.camel@johannes.berg> (sfid-20080610_100751_106673_E2D6B39A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OaiV/Z5AWQ77d4uiIQnS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-09 at 17:28 -0700, Harvey Harrison wrote:
> Rather than keep a cached host-endian frame control, use byteswapped
> helpers throughout and get the frame control directly from the 802.11
> frame itself.
>=20
> Very little testing has been done so far of this, but it does compile.
>=20
> Applies on top of the 8-patch series adding byteswapped frame control
> helpers.

Cool. I'll test it later.


> -	case (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
> +	if (ieee80211_has_a4(fc)) {

I wonder if the compiler was smart enough to make the switch statement
into something like

if (fromds) {
	if (tods) {
		...
	} else {
		...
	}
} else {
	if (tods) {
		...
	} else {
		...
	}
}

and if we should do that?

johannes

--=-OaiV/Z5AWQ77d4uiIQnS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITjYgAAoJEKVg1VMiehFYAbEP/ihIyG6gTIg16BC/TPtqWwnm
O7Ow1AEqeIjmFCbrSk+33i531+V1LieuTxY5Yw5qIZRt8eka/XMg30qgLFSyok0w
d5iQFaYg+AO+q6FjmFUWfTF2y5it52WnMrzFdZaIaXjnPgv/oIkiUVdkcGsvoTQb
D1uZAxpMo9OMOeEHUWLCo25iE7bJNzkvtK3FEfPBbbTz02lWkj4mRI4eASMcGieq
acWywJQVu7VSezwtEEbsWneRUrz+lkybaHgDMAww/SaG2MnB+nZz1CbA7kPYMllK
5yBWQ4p1vANx4sDbzvs6ayQMdELWJtR406GB4W1mItUHu7W9TVRxFXSYC//3dA5y
b276yNzL3vMYczeOZELBPFDdReHgvMLGNBWJ7aXYACurHWE2xCaoKT5Hn7o+2pBM
9XTHzmP/N4HEP0xF+FcBC8sZkORh3oY4Co+q2IdZw+RzcC+l3FqkPqDw3lQBm0Bm
wAU1zbtax75JETgNeaDL9v/8f7Yx1ImMm6bIl/jZG2RefpHmzfVny6qZRLtYrKjf
NgizCiS8QXwJEwXcc14xYWwE6FGXf8wkqVbralOVc/SWG4UGu26XHYMiTAwGEGFQ
LjNE5rygIVKrNKHSC6m19gfIFDELvzK1s0o1MJulBW6uFpvP3mBXe490ipROHNtN
Wi/5xCUEzqvH8fdMts+N
=Lprf
-----END PGP SIGNATURE-----

--=-OaiV/Z5AWQ77d4uiIQnS--

