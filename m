Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:33111 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753335AbXGRU3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2007 16:29:45 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: mac80211/bcm43xx deadlock
Date: Wed, 18 Jul 2007 13:28:17 -0700
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Jiri Benc <jbenc@suse.cz>
References: <1182848382.3830.5.camel@johannes.berg> <1182954090.4769.28.camel@johannes.berg> <20070718181347.GD6625@tuxdriver.com>
In-Reply-To: <20070718181347.GD6625@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1886823.LQSKGDy9xC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707181328.22000.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1886823.LQSKGDy9xC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 18 July 2007 11:13, John W. Linville wrote:
> I didn't see an answer here.  Before we remove it, I'd prefer to know
> what we thought we were protecting in the first place. :-)
>
It prevents BSSID/SSID/channel configuration from racing against userspace=
=20
configuration of the same thing. It's unlikely, however, and this deadlock =
is=20
much more serious than that race. I answered this in the patch for removing=
=20
the rtnl (01-kill-rtnl-locking.diff), though I wasn't as specific. This pat=
ch=20
should probably also go to stable.

=2DMichael Wu

--nextPart1886823.LQSKGDy9xC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGnnflT3Oqt9AH4aERAl4UAJ9imLvOWQ/FinWspNBjfhhu5+BDQgCglglC
MoZT7HvjRzBV4v0dQeYhl7U=
=V/AO
-----END PGP SIGNATURE-----

--nextPart1886823.LQSKGDy9xC--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
