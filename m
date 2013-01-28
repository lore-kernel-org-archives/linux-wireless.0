Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3A1MZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 07:25:26 -0500
Message-ID: <1359375945.8120.13.camel@jlt4.sipsolutions.net> (sfid-20130128_132530_483102_11AAEF33)
Subject: pull-request: mac80211-next 2013-01-28 (was: pull-request:
 mac80211-next 2013-01-24)
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 28 Jan 2013 13:25:45 +0100
In-Reply-To: <1359045496.21908.11.camel@jlt4.sipsolutions.net> (sfid-20130124_173759_769373_43373817)
References: <1359045496.21908.11.camel@jlt4.sipsolutions.net>
	 (sfid-20130124_173759_769373_43373817)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-G2wPyHBm5M0kc6vKjfDF"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-G2wPyHBm5M0kc6vKjfDF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Please ignore the previous pull request. I've updated my branch with a
few more commits, this is the combined pull request.

I've included
 * AKM definitions from Bing,
 * mesh fixes from Thomas, including a fix from him for me breaking his
   patch while applying,
 * channel check fix from Simon,
 * an old patch from Yoni Divinsky who doesn't even work for TI any
   more, to configure the WEP TX key for ARP offload etc.
 * MAC ACL API from Vasanth
 * a fix for the infamous chanctx_conf warning from Arnd
 * from myself, a fix for my previous aggregation changes, some cleanup
   and some improvements and fixes for WoWLAN

Let me know if there are any problems.

Thanks,
johannes

The following changes since commit 5a32aff37a02ebc959837f08d09ac8ba65d4f1b0=
:

  mac80211: split out chandef tracing macros (2013-01-16 23:57:51 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 3b4797bce0050570e84bedd10e1b14e9320a3551:

  mac80211: fix mesh_sta_info_get() reshuffle damage (2013-01-28 13:15:34 +=
0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      mac80211: avoid a build warning

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

Thomas Pedersen (3):
      mac80211: clean up mesh sta allocation warning
      mac80211: support mesh rate updates
      mac80211: fix mesh_sta_info_get() reshuffle damage

Vasanthakumar Thiagarajan (2):
      cfg80211: Move the definition of struct mac_address up
      cfg80211/nl80211: add API for MAC address ACLs

Yoni Divinsky (1):
      mac80211: add op to configure default key id

 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   5 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   1 +
 drivers/net/wireless/ti/wlcore/main.c              |   3 +-
 include/linux/ieee80211.h                          |   5 +-
 include/net/cfg80211.h                             |  42 +++++-
 include/net/mac80211.h                             |  31 +++-
 include/uapi/linux/nl80211.h                       |  51 ++++++-
 net/mac80211/agg-rx.c                              |  14 +-
 net/mac80211/agg-tx.c                              |  61 +++++---
 net/mac80211/driver-ops.h                          |  36 ++++-
 net/mac80211/ieee80211_i.h                         |   3 +-
 net/mac80211/iface.c                               |   3 -
 net/mac80211/key.c                                 |   5 +-
 net/mac80211/main.c                                |  64 ++++++--
 net/mac80211/mesh_plink.c                          | 168 +++++++++++++----=
----
 net/mac80211/mlme.c                                |  42 ++----
 net/mac80211/sta_info.c                            |   5 -
 net/mac80211/trace.h                               |  53 ++++++-
 net/mac80211/tx.c                                  |   8 +-
 net/wireless/core.c                                |   5 +
 net/wireless/nl80211.c                             | 116 ++++++++++++++
 net/wireless/rdev-ops.h                            |  12 ++
 net/wireless/trace.h                               |  18 +++
 net/wireless/util.c                                |   3 +-
 24 files changed, 576 insertions(+), 178 deletions(-)


--=-G2wPyHBm5M0kc6vKjfDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRBm5JAAoJEDBSmw7B7bqr9W8P/REH1/j80SdFsJn2ExZ3pcGh
Ktjk6n80f8D6AG6hrCt5IJlfvFFSfBjcFj8GQ81uPtlvoXiLf2VoijUViYl6Lfy8
yT5TgmPI/jEJg9ovALXA/7CAVeBtewgLx/DWP2+qeBQCpkIm827p7oF2NHzcWbhU
PPg/U9RHywU1hUgFhZfJjrZGbvjpzZg4Y/kaQEBl465rSmsep1RMjYA5yXsIvybI
81aT8fJnnKRBlmXA2sJprjdgZkWXpHEGEULJwrLy0Uj2UJNwZBi7z8wdBhsyyGpT
Dj81k/HW6WOnMhxkgFmCH/3bGkAwmorN5/t66jaX3mfbCrOmExGt5vaYR7Izh7bU
XwMbv9F8RU3PhgmkMk4L2fgHarsir9oDxx0qu/QJ2YlCaK+ljQcD8cmp9j+3txWE
qs5Vei/rr5aCAX4S7HIe1oU3e+qy8Idcvbu6/RZslLiumGIPASAKCpaiLirXL2WF
wW2CgscoPuJ0/LVf/hwp8uUcmpYrEkBUNQ/6l3kpKahEqyLmXyY0fZQHDy0F7oqx
jlucpCJ/zBf0u12jTJNVZI0YWbOV8fsHLF0GSd7FTJgQIQ1nWWvSb21FtjgjPFJk
miDDF6FCdm8+zDcuQ56ALxikyc4hecgqM/DYSZlsSeA4uNYZ+7c1zochWmbGuXfb
kWw0GWnwre31EyG1N3S3
=Q8aU
-----END PGP SIGNATURE-----

--=-G2wPyHBm5M0kc6vKjfDF--

