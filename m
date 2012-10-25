Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202Ab2JYRTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 13:19:47 -0400
Message-ID: <1351185615.10421.13.camel@jlt4.sipsolutions.net> (sfid-20121025_191951_877356_4B950B55)
Subject: pull-request: mac80211-next 2012-10-25
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 25 Oct 2012 19:20:15 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-9npkSzdxnfeAKUhDHdOj"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9npkSzdxnfeAKUhDHdOj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please pull from mac80211-next (per below pull request) to get a few
updates. Most important is probably the fix for the WDS regression that
my previous pull request introduced. Other than that, I have some
tracing code, two mesh updates and a change to allow drivers to
calculate the AES CMAC subkeys without having to implement the GF_mulx
operation themselves.

johannes



The following changes since commit d012a605108a482392be80710ea35f1db27c4aa9=
:

  mac80211: make client powersave independent of interface type (2012-10-19=
 15:43:51 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 1724ffbc7439de679d536163e03f54f35574d449:

  mac80211: complete bss_info tracing (2012-10-25 13:54:09 +0200)

----------------------------------------------------------------
Assaf Krauss (1):
      mac80211: expose AES-CMAC subkey calculation

Johannes Berg (4):
      mac80211: fix WDS channel context test
      cfg80211: add tracing for P2P Device start/stop
      mac80211: use non-atomic bitmap operation for local variable
      mac80211: complete bss_info tracing

Rami Rosen (1):
      mac80211: remove duplicate check in ieee80211_rx_mgmt_beacon

Thomas Pedersen (1):
      mac80211: mesh STAs only process mesh beacons

 include/net/mac80211.h  |   13 +++++++++++++
 net/mac80211/aes_cmac.c |   17 +++++++++++++++++
 net/mac80211/main.c     |    2 +-
 net/mac80211/mesh.c     |    9 +++++----
 net/mac80211/mlme.c     |    9 ++++-----
 net/mac80211/trace.h    |   34 +++++++++++++++++++++++++++++++---
 net/mac80211/util.c     |    2 +-
 net/wireless/core.c     |    4 ++--
 net/wireless/nl80211.c  |    4 ++--
 net/wireless/rdev-ops.h |   18 ++++++++++++++++++
 net/wireless/trace.h    |   10 ++++++++++
 11 files changed, 104 insertions(+), 18 deletions(-)


--=-9npkSzdxnfeAKUhDHdOj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQiXTPAAoJEDBSmw7B7bqrhPcQALdXDUX3izjKmfc/SSijoFjl
C0gWCE7Hy6Sw1x3oYCrDBcZzW2wHy+ZH6M0ZNRWCDkNzISoSUluIEpoky5C+6gBI
/gkrlz2QmWgMjztVgoA7gCxiVt5gl34atKV19slevfxoTN9CCQRGZMmXD7dLYvX2
/rOd6HBsRiYLQi0tX+n48ycUH77SnRfQCBhgO2zZrZy1ieAJ2Z/hhbY9bBfinQ+m
Qa44X0cMzZpgC5MPSdfLOVPn6WcS0kAWhbhYknPYL4apnJeJbGQnfZ9tHGMx5eVd
HV6kn3+31sIrJsZB5rDy0l/dDO0Z/oulShkerC/yFXFmsIMKJoklKDWrVF4q4a60
FZMScnN+CzNgndjV427L7mR8SV0Y7ISYb1jd9NrRO4P04znveYBGf6ELzMhNG+AW
3VWtlj4fS2i2xPQQwoWsZO6d39HXfS5Y/sVYe8pRI/ooGXnC+x8gxyY90VvAV/RY
xXp2ffv3f/ftlp4pe0GYnRnNOG0RtA8QaqNck4SVMr35inZLq5BErG2wi7PH5HC4
cP3aVPZeBPbhdFm+b6fxTEYhJnVfdxtLGhC+8SnSWgLqrjH0Fmz64d9Zqcd2Hshz
TgkorQYcug/PPIss5j98gea+afGQ96BNaWlRjAuU4KwghrIP/qwxUZRFihNrTQ6f
EmWDUP59jf+s5+J2gmIe
=Bn/Z
-----END PGP SIGNATURE-----

--=-9npkSzdxnfeAKUhDHdOj--

