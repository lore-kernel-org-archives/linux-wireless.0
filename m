Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38155 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181AbbLAJ4O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:56:14 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Kalle Valo <kvalo@adurom.com> Kalle Valo" <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi-next 2015-12-01
Date: Tue, 1 Dec 2015 09:56:05 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com> (sfid-20151201_105623_856278_4FA19F02)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is a pull request for -next.
It is based on your tree after the reorganisation. Details in the tag.
Let me know if you have issues.

Please pull. Thanks.


The following changes since commit 6d808eba602b00f77f26191f45328774ff057cc0:

  mac80211_hwsim: move Kconfig entry for sorting alphabetically (2015-11-18 15:23:36 +0200)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2015-12-01

for you to fetch changes up to 417a9667b4e396a1ed5510699c3b0701a1f0c645:

  iwlwifi: remove IWL_DL_LED (2015-11-26 17:00:16 +0200)

----------------------------------------------------------------
* BT coex improvements (Avri, Moshe)
* D3 operation bugfixes (Luca, Eliad)
* Rate control improvements (Eyal)
* Firmware debugging infra improvements (Golan)
* Ground work for multi Rx queue capable devices (Johannes)
* ROC improvements (Matti)

----------------------------------------------------------------
Avraham Stern (1):
      iwlwifi: mvm: Configure fragmented scan for scheduled scan

Avri Altman (3):
      iwlwifi: mvm: Avoid dereferencing sta if it was already flushed
      iwlwifi: mvm: Enable MPLUT only on supported hw
      iwlwifi: mvm: Align bt-coex priority with requirements

Dan Carpenter (1):
      iwlwifi: mvm: rs: fix a warning message

Derek Basehore (1):
      iwlwifi: mvm: report wakeup for wowlan

Dreyfuss, Haim (1):
      iwlwifi: Add new PCI IDs for 9260 and 5165 series

Eliad Peller (2):
      iwlwifi: mvm: refactor d3 key update functions
      iwlwifi: remove IWL_DL_LED

Emmanuel Grumbach (5):
      iwlwifi: bump firmware API to 19
      Merge remote-tracking branch 'iwlwifi-fixes/master' into next
      iwlwifi: add support for 12K Receive Buffers
      iwlwifi: mvm: change name of iwl_mvm_d3_update_gtk
      iwlwifi: change the Intel Wireless email address

Eyal Shapira (1):
      iwlwifi: mvm: drop low_latency_agg_frame_cnt_limit

Golan Ben Ami (1):
      iwlwifi: mvm: Support setting continuous recording debug mode

Golan Ben-Ami (4):
      iwlwifi: mvm: add trigger for firmware dump upon TDLS events
      iwlwifi: export the _no_grab version of PRPH IO functions
      iwlwifi: dump prph registers in a common place for all transports
      iwlwifi: mvm: move fw-dbg code to separate file

Johannes Berg (11):
      iwlwifi: nvm: fix up phy section when reading it
      iwlwifi: dvm: remove Kconfig default
      iwlwifi: trans: make various conversion macros inlines
      iwlwifi: dvm: remove stray debug code
      iwlwifi: pcie: remove ICT allocation message
      iwlwifi: mvm: use build-time assertion for fw trigger ID
      iwlwifi: clean up transport debugfs handling
      iwlwifi: pcie: remove pointer from debug message
      iwlwifi: mvm: use firmware station lookup, combine code
      iwlwifi: print index in api/capa flags parsing message
      iwlwifi: mvm: add 9000-series RX API

Luca Coelho (7):
      iwlwifi: mvm: don't overwrite the key indices in D3 entry
      iwlwifi: mvm: ignore LMAC scan notifications when running UMAC scans
      iwlwifi: generalize d0i3_entry_timeout module parameter
      iwlwifi: mvm: remove redundant d0i3 flag from the config struct
      iwlwifi: mvm: remove stray nd_config element
      iwlwifi: mvm: flush all used TX queues before suspending
      iwlwifi: mvm: remove unnecessary check in iwl_mvm_is_d0i3_supported()

Matti Gottlieb (2):
      iwlwifi: mvm: check FW's response for nvm access write cmd
      iwlwifi: mvm: ROC: Extend the ROC max delay duration & limit ROC duration

Moshe Harel (2):
      iwlwifi: mvm: add bt settings to debugfs
      iwlwifi: mvm: add bt rrc and ttc to debugfs

Nicholas Krause (1):
      iwlwifi: mvm: fix incorrect fallthrough in iwl_mvm_check_running_scans()

Oren Givon (3):
      iwlwifi: Add new PCI IDs for the 8260 series
      iwlwifi: Add PCI IDs for the new 3168 series
      iwlwifi: Add PCI IDs for the new series 8165

 drivers/net/wireless/intel/iwlwifi/Kconfig              |   2 +-
 drivers/net/wireless/intel/iwlwifi/Makefile             |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.h          |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/led.c            |   4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c            |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c           |  16 ++-
 drivers/net/wireless/intel/iwlwifi/dvm/power.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/power.h          |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-1000.c           |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-2000.c           |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-5000.c           |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-6000.c           |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c           |  15 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c           |  13 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c           | 163 ++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h         |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h         |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h          |   2 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h  |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-io.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-ucode.h |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c            |  19 +++-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c   |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.h    |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h             |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h  |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h        |  15 +++
 drivers/net/wireless/intel/iwlwifi/iwl-fw.h             |  16 +--
 drivers/net/wireless/intel/iwlwifi/iwl-io.c             |  25 +++--
 drivers/net/wireless/intel/iwlwifi/iwl-io.h             |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h      |  13 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-notif-wait.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c      |  30 +++---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h      |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h            |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h          |  29 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile         |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c           |  41 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c             | 228 ++++++++++++++++++++++-------------------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c        |  60 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-power.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rs.h      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h      | 116 ++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tof.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h      |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h         |  22 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c         | 780 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h         | 150 +++++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c             | 132 +-----------------------
 drivers/net/wireless/intel/iwlwifi/mvm/led.c            |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c       |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c       | 522 ++++++++++++++++------------------------------------------------------------------------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h            |  90 +++++------------
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c            |  53 +++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/offloading.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c            |  31 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c             |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c             |  44 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c           |  16 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c             |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c            |  88 ++++++++--------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h            |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/testmode.h       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c     |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c             |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c             |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c          |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c           |  40 +++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h      |  20 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c            |  25 +++--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c         | 188 +++-------------------------------
 88 files changed, 1989 insertions(+), 1162 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-9000.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.h

