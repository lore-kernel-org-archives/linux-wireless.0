Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59880 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784Ab3E2HGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 03:06:05 -0400
Message-ID: <1369811155.8414.1.camel@jlt4.sipsolutions.net> (sfid-20130529_090609_605439_26842BBD)
Subject: pull-request: iwlwifi-next 2013-05-29
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 May 2013 09:05:55 +0200
In-Reply-To: <1369658029.14740.7.camel@jlt4.sipsolutions.net> (sfid-20130527_143407_283994_588E3186)
References: <1369658029.14740.7.camel@jlt4.sipsolutions.net>
	 (sfid-20130527_143407_283994_588E3186)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-BkktiuWAHcQFXRaPKUA7"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BkktiuWAHcQFXRaPKUA7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[resending, same text but new commit IDs]

> John,
>=20
> I have accumulated a bunch of new things in iwlwifi-next. Unfortunately,
> to resolve a (semantic) conflict, I had to merge iwlwifi, which pulled
> in some ath9k/mwifiex changes we well since you didn't merge wireless
> into wireless-next at any point. If you want to handle this differently
> let me know. The shortlog below also looks inflated because of that,
> I've also pasted the 'real' one below the pull request.
>=20
> The 'big features' I have are powersave related, including beacon
> filtering and connection monitor (which I have been sitting on for a
> while because it required a mac80211 patch) and thermal throttling/CT
> kill. The rest is mostly cleanups and small(ish) improvements.
>=20
> Please pull.
>=20
> Thanks,
> johannes

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e=
:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git fo=
r-john

for you to fetch changes up to b571a69745dc90aec3d0505a7ceac2702a93861b:

  iwlwifi: mvm: add debugfs for powersave (2013-05-29 09:03:24 +0200)

----------------------------------------------------------------
Alexander Bondar (6):
      iwlwifi: mvm: Prevent setting assoc flag in MAC_CONTEXT_CMD
      iwlwifi: mvm: Add number of DTIMs to skip
      iwlwifi: mvm: configure power management in D3
      iwlwifi: mvm: Add beacon abort enablement
      iwlwifi: mvm: Change number of DTIMs to skip semantics
      iwlwifi: mvm: add debugfs for powersave

Amitkumar Karwar (1):
      mwifiex: fix memory leak issue when driver unload

Bing Zhao (1):
      mwifiex: clear is_suspended flag when interrupt is received early

Daniel Drake (1):
      mwifiex: fix setting of multicast filter

David S. Miller (1):
      Merge branch 'wireless'

Emmanuel Grumbach (10):
      iwlwifi: move BUILD_RAxTID to transport
      iwlwifi: pcie: prefer to load the firmware in one shot
      iwlwifi: enable shadow registers for 7000
      iwlwifi: mvm: tell firmware to let multicast frames in
      iwlwifi: mvm: fix aggregation drain flow
      iwlwifi: mvm: add a missing define in firmware API
      iwlwifi: constify the source buffer of iwl_trans_write_mem
      iwlwifi: dvm: fix zero LQ CMD sending avoidance
      iwlwifi: mvm: use proper scan type for P2P
      iwlwifi: take valid ant for HT caps from TLV

Eran Harary (2):
      iwlwifi: support loading NVM data from file
      iwlwifi: fix initialisation while RF-kill is asserted

Eytan Lifshitz (1):
      iwlwifi: mvm: add thermal throttling and CT kill

Felix Fietkau (1):
      ath9k: fix key allocation error handling for powersave keys

Hila Gonen (2):
      iwlwifi: mvm: Add beacon filtering support
      iwlwifi: mvm: Add support for connection monitor offload

Ilan Peer (4):
      iwlwifi: mvm: Loosen the channel context/phy context coupling
      iwlwifi: mvm: Change PHY context handling
      iwlwifi: mvm: Allow P2P Device to use an existing PHY context
      iwlwifi: mvm: Always use SCAN_TYPE_FORCED

Johannes Berg (15):
      iwlwifi: mvm: don't assume data section is at 0x800000
      iwlwifi: pcie: dump stack on NIC error in sync commands
      iwlwifi: nvm: honour VHT enable flag
      iwlwifi: mvm: optionally store D3 SRAM after resume
      iwlwifi: mvm: sanity check context in iwl_mvm_phy_ctxt_unref()
      iwlwifi: mvm: fix NVM parsing error path
      iwlwifi: reverse DATA/INST section order
      iwlwifi: nvm: don't print NVM section reads by default
      iwlwifi: mvm: don't store section offset/length in debugfs
      iwlwifi: mvm: adjust firmware D3 configuration API
      iwlwifi: move D3_CFG_COMPLETE handling into DVM
      iwlwifi: dvm: rename iwl_lib_ops to iwl_dvm_cfg
      iwlwifi: move some configuration parameters into DVM
      iwlwifi: dvm: constify configuration structs
      Merge remote-tracking branch 'iwlwifi-fixes/master' into HEAD

John W. Linville (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless i=
nto for-davem

Oren Givon (1):
      iwlwifi: add new 7260 and 3160 series device IDs

Stanislaw Gruszka (2):
      ath5k: do not reschedule tx_complete_work on stop
      iwl4965: workaround connection regression on passive channel

Sujith Manoharan (2):
      ath9k: Fix beacon reconfiguration
      ath9k: Update initvals for AR9565

Thommy Jakobsson (1):
      B43: Handle DMA RX descriptor underrun

 drivers/net/wireless/ath/ath5k/base.c              |   5 +
 .../net/wireless/ath/ath9k/ar9565_1p0_initvals.h   | 138 +++---
 drivers/net/wireless/ath/ath9k/main.c              |  10 +-
 drivers/net/wireless/b43/dma.c                     |  19 +
 drivers/net/wireless/b43/dma.h                     |   4 +-
 drivers/net/wireless/b43/main.c                    |  43 +-
 drivers/net/wireless/iwlegacy/4965-mac.c           |   3 +-
 drivers/net/wireless/iwlwifi/dvm/agn.h             |  21 +-
 drivers/net/wireless/iwlwifi/dvm/calib.c           |   8 +-
 drivers/net/wireless/iwlwifi/dvm/commands.h        |   4 -
 drivers/net/wireless/iwlwifi/dvm/dev.h             |  57 ++-
 drivers/net/wireless/iwlwifi/dvm/devices.c         | 107 ++++-
 drivers/net/wireless/iwlwifi/dvm/lib.c             |  20 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |  14 +-
 drivers/net/wireless/iwlwifi/dvm/main.c            |  45 +-
 drivers/net/wireless/iwlwifi/dvm/power.c           |   6 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c              |   8 +-
 drivers/net/wireless/iwlwifi/dvm/rx.c              |   2 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c            |  12 +-
 drivers/net/wireless/iwlwifi/dvm/sta.c             |   2 +-
 drivers/net/wireless/iwlwifi/dvm/tt.c              |   2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c              |  12 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c           |  10 +-
 drivers/net/wireless/iwlwifi/iwl-1000.c            |   3 -
 drivers/net/wireless/iwlwifi/iwl-2000.c            |  39 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c            |   4 -
 drivers/net/wireless/iwlwifi/iwl-6000.c            |  32 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c            |  53 ++-
 drivers/net/wireless/iwlwifi/iwl-config.h          |  49 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h             |  19 +
 drivers/net/wireless/iwlwifi/iwl-drv.c             |   3 +
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c    |  15 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.h    |   3 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h              |   7 +-
 drivers/net/wireless/iwlwifi/iwl-modparams.h       |   1 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c       |  20 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.h       |   2 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h            |  12 +
 drivers/net/wireless/iwlwifi/iwl-trans.h           |   7 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile          |   2 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c         |   6 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c              |  27 ++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c         | 427 ++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h       |   4 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h    |  93 +++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h       |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          | 260 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c              |  37 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c        |  42 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c        | 244 ++++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h             | 197 +++++++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c             | 212 ++++++++-
 drivers/net/wireless/iwlwifi/mvm/ops.c             |  31 +-
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c        |  75 +--
 drivers/net/wireless/iwlwifi/mvm/power.c           | 183 +++++++-
 drivers/net/wireless/iwlwifi/mvm/rs.c              |  26 ++
 drivers/net/wireless/iwlwifi/mvm/rs.h              |   5 +
 drivers/net/wireless/iwlwifi/mvm/rx.c              |  22 +
 drivers/net/wireless/iwlwifi/mvm/sta.c             |  26 +-
 drivers/net/wireless/iwlwifi/mvm/sta.h             |   8 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c              | 509 +++++++++++++++++=
++++
 drivers/net/wireless/iwlwifi/mvm/tx.c              |  48 +-
 drivers/net/wireless/iwlwifi/mvm/utils.c           |  31 ++
 drivers/net/wireless/iwlwifi/pcie/drv.c            |  50 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c          |  32 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c             |   8 +-
 drivers/net/wireless/mwifiex/cfg80211.c            |   3 -
 drivers/net/wireless/mwifiex/cmdevt.c              |   1 +
 drivers/net/wireless/mwifiex/main.c                |   1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c           |  21 +-
 70 files changed, 2907 insertions(+), 546 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tt.c


--=-BkktiuWAHcQFXRaPKUA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRpajTAAoJEDBSmw7B7bqruEUQAKiKBb4wX6NeF8sCFJqVo2N2
ZGDS+OsModxtDgNq8G6eAuWFlsgyCI1dZugX9VfrpsHBlYxA9VGgwEODkfLFod65
yJLLBxKLb42UL+0pKRJx4V0D0VyKqajnoLxCLCKQ9OQXV0Fmph55l6/RfsncKfXJ
1pvvFKH9bOIR6DJq+U7WNaq8LTwkDVyez1zOrOfU5SHfEhVugauOUoIBWTJfpJ89
wCKSCIxydCHyJ/c6Ax80x633PLb23I5TI38PyK+V9hJe5iseLKUFZOeC7ycViICp
iHmMMGSreCSX8pfjSdTkEp3fVUwkTStDB0cH6MvlTc9AOMXHqpySaTWFuUEGDtco
jg1y69AVyHGHHqP6L9aNSFdulNFyB6POEK8HTVtXsiMmgGvf/Hr0ggudOFl0G3pA
E+89isf2c3zEUxWbh4T+HnDjBpi/l+b4oYsTOau+EetXwElFgkGdn6BRg2JlThPk
87QfEEinYWCgZBxOMEUt2JjmwmbNzG6FFy0rsMLKcnXnJ6ngfxutksS9vAbkERFx
lwvMaUWFAymo/Aaug2XnTCoCn3+IV1psjlgvmxIZLCkf0xInFsIALb1gFgqLTN4g
pcMzveThKpVdQPP2l4tVzx5QFSyVS/Hiz9sBXCPI7Bh7mVc7KlsBnlGuXBP8EAg3
FtAAud3Zi57H+VH7znIn
=yF3M
-----END PGP SIGNATURE-----

--=-BkktiuWAHcQFXRaPKUA7--

