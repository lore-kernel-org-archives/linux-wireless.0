Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:50716 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858AbcAaLFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:05:51 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-next 2016-01-31
Date: Sun, 31 Jan 2016 11:05:38 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com> (sfid-20160131_120556_248903_636E2B5B)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is a pull request for 4.6. Please pull. Thanks!

The following changes since commit aee3bfa3307cd0da2126bdc0ea359dabea5ee8f7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2016-01-12 18:57:02 -0800)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2016-01-31

for you to fetch changes up to 01789793426771a0198af6a66f48fbc2474f07ab:

  iwlwifi: mvm: allow to disable beacon filtering for AP/GO interface (2016-01-31 12:53:56 +0200)

----------------------------------------------------------------
Here's a first batch of patches for 4.6:
* continue the work on multiple Rx queues (Sara)
* add support for beacon storing
  used in low power states (Sara)
* cleanups (Rodrigo, Johannes)
* fix the LED behavior for iwldvm (Hubert)
* Use the regular firmware image of WoWLAN (Matti)
* fix 8000 devices for Big Endian machines (Johannes)
* more firmware debug hooks (Golan)
* add support for P2P Client snoozing (Avri)
* make the beacon filtering for AP mode configurable (Andrei)
* fix transmit queues overflow with LSO

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: allow to disable beacon filtering for AP/GO interface

Avri Altman (3):
      iwlwifi: mvm: Add P2P client snoozing
      iwlwifi: mvm: Remove bf_vif from iwl_power_vifs
      iwlwifi: mvm: Remove iwl_mvm_update_beacon_abort

Chaya Rachel Ivgi (1):
      iwlwifi: mvm: add support for negative temperatures

Emmanuel Grumbach (2):
      iwlwifi: pcie: buffer packets to avoid overflowing Tx queues
      iwlwifi: various comments and code cleanups

Golan Ben-Ami (2):
      iwlwifi: mvm: add trigger for firmware dump upon TX response status
      iwlwifi: mvm: make collecting fw debug data optional

Gregory Greenman (1):
      iwlwifi: mvm: rs: fix TPC action decision algorithm

Hubert Tarasiuk (1):
      iwlwifi: dvm: handle zero brightness for wifi LED

Johannes Berg (5):
      iwlwifi: mvm: remove shadowing variable
      iwlwifi: mvm: fix debugfs signedness warning
      iwlwifi: mvm: track low-latency sources separately
      iwlwifi: mvm: support setting minimum quota from debugfs
      iwlwifi: treat iwl_parse_nvm_data() MAC addr as little endian

Luca Coelho (1):
      iwlwifi: pcie: add initial RTPM support for PCI

Luciano Coelho (1):
      iwlwifi: pcie: add RTPM support when wifi is enabled

Matti Gottlieb (1):
      iwlwifi: mvm: Do not switch to D3 image on suspend

Max Stepanov (1):
      iwlwifi: mvm: add debug print if scan config is ignored

Rodrigo Freire (1):
      iwlwifi: Document missing module options

Sara Sharon (10):
      iwlwifi: pcie: add infrastructure for multi-queue rx
      iwlwifi: pcie: add 9000 series multi queue rx DMA support
      iwlwifi: mvm: support beacon storing
      iwlwifi: mvm: change access to ieee80211_hdr
      iwlwifi: mvm: change the check for ADD_STA status
      iwlwifi: mvm: add tlv for multi queue rx support
      iwlwifi: mvm: add new ADD_STA command version
      iwlwifi: mvm: support rss queues configuration command
      iwlwifi: pcie: enable multi-queue rx path
      iwlwifi: pcie: update iwl_mpdu_desc fields

 drivers/net/wireless/intel/iwlwifi/Kconfig             |  12 ++++
 drivers/net/wireless/intel/iwlwifi/dvm/led.c           |   5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c          |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h        |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h            |  77 +++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h       |  21 ++++++
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h     |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c     |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h         |  20 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h     |   8 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c            |  73 ++++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  75 ++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c       |  58 ++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h     |  42 ++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  69 ++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h        |  31 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c            |  29 ++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c      |  43 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h           |  36 +++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c           |   8 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c           |  28 ++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/power.c         | 131 ++++++++++++++++++++++-------------
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c         |  16 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c            |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c          |  13 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c          |   9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c           |  50 ++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h           |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c            |  17 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c            |  33 +++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c         |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c          | 134 +++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h     |  42 ++++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c           | 536 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c        | 155 ++++++++++++++++++++++++++++-------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c           |  87 ++++++++++++++++++++---
 42 files changed, 1483 insertions(+), 420 deletions(-)

