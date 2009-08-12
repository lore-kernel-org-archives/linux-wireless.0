Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZHLRgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 13:36:12 -0400
Subject: Re: Multiple SSID
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890908121025p75b141b6o86c30518bf9de7ea@mail.gmail.com>
References: <20090812100416.744dc5ba@nehalam>
	 <43e72e890908121025p75b141b6o86c30518bf9de7ea@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AYR2+pIw/8Hb0dxjGY0o"
Date: Wed, 12 Aug 2009 19:35:37 +0200
Message-Id: <1250098537.26464.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AYR2+pIw/8Hb0dxjGY0o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-12 at 10:25 -0700, Luis R. Rodriguez wrote:
> On Wed, Aug 12, 2009 at 10:04 AM, Stephen
> Hemminger<shemminger@vyatta.com> wrote:
> > I have a dumb questions. How does one setup multiple SSID's with
> > current (ie not madwifi) wireless API?
> >
> > 1. I assume need to run multiple instances of hostapd with different
> >   config. Will that work?
>=20
> Yes. But the next question is how to create new wlan%d AP interfaces.
> That is answered below.

Huh, no, that's not really true. You can run one hostapd with multiple
BSSes, in theory, except driver_nl80211.c doesn't have all the code for
it yet. Should be fairly simple though to implement, just needs a list
of BSSes in that file.

> > 3. Do vlan's work on wireless (ath9k)?

Well, not in the 802.1q sense. VLANs exist our terminology as a way to
separate (by using different group keys and different local netdevs)
stations connected to the same BSS. This should work, with radius or
with static configuration, but I never tried.

johannes

--=-AYR2+pIw/8Hb0dxjGY0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKgv1mAAoJEODzc/N7+Qmak6EP/0MT3a39B2ZVv/PG7UAHAbao
MQfAOqW1GqFfcsTbR9/QQlkic1jd1MbquqiwfIac+iAMAeH0tkytbJPc2T9Joj0B
mz1mWxxexNpW1AWH+k3NYg5xJiAyWgH2a1MoiWgYTa10AwbrdWUIFq2suLgZqKn+
cryZIcmdWLMlalSxU0zNnafn8UJSRQnGwHTku8ead/Tg7L0SaQlCJWpALK0XpMSb
JEUGpGbd8WzY6ZBIf5wqAM/tLx+xMeUVVXsmcUp/T5Pnr/dRLHc5KDOcn5yoz5h6
jYcS8XqO7NcqxnGGsmsy3IYZp4ph2lGaK5gr8ItpzD+sX9SIv0FacLuefARq2/6Z
RGdHN8/Jj66wiMWnzfqfwVc2RE5ss8RBKridJ2ThZOBTJvnRjx4+1sBYbMr+ZRBk
4W8V9tF99rGBSbGXfcnp+VXogpGKzIk37Q4EVddxbO1TFelXZG2trcwbMa05FhVs
4Rm0RBiC8Q/HUFh0gy0ofY5oRiP4OGtaVGso2eA/J6V2BR6XK+ElDQcWzKES/DYP
8RqVnAjFnTzItgZ75uWssuuJUk8/+5H3dgYFREwwXF3uuGQfQCGo85JQuAet02mx
45o9yVMsWIfs6NJwEgWhoGOZ+PQ66LdgU7sivXvUiHGVIU3fpVLs8V+Wef6KoHj5
rf+Aqm6pBzIvfSsjXln+
=U9td
-----END PGP SIGNATURE-----

--=-AYR2+pIw/8Hb0dxjGY0o--

