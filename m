Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab3CVKTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 06:19:41 -0400
Message-ID: <1363947571.8238.4.camel@jlt4.sipsolutions.net> (sfid-20130322_111945_083051_806A9563)
Subject: Re: pull-request: mac80211 2013-03-22
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 22 Mar 2013 11:19:31 +0100
In-Reply-To: <1363723052.8336.6.camel@jlt4.sipsolutions.net> (sfid-20130319_205755_751711_D4ADDEEC)
References: <1363723052.8336.6.camel@jlt4.sipsolutions.net>
	 (sfid-20130319_205755_751711_D4ADDEEC)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-GGWMdf5o8ZVf/LZnH83H"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GGWMdf5o8ZVf/LZnH83H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Now I'm reviving this pull-request :-)

I have two tracing fixes (one from Vladimir), two fixes for P2P device
crashes, a fix for a BSS memory leak/lost update problem and a fix from
Ben for a scanning issue in mac80211. It's a little on the large side
because one of the P2P device problems required a bit much locking work,
but I've run through all the different scenarios (wext/nl80211,
p2p-device/station interface, ifdown/rfkill) to verify locking with
lockdep.

Let me know if there's any problem.

johannes


The following changes since commit 801d929ca7d935ee199fd61d8ef914f51e892270=
:

  mac80211: another fix for idle handling in monitor mode (2013-03-02 21:24=
:42 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 9e68a67a888d98bda8393c29dde12fb4f0b42a19:

  mac80211: Don't restart sta-timer if not associated. (2013-03-22 10:55:55=
 +0100)

----------------------------------------------------------------
Ben Greear (1):
      mac80211: Don't restart sta-timer if not associated.

Johannes Berg (6):
      mac80211: always synchronize_net() during station removal
      cfg80211: fix potential BSS memory leak and update
      mac80211: fix crash with P2P Device returning action frames
      cfg80211: fix wdev tracing crash
      mac80211: fix virtual monitor interface locking
      cfg80211: always check for scan end on P2P device

Vladimir Kondratiev (1):
      cfg80211: fix inconsistency in trace for rdev_set_mac_acl

 net/mac80211/iface.c    | 35 ++++++++++++++++--------------
 net/mac80211/mesh.c     |  3 ++-
 net/mac80211/mlme.c     |  6 ++++--
 net/mac80211/rx.c       | 14 +++++++++++-
 net/mac80211/sta_info.c | 12 +++++++++--
 net/wireless/core.c     | 57 ++++++++++++++++++++++++++++++++++++---------=
----
 net/wireless/core.h     |  3 +++
 net/wireless/nl80211.c  | 52 ++++++++++++++++++++++----------------------
 net/wireless/scan.c     | 24 ++++++++++++++-------
 net/wireless/sme.c      |  6 ++++--
 net/wireless/trace.h    |  5 +++--
 net/wireless/wext-sme.c |  6 ++++++
 12 files changed, 149 insertions(+), 74 deletions(-)


--=-GGWMdf5o8ZVf/LZnH83H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRTDAzAAoJEDBSmw7B7bqrJqkQAKVAjpC59eOVVqtYclJae4OP
KwV1rt8ujZqvps1a0vWbA7oVnl18ovyMQGaRvFfvYmaE0vPH3isRMlxKIDp7EFWP
n1kQnU1n4TB9p7CbWs6S2kzuHVy93rfb8DCZyhVbaJEpq2c0zk88Kt3DJjEGKC9y
8mfC5xsy/M7qsdtkL3x2OvAAqBHZpOhyQzB5GxGk/NZ9Xwf0VZG4LdjEUjd+ogn0
eGlWO4TmTv6+xDM3mL3qF083+QtXjP5B+W2N0Q2jMtLhqMHz7M3/AyQFnL0bBGSU
zd2+ljOISQBv7FqShnMnqXR6IRWNUI90SbZ5Tr4JpuHrQA8IcrniYpD6pokq7z4G
1Wgg8ayOTq5weCY8BOU9q2PsPR11mEvVL8FeTQim18XZPaNeEnAL5Ms0Go+ZNHk+
uJFZZrS6UNnMWu6ZCRJIvdfC0I0lIadFVtpZIa2Cv9C04kLWbXETXOJO6jL6YyS1
8hgmAe0WfFddPZhqi0FC5XL5fvdHjfske28NBKMvjmnykOirqB5LFsDspw0G/r8s
G0gaIe2qPiuXCsnvweQODMjns/uXLQxkKGZ6GxWcE6nMw17RH1ZfX+3BE4bcrSm8
pIfFNorGndWzW9lN4XV2CIoQpJ07KUaVkgWT1SoUyzpi/b1n615S6qb4EIT2ZmYW
8dO154LKGa8t8zUH62jM
=Rcvn
-----END PGP SIGNATURE-----

--=-GGWMdf5o8ZVf/LZnH83H--

