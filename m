Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3AXQh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 11:37:56 -0500
Message-ID: <1359045496.21908.11.camel@jlt4.sipsolutions.net> (sfid-20130124_173759_769373_43373817)
Subject: pull-request: mac80211-next 2013-01-24
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 24 Jan 2013 17:38:16 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-/pliA9o90tucsz40NWGN"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/pliA9o90tucsz40NWGN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

For mac80211-next, I have a few more patches:
 * AKM definitions from Bing,
 * mesh fixes from Thomas,
 * channel check fix from Simon,
 * an old patch from Yoni Divinsky who doesn't even work for TI any
   more, to configure the WEP TX key for ARP offload etc.
 * from myself, a fix for my previous aggregation changes, some cleanup
   and some improvements and fixes for WoWLAN

Please pull.

Thanks,
johannes

The following changes since commit 5a32aff37a02ebc959837f08d09ac8ba65d4f1b0=
:

  mac80211: split out chandef tracing macros (2013-01-16 23:57:51 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 782d2673655c05a1c0335fe0ee4cb62c23bcc231:

  mac80211: remove redundant check (2013-01-24 16:07:58 +0100)

----------------------------------------------------------------
Bing Zhao (1):
      ieee80211: define AKM suite selectors type 5, 6 and 7

Emmanuel Grumbach (1):
      mac80211: provide the vif in rssi_callback

Johannes Berg (5):
      mac80211: remove ARP filter enable/disable logic
      mac80211: improve aggregation debug messages
      mac80211: allow drivers to access IPv6 information
      mac80211: fix aggregation state with current drivers
      mac80211: remove redundant check

Simon Wunderlich (1):
      cfg80211: fix channel check in cfg80211_can_use_iftype_chan

Thomas Pedersen (2):
      mac80211: clean up mesh sta allocation warning
      mac80211: support mesh rate updates

Yoni Divinsky (1):
      mac80211: add op to configure default key id

 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   5 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   1 +
 drivers/net/wireless/ti/wlcore/main.c              |   3 +-
 include/linux/ieee80211.h                          |   5 +-
 include/net/mac80211.h                             |  31 +++-
 net/mac80211/agg-rx.c                              |  14 +-
 net/mac80211/agg-tx.c                              |  61 +++++---
 net/mac80211/driver-ops.h                          |  36 ++++-
 net/mac80211/ieee80211_i.h                         |   3 +-
 net/mac80211/iface.c                               |   3 -
 net/mac80211/key.c                                 |   5 +-
 net/mac80211/main.c                                |  64 ++++++--
 net/mac80211/mesh_plink.c                          | 166 +++++++++++++----=
----
 net/mac80211/mlme.c                                |  42 ++----
 net/mac80211/sta_info.c                            |   5 -
 net/mac80211/trace.h                               |  53 ++++++-
 net/wireless/util.c                                |   3 +-
 17 files changed, 332 insertions(+), 168 deletions(-)


--=-/pliA9o90tucsz40NWGN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRAWN4AAoJEDBSmw7B7bqrpnAP/1KTvG8JLAG0xPMchdFkndJi
WESX1TLScybcAmll65D1HxP7cPtyGHmmNYpv7a7pHo4T05TH+ktlMURqXFg2T8I5
CJp5B37LvDd4KesoD4LpiaZykQ3HcFZ9v100Kv4jS2qTV2jqlK6zjYYGO1AxmeK9
v7+aIHQCLegHuHVBBr/rdWQeocBGJHpGEZq2nJQ7mvZHMu3mxKNWvThIpdXEzpUS
McMuAlwMcOikEyRLI2pUJ6f43N7hf2ackxVZSqCkdG1trmhbKp3VifVVt2iXQ5qu
0bXNmQQOftSq9GA32D8TryxFmKm+Vy6EE08HKAQIngYsSCZ+AwE1V7KyumHTYPzB
SI1lMQDuIpZylcP63Ig4qvefQQB6riU4i6JOQ9fKnKssn33DChpcROXq/8TV47It
FR7pIjv6aAV6aZSFQtXsV7GyyMq2+t2PVUDmyGdlOSyYTyRS7tfarxBBtCU4Rq2K
5Kw/UepDBbZ0FK1i8uJA/ayEdJu/dRGUA7NshjpLeb0QMIe62L2EfVtWw+37bubb
J89egyaFwqcEL+iFuHvnwFI+5Uw9mQRzuH7ABZbFhkzkqZi6ZnXm9/wCtp5Zz2eJ
p1+BijYN+V8TkStjbFJ6vGx7y8NCtVeb964d70i97/Efu67Enu4ZayyFWAX2Ebvs
vm3rYy42vafLe5Xvl8Xg
=qTeh
-----END PGP SIGNATURE-----

--=-/pliA9o90tucsz40NWGN--

