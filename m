Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbYJ1XNn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 19:13:43 -0400
Subject: Re: [PATCH] iwlwifi: remove implicit direct scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810281454v434182f0t5f42ee6cef6c408d@mail.gmail.com> (sfid-20081028_225435_366897_7D675868)
References: <1225214465.3598.27.camel@johannes.berg>
	 <1ba2fa240810281353u4b038cf2gb46cb830b278a278@mail.gmail.com>
	 <1ba2fa240810281454v434182f0t5f42ee6cef6c408d@mail.gmail.com>
	 (sfid-20081028_225435_366897_7D675868)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LJ0svzOq3kXeNXuuF5OF"
Date: Tue, 28 Oct 2008 23:59:22 +0100
Message-Id: <1225234763.1369.3.camel@johannes.berg> (sfid-20081029_001349_025740_97A74518)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LJ0svzOq3kXeNXuuF5OF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 23:54 +0200, Tomas Winkler wrote:

> >> Am I missing something? This seems very strange! What specifies that
> >> when an SSID is set on an interface the user wants to scan for that on=
e?
> >> The interface might just have been associated previously to that SSID,
> >> now disassociated and network manager is asking for a scan to get
> >> information about networks to let the user select a new one.
> >
> > NACK, this is a heuristic that helps connection to configured SSID. It
> > doesn't mean that other ssid won't be scanned.
> > This code might be revised again when multiple SSID scan will be implem=
ented
> > Tomas
> >
> Okay I've only now have  seen the real reason for this. The SSID
> removal from the driver API. It's much better argument for removing
> this code anyway have to think how this will be substituted.

:)
Unless somebody can come up with a good argument for requiring the SSID?
I don't see it being necessary the way beaconing and everything is
designed in mac80211 now, and this leaves only the BSSID in the
interface config which I'll move to BSS config and then remove the
interface config thing completely.

Also, doesn't ieee80211_sta_config_auth already do exactly this
heuristic thing? If it doesn't know about the BSS it'll initiate a scan
for the SSID it's looking for?

johannes

--=-LJ0svzOq3kXeNXuuF5OF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJB5lHAAoJEKVg1VMiehFY3+AP/ibriTr172+g/zUqu/CzwPwW
RAs2KboHIWmSG89DDevPpA4kkrGpMjTox6t+56dK6kSVDGpc8+zmDTm0u98U5FHz
KmV8HpreNmeDoXVnEl8KrJ9zjRA0kEpz8gfx0H0f1YvC8bl6kkIC0WU7JgMyb480
TvgI+szEHi6eUio5RgEQ5ajUK8poWzLQjAP9jEamCq9FZTlHF2PgQlCb2yRrBB8O
MkSdYKtOEJ1AlzBacNqHCGkVehnQNBW+AOm9wDNkIDMerBVUlLgvyF224J90ydat
zUNdrbnqs/GC2LtNpYoR0ZZsbkfetsq4JyhJo9u3FoxDhMay9E/5+mjv6k/bZQVG
X8y+KY8Tni0rah5eCKyevto4gfdlPEVZuqk8pJI4YX4rPJo9kE6H1N4MNU6hV4uR
x0ljAnqCtV+HbNb8ZRDcX7Iy4CQBGhJJ7y6T4HpJECBHYdxNxf5epfe49ktqskXX
fgTVYaSqiyXStSHTPC6igTf9rXqzK+XWSpFVkLyCQYRSpx2puFTC1K9ZDdfOFnsW
xbIhz0Kb95lOubSaXlQDSujycEMN/iM9TmIJOjAK9NlDgwryOxd/l601SWs8vJxf
nZPSMCT1PQpAGHxyO0YFB5mJRxTtK5dY5KFEV7Y94C3O/FZAuhvqGRXtkQvT4flw
jgLNPcOtLwt3AnNad8Zo
=jFdG
-----END PGP SIGNATURE-----

--=-LJ0svzOq3kXeNXuuF5OF--

