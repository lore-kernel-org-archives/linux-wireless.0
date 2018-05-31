Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58046 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755259AbeEaOKY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 10:10:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-05-31
Date: Thu, 31 May 2018 17:10:15 +0300
Message-ID: <877enj29x4.fsf@kamboji.qca.qualcomm.com> (sfid-20180531_161101_722792_903C70C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

here's a pull request to net-next tree for 4.18. More info below and
please let me know if there are any problems.

Kalle

The following changes since commit e3bb946cd922b773fdc03252aefbf2472d1d530c:

  Merge branch 'TI-Ethernet-driver-warnings-fixes' (2018-05-21 16:17:11 -04=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2018-05-31

for you to fetch changes up to 76606886c9f433bb46ed9c8910cabce780b23f36:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2018-05-30 22:24:44 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 4.18

Hopefully the last pull request to 4.18 before the merge window.
Nothing major here, we have smaller new features and of course a lots
of fixes.

Major changes:

ath10k

* add memory dump support for QCA9888 and QCA99X0

* add support to configure channel dwell time

* support new DFS host confirmation feature in the firmware

ath

* update various regulatory mappings

wcn36xx

* various fixes to improve reliability

* add Factory Test Mode support

brmfmac

* add debugfs file for reading firmware capabilities

mwifiex

* support sysfs initiated device coredump

----------------------------------------------------------------
Ahmad Masri (1):
      wil6210: align to latest auto generated wmi.h

Alexei Avshalom Lazar (2):
      wil6210: disable tracing config option
      wil6210: Initialize reply struct of the WMI commands

Andrey Shevchenko (3):
      qtnfmac: remove unused function declarations
      qtnfmac: fix bg_scan_period parameter processing
      qtnfmac: cancel scan on disconnect

Anilkumar Kolli (1):
      ath10k: add memory dump support for QCA9888 and QCA99X0

Arend Van Spriel (3):
      brcmfmac: move ALLFFMAC variable in flowring module
      brcmfmac: add support for sysfs initiated coredump
      mwifiex: support sysfs initiated device coredump

Aviya Erenfeld (1):
      iwlmvm: tdls: Check TDLS channel switch support

Colin Ian King (3):
      ath10k: fix spelling mistake: "servive" -> "service"
      rsi: fix spelling mistake "Uknown" -> "Unknown"
      iwlwifi: mvm: remove division by size of sizeof(struct ieee80211_wmm_=
rule)

Daniel Mack (10):
      wcn36xx: fix buffer commit logic on TX path
      wcn36xx: set DMA mask explicitly
      wcn36xx: don't disable RX IRQ from handler
      wcn36xx: clear all masks in RX interrupt
      wcn36xx: only handle packets when ED or DONE bit is set
      wcn36xx: consider CTRL_EOP bit when looking for valid descriptors
      wcn36xx: set PREASSOC and IDLE stated when BSS info changes
      wcn36xx: drain pending indicator messages on shutdown
      wcn36xx: simplify wcn36xx_smd_open()
      wcn36xx: improve debug and error messages for SMD

Dedy Lansky (3):
      wil6210: move WMI functionality out of wil_cfg80211_mgmt_tx
      wil6210: remove unused rx_reorder members
      wil6210: rate limit wil_rx_refill error

Dmitry Lebed (2):
      qtnfmac: improve control path timeout handling
      qtnfmac: fix firmware command error path

Emmanuel Grumbach (2):
      iwlwifi: mvm: fix TSO with highly fragmented SKBs
      iwlwifi: mvm: honor the max_amsdu_subframes limit

Erel Geron (1):
      iwlwifi: fix non_shared_ant for 9000 devices

Erik Stromdahl (1):
      ath10k: fix return value check in wake_tx_q op

Eyal Ilsar (1):
      wcn36xx: Add support for Factory Test Mode (FTM)

Eyal Reizer (1):
      wlcore: sdio: check for valid platform device data before suspend

Fabio Estevam (1):
      ath10k: snoc: Remove owner assignment from platform_driver

Felix Fietkau (7):
      mt76: fix sending encrypted broadcast packets for secondary interfaces
      mt76: discard early received packets if not running yet
      mt76: only stop tx queues on offchannel, not during the entire scan
      mt76: prevent tx scheduling during channel change
      mt76: move ieee80211_hw allocation to common core
      mt76: wait for pending tx to complete before switching channel
      mt76: use udelay instead of usleep_range in mt76x2_mac_stop

Franky Lin (3):
      brcmfmac: validate user provided data for memdump before copying
      brcmfmac: trigger memory dump upon firmware halt signal
      brcmfmac: trigger memory dump on SDIO firmware halt message

Ganapathi Bhat (3):
      mwifiex: avoid exporting mwifiex_send_cmd
      mwifiex: handle race during mwifiex_usb_disconnect
      mwifiex: skip sending GT_REKEY_OFFLOAD_CFG if firmware has no support

Golan Ben Ami (1):
      iwlwifi: add csr configuration for 6300 devices

Govind Singh (1):
      ath10k: replace bit shifts with the BIT() macro for rx desc bits

Gregory Greenman (1):
      iwlwifi: mvm: open BA session only when sta is authorized

Gustavo A. R. Silva (2):
      mwifiex: mark expected switch fall-throughs
      rtlwifi: remove duplicate code

Igor Mitsyanko (1):
      qtnfmac: decode error codes from firmware replies

Johannes Berg (1):
      iwlwifi: mvm: fix race in queue notification wait

Kalle Valo (3):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2018-05-30' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Kenneth Lu (1):
      ath10k: remove variables which set but not used

Lior David (2):
      wil6210: fix call to wil6210_disconnect during unload
      wil6210: change reply_size arg to u16 in wmi_call

Lorenzo Bianconi (1):
      mt76x2: apply coverage class on slot time too

Luc Van Oostenryck (1):
      ath6kl: fix ath6kl_data_tx()'s return type

Marcus Folkesson (1):
      ath10k: hw: make consistent usage of ATH10K_FW_DIR in paths

Niklas Cassel (1):
      ath10k: sdio: jump to correct label in error handling path

Ping-Ke Shih (13):
      rtlwifi: remove CONNECTION_MONITOR flag
      rtlwifi: remove duplicate rx_packet_type definition
      rtlwifi: rename register-based C2H command IDs to V0
      rtlwifi: remove duplicate C2H definition
      rtlwifi: remove unused fw C2H command ID
      rtlwifi: remove dummy hal_op rx_command_packet from rtl8188ee and rtl=
8723ae
      rtlwifi: Add hal_op c2h_ra_report_handler for special process
      rtlwifi: remove duplicate C2H handler
      rtlwifi: remove hal_op rx_command_packet
      rtlwifi: remove hal_op c2h_content_parsing
      rtlwifi: use sk_buff to queue C2H commands
      rtlwifi: access skb->data to get C2H data by macro
      rtlwifi: fix btmpinfo timeout while processing C2H_BT_INFO

Pradeep Kumar Chitrapu (1):
      ath10k: add support to configure channel dwell time

Rafa=C5=82 Mi=C5=82ecki (1):
      brcmfmac: add debugfs entry for reading firmware capabilities

Sanjay Konduri (2):
      rsi: add fix for crash during assertions
      rsi: add fix for corruption of auto rate table

Sara Sharon (1):
      iwlwifi: mvm: drop UNKNOWN security type frames

Sergey Matyukevich (3):
      qtnfmac: simplify notation
      qtnfmac: cleanup wdev structure between its uses
      qtnfmac: fix invalid STA state on EAPOL failure

Shaul Triebitz (1):
      iwlwifi: pcie: fix race in Rx buffer allocator

Sriram R (2):
      ath: add support to get the detected radar specifications
      ath10k: DFS Host Confirmation

Sven Eckelmann (35):
      ath: Add regulatory mapping for Bahamas
      ath: Add regulatory mapping for Bermuda
      ath: Add regulatory mapping for Kenya
      ath: Add regulatory mapping for Mauritius
      ath: Add regulatory mapping for Montenegro
      ath: Add regulatory mapping for Nicaragua
      ath: Add regulatory mapping for Paraguya
      ath: Add regulatory mapping for Serbia
      ath: Add regulatory mapping for Tanzania
      ath: Add regulatory mapping for Uganda
      ath: Add regulatory mapping for APL2_FCCA
      ath: Add regulatory mapping for APL13_WORLD
      ath: Add regulatory mapping for ETSI8_WORLD
      ath: Add regulatory mapping for ETSI9_WORLD
      ath: Add regulatory mapping for FCC3_ETSIC
      ath: Map Albania to ETSI1_WORLD
      ath: Map Algeria to APL13_WORLD
      ath: Map Australia to FCC3_WORLD
      ath: Map Bangladesh to APL1_WORLD
      ath: Map Brunei Darussalam to APL6_WORLD
      ath: Map Bulgaria to ETSI1_WORLD
      ath: Map Colombia to FCC1_FCCA
      ath: Map Czech to ETSI1_WORLD
      ath: Map Honduras to FCC3_WORLD
      ath: Map Isreal to ETSI3_WORLD
      ath: Map Macedonia to ETSI1_WORLD
      ath: Map Malasia to FCC1_WORLD
      ath: Map New Zealand to FCC3_ETSIC
      ath: Map Peru to APL1_WORLD
      ath: Map Philippines to FCC3_WORLD
      ath: Map Romania to ETSI1_WORLD
      ath: Map Russia to ETSI8_WORLD
      ath: Map Singapore to FCC3_WORLD
      ath: Map Ukraine to ETSI9_WORLD
      ath: Map Zimbabwe to ETSI1_WORLD

Tamizh Chelvam (1):
      ath10k: fix kernel panic while reading tpc_stats

Tony Lindgren (1):
      wlcore: sdio: Fix flakey SDIO runtime PM handling

Tzu-En Huang (1):
      rtlwifi: support accurate nullfunc frame tx ack report

Venkateswara Naralasetty (1):
      ath10k: fix information leak in debugfs

Xinming Hu (3):
      mwifiex: correct histogram data with appropriate index
      mwifiex: increase log level for internal scan fail result
      mwifiex: reserve passive scan time for radar channel

Yu Wang (1):
      ath10k: add quiet mode support for QCA6174/QCA9377

YueHaibing (2):
      ath10k: remove useless test before clk_disable_unprepare
      atmel: Add missing call to pci_disable_device()

 drivers/net/wireless/ath/ath10k/ahb.c              |   9 +-
 drivers/net/wireless/ath/ath10k/core.h             |  22 ++
 drivers/net/wireless/ath/ath10k/coredump.c         |  98 ++++++
 drivers/net/wireless/ath/ath10k/debug.c            |  28 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |  30 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  37 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          | 136 ++++----
 drivers/net/wireless/ath/ath10k/sdio.c             |   2 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   1 -
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |  32 ++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  33 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |  16 +
 drivers/net/wireless/ath/ath10k/wmi.c              | 206 +++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h              |  34 +-
 drivers/net/wireless/ath/ath6kl/core.h             |   2 +-
 drivers/net/wireless/ath/ath6kl/txrx.c             |   2 +-
 drivers/net/wireless/ath/ath9k/dfs.c               |   2 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |   5 +-
 drivers/net/wireless/ath/dfs_pattern_detector.h    |   3 +-
 drivers/net/wireless/ath/dfs_pri_detector.h        |   3 +-
 drivers/net/wireless/ath/regd.h                    |   7 +
 drivers/net/wireless/ath/regd_common.h             |  60 ++--
 drivers/net/wireless/ath/wcn36xx/Makefile          |   2 +
 drivers/net/wireless/ath/wcn36xx/dxe.c             | 176 ++++++----
 drivers/net/wireless/ath/wcn36xx/hal.h             |  16 +
 drivers/net/wireless/ath/wcn36xx/main.c            |  13 +
 drivers/net/wireless/ath/wcn36xx/smd.c             | 113 +++++-
 drivers/net/wireless/ath/wcn36xx/smd.h             |   4 +
 drivers/net/wireless/ath/wcn36xx/testmode.c        | 149 ++++++++
 drivers/net/wireless/ath/wcn36xx/testmode.h        |  46 +++
 drivers/net/wireless/ath/wcn36xx/testmode_i.h      |  29 ++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   2 +
 drivers/net/wireless/ath/wil6210/Kconfig           |   2 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  61 +---
 drivers/net/wireless/ath/wil6210/debugfs.c         |   5 +-
 drivers/net/wireless/ath/wil6210/main.c            |   2 +
 drivers/net/wireless/ath/wil6210/netdev.c          |   8 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |   7 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |  12 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |  13 +-
 drivers/net/wireless/ath/wil6210/wmi.c             | 152 +++++---
 drivers/net/wireless/ath/wil6210/wmi.h             | 387 +++++++++++++++++=
++--
 drivers/net/wireless/atmel/atmel_pci.c             |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   2 -
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |   2 -
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   8 +
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   |   3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  36 ++
 .../broadcom/brcm80211/brcmfmac/flowring.c         |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   6 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c      |   1 +
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  38 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  36 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |  16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  16 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   3 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   2 +
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  24 +-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |  31 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |   1 +
 drivers/net/wireless/marvell/mwifiex/main.h        |   1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  18 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  10 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |  12 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |   3 +
 drivers/net/wireless/marvell/mwifiex/usb.c         |  15 +
 drivers/net/wireless/marvell/mwifiex/util.c        |  15 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   4 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  43 ++-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   5 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |   3 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  22 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |   3 +
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  15 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   4 +-
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  56 +--
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  35 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |   5 -
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   3 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   2 -
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   8 +-
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    |  15 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |   2 +
 drivers/net/wireless/quantenna/qtnfmac/trans.c     |   4 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        | 208 ++++++++---
 drivers/net/wireless/realtek/rtlwifi/base.h        |   7 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  23 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  18 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/def.h   |  32 --
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |   2 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |   7 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.h   |   4 -
 .../net/wireless/realtek/rtlwifi/rtl8192ce/def.h   |  25 --
 .../net/wireless/realtek/rtlwifi/rtl8192ee/def.h   |   8 -
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  78 +----
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |  16 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  29 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.h   |   3 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/def.h   |  25 --
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |   6 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.h   |  20 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |   1 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |   7 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.h   |   3 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/def.h   |   8 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |  69 ----
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |  13 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   2 -
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |  30 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.h   |   3 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/def.h   |  33 --
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  69 +---
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |  21 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |  31 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   |   3 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  56 ++-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   3 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   1 +
 drivers/net/wireless/ti/wlcore/sdio.c              |  21 +-
 133 files changed, 2282 insertions(+), 1157 deletions(-)
 create mode 100644 drivers/net/wireless/ath/wcn36xx/testmode.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/testmode.h
 create mode 100644 drivers/net/wireless/ath/wcn36xx/testmode_i.h

--=20
Kalle Valo
