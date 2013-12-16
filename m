Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3LPPQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:16:28 -0500
Message-ID: <1387206978.2057.26.camel@jlt4.sipsolutions.net> (sfid-20131216_161632_469312_3B16527C)
Subject: pull-request: mac80211-next 2013-12-16
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 16 Dec 2013 16:16:18 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-pjs8Yq3MrVyTACWKablA"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pjs8Yq3MrVyTACWKablA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And another set for -next ...

Here I just have a collection of fixes/improvements/cleanups, very
little really stands out apart from CSA fixes, vendor command support
and the RCU speedups.

Let me know if there's any problem.

johannes


The following changes since commit 55957fb7a0b61d8ab6ff3f04e279b8fc22b738fa=
:

  ath9k: initialize retry chain flags in tx99 code (2013-12-11 10:56:22 -05=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for=
-john

for you to fetch changes up to 204e35a91c4b3327b7239d7687fbd4923edbbf08:

  nl80211: add VHT support for set_bitrate_mask (2013-12-16 16:05:17 +0100)

----------------------------------------------------------------
Barak Bercovitz (1):
      cfg80211: stop sched scan only when needed

Chun-Yeow Yeoh (1):
      nl80211: allow the use of DFS channel in mesh

David Spinadel (1):
      mac80211: reschedule sched scan after HW restart

Eliad Peller (4):
      mac80211: remove duplicate code
      mac80211: determine completed scan type by defined ops
      mac80211: start_next_roc only if scan was actually running
      cfg80211: don't "leak" uncompleted scans

Felix Fietkau (1):
      mac80211: let the driver reserve extra tailroom in beacons

Janusz Dziedzic (4):
      nl80211: don't clear bitrate_mask twice
      nl80211: allow setting bitrate mask back to default
      cfg80211: in bitrate_mask, rename mcs to ht_mcs
      nl80211: add VHT support for set_bitrate_mask

Johannes Berg (14):
      Revert "mac80211: add driver callback for per-interface multicast fil=
ter"
      mac80211: move align variable to remove __maybe_unused
      nl80211: vendor command support
      mac80211: neaten ieee80211_deliver_skb
      mac80211: warn if unhashing station fails
      Merge remote-tracking branch 'wireless-next/master' into mac80211-nex=
t
      mac80211: add pre-RCU-sync sta removal driver operation
      iwlwifi: mvm: use pre-RCU-sync sta removal operation
      mac80211: move 4-addr sta pointer clearing before synchronize_rcu()
      mac80211: don't delay station destruction
      mac80211: move synchronize_net() before sta key removal
      mac80211: optimise synchronize_net() for sta_info_flush
      mac80211: optimise mixed AP/VLAN station removal
      mac80211: free all AP/VLAN keys at once

Luciano Coelho (4):
      mac80211: lock sdata in ieee80211_csa_connection_drop_work()
      mac80211: make ieee80211_assign_beacon() static
      mac80211: refactor ieee80211_ibss_process_chanswitch()
      mac80211: align ieee80211_ibss_csa_beacon() with ieee80211_assign_bea=
con()

Luis R. Rodriguez (2):
      cfg80211: add reg_get_dfs_region()
      cfg80211: DFS check dfs_region before usage

Marek Kwaczynski (1):
      nl80211/cfg80211: Set Operating Mode Notification

Max Stepanov (2):
      mac80211: check pairwise key_idx on get_key call
      mac80211: read station mgmt keys via get_key call

Simon Wunderlich (1):
      mac80211: fix nested sdata lock for IBSS/CSA

Thomas Pedersen (1):
      mac80211: update adjusting TBTT bit in beacon

 drivers/net/wireless/ath/ath6kl/wmi.c          |   6 +-
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |  13 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |  23 ++
 drivers/net/wireless/iwlwifi/mvm/sta.c         |  11 +-
 drivers/net/wireless/mwifiex/cfg80211.c        |   6 +-
 include/net/cfg80211.h                         | 123 +++++++-
 include/net/mac80211.h                         |  45 ++-
 include/uapi/linux/nl80211.h                   |  65 ++++-
 net/mac80211/cfg.c                             |  30 +-
 net/mac80211/driver-ops.h                      |  32 +--
 net/mac80211/ibss.c                            |  74 ++---
 net/mac80211/ieee80211_i.h                     |  21 +-
 net/mac80211/iface.c                           |  49 +---
 net/mac80211/key.c                             |  60 ++--
 net/mac80211/key.h                             |   3 +-
 net/mac80211/main.c                            |   8 +-
 net/mac80211/mesh.c                            |   5 +
 net/mac80211/mesh_sync.c                       |   9 +-
 net/mac80211/mlme.c                            |   2 +-
 net/mac80211/pm.c                              |   3 +-
 net/mac80211/rx.c                              |  33 +--
 net/mac80211/scan.c                            |  80 ++++--
 net/mac80211/sta_info.c                        | 118 ++++----
 net/mac80211/sta_info.h                        |  30 +-
 net/mac80211/trace.h                           |  58 +---
 net/mac80211/tx.c                              |  12 +-
 net/mac80211/util.c                            |  34 +++
 net/wireless/core.c                            |  25 +-
 net/wireless/core.h                            |   6 +-
 net/wireless/mesh.c                            |  13 +-
 net/wireless/nl80211.c                         | 380 +++++++++++++++++++--=
----
 net/wireless/reg.c                             |  27 ++
 net/wireless/reg.h                             |   1 +
 net/wireless/scan.c                            |  16 +-
 34 files changed, 909 insertions(+), 512 deletions(-)


--=-pjs8Yq3MrVyTACWKablA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJSrxlCAAoJEDBSmw7B7bqrxYcQAL+WXP1RdxbIAiZdsyuUH3V/
mbBMDN9czNBgnCXnDaYC4/N7l3DSWAelAPY7Cat3lyIAp3cnwpJE1q3fwc+U4I4p
MZkCs4rIMK3rzTRZNuey7uaFVWWFYE52odzKQb0AwC2v7repBtoDoPTpUccdtp0O
K8tZFg7iMsWg4WPy6VT9zZbOgwKs71ieMkhn3buFDOYbjZeBc4iL3xsHwXs74aIG
2mEUqqHUfcmFfKrcRH0tCLpYJibrls5guFu6ENC3+BB2CxAi/fyJmB3e9WKrFQe0
cLY4pfvZRPhnShn3t+2zD9RTciy8WJk5f5k2SDHm2KX61JIeAT4ouKJh0y8FAtQC
VuYUgQBcJdLpmmzwZTTr/jlAvfJNOH5zGPWezQtZMwlkrKUMGJ5VFeMK4KJrvTTx
9hQwX6Mra3e+RQvAW7L0UF441IrB0ph23JluIF47mIeGug7YmJdYNpOA3dF9h6fu
HDYl5YdXR1q0QhOeeLTvKbsn1pj0gcUYetDNBoXRhe3xi+5clMHpt7sc0Zq1Pobm
iG4RBe7PuGAgKkT4GtO0lnAGYesbG66saX4mK0udmp18ePQEedvDkWq6WD0GoRa9
fQoUN4xK9uibZfbLX6lmnlegJgH32GbT0j+sfdAqNnj8psWoTuQp/THpl346vHOA
YkFUnUqv5zyiKYu5HPuS
=bBWu
-----END PGP SIGNATURE-----

--=-pjs8Yq3MrVyTACWKablA--

