Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58934 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbeEQIok (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 04:44:40 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-05-17
Date: Thu, 17 May 2018 11:44:34 +0300
Message-ID: <87k1s2k6x9.fsf@kamboji.qca.qualcomm.com> (sfid-20180517_104544_026246_E8B5208A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's a pull request to net-next for 4.18. I forgot to mention in the
signed tag was that one id is added to include/linux/mmc/sdio_ids.h but
that was acked by Ulf.

I suspect hat because of my merge of wireless-drivers into
wireless-drivers-next the diffstat from request-pull was wrong again. I
manually replaced that with the diffstat from my test pull to net-next.

Please let me know if you have any problems.

Kalle

The following changes since commit af8a41cccf8f469165c6debc8fe07c5fd2ca501a:

  rtlwifi: cleanup 8723be ant_sel definition (2018-04-24 13:15:08 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2018-05-17

for you to fetch changes up to 763ece85f45a6b93268e25a0abf02922f911dab4:

  brcmfmac: fix initialization of struct cfg80211_inform_bss variable (2018=
-05-15 18:03:35 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 4.18

The first pull request for 4.18. As usual new features and bug fixes
but nothing really special.

I also merged wireless-drivers due to an iwlwifi patch dependency.

Major changes:

iwlwifi

* implement Traffic Condition Monitor and use it for scan, BT coex and
  to detect when the AP doesn't support UAPSD properly

* some more work for the 22000 family of devices;

* introduce AMSDU rate control offload

qtnfmac

* DFS offload support

rsi

* roaming enhancements

* increase max supported aggregation subframes

* don't advertise 5 GHz support if the device doesn't support it

brcmfmac

* add support for BCM4366E chipset

* add support for bcm43364 wireless chipset

ath10k

* enable temperature reads for QCA6174 and QCA9377

* add firmware memory dump support for QCA9984

* continue adding WCN3990 support via SNOC bus

----------------------------------------------------------------
Amitkumar Karwar (7):
      rsi: disable fw watchdog timer during reset
      rsi: device bootup parameter configuration
      rsi: use appropriate interface for power save configuration
      rsi: increase max supported aggregation subframes
      rsi: parse TID from data frame correctly
      rsi: enable power save by default for coex
      rsi: advertise 5GHz support based on device capability

Arend Van Spriel (2):
      brcmfmac: check p2pdev mac address uniqueness
      brcmfmac: constify firmware mapping tables

Arnd Bergmann (1):
      ath10k: avoid possible string overflow

Carl Huang (2):
      ath10k: add WMI_SERVICE_AVAILABLE_EVENT support
      ath10k: support MAC address randomization in scan

Colin Ian King (9):
      wil6210: fix potential null dereference of ndev before null check
      ath10k: fix spelling mistake: "tiggers" -> "triggers"
      ath6kl: fix spelling mistake: "chache" -> "cache"
      cw1200: fix spelling mistake: "Mailformed" -> "Malformed"
      rt2x00: fix spelling mistake in various macros, UKNOWN -> UNKNOWN
      ipw2100: fix spelling mistake: "decsribed" -> "described"
      rtlwifi: fix spelling mistake: "dismatch" -> "mismatch"
      ipw2200: fix spelling mistake: "functionalitis" -> "functionalities"
      rsi: fix spelling mistake: "thead" -> "thread"

Dan Carpenter (2):
      rsi: remove unecessary PTR_ALIGN()s
      mwifiex: pcie: tighten a check in mwifiex_pcie_process_event_ready()

Dan Haab (1):
      brcmfmac: add support for BCM4366E chipset

Daniel Mack (11):
      wcn36xx: check for DMA mapping errors in wcn36xx_dxe_tx_frame()
      wcn36xx: don't keep reference to skb if transmission failed
      wcn36xx: don't delete invalid bss indices
      wcn36xx: allocate skbs with GFP_KERNEL during init
      wcn36xx: use READ_ONCE() to access desc->ctrl
      wcn36xx: pass correct BSS index when deleting BSS keys
      wcn36xx: abort scan request when 'dequeued' indicator is sent
      wcn36xx: cancel pending scan request when interface goes down
      wcn36xx: handle scan cancellation when firmware support is missing
      wcn36xx: send bss_type in scan requests
      wcn36xx: pass information elements in scan requests

Dmitry Lebed (1):
      qtnfmac: add DFS offload support

Eliad Peller (2):
      iwlwifi: pcie: allow sending pre-built A-MSDUs
      iwlwifi: mvm: set wakeup filters for wowlan "any" configuration

Emmanuel Grumbach (3):
      iwlwifi: mvm: BT Coex - make the primary / secondary pick traffic awa=
re
      iwlwifi: pcie: implement the overlow queue for Gen2 devices
      iwlwifi: mvm: set the MFP flag for keys that are used by MFP stations

Erik Stromdahl (2):
      ath10k: add inlined wrappers for htt tx ops
      ath10k: add inlined wrappers for htt rx ops

Eyal Reizer (1):
      wlcore: sdio: allow pm to handle sdio power

Felix Fietkau (11):
      mt76: stop tx queues from the driver callback instead of common code
      mt76: add missing VHT maximum A-MPDU length capability
      mt76: toggle driver station powersave bit before notifying mac80211
      mt76: rework tx power handling
      mt76: fix potential sleep in atomic context
      mt76: set RX_FLAG_DUP_VALIDATED for A-MPDU reordered packets
      mt76: check qos ack policy before reordering packets
      mt76: fix concurrent rx calls on A-MPDU release
      mt76: add rcu locking in tid reorder function
      mt76: add rcu locking around tx scheduling
      mt76: check for pending reset before attempting to schedule tx

Franky Lin (5):
      brcmfmac: reports boottime_ns while informing bss
      brcmfmac: use nl80211_band directly to get ieee80211 channel
      brcmfmac: add hostready indication
      brcmfmac: coarse support for PCIe shared structure rev7
      brcmfmac: fix initialization of struct cfg80211_inform_bss variable

Ganapathi Bhat (1):
      mwifiex: increase TX threashold to avoid TX timeout during ED MAC test

Golan Ben Ami (2):
      iwlwifi: allow different csr flags for different device families
      iwlwifi: support new csr addresses for hw address

Golan Ben-Ami (1):
      iwlwifi: introduce Image Loader (IML) - new firmware image

Govind Singh (15):
      ath10k: build ce layer in ath10k core module
      ath10k: platform driver for WCN3990 SNOC WLAN module
      ath10k: add resource init and deinit for WCN3990
      ath10k: add hif start/stop methods for wcn3990 snoc layer
      ath10k: add HTC services for WCN3990
      ath10k: map HTC services to tx/rx pipes for wcn3990
      ath10k: add hif power-up/power-down methods
      ath10k: add hif tx methods for wcn3990
      ath10k: add hif rx methods for wcn3990
      ath10k: modify hif tx paddr to dma_addr_t type
      ath10k: vote for hardware resources for WCN3990
      dt: bindings: add bindings for wcn3990 wifi block
      ath10k: fix fw path name for WCN3990 target
      ath10k: enable SRRI/DRRI support on ddr for WCN3990
      ath10k: enable sta idle power save

Gregory Greenman (1):
      iwlwifi: mvm: support offload of AMSDU rate control

Gustavo A. R. Silva (6):
      ath9k: dfs: remove accidental use of stack VLA
      mt7601u: phy: mark expected switch fall-through
      brcmsmac: phy_lcn: remove duplicate code
      qtnfmac: pearl: pcie: fix memory leak in qtnf_fw_work_handler
      rsi_91x: fix structurally dead code
      rsi_91x: fix uninitialized variable

Haim Dreyfuss (1):
      iwlwifi: move timestamp functions from debugfs.h to dbg.h

Jia-Ju Bai (1):
      net: wireless: b43legacy: Replace GFP_ATOMIC with GFP_KERNEL in dma_t=
x_fragment

Johannes Berg (3):
      iwlwifi: mvm: detect U-APSD breaking aggregation
      iwlwifi: mvm: clean up scan capability checks
      iwlwifi: mvm: move skb padding reservation earlier

Julia Lawall (1):
      mwifiex: delete unneeded include

Kalle Valo (4):
      Merge tag 'iwlwifi-next-for-kalle-2018-04-20' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge git://git.kernel.org/.../kvalo/wireless-drivers.git
      Merge tag 'iwlwifi-next-for-kalle-2018-04-26' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next

Liad Kaufman (2):
      iwlwifi: support api ver2 of NVM_GET_INFO resp
      iwlwifi: mvm: support 22000 HW opening agg before traffic

Loic Poulain (2):
      wcn36xx: Add missing fall through comment in smd.c
      wcn36xx: Remove useless skb spinlock

Lorenzo Bianconi (10):
      mt76x2: fix tssi initialization for 5GHz band
      mt76x2: make mt76x2_mac_reset routine static
      mt76x2: remove unnecessary MT_TX_ALC_CFG_4 configuration
      mt76x2: fix tx_alc_enabled check
      mt76x2: set default values in TX_ALC_CFG_{1, 2} for tempetaure compen=
sation
      mt76x2: fix TXD_INFO bitmask definition
      mt76x2: fix is_mt7612 routine
      mt76x2: remove unnecessary break in mt76x2_mac_process_tx_rate()
      mt76x2: fix avg_rssi estimation
      mt76x2: add a polling delay in mt76x2_mac_stop routine

Luc Van Oostenryck (2):
      mwifiex: fix mwifiex_hard_start_xmit()'s return type
      qtnfmac: fix qtnf_netdev_hard_start_xmit()'s return type

Luca Coelho (10):
      iwlwifi: mvm: add traffic condition monitoring (TCM)
      iwlwifi: mvm: use TCM data to decide scan priority
      iwlwifi: mvm: fix OOC priority in scans
      iwlwifi: use flags to denote modifiers for the channel maps
      iwlwifi: remove upper case letters in sku_capa_band_*_enable
      iwlwifi: cfg: remove unnecessary cfg data in non-dvm devices
      iwlwifi: fw: harden page loading code
      iwlwifi: fw: combine loading of last page block into main copy loop
      iwlwifi: pcie: remove non-responsive device
      iwlwifi: make bitfield a u32 instead of u16

Maharaja Kennadyrajan (1):
      ath10k: fix a typo in ath10k_wmi_set_wmm_param()

Manikanta Pubbisetty (1):
      ath10k: correct target assert problem due to CE5 stuck

Marcus Folkesson (1):
      ath10k: sdio: fix memory leak for probe allocations

Naftali Goldstein (1):
      iwlwifi: mvm: update rs-fw API

Ping-Ke Shih (2):
      rtlwifi: btcoex: remove identical statements within if-else branches
      rtlwifi: remove duplicate definition of antenna number for btcoex

Prameela Rani Garnepudi (4):
      rsi: move xtend_desc structure from rsi_main.h to rsi_mgmt.h
      rsi: move descriptor preparation to core
      rsi: enable 80MHz clock by default
      rsi: roaming enhancements

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag

Rakesh Pillai (5):
      ath10k: add support to get target info from hif ops
      ath10k: check all CE for data if irq summary is not retained
      ath10k: enable hw checksum for wcn3990
      ath10k: add hw params for shadow register support
      ath10k: add support for shadow register for WNC3990

Sanjay Kumar Konduri (1):
      rsi: Add null check for virtual interfaces in wowlan config

Sara Sharon (8):
      iwlwifi: mvm: detect low latency and traffic load per band
      iwlwifi: pcie: allocate shorter TX queues for 22000 devices
      iwlwifi: Revert "iwlwifi: pcie: dynamic Tx command queue size"
      iwlwifi: add TX queue size parameter to TX queue allocation
      iwlwifi: pcie: use the queue size as sent by opmode
      iwlwifi: mvm: use shorter queues for mgmt and auxilary queues
      iwlwifi: mvm: use the new get_tid function
      iwlwifi: mvm: remove check for non low latency TIDs

Sean Lanigan (1):
      brcmfmac: Add support for bcm43364 wireless chipset

Shaul Triebitz (3):
      iwlwifi: move all NVM parsing code to the common files
      iwlwifi: pcie: gen2: fix race in cmd fifo write ptr
      iwlwifi: get rid of fw/nvm.c

Siva Rebbagondla (4):
      rsi: fix nommu_map_sg overflow kernel panic
      rsi: Fix 'invalid vdd' warning in mmc
      rsi: reset hibernate_resume flag to work hibernate resume in coex mod=
e.
      rsi: Set wowlan flag while writing wowlan config parameters

Stanislaw Gruszka (4):
      mt7601u: use EWMA to calculate avg_rssi
      mt7601u: run calibration works after finishing scanning
      rt2x00: call sta_add/remove directly in rt2800
      rt2x00: check against flushing empty queue

Taketo Kabe (1):
      b43: fix transmit failure when VT is switched

Thomas Hebb (1):
      ath10k: search all IEs for variant before falling back

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      wireless-drivers: Dynamically allocate struct station_info

Venkateswara Naralasetty (1):
      ath10k: Add tx ack signal support for management frames

Wen Gong (1):
      ath10k: convert wow pattern from 802.3 to 802.11

Xinming Hu (5):
      mwifiex: uap: filter duplicate ERP IE
      mwifiex: uap: support cfg80211 ignore_broadcast_ssid=3D2
      mwifiex: make firmware mac address consistent with host configuration
      mwifiex: always configure firmware mac address during changing virtua=
l interface
      mwifiex: keep user configured mac address during changing virtual int=
erface

Xose Vazquez Perez (1):
      rt2x00: rt2800: add antenna diversity for RT5370G

 drivers/net/wireless/ath/ath10k/Kconfig                          |   12 ++
 drivers/net/wireless/ath/ath10k/Makefile                         |    7 +-
 drivers/net/wireless/ath/ath10k/ce.c                             |  269 ++=
++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/ce.h                             |   24 ++-
 drivers/net/wireless/ath/ath10k/core.c                           |  183 ++=
+++++++++-------
 drivers/net/wireless/ath/ath10k/core.h                           |    2 +
 drivers/net/wireless/ath/ath10k/hif.h                            |   15 +-
 drivers/net/wireless/ath/ath10k/htc.c                            |    6 +
 drivers/net/wireless/ath/ath10k/htc.h                            |    4 +
 drivers/net/wireless/ath/ath10k/htt.c                            |    4 +-
 drivers/net/wireless/ath/ath10k/htt.h                            |  111 ++=
++++++++-
 drivers/net/wireless/ath/ath10k/htt_rx.c                         |   24 ++-
 drivers/net/wireless/ath/ath10k/htt_tx.c                         |   19 +-
 drivers/net/wireless/ath/ath10k/hw.c                             |    9 +-
 drivers/net/wireless/ath/ath10k/hw.h                             |   22 ++-
 drivers/net/wireless/ath/ath10k/mac.c                            |   26 ++-
 drivers/net/wireless/ath/ath10k/pci.c                            |    8 +-
 drivers/net/wireless/ath/ath10k/sdio.c                           |   24 +--
 drivers/net/wireless/ath/ath10k/snoc.c                           | 1414 ++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/snoc.h                           |   95 ++=
++++++++
 drivers/net/wireless/ath/ath10k/txrx.c                           |    8 +
 drivers/net/wireless/ath/ath10k/wmi-ops.h                        |   46 ++=
+++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c                        |   63 ++=
+++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h                        |  357 ++=
++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c                            |   34 ++=
+-
 drivers/net/wireless/ath/ath10k/wmi.h                            |   28 +++
 drivers/net/wireless/ath/ath10k/wow.c                            |  138 ++=
+++++++++++-
 drivers/net/wireless/ath/ath6kl/debug.c                          |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c                           |   14 +-
 drivers/net/wireless/ath/ath9k/dfs.c                             |    6 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c                           |   36 ++=
--
 drivers/net/wireless/ath/wcn36xx/dxe.h                           |    1 -
 drivers/net/wireless/ath/wcn36xx/hal.h                           |    8 +-
 drivers/net/wireless/ath/wcn36xx/main.c                          |   40 ++=
+-
 drivers/net/wireless/ath/wcn36xx/smd.c                           |   33 ++=
+-
 drivers/net/wireless/ath/wcn36xx/smd.h                           |    2 +
 drivers/net/wireless/ath/wcn36xx/txrx.c                          |   15 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h                       |    7 +-
 drivers/net/wireless/ath/wil6210/debugfs.c                       |   22 ++-
 drivers/net/wireless/ath/wil6210/main.c                          |    3 +-
 drivers/net/wireless/ath/wil6210/wmi.c                           |   19 +-
 drivers/net/wireless/broadcom/b43/dma.c                          |   14 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c                    |    2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c        |    1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c      |   51 ++=
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c          |    1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c      |    2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h      |    2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.h        |    6 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c           |    7 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c          |   40 ++=
+-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c          |    2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c           |    2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c   |    9 +-
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h    |    1 +
 drivers/net/wireless/intel/ipw2x00/ipw2100.c                     |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.h                     |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c                     |    2 +-
 drivers/net/wireless/intel/iwlwifi/Makefile                      |    2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c                    |    8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c                    |   13 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c                   |   11 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c                    |    8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c                    |   19 +-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c                    |   12 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c                    |   10 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c                    |    6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c                    |    8 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h             |    5 -
 drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h              |   42 ++=
+--
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h                   |  156 ++=
++++----------
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h                  |    2 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h                      |   36 ++=
++
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c                  |    1 +
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h                  |   31 --=
--
 drivers/net/wireless/intel/iwlwifi/fw/file.h                     |    3 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h                      |    6 +
 drivers/net/wireless/intel/iwlwifi/fw/nvm.c                      |  162 --=
--------------
 drivers/net/wireless/intel/iwlwifi/fw/paging.c                   |   78 ++=
++----
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h                  |    1 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h                  |   92 ++=
++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h                     |   28 +--
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c                     |   14 ++
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c            |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.h            |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-read.c             |    8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h               |    2 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c               |  353 ++=
++++++++++++++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h               |   56 ++=
++--
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h                   |   13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c                    |   37 ++=
++
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h               |    7 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c                      |   22 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c             |    2 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c                 |   25 +++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c                      |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c                |   33 ++=
++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h                     |  101 ++=
++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c                     |  208 +-=
-------------------
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c                     |   18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c                   |  117 ++=
++++------
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c                      |   15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h                      |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c                      |  103 ++=
+++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c                    |   33 ++=
--
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c                    |  194 ++=
+++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c                     |   28 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h                     |    7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c                      |   56 ++=
+++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c                   |  438 ++=
+++++++++++++++++++++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c              |    2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h               |    8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c                     |    3 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c             |   15 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c                  |  139 ++=
++++++++----
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c                |   55 ++=
++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c                     |   52 ++=
+---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c                  |    7 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c                    |    1 -
 drivers/net/wireless/marvell/mwifiex/ie.c                        |    1 +
 drivers/net/wireless/marvell/mwifiex/main.c                      |   43 ++=
+--
 drivers/net/wireless/marvell/mwifiex/main.h                      |    7 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c                      |    3 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c                 |   25 ++-
 drivers/net/wireless/mediatek/mt76/agg-rx.c                      |   16 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c                    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76.h                        |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h                      |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h                  |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c               |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h               |    6 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c                 |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c                  |    1 -
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h                  |    1 -
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c                 |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c                  |   84 ++=
++++---
 drivers/net/wireless/mediatek/mt76/tx.c                          |    6 +
 drivers/net/wireless/mediatek/mt7601u/mac.c                      |    4 +-
 drivers/net/wireless/mediatek/mt7601u/main.c                     |    6 +
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h                  |    5 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c                      |   11 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c                |    9 +
 drivers/net/wireless/quantenna/qtnfmac/core.c                    |    2 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c                   |   52 ++=
++--
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c              |    4 +
 drivers/net/wireless/quantenna/qtnfmac/qlink.h                   |    7 +-
 drivers/net/wireless/ralink/rt2x00/rt2800.h                      |   17 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c                   |   20 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h                   |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c                  |    1 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c                   |    6 +-
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c                   |    6 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c                   |    6 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h                      |    4 -
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c                   |    3 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c                 |    2 +
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c |    2 +-
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c |    2 +-
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a1ant.c |   19 +-
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8821a2ant.c |    2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c              |    4 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h                      |    5 -
 drivers/net/wireless/rsi/rsi_91x_coex.c                          |    1 +
 drivers/net/wireless/rsi/rsi_91x_core.c                          |   33 ++=
+-
 drivers/net/wireless/rsi/rsi_91x_hal.c                           |  108 ++=
+++++----
 drivers/net/wireless/rsi/rsi_91x_mac80211.c                      |   72 ++=
++---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c                          |   34 ++=
--
 drivers/net/wireless/rsi/rsi_91x_sdio.c                          |   27 +--
 drivers/net/wireless/rsi/rsi_91x_usb.c                           |    8 +
 drivers/net/wireless/rsi/rsi_boot_params.h                       |    3 +-
 drivers/net/wireless/rsi/rsi_hal.h                               |    3 +
 drivers/net/wireless/rsi/rsi_main.h                              |    7 +-
 drivers/net/wireless/rsi/rsi_mgmt.h                              |   19 +-
 drivers/net/wireless/rsi/rsi_sdio.h                              |    2 +-
 drivers/net/wireless/rsi/rsi_usb.h                               |    1 +
 drivers/net/wireless/st/cw1200/txrx.c                            |    2 +-
 drivers/net/wireless/ti/wlcore/sdio.c                            |   27 +--
 include/linux/mmc/sdio_ids.h                                     |    1 +
 179 files changed, 5580 insertions(+), 1480 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath10k/snoc.c
 create mode 100644 drivers/net/wireless/ath/ath10k/snoc.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/nvm.c

--=20
Kalle Valo
