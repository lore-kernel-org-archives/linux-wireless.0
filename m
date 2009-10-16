Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857AbZJPLjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:39:11 -0400
Subject: Re: BUG? I can reproduce "Association request to the driver
 failed" at will
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com
In-Reply-To: <20091012071550.GD25578@jm.kir.nu>
References: <200909211309.40476.hs4233@mail.mn-solutions.de>
	 <20091012071550.GD25578@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Us93ZnpHS/bMHeFux8o+"
Date: Fri, 16 Oct 2009 19:07:12 +0900
Message-Id: <1255687632.4095.331.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Us93ZnpHS/bMHeFux8o+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-12 at 10:15 +0300, Jouni Malinen wrote:

> Though, even in this case, there is actually a bug somewhere (in
> mac80211, I would assume).. The authentication attempt with the second
> AP times out because mac80211 ends up sending the direct probes to the
> MAC address of the old AP (which is now turned off). When wpa_supplicant
> tries to authenticate again, the direct probes are going to the correct
> destination and connection can be established.

I can't see that happen in mac80211 -- can somebody run this with some
printks in cfg80211 that tell us what exactly is being passed down to
mac80211's auth() call?

> I can reproduce this with the current wpa_supplicant (that has a
> workaround for this EALREADY for authentication case, but not for
> assoc) and the current wireless-testing. Roaming will get mac80211 into
> very odd state..
>=20
> Not only is this association failing (after the authentication with the
> same AP actually worked), but the scanning state will also get quite
> confused.. The next scan trigger after this is never completed (iw scan
> gets stuck). Or well, actually, once I wait long enough for the AP to
> deauthenticate the client, it looks like mac80211 can recover. The scan
> command returned after five minutes of waiting.. ;-)

Good hint. It looks like it gets stuck between assoc and auth for the
old AP?

> > The "Association request to the driver failed" will
> > be shown even without "-d". Also note that the association
> > seems to actually work, e.g. I can ping throught the
> > connection.
>=20
> mac80211 remains associated with the old AP (I think) and somehow
> remains in the state between authentication and association (with the
> new AP) which will block scans.

I think we need a cfg80211 event tracer :)

Actually, does wpa_supplicant _deauth_ from the AP, or does it just
disassoc? It's definitely supposed to deauth.

johannes

--=-Us93ZnpHS/bMHeFux8o+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2EXNAAoJEODzc/N7+Qmabt4P/iTukH3RrR/bMMgazOT2p+PT
zfRii5+VIzEL6Ge4pqgiE5yVVabG7N7TmAWaIKqyAnaijqKsDaWOHw9DnVLEzK/y
Q6bm3+BeSqx9ql3O6b0DzOkA9ooL0y1fAOaV1WhJT5gAOiTXKrDUZmAQ9VVUBY7Q
Ll1/7E7Bhm/ssidlkoDTIdi4Ya/TktNoksxEbcwXvbhfuiUtXQq9dC3Z0WtJ1Kna
zXJwMtKb4547q1GXeerQtEc0fIXLlvCcwBCBIbLgxN3AZctj7lCMxmjnlISzA/3/
ncoQgFGVLgRhzXJ3NgYjudAS74ocoxWXx2+4JdJDpI9K6OeSXU2FOBIID5RjtEso
leyT9T0eu9v2ArUphd0qtw9e1/LEp5ScMBdqUSZ+EYdJUwsFDCZ4O7iwbpKKGSzB
aNndp3MZcQh3pRG3QnAgS+fM2RYSp7SMaDx9X9iXbIawDNwdOE9/H4KpqyELXbqq
Kiwfq1qKjBLAuaACnsFAGqYRJXQQ6Ibc7K2eyf+vm36QmbM5xGLX8KHQXZiUFwmx
EWaSingcc0yIm7YB0Vf3GnRsm7+v0kY5+Xeb9KCnl/vHUO8Ui048Z3hIdEvDTQ1A
a84rVuFDQMxhnUuztV6kIh3TG434tTdVmCP36hs/25iLqmuB8RKUz1gxrYoz6g65
N3G12Bo/bAzW/akelYpk
=Lm9a
-----END PGP SIGNATURE-----

--=-Us93ZnpHS/bMHeFux8o+--

