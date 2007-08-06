Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762319AbXHFKQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 06:16:20 -0400
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070804074616.GA17144@deine-taler.de>
References: <1186178959.13315.30.camel@johannes.berg>
	 <46B3B2AD.1040509@gentoo.org>  <20070804074616.GA17144@deine-taler.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kdAtJ4pTkP/WB7bS4SC1"
Date: Mon, 06 Aug 2007 12:17:07 +0200
Message-Id: <1186395427.28655.56.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kdAtJ4pTkP/WB7bS4SC1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[as for the rest of the mail]

> I would suggest something like this:
>=20
> int (*enable_phy)(struct ieee80211_hw *hw, int flags);
> int (*disable_phy)(struct ieee80211_hw *hw, int flags);
> int (*set_phy_freq)(struct ieee80211_hw *hw, int /* ? */ freq, int flags)=
;
> ...
>=20
> int (*enable_mac)(struct ieee80211_hw *hw, u8 *mac_addr,
>                int filter_flags, int flags);
> int (*disable_mac)(struct ieee80211_hw *hw, u8 *mac_addr);
> int (*set_mac_bssid)(struct ieee80211_hw *hw, u8 *mac_addr, u8 *bssid);
> int (*enable_mac_beacon)(struct ieee80211_hw *hw, u8 *mac_addr,
>                       struct ieee80211_beacon_config *config);
> int (*disable_mac_beacon)(struct ieee80211_hw *hw, u8 *mac_addr);
> ...
>=20
> The call sequence could be:
>=20
> enable_phy
> set_phy_freq
> set_phy_rate
> enable_mac
> set_mac_bssid     // For AP this will be the own mac address.
> enable_mac_beacon // first mac address will be master
> enable_mac        // for second mac address if needed
> set_mac_bssid     // set bssid for second mac
> disable_mac
> disable_mac
> disable_phy
>=20
> I would make it to a rule that the setter functions could only be
> called if the corresponding layer (phy, mac) has been enabled. All
> the interface semantics for the upper layer should be handled by
> the mac80211 stack including the persistent storage of a frequency
> value before the the device has been brought up.

I don't think I like this. First of all, it's quite a large step away
from how mac80211 operates and thus a lot of work. Secondly, the driver
would continually have to look up things by mac address. As far as I can
tell everything you have there as MAC-level configuration is right now
covered by the add/remove_interface callbacks. And then what you have as
MAC level configuration is rather incomplete by only setting a MAC
address and no other MAC parameters. But as I said, many callbacks don't
make sense unless you have two (lower) MACs in the device which I think
is just a misunderstanding and you only have two MAC *addresses*. So
then mixing PHY and MAC configuration isn't so bad because you have only
one of each anyway. And having per-interface configuration to the driver
covers the remaining things nicely.

johannes

--=-kdAtJ4pTkP/WB7bS4SC1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtvUj/ETPhpq3jKURAi8OAKCJaW30Drz2YIhGZ6vX9XNtSIX2cwCgpXWt
ntSxoiYZpU72Ih8szGBLq60=
=UNR0
-----END PGP SIGNATURE-----

--=-kdAtJ4pTkP/WB7bS4SC1--

