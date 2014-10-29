Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36884 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaJ2Lsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 07:48:51 -0400
Received: by mail-ob0-f182.google.com with SMTP id nt9so2421903obb.41
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 04:48:50 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Oct 2014 13:48:50 +0200
Message-ID: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com> (sfid-20141029_124855_673787_5D63E1D0)
Subject: pull request: iwlwifi-next 2014-10-29
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Here is a pull request for 3.19. More details below.

Thanks!

The following changes since commit 35a9ad8af0bb0fa3525e6d0d20e32551d226f38e:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
(2014-10-08 21:40:54 -0400)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
tags/iwlwifi-next-for-john-2014-10-29

for you to fetch changes up to d9e4d61c5b900f6938b4aa49f25a0db37aeb23b6:

  iwlwifi: mvm: unref SCAN ref on scan completion (2014-10-29 13:14:41 +0200)

----------------------------------------------------------------
The big new thing here is netdetect which allows the
firmware to wake up the platform when a specific network
is detected. Along with that I have fixes for d3 operation.
The usual amount of rate scaling stuff - we now support STBC.
The other commit that stands out is Johannes's work on
devcoredump. He basically starts to use the standard
infrastructure he built.

----------------------------------------------------------------
Arik Nemtsov (1):
      iwlwifi: mvm: remove mvm argument from get_queues_mask

David Spinadel (1):
      iwlwifi: mvm: fix scan condition iterator

Eliad Peller (1):
      iwlwifi: mvm: unref SCAN ref on scan completion

Emmanuel Grumbach (12):
      iwlwifi: configure the LTR
      iwlwifi: mvm: BT Coex - update the MPLUT Boost register value
      iwlwifi: mvm: BT coex - fix BT prio for probe requests
      iwlwifi: dvm: drop non VO frames when flushing
      Revert "iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate"
      iwlwifi: pcie: fix polling in various places
      Merge remote-tracking branch 'iwlwifi-fixes/master' into iwlwifi-next
      iwlwifi: mvm: remove unneeded NULL pointer check
      iwlwifi: pcie: warn if extern fw_debug buffer failed
      iwlwifi: pcie: fix recovery from ARC reset in WoWLAN
      iwlwifi: mvm: BT Coex - move BT_ANTENNA_COUPLING_THRESHOLD to constants
      iwlwifi: mvm: BT Coex - make the multiprio lut a constant

Eran Harary (1):
      iwlwifi: always run the secured flow for family 8000

Eyal Shapira (3):
      iwlwifi: rs: option to easily disable Tx MIMO
      iwlwifi: enable STBC support for 8000 chips
      iwlwifi: mvm: rs: add Tx STBC support

Gregory Greenman (1):
      iwlwifi: allow to restrict Tx aggregation size per-device

Haim Dreyfuss (1):
      iwlwifi: mvm: Add tx power condition to bss_info_changed_ap_ibss

Joe Perches (1):
      iwlwifi: dvm: Fix probable mask then right shift defect

Johannes Berg (3):
      iwlwifi: mvm: improve MCS rate warning
      iwlwifi: mvm: flush queues without mutex held
      iwlwifi: mvm: port to devcoredump framework

Liad Kaufman (1):
      iwlwifi: 8000: fix string given to MODULE_FIRMWARE

Luciano Coelho (7):
      iwlwifi: mvm: hold the rtnl when resuming from a d3 test
      iwlwifi: mvm: split wowlan handling out of the main suspend function
      iwlwifi: mvm: move the check if associated outside of the
iterator for wowlan
      iwlwifi: mvm: spin off a function to start scan offload
      iwlwifi: mvm: add debugfs entry to configure netdetect SSIDs
      iwlwifi: mvm: change the iwl_mvm_d3_iface_iterator into a generic function
      iwlwifi: mvm: remove unnecessary includes in tt.c

Matti Gottlieb (1):
      iwlwifi: mvm: ROC - bug fixes around time events and locking

Max Stepanov (1):
      iwlwifi: mvm: add MVM_FW_BCAST_FILTER_PASS_ALL option

 drivers/net/wireless/iwlwifi/Kconfig            |   1 +
 drivers/net/wireless/iwlwifi/dvm/lib.c          |   4 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |  24 ++++----
 drivers/net/wireless/iwlwifi/iwl-8000.c         |   4 +-
 drivers/net/wireless/iwlwifi/iwl-config.h       |  12 ++++
 drivers/net/wireless/iwlwifi/iwl-drv.c          |   3 -
 drivers/net/wireless/iwlwifi/iwl-fw.h           |   1 -
 drivers/net/wireless/iwlwifi/iwl-trans.h        |   6 +-
 drivers/net/wireless/iwlwifi/mvm/coex.c         |  13 +----
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c  |  14 ++---
 drivers/net/wireless/iwlwifi/mvm/constants.h    |   5 ++
 drivers/net/wireless/iwlwifi/mvm/d3.c           | 318
++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      | 201
+++++++++++++++++++++++++++++++++++++++-------------------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |  35 +++++++++++-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       |   1 +
 drivers/net/wireless/iwlwifi/mvm/fw.c           |   9 +++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |   5 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 132
++++++++++++++++++++++++++++--------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h          |  14 ++++-
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  16 ++++--
 drivers/net/wireless/iwlwifi/mvm/rs.c           |  80
++++++++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/rs.h           |   2 +
 drivers/net/wireless/iwlwifi/mvm/scan.c         |  38 +++++++++++-
 drivers/net/wireless/iwlwifi/mvm/sta.c          |   2 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c   |   2 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c           |   4 --
 drivers/net/wireless/iwlwifi/mvm/tx.c           |  14 ++---
 drivers/net/wireless/iwlwifi/mvm/utils.c        |  37 ++++++++++++
 drivers/net/wireless/iwlwifi/pcie/trans.c       |  53 ++++++++---------
 29 files changed, 664 insertions(+), 386 deletions(-)
