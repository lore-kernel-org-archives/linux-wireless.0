Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4DDC282CC
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 07:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C9992175B
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 07:17:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="G9PVIFqr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TM65ceC8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfBFHRS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 02:17:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51848 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfBFHRS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 02:17:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7A70A607F5; Wed,  6 Feb 2019 07:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549437435;
        bh=KVRzoX7wJ3TcN5Gm+07zzjF2ksFJX6QjRmOM7mN9Pwk=;
        h=From:To:Cc:Subject:Date:From;
        b=G9PVIFqrKWJgx5G6WLE990Km2q5lJH72GfAx/xRLQhQW2+BovBXgmVsXQkpRM6OA3
         mIZ55yZ8eLoeesS846TivnQzLrQbCcxLgeXD6sAuYLBJpzxsyRUpbxrhxZupEh8b2n
         fsHvjL1fRVC+Ln0xz2Sxbrflofp50VwUtqEPNtDM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9CDB960112;
        Wed,  6 Feb 2019 07:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549437434;
        bh=KVRzoX7wJ3TcN5Gm+07zzjF2ksFJX6QjRmOM7mN9Pwk=;
        h=From:To:Cc:Subject:Date:From;
        b=TM65ceC8Zi/0k+WguDhwk1ilQZfErBeI1dlI8I+EQnF/26qjyx7ouHBqUEgs4t2Dn
         MHEdtgLgpm9oIafzQ53/nNmNl/Pe6b3LQIjQj59lU1ehcPeyn9PhxkMrEyaS9i0R40
         MqGx6+FDS04r/asXWM5/SwRYr9Lqvai12gcAtJ0g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9CDB960112
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-02-06
Date:   Wed, 06 Feb 2019 09:17:10 +0200
Message-ID: <878sytbd3d.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's a pull request to net-next for 5.1, more info below. Please let
me know if there are any problems.

Kalle


The following changes since commit bfeffd155283772bbe78c6a05dec7c0128ee500c:

  Linux 5.0-rc1 (2019-01-06 17:08:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2019-02-06

for you to fetch changes up to 030b43671ae88f827a415ad35700705ffc10d10d:

  wireless: prefix header search paths with $(srctree)/ (2019-02-01 14:42:2=
5 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 5.1

First set of patches for 5.1. Lots of new features in various drivers
but nothing really special standing out.

Major changes:

brcmfmac

* DMI nvram filename quirk for PoV TAB-P1006W-232 tablet

rsi

* support for hardware scan offload

iwlwifi

* support for Target Wakeup Time (TWT) -- a feature that allows the AP
  to specify when individual stations can access the medium

* support for mac80211 AMSDU handling

* some new PCI IDs

* relicense the pcie submodule to dual GPL/BSD

* reworked the TOF/CSI (channel estimation matrix) implementation

* Some product name updates in the human-readable strings

mt76

* energy detect regulatory compliance fixes

* preparation for MT7603 support

* channel switch announcement support

mwifiex

* support for sd8977 chipset

qtnfmac

* support for 4addr mode

* convert to SPDX license identifiers

----------------------------------------------------------------
Andrei Otcheretianski (1):
      iwlwifi: mvm: Disconnect on large beacon loss

Andrey Shevchenko (1):
      qtnfmac: support EBUSY errcode for QLINK protocol

Bernd Edlinger (5):
      rtl8723ae: Take the FW LPS mode handling out
      rtl8723ae: Dont use old data for input gain control
      rtl8723ae: Re-introduce the adaptive rate control
      rtlwifi: Don't clear num_rx_inperiod too early
      rt2x00: Work around a firmware bug with shared keys

Colin Ian King (8):
      ray_cs: fix array out-of-bounds access
      mt76: make const array 'data' static, shrinks object size
      iwlwifi: pcie: make array 'prop' static, shrinks object size
      iwlwifi: fix spelling mistake "registrating" -> "registering"
      libertas: fix indentation issue
      cw1200: fix indentation issues
      rtlwifi: rtl818x: fix indentation issue
      wlcore: clean up an indentation issue

David Spinadel (1):
      iwlwifi: mvm: Change FW channel info API

Emmanuel Grumbach (4):
      iwlwifi: mvm: advertise support for TWT in the Extended Capability IE
      iwlwifi: mvm: rely on mac80211 to configure TWT support
      iwlwifi: mvm: fix firmware statistics usage
      iwlwifi: mvm: freeze management TXQ timer when station goes to sleep

Felix Fietkau (12):
      mt76: add size check for additional rx fragments
      mt76: throttle transmission of buffered multicast packets
      mt76: request tx status for powersave released EOSP packet
      mt76: fix tx status reporting for non-probing frames
      mt76: set IEEE80211_HW_NEEDS_UNIQUE_STA_ADDR flag
      mt76: move mt76x02_get_txpower to mt76 core
      mt76: move mt76x02_phy_get_min_avg_rssi to mt76 core
      mt76: fix rssi ewma tracking
      mt76: fix signedness of rx status signal field
      mt76: add channel switch announcement support
      mt76: fix per-chain signal strength reporting
      mt76: avoid scheduling tx queues for powersave stations

Greg Kroah-Hartman (15):
      iwlegacy: no need to check return value of debugfs_create functions
      wlcore: no need to check return value of debugfs_create functions
      wl1251: no need to check return value of debugfs_create functions
      wl12xx: no need to check return value of debugfs_create functions
      wl18xx: no need to check return value of debugfs_create functions
      rtlwifi: no need to check return value of debugfs_create functions
      qtnfmac: no need to check return value of debugfs_create functions
      cw1200: no need to check return value of debugfs_create functions
      b43: no need to check return value of debugfs_create functions
      b43legacy: no need to check return value of debugfs_create functions
      brcmsmac: no need to check return value of debugfs_create functions
      rsi: no need to check return value of debugfs_create functions
      rt2x00: no need to check return value of debugfs_create functions
      libertas: no need to check return value of debugfs_create functions
      mwifiex: no need to check return value of debugfs_create functions

Gustavo A. R. Silva (1):
      qtnfmac: use struct_size() in kzalloc()

Hans de Goede (2):
      brcmfmac: Add DMI nvram filename quirk for PoV TAB-P1006W-232 tablet
      brcmfmac: Use firmware_request_nowarn for the clm_blob

Hauke Mehrtens (1):
      mt76: Add missing include of linux/module.h

Hemantkumar Suthar (1):
      mwifiex: add support for sd8977 chipset

Ihab Zhaika (3):
      iwlwifi: correct one of the PCI struct names
      iwlwifi: add new cards for 22560, 9260 and killer series
      iwlwifi: update product name for 9260 and 9560

Ilan Peer (3):
      iwlwifi: mvm: Flush transmit queues on P2P Device ROC done
      iwlwifi: mvm: Set Tx rate and flags when there is not station
      iwlwifi: mvm: Do not set RTS/CTS protection for P2P Device MAC

Johannes Berg (16):
      iwlwifi: mvm: make NVM access actually fail on failures
      iwlwifi: fw api: remove unused/deprecated filter status
      iwlwifi: fw api: document WoWLAN patterns command
      iwlwifi: mvm: fix %16 to %016 print format
      iwlwifi: mvm: read IWL_RX_MPDU_PHY_SHORT_PREAMBLE only for CCK
      iwlwifi: pcie: align licensing to dual GPL/BSD
      iwlwifi: mvm: clean up LDBG config command usage
      iwlwifi: move iwl_enable_{rx,tx}_ampdu to iwl-modparams.h
      iwlwifi: mvm: fix A-MPDU reference assignment
      iwlwifi: remove TOF implementation
      iwlwifi: dvm: remove useless condition
      iwlwifi: pcie: use u32* argument to iwl_trans_get_fw_monitor_len()
      iwlwifi: mvm: add location APIs
      iwlwifi: mvm: implement CSI reporting
      iwlwifi: mvm: document monitor mode reorder buffer bypass
      iwlwifi: mvm: include configured sniffer AID in radiotap

Julia Lawall (1):
      cw1200: drop useless LIST_HEAD

Kalle Valo (3):
      Merge tag 'iwlwifi-next-for-kalle-2019-01-25' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2019-01-22' of https://github.com/nbd168/wi=
reless
      Merge tag 'iwlwifi-next-for-kalle-2019-01-29' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next

Kangjie Lu (2):
      brcmfmac: add a check for the status of usb_register
      libertas: add checks for the return value of sysfs_create_group

Liad Kaufman (5):
      iwlwifi: update hcmds documentation
      iwlwifi: mvm: make num_active_macs unsigned
      iwlwifi: tighten boundary checks
      iwlwifi: memcpy from dev_cmd and not dev_cmd->hdr
      iwlwifi: mvm: remove sta key on wep ap

Lo-Hsiang Lo (1):
      brcmfmac: fix system warning message during wowl suspend

Lorenzo Bianconi (18):
      mt76: dma: remove napi from mt76_dma_rx_fill signature
      mt76: usb: do not build the skb if reported len does not fit in buf_s=
ize
      mt76: fix typo in mt76x02_check_mac_err routine
      mt76: mac: run mt76x02_mac_work routine atomically
      mt76: usb: avoid queue/status spinlocks while passing tx status to ma=
c80211
      mt76x0: pci: fix ACS support
      mt76x2: add static qualifier to mt76x2_init_hardware
      mt76: dfs: run mt76x02_dfs_set_domain atomically
      mt76x2: init: set default value for MT_TX_LINK_CFG
      mt76: add energy detect CCA support to mt76x{0,2}e drivers
      mt76: mac: minor optimizations in mt76x02_mac_tx_rate_val
      mt76: dma: do not build skb if reported len does not fit in buf_size
      mt76: mmio: introduce mt76x02_check_tx_hang watchdog
      mt76: dma: avoid indirect call in mt76_dma_tx_queue_skb
      mt76: use proper name for __MT76x02_H macro
      mt76: add led support to mt76x0e driver
      mt76: do not report out-of-range rx nss
      mt7601u: do not use WARN_ON in the datapath

Luca Coelho (12):
      iwlwifi: add PCI IDs for the 22260 device series
      iwlwifi: pcie: recognize NICs with hw_rev 0x364 correctly
      iwlwifi: remove support for 9000 A-step devices
      iwlwifi: pcie: remove unnecessary iwl_pcie_enable_rx_wake() function
      iwlwifi: pcie: remove suspend/resume workaround for 9000A devices
      iwlwifi: mvm: fix values in the table example
      iwlwifi: mvm: save and export regdb blob from the NVM
      iwlwifi: make iwl_fw_dbg_start_stop_hcmd() inline
      iwlwifi: mvm: pre-initialize alive_data in wait_alive()
      iwlwifi: calculate pointers from out_cmd instead of out_cmd->hdr
      iwlwifi: make sure cur_fw_img is valid before accessing img
      iwlwifi: mvm: fix merge damage in iwl_mvm_rx_mpdu_mq()

Masahiro Yamada (1):
      wireless: prefix header search paths with $(srctree)/

Mordechay Goodstein (3):
      iwlwifi: mvm: avoid possible access out of array.
      iwlwifi: avoid access out of memory allocated
      iwlwifi: mvm: disable completely low latency mode with debugfs

Prameela Rani Garnepudi (1):
      rsi: add support for hardware scan offload

Rafa=C5=82 Mi=C5=82ecki (2):
      bcma: keep a direct pointer to the struct device
      bcma: use dev_* printing functions

Sara Sharon (7):
      iwlwifi: mvm: support mac80211 TXQs model
      iwlwifi: mvm: support mac80211 AMSDU
      iwlwifi: mvm: bring back mvm GSO code
      iwlwifi: pcie: fix the use of a wrong define
      iwlwifi: pcie: add prints to track virtual ID
      iwlwifi: mvm: add an option to dereference vif by id
      iwlwifi: mvm: get rid of tx_path_lock

Sergey Matyukevich (8):
      qtnfmac: fix INTx interrupt handling
      qtnfmac: add support for 4addr mode
      qtnfmac: switch to 32bit values for RTS/FRAG thresholds
      qtnfmac: do not reject retry changes in driver
      qtnfmac: convert to SPDX license identifiers
      qtnfmac: add missing bss record to host scan cache
      qtnfmac: remove unused declarations
      qtnfmac: qtnf_cmd_send_with_reply cleanup

Shahar S Matityahu (9):
      iwlwifi: wrt: add to dump number of lmacs, lmac1 and umac error id
      iwlwifi: wrt: add 22000 device familiy prph dump support
      iwlwifi: monitor dumping flow cleanup
      iwlwifi: trigger dump on assert prior to setting the device up
      iwlwifi: dbg_ini: allocate dram buffer with proper flags
      iwlwifi: dbg_ini: properly handle ini user trigger
      iwlwifi: dbg_ini: retrieve dump_delay value properly
      iwlwifi: dbg_ini: set dump mask BIT(n) instead of n
      iwiwifi: fix bad monitor buffer register addresses

Shaul Triebitz (4):
      iwlwifi: mvm: fix wrong DCM TLC config
      iwlwifi: iwlmvm: ignore HE PPDU type regarding EOF
      iwlwifi: iwlmvm: in monitor NDP notif take the NSS from rx_vec
      iwlwifi: mvm: update firmware when MU EDCA params change

Siva Rebbagondla (1):
      rsi: Suppress sdhci warnings in mmc

Stanislaw Gruszka (5):
      mt76x02: do not set protection on set_rts_threshold callback
      mt76x02: fixup MT_PROT_RATE_* defines
      mt76x02: set protection according to ht operation element
      mt76x0: configure MT_VHT_HT_FBK_CFG1
      mt7601u: bump supported EEPROM version

Tomislav Po=C5=BEega (1):
      rt2x00: reduce tx power to nominal level on RT6352

Wei Yongjun (1):
      cw1200: fix missing unlock on error in cw1200_hw_scan()

YueHaibing (3):
      brcmsmac: remove set but not used variables 'phybw40, maxtargetpwr'
      iwlwifi: use kmemdup in iwl_parse_nvm_mcc_info()
      wireless: remove unneeded semicolon

Zumeng Chen (1):
      wlcore: Fix memory leak in case wl12xx_fetch_firmware failure

 drivers/bcma/bcma_private.h                        |   9 +-
 drivers/bcma/driver_gpio.c                         |   2 +-
 drivers/bcma/host_pci.c                            |   2 +
 drivers/bcma/host_soc.c                            |   4 +-
 drivers/bcma/main.c                                |  45 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   2 +-
 drivers/net/wireless/ath/ath6kl/init.c             |   2 +-
 drivers/net/wireless/broadcom/b43/debugfs.c        |  36 +-
 drivers/net/wireless/broadcom/b43legacy/debugfs.c  |  35 +-
 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |  15 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |   5 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   6 +-
 .../wireless/broadcom/brcm80211/brcmsmac/Makefile  |   6 +-
 .../wireless/broadcom/brcm80211/brcmsmac/debug.c   |  26 +-
 .../wireless/broadcom/brcm80211/brcmsmac/debug.h   |   2 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |  13 +-
 .../wireless/broadcom/brcm80211/brcmutil/Makefile  |   4 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   5 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   5 +-
 drivers/net/wireless/intel/iwlegacy/common.h       |   6 +-
 drivers/net/wireless/intel/iwlegacy/debug.c        |  34 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  74 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      | 139 ++--
 drivers/net/wireless/intel/iwlwifi/dvm/Makefile    |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |  23 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c        |   5 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |  23 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |  10 +
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |  55 ++
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |  33 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   | 711 ++++++++++++++++++
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |  51 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  11 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h  |  15 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h   |  19 +-
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |  34 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tof.h    | 393 ----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 212 ++++--
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  22 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |  11 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |  12 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  17 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   1 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  27 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  41 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |  38 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |  18 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   8 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   | 813 ++---------------=
----
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  91 +--
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  | 200 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 249 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 203 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       | 116 +--
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |  26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 104 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 377 ++++------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   4 -
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |  33 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c       | 305 --------
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h       |  89 ---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 161 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  37 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 266 ++++---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  46 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  78 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  45 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  14 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  47 +-
 drivers/net/wireless/marvell/libertas/debugfs.c    |   6 -
 drivers/net/wireless/marvell/libertas/mesh.c       |   5 +
 drivers/net/wireless/marvell/libertas_tf/main.c    |   2 +-
 drivers/net/wireless/marvell/mwifiex/Kconfig       |   2 +-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |   5 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   5 +
 drivers/net/wireless/marvell/mwifiex/sdio.h        |  70 ++
 drivers/net/wireless/mediatek/mt76/dma.c           |  31 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  68 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  23 +-
 .../net/wireless/mediatek/mt76/mt76x0/initvals.h   |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  11 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |   6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb_mcu.c    |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |  22 +-
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |   6 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 222 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  12 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  | 142 +++-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |  47 --
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h   |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |  38 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  89 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.h    |  23 -
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |   1 -
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |  58 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |   4 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_phy.c    |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_mcu.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  17 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  20 +-
 drivers/net/wireless/mediatek/mt76/util.c          |  42 ++
 drivers/net/wireless/mediatek/mt7601u/dma.c        |   6 +-
 drivers/net/wireless/mediatek/mt7601u/eeprom.h     |   2 +-
 drivers/net/wireless/quantenna/Makefile            |   1 +
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |  19 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |  43 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.h  |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |  63 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |  22 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  21 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/debug.c     |  31 +-
 drivers/net/wireless/quantenna/qtnfmac/debug.h     |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  96 ++-
 drivers/net/wireless/quantenna/qtnfmac/event.h     |  17 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |   6 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |  27 +-
 .../net/wireless/quantenna/qtnfmac/qlink_util.c    |  16 +-
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |  28 +-
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c   |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h   |  17 +-
 .../net/wireless/quantenna/qtnfmac/shm_ipc_defs.h  |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/trans.c     |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/trans.h     |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/util.c      |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/util.h      |  17 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c   |  27 -
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |  93 +--
 drivers/net/wireless/ray_cs.c                      |   4 +-
 .../net/wireless/realtek/rtl818x/rtl8180/Makefile  |   2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   2 +-
 .../net/wireless/realtek/rtl818x/rtl8187/Makefile  |   2 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |   4 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |   2 +
 drivers/net/wireless/realtek/rtlwifi/debug.c       |  14 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    |  95 ++-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |   8 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |   6 +-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c         |   5 -
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   3 +
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |  67 ++
 drivers/net/wireless/rsi/rsi_91x_main.c            |   1 +
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            | 133 ++++
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |  15 +-
 drivers/net/wireless/rsi/rsi_main.h                |  22 +
 drivers/net/wireless/rsi/rsi_mgmt.h                |  35 +
 drivers/net/wireless/st/cw1200/debug.c             |  26 +-
 drivers/net/wireless/st/cw1200/fwio.c              |   4 +-
 drivers/net/wireless/st/cw1200/queue.c             |   1 -
 drivers/net/wireless/st/cw1200/scan.c              |   5 +-
 drivers/net/wireless/ti/wl1251/debugfs.c           |  59 +-
 drivers/net/wireless/ti/wl12xx/debugfs.c           |  20 +-
 drivers/net/wireless/ti/wl18xx/debugfs.c           |  20 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |   2 +-
 drivers/net/wireless/ti/wlcore/debugfs.c           |  28 +-
 drivers/net/wireless/ti/wlcore/debugfs.h           |  10 +-
 drivers/net/wireless/ti/wlcore/main.c              |   7 +-
 include/linux/bcma/bcma.h                          |  11 +-
 183 files changed, 4083 insertions(+), 3927 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/location.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/tof.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/tof.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/tof.h
