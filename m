Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37898 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbaE1O3A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 10:29:00 -0400
Message-ID: <1401287317.8146.26.camel@jlt4.sipsolutions.net> (sfid-20140528_162904_859827_A2682BB5)
Subject: pull-request: mac80211-next 2014-05-28
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 28 May 2014 16:28:37 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-5Hl3zNiCyaLYL9cbRmPB"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5Hl3zNiCyaLYL9cbRmPB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Since you asked ;-)

The remainder for -next right now is mostly fixes, and a handful of
small new things like some CSA infrastructure, the regdb script mW/dBm
conversion change and sending wiphy notifications.

Let me know if there are any issues.

johannes
---

The following changes since commit 67af9811539be83dbdc0739215d29af23c870405=
:

  cfg80211: allow RSSI compensation (2014-05-22 09:58:49 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git HEA=
D

for you to fetch changes up to d3a58df87a2e4c2301ac843604202d290a48440b:

  mac80211: set new interfaces as idle upon init (2014-05-28 16:22:49 +0200=
)

----------------------------------------------------------------
Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

Avraham Stern (1):
      mac80211: set new interfaces as idle upon init

Emmanuel Grumbach (1):
      mac80211: fix virtual monitor interface addition

Felix Fietkau (2):
      mac80211: fix a memory leak on sta rate selection table
      mac80211: reduce packet loss notifications under load

Jes Sorensen (1):
      wireless: add missing WLAN_EID_BSS_INTOLERANT_CHL_REPORT

Johannes Berg (1):
      cfg80211: send events when devices are added/removed

Krzysztof Ha=C5=82asa (1):
      mac80211: fix IBSS join by initializing last_scan_completed

Luciano Coelho (1):
      mac80211: add a single-transaction driver op to switch contexts

chaitanya.mgit@gmail.com (1):
      regdb: Generalize the mW to dBm power conversion

 include/linux/ieee80211.h     |  1 +
 include/net/mac80211.h        | 46 +++++++++++++++++++++++
 net/mac80211/debugfs_netdev.c |  6 +--
 net/mac80211/driver-ops.h     | 53 +++++++++++++++++++++++++++
 net/mac80211/ibss.c           |  1 +
 net/mac80211/iface.c          |  2 +
 net/mac80211/sta_info.c       |  1 +
 net/mac80211/status.c         | 25 ++++++++++---
 net/mac80211/trace.h          | 85 +++++++++++++++++++++++++++++++++++++++=
++++
 net/wireless/core.c           |  5 ++-
 net/wireless/genregdb.awk     | 14 +------
 net/wireless/nl80211.c        | 21 ++++++++---
 net/wireless/nl80211.h        |  3 +-
 13 files changed, 234 insertions(+), 29 deletions(-)


--=-5Hl3zNiCyaLYL9cbRmPB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJThfKYAAoJEDBSmw7B7bqrE40P/2i0eaMoON0aBRmpDHAVIuzv
bOgiq4UvlwZbNjIhJYLbLx0RdUTlFzNTe6UY5xWSZ5dOUOAH5aCWyLGLMzVHZRLi
+bVPKP87uDL8Ox7xYmKliYAQu1lQbNIKrd4ZmbQmX5R+US9yBScbZua5eR0mVP0m
2KD4tin8RrA7Dn7qpz7mCrCU78Byky1BA69VGQBmYvt5Pao4BiaAGDt43IFnqyKb
b2HD9oqhBkr97TkF4FhMlC2a3HQBj1LTM+gKcpTUg7TAwLPJdK2fq8Q9HXErH2wz
FdobZQduA/+1UcIgLbLLKrGS54yQRMU7qJ2uQSzk1lp5D3oH5nXye0uPVEJI6YdQ
ZmwgeO3dpJfx2jG6qdosqCz1QpPhlYv8AneiE0i4cKmThuJZQvw47dN6ktP6FdDd
SxfkGaAQWFqgoql8H4DrBrJOe8oHKoQ9bH/OGYg2o+J4vKWOeix138OjlueX8c9u
a4MWEgwK76Jug6ROYdFghwStPguOOsWBuEIT72zFOlwFMD3YMCQk8+nG5tXoHq/N
6KRl6ng1rbk/klMCtoZyqoG93SY8GmVJXPXbNNY9MpFafpDZn6c3KWYm1UWxn5nd
dViiNPHGiiIc102JlB8YCJeb8Bbpm3BIh85sFG5jJGOpco4Aut3HHptjZ0juXAjg
GGPpJKkG4ECFqQecYqN0
=yL/c
-----END PGP SIGNATURE-----

--=-5Hl3zNiCyaLYL9cbRmPB--

