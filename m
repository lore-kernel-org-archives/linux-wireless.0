Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35588 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab0BFNfz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 08:35:55 -0500
Subject: Re: [RFC 1/2] cfg80211: generic trigger scan and callback on
 completion
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com,
	sameo@linux.intel.com, dcbw@redhat.com
In-Reply-To: <1265462416-7547-2-git-send-email-kilroyd@googlemail.com>
References: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
	 <1265462416-7547-2-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-m1Fg3RyiLZGu+5w+ircE"
Date: Sat, 06 Feb 2010 14:35:52 +0100
Message-ID: <1265463352.4041.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m1Fg3RyiLZGu+5w+ircE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-06 at 13:20 +0000, David Kilroy wrote:

> We could maintain a list of functions to call, but this isn't necessary
> for the moment. Just maintain the single function pointer to be called
> on scan completion.
>=20
> Note that we allow the caller to set the callback even when a scan is
> already in progress. This allows cfg80211 SME to scan again
> when the existing scan completes.

I think the "callback even when busy" thing is somewhat confusing. I'd
prefer if you used a standard notifier struct (probably raw since we
have rdev locking; see include/linux/notifier.h) and the callees sorted
out their state there. As it is, it's really complicated to make sure
that one request doesn't clobber another -- the current use guarantees
that but I'm not sure I want to rely on it going forward.

johannes

--=-m1Fg3RyiLZGu+5w+ircE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLbXA0AAoJEODzc/N7+QmaJUUP/RFSaxo+nI/qhHob0fkyKTmK
O/ZtV+hwDuMfYEzklBmRjhNvC389y+fvvnB2HMGzx6jZQ6uZ1eygFBxz+l5+NFke
odd3mSdWqC+lcdAzYpgqrSvYvBBNV/x6qS6g7s+CssBHhafhFEVPEntw0jNofsFy
P+2dbY1Y+iJILFViO6/EoDdoDm+d/29ODEGjxi/S+I42Q69meQBYGacBdTUVBfHC
cAohrf342PeNIFlIz+2hU7AVVBivj/g5iULxAymLDD4neLN9+JhXWXKRgv7NLu4m
Jmv5VZKUngELy/ruVVDUoeiu4Gr25422IcB3FH/msdVUruLrCtccNrAcb4TaeuVG
gD/n4N2yXEdpn5tH3OYfBaE2J+UE+kmy7jc+nGgbbQApVeFCm3u4joHlPMT+oUoc
252PiPTaP+9DUvROGKhpudBgHubh8z3uDWHRTlMovBIYY3yY2wqZ08VJ7qNZfXXi
WbOjKbfQStDevWESoaw2bwqmKE71pysD+WAX9wFIqVS4HdCvKSwpl48w1WcvHKNu
O8QaoM/ytYKY6tSFihlGrkNQf0Pu/kXYQaLsvJOh3eMCPGayVWSYhhaVEslJIb/T
DC415mBgQNmW8Y1+NHQoN1gYJ/e+Dq/3adPJTWsl3vFBCZ5eTZxKY4sMxUqiy5lt
quwUx+R3c8jGC0n8wIek
=CfSe
-----END PGP SIGNATURE-----

--=-m1Fg3RyiLZGu+5w+ircE--

