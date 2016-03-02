Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29386 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbcCBHvW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2016 02:51:22 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@adurom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi-next 2016-03-02
Date: Wed, 2 Mar 2016 07:51:12 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA50146@hasmsx107.ger.corp.intel.com> (sfid-20160302_085125_986226_44337B15)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is a pull request for 4.6. It is big because a lot of patches were
waiting for code in mac80211-next which is now in net-next.
As you figured, I need you to pull Johannes's 
mac80211-next-for-davem-2016-02-26 before you pull this from me.
Of course, you can just merge net-next. This is really up to you :)
I also merged iwlwifi-fixes.git (twice even) to prevent conflicts upstream.
In the tag, I mentioned which patches need mac80211-next since you asked for it
last time.

My prevent_stupid_mistakes.sh script seems to be working fairly well now,
in case you see an issue, let me know.

Thanks!


The following changes since commit 50ee738d7271fe825e4024cdfa5c5301a871e2c2:

  rfkill: Add documentation about LED triggers (2016-02-24 09:13:12 +0100)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2016-03-02

for you to fetch changes up to 53f09e742b0fdf14a2a2bfd2062ee96c9b3eedf0:

  Merge branch 'fixes' into next (2016-03-02 09:35:38 +0200)

----------------------------------------------------------------
* add support for thermal device / cooling device (Chaya Rachel)
* fixes for 9000 devices data path (Sara Sharon)
* improvements in scheduled scan w/o profiles (Luca)
* new firmware support (-21.ucode)
* add MSIX support for 9000 devices (Haim Dreyfuss)
* cleanup in PCIe initialization
* enable MU-MIMO and take care of firmware restart(Sara Sharon)
        ===> This needs mac80211-next
* add support for large SKBs in mvm to reach A-MSDU
        ===> This needs mac80211-next
* add support for filtering frames from a BA session (Sara Sharon)
        ===> This needs mac80211-next
* start implementing the new Rx path for 9000 devices (Sara Sharon)
* enable the new RRM feature flag (Beni Lev)
* fix U-APSD enablement on P2P Client (Avri Altman)
* fix beacon abort enablement (Avri Altman)
* forbid beacon storing with WoWLAN (Matti Gottlieb)
* support unified uSniffer / regular firmware image (Golan Ben-Ami)
* fix a race between debugfs hooks and iface up (Chaya Rachel Ivgi)
* fixes for runtime PM (Luca)
* add a new module paramater to disable VHT (Andrei Otcheretianski)
* build infrastructure for Dynamic Queue Allocation (Liad Kaufman)

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: add disable_11ac module param

Avri Altman (2):
      iwlwifi: mvm: forbid U-APSD for P2P Client if the firmware doesn't support it
      iwlwifi: mvm: Send power command on BSS_CHANGED_BEACON_INFO if needed

Beni Lev (1):
      iwlwifi: mvm: Set global RRM capability

Chaya Rachel Ivgi (4):
      iwlwifi: mvm: add CT-KILL notification
      iwlwifi: mvm: add registration to thermal zone
      iwlwifi: mvm: add registration to cooling device
      iwlwifi: mvm: update ucode status before stopping device

Emmanuel Grumbach (15):
      Merge tag 'mac80211-next-for-davem-2016-02-26' into next2
      Merge tag 'iwlwifi-for-kalle-2016-02-15' into HEAD
      iwlwifi: mvm: bump firmware API to 21
      iwlwifi: pcie: aggregate Flow Handler configuration writes
      iwlwifi: pcie: fix identation in trans.c
      iwlwifi: mvm: send large SKBs to the transport
      iwlwifi: mvm: add Tx A-MSDU inside A-MPDU
      iwlwifi: mvm: allow to limit the A-MSDU from debugfs
      iwlwifi: mvm: don't enable A-MSDU when the rates are too low
      iwlwifi: mvm: don't send an A-MSDU that is larger than the TXF
      iwlwifi: pcie: prevent skbs shadowing in iwl_trans_pcie_reclaim
      iwlwifi: mvm: remove unused field in iwl_mvm_tid_data
      iwlwifi: mvm: various trivial cleanups
      iwlwifi: mvm: kill iwl_mvm_enable_agg_txq
      Merge branch 'fixes' into next

Eyal Shapira (1):
      iwlwifi: mvm: rs: fix a theoretical access to uninitialized array elements

Golan Ben-Ami (1):
      iwlwifi: support ucode with d0 unified image - regular and usniffer

Haim Dreyfuss (1):
      iwlwifi: pcie: Add new configuration to enable MSIX

Liad Kaufman (3):
      iwlwifi: mvm: inc pending frames counter also when txing non-sta
      iwlwifi: mvm: disable DQA support
      iwlwifi: mvm: support sw queue start/stop from mvm

Luca Coelho (4):
      iwlwifi: mvm: handle pass all scan reporting
      iwlwifi: pcie: add pm_prepare and pm_complete ops
      iwlwifi: mvm: only release the trans ref if d0i3 is supported in fw
      iwlwifi: mvm: take the transport ref back when leaving

Matti Gottlieb (2):
      iwlwifi: mvm: Fix paging memory leak
      iwlwifi: mvm: Disable beacon storing in  D3 when WOWLAN configured

Sara Sharon (13):
      iwlwifi: mvm: set the correct descriptor size for tracing
      iwlwifi: mvm: fix RSS key sizing
      iwlwifi: mvm: enable VHT MU-MIMO for supported hardware
      iwlwifi: mvm: update firmware of VHT MU-MIMO groups status on restart
      iwlwifi: support tracing wide commands
      iwlwifi: mvm: update rx_status with mactime flag
      iwlwifi: mvm: support filtered frames notification
      iwlwifi: pcie: configure more RFH settings
      iwlwifi: mvm: add duplicate packet detection per rx queue
      iwlwifi: mvm: add RSS queues notification infrastructure
      iwlwifi: mvm: support VHT MU-MIMO notification
      iwlwifi: mvm: take care of padded packets
      iwlwifi: pcie: detect and workaround invalid write ptr behavior

 drivers/net/wireless/intel/iwlwifi/Kconfig                |  13 ++-
 drivers/net/wireless/intel/iwlwifi/dvm/led.c              |   5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c         |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c             |  25 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c             |  45 +++++++--
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c             |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h           |   4 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h              |  49 ++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h |   4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c              |  13 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h               |  81 +++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-fw-error-dump.h    |   3 +
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h          |  31 ++++++
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h        |   4 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c        |  12 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h             |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h            |  21 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h        |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c               |  73 +++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c      |  75 +++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c          |  78 ++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-d3.h        |   1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h        |  94 ++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h       |  69 ++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h           | 157 ++++++++++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c           |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c               |  59 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c         |  45 ++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c         |  88 ++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h              | 143 ++++++++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c              |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c              | 120 ++++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/power.c            | 131 ++++++++++++++++---------
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c            |  16 +++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c               | 102 +++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c               |  63 +++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c             | 159 +++++++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c             |  41 +++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c              |  84 ++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h              |  25 +++--
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c               | 478 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c               | 233 +++++++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c            |   6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c             | 179 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h        | 147 +++++++++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c              | 744 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c           | 614 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c              |  87 +++++++++++++++--
 50 files changed, 3740 insertions(+), 723 deletions(-)

