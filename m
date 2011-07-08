Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2126 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab1GHQUd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:33 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 00/21] update for 3.1
Date: Fri,  8 Jul 2011 08:46:08 -0700
Message-Id: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182037_080561_C1817BCF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We start the work on separate the transport layer for pci-e bus interface
We also adding dynamic ps poll for better handle BT coex environment

Don Fry (1):
  iwlagn: remove iwlagn_hcmd_utils structure and call directly

Emmanuel Grumbach (7):
  iwlagn: remove the CMD_MAPPED flag
  iwlagn: add an API to free the TX context
  iwlagn: add an API for RX stop
  iwlagn: add an API for TX stop
  iwlagn: remove code duplication
  iwlagn: consolidate the API that sends host commands and move to
    transport
  iwlagn: provide heplers to access the transport ops

Fry, Donald H (3):
  iwlagn: remove the indirection for update_chain_flags
  iwlagn: remove the indirection for iwl_apm_init
  iwlagn: remove indirection for eeprom_query_addr

Meenakshi Venkataraman (2):
  mac80211: add driver RSSI threshold events
  iwlagn: Enable/disable PS poll based on RSSI and BT coex traffic
    state

Wey-Yi Guy (8):
  iwlagn: remove the indirection for the dma channel num
  iwlagn: remove double level temperature indirect call
  iwlagn: use bt handler for 2030 and 135 series devices
  iwlagn: declare static
  iwlagn: add CMD_ON_DEMAND flag for host command from testmode
  iwlagn: allow application own the uCode operation
  iwlagn: block regular host commands if driver don't own uCode
  iwlagn: separate and enhance the fixed rate from

 drivers/net/wireless/iwlwifi/iwl-1000.c       |   13 +--
 drivers/net/wireless/iwlwifi/iwl-2000.c       |   41 ++++---
 drivers/net/wireless/iwlwifi/iwl-5000.c       |   29 +----
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   30 +----
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c  |   15 ++-
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h  |    7 -
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c   |  115 ++----------------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c    |  162 +++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |   28 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c   |   55 +++++++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c    |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c     |  106 ++++-------------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c  |   14 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c        |   58 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-agn.h        |   19 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h   |    3 +
 drivers/net/wireless/iwlwifi/iwl-core.c       |   23 ++--
 drivers/net/wireless/iwlwifi/iwl-core.h       |   50 +-------
 drivers/net/wireless/iwlwifi/iwl-dev.h        |   49 ++++++--
 drivers/net/wireless/iwlwifi/iwl-eeprom.c     |    7 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl-fh.h         |    2 +-
 drivers/net/wireless/iwlwifi/iwl-hcmd.c       |   32 +----
 drivers/net/wireless/iwlwifi/iwl-led.c        |    3 +-
 drivers/net/wireless/iwlwifi/iwl-power.c      |    9 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c         |   47 +++++++-
 drivers/net/wireless/iwlwifi/iwl-scan.c       |   10 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c        |   20 +++-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c    |   49 +++++++-
 drivers/net/wireless/iwlwifi/iwl-testmode.h   |   14 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.c      |  154 +++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h      |   41 ++++++
 drivers/net/wireless/iwlwifi/iwl-tx.c         |  139 ++-------------------
 include/net/mac80211.h                        |   20 +++
 net/mac80211/driver-ops.h                     |    8 ++
 net/mac80211/driver-trace.h                   |   46 +++++++
 net/mac80211/ieee80211_i.h                    |    8 ++
 net/mac80211/mlme.c                           |   23 ++++
 net/mac80211/util.c                           |   40 ++++++
 40 files changed, 884 insertions(+), 615 deletions(-)

