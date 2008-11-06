Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYKFKjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 05:39:22 -0500
Subject: Re: [PATCH 3/7] iwlwifi: fix priv->iw_mode setting when multiple
	vif are configured
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1225938894.2604.140.camel@debian.sh.intel.com>
References: <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
	 <ae8368d03d2885c4942e2f9876dcaa60.squirrel@secure.sipsolutions.net>
	 <20081105000900.GA10671@mail.intel.com>
	 <1225884472.3619.72.camel@johannes.berg>
	 <1225938894.2604.140.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9jFOaDMzfaStkAng2SOM"
Date: Thu, 06 Nov 2008 11:39:16 +0100
Message-Id: <1225967956.3619.199.camel@johannes.berg> (sfid-20081106_113927_935688_98BB6C9A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9jFOaDMzfaStkAng2SOM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-06 at 10:34 +0800, Zhu Yi wrote:
> On Wed, 2008-11-05 at 19:27 +0800, Johannes Berg wrote:
> > > > This example is not correct, mac80211 will only support multiple vi=
rtual
> > > > interfaces when the driver allows this via add_interface (which I d=
on't
> > > > think yours does) and it will *never* tell you about monitor interf=
aces at
> > > > all except by way of configuring the filter differently.
> > >=20
> > > We do support add_interface in iwlagn. But it works correctly only if
> > > the second one is a monitor interface.
> >=20
> > But like I said, add_interface is _never_ called with _MONITOR.
>=20
> I'm confused. We do hook up in the configure_filter handler to set up
> the monitor. I assume you did read our code in iwl-agn.c. No?

Yes, but it confuses me that you use the monitor interface type.

> > > > Therefore, all the "is monitor" checks in iwlwifi are pretty pointl=
ess
> > > > unless you really want to have differing behaviour between "monitor=
 +
> > > > something" and "just monitor"?
> > >=20
> > > In case of BSS + monitor, we need to tell firmware about the
> > > association status. This differs with pure montior mode.
> >=20
> > You can only distinguish those by the filter flags, and should probably
> > base the firmware knowledge on that. We want to be able to pull up
> > "plain" monitor interfaces w/o any special flags that show things
> > exactly as they'd go to mac80211 if the monitor interface was not
> > present. I suspect you should look at the FIF_OTHER_BSS flag?
>=20
> We do handle FIF_OTHER_BSS in configure_filter. Please take a look at it
> and let me know if anything is wrong.

Ok, for one, it seems weird that you're saying you handled
 * other bss
 * allmulti
 * bcn/presp promisc
 * control
without doing anything. Does your hw/fw really always pass up control
frames? I didn't think it does.

Also, it seems rather odd that you need to reconnect etc. when a monitor
interface is added, that would destroy AP and mesh modes completely when
somebody adds a new monitor interface on AP mode to see what's going on.

Can you really not actually implement the filter flags but have to
completely reprogram the firmware for monitor mode? What exactly does
monitor mode do? It seems that at least, the logic in configure_filter
should mask out the control/allmulti flags when otherbss is not set,
because right now, if I add a monitor interface that _only_ asks for
control frames and _not_ other bss frames, it doesn't look like it would
work.

johannes

--=-9jFOaDMzfaStkAng2SOM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEslRAAoJEKVg1VMiehFYxqsQALtGNR6XYmlqf9nNAZjNzMRE
9VTYC/Miz0B0tYTBkxV4KRR7Lymc8TnsyMfbTatA9+y/vmYuc98M+y1MpmrOibU0
4Z4mHDsPxvApqbIrtYgm0bBHV+XE2cLjpjGvR6tqRzIC0eS1XpcCrTOTAJ7La5K+
6iSc6g2TwNbdJeDA6MyQ/4ocb/exfrzm1atwsi9LhtJ3YwY4khdrUTJ5vPcjdgQM
Vr5LgyIKxDTlXhHHqYPU6A5FvEgoj/HeKLFyujQQkSONN3uBw5P98lGjWC3tUDs5
Igh9v38uo5GpEIyReYDK8dvg+Ej3fPRiXQZv6QlD+K8McdLf5IK3SkrqDro09Wmz
j3B5VI5WFziFbvh/OSHhmv8WVjeii2BEFRlC91T2ja/zhKoQw1bU1CJCek062K2j
H/BZVSGaHjDjT8dIhbrLHrx64gpGXK4OHZ5fmDQDhpH1u2VyETAsswOhSiuCm/9D
XT2GlZEzs+dMccXmQo7JDM70VG9CP4Yb66mUjJT6BmzYgdKUQ99dIDIsuxId8E9T
ENva6BXH1dWYtoNBkOtMH2K1F9wzAKdK3Do+knBVw++yKe5MXBsLBjaY5MGaWEfu
ywQzf5ytrGJq6Opto3RswjKyJ6Szqk7jGLAYOJ0CrG+CFLigS4qj1qT6vgYI9IpU
GGw2aiiUd1cwV7JBsgZa
=RGCS
-----END PGP SIGNATURE-----

--=-9jFOaDMzfaStkAng2SOM--

