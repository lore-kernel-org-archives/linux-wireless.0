Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38118 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbeHETMh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Aug 2018 15:12:37 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-08-05
Date: Sun, 05 Aug 2018 20:07:16 +0300
Message-ID: <87effc68u3.fsf@kamboji.qca.qualcomm.com> (sfid-20180805_190745_897900_D5BBB41D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

a pull request to net-next tree for 4.19. If the merge window doesn't
open today I'm planning to submit one more pull request later next week.

Please let me know if you have any problems.

Kalle


The following changes since commit aea5f654e6b78a0c976f7a25950155932c77a53f:

  net/sched: add skbprio scheduler (2018-07-24 14:44:00 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2018-08-05

for you to fetch changes up to e800a333135bef633ffb21bdd471b8ffc491db7b:

  mt76x0: rename trace symbols (2018-08-04 09:06:15 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 4.19

This time a bigger pull request as we have two new Mediatek drivers
MT76x2u (CONFIG_MT76x2U) and MT76x0U (CONFIG_MT76x0U). Also iwlwifi got
support for the new IEEE 802.11ax standard, the successor for
802.11ac. And naturally smaller new features and bugfixes all over.

Major changes:

wcn36xx

* fix WEP in client mode

wil6210

* add support for Talyn-MB (Talyn ver 2.0) device

* add support for enhanced DMA firmware feature

iwlwifi

* implement 802.11ax D2.0

* support for the new 22560 device family

* new PCI IDs for 22000 and 22560

qtnfmac

* implement cfg80211 power management callback

* enable multiple SSIDs scan support

* qtnfmac: implement basic WoWLAN support

mt7601u

* fall back to software encryption for hw unsupported ciphers

* enable 802.11 Management Frame Protection (MFP)

mt76

* support setting RTS threshold

* add USB support

* add support for MT76x2u devices

* add support for MT76x0U devices

mwifiex

* allow user space to set all other IEs except WMM IE

rsi

* add firmware support for AP+BT dual mode

----------------------------------------------------------------
Alagu Sankar (3):
      ath10k: sdio: use same endpoint id for all packets in a bundle
      ath10k: sdio: allocate correct size for RECV_1MORE_BLOCK rx packets
      ath10k: sdio: set skb len for all rx packets

Amol Hanwate (3):
      rsi: Correct RSI_NEEDED_HEADROOM in mac80211_attach.
      rsi: fill rx_params only once.
      rsi: move init_done flag to end of rsi_91x_init().

Andrey Shevchenko (1):
      qtnfmac: enable multiple SSIDs scan support

Arnd Bergmann (1):
      ath9k: use timespec64 for tsf_ts

Ben Greear (1):
      ath10k: protect ath10k_htt_rx_ring_free with rx_ring.lock

Bob Copeland (1):
      ath10k: use locked skb_dequeue for rx completions

Colin Ian King (4):
      airo: remove unused variables len and dev and clean up formatting
      ipw2x00: remove redundant variables len, ret, reason and crypt
      iwlegacy: remove several redundant variables
      ray_cs: remove redundant pointer 'p'

Daniel Mack (1):
      wcn36xx: drop unnecessary initialization of variables

Davide Caratti (1):
      mt7601u: expose 802.11w support

Emmanuel Grumbach (1):
      iwlwifi: pcie: don't access periphery registers when not available

Erik Stromdahl (3):
      ath10k: fix bug in masking of TID value
      ath10k: rename HTC_HOST_MAX_MSG_PER_BUNDLE define
      ath10k: replace hardcoded constant with define

Ganapathi Bhat (3):
      mwifiex: replace rx_pkt_lock by rx_reorder_tbl_lock
      mwifiex: restructure rx_reorder_tbl_lock usage
      mwifiex: use atomic bitops to represent adapter status variables

Ganapathi Raju (1):
      rsi: fix for 40MHZ connection issue.

Gidon Studinski (3):
      wil6210: add support for enhanced DMA structures
      wil6210: initialize TX and RX enhanced DMA rings
      wil6210: add support for enhanced DMA RX data flows

Golan Ben Ami (17):
      iwlwifi: allow different csr flags for different device families
      iwlwifi: introduce device family 22560
      iwlwifi: pcie: allocate and free rx cr's and tr's tails
      iwlwifi: pcie: support context information for 22560 devices
      iwlwifi: pcie: update bytes in the byte count table
      iwlwifi: pcie: start early debug for 22560 devices
      iwlwifi: update gen3 interrupts - sw error and image response
      iwlwifi: cancel the injective function between hw pointers to tfd ent=
ry index
      iwlwifi: support multiple tfd queue max sizes for different devices
      iwlwifi: support new tx api
      iwlwifi: introduce new rx structures used by 22560 RFH
      iwlwifi: update registers changed for 22560 devices
      iwlwifi: pcie: support 2k rx buffers
      iwlwifi: pcie: support rx structures for 22560 devices
      iwlwifi: support new rx_mpdu_desc api
      iwlwifi: hard code power save mode to CAM for 22560 devices
      iwlwifi: move some msix and rx functions to a common place

H. Nikolaus Schaller (1):
      wlcore: remove duplicate \n for some warnings

Jia-Ju Bai (2):
      atmel: Replace mdelay() with msleep() in probe_atmel_card()
      rtl818x: Replace mdelay() with msleep() in rtl8225se_rf_init

Johannes Berg (1):
      iwlwifi: 22000 devices: restrict to HT A-MPDU size

Kalle Valo (3):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2018-07-26' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge tag 'iwlwifi-next-for-kalle-2018-08-02' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next

Loic Poulain (4):
      wcn36xx: Fix WEP104 encryption type
      wcn36xx: Track associated stations
      wcn36xx: Fix WEP encryption
      wlcore: Set rx_status boottime_ns field on rx

Lorenzo Bianconi (22):
      mt7601u: use sw encryption for hw unsupported ciphers
      mt76x2: add frame protection support
      mt76x2: fix CCK protection control frame rate
      mt76: move MT_TXD_INFO, MT_MCU_MSG and MT_RX_FCE_INFO defs in dma.h
      mt76x2: move mt76x2_fw_header and mt76x2_patch_header definitions in =
mcu.h
      mt76x2: move utility routines in mt76x2.h
      mt76x2: introduce mt76x2_init_device routine
      mt76x2: move interface_modes definition in mt76x2_init
      mt76x2: introduce mt76x2_mac_load_tx_status routine
      mt76x2: add napi struct to mt76_rx_poll_complete/mt76_rx_complete sig=
natures
      mt76x2: add buffer len to mt76x2_mac_write_txwi signature
      mt76: rename mt76_tx_queue_skb in mt76_dma_tx_queue_skb
      mt76: introduce tx_queue_skb function pointer in mt76_bus_ops
      mt76: introduce mt76x2-common module
      mt76: add mt76x2_tx_common to mt76x2-common module
      mt76: add mt76x2_mac_common to mt76x2-common module
      mt76: add mt76x2_init_common to mt76x2-common module
      mt76: add mt76x2_common to mt76x2-common module
      mt76: add mt76x2_phy_common to mt76x2-common module
      mt76: move mt76x2_debugfs in mt76-common module
      mt76: add usb support to mt76 layer
      mt76: add driver code for MT76x2u based devices

Luca Coelho (9):
      iwlwifi: fw: add FW APIs for HE
      iwlwifi: add support for IEEE802.11ax
      iwlwifi: add module parameter to disable 802.11ax
      iwlwifi: mvm: add radiotap data for HE
      iwlwifi: add support for 22560 devices
      iwlwifi: pcie: add a bunch of PCI IDs for 22000 and 22560
      iwlwifi: d3: disable dbg recording before entering D3
      iwlwifi: mvm: remove dead gscan code
      iwlwifi: pcie: include tcp.h implicitly

Maya Erez (5):
      wil6210: add support for Talyn-MB (Talyn ver 2.0) device
      wil6210: add support for enhanced DMA TX data flows
      wil6210: add support for enhanced DMA debugfs
      wil6210: add support for Talyn-MB boot flow
      wil6210: remove crash dump collection from OTP section

Niklas Cassel (1):
      ath10k: transmit queued frames after processing rx packets

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: specify some features per firmware version

Roman Stratiienko (1):
      mwifiex: Fix skipped vendor specific IEs

Sara Sharon (6):
      iwlwifi: pcie: unionize used bd and completion descriptor
      iwlwifi: pcie: move rxb retrieval to a helper function
      iwlwifi: trans: add a new op for getting DMA data
      iwlwifi: mvm: configure multi RX queue
      Revert "iwlwifi: implement fseq version mismatch warning"
      iwlwifi: pcie: split tx to amsdu and non amsdu

Sebastian Andrzej Siewior (1):
      ath9k: use irqsave() in USB's complete callback

Sergei Maksimenko (1):
      qtnfmac: implement cfg80211 power management callback

Sergey Matyukevich (1):
      qtnfmac: implement basic WoWLAN support

Shahar S Matityahu (1):
      iwlwifi: allow masking out memory areas from the fw dump

Siva Rebbagondla (6):
      rsi: fix for low throughput issue
      rsi: fix for WoWLAN wakeup in security mode.
      rsi: optimize virtual interfaces
      rsi: remove redundant device ids
      rsi: remove redundant flash_content variable
      rsi: add firmware support for AP+BT dual mode

Stanislaw Gruszka (16):
      mt76x0: core files
      mt76x0: mac files
      mt76x0: usb files
      mt76x0: mcu files
      mt76x0: phy files
      mt76x0: init files
      mt76x0: eeprom files
      mt76x0: trace and debugfs files
      mt76x0: dma and tx files
      mt76x0: main file
      mt76: add more states
      mt76: Kconfig and Makefile for mt76x0 driver
      mt76x0: disable HW before probe
      mt76x0: load firmware from mediatek subdir
      mt76x0: rename mt76_* functions
      mt76x0: rename trace symbols

YueHaibing (3):
      atmel: hide unused procfs helpers
      hostap: hide unused procfs helpers
      rt2x00: remove redundant functions rt2x00mac_sta_{add/remove}

Zhi Chen (2):
      ath10k: fix scan crash due to incorrect length calculation
      ath10k: fix tlv 5ghz channel missing issue

 drivers/net/wireless/ath/ath10k/htc.c              |    4 +-
 drivers/net/wireless/ath/ath10k/htc.h              |    4 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   13 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    2 +-
 drivers/net/wireless/ath/ath10k/mac.c              |    5 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   16 +-
 drivers/net/wireless/ath/ath10k/sdio.h             |    8 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   10 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    4 +-
 drivers/net/wireless/ath/ath9k/channel.c           |   14 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    7 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    9 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   10 +-
 drivers/net/wireless/ath/ath9k/hw.h                |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |    4 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |   11 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |   30 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   95 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |    3 +
 drivers/net/wireless/ath/wil6210/Makefile          |    1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   12 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |  490 +++++-
 drivers/net/wireless/ath/wil6210/ethtool.c         |    2 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |  225 ++-
 drivers/net/wireless/ath/wil6210/main.c            |  360 ++++-
 drivers/net/wireless/ath/wil6210/netdev.c          |   73 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |   59 +-
 drivers/net/wireless/ath/wil6210/pm.c              |    6 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |   26 +-
 drivers/net/wireless/ath/wil6210/trace.h           |   59 +
 drivers/net/wireless/ath/wil6210/txrx.c            |  649 ++++----
 drivers/net/wireless/ath/wil6210/txrx.h            |  105 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       | 1598 ++++++++++++++++=
++++
 drivers/net/wireless/ath/wil6210/txrx_edma.h       |  562 +++++++
 drivers/net/wireless/ath/wil6210/wil6210.h         |  228 ++-
 drivers/net/wireless/ath/wil6210/wil_crash_dump.c  |    5 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |  502 +++++-
 drivers/net/wireless/ath/wil6210/wmi.h             |  167 +-
 drivers/net/wireless/atmel/atmel.c                 |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   38 +
 drivers/net/wireless/cisco/airo.c                  |    8 +-
 drivers/net/wireless/cisco/airo_cs.c               |    3 -
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    7 -
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c     |    2 -
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   10 -
 drivers/net/wireless/intel/iwlegacy/3945.c         |    2 -
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |    6 -
 drivers/net/wireless/intel/iwlwifi/Makefile        |    4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c      |    2 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  163 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |    1 +
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c      |    3 +
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c      |    1 +
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |    1 +
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |    1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |   18 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   10 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |   12 +
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |  172 +++
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   36 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  250 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   25 +
 drivers/net/wireless/intel/iwlwifi/fw/common_rx.c  |   88 --
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  284 ++--
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   40 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   37 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    3 -
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    7 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |  286 ++++
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  |    5 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |    5 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   74 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |    8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   28 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  110 ++
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   29 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    7 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   50 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    4 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  205 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   44 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   39 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  364 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   48 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |  207 +++
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   62 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   27 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  294 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  388 +++--
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   11 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  235 +--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  192 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   92 +-
 drivers/net/wireless/intersil/hostap/hostap_ap.c   |    8 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |   17 +-
 drivers/net/wireless/intersil/hostap/hostap_proc.c |   10 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |    5 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   95 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |    3 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   34 +-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |    2 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |    8 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |    5 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |   33 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |   17 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   12 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |    3 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   12 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |    3 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |    8 +-
 drivers/net/wireless/marvell/mwifiex/sta_tx.c      |    2 +-
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |    3 +
 drivers/net/wireless/marvell/mwifiex/usb.c         |   25 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |    6 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c         |    2 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |   26 +
 drivers/net/wireless/mediatek/mt76/Makefile        |   20 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |    2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   77 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |   43 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   20 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  162 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile |    7 +
 drivers/net/wireless/mediatek/mt76/mt76x0/core.c   |   34 +
 .../net/wireless/mediatek/mt76/mt76x0/debugfs.c    |  166 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c    |  522 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h    |  126 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |  445 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |  149 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  720 +++++++++
 .../net/wireless/mediatek/mt76/mt76x0/initvals.h   |  282 ++++
 .../wireless/mediatek/mt76/mt76x0/initvals_phy.h   |  772 ++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    |  660 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |  154 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  403 +++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c    |  656 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h    |  101 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  330 ++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 1008 ++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.h    |   81 +
 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h   |  651 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c  |   21 +
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  |  313 ++++
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  270 ++++
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  381 +++++
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h    |   61 +
 drivers/net/wireless/mediatek/mt76/mt76x0/util.c   |   42 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |   91 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  350 +++++
 .../net/wireless/mediatek/mt76/mt76x2_debugfs.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    |   21 -
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h    |   38 -
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  305 +---
 .../wireless/mediatek/mt76/mt76x2_init_common.c    |  259 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |  656 +-------
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |    2 +-
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c |  699 +++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  323 +---
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    |   17 -
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h    |   17 +
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    |  347 -----
 .../net/wireless/mediatek/mt76/mt76x2_phy_common.c |  349 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h   |   30 +
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |  128 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |  149 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_usb.c    |  142 ++
 drivers/net/wireless/mediatek/mt76/mt76x2u.h       |   83 +
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |  108 ++
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c  |  318 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c   |  240 +++
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  185 +++
 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c   |  463 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c   |  303 ++++
 drivers/net/wireless/mediatek/mt76/tx.c            |   85 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  845 +++++++++++
 drivers/net/wireless/mediatek/mt76/usb_mcu.c       |  242 +++
 drivers/net/wireless/mediatek/mt76/usb_trace.c     |   23 +
 drivers/net/wireless/mediatek/mt76/usb_trace.h     |   71 +
 drivers/net/wireless/mediatek/mt7601u/init.c       |    1 +
 drivers/net/wireless/mediatek/mt7601u/main.c       |   11 +
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  100 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  154 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |    3 +
 drivers/net/wireless/quantenna/qtnfmac/core.c      |    1 +
 drivers/net/wireless/quantenna/qtnfmac/core.h      |    3 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |   85 ++
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     |   18 -
 drivers/net/wireless/ray_cs.c                      |    6 +-
 .../wireless/realtek/rtl818x/rtl8180/rtl8225se.c   |    4 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   28 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    3 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |    7 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   23 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    5 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |    6 +-
 drivers/net/wireless/rsi/rsi_mgmt.h                |    2 +-
 drivers/net/wireless/rsi/rsi_sdio.h                |    3 +
 drivers/net/wireless/rsi/rsi_usb.h                 |    3 +
 drivers/net/wireless/ti/wlcore/main.c              |   10 +-
 drivers/net/wireless/ti/wlcore/rx.c                |    8 +-
 211 files changed, 22060 insertions(+), 3866 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx_edma.c
 create mode 100644 drivers/net/wireless/ath/wil6210/txrx_edma.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/common_rx.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-context-info-gen=
3.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals_phy.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/phy.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/util.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_phy_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb_trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb_trace.h
