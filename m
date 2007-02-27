Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbXB0TPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 14:15:38 -0500
Subject: Re: Patch to allow specification of interface name prefix
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1172602341.3291.8.camel@dv>
References: <510326.55988.qm@web50211.mail.yahoo.com>
	 <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
	 <45E112F7.9090908@lwfinger.net>	<20070226150241.1b5b63b2@freekitty>
	 <20070227111644.784600be@logostar.upir.cz>
	 <20070227094108.11f4844f@freekitty>  <45E4769E.2040102@candelatech.com>
	 <1172602341.3291.8.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GZ8DuXEK5r86DnsdiPBZ"
Date: Tue, 27 Feb 2007 20:15:08 +0100
Message-Id: <1172603708.3870.265.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GZ8DuXEK5r86DnsdiPBZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-27 at 13:52 -0500, Pavel Roskin wrote:

> Shell scripts can do it using
> "wireless" directory in sysfs:

No, that's wrong. The 'wireless' directory there is bound to disappear
since it's created by d80211. The sysfs interface is still subject to
discussion.

I think (but also subject to discussion) the way we'll want to do is
take note of the 'wiphy' link. But to do that globally cfg80211 will
need to be taught to create that link instead of mac80211 which requires
knowledge about netdevs in cfg80211 and we still haven't quite figured
that out.

For legacy devices not using cfg80211, the only way will be to invoke
legacy wext calls on them.

johannes

--=-GZ8DuXEK5r86DnsdiPBZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5IM8/ETPhpq3jKURAi6EAJ9LLf7d/E4BaHiVdLe3JnqWPKj+twCdENaN
xIXeXiCdzPsF+cs15N+KIKw=
=LRnG
-----END PGP SIGNATURE-----

--=-GZ8DuXEK5r86DnsdiPBZ--

