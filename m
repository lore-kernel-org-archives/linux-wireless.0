Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbXIFL7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 07:59:18 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Ian Schram <ischram@telenet.be>
Cc: linux-wireless@vger.kernel.org, "Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@nbd.name>
In-Reply-To: <46DF5894.70909@telenet.be>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070831205524.GA11128@tuxdriver.com>
	 <1188872746.13078.411.camel@debian.sh.intel.com>
	 <1188915229.9942.29.camel@johannes.berg>  <46DF5894.70909@telenet.be>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-feCd75JSHwM++aJ+h9pf"
Date: Thu, 06 Sep 2007 14:00:26 +0200
Message-Id: <1189080026.28781.58.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-feCd75JSHwM++aJ+h9pf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-06 at 03:32 +0200, Ian Schram wrote:

> I thought I'd try and answer this question to the best of my ability, sin=
ce it
> has been asked before. And even though it's open source and now has been =
submitted
> to this list, leaving this unanswered feels like a creepy way of potentia=
l time bombs
> and frustration. That said I'm probably not the best person to do it.

Thanks, I appreciate it.

> iwl3945-rs:
>=20
> - the device can retry at different rates, and hence is able to deduct
> from the total number of retries a packet needed at which rates it failed=
/
> succeeded

We recently discussed this capability, atheros hardware as it as well,
so we need a generic way to tell mac80211 how many retry rates the
hardware can support so that better rate control algorithms can be
written. I don't see this as device specific but rather as something the
mac80211 driver interface is currently lacking. Cf. the "minstrel" rate
control algorithm.

> - tables of expected tpt (throughput?) which are used in the the throughp=
ut
> calculation are probably not very universal?
> there aren't identical for 3945 and 4965.

Seems to me like something the driver should be doing and reporting to
the rate control algorithm via some defined interface.

> -some synchronization of the station list with the device ucode happens h=
ere

This is totally wrong. Please extend mac80211 instead, maybe the
sta_table_notification callback.

> So that's that. Some questionable implementation details, but it does use
> device specific logic/capabilities in order to decide which rate to use.
> Now what do we do?

As a first step, I think we (i.e. mostly you because only few other
people have an interest right now) should work on defining an interface
between the drivers and mac80211 that allows the drivers to export these
capabilities like "how many different retry rates can I give you with
one packet" in order to allow different rate control algorithms to take
advantage of that. Oh and then don't just implement the interface and
push it onto us as a "ok done" thing but discuss the interface first.

johannes

--=-feCd75JSHwM++aJ+h9pf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3+va/ETPhpq3jKURAj5YAKCIXXZuAXw5xi8YZXvr/H2nlOeeFQCfeerd
nR7GUJC+w5w7Ni0InDx8e3E=
=4VYP
-----END PGP SIGNATURE-----

--=-feCd75JSHwM++aJ+h9pf--

