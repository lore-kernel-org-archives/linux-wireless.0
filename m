Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbXIDNlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 09:41:08 -0400
Subject: Re: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <20070904011648.GX1835@jm.kir.nu>
References: <1187987850.24933.29.camel@johannes.berg>
	 <20070904011648.GX1835@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Rfn9NFHfaCPGaXXYa+0J"
Date: Tue, 04 Sep 2007 15:42:15 +0200
Message-Id: <1188913335.9942.16.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Rfn9NFHfaCPGaXXYa+0J
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-03 at 18:16 -0700, Jouni Malinen wrote:

> Where are things like NL80211_ATTR_IFNAME and
> NL80211_CMD_ADD_VIRTUAL_INTERFACE defined? I would assume these are from
> linux/nl80211.h, but where should I get the version that includes these?

You have to use the one from wireless-dev as we don't ship it from
mainline yet.

> This is making it a bit difficult to build driver_devicescape.c and same
> goes for the requirement for svn trunk version of libnl.. Any idea how
> much code from libnl is needed here? Would it be major effort to do the
> needed calls without having to rely on libnl at or (or at least not on
> an unreleased svn trunk version)?

There's a whole bunch of code in libnl I use, all the generic netlink
family resolving etc. Maybe Thomas can prerelease a libnl with generic
netlink support?

> This is not good direction to go to.. I would really not like to include
> linux/*.h unless absolutely needed since these header files have been
> very likely to conflict with glibc ones and there is not really that
> much guarantees in people wanting to keep kernel header files suitable
> for inclusion into user space programs.

Actually, the latter point hasn't been true for a long time, ever since
David Woodhouse cleaned up exporting kernel headers to userspace glibc
has happily shipped them.

> I would much rather use these for now and should the /usr/include/linux
> directory in most distributions some day have all the needed stuff, then
> we could move towards using those.

It really ought to have the wireless stuff except for nl80211.h

johannes

--=-Rfn9NFHfaCPGaXXYa+0J
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3WC3/ETPhpq3jKURAhMrAJsETljPn1gKR7OjvMI5Ynzi+GfU0QCgo6Ch
UX3tPnrToL56fIow79iXCbo=
=vLGx
-----END PGP SIGNATURE-----

--=-Rfn9NFHfaCPGaXXYa+0J--

