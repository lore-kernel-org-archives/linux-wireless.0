Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46458 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752789AbdLRORa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 09:17:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luciano.coelho@intel.com
Subject: pull-request: wireless-drivers-next 2017-12-18
Date: Mon, 18 Dec 2017 16:17:24 +0200
Message-ID: <874looktmz.fsf@kamboji.qca.qualcomm.com> (sfid-20171218_151737_508037_10BB5EE2)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

a pull request for 4.16 to net-next tree. This is a big one, but on the
other hand most of the stuff here has been some time on linux-next so
hopefully there are no nasty surprises. Even though Arnd just send a
patch[1] five minutes ago about fixing a wcn36xx build warning, but I
don't think that's critical enough to hold up this, so I'll send it to
you in the next pull request.

But this time we actually have a merge conflict due to a000 hardware
rename in iwlwifi:

CONFLICT (content): Merge conflict in drivers/net/wireless/intel/iwlwifi/pc=
ie/drv.c

The fix is quite straightforward, take the 22000 versions and manually
add an entry for 0xA0F0 device:

{IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22000_2ax_cfg_hr)},

I put the 'git diff' output of my test resolution below, hopefully it
helps. I'll also Cc Luca so he can correct any mistakes I did :)

Please let me know if you have any problems.

[1] https://patchwork.kernel.org/patch/10119565/

--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@@ -652,20 -651,19 +652,20 @@@ static const struct pci_device_id iwl_h
        {IWL_PCI_DEVICE(0xA370, 0x4034, iwl9560_2ac_cfg_soc)},
        {IWL_PCI_DEVICE(0xA370, 0x40A4, iwl9462_2ac_cfg_soc)},
=20=20
- /* a000 Series */
-       {IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg_hr_cdb)},
-       {IWL_PCI_DEVICE(0x34F0, 0x0310, iwla000_2ac_cfg_jf)},
-       {IWL_PCI_DEVICE(0x2720, 0x0000, iwla000_2ax_cfg_hr)},
-       {IWL_PCI_DEVICE(0x34F0, 0x0070, iwla000_2ax_cfg_hr)},
-       {IWL_PCI_DEVICE(0x2720, 0x0078, iwla000_2ax_cfg_hr)},
-       {IWL_PCI_DEVICE(0x2720, 0x0070, iwla000_2ac_cfg_hr_cdb)},
-       {IWL_PCI_DEVICE(0x2720, 0x0030, iwla000_2ac_cfg_hr_cdb)},
-       {IWL_PCI_DEVICE(0x2720, 0x1080, iwla000_2ax_cfg_hr)},
-       {IWL_PCI_DEVICE(0x2720, 0x0090, iwla000_2ac_cfg_hr_cdb)},
-       {IWL_PCI_DEVICE(0x2720, 0x0310, iwla000_2ac_cfg_hr_cdb)},
-       {IWL_PCI_DEVICE(0x40C0, 0x0000, iwla000_2ax_cfg_hr)},
-       {IWL_PCI_DEVICE(0x40C0, 0x0A10, iwla000_2ax_cfg_hr)},
-       {IWL_PCI_DEVICE(0xA0F0, 0x0000, iwla000_2ax_cfg_hr)},
+ /* 22000 Series */
+       {IWL_PCI_DEVICE(0x2720, 0x0A10, iwl22000_2ac_cfg_hr_cdb)},
+       {IWL_PCI_DEVICE(0x34F0, 0x0310, iwl22000_2ac_cfg_jf)},
+       {IWL_PCI_DEVICE(0x2720, 0x0000, iwl22000_2ax_cfg_hr)},
+       {IWL_PCI_DEVICE(0x34F0, 0x0070, iwl22000_2ax_cfg_hr)},
+       {IWL_PCI_DEVICE(0x2720, 0x0078, iwl22000_2ax_cfg_hr)},
+       {IWL_PCI_DEVICE(0x2720, 0x0070, iwl22000_2ac_cfg_hr_cdb)},
+       {IWL_PCI_DEVICE(0x2720, 0x0030, iwl22000_2ac_cfg_hr_cdb)},
+       {IWL_PCI_DEVICE(0x2720, 0x1080, iwl22000_2ax_cfg_hr)},
+       {IWL_PCI_DEVICE(0x2720, 0x0090, iwl22000_2ac_cfg_hr_cdb)},
+       {IWL_PCI_DEVICE(0x2720, 0x0310, iwl22000_2ac_cfg_hr_cdb)},
+       {IWL_PCI_DEVICE(0x40C0, 0x0000, iwl22000_2ax_cfg_hr)},
+       {IWL_PCI_DEVICE(0x40C0, 0x0A10, iwl22000_2ax_cfg_hr)},
++      {IWL_PCI_DEVICE(0xA0F0, 0x0000, iwl22000_2ax_cfg_hr)},
=20=20
  #endif /* CONFIG_IWLMVM */


The following changes since commit 0fc66ddfaf8bb8f73c965f24928f8815b470304e:

  Documentation: net: dsa: Cut set_addr() documentation (2017-11-30 10:10:1=
6 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2017-12-18

for you to fetch changes up to 1dde35d0b8e3a9fbf24e13d16dc583f1cc5d027b:

  Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/a=
th.git (2017-12-14 18:38:48 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 4.16

A bigger pull request this time, the most visible change being the new
driver mt76. But there's also Kconfig refactoring in ath9k and ath10k,
work beginning in iwlwifi to have rate scaling in firmware/hardware,
wcn3990 support getting closer in ath10k and lots of smaller changes.

mt76

* a new driver for MT76x2e, a 2x2 PCIe 802.11ac chipset by MediaTek

ath10k

* enable multiqueue support for all hw using mac80211 wake_tx_queue op

* new Kconfig option ATH10K_SPECTRAL to save RAM

* show tx stats on QCA9880

* new qcom,ath10k-calibration-variant DT entry

* WMI layer support for wcn3990

ath9k

* new Kconfig option ATH9K_COMMON_SPECTRAL to save RAM

wcn36xx

* hardware scan offload support

wil6210

* run-time PM support when interface is down

iwlwifi

* initial work for rate-scaling offload

* Support for new FW API version 36

* Rename the temporary hw name A000 to 22000

ssb

* make SSB a menuconfig to ease disabling it all

mwl8k

* enable non-DFS 5G channels 149-165

----------------------------------------------------------------
Anilkumar Kolli (3):
      ath10k: remove MAC80211_DEBUGFS dependency on ath10k_sta_statistics
      ath10k: move pktlog_filter out of ath10k_debug
      ath10k: add per peer tx stats support for 10.2.4

Arnd Bergmann (3):
      wlcore: use boottime for fw time sync
      ath10k: use 64-bit crash dump timestamps
      wlcore: fix unused function warning

Ashish Kalra (1):
      bcma: Adjust block comment

Avraham Stern (1):
      iwlwifi: mvm: add WFA vendor specific TPC report IE to probe request

Balaji Pothunoori (1):
      ath10k: handling qos at STA side based on AP WMM enable/disable

Ben Greear (1):
      ath10k: fix invalid STS_CAP_OFFSET_MASK

Bjorn Andersson (1):
      wcn36xx: Reduce spinlock in indication handler

Colin Ian King (3):
      rtlwifi: rtl818x: remove redundant check for cck_power > 15
      wlcore, wl1251: fix spelling: "Couldnt" -> "Couldn't" and remove erro=
r on -ENOMEM
      brcmsmac: use ARRAY_SIZE on rfseq_updategainu_events

Dan Carpenter (1):
      ath9k_htc: Add a sanity check in ath9k_htc_ampdu_action()

Dedy Lansky (1):
      wil6210: print human readable names of WMI commands and events

Emmanuel Grumbach (5):
      iwlwifi: mvm: rs: don't override the rate history in the search cycle
      iwlwifi: mvm: revert support new Coex firmware API
      iwlwifi: print the version number of the firmware in hex
      iwlwifi: fix the ALIVE notification layout
      iwlwifi: mvm: remove set but unused variable in iwl_mvm_roc_done_wk

Eyal Ilsar (1):
      wcn36xx: set default BTLE coexistence config

Felix Fietkau (3):
      dt-bindings: net: add mt76 wireless device binding
      mt76: add common code shared between multiple chipsets
      mt76: add driver code for MT76x2e

Gregory Greenman (7):
      iwlwifi: mvm: rs: introduce new API for rate scaling
      iwlwifi: mvm: rs: add ops for the new rate scaling in the FW
      iwlwifi: mvm: rs: add basic implementation of the new RS API handlers
      iwlwifi: mvm: rs: new rate scale API - add FW notifications
      iwlwifi: mvm: rs: new rate scale API - add debugfs hooks
      iwlwifi: mvm: rs: add size checks when printing to a buffer
      iwlwifi: mvm: rs: add sanity check when sending LQ command

Gustavo A. R. Silva (1):
      ath9k: dfs: use swap macro in ath9k_check_chirping

Hamad Kadmany (1):
      wil6210: abort properly in cfg suspend

Ian Molton (20):
      brcmfmac: Fix parameter order in brcmf_sdiod_f0_writeb()
      brcmfmac: Register sizes on hardware are not dependent on compiler ty=
pes
      brcmfmac: Split brcmf_sdiod_regrw_helper() up.
      brcmfmac: Clean up brcmf_sdiod_set_sbaddr_window()
      brcmfmac: Remove dead IO code
      brcmfmac: Remove bandaid for SleepCSR
      brcmfmac: Remove brcmf_sdiod_request_data()
      brcmfmac: Fix asymmetric IO functions.
      brcmfmac: Remove noisy debugging.
      brcmfmac: Rename bcmerror to err
      brcmfmac: Split brcmf_sdiod_buffrw function up.
      brcmfmac: whitespace fixes in brcmf_sdiod_send_buf()
      brcmfmac: Clarify if using braces.
      brcmfmac: Rename / replace old IO functions with simpler ones.
      brcmfmac: Tidy register definitions a little
      brcmfmac: Remove brcmf_sdiod_addrprep()
      brcmfmac: remove unnecessary call to brcmf_sdiod_set_backplane_window=
()
      brcmfmac: Cleanup offsetof()
      brcmfmac: Remove unused macro.
      brcmfmac: Remove repeated calls to brcmf_chip_get_core()

Johannes Berg (3):
      iwlwifi: mvm: remove TCP wakeup support
      iwlwifi: mvm: remove superfluous flush_work()
      iwlwifi: mvm: request statistics when reading debugfs

J=C3=A9r=C3=A9my Lefaure (1):
      wireless: use ARRAY_SIZE

Kalle Valo (3):
      Merge tag 'iwlwifi-next-for-kalle-2017-11-29' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge tag 'iwlwifi-next-for-kalle-2017-12-05' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Kenneth Lu (2):
      ath6kl: remove redundant variable ies_len
      ath6kl: improve endianness handling

Larry Finger (1):
      rtlwifi: Convert individual interrupt results to struct

Lazar Alexei (5):
      wil6210: run-time PM when interface down
      wil6210: get suspend reject reason and resume triggers from FW
      wil6210: fix PCIe bus mastering in case of interface down
      wil6210: remove suspend time statistics
      wil6210: update statistics for suspend

Liad Kaufman (3):
      iwlwifi: mvm: support MGMT frames in compressed BA
      iwlwifi: dbg: allow wrt collection before ALIVE
      iwlwifi: mvm: make init_dbg effective only on failure

Limin Zhu (1):
      mwifiex: cfg80211: do not change virtual interface during scan proces=
sing

Lior David (5):
      wil6210: refresh FW capabilities during interface up
      wil6210: fix length check in __wmi_send
      wil6210: add block size checks during FW load
      wil6210: missing length check in wmi_set_ie
      wil6210: missing length check in wil_cfg80211_mgmt_tx

Loic Poulain (1):
      wcn36xx: Add hardware scan offload support

Luca Coelho (3):
      iwlwifi: rename the temporary name of A000 to the official 22000
      iwlwifi: bump FW API to 36 for 8000 and up
      iwlwifi: mvm: fix wrong #ifdef that uses a macro from backports

Manikanta Pubbisetty (2):
      ath10k: update tdls teardown state to target
      ath10k: handle tdls peer events

Matthias Schiffer (2):
      ath9k: move spectral scan support under a separate config symbol
      ath10k: move spectral scan support under a separate config symbol

Nicolas Iooss (1):
      rtlwifi: always initialize variables given to RT_TRACE()

Ping-Ke Shih (4):
      rtlwifi: Reduce IO in RX interrupt to boost throughput
      rtlwifi: fix the wrong size to calculate fifo space
      rtlwifi: cleanup the code that check whether TX ring is available
      rtlwifi: rtl_pci: 8822BE puts broadcast and multicast packet to HIQ

Rajkumar Manoharan (1):
      ath10k: unify rx processing in napi_poll

Rakesh Pillai (4):
      ath10k: wmi: modify svc bitmap parsing for wcn3990
      ath10k: wmi: add management tx by reference support over wmi
      ath10k: wmi: get wmi init parameter values from hw params
      ath10k: wmi: add hw params entry for wcn3990

Reizer, Eyal (1):
      wlcore: allow elp during wowlan suspend

Sara Sharon (2):
      iwlwifi: mvm: check for short GI only for OFDM
      iwlwifi: mvm: avoid dumping assert log when device is stopped

Sven Eckelmann (2):
      dt: bindings: add new dt entry for ath10k calibration variant
      ath10k: search DT for qcom,ath10k-calibration-variant

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      ath10k: re-enable TXQs for all devices

Tsang-Shian Lin (1):
      rtlwifi: rtl_pci: Fix the bug when inactiveps is enabled.

Vincent Legoll (1):
      ssb: make SSB a menuconfig to ease disabling it all

Weixiao Zhang (1):
      mwl8k: Expand non-DFS 5G channels

Wright Feng (1):
      brcmfmac: enlarge buffer size of caps to 512 bytes

Xinming Hu (1):
      mwifiex: do not support change AP interface to station mode

 .../bindings/net/wireless/mediatek,mt76.txt        |  32 +
 .../bindings/net/wireless/qcom,ath10k.txt          |   3 +
 drivers/bcma/driver_pcie2.c                        |   3 +-
 drivers/net/wireless/ath/ath10k/Kconfig            |   9 +-
 drivers/net/wireless/ath/ath10k/Makefile           |   2 +-
 drivers/net/wireless/ath/ath10k/core.c             |  95 ++-
 drivers/net/wireless/ath/ath10k/core.h             |  10 +-
 drivers/net/wireless/ath/ath10k/debug.c            |  18 +-
 drivers/net/wireless/ath/ath10k/debug.h            |  21 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |  27 -
 drivers/net/wireless/ath/ath10k/htt.h              |  19 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           | 181 +++--
 drivers/net/wireless/ath/ath10k/hw.c               |   2 +
 drivers/net/wireless/ath/ath10k/hw.h               |  14 +
 drivers/net/wireless/ath/ath10k/mac.c              |  65 +-
 drivers/net/wireless/ath/ath10k/spectral.h         |   4 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |   9 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          | 146 +++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          | 113 +++
 drivers/net/wireless/ath/ath10k/wmi.c              |  72 ++
 drivers/net/wireless/ath/ath10k/wmi.h              |   5 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   2 -
 drivers/net/wireless/ath/ath6kl/txrx.c             |   2 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |  14 +-
 drivers/net/wireless/ath/ath9k/Makefile            |   4 +-
 drivers/net/wireless/ath/ath9k/common-spectral.h   |   4 +-
 drivers/net/wireless/ath/ath9k/dfs.c               |   8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   4 +
 drivers/net/wireless/ath/wcn36xx/hal.h             | 107 ++-
 drivers/net/wireless/ath/wcn36xx/main.c            |  16 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             | 126 +++-
 drivers/net/wireless/ath/wcn36xx/smd.h             |   3 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  17 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         | 150 +++-
 drivers/net/wireless/ath/wil6210/ethtool.c         |  15 +
 drivers/net/wireless/ath/wil6210/fw_inc.c          |  79 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |  22 +-
 drivers/net/wireless/ath/wil6210/main.c            |  26 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |  18 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |  97 ++-
 drivers/net/wireless/ath/wil6210/pm.c              | 104 ++-
 drivers/net/wireless/ath/wil6210/wil6210.h         |  40 +-
 drivers/net/wireless/ath/wil6210/wmi.c             | 304 +++++++-
 drivers/net/wireless/ath/wil6210/wmi.h             |  17 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 377 +++------
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 248 +++---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  52 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   3 +-
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_n.c     | 462 +++---------
 drivers/net/wireless/intel/iwlwifi/Makefile        |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     | 216 ++++++
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |   4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c      | 216 ------
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h   |  30 -
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |  15 +
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     | 262 ++++++-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  15 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |   8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  20 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  11 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |  12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |  33 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        | 232 +-----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  91 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  43 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     | 314 ++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        | 234 +++---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |  48 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  35 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   7 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  14 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  36 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   4 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   7 +-
 drivers/net/wireless/marvell/mwl8k.c               |   7 +-
 drivers/net/wireless/mediatek/Kconfig              |   1 +
 drivers/net/wireless/mediatek/Makefile             |   1 +
 drivers/net/wireless/mediatek/mt76/Kconfig         |  10 +
 drivers/net/wireless/mediatek/mt76/Makefile        |  15 +
 drivers/net/wireless/mediatek/mt76/debugfs.c       |  77 ++
 drivers/net/wireless/mediatek/mt76/dma.c           | 451 +++++++++++
 drivers/net/wireless/mediatek/mt76/dma.h           |  38 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        | 112 +++
 drivers/net/wireless/mediatek/mt76/mac80211.c      | 393 ++++++++++
 drivers/net/wireless/mediatek/mt76/mmio.c          |  61 ++
 drivers/net/wireless/mediatek/mt76/mt76.h          | 360 +++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        | 227 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_core.c   |  88 +++
 .../net/wireless/mediatek/mt76/mt76x2_debugfs.c    | 133 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c    | 493 ++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h    |  80 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    | 183 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h    |  68 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 647 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h | 182 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   | 839 +++++++++++++++++=
++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    | 755 ++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    | 190 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   | 545 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    | 451 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h    | 155 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c    | 110 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    | 758 +++++++++++++++++=
++
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h   | 587 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_trace.c  |  23 +
 drivers/net/wireless/mediatek/mt76/mt76x2_trace.h  | 144 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     | 258 +++++++
 drivers/net/wireless/mediatek/mt76/trace.c         |  23 +
 drivers/net/wireless/mediatek/mt76/trace.h         |  71 ++
 drivers/net/wireless/mediatek/mt76/tx.c            | 511 +++++++++++++
 drivers/net/wireless/mediatek/mt76/util.c          |  78 ++
 drivers/net/wireless/mediatek/mt76/util.h          |  44 ++
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c |   5 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |   2 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  75 +-
 drivers/net/wireless/realtek/rtlwifi/pci.h         |   5 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |  11 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |  12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |  12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |  11 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |  57 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |  12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   7 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |  22 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |  12 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/table.c |  14 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  11 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.h    |   3 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c |  34 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  11 +-
 drivers/net/wireless/ti/wl1251/init.c              |   4 +-
 drivers/net/wireless/ti/wlcore/acx.c               |   2 +-
 drivers/net/wireless/ti/wlcore/acx.h               |   2 -
 drivers/net/wireless/ti/wlcore/main.c              |  41 +-
 drivers/net/wireless/ti/wlcore/tx.c                |   4 +-
 drivers/ssb/Kconfig                                |   9 +-
 159 files changed, 12700 insertions(+), 2097 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek=
,mt76.txt
 create mode 100644 drivers/net/wireless/intel/iwlwifi/cfg/22000.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/cfg/a000.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mac80211.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dfs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/util.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/util.h
