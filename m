Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41666 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab3CDMzE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 07:55:04 -0500
Message-ID: <1362401694.21028.6.camel@jlt4.sipsolutions.net> (sfid-20130304_135511_332981_C1CF0D11)
Subject: pull-request: mac80211 2013-03-04
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Mar 2013 13:54:54 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-d5VziB83ZgMKo75PV9HP"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-d5VziB83ZgMKo75PV9HP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John

I've accumulated a number of fixes for the 3.9 stream again. We're still
looking for a few more bugs though, but for now this.

Here I have fixes from Ben Greear for stray work items when deleting
interfaces, another idle handling fix from Felix, a fix from Marco ro a
mesh PS buffering crash and I have a fix for the VHT MCS calculation in
association request frames and more nl80211 feature advertising removal
as well as a workaround to increase the dump size if the SKB overhead is
too large. For 3.10 I already have a complete fix queued, but that also
requires (simple) userspace changes.


Let me know if there are any issues!

johannes


The following changes since commit cb601ffa326bc5c74a6ecd8e72ae9631e5f12f75=
:

  mac80211: fix monitor mode channel reporting (2013-02-26 21:53:38 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 801d929ca7d935ee199fd61d8ef914f51e892270:

  mac80211: another fix for idle handling in monitor mode (2013-03-02 21:24=
:42 +0100)

----------------------------------------------------------------
Ben Greear (2):
      mac80211: stop timers before canceling work items
      mac80211: Fix crash due to un-canceled work-items

Felix Fietkau (1):
      mac80211: another fix for idle handling in monitor mode

Johannes Berg (4):
      nl80211: remove channel width and extended capa advertising
      mac80211: really fix monitor mode channel reporting
      nl80211: increase wiphy dump size dynamically
      mac80211: fix VHT MCS calculation

Marco Porsch (1):
      mac80211: fix oops on mesh PS broadcast forwarding

 net/mac80211/cfg.c     | 21 +++++++++++++--------
 net/mac80211/iface.c   |  6 ++++++
 net/mac80211/mlme.c    | 28 ++++++++++++++++++++++-----
 net/mac80211/tx.c      |  3 ++-
 net/wireless/core.c    |  3 +--
 net/wireless/nl80211.c | 51 +++++++++++++++++++++++++---------------------=
----
 6 files changed, 70 insertions(+), 42 deletions(-)


--=-d5VziB83ZgMKo75PV9HP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRNJmeAAoJEDBSmw7B7bqrD/QQAK7dwWYh3CfQ10qERfZ5tr+2
m6dn2uMnNla9enR6iuS0qVtBoT58JHozK0wbMrfnLz96/Ah+0WEgu82zZB7LavLn
TBlZFHJMHiItEDdDvoKXatXkOzyGkJn1P3l6DSV2/ZsB3eoB3/JuGtxLd1T/tMmI
ZhJrpa5mgv2Gby0vC/fcI/P6xJdtSEnG0uiOwiLDtxQ/ockv5tU+g4cx2/AlnLWK
OSUrDs3Hs1pv7YEA52MgGVPR2vM8Pmb6hUglHXZQCIR0j7Eizjl1dHmoqWTq/9FE
z8MPEloMkkA87uOYpnGk45mfSJxfGPjVMVdSB90z0UczI5cD0UzQy0l8oeHFA1Sv
eYft3GsfLw7oSZEKLwuATWGavlVLYkOYgI3SbslxNqdMcTQH05cgDxD6SUOwlr6b
0X2sSF7obOChn6RpMgc8UZCj1dL1Ccw3DfsEYrIvyxKE+Z0KJN9Rlx26ASertSJN
KhyS66UsewB/SaRfnPcr5TTiFyiFWcXEH7p1yAeJaM0lj0lorfkYjFOrGsS7WznM
FS5aJdZhHA/J9rwWVyWShH820IpoLeWE9za/3rMScrc5zFoHYQ47JjUOcnkaSJdN
jEpalMgwkofoE1/7/saPLjX2kMSh32P3MfUjz69qWCWiccQmmnTPuq9UDK2spJAg
VMz3dm5Q3sy/sHVuy+XV
=aqLW
-----END PGP SIGNATURE-----

--=-d5VziB83ZgMKo75PV9HP--

