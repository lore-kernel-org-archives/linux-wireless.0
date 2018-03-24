Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50250 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbeCXMaG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 08:30:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-03-24
Date: Sat, 24 Mar 2018 14:30:01 +0200
Message-ID: <87o9jdr706.fsf@kamboji.qca.qualcomm.com> (sfid-20180324_133027_421518_17253DBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's the first pull request to net-next for 4.17. What's special here
is the addition of a new bluetooth driver, but that's been acked by
Marcel. Also we add a new include file to include/net because of that.

Please let me know if you have any problems.

Kalle

The following changes since commit f74290fdb363665538743d14c4f00aeacdb68d87:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-02-24=
 00:04:20 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2018-03-24

for you to fetch changes up to 28bf8312a983a7873997bf3faf4c2b4e62e4abc0:

  mwifiex: get_channel from firmware (2018-03-13 18:53:47 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 4.17

The biggest changes are the bluetooth related patches to the rsi
driver. It adds a new bluetooth driver which communicates directly
with the wireless driver and the interface is defined in
include/net/rsi_91x.h.

Major changes:

wl1251

* read the MAC address from the NVS file

rtlwifi

* enable mac80211 fast-tx support

mt76

* add capability to select tx/rx antennas

mt7601

* let mac80211 validate rx CCMP Packet Number (PN)

rsi

* bluetooth: add new btrsi driver

* btcoex support with the new btrsi driver

----------------------------------------------------------------
Arend Van Spriel (8):
      brcmfmac: move brcmf_bus_preinit() call just after changing bus state
      brcmfmac: move allocation of control rx buffer to brcmf_sdio_bus_prei=
nit()
      brcmfmac: call brcmf_attach() just before calling brcmf_bus_started()
      brcmfmac: usb: call brcmf_usb_up() during brcmf_bus_preinit()
      brcmfmac: move brcmf_attach() function in core.c
      brcmfmac: remove brcmf_bus_started() from bus api
      brcmfmac: change log level for some low-level sdio functions
      brcmfmac: remove duplicate pointer variable from brcmf_sdio_firmware_=
callback()

Arnd Bergmann (1):
      rtlwifi: rtl8192cu: remove pointless memcpy

Arvind Yadav (1):
      ssb: use put_device() if device_register fail

Colin Ian King (2):
      wireless: zd1211rw: remove redundant assignment of pointer 'q'
      brcmsmac: remove duplicated bit-wise or of IEEE80211_CHAN_NO_IR

Denis 'GNUtoo' Carikli (1):
      bcma: add HP Stream Notebook

Ganapathi Bhat (3):
      Revert "mwifiex: fix incorrect ht capability problem"
      mwifiex: fix incorrect ht capability problem
      mwifiex: get_channel from firmware

Gustavo A. R. Silva (1):
      ssb: return boolean instead of integer in ssb_dma_translation_special=
_bit

Jia-Ju Bai (1):
      bcma: Replace mdelay with usleep_range in bcma_pmu_resources_init

Johannes Berg (1):
      brcmfmac: reject too long PSK

Lorenzo Bianconi (11):
      mt76x2: remove warnings in mt76x2_mac_write_txwi()
      mt7601u: move mt7601u_set_macaddr in mac related code
      mt7601u: set device mac address in mt7601u_add_interface()
      mt7601u: make write with mask access atomic
      mt76: initialize available_antennas_{tx,rx} info
      mt76: add mt76_init_stream_cap routine
      mt76x2: add mac80211 {set,get}_antenna callbacks
      mt7601u: remove a warning in mt7601u_efuse_physical_size_check()
      mt76x2: remove unnecessary len variable in mt76x2_eeprom_load()
      mt7601u: simplify mt7601u_mcu_msg_alloc signature
      mt7601u: let mac80211 validate rx CCMP PN

Matt Redfearn (2):
      ssb: Prevent build of PCI host features in module
      bcma: Prevent build of PCI host features in module

Matthias Kaehlcke (1):
      rtlwifi: rtl8192cu: Remove variable self-assignment in rf.c

Pali Roh=C3=A1r (4):
      wl1251: Update wl->nvs_len after wl->nvs is valid
      wl1251: Generate random MAC address only if driver does not have valid
      wl1251: Parse and use MAC address from supplied NVS data
      wl1251: Set generated MAC address back to NVS data

Ping-Ke Shih (11):
      rtlwifi: enable mac80211 fast-tx support
      rtlwifi: Add Support VHT to spec_ver
      rtlwifi: Use 6 bits as sequence number of TX report
      rtlwifi: Extend tx_power_by_rate_offset size for newer IC
      rtlwifi: Add rate section and its related definition and comment
      rtlwifi: Fix VHT NSS in RC
      rtlwifi: add definition radio_mask for RF and maximum bandwidth
      rtlwifi: add efuse ops for other components
      rtlwifi: btcoex: add routine to set default port id
      rtlwifi: btcoex: Add 8822be btcoex supported files for wifi only
      rtlwifi: btcoex: fix argument typo of if-statement found by Coccinelle

Prameela Rani Garnepudi (9):
      rsi: add rx control block to handle rx packets in USB
      rsi: add header file rsi_91x
      rsi: add coex support
      Bluetooth: btrsi: add new rsi bluetooth driver
      rsi: add module parameter operating mode
      rsi: sdio changes to support BT
      rsi: improve RX handling in SDIO interface
      rsi: use dynamic RX control blocks instead of MAX_RX_URB
      rsi: improve RX packet handling in USB interface

Randy Dunlap (1):
      net/wireless: fix spaces and grammar copy/paste in vendor Kconfig hel=
p text

Sergei Maksimenko (1):
      qtnfmac: enable reloading of qtnfmac kernel modules

Sergey Matyukevich (2):
      qtnfmac: fix releasing Tx/Rx data buffers
      qtnfmac: implement asynchronous firmware loading

Siva Rebbagondla (2):
      rsi: add bluetooth rx endpoint
      rsi: handle BT traffic in driver

Sudhir Sreedharan (1):
      rtl8187: Fix NULL pointer dereference in priv->conf_mutex

Xinming Hu (2):
      mwifiex: set different mac address for interfaces with same bss type
      mwifiex: correct antenna number with high bits reserved

 drivers/bcma/Kconfig                               |   2 +-
 drivers/bcma/driver_chipcommon_pmu.c               |   2 +-
 drivers/bcma/host_pci.c                            |   1 +
 drivers/bluetooth/Kconfig                          |  12 +
 drivers/bluetooth/Makefile                         |   2 +
 drivers/bluetooth/btrsi.c                          | 188 +++++++++
 drivers/net/wireless/admtek/Kconfig                |   4 +-
 drivers/net/wireless/ath/Kconfig                   |   4 +-
 drivers/net/wireless/atmel/Kconfig                 |   4 +-
 drivers/net/wireless/broadcom/Kconfig              |   4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   1 -
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   3 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   3 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 119 +++---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  20 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  95 +++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  35 +-
 .../wireless/broadcom/brcm80211/brcmsmac/channel.c |   1 -
 drivers/net/wireless/cisco/Kconfig                 |   4 +-
 drivers/net/wireless/intel/Kconfig                 |   4 +-
 drivers/net/wireless/intersil/Kconfig              |   4 +-
 drivers/net/wireless/marvell/Kconfig               |   4 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |  30 ++
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  40 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   3 +-
 drivers/net/wireless/marvell/mwifiex/decl.h        |  17 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |   7 +
 drivers/net/wireless/marvell/mwifiex/main.c        |  24 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |  29 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  22 ++
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  19 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  56 +--
 drivers/net/wireless/mediatek/Kconfig              |   4 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  68 +++-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   3 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |   3 +
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  36 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    |  55 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h   |   2 +
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |  26 +-
 drivers/net/wireless/mediatek/mt7601u/initvals.h   |   1 +
 drivers/net/wireless/mediatek/mt7601u/mac.c        |  26 +-
 drivers/net/wireless/mediatek/mt7601u/mac.h        |   1 +
 drivers/net/wireless/mediatek/mt7601u/main.c       |   3 +
 drivers/net/wireless/mediatek/mt7601u/mcu.c        |   7 +-
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h    |   3 +-
 drivers/net/wireless/mediatek/mt7601u/usb.c        |  52 ++-
 drivers/net/wireless/quantenna/Kconfig             |   4 +-
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |   3 +-
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 418 ++++++++++-------=
----
 .../wireless/quantenna/qtnfmac/pearl/pcie_ipc.h    |   1 +
 .../quantenna/qtnfmac/pearl/pcie_regs_pearl.h      |   1 +
 drivers/net/wireless/ralink/Kconfig                |   4 +-
 drivers/net/wireless/realtek/Kconfig               |   4 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |   2 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  34 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |   2 +-
 .../rtlwifi/btcoexist/halbtc8822bwifionly.c        |  55 +++
 .../rtlwifi/btcoexist/halbtc8822bwifionly.h        |  25 ++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |  22 ++
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   2 +
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |  13 +
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |   2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   1 +
 drivers/net/wireless/realtek/rtlwifi/rc.c          |  55 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/rf.c    |   3 -
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |   1 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   1 +
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  39 +-
 drivers/net/wireless/rsi/Kconfig                   |  13 +-
 drivers/net/wireless/rsi/Makefile                  |   1 +
 drivers/net/wireless/rsi/rsi_91x_coex.c            | 179 +++++++++
 drivers/net/wireless/rsi/rsi_91x_core.c            |  20 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |  56 ++-
 drivers/net/wireless/rsi/rsi_91x_main.c            | 129 ++++++-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |  58 ++-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |  65 +++-
 drivers/net/wireless/rsi/rsi_91x_usb.c             | 186 ++++++---
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c         |  31 +-
 drivers/net/wireless/rsi/rsi_coex.h                |  37 ++
 drivers/net/wireless/rsi/rsi_common.h              |   5 +-
 drivers/net/wireless/rsi/rsi_hal.h                 |  22 ++
 drivers/net/wireless/rsi/rsi_main.h                |  21 +-
 drivers/net/wireless/rsi/rsi_mgmt.h                |   3 +
 drivers/net/wireless/rsi/rsi_sdio.h                |   8 +
 drivers/net/wireless/rsi/rsi_usb.h                 |  17 +-
 drivers/net/wireless/st/Kconfig                    |   4 +-
 drivers/net/wireless/ti/Kconfig                    |   4 +-
 drivers/net/wireless/ti/wl1251/main.c              | 102 ++++-
 drivers/net/wireless/zydas/Kconfig                 |   4 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   1 -
 drivers/ssb/Kconfig                                |   2 +-
 drivers/ssb/main.c                                 |   4 +-
 include/net/rsi_91x.h                              |  56 +++
 98 files changed, 2065 insertions(+), 727 deletions(-)
 create mode 100644 drivers/bluetooth/btrsi.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc88=
22bwifionly.c
 create mode 100644 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc88=
22bwifionly.h
 create mode 100644 drivers/net/wireless/rsi/rsi_91x_coex.c
 create mode 100644 drivers/net/wireless/rsi/rsi_coex.h
 create mode 100644 include/net/rsi_91x.h
