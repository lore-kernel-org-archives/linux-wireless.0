Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbZBEMLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 07:11:36 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Dan Williams <dcbw@redhat.com>, Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090205120730.GA18339@jm.kir.nu>
References: <20090204150857.GA5069@sortiz.org>
	 <1233789837.24227.19.camel@localhost.localdomain>
	 <1233790539.7390.23.camel@johannes.local>
	 <20090205084407.GA11126@jm.kir.nu> <20090205111058.GA16422@jm.kir.nu>
	 <1233834907.3931.4.camel@johannes.local> <20090205120730.GA18339@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ycjKwp6Gwr88ZeXeBn6Y"
Date: Thu, 05 Feb 2009 13:10:54 +0100
Message-Id: <1233835854.3931.18.camel@johannes.local> (sfid-20090205_131140_878818_A2CC689E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ycjKwp6Gwr88ZeXeBn6Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-05 at 14:07 +0200, Jouni Malinen wrote:

> (a) Currently not, but once people realize that the length field has a
> maximum value of 65535, using it as the largest attempt sounds like the
> most logical choice. In other words, yes, this will require a small
> change in programs that care (wpa_supplicant, which I already changed;
> iwlist; etc.), but the change is minimal and not doing this does not brea=
k
> anything new.

True.

> (b) Yes, user space apps better be prepared to read the results even if
> the last entry is truncated (can happen with current kernel). There is
> no clear way for the app to know that there could be more scan results
> (well, it could guess that this is the case if the returned buffer is
> very close to 64 kB), but it is not like scanning is that reliable
> operation anyway, so applications better be prepared to not always
> find every BSS in the results.

Yeah, the truncation is a little worrying. I doubt any program but
wpa_supplicant is prepared to handle that. Should we completely remove
the entry, and add some new/custom piece to stream that indicates that
we had to truncate here?

johannes

--=-ycjKwp6Gwr88ZeXeBn6Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJitdMAAoJEKVg1VMiehFYbtkP/2IkesOBMkmveTpKV81DhbTj
lN0FaMZtw/6KwXmg5L1fin7PFk343KNpbD1j4R6mzvYc9V5LvV/uWTPjKqcOESpH
b2j5Hbae8Jdrxpk6Po8O6/46LetT33hJCLiOAPK2xFn43lKGIlxOXVZe+QZmW0sP
gwahzHQF3ONzcYEz1uEtCl4UuKb4e85yjChS1jqfEiwLZWOSEdrwv4hiL+6wyhTo
Os/ZInKRsDpHh6n+fFp639ULZdAIZPgx/okFBaa4RdmvT1fvrpb/fGZWDhxz7pCK
dPX5a9xjlXk6DhMT79Su9hUYi8FMd4P/qLAaMTUVTZd89rUBARV2h9+KTQDIYkTT
lrFn0ykro6H3rL4JHLZZ+65bdaWG1pyK+wToG09qUQGFJBaAvM/veLuhK8ClZZRy
R1C6NNx3nklGGvG3tbEAWoxHlTGrvBZ4jl0qeom12G5myqwlpMmICe9LCsEyp/Ky
6W5Pn2AQoRlgN4s+aRJI1svcUIsRSEkgvOYh+bj8PmxoVkP2mR3vJV/0YXWINZuZ
ywQ5iPEm2LKxKMGPiKEgxedVhA+bXrJrhT7up8wXj6TdJg9/15lkDzCZ63M/QPeH
DuEAKHihojiD96P5vf2Y5zkrzqGgag9Adn03/dMDIyZHSrGzYhhRWQZM4CbucLoh
8Og80z5lVWnGwkGvpTyG
=0fp6
-----END PGP SIGNATURE-----

--=-ycjKwp6Gwr88ZeXeBn6Y--

