Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:35189 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448AbcAGMq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:46:59 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-next 2016-01-07
Date: Thu, 7 Jan 2016 12:46:20 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com> (sfid-20160107_134702_633892_829E879C)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

Here is the last round of patches for 4.5. Most of them are small and / or fixes.
Let me know if you have issues.
FYI - I scripted a few checks so that I hope that the internal tags that leaked
in the previous pull request won't leak any more.

The following changes since commit e5d15cb530082cc13a6c9457eddd6f75b0f4de65:

  iwlwifi: bail out in case of bad trans state (2015-12-21 19:35:41 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2016-01-07

for you to fetch changes up to ccecff64ac4ee0d2f610e6606d2dfb17a38436f6:

  iwlwifi: pcie: properly configure the debug buffer size for 8000 (2016-01-07 14:39:58 +0200)

----------------------------------------------------------------
* bug fixes and improvements for firmware debug system (Golan and myself)
* fixes for D0i3 (Eliad)
* prevent muliple stations with the same MAC address
* advertise support for Rx A-MSDU in A-MPDU
* scan related fixes
* support -20.ucode
* fix WoWLAN for iwldvm
* preparations towards multiple Rx queues
* platform power improvements for GO mode when no clients are associated

----------------------------------------------------------------
Ayala Beker (1):
      iwlwifi: mvm: don't ask beacons when P2P GO vif and no assoc sta

David Spinadel (1):
      iwlwifi: mvm: fix extended dwell time

Eliad Peller (1):
      iwlwifi: mvm: initialize gtkdata->mvm correctly

Emmanuel Grumbach (10):
      iwlwifi: dvm: fix WoWLAN
      iwlwifi: mvm: let the firmware choose the antenna for beacons
      iwlwifi: mvm: reset mvm->scan_type when firmware is started
      iwlwifi: set max firmware version of 7265 to 17
      iwlwifi: mvm: bump max API to 20
      iwlwifi: mvm: dump the radio registers when the firmware crashes
      iwlwifi: mvm: remove useless WARN_ON and rely on cfg80211's combination
      iwlwifi: mvm: constify the parameters of a few functions in fw-dbg.c
      iwlwifi: mvm: fix memory leaks in error paths upon fw error dump
      iwlwifi: pcie: properly configure the debug buffer size for 8000

Golan Ben-Ami (1):
      iwlwifi: mvm: add a non-trigger window to fw dbg triggers

Johannes Berg (4):
      iwlwifi: mvm: support A-MSDU in A-MPDU
      iwlwifi: mvm: prevent multiple stations with the same address
      iwlwifi: mvm: check PN for CCMP/GCMP in the driver
      iwlwifi: mvm: check minimum temperature notification length

Matti Gottlieb (1):
      iwlwifi: mvm: change mcc update API

Oren Givon (2):
      iwlwifi: update and fix 7265 series PCI IDs
      iwlwifi: nvm: fix loading default NVM file

 drivers/net/wireless/intel/iwlwifi/dvm/lib.c           |   4 ++++
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c          |   4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h |   2 ++
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h       |  12 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h          |   6 ++++++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h         |   4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c            | 115 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h        |  60 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c        |  62 ++++++++++++++++++++++++++++++++++++++++++++++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h        |  30 +++++++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c            |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c      |  53 +++++++++++++++++++++++++----------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c      |  49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h           |   9 ++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c           |  55 +++++++++++++++++++++++++++++++++++++++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/power.c         |   2 --
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c          | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c          |  13 +++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h           |  12 ++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c            |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c          |   5 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c        |  17 +++++++++++++----
 24 files changed, 506 insertions(+), 121 deletions(-)

