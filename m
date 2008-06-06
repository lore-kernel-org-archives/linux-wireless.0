Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57774 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYFFIPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 04:15:40 -0400
Subject: Re: mac80211 organization
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1212705015.6340.58.camel@brick> (sfid-20080606_003018_948305_421B849D)
References: <1212705015.6340.58.camel@brick>
	 (sfid-20080606_003018_948305_421B849D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2HPtdeG/G8YDI6jHRNSu"
Date: Fri, 06 Jun 2008 10:13:48 +0200
Message-Id: <1212740028.698.16.camel@johannes.berg> (sfid-20080606_101547_277685_9E5F6E7E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2HPtdeG/G8YDI6jHRNSu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-05 at 15:30 -0700, Harvey Harrison wrote:
> Could you give me a quick rundown of the differences/thoughts behind

Sure.

> include/linux/ieee80211.h

That's intended for IEEE 802.11 specific stuff that full-mac drivers
could use too, mostly protocol-related defines and helper macros/inlines
(it has no corresponding .c file so you can't have actual functions.)

> include/linux/net/mac80211.h

That declares the mac80211 specific stuff.

> and net/mac80211/ieee80211_i.h

That's internal to mac80211.

> I'm trying to figure out where some of these helpers should go, but it
> would be easier with a bit more context.

Many should probably go into the first category as they could be useful
for others. Note though that there's net/ieee80211.h too with stuff for
the ieee80211 stack, and linux/ieee80211.h needs to be compatible with
both net/mac80211.h and net/ieee80211.h

johannes

--=-2HPtdeG/G8YDI6jHRNSu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEjxu6Vg1VMiehFYAQKZJg//f9xkRsxpfUjP24Qnh2uLqJWF4tbMQuHm
YIE+KAf1GrJuPNKoBURxC23MhWD6JheHjLax8IzA9N/y+bo7YT8UNijiAvKsyqZv
GUl/QJYrCYuDmGjnfbTOh5eyWpYUBkdhYij2Amfjx0/Yj7CKWTvoZfTrnrwC9F69
cggJ5uhL1u1i+f9mM6hSfKAOJUc3fSpIm0LuqCuMrQbMq8Cldw8JxyDmtmeITbjo
pOTTOUblovRolY50Wqd7P3I9LLgzuw77QmvbPIGzbLwxROYyII8qyPCAXYwkbt6T
Mkcl0OLdKoTsaSqFraMeb3MH0eESfstgjelxPNR8mJHK3k0NUVirRdWpH72E/DOZ
XxLBnYCkr5Gm0YEGzSyEsznwoz75NIIMukIdfqWP4vDNv3uFLi4g++Anr3D5nsBL
vcLo3DmXyjQXW/aa3iuxPnsyqs6pyl507RMMCkz5W48j94Euek1A8k8qd5QYcAC+
DPxAnnuRpo26XvxO89r9NxUqgIAm9FeBXZHdMf+Xg/FGmbV+HN5EDmfrE4EMO0gy
kupKe3M+DJdDFcG0CRuJanDB9aIqxmQwhREUOzJ4vJ7VkIXFBItZxnAwf2Q4n9XV
NRxvGfEul/t/G8ZdmtHraJgjAH2Nnn3k7DOBzOUCZWtnnCCQ+l2xQ0pDB2PLazsz
HTSRrdUbTWs=
=WvQm
-----END PGP SIGNATURE-----

--=-2HPtdeG/G8YDI6jHRNSu--

