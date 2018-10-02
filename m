Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5291CC43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 17:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E65342064A
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 17:06:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dKwx8H/j";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O3UEALL0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E65342064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbeJBXvC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 19:51:02 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbeJBXvB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 19:51:01 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2D0A560C4F; Tue,  2 Oct 2018 17:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538499998;
        bh=fmeCrpVSoaUflnciOmlRDNaL5Ik8UhTpMaIp4of9gCQ=;
        h=From:To:Cc:Subject:Date:From;
        b=dKwx8H/jiWskSoE6z03z5qIsiJzfxMTEOioybR2WhzvS/2ltJdkm1zRiYEjfiOVeY
         HbWWgGvEhjJ48MS8wUUX6dfdXE3PTorvk4WqWgAKGGdO/xBiIsqDyAb/JF7+BJci1V
         ErR26lpenpawVRSBfHgmdnx3EIMSQcxp0v21baNY=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CE8F060C1D;
        Tue,  2 Oct 2018 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538499996;
        bh=fmeCrpVSoaUflnciOmlRDNaL5Ik8UhTpMaIp4of9gCQ=;
        h=From:To:Cc:Subject:Date:From;
        b=O3UEALL0NZEuI+SepbfmO7i3MQy1vxJ8BaeWS0npgefcZVZwTLgbfftRF9YBJOVF/
         q+22HdgdS2SUPwYypxxTI7ZVQNewkzj8cMg/o1kqF1RqEx/RqPNc+rgTkoXnhupQo3
         cD3mHGgc5n+eMsVLBpjaS2smiukkr0uwUGpaZyUY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CE8F060C1D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2018-10-02
Date:   Tue, 02 Oct 2018 20:06:30 +0300
Message-ID: <87ftxojn1l.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's the first pull request to net-next for 4.20. This is rather large
due to mt76 refactoring and me not being able to send the pull request
earlier, sorry about that.

Most of this has been in linux-next for some time now so I'm hoping
there should not be any nasty surprises, but please let me know if you
have any problems.

Kalle

The following changes since commit 050cdc6c9501abcd64720b8cc3e7941efee9547d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2018-08-27 11:59:39 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2018-10-02

for you to fetch changes up to 08b0109eea36d71f87b863045d91bbcee98758bd:

  Merge tag 'iwlwifi-next-for-kalle-2018-09-28' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2018-10-01 18:49:48 +0300)

----------------------------------------------------------------
wireless-drivers-next patches for 4.20

First set of new features for 4.20. mt76 driver is going through major
refactoring and that's why there are so many mt76 patches. iwlwifi is
also under heavy development and smaller changes to other drivers.

Also wireless-drivers was merged to fix a conflict between the two trees.

Major changes:

ath10k

* limit available channels via DT ieee80211-freq-limit

wil6210

* add 802.11r Fast Roaming support for AP and station modes

* add support for channel 4

iwlwifi

* new FW API handling

* some improvements in the PCI recovery mechanism

* enable a new scanning feature;

* continued work on HE (mostly radiotap)

* TKIP implementation in new devices

* work continues for new 22560 hardware

mt76

* add support for Alfa AWUS036ACM

* lots of refactoring to make it easier to add new hardware support

* prepare for adding mt76x0e (pci-e variant) support

* add CONFIG_MT76x0E kconfig symbol

brcmfmac

* add support CYW89342 mini-PCIe device

* add 4-way handshake offload detection for FT-802.1X

* enable NL80211_EXT_FEATURE_CQM_RSSI_LIST

* fix for proper support of 160MHz bandwidth

rtl8xxxu

* add rtl8188ctv support

----------------------------------------------------------------
Ahmad Masri (1):
      wil6210: add FT roam support for AP and station

Aleksei Mamlin (1):
      rtl8xxxu: Add rtl8188ctv support

Alexei Avshalom Lazar (1):
      wil6210: add support for channel 4

Arend van Spriel (2):
      brcmfmac: fix for proper support of 160MHz bandwidth
      brcmfmac: increase buffer for obtaining firmware capabilities

Avraham Stern (3):
      iwlwifi: set the tid for non-QOS frames to zero
      iwlwifi: mvm: Send LQ command as async when necessary
      iwlwifi: mvm: set wep key for all stations in soft ap mode

Ayala Beker (2):
      iwlwifi: mvm: skip EBS in low latency mode while fragmented scan isn't supported
      iwlwifi: mvm: activate fragmented EBS in case of fragmented scan

Chung-Hsien Hsu (2):
      brcmfmac: add FT-based AKMs in brcmf_set_key_mgmt() for FT support
      brcmfmac: add 4-way handshake offload detection for FT-802.1X

Colin Ian King (3):
      ath9k: remove unused array firstep_table
      orinoco: remove unused array encaps_hdr and macro ENCAPS_OVERHEAD
      b43: fix spelling mistake "hw_registred" -> "hw_registered"

Dan Carpenter (2):
      libertas_tf: prevent underflow in process_cmdrequest()
      rt2x00: use simple_read_from_buffer()

David Spinadel (1):
      iwlwifi: mvm: Support TKIP on gen2 data path

Dedy Lansky (2):
      wil6210: drop Rx multicast packets that are looped-back to STA
      wil6210: fix invalid memory access for rx_buff_mgmt debugfs

Dreyfuss, Haim (1):
      iwlwifi: mvm: cleanup dead code on resume flow for non unified image.

Emmanuel Grumbach (5):
      iwlwifi: improve the flow when a NIC is disconnected
      iwlwifi: mvm: send BCAST management frames to the right station
      iwlwifi: mvm: fix a comment about the SP length
      iwlwifi: dbg: don't crash if the firmware crashes in the middle of a debug dump
      iwlwifi: mvm: remove support for adjacent channel compensation

Erel Geron (3):
      iwlwifi: mvm: support Coex Schema 2
      iwlwifi: fix non_shared_ant for 22000 devices
      iwlwifi: mvm: TLC support for Coex Schema 2

Felix Fietkau (2):
      ath9k: fix tx99 with monitor mode interface
      mt76: use a per rx queue page fragment cache

Ganapathi Bhat (2):
      mwifiex: do no submit URB in suspended state
      mwifex: free rx_cmd skb in suspended state

Geert Uytterhoeven (1):
      mt76: Fix comparisons with invalid hardware key index

Golan Ben Ami (9):
      iwlwifi: add required include to iwl-fh.h
      iwlwifi: pcie: allow using tx init for other queues but the command queue
      iwlwifi: pcie: make non-static hcmd and rx code
      iwlwifi: remove FSF's address from the license notice
      iwlwifi: pcie: store the default rxq number
      iwlwifi: pcie: make gen2 of apm_init non-static
      iwlwifi: refactor txq_alloc for supporting more command type
      iwlwifi: pcie: fit reclaim msg to MAX_MSG_LEN
      iwlwifi: configure power scheme to balanced for 22560 devices

Gregory Greenman (1):
      iwlwifi: mvm: add NOA and CSA to a probe response

Gustavo A. R. Silva (2):
      ath10k: use struct_size() in kzalloc()
      orinoco_usb: fix spelling mistake in fall-through annotation

Haim Dreyfuss (1):
      iwlwifi: mvm: support new reduce tx power FW API.

Ido Yariv (1):
      iwlwifi: Add missing 11n disable module parameter check

Igor Mitsyanko (11):
      qtnfmac_pcie: do not store FW name in driver state structure
      qtnfmac_pcie: move Pearl pcie sources to pcie-specific directory
      qtnfmac_pcie: rename private Pearl PCIe state structure
      qtnfmac_pcie: indicate pearl-specific structures by their names
      qtnfmac_pcie: pearl: rename spinlock tx0_lock to tx_lock
      qtnfmac_pcie: separate platform-independent PCIe structure
      qtnfmac_pcie: rename platform-specific functions
      qtnfmac: add missing header includes to bus.h
      qtnfmac_pcie: extract platform-independent PCIe code
      qtnfmac: wait for FW load work to finish at PCIe remove
      qtnfmac_pcie: check for correct CHIP ID at pcie probe

Igor Stoppa (1):
      wireless: remove unnecessary unlikely()

Ilan Peer (1):
      iwlwifi: mvm: Allow TKIP for AP mode

Jia-Shyr Chuang (1):
      brcmfmac: add CYW89342 mini-PCIe device

Johannes Berg (19):
      iwlwifi: remove dump_regs() from transport ops
      iwlwifi: don't WARN on trying to dump dead firmware
      iwlwifi: mvm: implement extended HE-MU sniffer API
      iwlwifi: mvm: put LTF symbol size into HE radiotap
      iwlwifi: mvm: properly decode HE GI duration
      iwlwifi: mvm: report # of LTF symbols for extended range SU PPDUs
      iwlwifi: mvm: remove channel 2 from HE radiotap if not applicable
      iwlwifi: mvm: decode HE TB PPDU data
      Revert "iwlwifi: allow memory debug TLV to specify the memory type"
      iwlwifi: RX API: remove unnecessary anonymous struct
      iwlwifi: mvm: report RU offset is known
      iwlwifi: remove ucode error tracepoint
      iwlwifi: api: annotate compressed BA notif array sizes
      iwlwifi: pcie: gen2: pull adding frags to helper routine
      iwlwifi: pcie: gen2: build A-MSDU only for GSO
      iwlwifi: pcie: tx: unify TFD unmapping
      iwlwifi: pcie: tx: pull tracing out of iwl_fill_data_tbs()
      iwlwifi: pcie: support transmitting SKBs with fraglist
      iwlwifi: fix LED command capability bit

Kalle Valo (5):
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2018-08-31' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      Merge wireless-drivers into wireless-drivers-next
      Merge tag 'mt76-for-kvalo-2018-09-19' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2018-09-28' of git://git.kernel.org/.../iwlwifi/iwlwifi-next

Karthick Gopalasubramanian (1):
      wil6210: remove reset file from debugfs

Kevin Lo (1):
      rtlwifi: remove set but unused variables

Kristian Evensen (1):
      mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST

Larry Finger (1):
      rtl8187: Fix warning generated when strncpy() destination length matches the sixe argument

Liad Kaufman (2):
      iwlwifi: mvm: add bss color to radiotap
      iwlwifi: mvm: add support for RX_AMPDU_EOF bit for HE SU

Lorenzo Bianconi (76):
      mt76x2u: run device cleanup routine if resume fails
      mt76: verify evt type in usb mcu response
      mt76: move mt76_reg_pair definition in mt76.h
      mt76: split __mt76u_mcu_send_msg and mt76u_mcu_send_msg routines
      mt76: move mt76x2u_mcu_deinit routine in mt76-usb module
      mt76: add multiple regs read support to usb_mcu layer
      mt76x0: use mt76u_init for bus initialization
      mt76x0: remove mt76x0_vendor_reset routine
      mt76x0: remove mt76x0_vendor_single_wr routine
      mt76x0: remove mt76x0_mcu_msg_alloc routine
      mt76x0: use shared mt76 usb mcu completion
      mt76x0: remove mt76x0_complete_urb routine
      mt76x0: remove mt76x0_vendor_request routine
      mt76x0: remove unused mt76x0_wait_asic_ready routine
      mt76x0: use mt76u_mcu_send_msg utility routine to send fw cmds
      mt76x0: remove unused mt76x0_mcu structure
      mt76x0: use mt76u_mcu_fw_send_data for fw uploading
      mt76x0: remove unused routines for usb_buff alloc/free
      mt76x2: change mt76x2_tx_complete routine signature
      mt76: move mt76x2_tx_complete routine in mt76x02-lib module
      mt76: move mt76x2u_remove_dma_hdr in mt76x02-lib module
      mt76: move mt76x2u_tx_complete_skb in mt76x02-lib moudule
      mt76: move mt76_qsel definition in dma.h
      mt76: move mt76x2u_set_txinfo in mt76x02-lib module
      mt76x0: introduce mt76x0_tx_prepare_skb routine
      mt76: move mt76x2u_tx_status_data in mt76x02-lib module
      mt76x0: disable usb rx bulk aggregation
      mt76x0: mark device as running in mt76x0_start
      mt76x0: simplify mt76_mac_process_rx signature
      mt76x0: add mt76x0_queue_rx_skb routine
      mt76x0: init mt76_driver_ops callbacks
      mt76x0: use mt76_alloc_device for device allocation
      mt76x0: unify tx/rx datapath with mt76x2u driver
      mt76x0: stop stat workqueue at hw stop
      mt76x0: set max fragments size
      mt76x0: remove unused dma.c source file
      mt76x0: remove unused stat work_queue
      mt76x0: remove unused {tx/rx}_queue definitions
      mt76x0: remove unused mt76x0_tx_status routine
      mt76x0: remove unused endpoint definitions
      mt76x0: remove unused stat_work
      mt76x0: enable per-sta tx queueing
      mt76x0: init hw capabilities
      mt76: remove unused MT76_MORE_STATS state
      mt76x0: remove mt76x0_stop_hardware routine
      mt76: move mt76 rate definitions in mt76x02-lib module
      mt76x0: alloc mcu buffers first in mt76x0_mcu_cmd_init
      mt76x0: fix memory leak during hw probe
      mt76x0: move stop related routines in mt76x0_mac_stop
      mt76x0: move mt76x0_init_hardware in mt76x0_register_device
      mt76x0: do not free/alloc buffers during suspend/resume
      mt76x0: remove has_{2,5}ghz fields of mt76x0_eeprom_params
      mt76x0: use mt76_register_device for device registration
      mt76x0: run vco calibration for each channel configuration
      mt76: move mt76x0 and mt76x2 mcu shared defs in mt76x02_mcu.h
      mt76: add mt76_mcu_ops data structure for mcu related pointers
      mt76: usb: use common helpers for mcu_alloc_msg()/mcu_send_msg()
      mt76: usb: move mt76x02 mcu code in mt76x02-usb module
      mt76: usb: move mt76u_skb_dma_info in mt76x02_usb_core.c
      mt76x02: move TXD/RXD/MCU definitions in mt76x02_dma.h
      mt76x02: add static qualifier to mt76x02_remove_dma_hdr
      mt76: usb: remove skb check in mt76x{0,2}u mcu routines
      mt76x2: use mt76_dev instead of mt76x2_dev in mt76x2_tx_queue_mcu
      mt76x2: remove leftover mt76u_buf data structure in mt76x2_mcu
      mt76: introduce mmio data structure in mt76_dev
      mt76: move __iomem regs in mt76_mmio
      mt76x2: use mt76_dev instead of mt76x2_dev in mt76x2_mcu_msg_send
      mt76x2: use common helpers for mcu_alloc_msg()/mcu_send_msg()
      mt76: unify firmware header between mt76x0 and mt76x2
      mt76: move mt76{0,2} mcu shared code in mt76x02_mcu.c
      mt76x2: move mt76x2 mcu shared code in mt76x2_mcu_common.c
      mt76: move shared mcu_calibrate routine in mt76x02-lib module
      mt76x2: move mt76x2_phy_tssi_compensate in mt76x2-common module
      mt76x0: remove mcu source file
      mt76x0: remove unused usb header file
      mt76x0: usb: remove mt76_fw definition

Luca Coelho (6):
      iwlwifi: remove unused TLC debugging commands
      iwlwifi: mvm: remove duplicate if in iwl_mvm_setup_connection_keep()
      iwlwifi: mvm: protect D0i3 code behind CONFIG_PM
      iwlwifi: mvm: support new WoWLAN status FW API
      iwlwifi: remove all occurrences of the FSF address paragraph
      iwlwifi: fix devices with PCI Device ID 0x34F0 and 11ac RF modules

Martin Willi (1):
      ath10k: schedule hardware restart if WMI command times out

Matt Chen (1):
      iwlwifi: pcie: avoid unnecessary work if NIC is disconnected

Maya Erez (4):
      wil6210: set edma variables only for Talyn-MB devices
      wil6210: allocate rx reorder buffer only if rx reorder is enabled
      wil6210: prevent usage of tx ring 0 for eDMA
      wil6210: fix RX buffers release and unmap

Mordechay Goodstein (3):
      iwlwifi: turn timestamp marker cmd off by default
      iwlwifi: enable reading the value of delay in timestamp_marker cmd
      iwlwifi: add 80211 hdr offset to trace data

Naftali Goldstein (4):
      iwlwifi: runtime: avoid calling debugfs read functions more than once
      iwlwifi: mvm: always init rs_fw with 20MHz bandwidth rates
      iwlwifi: rs-fw: enable STBC in he correctly
      iwlwifi: rs-fw: support dcm

Nathan Chancellor (4):
      ipw2x00: Remove unnecessary parentheses
      rsi: Remove unnecessary boolean condition
      ath5k: Remove unused BUG_ON
      rtlwifi: btcoex: Use proper enumerated types for Wi-Fi only interface

Rajat Jain (1):
      iwlwifi: pcie: Fail fast if HW is inaccessible at probe

Rakesh Pillai (1):
      ath10k: skip resetting rx filter for WCN3990

Rasmus Villemoes (1):
      brcmfmac: fix wrong strnchr usage

Rosen Penev (1):
      mt76x2u: Add support for Alfa AWUS036ACM

Sara Sharon (11):
      iwlwifi: mvm: move he RX handling to a separate function
      iwlwifi: mvm: move he RX handling to a separate function
      iwlwifi: drop packets with bad status in CD
      iwlwifi: mvm: fix BAR seq ctrl reporting
      iwlwifi: mvm: avoid sending too many BARs
      iwlwifi: pcie: set interrupt coalescing also for gen2
      iwlwifi: fw: add a restart FW debug function
      iwlwifi: fw: stop and start debugging using host command
      iwlwifi: pcie: read correct prph address for newer devices
      iwlwifi: mvm: use correct FIFO length
      iwlwifi: pcie: add infrastructure for multiple debug buffers

Shahar S Matityahu (4):
      iwlwifi: add d3 debug data support
      iwlwifi: change monitor DMA to be coherent
      iwlwifi: avoid code duplication in stopping fw debug data recording
      iwlwifi: debug flow cleanup

Shaul Triebitz (4):
      iwlwifi: iwlmvm: fix typo when checking for TX Beamforming
      iwlwifi: mvm: enable sending HE_AIR_SNIFFER command via debugfs
      iwlwifi: mvm: do not override amsdu size user settings
      iwlwifi: pcie: set RB size according to user settings

Siva Rebbagondla (2):
      rsi: fix memory alignment issue in ARM32 platforms
      rsi: improve kernel thread handling to fix kernel panic

Stanislaw Gruszka (52):
      mt76: unify wait_for_mac
      mt76: rename mt76x2_regs.h
      mt76: merge mt76x0/regs.h into mt76x02_regs.h
      mt76: create new mt76x02-lib module for common mt76x{0,2} code
      mt76: unify mac_get_key_info
      mt76: add helpers for register access with mt76_dev struct
      mt76: unify mac_shared_key_setup
      mt76: unify mac_wcid_set_key
      mt76: unify mac_wcid_setup
      mt76: use mac_wcid_set_drop in mt76x0
      mt76x0: use mt76_wcid_free in mt76x0
      mt76: unify mt76x02_vif struct
      mt76: unify sta structure part 1
      mt76: unify sta structure part 2
      mt76x0: initalize custom tx queues
      mt76x0: use mt76x02_sta and mt76x02_tx_status
      mt76x0: fix remove_interface
      mt76: move wcid fields to common mt76_dev struct
      mt76: unify sta_add / sta_remove
      mt76: pratially unify add_interface
      mt76: unify ampdu_action
      mt76: unify set_key
      mt76x0: remove empty sta_notify
      mt76: unify AC to hw queue mapping
      mt76: unify conf_tx
      mt76x0: remove vif_mask
      mt76: unify remove_interface
      mt76: unify add_interface
      mt76: unify sta_rate_tbl_update and related helpers
      mt76: unify txwi and rxwi structures
      mt76: unify load_tx_status
      mt76: unify send_tx_status and related helpers
      mt76: use mt76_rx_status in mt76x0
      mt76: unify mac_process_rate
      mt76x0: reserve enough space in mac80211
      mt76: unify {insert/remove}_hdr_pad
      mt76: partially unify filling txwi fields
      mt76x0: trim rx skb to proper length
      mt76x0: inital split between pci and usb
      mt76x0: remove unused mt76x0_wcid
      mt76x0: remove some usb specific code from mt76x0_register_device
      mt76x0: make device allocation bus neutral
      mt76: add usb implementation of {wr,rd}_rp
      mt76: add rd_rp and wr_rp to bus_ops/mcu_ops
      mt76x0: remove unused mt76x0_burst_read_regs
      mt76x0: remove mt76x0_burst_write_regs()
      mt76x0: usb: move firmware loading to usb.c
      rt2800: move usb specific txdone/txstatus routines to rt2800lib
      rt2800mmio: use txdone/txstatus routines from lib
      rt2x00: do not check for txstatus timeout every time on tasklet
      rt2x00: use different txstatus timeouts when flushing
      rt2800: flush and txstatus rework for rt2800mmio

Sven Eckelmann (1):
      ath10k: limit available channels via DT ieee80211-freq-limit

Takashi Iwai (1):
      brcmsmac: Use kvmalloc() for ucode allocations

Tamizh chelvam (1):
      ath10k: fix kernel panic by moving pci flush after napi_disable

Varsha Rao (4):
      ath9k: Remove unnecessary parentheses
      ath6kl: Remove unnecessary parentheses
      brcmsmac: Remove extra parentheses
      cw1200: Remove extra parentheses

YueHaibing (5):
      wcn36xx: Use kmemdup instead of duplicating it in wcn36xx_smd_process_ptt_msg_rsp
      wcn36xx: use dma_zalloc_coherent instead of allocator/memset
      rsi: remove set but not used variables 'header_size' and 'tx_params'
      brcmfmac: remove set but not used variables 'sfdoff' and 'pad_size'
      qtnfmac: remove set but not used variable 'vif'

zhong jiang (1):
      brcm80211: remove redundant condition check before debugfs_remove_recursive

 drivers/net/wireless/ath/ath10k/ahb.c              |    4 +-
 drivers/net/wireless/ath/ath10k/ce.c               |   24 +-
 drivers/net/wireless/ath/ath10k/core.c             |   17 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    4 +-
 drivers/net/wireless/ath/ath10k/hw.h               |    5 +
 drivers/net/wireless/ath/ath10k/mac.c              |    2 +
 drivers/net/wireless/ath/ath10k/pci.c              |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    6 +
 drivers/net/wireless/ath/ath5k/debug.c             |    2 -
 drivers/net/wireless/ath/ath6kl/main.c             |    2 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |    4 -
 drivers/net/wireless/ath/ath9k/ath9k.h             |    1 -
 drivers/net/wireless/ath/ath9k/debug_sta.c         |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |   12 +-
 drivers/net/wireless/ath/ath9k/tx99.c              |    9 -
 drivers/net/wireless/ath/ath9k/xmit.c              |    2 +-
 drivers/net/wireless/ath/carl9170/tx.c             |    4 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |   19 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |    4 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  333 ++++-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   47 +-
 drivers/net/wireless/ath/wil6210/main.c            |   13 +-
 drivers/net/wireless/ath/wil6210/pcie_bus.c        |    1 +
 drivers/net/wireless/ath/wil6210/rx_reorder.c      |   12 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |   98 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |   26 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |   19 +
 drivers/net/wireless/ath/wil6210/wmi.c             |  350 ++++-
 drivers/net/wireless/ath/wil6210/wmi.h             |    2 +
 drivers/net/wireless/broadcom/b43/b43.h            |    2 +-
 drivers/net/wireless/broadcom/b43/dma.c            |    2 +-
 drivers/net/wireless/broadcom/b43/main.c           |    8 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c      |    2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    8 +
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    5 +-
 .../wireless/broadcom/brcm80211/brcmsmac/debug.c   |    3 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |    6 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |    4 +-
 .../net/wireless/broadcom/brcm80211/brcmutil/d11.c |   34 +-
 .../broadcom/brcm80211/include/brcmu_wifi.h        |    3 +
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c      |    4 -
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c      |    4 -
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   71 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |    4 -
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c      |    4 -
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c      |    5 -
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |    5 -
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |    5 -
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c     |    5 -
 drivers/net/wireless/intel/iwlwifi/dvm/calib.h     |    5 -
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h  |    5 -
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c   |    5 -
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h       |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c   |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/led.h       |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |    5 -
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/power.c     |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/power.h     |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rs.h        |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |    5 -
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c        |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tt.h        |    4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |    5 -
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c     |    5 -
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    3 -
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |    3 -
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h   |    3 +
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   89 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |    5 +
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   32 +
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |   49 +
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |   14 +
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   30 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   78 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  189 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |    1 +
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    8 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  337 ++---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |   97 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |  124 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    |    3 -
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |    8 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   32 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |    5 -
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c |    5 -
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h |    5 -
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    1 +
 drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h    |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   18 +-
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  |   25 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |    6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c     |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h     |    4 -
 .../net/wireless/intel/iwlwifi/iwl-devtrace-data.h |   10 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace-io.h   |    4 -
 .../wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h  |   69 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace-msg.h  |    4 -
 .../wireless/intel/iwlwifi/iwl-devtrace-ucode.h    |    4 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c  |    7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h  |   22 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   24 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |    5 -
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |    7 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |    5 -
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |    5 -
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.h   |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |    4 -
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |    4 -
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |    3 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |    7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c    |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h    |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h       |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |    5 -
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   41 +-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  183 ++-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   37 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h   |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   28 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   91 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   36 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |    5 -
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   69 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   35 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  721 ++++++----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |    3 -
 drivers/net/wireless/intel/iwlwifi/mvm/testmode.h  |    5 -
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/tof.c       |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/tof.h       |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |    5 -
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |  162 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   27 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |    4 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   28 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   60 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  109 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   20 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    9 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  267 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  182 ++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   93 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |    6 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |    5 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |   13 +
 drivers/net/wireless/mediatek/mt76/Kconfig         |   29 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |   10 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   16 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |   51 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    6 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |   12 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   94 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/Makefile |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/core.c   |   34 -
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c    |  522 -------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |   26 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |    3 -
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  400 ++----
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    |  437 +-----
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |  136 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  272 +---
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c    |  656 ---------
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h    |   61 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  181 +--
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   81 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |   37 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h   |  651 ---------
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  |   14 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  245 +---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  382 +++--
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h    |   61 -
 drivers/net/wireless/mediatek/mt76/mt76x0/util.c   |   42 -
 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h   |   60 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |  504 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  205 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |  213 +++
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |  100 ++
 .../mt76/{mt76x2_regs.h => mt76x02_regs.h}         |   78 +-
 .../mediatek/mt76/{mt76x2_dma.h => mt76x02_usb.h}  |   22 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   72 +
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |  359 +++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  456 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |   54 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |   88 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  318 +----
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    |   55 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |   27 +-
 .../wireless/mediatek/mt76/mt76x2_init_common.c    |   48 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |   19 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  131 +-
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c |  488 +------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |   93 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c    |  261 +---
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h    |   68 +-
 .../net/wireless/mediatek/mt76/mt76x2_mcu_common.c |  124 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c    |   65 +-
 .../net/wireless/mediatek/mt76/mt76x2_phy_common.c |   53 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_trace.h  |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c     |   13 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |   49 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_usb.c    |   17 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u.h       |   17 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |   69 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c  |   23 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |   47 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c   |  218 +--
 drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c   |   67 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   16 +
 drivers/net/wireless/mediatek/mt76/usb.c           |  105 +-
 drivers/net/wireless/mediatek/mt76/usb_mcu.c       |  204 +--
 drivers/net/wireless/quantenna/qtnfmac/Makefile    |    3 +-
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |    5 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |    3 -
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  391 +++++
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |   85 ++
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 1262 +++++++++++++++++
 .../{pearl/pcie_ipc.h => pcie/pearl_pcie_ipc.h}    |   58 -
 .../pcie_regs_pearl.h => pcie/pearl_pcie_regs.h}   |    0
 .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 1494 --------------------
 .../quantenna/qtnfmac/pearl/pcie_bus_priv.h        |   91 --
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    |   14 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  154 ++
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |    3 +
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c    |  277 ++--
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h    |    1 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |  143 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |    3 +
 drivers/net/wireless/ralink/rt2x00/rt2x00debug.c   |   18 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     |    4 +
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |    2 +
 .../net/wireless/realtek/rtl818x/rtl8187/leds.c    |    2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |    2 +
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |    4 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    4 -
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    2 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   11 +-
 drivers/net/wireless/rsi/rsi_common.h              |    1 -
 drivers/net/wireless/st/cw1200/txrx.c              |    4 +-
 276 files changed, 8620 insertions(+), 9949 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/core.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/regs.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/util.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_regs.h => mt76x02_regs.h} (89%)
 rename drivers/net/wireless/mediatek/mt76/{mt76x2_dma.h => mt76x02_usb.h} (58%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_util.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_util.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_mcu_common.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
 create mode 100644 drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_ipc.h => pcie/pearl_pcie_ipc.h} (68%)
 rename drivers/net/wireless/quantenna/qtnfmac/{pearl/pcie_regs_pearl.h => pcie/pearl_pcie_regs.h} (100%)
 delete mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
 delete mode 100644 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie_bus_priv.h
