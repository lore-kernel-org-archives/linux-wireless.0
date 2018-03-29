Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49842 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751227AbeC2NVu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 09:21:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-03-29
Date: Thu, 29 Mar 2018 16:21:44 +0300
Message-ID: <87efk3j9uf.fsf@kamboji.qca.qualcomm.com> (sfid-20180329_152209_754123_81553CB9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's a pull request to net-next for 4.17. If the merge window starts
on Sunday this will be the last pull request. Do note that I pulled
wireless-drivers into wireless-drivers-next as iwlwifi needed some
patches.

Please let me know if you have any problems.

Kalle

The following changes since commit 996bfed118748c128ad4b6c05c09fd2f5fdfa1b4:

  Merge tag 'wireless-drivers-next-for-davem-2018-03-24' of git://git.kerne=
l.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next (2018-03-25 21:2=
7:38 -0400)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2018-03-29

for you to fetch changes up to 14c99949a3398a655c47b262ca8e2e83edfae7fd:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2018-03-29 15:55:28 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 4.17

Smaller new features to various drivers but nothing really out of
ordinary.

Major changes:

ath10k

* enable chip temperature measurement for QCA6174/QCA9377

* add firmware memory dump for QCA9984

* enable buffer STA on TDLS link for QCA6174

* support different beacon internals in multiple interface scenario
  for QCA988X/QCA99X0/QCA9984/QCA4019

iwlwifi

* support for new PCI IDs for the 9000 family

* support for a new firmware API version

* support for advanced dwell and Optimized Connectivity Experience
  (OCE) in scanning

btrsi

* fix kconfig dependencies

wil6210

* support multiple virtual interfaces

----------------------------------------------------------------
Amitkumar Karwar (2):
      rsi: fix error path handling in SDIO probe
      rsi: fix kernel panic observed on 64bit machine

Andrei Otcheretianski (2):
      iwlwifi: mvm: Increase session protection time after CS
      iwlwifi: mvm: Move unused phy's to a default channel

Anilkumar Kolli (2):
      ath10k: add memory dump support QCA9984
      ath10k: advertize beacon_int_min_gcd

Arend Van Spriel (12):
      brcmfmac: do not convert linux error to firmware error string
      brcmfmac: use brcmf_chip_name() to store name in revinfo
      brcmfmac: use brcmf_chip_name() for consistency
      brcmfmac: allocate struct brcmf_pub instance using wiphy_new()
      brcmfmac: use wiphy debugfs dir entry
      brcmfmac: derive firmware filenames from basename mapping
      brcmfmac: pass struct in brcmf_fw_get_firmwares()
      brcmfmac: introduce brcmf_fw_alloc_request() function
      brcmfmac: add extension to .get_fwname() callbacks
      brcmfmac: get rid of brcmf_fw_map_chip_to_name()
      brcmfmac: get rid of brcmf_fw_get_full_name()
      brcmfmac: add kerneldoc for struct brcmf_bus::msgbuf

Arnd Bergmann (1):
      Bluetooth: btrsi: rework dependencies

Avraham Stern (3):
      iwlwifi: mvm: clear tx queue id when unreserving aggregation queue
      iwlwifi: mvm: make sure internal station has a valid id
      iwlwifi: mvm: fix array out of bounds reference

Ayala Beker (1):
      iwlwifi: fw api: support the new scan request FW API version

Beni Lev (1):
      iwlwifi: mvm: Correctly set IGTK for AP

Carl Huang (1):
      ath10k: fix use-after-free in ath10k_wmi_cmd_send_nowait

Christian Lamparter (1):
      ath10k: fix recent bandwidth conversion bug

Colin Ian King (4):
      wil6210: fix spelling mistake: "preperation"-> "preparation"
      ath5k: remove duplicated re-assignment to pointer 'tq'
      rsi: remove redundant duplicate assignment of buffer_size
      rtlwifi: rtl8821ae: fix spelling mistake: "Aboslute" -> "Absolute"

Daniel Mack (1):
      wcn36xx: dequeue all pending indicator messages

Emmanuel Grumbach (2):
      iwlwifi: mvm: set the correct tid when we flush the MCAST sta
      iwlwifi: bump the max API version for 9000 and 22000 devices

Ganapathi Bhat (1):
      mwifiex: remove warnings in mwifiex_cmd_append_11n_tlv()

Govind Singh (1):
      ath10k: fix log message for hif power on failure

Haim Dreyfuss (1):
      iwlwifi: api: Add geographic profile information to MCC_UPDATE_CMD

Ignacio Nunez Hernanz (1):
      ath10k: make ath10k report discarded packets to mac80211

Ilan Peer (1):
      iwlwifi: mvm: Allow iwl_mvm_mac_mgd_prepare_tx() when associated

Joe Perches (2):
      wireless: Use octal not symbolic permissions
      ath: Remove unnecessary ath_bcast_mac and use eth_broadcast_addr

Johannes Berg (1):
      iwlwifi: mvm: fix error checking for multi/broadcast sta

Kalle Valo (7):
      Merge tag 'iwlwifi-for-kalle-2018-03-16' of git://git.kernel.org/.../=
iwlwifi/iwlwifi-fixes
      Merge tag 'iwlwifi-for-kalle-2018-03-19' of git://git.kernel.org/.../=
iwlwifi/iwlwifi-fixes
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge git://git.kernel.org/.../kvalo/wireless-drivers.git
      Merge tag 'iwlwifi-next-for-kalle-2018-03-28' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      ath10k: refactor ath10k_pci_dump_memory() in preparation for QCA9984 =
support
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Karthikeyan Periyasamy (2):
      ath10k: Fix kernel panic while using worker (ath10k_sta_rc_update_wk)
      Revert "ath10k: send (re)assoc peer command when NSS changed"

Kevin Lo (1):
      rtlwifi: correct comment

Lior David (8):
      wil6210: add wil6210_vif structure for per-VIF data
      wil6210: support concurrency record in FW file
      wil6210: infrastructure for multiple virtual interfaces
      wil6210: add support for adding and removing virtual interfaces
      wil6210: multiple VIFs support for start/stop AP
      wil6210: rename p2p_wdev_mutex to vif_mutex
      wil6210: multiple VIFs support for connections and data path
      wil6210: add debugfs 'mids' file

Loic Poulain (2):
      wcn36xx: Fix warning due to duplicate scan_completed notification
      wcn36xx: Fix firmware crash due to corrupted buffer address

Lorenzo Bianconi (3):
      mt76: use mt76_poll_msec routine in mt76pci_load_firmware()
      mt76x2: fix possible NULL pointer dereferencing in mt76x2_tx()
      mt76x2: fix warning in ieee80211_get_key_rx_seq()

Luca Coelho (3):
      iwlwifi: add shared clock PHY config flag for some devices
      iwlwifi: mvm: check if mac80211_queue is valid in iwl_mvm_disable_txq
      iwlwifi: add a bunch of new 9000 PCI IDs

Maharaja Kennadyrajan (1):
      ath10k: debugfs support to get final TPC stats for 10.4 variants

Mordechay Goodstein (1):
      iwlwifi: set default timstamp marker cmd

Peter Gro=C3=9Fe (1):
      ath9k: spelling s/premble/preamble/

Ping-Ke Shih (11):
      rtlwifi: Add modifier static to functions reported by sparse
      rtlwifi: remove redundant statement found by static checker
      rtlwifi: btcoex: Add enum DM_INFO for btcoex to query dm's counters
      rtlwifi: btcoex: Add customer_id to do special deal to oem vendor
      rtlwifi: btcoex: Get status of multichannel concurrence
      rtlwifi: btcoex: Add rate table for the use of btcoex
      rtlwifi: btcoex: Add interaction with phydm
      rtlwifi: btcoex: Add pre- and post- normal LPS function
      rtlwifi: btcoex: add assoc type v2 to connection notify
      rtlwifi: btcoex: new definitions introduced by 8822be
      rtlwifi: btcoex: Add new but dummy definitions introduced by 8822b

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: drop Inter-Access Point Protocol packets by default

Rajkumar Manoharan (1):
      ath10k: fix vdev stats for 10.4 firmware

Rakesh Pillai (1):
      ath10k: dma unmap mgmt tx buffer if wmi cmd send fails

Ramon Fried (5):
      wcn36xx: reduce verbosity of drivers messages
      wcn36xx: calculate DXE control registers values
      wcn36xx: calculate DXE default channel values
      wcn36xx: Check DXE IRQ reason
      wcn36xx: turn off probe response offloading

Ryan Hsu (3):
      ath10k: update the IRAM bank number for QCA9377
      ath10k: enable QCA6174/QCA9377 to read the chip temperature
      ath10k: add FW API 6 firmware image for QCA9377

Sara Sharon (4):
      iwlwifi: mvm: flip AMSDU addresses only for 9000 family
      iwlwifi: mvm: take RCU lock before dereferencing
      iwlwifi: mvm: move TSO segment to a separate function
      iwlwifi: mvm: save low latency causes in an enum

Sathishkumar Muruganandam (1):
      ath10k: suppress "Unknown eventid: 36925" warnings

Sebastian Gottschall (1):
      ath9k: fix crash in spectral scan

Shahar S Matityahu (1):
      iwlwifi: wrt: add fw force restart via triggers

Sriram R (1):
      ath: fix false radar detection in JP region

Stefan Wahren (1):
      brcmfmac: Fix check for ISO3166 code

Takashi Iwai (1):
      brcmsmac: allocate ucode with GFP_KERNEL

Timothy Redaelli (1):
      ath9k: fix DFS detector synchronization

Tobin C. Harding (1):
      rsi: Remove stack VLA usage

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      ath9k: Protect queue draining by rcu_read_lock()

Vasanthakumar Thiagarajan (1):
      ath10k: add sta rx packet stats per tid

Wojciech Dubowik (2):
      ath9k: Fix airtime calculation for quarter/half channels
      ath9k: Fix ack SIFS time for quarter/half channels

Yingying Tang (4):
      ath10k: enable TDLS peer buffer STA feature
      ath10k: enable TDLS peer inactivity detection
      ath10k: avoid to set WEP key for TDLS peer
      ath10k: fix TDLS peer TX data failure issue on encryped AP

Zamir, Roee (2):
      iwlwifi: mvm: add adaptive dwell support
      iwlwifi: mvm: add support for oce

 drivers/bluetooth/Kconfig                          |   4 +-
 drivers/net/wireless/ath/ath.h                     |   2 -
 drivers/net/wireless/ath/ath10k/core.c             |   9 +-
 drivers/net/wireless/ath/ath10k/core.h             |  88 +++
 drivers/net/wireless/ath/ath10k/coredump.c         |  90 +++
 drivers/net/wireless/ath/ath10k/coredump.h         |   2 +
 drivers/net/wireless/ath/ath10k/debug.c            | 154 +++++
 drivers/net/wireless/ath/ath10k/debug.h            |  41 ++
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      | 286 ++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c           | 113 +++-
 drivers/net/wireless/ath/ath10k/mac.c              |  54 +-
 drivers/net/wireless/ath/ath10k/pci.c              | 101 ++-
 drivers/net/wireless/ath/ath10k/trace.h            |  12 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |  12 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |  56 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          | 116 +++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |  18 +
 drivers/net/wireless/ath/ath10k/wmi.c              | 462 ++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h              |  94 ++-
 drivers/net/wireless/ath/ath5k/attach.c            |   2 +-
 drivers/net/wireless/ath/ath5k/base.c              |   6 +-
 drivers/net/wireless/ath/ath5k/debug.c             |  37 +-
 drivers/net/wireless/ath/ath5k/qcu.c               |   2 -
 drivers/net/wireless/ath/ath5k/sysfs.c             |   8 +-
 drivers/net/wireless/ath/ath6kl/debug.c            |  43 +-
 drivers/net/wireless/ath/ath9k/common-debug.c      |   9 +-
 drivers/net/wireless/ath/ath9k/common-init.c       |   2 +-
 drivers/net/wireless/ath/ath9k/common-spectral.c   |  22 +-
 drivers/net/wireless/ath/ath9k/debug.c             |  40 +-
 drivers/net/wireless/ath/ath9k/debug_sta.c         |   6 +-
 drivers/net/wireless/ath/ath9k/dfs_debug.c         |   4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_debug.c     |  16 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  14 +-
 drivers/net/wireless/ath/ath9k/init.c              |  11 +-
 drivers/net/wireless/ath/ath9k/tx99.c              |   4 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   4 +
 drivers/net/wireless/ath/carl9170/debug.c          |   8 +-
 drivers/net/wireless/ath/carl9170/main.c           |   4 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |   2 +-
 drivers/net/wireless/ath/wcn36xx/debug.c           |   5 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |  69 +-
 drivers/net/wireless/ath/wcn36xx/dxe.h             | 221 +++++-
 drivers/net/wireless/ath/wcn36xx/main.c            |  14 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             | 115 ++--
 drivers/net/wireless/ath/wcn36xx/txrx.c            |  32 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   2 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        | 741 +++++++++++++++--=
----
 drivers/net/wireless/ath/wil6210/debug.c           |   9 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         | 117 +++-
 drivers/net/wireless/ath/wil6210/ethtool.c         |   4 +-
 drivers/net/wireless/ath/wil6210/fw.h              |  38 +-
 drivers/net/wireless/ath/wil6210/fw_inc.c          |  52 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |   8 +-
 drivers/net/wireless/ath/wil6210/main.c            | 333 +++++----
 drivers/net/wireless/ath/wil6210/netdev.c          | 382 +++++++++--
 drivers/net/wireless/ath/wil6210/p2p.c             | 175 ++---
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |  57 +-
 drivers/net/wireless/ath/wil6210/pm.c              | 132 ++--
 drivers/net/wireless/ath/wil6210/pmc.c             |   8 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |  45 +-
 drivers/net/wireless/ath/wil6210/txrx.c            | 177 +++--
 drivers/net/wireless/ath/wil6210/txrx.h            |  22 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         | 217 +++---
 drivers/net/wireless/ath/wil6210/wmi.c             | 460 +++++++++----
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   7 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  88 ++-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  17 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  14 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  82 +--
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 105 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   |  42 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |  17 -
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   3 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   7 +
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 242 ++++---
 .../broadcom/brcm80211/brcmfmac/firmware.h         |  82 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |   3 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  11 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 157 +++--
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |   7 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 151 +++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  96 ++-
 .../wireless/broadcom/brcm80211/brcmsmac/debug.c   |   2 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   6 +-
 drivers/net/wireless/cisco/airo.c                  |   6 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |  29 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |  51 +-
 drivers/net/wireless/intel/ipw2x00/libipw_module.c |   2 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |  35 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  19 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   8 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   4 +-
 drivers/net/wireless/intel/iwlegacy/debug.c        |  58 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |  66 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c   |  78 ++-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |  16 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  20 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  73 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  10 +
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |  26 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    |   5 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  17 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   5 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  43 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   2 +
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |  51 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   | 110 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  51 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |  21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 199 ++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  74 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 168 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  19 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 195 +++++-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  12 +-
 drivers/net/wireless/intersil/p54/main.c           |   2 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |  10 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |  10 +-
 .../net/wireless/mediatek/mt76/mt76x2_debugfs.c    |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  11 +
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |   5 +-
 drivers/net/wireless/mediatek/mt7601u/debugfs.c    |  16 +-
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c   |  64 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |   2 +-
 drivers/net/wireless/ray_cs.c                      |   8 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |   1 -
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |   1 +
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |   6 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |  33 -
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |   4 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  86 ++-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       | 122 ++++
 .../wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h    |   4 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h    |   4 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h    |   4 +-
 .../wireless/realtek/rtlwifi/rtl8723be/pwrseq.h    |   4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |  16 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h    |   4 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  33 +
 drivers/net/wireless/rsi/Kconfig                   |   4 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |  65 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   1 -
 drivers/net/wireless/rsi/rsi_sdio.h                |   2 +
 drivers/net/wireless/st/cw1200/debug.c             |   6 +-
 drivers/net/wireless/st/cw1200/main.c              |   2 +-
 drivers/net/wireless/ti/wl18xx/main.c              |  27 +-
 drivers/net/wireless/ti/wlcore/main.c              |   8 +-
 drivers/net/wireless/ti/wlcore/sdio.c              |   2 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |   7 +-
 173 files changed, 6233 insertions(+), 2505 deletions(-)
