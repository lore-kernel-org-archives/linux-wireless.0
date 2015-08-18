Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:54627 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbbHRHzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:55:32 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-next 2015-08-18
Date: Tue, 18 Aug 2015 07:55:24 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com> (sfid-20150818_095540_509171_60B227DB)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is another pull request for 4.3. As usual, details in the tag. As
announced, this needs patches
from mac80211-next, so I merged Johanne's tag and you did so as well
upon my request (thank
you for that).

Please pull and let me know if you have issues.

The following changes since commit 8f9c98df949333f08b74e5df1caacf7e2c5e8552:

  mac80211: fix BIT position for TDLS WIDE extended cap (2015-08-14
17:49:53 +0200)

are available in the git repository at:

 
https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
tags/iwlwifi-next-for-kalle-2015-08-18

for you to fetch changes up to ecc7c518b3017821a6b26fb5fdaa548afa8ee236:

  iwlwifi: mvm: fix a race in D0i3 vs. Tx path (2015-08-18 10:25:26 +0300)

----------------------------------------------------------------
* polish the Miracast operation
* fix a few power consumption issues
* scan cleanup
* fixes for D0i3 system state
* add paging for devices that support it
* add again the new RBD allocation model
* add more options to the firmware debug system
* add support for frag SKBs in Tx

----------------------------------------------------------------
Adrien Schildknecht (1):
      iwlwifi: out-of-bounds access in iwl_init_sband_channels

Alexander Bondar (2):
      iwlwifi: Add max TX aggregation size for 8260 SDIO devices series
      iwlwifi: rs: disable MIMO only if allowed in configuration

Andy Shevchenko (1):
      iwlwifi: convert hex_dump_to_buffer() to %*ph

Arik Nemtsov (1):
      iwlwifi: mvm: support TDLS wider-bandwidth

Assaf Krauss (1):
      iwlwifi: mvm: ToF - Set correct range request cmd id

Avraham Stern (2):
      iwlwifi: mvm: Fix regular scan priority
      iwlwifi: add new TLV capability flag for gscan support

Avri Altman (3):
      iwlwifi: mvm: revert to our old skip over dtim policy
      iwlwifi: mvm: set different pm_timeout for action frames
      iwlwifi: mvm: Enable power management on low-latency bss

Ayala Beker (1):
      iwlwifi: mvm: add debug info to schedule scan complete message.

Dan Carpenter (1):
      iwlwifi: mvm: fix a range check in debugfs code

David Spinadel (3):
      iwlwifi: mvm: simplify calculating scan dwells and other timing values
      iwlwifi: mvm: remove partial and full scan lists from lmac sched scan
      iwlwifi: mvm: don't disconnect on beacon loss in D0I3

Dor Shaish (1):
      iwlwifi: mvm: print secboot status registers on alive timeout

Eliad Peller (1):
      iwlwifi: make sure d3_suspend/resume ops exist

Emmanuel Grumbach (7):
      iwlwifi: pcie: fix prepare card flow
      iwlwifi: pcie: fix stuck queue detection for sleeping clients
      iwlwifi: pcie: dump RBs when FW error occurs
      Merge remote-tracking branch 'iwlwifi-fixes/master' into next
      Merge tag 'mac80211-next-for-davem-2015-08-14' into next
      iwlwifi: bump mvm firmware API to 16
      iwlwifi: mvm: fix a race in D0i3 vs. Tx path

Johannes Berg (2):
      iwlwifi: pcie: support frag SKBs
      iwlwifi: pass NAPI struct from transport layer

Matti Gottlieb (2):
      iwlwifi: mvm: Add FW paging mechanism for the UMAC on PCI
      iwlwifi: mvm: Add FW paging mechanism for the UMAC on SDIO

Oren Givon (1):
      iwlwifi: mvm: add the ability to trigger only monitor dumps

Sara Sharon (1):
      iwlwifi: pcie: New RBD allocation model

 drivers/net/wireless/iwlwifi/dvm/agn.h              |  19 ++--
 drivers/net/wireless/iwlwifi/dvm/debugfs.c          |   8 +-
 drivers/net/wireless/iwlwifi/dvm/dev.h              |   5 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c              |   8 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c         |  14 ++-
 drivers/net/wireless/iwlwifi/dvm/main.c             |  13 ---
 drivers/net/wireless/iwlwifi/dvm/rs.c               |  51 +++++-----
 drivers/net/wireless/iwlwifi/dvm/rx.c               | 105
++++++++-------------
 drivers/net/wireless/iwlwifi/dvm/rxon.c             |   3 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c             |  25 ++---
 drivers/net/wireless/iwlwifi/dvm/sta.c              | 111
++++++++--------------
 drivers/net/wireless/iwlwifi/dvm/tx.c               |  18 ++--
 drivers/net/wireless/iwlwifi/dvm/ucode.c            |   5 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c             |   4 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c             |  12 ++-
 drivers/net/wireless/iwlwifi/iwl-config.h           |   2 +
 drivers/net/wireless/iwlwifi/iwl-csr.h              |   3 +
 drivers/net/wireless/iwlwifi/iwl-devtrace-data.h    |   7 +-
 drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h |  14 ++-
 drivers/net/wireless/iwlwifi/iwl-drv.c              |  72 +++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c     |   4 +-
 drivers/net/wireless/iwlwifi/iwl-fw-error-dump.h    |  17 ++++
 drivers/net/wireless/iwlwifi/iwl-fw-file.h          |  50 +++++++++-
 drivers/net/wireless/iwlwifi/iwl-fw.h               |  68 ++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c       |   8 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h       |   5 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c        |  12 +--
 drivers/net/wireless/iwlwifi/iwl-op-mode.h          |  32 ++-----
 drivers/net/wireless/iwlwifi/iwl-prph.h             |  12 +++
 drivers/net/wireless/iwlwifi/iwl-trans.h            | 125
++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/Makefile           |   1 +
 drivers/net/wireless/iwlwifi/mvm/coex.c             |  44 ++++-----
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c      |  31 +++---
 drivers/net/wireless/iwlwifi/mvm/constants.h        |   1 +
 drivers/net/wireless/iwlwifi/mvm/d3.c               |  74 +++++++++++----
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c      | 751
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/debugfs.c          |   9 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h     |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h      | 150
+----------------------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h       | 386
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h        |  12 +++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h           |  86 ++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw.c               | 389
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c         |  13 +--
 drivers/net/wireless/iwlwifi/mvm/mac80211.c         |  63 ++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h              | 155
+++++++++++++++---------------
 drivers/net/wireless/iwlwifi/mvm/nvm.c              |  23 +----
 drivers/net/wireless/iwlwifi/mvm/ops.c              | 113
++++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/power.c            |  46 ++-------
 drivers/net/wireless/iwlwifi/mvm/rs.c               | 160
+++++++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/rs.h               |  10 ++
 drivers/net/wireless/iwlwifi/mvm/rx.c               |  43 +++++----
 drivers/net/wireless/iwlwifi/mvm/scan.c             | 330
+++++++++++++++++++++++++++-------------------------------------
 drivers/net/wireless/iwlwifi/mvm/sta.c              |  44 ++++++---
 drivers/net/wireless/iwlwifi/mvm/sta.h              |   5 +-
 drivers/net/wireless/iwlwifi/mvm/tdls.c             |  33 +++----
 drivers/net/wireless/iwlwifi/mvm/time-event.c       |  16 ++--
 drivers/net/wireless/iwlwifi/mvm/time-event.h       |   5 +-
 drivers/net/wireless/iwlwifi/mvm/tof.c              | 304
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/tof.h              |  94
+++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/tt.c               |  13 +--
 drivers/net/wireless/iwlwifi/mvm/tx.c               |  96
+++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/utils.c            |  13 +--
 drivers/net/wireless/iwlwifi/pcie/drv.c             |  22 ++---
 drivers/net/wireless/iwlwifi/pcie/internal.h        |  13 ++-
 drivers/net/wireless/iwlwifi/pcie/rx.c              | 158
+++++++++++++++++++++----------
 drivers/net/wireless/iwlwifi/pcie/trans.c           | 488
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------
 drivers/net/wireless/iwlwifi/pcie/tx.c              | 150
++++++++++++++++++++++-------
 68 files changed, 3849 insertions(+), 1329 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tof.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tof.h

