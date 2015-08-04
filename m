Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:22350 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbbHDUqW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:46:22 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Subject: pull request: iwlwifi-next 2015-08-04
Date: Tue, 4 Aug 2015 20:36:54 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com> (sfid-20150804_224634_042680_9CE0F733)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

It comes late, but this is the first pull request for 4.3.
I have quite a bit for the next one that will come after this one.

Please pull - thanks!

emmanuel

The following changes since commit e0456717e483bb8a9431b80a5bdc99a928b9b003:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
(2015-06-24 16:49:49 -0700)

are available in the git repository at:

 
https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
tags/iwlwifi-next-for-kalle-2015-08-04

for you to fetch changes up to 75118fdb63496e4611ab50380499ddd62b9de69f:

  iwlwifi: mvm: clean up fw-api-scan.h (2015-08-04 21:29:37 +0300)

----------------------------------------------------------------
* Deprecate -10.ucode
* Clean ups towards multiple Rx queues
* Add support for longer CMD IDs. This will be required by new
    firmwares since we are getting close to the u8 limit.
* bugfixes for the D0i3 power state
* Add basic support for FTM
* More random that doesn't really stand out

----------------------------------------------------------------
Aviya Erenfeld (1):
      iwlwifi: add wide firmware command infrastructure for TX

Avraham Stern (1):
      iwlwifi: mvm: add wide firmware command infrastructure for RX

Avri Altman (2):
      iwlwifi: mvm: update comment of power_scheme module parameter
      iwlwifi: mvm: Enable Rx Checksum hw

David Spinadel (1):
      iwlwifi: mvm: clean up fw-api-scan.h

Eliad Peller (4):
      Revert "iwlwifi: mvm: move deferred d0i3 exit to resume_complete op"
      iwlwifi: return error if d0i3 was aborted
      iwlwifi: call d3_suspend/resume in d0i3 case as well
      iwlwifi: pcie: reset write pointer on ict reset

Emmanuel Grumbach (5):
      iwlwifi: dvm: start HW before running FW
      iwlwifi: pcie: lock start_hw / start_fw / stop_device
      iwlwifi: pcie: cancel Tx timer upon firmware crash
      iwlwifi: pcie: add missing calls to synchronize_irq()
      iwlwifi: pcie: don't warn on long MPDUs when supported

Eyal Shapira (1):
      iwlwifi: mvm: rs: report last tx rate based on RSSI and caps

Gregory Greenman (3):
      iwlwifi: mvm: add basic Time of Flight (802.11mc FTM) support
      iwlwifi: mvm: fix beacon filtering temperature thresholds for D0i3
      iwlwifi: mvm: ignore CQM when setting beacon filtering in D0i3
enter flow

Haim Dreyfuss (2):
      iwlwifi: pcie: Set scheduler to work on auto mode
      iwlwifi: pcie: provide a way to stop configuration if it is forbidden

Ilan Peer (2):
      iwlwifi: mvm: Do not sample the device time for session protection
      iwlwifi: mvm: Use the AP station for non_sta transmit

Johannes Berg (10):
      iwlwifi: mvm: handle RX MPDUs separately
      iwlwifi: mvm: LRU-assign key offsets
      iwlwifi: dvm: move ADD_STA response handling to sync command
      iwlwifi: dvm: remove ADD_STA prints relying on station ID
      iwlwifi: dvm: remove command/return value from RX handlers
      iwlwifi: mvm: remove command/return value from RX handlers
      iwlwifi: remove command and return value from opmode RX
      iwlwifi: remove command header flags field
      iwlwifi: mvm: move existing UMAC commands to group 1
      iwlwifi: mvm: move TX PN assignment for CCMP to the driver

Nicholas Krause (1):
      iwlwifi: make various functions void in the file rs.c

Sara Sharon (4):
      iwlwifi: deprecate -10.ucode for 3160 / 7260 / 7265
      iwlwifi: mvm: remove IWL_UCODE_TLV_API_BASIC_DWELL
      iwlwifi: add wide firmware command support for notifications
      iwlwifi: mvm: add wide firmware command support for debug triggers

 drivers/net/wireless/iwlwifi/dvm/agn.h              |  19 +--
 drivers/net/wireless/iwlwifi/dvm/dev.h              |   5 +-
 drivers/net/wireless/iwlwifi/dvm/lib.c              |   8 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c         |  14 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c               |  51 +++---
 drivers/net/wireless/iwlwifi/dvm/rx.c               | 104 ++++--------
 drivers/net/wireless/iwlwifi/dvm/rxon.c             |   3 +-
 drivers/net/wireless/iwlwifi/dvm/scan.c             |  25 +--
 drivers/net/wireless/iwlwifi/dvm/sta.c              | 111 +++++--------
 drivers/net/wireless/iwlwifi/dvm/tx.c               |  18 +-
 drivers/net/wireless/iwlwifi/dvm/ucode.c            |   5 +-
 drivers/net/wireless/iwlwifi/iwl-7000.c             |   2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c             |   3 +-
 drivers/net/wireless/iwlwifi/iwl-config.h           |   2 +
 drivers/net/wireless/iwlwifi/iwl-csr.h              |   1 +
 drivers/net/wireless/iwlwifi/iwl-devtrace-iwlwifi.h |  14 +-
 drivers/net/wireless/iwlwifi/iwl-fw-file.h          |  16 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c       |   8 +-
 drivers/net/wireless/iwlwifi/iwl-notif-wait.h       |   5 +-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h          |  10 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h             |   4 +
 drivers/net/wireless/iwlwifi/iwl-trans.h            |  89 ++++++++--
 drivers/net/wireless/iwlwifi/mvm/Makefile           |   1 +
 drivers/net/wireless/iwlwifi/mvm/coex.c             |  44 ++---
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c      |  31 ++--
 drivers/net/wireless/iwlwifi/mvm/constants.h        |   1 +
 drivers/net/wireless/iwlwifi/mvm/d3.c               |  74 +++++++--
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c      | 751
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h     |   2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h      | 147 -----------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h       | 386
+++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h           |  36 +++-
 drivers/net/wireless/iwlwifi/mvm/fw.c               |  31 ++--
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c         |  13 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c         |  26 ++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h              | 142 ++++++++--------
 drivers/net/wireless/iwlwifi/mvm/nvm.c              |  23 +--
 drivers/net/wireless/iwlwifi/mvm/ops.c              |  52 +++---
 drivers/net/wireless/iwlwifi/mvm/power.c            |  14 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c               | 157
+++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/rs.h               |  10 ++
 drivers/net/wireless/iwlwifi/mvm/rx.c               |  37 +++--
 drivers/net/wireless/iwlwifi/mvm/scan.c             | 145 +++++------------
 drivers/net/wireless/iwlwifi/mvm/sta.c              |  41 +++--
 drivers/net/wireless/iwlwifi/mvm/sta.h              |   5 +-
 drivers/net/wireless/iwlwifi/mvm/tdls.c             |  33 ++--
 drivers/net/wireless/iwlwifi/mvm/time-event.c       |  14 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h       |   5 +-
 drivers/net/wireless/iwlwifi/mvm/tof.c              | 304
++++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/tof.h              |  94 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/tt.c               |  13 +-
 drivers/net/wireless/iwlwifi/mvm/tx.c               |  84 ++++++----
 drivers/net/wireless/iwlwifi/mvm/utils.c            |  13 +-
 drivers/net/wireless/iwlwifi/pcie/drv.c             |  17 +-
 drivers/net/wireless/iwlwifi/pcie/internal.h        |   7 +-
 drivers/net/wireless/iwlwifi/pcie/rx.c              |  23 +--
 drivers/net/wireless/iwlwifi/pcie/trans.c           | 135 ++++++++++++---
 drivers/net/wireless/iwlwifi/pcie/tx.c              |  65 +++++---
 58 files changed, 2572 insertions(+), 921 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tof.c
 create mode 100644 drivers/net/wireless/iwlwifi/mvm/tof.h

