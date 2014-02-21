Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaBUJvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 04:51:08 -0500
Message-ID: <1392976254.4346.45.camel@jlt4.sipsolutions.net> (sfid-20140221_105118_737516_F5C82573)
Subject: pull-request: mac80211-next 2014-02-21
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 21 Feb 2014 10:50:54 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Rbct4aGmzOboipy0/MyO"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Rbct4aGmzOboipy0/MyO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

More content for -next ... :) I've merged wireless-next to get the TDLS
patch to apply properly without causing undue conflicts in mwifiex.

This time, I have a number of small fixes and improvements, and those
are fairly straight-forward. More interesting changes come from Luca
with some preparations for the CSA work, mostly around interface/channel
combinations checking. One other possibly interesting change is a small
one by myself to add NAPI support back to mac80211, which can help
improve TCP behaviour through GRO.

Let me know if there's any problem!

johannes

---

The following changes since commit 35582ad9d342025653aaf28ed321bf5352488d7f=
:

  Staging: rtl8812ae: remove modules field of rate_control_ops (2014-02-13 =
15:23:23 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 6658ab80fd4ef940fc2366ddb66690a15ea69c18:

  mac80211: ibss: handle cfg80211_chandef_dfs_required() error codes (2014-=
02-21 09:37:46 +0100)

----------------------------------------------------------------
Calvin Owens (1):
      ieee80211: Print human-readable disassoc/deauth reason codes

David Spinadel (1):
      mac80211: fix IE buffer len

Eliad Peller (2):
      mac80211: reset probe_send_count also in HW_CONNECTION_MONITOR case
      mac80211: add beacon_loss debugfs file

Janusz Dziedzic (1):
      cfg80211: regulatory: introduce NL80211_RRF_AUTO_BW rule flag

Johannes Berg (10):
      mac80211: remove superfluous band variable
      mac80211_hwsim: fix number of channels in interface combinations
      mac80211: simplify roc check in idle calculation
      cfg80211: remove NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL
      nl80211: use ie_len in scheduled scan
      mac80211: add NAPI support back
      mac80211: remove erroneous comment about RX radiotap header
      Merge remote-tracking branch 'wireless-next/master' into mac80211-nex=
t
      cfg80211: document sched_scan_stop synchronous behaviour
      mac80211: allow driver to return error from sched_scan_stop

Luciano Coelho (7):
      mac80211_hwsim: allow creation of single-channel radios with chanctx
      cfg80211: docbook: fix small formatting error
      cfg80211: docbook: add interface combinations documentation
      mac80211: allow drivers to request SMPS off
      nl80211: make sure we check for DFS with mesh channel switch
      cfg80211: remove radar requirements check from cfg80211_can_use_iftyp=
e_chan()
      mac80211: ibss: handle cfg80211_chandef_dfs_required() error codes

Sunil Dutt Undekari (1):
      cfg80211: Pass TDLS peer capability information in tdls_mgmt

 Documentation/DocBook/80211.tmpl            |  2 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  6 ++-
 drivers/net/wireless/mac80211_hwsim.c       | 31 +++++++----
 drivers/net/wireless/mac80211_hwsim.h       |  4 ++
 drivers/net/wireless/mwifiex/cfg80211.c     |  4 +-
 drivers/net/wireless/ti/wlcore/main.c       |  6 ++-
 include/net/cfg80211.h                      | 24 ++++++---
 include/net/mac80211.h                      | 43 ++++++---------
 include/uapi/linux/nl80211.h                | 42 ++++++++++-----
 net/mac80211/cfg.c                          |  7 +--
 net/mac80211/debugfs_netdev.c               | 13 +++++
 net/mac80211/driver-ops.h                   | 12 +++--
 net/mac80211/ht.c                           |  2 -
 net/mac80211/ibss.c                         |  5 ++
 net/mac80211/ieee80211_i.h                  |  2 +
 net/mac80211/iface.c                        | 11 ++--
 net/mac80211/main.c                         | 12 +++++
 net/mac80211/mlme.c                         | 72 ++++++++++++++++++++++---
 net/mac80211/rx.c                           |  5 +-
 net/mac80211/scan.c                         |  9 ++--
 net/wireless/chan.c                         |  6 +--
 net/wireless/genregdb.awk                   |  2 +
 net/wireless/ibss.c                         |  7 ++-
 net/wireless/mesh.c                         |  6 +++
 net/wireless/nl80211.c                      | 33 ++++++++----
 net/wireless/rdev-ops.h                     |  9 ++--
 net/wireless/reg.c                          | 83 ++++++++++++++++---------=
----
 net/wireless/trace.h                        | 12 +++--
 net/wireless/util.c                         | 31 +----------
 29 files changed, 312 insertions(+), 189 deletions(-)


--=-Rbct4aGmzOboipy0/MyO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTByF+AAoJEDBSmw7B7bqrIiAQAJEPjyZDbPz5OqyAB2Y9quxT
MVMV2A9HxzFpK+13gzB8u9R87jKB9F1/PWCvuHcj8EJ8MmFBGZ5qmt/yNwjZtbgP
mSXOD//SJcsHx9lczGv9+NI9+Kh2k9SZC42npvGHevOPOki+zqXyopoGPQB/CQih
u0jrKWw51qrQ09pSajIipZo9Yr/yGvShhGBTnpXDPlnsMAZAi6fzzz3R4SpR5uWI
5LgU/64hi20rGA2seHmyUUgSoioee7NYOJBjxV8oRVp1SMEeW00GoOEqt0TRdDzc
q80UxdRPo/GzA5wVLu43RJtifGt7Ck2CrT9DAPjHhMmJalxs/3g3ue+FnMm7sFJr
exU1ee0TlR46+aCBCGHEO6WAQd2TN1LMEV0tROVzHt1vLao21Nu2rjR1wHQXF1wv
Q1J1GcBtW63BcOGMrU5EeJx3FDwEL3jG5M86dPyxTdIg3bPpRPlOU04VXKndbNYv
gEuDXgPANoyOjUcGVsJiJNig95SivrxhRDwD6v7hLon+xKsCNnTgtxhehRt+H5OR
aa6/Ocl1tkjOQoQkeLYxYZ5BP/dQUMgT2xOwhN0hn3Pu+o6TTX2skBfWjhYg0HE8
JhJLVqvAvcQkoiDcfIOvJGq5puChsREUf+uBuBOXL5IO3sqMef9qkERzQyB6Bs6k
TDthqIQX9YlqJ0GWvLi5
=IWkC
-----END PGP SIGNATURE-----

--=-Rbct4aGmzOboipy0/MyO--

