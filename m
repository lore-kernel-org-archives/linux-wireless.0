Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36055 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbZBHKgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 05:36:12 -0500
Subject: Re: generic ieee80211_sta_commit()?
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090207233507.67590@gmx.net> (sfid-20090208_003539_503598_424F18AB)
References: <20090207233507.67590@gmx.net>
	 (sfid-20090208_003539_503598_424F18AB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-neX8j8WMZaBi8oBXsbzh"
Date: Sun, 08 Feb 2009 11:36:04 +0100
Message-Id: <1234089364.4175.113.camel@johannes.local> (sfid-20090208_113616_111287_015939AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-neX8j8WMZaBi8oBXsbzh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, 2009-02-08 at 00:35 +0100, Alina Friedrichsen wrote:
> Hello,
>=20
> after a "ip link set wlan0 down" and than "ip link set wlan0 up" the
> wifi connection don't come up again. If you do a "iwconfig wlan0
> channel 4" beaconing in IBSS doesn't work anymore.

What if you set the SSID again? I'd think that would help?

> My thought to fix this is to add a generic ieee80211_sta_commit()
> function which is called after the most config changes (e.g. SSID,
> BSSID, channel, interface up, ...), so that a clean rejoin is done by
> the function and the driver hangs not in an undefined state. And I
> think it's more elegant, because ieee80211_sta_set_bssid() then
> doesn't need to call ieee80211_sta_set_ssid() anymore to do the
> rejoin.

That could make sense, not exactly sure at this point. I'm also still
wondering about the other issue with turning _off_ IBSS, with essid off
or so, see my other mail.

> What do you think about it? If agree I will implement it after
> Johannes IBSS changes are applied to avoid confusion.

Sounds reasonable, if it fixes a bug. I'd have to see the patch, I
guess. I'd like to also do assoc/IBSS stuff in cfg80211 at some point
soonish.

johannes

--=-neX8j8WMZaBi8oBXsbzh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjrWRAAoJEKVg1VMiehFYvAMP/0nn1SWSNQDOuuuj3saTjfXy
WMxrQZXuYieXQlNxXXj9Hc3aMSrsn1+L+Bldo8CddHd+0Ct9mnkMbtimANhh798+
fYc6oYKhcgPG+5fvm9g8QuPwI/ga5LW0L+Au9JCcpT6c8SbGgIsQowDuknLlCaxb
QomIPKVPrVEHrFJ+6M5x0MCbdoklHA3bwqy0vhzMs9wR3aUNJEHf0fiJkdkWHceQ
v1oaoy77RXJskWw2TgStNRKUCZM4LmtyOwO6pXLlp2BgxVzSmgAuEP8XH1M53zqH
vb8pN115ndXBbU8Wj4KphW4VZyPVxOT0rGxWIZsJfuBzVGFlU9mm+wzfduG45vc/
LEmUQ1y+Smo2Dt2d6r4EN7AHeNSRmbQvfinYixk4qTo0AkJPXSD14qKBaSk97zWi
6l8ajpISp/l8/E2b6zY45dBs9SDhKtaHYoIaPqUsPGDgyZv5E6FAG3COUtuOzamZ
/q6vdc9xNtM0u9LCYT1gPFkyhsi/cZFtZtgPPXpqiSkN9DoOY9tBCXeCjF7/ORP9
jfqhYwzyWJlo7x5oMS53GCXTFhDPnuiM0jD2EVzMoS73EmiR0CdF5CdDdnYTW3iI
c5aj0741JycJt+7BC2O3aY8blvIGRWRQSSDGLiv08PBxdltYOMuT2qeqkd3S9/Bx
N+UKZlWYfs4ugkl0zZzJ
=/YqI
-----END PGP SIGNATURE-----

--=-neX8j8WMZaBi8oBXsbzh--

