Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46406 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbZGWJzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 05:55:09 -0400
Subject: RE: Slow roaming in mac80211 (2.6.30).
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <2E12E93FA1AB41BDA5C8A7292FCAC884@gotws1589>
References: <2E12E93FA1AB41BDA5C8A7292FCAC884@gotws1589>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LCJyvfFq7+w9Jb1VayTl"
Date: Thu, 23 Jul 2009 11:54:35 +0200
Message-Id: <1248342875.19121.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LCJyvfFq7+w9Jb1VayTl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Lars,

> I have further investigated the roaming issues and found two problems.

Thanks!

> First ieee80211_rx_mgmt_deauth() and ieee80211_rx_mgmt_disassoc()
> sets a retry state at the same time as they tells the wpa_supplicant
> that the AP is gone.
>=20
> Patch lae-mac80211-rm-direct-probe.patch addresses this problem.

Hmm. I can see that being a problem, we might get away with just
removing the whole retry block. Ultimately though, I don't think it's a
-stable issue.

> Second problem address the auto scan function in
> ieee80211_sta_config_auth().  When an incomplete AP information is
> found, it start a new scan. This scan will delay the actions taken by
> the wpa_supplicant for the scan period.
>=20
> Patch lae-mac80211-rm-extra-scan-request.patch addresses this problem.

I don't think this is correct, it will only work properly with
wpa_supplicant I think. Not really sure though.

> > I would suggest you just use wpa_supplicant -Dnl80211, which=20
> > should help
> > a lot with this kind of things.
>=20
> I need to patch the kernel for this, rigth ?
> Where can I get appropriate patches?

No, you don't need to patch the kernel, you just need to use a git (?)
version of wpa_supplicant.

johannes

--=-LCJyvfFq7+w9Jb1VayTl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKaDNWAAoJEODzc/N7+Qmai4QQAKOcPzIfDNQvh8dJIvIcMZXY
a8bZE8gkvj/8wTvBGVS2FcLnu2BxvwLaVVxoWc79/WqLdxS5FH5yVbuM8UZ7Atzo
rmkLusUHYKw39UhUcBZ7Tk0g4b44l4HgzCHcd+hpIhH5WDpxhyHf6iKtN+eW8pam
j7gQyuOcbPeNfX5J9DPUJ1IluW2YO5Wxq6bfnDPCU9I80ii8AHTlZqE0SbUef6dz
hRDBHxeCeY2yL/umU1uqGDpzj8y/R7dirjfdPrXHoRUKmc/d9r74l7vjuvewZ0+k
7mo1hfB1UDDO+/+TYklGnb4luf/VX0VmXmws2oorBZADXDU1nde/57dOGBsWiQRq
Zgrmmjfu4NbTBCoFnB8dZdG7eVYKWanoCgHiPkyTG6FAqZqWIMHEouni2Co67Ao2
y4DJknEfVwqmhmcvDws9/u8p/nCq08fVaJzMiFOduAjv3fghSN8sai/N85gToV3v
1cQXGikMusm7KMpFa+r9QQgtL9s0+BxnCRu/KEWsAPt0hyVZvf4PjLefpgVpzHza
6iwsK1FsFR378KjJ36QTpEkGsscCgmyay0kEAseNH0Tn2D1XRvWcr4mdONcoIXaY
mnLcYOtDcLqFtdfIzDuExIcx8n4ivDH+iq2z9Vk/BYy4fh2YHAkDLtWzudApofX/
J9e2ACnjkfvpRUvwIq+O
=c93k
-----END PGP SIGNATURE-----

--=-LCJyvfFq7+w9Jb1VayTl--

