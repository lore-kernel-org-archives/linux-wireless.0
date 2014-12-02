Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48090 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754045AbaLBSGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:06:18 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-next 2014-12-02
Date: Tue, 2 Dec 2014 18:05:39 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com> (sfid-20141202_190622_061616_2F6D76C0)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

This is a last pull request with content for 3.19. As usual, the details are below.

Thanks!

The following changes since commit dcad8e4299bf81f8795b44677036dfa490c9fb15:

  iwlwifi: update the secure mem space and for the CPUs (2014-11-24 08:30:44 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-john-2014-12-02

for you to fetch changes up to 61df750cb00b69882ba3acbb82e9368d01119c93:

  iwlwifi: mvm: Ability to work with packed usniffer image (2014-12-02 16:51:56 +0200)

----------------------------------------------------------------
I deprecate here -8.ucode since -9 has been published long ago.
Along with that I have a new activity, we have now better
a infrastructure for firmware debugging. This will allow to
have configurable probes insides the firmware.
Luca continues his work on NetDetect, this feature is now
complete. All the rest is minor fixes here and there.

----------------------------------------------------------------
David Spinadel (1):
      iwlwifi: mvm: remove a dangling line of documentation

Eliad Peller (2):
      iwlwifi: mvm: add missing mvm ref debug print
      iwlwifi: pcie: refactor cmd_in_flight set/clear code

Emmanuel Grumbach (10):
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
      iwlwifi: deprecate -8.ucode for 3160 / 7260 / 7265
      iwlwifi: mvm: remove IWL_UCODE_TLV_CAPA_EXTENDED_BEACON
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_CSA_FLOW
      iwlwifi: mvm: BT Coex - change the MPLUT registers' value
      iwlwifi: don't load on 7265D with old NVM
      iwlwifi: pcie: claim ownership on the device after stop_device()
      iwlwifi: dvm: fix flush support for old firmware
      iwlwifi: mvm: update values for Smart Fifo

Eran Harary (2):
      iwlwifi: mvm: support ucode load for family_8000 B0 only
      iwlwifi: mvm: Ability to work with packed usniffer image

Idan Kahlon (1):
      iwlwifi: mvm: support NVM file with header

Johannes Berg (1):
      iwlwifi: move firmware file format definitions to correct header

Liad Kaufman (6):
      iwlwifi: pcie: add fh registers to dump data
      iwlwifi: use correct fw file in 8000 b-step
      iwlwifi: define the .ucode file format for debug
      iwlwifi: mvm: send dbg config hcmds to fw if set in tlv
      iwlwifi: pcie: config regs according to fw tlv
      iwlwifi: pcie: support more monitor types dumping

Luciano Coelho (4):
      iwlwifi: mvm: check TLV flag before trying to use hotspot firmware commands
      iwlwifi: mvm: check and report if wake up was due to net detect
      iwlwifi: mvm: add SSID match information for net-detect
      iwlwifi: mvm: add channel information to the netdetect notifications

Oren Givon (1):
      iwlwifi: fix 4165 series name

 drivers/net/wireless/iwlwifi/dvm/commands.h      |  31 ++++++++------
 drivers/net/wireless/iwlwifi/dvm/lib.c           |  47 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-7000.c          |  16 ++++---
 drivers/net/wireless/iwlwifi/iwl-8000.c          |   8 ++--
 drivers/net/wireless/iwlwifi/iwl-config.h        |   1 +
 drivers/net/wireless/iwlwifi/iwl-drv.c           | 195 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h |   3 ++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h       | 308 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-fw.h            | 247 ++++++++++++++++++++++++++++++---------------------------------------------------------------------------
 drivers/net/wireless/iwlwifi/iwl-prph.h          |   8 ++--
 drivers/net/wireless/iwlwifi/iwl-trans.h         |   7 +++
 drivers/net/wireless/iwlwifi/mvm/constants.h     |   4 +-
 drivers/net/wireless/iwlwifi/mvm/d3.c            | 208 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c       |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h     |   6 +--
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h   |  44 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h        |  10 ++---
 drivers/net/wireless/iwlwifi/mvm/fw.c            |  46 +++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c      |  19 +++------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c      |  16 ++++---
 drivers/net/wireless/iwlwifi/mvm/mvm.h           |   8 +++-
 drivers/net/wireless/iwlwifi/mvm/nvm.c           |  31 ++++++++++----
 drivers/net/wireless/iwlwifi/mvm/offloading.c    |   2 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c           |  31 +++++++-------
 drivers/net/wireless/iwlwifi/pcie/trans.c        | 330 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------------
 drivers/net/wireless/iwlwifi/pcie/tx.c           | 102 +++++++++++++++++++++++++++----------------
 26 files changed, 1258 insertions(+), 471 deletions(-)

