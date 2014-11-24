Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34901 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaKXOeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:34:04 -0500
Received: by mail-la0-f46.google.com with SMTP id gd6so7810181lab.33
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:34:02 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 24 Nov 2014 16:34:02 +0200
Message-ID: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com> (sfid-20141124_153409_485951_F5CD5D1B)
Subject: pull request: iwlwifi-next 2014-11-24
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

I have a big batch here. New features were unblocked by the merge a
few patches in mac80211-next.git and I was away for 2 weeks.
I plan to have another pull request for wireless-next before the merge
window opens.
Details below - please pull.

Thanks,

The following changes since commit 9e6f3f472c8f95021ad048acc7cd3e40a827f8ce:

  mwifiex: Add USB8766 support (2014-11-20 16:14:39 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
tags/iwlwifi-next-for-john-2014-11-24

for you to fetch changes up to dcad8e4299bf81f8795b44677036dfa490c9fb15:

  iwlwifi: update the secure mem space and for the CPUs (2014-11-24
08:30:44 +0200)

----------------------------------------------------------------
Major works are CSA and TDLS. On top of that I have a new
firmware API for scan and a few rate control improvements.
Johannes find a few tricks to improve our CPU utilization
and adds support for a new spin of 7265 called 7265D.
Along with this a few random things that don't stand out.

----------------------------------------------------------------
Andrei Otcheretianski (2):
      iwlwifi: mvm: Insert DS Parameter Set placeholder in probes
      iwlwifi: mvm: Handle failed beacon transmissions during CSA

Arik Nemtsov (10):
      iwlwifi: mvm: expose some static APIs for use by TDLS code
      iwlwifi: pcie: support loading FW with extended mem range
      iwlwifi: mvm: declare TDLS support
      iwlwifi: mvm: add TDLS channel switch FW APIs
      iwlwifi: mvm: configure TDLS peers to FW
      iwlwifi: mvm: allow private per-STA TFD queues
      iwlwifi: mvm: disconnect TDLS peers on reconfig
      iwlwifi: mvm: use private TFD queues for TDLS stations
      iwlwifi: mvm: implement mac80211 TDLS channel-switch APIs
      iwlwifi: mvm: disconnect TDLS peers before channel switch

Avri Altman (2):
      iwlwifi: mvm: New skip over dtim policy
      iwlwifi: mvm: Fix the keep_alive calculation

Chaya Rachel Ivgy (1):
      iwlwifi: mvm: add support to MFUART loading notification

David Spinadel (3):
      iwlwifi: mvm: implement UMAC scan API
      iwlwifi: mvm: go to umac scan even if lmac tlv bit is on
      iwlwifi: mvm: remove warning on unknown scan complete

Eliad Peller (7):
      iwlwifi: mvm/trans: abort d0i3_enter in case of held ref
      iwlwifi: mvm: wake up d0i3_exit_waitq when aborting d0i3
      iwlwifi: mvm: move deferred d0i3 exit to resume_complete op
      iwlwifi: mvm: disable beacon filtering escape timer
      iwlwifi: trans: add suspend/resume ops
      iwlwifi: mvm: call iwl_trans_suspend/resume
      iwlwifi: declare d0i3 support for IWL_DEVICE_8000

Emmanuel Grumbach (9):
      iwlwfifi: fix WANT_DEV_COREDUMP selection in Kconfig
      iwlwifi: mvm: rs - don't use the shared antenna when BT load is high
      iwlwifi: pcie: introduce delay when waking up the device
      iwlwifi: pcie: newer platform needs a OS alive indication
      Merge remote-tracking branch 'wireless-next/master' into iwlwifi-next
      iwlwifi: mvm: add support for WMM Access Control
      iwlwifi: mvm: BT Coex - add support for TTC / RRC
      iwlwifi: pcie: properly reset the device
      iwlwifi: update the secure mem space and for the CPUs

Eran Harary (1):
      iwlwifi: change max HT and VHT A-MPDU exponent

Eyal Shapira (5):
      iwlwifi: mvm: handle error from iwl_trans_update_sf
      iwlwifi: mvm: rs: fix a WARNING in case of STBC and VHT
      iwlwifi: mvm: rs: fix getting stuck in a test window
      iwlwifi: mvm: rs: consider a missing BA as a single tx failure
      iwlwifi: mvm: declare support for VHT BF info in radiotap

Johannes Berg (11):
      iwlwifi: mvm: use correct type for firmware status
      iwlwifi: mvm: rs: don't use shadowing variable
      iwlwifi: mvm: don't capture firmware coredump for D3->D0 reconfig
      iwlwifi: mvm: support random MAC address for scanning
      iwlwifi: pcie: support 7265-D devices
      iwlwifi: mvm: use unsigned for ssid_bitmap
      iwlwifi: mvm: refactor key add/remove functions
      iwlwifi: mvm: add WEP RX hardware offload support
      iwlwifi: build mac80211 rx_status in place
      iwlwifi: mvm: pull crypto header into skb->head
      iwlwifi: mvm: pull SNAP header into skb->head

Liad Kaufman (2):
      iwlwifi: mvm: fix init_dbg flow to work as expected
      iwlwifi: mvm: block TID when using TDLS

Luciano Coelho (21):
      iwlwifi: mvm: refactor temperature notification handling
      iwlwifi: mvm: handle unsolicited DTS_MEASUREMENT_NOTIFICATIONs
      iwlwifi: mvm: make nd_ies part of the mvm struct
      iwlwifi: mvm: use new pre_channel_switch op instead of
channel_switch_beacon
      iwlwifi: mvm: only save csa_vif in AP/GO mode
      iwlwifi: mvm: refactor iwl_mvm_switch_vif_chanctx to support other modes
      iwlwifi: mvm: add support for CHANCTX_SWMODE_REASSIGN_VIF
      iwlwifi: mvm: return the actual error code when switch_vif_chanctx fails
      iwlwifi: mvm: disable PS during channel switch
      iwlwifi: mvm: use switching_chanctx argument instead of csa_active
      iwlwifi: mvm: add CSA absent time event for clients
      iwlwifi: mvm: schedule CSA time event a bit before beacon 1
      iwlwifi: mvm: finalize on post_switch instead of unassign
      iwlwifi: mvm: add a channel_switch op to bypass mac80211 timer
      iwlwifi: mvm: disable beacon filtering during CSA
      iwlwifi: mvm: clear TE data if CSA time event fails to start
      iwlwifi: mvm: protect session during CSA
      iwlwifi: mvm: add support for net detect
      iwlwifi: mvm: refactor wowlan and netdetect configuration when suspending
      iwlwifi: mvm: refactor iwl_mvm_query_wakeup_reasons()
      iwlwifi: mvm: treat netdetect wake up separately

Matti Gottlieb (1):
      iwlwifi: mvm: add remove flow for AUX ROC time events

Oren Givon (1):
      iwlwifi: sdio: new SDIO card id for 4165 series

 drivers/net/wireless/iwlwifi/Kconfig            |   2 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c         |  38 +++++-
 drivers/net/wireless/iwlwifi/iwl-8000.c         |  23 ++++
 drivers/net/wireless/iwlwifi/iwl-config.h       |  10 ++
 drivers/net/wireless/iwlwifi/iwl-csr.h          |  39 +++---
 drivers/net/wireless/iwlwifi/iwl-debug.h        |   3 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |   2 +-
 drivers/net/wireless/iwlwifi/iwl-fw.h           |  10 +-
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c    |   5 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h      |   3 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h         |  12 +-
 drivers/net/wireless/iwlwifi/iwl-trans.h        |  14 ++
 drivers/net/wireless/iwlwifi/mvm/coex.c         |  16 +++
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c  |  19 ++-
 drivers/net/wireless/iwlwifi/mvm/constants.h    |   2 +
 drivers/net/wireless/iwlwifi/mvm/d3.c           | 190
++++++++++++++++++--------
 drivers/net/wireless/iwlwifi/mvm/debugfs.c      |  14 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-coex.h  |   9 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h  | 253
++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h       | 169 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw.c           |  28 ++++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c     |  86 +++++++++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 419
++++++++++++++++++++++++++++++++++++++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/mvm.h          | 130 +++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/ops.c          |  45 ++++--
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c     |   4 +-
 drivers/net/wireless/iwlwifi/mvm/power.c        |  40 ++++--
 drivers/net/wireless/iwlwifi/mvm/rs.c           |  45 ++++--
 drivers/net/wireless/iwlwifi/mvm/rx.c           | 150 ++++++++++----------
 drivers/net/wireless/iwlwifi/mvm/scan.c         | 753
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/mvm/sta.c          | 301
+++++++++++++++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/mvm/sta.h          |   5 +
 drivers/net/wireless/iwlwifi/mvm/tdls.c         | 569
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/time-event.c   | 146 ++++++++++++++++----
 drivers/net/wireless/iwlwifi/mvm/time-event.h   |   4 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c           |  71 ++++++++--
 drivers/net/wireless/iwlwifi/mvm/tx.c           |  39 ++++--
 drivers/net/wireless/iwlwifi/pcie/drv.c         |  20 +++
 drivers/net/wireless/iwlwifi/pcie/trans.c       |  37 ++++-
 drivers/net/wireless/iwlwifi/pcie/tx.c          |   3 +
 41 files changed, 3252 insertions(+), 478 deletions(-)
