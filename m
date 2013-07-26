Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab3GZI2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:28:53 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1V2dOM-000230-Tb
	for linux-wireless@vger.kernel.org; Fri, 26 Jul 2013 10:28:51 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: pull-request: iwlwifi-next 2013-07-26
Date: Fri, 26 Jul 2013 10:28:17 +0200
Message-Id: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net> (sfid-20130726_102907_482078_CA749114)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

John,

First -next pull request for iwlwifi. I'm trying something new, writing
the pull request directly into the cover letter of git send-email so I
can send the patches out at the same time as the pull request and don't
forget the patches - let me know if there's a problem with that.

There are a lot of various changes, I can't really list them all in a
meaningful way. One thing to note is maybe that we're removing the P2P
support from the older driver - it has never been really functional and
should be converted to P2P-Device, but we don't have time or testing
support to do that, and as it is it's not really functional.


johannes


The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john

for you to fetch changes up to 5e216eb4ed04b9b1725ce3e7779a4fb680e63446:

  iwlwifi: mvm: add high temperature SKU thermal throttling parameters (2013-07-26 10:21:14 +0200)

- ----------------------------------------------------------------
Alexander Bondar (3):
      iwlwifi: mvm: Upgrade to a new power management uAPSD API
      iwlwifi: mvm: Change AM->PSM timeout for EAPOL frames
      iwlwifi: mvm: Change beacon abort escape time value

Avri Altman (1):
      iwlwifi: rx_phy_info: new api to get signal strength

David Spinadel (1):
      iwlwifi: mvm: enable pre-scan passive to active

Emmanuel Grumbach (7):
      iwlwifi: pcie: don't disable L1 for newest NICs
      iwlwifi: mvm: better handle several several vifs in BT Coex
      iwlwifi: mvm: fix the ACK / CTS kill mask upon RSSI event
      iwlwifi: mvm: don't allocate BT_COEX cmd on stack
      iwlwifi: mvm: remove the default calibration values for 7000
      iwlwifi: mvm: register vif debugfs for AP mode too
      iwlwifi: mvm: remove obsolete flag in TX command API

Eran Harary (1):
      iwlwifi: mvm: fix debugfs restart if fw_restart is disabled

Eyal Shapira (1):
      iwlwifi: remove duplicate rate scale init code

Eytan Lifshitz (1):
      iwlwifi: mvm: add high temperature SKU thermal throttling parameters

Hila Gonen (1):
      iwlwifi: mvm: Change beacon filtering command

Ilan Peer (1):
      iwlwifi: mvm: Return on inconsistency in add interface

Inbal Hacohen (1):
      iwlwifi: move dump_fh into common code

Johannes Berg (10):
      iwlwifi: remove forward debugfs function declarations
      iwlwifi: mvm: remove unneeded argument from iwl_mvm_tx_protection()
      iwlwifi: pcie: make unused queue warning more readable
      iwlwifi: dvm: remove P2P support
      iwlwifi: mvm: reprobe device on firmware error during restart
      iwlwifi: mvm: support six IPv6 addresses in D3
      iwlwifi: mvm: assign quota per virtual interface
      iwlwifi: mvm: split constants into separate file
      iwlwifi: mvm: report per-chain signal to mac80211
      iwlwifi: list Emmanuel in maintainers file

Matti Gottlieb (2):
      iwlwifi: mvm: sram hex dump on NIC error
      iwlwifi: mvm: Enable user set TX power

 MAINTAINERS                                     |   2 +-
 drivers/net/wireless/iwlwifi/Kconfig            |  17 --
 drivers/net/wireless/iwlwifi/dvm/agn.h          |   6 -
 drivers/net/wireless/iwlwifi/dvm/debugfs.c      |  15 --
 drivers/net/wireless/iwlwifi/dvm/dev.h          |   7 -
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     | 172 +------------
 drivers/net/wireless/iwlwifi/dvm/main.c         |  62 -----
 drivers/net/wireless/iwlwifi/dvm/rs.c           |   3 -
 drivers/net/wireless/iwlwifi/dvm/rxon.c         |   6 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c         | 105 +-------
 drivers/net/wireless/iwlwifi/dvm/tx.c           |  19 --
 drivers/net/wireless/iwlwifi/iwl-7000.c         |  11 +
 drivers/net/wireless/iwlwifi/iwl-config.h       |   4 +
 drivers/net/wireless/iwlwifi/iwl-fw.h           |  19 +-
 drivers/net/wireless/iwlwifi/iwl-io.c           |  67 +++++
 drivers/net/wireless/iwlwifi/iwl-io.h           |   3 +
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |   8 +-
 drivers/net/wireless/iwlwifi/mvm/Makefile       |   2 +-
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c      | 162 +++++++-----
 drivers/net/wireless/iwlwifi/mvm/constants.h    |  71 ++++++
 drivers/net/wireless/iwlwifi/mvm/d3.c           |  66 +++--
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      | 116 ++++-----
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h    |  52 +++-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 143 +++++++++--
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h  |   5 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h    |   2 -
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  27 +-
 drivers/net/wireless/iwlwifi/mvm/fw.c           |  55 ----
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |   3 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     |  37 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  83 ++++--
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  54 +++-
 drivers/net/wireless/iwlwifi/mvm/power.c        | 198 ++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/power_legacy.c | 319 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/quota.c        |  16 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c           |  10 +-
 drivers/net/wireless/iwlwifi/mvm/rs.h           |   4 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c           |  78 +++---
 drivers/net/wireless/iwlwifi/mvm/scan.c         |   2 +
 drivers/net/wireless/iwlwifi/mvm/sta.c          |   3 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c           |  32 ++-
 drivers/net/wireless/iwlwifi/mvm/tx.c           |   2 +
 drivers/net/wireless/iwlwifi/mvm/utils.c        |  23 ++
 drivers/net/wireless/iwlwifi/pcie/drv.c         |   6 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h    |   1 -
 drivers/net/wireless/iwlwifi/pcie/rx.c          |   2 +-
 drivers/net/wireless/iwlwifi/pcie/trans.c       |  95 +------
 drivers/net/wireless/iwlwifi/pcie/tx.c          |   5 +-
 48 files changed, 1307 insertions(+), 893 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/constants.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/power_legacy.c
-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJR8jM1AAoJEDBSmw7B7bqrS1sQAM5vMF4xcvAQu9WygGLXQUGR
bW7Hl9jMVZolNXP1RUGCsdf4pifw3ov/U45JbgyGvVoKGKQkfPdLF3k18dTSZ88f
MrVpkMjppuMeuOnRV9p8H+HHb41B0nJLIt/V9/d/l6n3Sl2TqzVPGLcNYA3zl/Iz
oGyYxii4Vvtb+RR+/JFJ/cPTogaTTpUp+bjxkSPz+np7412hl+XS/4p8MtmlAgPb
ZKKU9B8ZviKWYeBeGjNzaWx++jM3aQZIzCebqs8F1R4mh431xdt7Je658vxmEK2K
7N8rmlIyd8U9EtFkHJS3OUX3dKsUuZttf46g4WspP2Yanc+aA+FAFRcthFjaoijm
GOkrr/AzI7wsniIV1adpW76xKeXhb/k+DCQcrZPAL8Mv0boDVvlOnNPd60G/MGnJ
qmlbbUTAEFDtn7kOV/lv/imvJBQ6bf5gGN5dgYc2d1OVLvypixrbRp4wyWg6WgG5
cQSg4ZSMxyx20V2gL2SMubHvsDCisWoMIMOlNOzFURHzwzk12FkeYw4DGdfB+ZH2
4z1Teaxq4gOMJ8R3h+UDKeSMwPxoCaN8mznu/5r6skV9af4GcyHtcBK/ie33qbN5
bDYwTQXqlhefrXlqsvutzMgv0w5JGeqzSIeGdNHFbS6snRugEdIenZxqo6igZvPz
B5WJyaiqu0iX86YvpOX9
=GP7+
-----END PGP SIGNATURE-----

