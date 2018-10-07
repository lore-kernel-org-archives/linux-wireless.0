Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8804C65C31
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 07:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A6512088F
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 07:37:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lOF8vCZl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KlBFstUa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A6512088F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbeJGOnj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 10:43:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40716 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbeJGOni (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 10:43:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4FFE360866; Sun,  7 Oct 2018 07:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538897833;
        bh=J6VXxLVvwE8kGpPzP5e11h9pBCM76ixo3ZY7KjN+XLE=;
        h=From:To:Cc:Subject:Date:From;
        b=lOF8vCZlOJc/XVK1ArYTzEB+51kcQ9khF+dB2+U7O4Gne+d1OINePYxJs0v2Pw8KA
         ssx7IUgcY0RCbG01f47c7iBZMQ2LgtPXdqO0hdA8jvTrLboBFhOLv/YyDZVKnI5WQ0
         SlNTei01qGtsj3z34cnTrGEGHZLxl0lanq73v/1s=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BAF5C6076A;
        Sun,  7 Oct 2018 07:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538897831;
        bh=J6VXxLVvwE8kGpPzP5e11h9pBCM76ixo3ZY7KjN+XLE=;
        h=From:To:Cc:Subject:Date:From;
        b=KlBFstUa+MNds+XRyf2AmkByt12nZLUysLY1kz0hWHCp1QV0+eVy8STQiWtAs+7i9
         e7X42urLVXc+U8YiSHfha/nfMp5VAdtqKl/Frt7lt7o5euQ2lD88bECpK2JN1YQao/
         z53itilhBZx6a1xL1uP3e6X9oWYaJ3IFMCTQ3p58=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BAF5C6076A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-10-07
Date:   Sun, 07 Oct 2018 10:37:06 +0300
Message-ID: <87murqdx7h.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

another pull request to net-next for 4.20. I'm sending this a bit
earlier than I prefer as I'm not sure if the merge window starts today
or not. Not all of these patches have been in linux-next, and also the
kbuild bot has been offline this week due to a service break, so there
might be some build problems which I have missed. Though a local
allmodconfig build with GCC 7.3.0 did work without problems.

Kalle

The following changes since commit 4e6d47206c32d1bbb4931f1d851dae3870e0df81:

  tls: Add support for inplace records encryption (2018-10-02 23:03:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2018-10-07

for you to fetch changes up to 5580d810560da33804053ae3bca13110c9a8d5e8:

  Merge tag 'mt76-for-kvalo-2018-10-05' of https://github.com/nbd168/wireless (2018-10-06 14:22:47 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 4.20

Second set of patches for 4.20. Heavy refactoring on mt76 continues
and the usual drivers in active development (iwlwifi, qtnfmac, ath10k)
getting new features. And as always, fixes and cleanup all over.

Major changes:

mt76

* more major refactoring to make it easier add new hardware support

* more work on mt76x0e support

* support for getting firmware version via ethtool

* add mt7650 PCI ID

iwlwifi

* HE radiotap cleanup and improvements

* reorder channel optimization for scans

* bump the FW API version

qtnfmac

* fixes for 'iw' output: rates for enabled SGI, 'dump station'

* expose more scan features to host: scan flush and dwell time

* inform cfg80211 when OBSS is not supported by firmware

wlcore

* add support for optional wakeirq

ath10k

* retrieve MAC address from system firmware if provided

* support extended board data download for dual-band QCA9984

* extended per sta tx statistics support via debugfs

* average ack rssi support for data frames

* speed up QCA6174 and QCA9377 firmware download using diag Copy
  Engine

* HTT High Latency mode support needed by SDIO and USB support

* get STA power save state via debugfs

ath9k

* add reset functionality for airtime station debugfs file

----------------------------------------------------------------
Anilkumar Kolli (4):
      ath10k: get the legacy rate index to update the txrate table
      ath10k: add debugfs entry to enable extended tx stats
      ath10k: add extended per sta tx statistics support
      ath10k: add debugfs support to dump per sta tx stats

Ayala Beker (1):
      iwlwifi: mvm: allow channel reorder optimization during scan

Balaji Pothunoori (1):
      ath10k: average ack rssi support for data frames

Ben Greear (1):
      ath10k: fix vdev-start timeout on error

Brian Norris (3):
      ath10k: retrieve MAC address from system firmware if provided
      ath10k: utilize random MAC address if none is provided
      ath10k: add missing sanity check on diag download

Carl Huang (3):
      ath10k: optimize pci diag mem read & write operations
      ath10k: support to access target space below 1M for qca6174 and qca9377
      ath10k: download firmware via diag Copy Engine for QCA6174 and QCA9377.

Chung-Hsien Hsu (2):
      brcmfmac: reduce timeout for action frame scan
      brcmfmac: fix full timeout waiting for action frame on-channel tx

Colin Ian King (1):
      mt76: fix header guard macro define names

Davide Caratti (1):
      mt76: report firmware version using ethtool

Emmanuel Grumbach (1):
      iwlwifi: mvm: clear HW_RESTART_REQUESTED when stopping the interface

Erik Stromdahl (14):
      ath10k: add struct ath10k_bus_params
      ath10k: add device type enum to ath10k_bus_params
      ath10k: add bus type check in ath10k_init_hw_params
      ath10k: use hw_params.num_peers for num_tids in TLV init
      ath10k: add per target config of max_num_peers
      ath10k: DMA related fixes for high latency devices
      ath10k: add HTT TX HL ops
      ath10k: add HTT RX HL ops
      ath10k: htt: RX ring config HL support
      ath10k: htt: High latency TX support
      ath10k: htt: High latency RX support
      ath10k: wmi: disable softirq's while calling ieee80211_rx
      ath10k: add default value for num_peers in WMI TLV init
      ath10k: remove num_peers in hw_params for most targets

Felix Fietkau (7):
      mt76: add stbc entries to mt76_rate_power
      mt76: include linux/module.h in files using MODULE_*
      mt76x2: disable WLAN core before probe
      mt76: fix handling ps-poll frames
      mt76: check aggregation sequence number for frames sent via drv_tx
      mt76: mt76x2: fix multi-interface beacon configuration
      ath9k: add back support for using active monitor interfaces for tx99

Govind Singh (4):
      ath10k: introduce CE_ATTR_POLL attribute for polling pipe
      ath10k: enable pktlog for WCN3990 target
      ath10k: move napi_enable to hif_start for consistent pairing
      ath10k: disable napi before resource cleanup to avoid "use after free"

Gustavo A. R. Silva (2):
      wil6210: fix unsigned cid comparison with >= 0
      ssb: chipcommon: fix fall-through annotation

Haim Dreyfuss (1):
      iwlwifi: mvm Support new MCC update response

Hauke Mehrtens (1):
      mt76: use skb_pad() instead of __skb_pad()

Igor Mitsyanko (4):
      qtnfmac: generate local disconnect event in disconnect callback
      qtnfmac: request userspace to do OBSS scanning if FW can not
      qtnfmac: do not initialize per-MAC data multiple times
      qtnfmac: do not cancel scan in disconnect callback

Johannes Berg (16):
      iwlwifi: mvm: remove unnecessary overload variable
      iwlwifi: mvm: minor cleanups to HE radiotap code
      iwlwifi: mvm: put HE SIG-B symbols/users data correctly
      iwlwifi: mvm: pull some he_phy_data decoding into a separate function
      iwlwifi: mvm: clean up HE radiotap RU allocation parsing
      iwlwifi: mvm: move HE-MU LTF_NUM parsing to he_phy_data parsing
      iwlwifi: mvm: add TXOP to HE radiotap data
      iwlwifi: mvm: add LDPC-XSYM to HE radiotap data
      iwlwifi: mvm: add more information to HE radiotap
      iwlwifi: mvm: set max TX/RX A-MPDU subframes to HE limit
      iwlwifi: pcie gen2: check iwl_pcie_gen2_set_tb() return value
      iwlwifi: add fall through comment
      iwlwifi: pcie: check iwl_pcie_txq_build_tfd() return value
      iwlwifi: bump firmware API version for 9000 and 22000 series devices
      iwlwifi: mvm: decode HE information for MU (without ext info)
      iwlwifi: mvm: show more HE radiotap data for TB PPDUs

K.T.VIJAYAKUMAAR (1):
      ath10k: avoid possible memory access violation

Kalle Valo (4):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2018-10-01' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2018-10-06' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2018-10-05' of https://github.com/nbd168/wireless

Lance Roy (1):
      zd1211rw: Replace spin_is_locked() with lockdep

Lorenzo Bianconi (84):
      mt76x2: fix tx power configuration for VHT mcs 9
      mt76x0: pci: add mt7650 PCI ID
      mt76x0: pci: add fw uploading routine
      mt76: move seq_put_array in mt76-core module
      mt76: move common eeprom definitions in mt76x02-lib module
      mt76: move eeprom utility routines in mt76x02_eeprom.h
      mt76: move mt76x2_eeprom_get in mt76x02_eeprom.h
      mt76: move mt76x02_mac_setaddr in mt76x02-lib module
      mt76: move mt76x2_get_efuse_data in mt76x02-lib module
      mt76: move mt76x2_ext_pa_enabled routine in mt76x02_eeprom.c
      mt76x0: remove mt76x0_set_country_reg routine
      mt76: add mt76x02_get_rx_gain and mt76x02_get_lna_gain utility routines
      mt76x0: unify lna_gain parsing
      mt76x0: unify rssi_offset parsing
      mt76x0: unify temperature offset parsing
      mt76x0: unify freq offset parsing
      mt76: move mt76x02_eeprom_parse_hw_cap in mt76x02-lib module
      mt76x0: unify parse hw capabilities
      mt76: move mt76x2_tssi_enabled in mt76x02_eeprom.h
      mt76: usb: remove WARN_ON in mt76u_get_rx_entry_len
      mt76: move mt76_rate_power in mt76_dev
      mt76: add mt76x02_phy_set_txpower utility routine
      mt76: move rate_txpower handler in mt76 debugfs
      mt76: move mt76x02_rate_power_val in mt76x02-lib module
      mt76x0: remove mt76x0_phy_set_tx_power and mt76x0_extra_power_over_mac
      mt76x0: remove eeprom dependency from mt76x0_set_tx_power_per_rate
      mt76x0: remove eeprom dependency from mt76x0_get_power_info
      mt76x0: use shared debugfs implementation
      mt76x0: phy: introduce mt76x0_phy_set_txpower routine
      mt76: usb: make rx page_frag_cache access atomic
      mt76x0: use mt76_poll in mt76x0_set_wlan_state
      mt76: move wait_for_wpdma in mt76x02_dma.h
      mt76: add mt76x02_dma_enable/mt76x02_dma_disable utility routines
      mt76: move mt76x02_set_irq_mask in mt76x02_mmio.c
      mt76: move queue initialization in mt76x02_mmio.c
      mt76: move mt76x02_beacon_offset in mt76x02_util.c
      mt76: mmio: add implementation of wr_rp and rd_rp
      mt76: move mt76x2_wait_for_bbp in mt76x02-lib module
      mt76x0: update initvals to latest version of vendor driver
      mt76x0: pci: move mcu code in pci_mcu.c
      mt76x0: usb: move mcu code in usb_mcu.c
      mt76x0: use mt76x02 utility routines in mt76x0 init code
      mt76x0: init: remove duplicated initialization
      mt76x0: init: remove MT_PBF_SYS_CTRL configuration in mt76x0_reset_csr_bbp
      mt76x0: init rx filter in mt76x0_init_hardware
      mt76: add mt76x02_mac_start routine
      mt76x0: usb: move initialization code in usb.c
      mt76x0: pci: add hw initialization at bootstrap
      mt76x0: phy: set antenna parameter according to wireless band
      mt76: move set_{tx,rx}_path routines in mt76x02-lib module
      mt76x0: add ieee80211_ops ops pointer to mt76x0_alloc_device signature
      mt76x0: pci: add mt76x0e_{start/stop} callbacks
      mt76x0: eeprom: load eeprom data from mtd by default
      mt76x0: usb: move mt76x0u_tx_prepare_skb in usb.c
      mt76x0: pci: add mt76x0e_cleanup routine
      mt76x2: move mt76x2 source files to mt76x2 folder
      mt76: usb: fix hw initialization sequence
      mt76x0: usb: stop cal/mac workqueues at hw stop
      mt76: move mt76x02_tx_get_max_txpwr_adj in mt76x02_util.c
      mt76: add get_tx_txpwr_adj function pointer to mt76_driver_ops
      mt76: move mt76x02_mac_write_txwi in mt76x02-lib module
      mt76: usb: use mt76x02u_tx_prepare_skb to fill txwi
      mt76x0: init: remove unnecessary configurations
      mt76: move mt76x02_phy_get_min_avg_rssi in mt76x02_phy.c
      mt76: move mt76x02_rx_get_sta and mt76x02_rx_get_sta_wcid in mt76x02_util.h
      mt76x0: mac: use sta ewma estimation for rssi tracking
      mt76x0: remove unused variable in mt76x0_dev
      mt76x0: remove hw_atomic_mutex mutex in mt76x0_dev
      mt76x2: move mt76x2_dev in mt76x02_util.h
      mt76x0: merge mt76x0_dev in mt76x02_dev
      mt76: move mt76x02_mac_process_rx in mt76x02-lib module
      mt76: unify rxwi parsing between mt76x2 and mt76x0 drivers
      mt76: move mt76x02_tx in mt76x02-lib module
      mt76: move txrx shared routines in mt76x02_txrx.c
      mt76: rename mt76x02_util.h in mt76x02.h
      mt76x2: remove leftover function declatarions
      mt76: move tpc routines in mt76x02-lib module
      mt76: move mt76x02_tx_prepare_skb in mt76x02_txrx.c
      mt76: usb: move mt76x02u_tx_complete_skb in mt76x02_usb_core.c
      mt76: move mt76x02_mac_poll_tx_status in mt76x02-lib moudle
      mt76: move mt76x02_tx_complete in mt76x02-lib module
      mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mmio.c
      mt76: move tx_tasklet management in mt76x02-lib moudle
      mt76: move irq handler in mt76x02-lib moudle

Louie Lu (1):
      ath9k: add reset for airtime station debugfs

Luca Coelho (1):
      iwlwifi: mvm: check for n_profiles validity in EWRD ACPI

Maharaja Kennadyrajan (2):
      ath10k: add debugfs support to get power save state change of STA
      ath10k: advertize beacon_int_min_gcd as 100 while bring up multi vaps

Naftali Goldstein (1):
      iwlwifi: nvm: get num of hw addresses from firmware

Niklas Cassel (1):
      ath10k: allow ATH10K_SNOC with COMPILE_TEST

Ping-Ke Shih (1):
      rtlwifi: Removed unused define and code efuse_re_pg* from wifi.h

Rakesh Pillai (1):
      ath10k: fix tx status flag setting for management frames

Rob Herring (1):
      ath6kl: convert to using %pOFn instead of device_node.name

Sara Sharon (8):
      iwlwifi: dbg: move debug data to a struct
      iwlwifi: dbg: refactor dump code to improve readability
      iwlwifi: dbg: split iwl_fw_error_dump to two functions
      iwlwifi: dbg: dump memory in a helper function
      iwlwifi: dbg: group trigger condition to helper function
      iwlwifi: dbg: make iwl_fw_dbg_no_trig_window trigger agnostic
      iwlwifi: dbg: decrement occurrences for all triggers
      iwlwifi: dbg: make trigger functions type agnostic

Sathishkumar Muruganandam (2):
      ath10k: refactoring needed for extended board data download
      ath10k: support extended board data download for dual-band QCA9984

Sergey Matyukevich (9):
      qtnfmac: do not track STA states in driver
      qtnfmac: cleanup and unify command error handling
      qtnfmac: pass sgi rate info flag to wireless core
      qtnfmac: inform wireless core about supported extended capabilities
      qtnfmac: drop error reports for out-of-bounds key indexes
      qtnfmac: add support for scan flush
      qtnfmac: add support for scan dwell time configuration
      qtnfmac: drop redundant data copy in control path
      qtnfmac: implement dump_station support for STA mode

Shahar S Matityahu (3):
      iwlwifi: add dump collection in case alive flow fails
      iwlwifi: runtime: add send host command op to firmware runtime op struct
      iwlwifi: add debugfs to send host command

Shaul Triebitz (1):
      iwlwifi: pcie: avoid empty free RB queue

Simon Wunderlich (5):
      ath9k: add counters for good and errorneous FFT/spectral frames
      ath9k: return when short FFT frame was handled
      ath9k: fix and simplify FFT max index retrieval
      ath9k: FFT magnitude check: don't consider lower 3 data bits
      ath9k: fix reporting calculated new FFT upper max

Sriram R (1):
      ath10k: add support for configuring management packet rate

Stanislaw Gruszka (3):
      mt76: fix return value of mt76x02_wait_for_mac
      mt76x0: add quirk to disable 2.4GHz band for Archer T1U
      mt76: fix frag length allocation for usb

Tony Lindgren (2):
      wlcore: Fix BUG with clear completion on timeout
      wlcore: Add support for optional wakeirq

Wen Gong (1):
      ath10k: add waiting htt tx complete before wow enable

Yisheng Xie (1):
      iwlwifi: mvm: use match_string() helper

YueHaibing (4):
      ath10k: remove duplicated includes
      ath9k: debug: remove set but not used variable 'fops_dump_nfcal'
      wil6210: remove set but not used variable 'start'
      b43: remove set but not used variable 'wl'

 drivers/net/wireless/ath/ath10k/Kconfig            |   3 +-
 drivers/net/wireless/ath/ath10k/ahb.c              |   9 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |  23 +
 drivers/net/wireless/ath/ath10k/bmi.h              |  36 +
 drivers/net/wireless/ath/ath10k/ce.c               |  18 +-
 drivers/net/wireless/ath/ath10k/ce.h               |  11 +-
 drivers/net/wireless/ath/ath10k/core.c             | 737 +++++++++++++--------
 drivers/net/wireless/ath/ath10k/core.h             |  64 +-
 drivers/net/wireless/ath/ath10k/debug.c            | 144 +++-
 drivers/net/wireless/ath/ath10k/debug.h            |   9 +
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      | 130 ++++
 drivers/net/wireless/ath/ath10k/htc.c              |  82 ++-
 drivers/net/wireless/ath/ath10k/htt.h              |  52 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           | 296 ++++++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c           | 155 ++++-
 drivers/net/wireless/ath/ath10k/hw.c               | 191 ++++++
 drivers/net/wireless/ath/ath10k/hw.h               |  32 +
 drivers/net/wireless/ath/ath10k/mac.c              | 114 +++-
 drivers/net/wireless/ath/ath10k/mac.h              |   1 +
 drivers/net/wireless/ath/ath10k/pci.c              |  76 ++-
 drivers/net/wireless/ath/ath10k/pci.h              |   3 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |  15 +
 drivers/net/wireless/ath/ath10k/sdio.c             |   8 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |  22 +-
 drivers/net/wireless/ath/ath10k/targaddrs.h        |   4 +
 drivers/net/wireless/ath/ath10k/txrx.c             |   3 +-
 drivers/net/wireless/ath/ath10k/usb.c              |   7 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |  11 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |  78 ++-
 drivers/net/wireless/ath/ath10k/wmi.h              |  43 +-
 drivers/net/wireless/ath/ath10k/wow.c              |   2 +
 drivers/net/wireless/ath/ath6kl/init.c             |   4 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   1 +
 drivers/net/wireless/ath/ath9k/common-debug.c      |   2 +
 drivers/net/wireless/ath/ath9k/common-debug.h      |   4 +
 drivers/net/wireless/ath/ath9k/common-spectral.c   |  83 +--
 drivers/net/wireless/ath/ath9k/common-spectral.h   |  17 +
 drivers/net/wireless/ath/ath9k/debug.c             |  13 -
 drivers/net/wireless/ath/ath9k/debug_sta.c         |  18 +-
 drivers/net/wireless/ath/ath9k/main.c              |  10 +-
 drivers/net/wireless/ath/ath9k/tx99.c              |   7 +
 drivers/net/wireless/ath/ath9k/xmit.c              |   2 +-
 drivers/net/wireless/ath/wil6210/pm.c              |   3 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |   2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   2 +-
 drivers/net/wireless/broadcom/b43/main.c           |   2 -
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |  26 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |   2 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   2 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |  81 +--
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   5 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 411 ++++++------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |  45 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |  64 ++
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   7 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |  41 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   2 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  77 ++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  10 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  42 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  39 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      | 373 ++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   3 +
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  16 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  32 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   2 +
 drivers/net/wireless/mediatek/mt76/Kconfig         |  43 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |  27 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |  31 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   6 +
 drivers/net/wireless/mediatek/mt76/mmio.c          |  27 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |  37 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig  |  20 +
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile |   6 +-
 .../net/wireless/mediatek/mt76/mt76x0/debugfs.c    |  85 +--
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 568 +++++++---------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h | 132 +---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   | 237 ++-----
 .../net/wireless/mediatek/mt76/mt76x0/initvals.h   | 406 +++++-------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    |  82 +--
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |  20 -
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 117 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h    |   9 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 157 +----
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    | 127 +++-
 .../net/wireless/mediatek/mt76/mt76x0/pci_mcu.c    | 146 ++++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 274 +++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     | 115 ----
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 308 ++++-----
 .../net/wireless/mediatek/mt76/mt76x0/usb_mcu.c    | 176 +++++
 drivers/net/wireless/mediatek/mt76/mt76x02.h       | 208 ++++++
 .../mediatek/mt76/{mt76x2_dfs.h => mt76x02_dfs.h}  |  40 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h   |  17 +
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.c    | 156 +++++
 .../mt76/{mt76x2_eeprom.h => mt76x02_eeprom.h}     | 147 ++--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 257 ++++++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  35 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |  13 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  | 260 ++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   | 183 +++++
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h   |  30 +
 .../mt76/{mt76x2_trace.c => mt76x02_trace.c}       |   2 +-
 .../mt76/{mt76x2_trace.h => mt76x02_trace.h}       |  31 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  | 203 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h   |   9 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |  59 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  80 +--
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  54 --
 drivers/net/wireless/mediatek/mt76/mt76x2.h        | 250 -------
 drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig  |  20 +
 drivers/net/wireless/mediatek/mt76/mt76x2/Makefile |  16 +
 .../mt76/{mt76x2_debugfs.c => mt76x2/debugfs.c}    |  35 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h    |  26 +
 .../mt76/{mt76x2_eeprom.c => mt76x2/eeprom.c}      | 356 ++++------
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h |  73 ++
 .../mt76/{mt76x2_init_common.c => mt76x2/init.c}   |  36 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mac.c    |  54 ++
 .../mt76/{mt76x2_common.c => mt76x2/mac.h}         |  37 +-
 .../mt76/{mt76x2_mcu_common.c => mt76x2/mcu.c}     |  20 +-
 .../mediatek/mt76/{mt76x2_mcu.h => mt76x2/mcu.h}   |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h | 107 +++
 .../wireless/mediatek/mt76/{ => mt76x2}/mt76x2u.h  |  44 +-
 .../mediatek/mt76/{mt76x2_pci.c => mt76x2/pci.c}   |   8 +-
 .../mt76/{mt76x2_dfs.c => mt76x2/pci_dfs.c}        | 145 ++--
 .../mt76/{mt76x2_init.c => mt76x2/pci_init.c}      | 141 +---
 .../mt76/{mt76x2_mac.c => mt76x2/pci_mac.c}        | 108 +--
 .../mt76/{mt76x2_main.c => mt76x2/pci_main.c}      |  39 +-
 .../mt76/{mt76x2_mcu.c => mt76x2/pci_mcu.c}        |  14 +-
 .../mt76/{mt76x2_phy.c => mt76x2/pci_phy.c}        |  43 +-
 .../mediatek/mt76/{mt76x2_tx.c => mt76x2/pci_tx.c} |  43 +-
 .../mt76/{mt76x2_phy_common.c => mt76x2/phy.c}     | 145 +---
 .../mediatek/mt76/{mt76x2_usb.c => mt76x2/usb.c}   |  10 +-
 .../mt76/{mt76x2u_init.c => mt76x2/usb_init.c}     |  63 +-
 .../mt76/{mt76x2u_mac.c => mt76x2/usb_mac.c}       |  40 +-
 .../mt76/{mt76x2u_main.c => mt76x2/usb_main.c}     |  25 +-
 .../mt76/{mt76x2u_mcu.c => mt76x2/usb_mcu.c}       |  21 +-
 .../mt76/{mt76x2u_phy.c => mt76x2/usb_phy.c}       |  54 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_core.c   |  88 ---
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    | 124 ----
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  64 --
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 239 -------
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  | 118 ----
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |  53 --
 drivers/net/wireless/mediatek/mt76/tx.c            |  36 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  17 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 193 +++---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 535 ++++-----------
 drivers/net/wireless/quantenna/qtnfmac/core.c      |  39 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |   8 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  18 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |   5 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |   5 +
 .../net/wireless/quantenna/qtnfmac/qlink_util.h    |   8 +
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.c   |  13 +-
 drivers/net/wireless/quantenna/qtnfmac/shm_ipc.h   |   4 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   4 -
 drivers/net/wireless/ti/wlcore/main.c              |  48 +-
 drivers/net/wireless/ti/wlcore/sdio.c              |  17 +-
 drivers/net/wireless/ti/wlcore/wlcore.h            |   2 +
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   2 +-
 drivers/ssb/driver_chipcommon.c                    |   2 +-
 177 files changed, 6916 insertions(+), 5633 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02.h
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dfs.h => mt76x02_dfs.h} (76%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_eeprom.c
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_eeprom.h => mt76x02_eeprom.h} (56%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_trace.c => mt76x02_trace.c} (97%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_trace.h => mt76x02_trace.h} (86%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_util.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_debugfs.c => mt76x2/debugfs.c} (78%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/dfs.h
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_eeprom.c => mt76x2/eeprom.c} (52%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_init_common.c => mt76x2/init.c} (89%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/mac.c
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_common.c => mt76x2/mac.h} (56%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mcu_common.c => mt76x2/mcu.c} (84%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mcu.h => mt76x2/mcu.h} (87%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
 rename drivers/net/wireless/mediatek/mt76/{ => mt76x2}/mt76x2u.h (51%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_pci.c => mt76x2/pci.c} (92%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dfs.c => mt76x2/pci_dfs.c} (84%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_init.c => mt76x2/pci_init.c} (78%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mac.c => mt76x2/pci_mac.c} (63%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_main.c => mt76x2/pci_main.c} (89%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_mcu.c => mt76x2/pci_mcu.c} (94%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_phy.c => mt76x2/pci_phy.c} (91%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_tx.c => mt76x2/pci_tx.c} (75%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_phy_common.c => mt76x2/phy.c} (66%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_usb.c => mt76x2/usb.c} (95%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_init.c => mt76x2/usb_init.c} (83%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_mac.c => mt76x2/usb_mac.c} (83%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_main.c => mt76x2/usb_main.c} (90%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_mcu.c => mt76x2/usb_mcu.c} (92%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2u_phy.c => mt76x2/usb_phy.c} (86%)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_core.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
