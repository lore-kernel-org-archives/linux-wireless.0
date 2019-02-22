Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C75C10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 15:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 580B12086A
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 15:01:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AxPslStY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jQCxLaHj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfBVPBP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 10:01:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46578 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfBVPBP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 10:01:15 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 68D04609C6; Fri, 22 Feb 2019 15:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550847672;
        bh=w3OSUhzyWd3QQyn5Mh998mxeOtBChdS5If1ky8qMfVA=;
        h=From:To:Cc:Subject:Date:From;
        b=AxPslStY4iPIIjEqjTeiwIvzSx8C/2vdeT30gpO37iSQpFXVwdquNgeXR43Y/uJpG
         4yYzcifbv2tCXgfq1U1/Jw+CYRcyse4KxYIwxK0ulvhZjf2tC+bpqgw/avyfkh/7iO
         Aq59CBhop5BzKPW+RCkZWNksKSGBXXvcBgB2hepI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BE1D16098A;
        Fri, 22 Feb 2019 15:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550847668;
        bh=w3OSUhzyWd3QQyn5Mh998mxeOtBChdS5If1ky8qMfVA=;
        h=From:To:Cc:Subject:Date:From;
        b=jQCxLaHjZRKJDOjTrg03a3qG1M4Xgq+todBLfGLzjf/lvDjyEXDN8/DIRj1u2tj5h
         IpLMDIMeMOUEQG2IsQSlqRWwa+9L0wp+T0Kk1FjDnT5G0sqUHU5UBk0znpnHpEvLfw
         TPCSx83acUlhQIPwLCebE478MshhaCpHMuIXqWek=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BE1D16098A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers-next 2019-02-22
Date:   Fri, 22 Feb 2019 17:01:03 +0200
Message-ID: <87sgwfn9zk.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's a pull request to net-next tree for 5.1, more info below. Do note
that the diffstat again was wrong due to the wireless-drivers merge so I
had to recreate it manually.

Please let me know if there are any problems.

Kalle

The following changes since commit d04ca383860bef90a0dab4eb397907f7f05e839e:

  mt76x0u: fix suspend/resume (2019-02-07 18:32:16 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next=
.git tags/wireless-drivers-next-for-davem-2019-02-22

for you to fetch changes up to 5c0c4c85463461a9ea0a69c4e80849a71c6b1e24:

  Merge tag 'iwlwifi-next-for-kalle-2019-02-20' of git://git.kernel.org/pub=
/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2019-02-20 21:06:13 +0200)

----------------------------------------------------------------
wireless-drivers-next patches for 5.1

Most likely the last set of patches for 5.1. WPA3 support to ath10k
and qtnfmac. FTM support to iwlwifi and ath10k. And of course other
new features and bugfixes.

wireless-drivers was merged due to dependency in mt76.

Major changes:

iwlwifi

* HE radiotap

* FTM (Fine Timing Measurement) initiator and responder implementation

* bump supported firmware API to 46

* VHT extended NSS support

* new PCI IDs for 9260 and 22000 series

ath10k

* change QMI interface to support the new (and backwards incompatible)
  interface from HL3.1 and used in recent HL2.0 branch firmware
  releases

* support WPA3 with WCN3990

* support for mac80211 airtime fairness based on transmit rate
  estimation, the firmware needs to support WMI_SERVICE_PEER_STATS to
  enable this

* report transmit airtime to mac80211 with firmwares having
  WMI_SERVICE_REPORT_AIRTIME feature, this to have more accurate
  airtime fairness based on real transmit time (instead of just
  estimated from transmit rate)

* support Fine Timing Measurement (FTM) responder role

* add dynamic VLAN support with firmware having WMI_SERVICE_PER_PACKET_SW_E=
NCRYPT

* switch to use SPDX license identifiers

ath

* add new country codes for US

brcmfmac

* support monitor frames with the hardware/ucode header

qtnfmac

* enable WPA3 SAE and OWE support

mt76

* beacon support for USB devices (mesh+ad-hoc only)

rtlwifi

* convert to use SPDX license identifiers

libertas_tf

* get the MAC address before registering the device

----------------------------------------------------------------
Abhishek Ambure (2):
      ath10k: assign 'n_cipher_suites =3D 11' for WCN3990 to enable WPA3
      ath10k: update GCMP & GCMP-256 cipher suite number for WCN3990

Adrian Bunk (1):
      mwifiex: Fix NL80211_TX_POWER_LIMITED

Alagu Sankar (1):
      ath10k: reduce transmit msdu count

Andrei Otcheretianski (1):
      iwlwifi: mvm: Set TX_CMD_FLG_PROT_REQUIRE correctly

Arend van Spriel (6):
      brcmfmac: assure SSID length from firmware is limited
      brcmfmac: add subtype check for event handling in data path
      brcmfmac: create debugfs files for bus-specific layer
      brcmfmac: disable MBSS feature for bcm4330 device
      brcmfmac: check and dump trap info during sdio probe
      brcmfmac: use chipname in brcmf_fw_alloc_request() for error path as =
well

Arnd Bergmann (1):
      iwlwifi: fix false-positive maybe-uninitialized warning

Avigail Grinstein (1):
      iwlwifi: mvm: support absolute thresholds in bf configuration

Avraham Stern (4):
      iwlwifi: mvm: Fix possible NULL pointer dereference
      iwlwifi: mvm: add support for new FTM fw API
      iwlwifi: mvm: add debug prints for FTM
      iwlwifi: mvm: stop static queues correctly

Ben Hutchings (1):
      mt76: Use the correct hweight8() function

Brian Norris (3):
      ath10k: sdio: add .owner field
      ath10k: pci: use mutex for diagnostic window CE polling
      mwifiex: don't advertise IBSS features without FW support

Christian Lamparter (1):
      ath10k: implement set_base_macaddr to fix rx-bssid mask in multiple A=
Ps conf

Colin Ian King (2):
      rsi: fix indentation issue with a code block
      rtlwifi: rtl8192ce: fix typo, "PairwiseENcAlgorithm" -> "PairwiseEncA=
lgorithm"

Dan Carpenter (2):
      rsi: fix a typo in a debug message
      carl9170: clean up a clamp() call

Daniel F. Dickinson (1):
      ath9k: Avoid OF no-EEPROM quirks without qca,no-eeprom

Emmanuel Grumbach (3):
      iwlwifi: mvm: support new format for the beacon notification
      iwlwifi: mvm: fix AP mode in WEP
      iwlwifi: mvm: fix the spatial reuse parsing for HE_TRIG PPDUs

Felix Fietkau (11):
      mt76: fix software encryption issues
      mt76: mt76x2: avoid running DPD calibration if tx is blocked
      mt76: explicitly disable energy detect cca during scan
      mt76: run MAC work every 100ms
      mt76: clear CCA timer stats in mt76x02_edcca_init
      mt76: measure the time between mt76x02_edcca_check runs
      mt76: increase ED/CCA tx block threshold
      mt76: fix tx status timeout processing
      mt76: fix corrupted software generated tx CCMP PN
      mt76: fix resetting software IV flag on key delete
      mt76: mt76x2: simplify per-chain signal strength handling

Govind Singh (5):
      ath10k: Add support for extended HTT aggr msg support
      ath10k: update HOST capability qmi message
      ath10k: enable bus layer suspend/resume for WCN3990
      ath10k: disable interface pause wow config for integrated chipset
      ath10k: request credit report if flow control enabled on ep

Greg Kroah-Hartman (5):
      ath10k: do not return invalid pointers as a *dentry
      ath9k: do not return invalid pointers as a *dentry
      iwlwifi: dvm: no need to check return value of debugfs_create functio=
ns
      iwlwifi: fw: no need to check return value of debugfs_create functions
      iwlwifi: iwl-drv: no need to check return value of debugfs_create fun=
ctions

Gustavo A. R. Silva (2):
      iwlwifi: eeprom-parse: use struct_size() in kzalloc()
      iwlwifi: nvm-parse: use struct_size() in kzalloc()

Haim Dreyfuss (1):
      iwlwifi: mvm: add support for 32kHz external clock indication

Ido Yariv (1):
      iwlwifi: mvm: don't require WOWLAN images when unified

Ihab Zhaika (2):
      iwlwifi: add new card for 9260 series
      iwlwifi: add new cards for 22000 and killer series and change the mar=
ket name

Ilan Peer (5):
      iwiwifi: mvm: Fix FW scan concurrency support assumptions
      iwlwifi: mvm: Don't warn on command failure during restart
      iwlwifi: mvm: Do not return an error value on HW restart
      iwlwifi: mvm: Don't request HW restart if already requested
      iwlwifi: mvm: Allow retries for probe responses

Johannes Berg (17):
      iwlwifi: mvm: remove redundant condition
      iwlwifi: dvm: use %u for sscanf() into unsigned variable
      iwlwifi: mvm: add HE TB PPDU SIG-A BW to radiotap
      iwlwifi: move config structs to C file
      iwlwifi: mvm: don't hide HE radiotap data in SKB
      iwlwifi: refactor NIC init sequence
      iwlwifi: mvm: fix RFH config command with >=3D10 CPUs
      iwlwifi: implement BISR HW workaround for 22260 devices
      iwlwifi: mvm: support FTM responder
      iwlwifi: mvm: support FTM initiator
      iwlwifi: mvm: clean up NO_PSDU case
      iwlwifi: bump FW API to 46 for 9000 and 22000 series
      iwlwifi: mvm: fix HE radiotap data4 for HE-TB PPDUs
      iwlwifi: mvm: fix error path in iwl_mvm_mac_setup_register()
      iwlwifi: nvm-parse: advertise IEEE80211_VHT_EXT_NSS_BW_CAPABLE in VHT
      iwlwifi: mvm: remove IWL_MVM_INIT_STATUS_REG_HW_INIT_COMPLETE
      iwlwifi: mvm: implement VHT extended NSS support in rs.c

Kalle Valo (16):
      Merge tag 'iwlwifi-next-for-kalle-2019-02-04' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge git://git.kernel.org/.../kvalo/wireless-drivers.git
      ath10k: fix line length warning in ath10k_ce_alloc_dest_ring()
      ath10k: add missing values to wmi_service_name()
      ath10k: make wmi_service_name() warn about missing service ids
      ath10k: change wmi.h to include only ieee80211.h
      ath10k: align ath10k_htt_txbuf structures
      ath10k: fix documentation in ath10k_wow_convert_8023_to_80211()
      ath10k: copy the whole struct ath10k_bus_params in ath10k_core_regist=
er()
      Merge tag 'iwlwifi-next-for-kalle-2019-02-14' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2019-02-18' of https://github.com/nbd168/wi=
reless
      ath10k: change 'unsigned long int' to 'unsigned long'
      ath10k: switch to use SPDX license identifiers
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2019-02-20' of git://git.kernel.org=
/.../iwlwifi/iwlwifi-next

Kan Yan (1):
      ath10k: report estimated frame transmit airtime to improve fairness

Kangjie Lu (1):
      ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()

Kees Cook (1):
      ath9k: eeprom: Use scnprintf instead of snprintf

Keyur Patel (1):
      orinoco : Replace function name in string with __func__

Larry Finger (21):
      rtlwifi: Replace old-style license information
      rtlwifi: btcoex: Replace old-style license information
      rtlwifi: rtl8188ee: Replace old-style license information
      rtlwifi: rtl8192com: Replace old-style license information
      rtlwifi: rtl8192ce: Replace old-style license information
      rtlwifi: rtl8192cu: Replace old-style license information
      rtlwifi: rtl8192de: Replace old-style license information
      rtlwifi: rtl8192ee: Replace old-style license information
      rtlwifi: rtl8192se: Replace old-style license information
      rtlwifi: rtl8723ae: Replace old-style license information
      rtlwifi: rtl8723be: Replace old-style license information
      rtlwifi: rtl8723_common: Replace old-style license information
      rtlwifi: rtl8821ae: Replace old-style license information
      rtlwifi: Remove CamelCase variables from base code
      rtlwifi: btcoexist: Remove CamelCase variable
      rtlwifi: rtl8188ee: Remove CamelCase variable
      rtlwifi: rtl8192{c,u}: Remove CamelCase variables
      rtlwifi: rtl8188de: Remove CamelCase variables
      rtlwifi: rtl8192se: Remove CamelCase variables
      rtlwifi: rtl8723{be,ae}: Remove CamelCase variables
      rtlwifi: rtl8821ae: Remove CamelCase variables

Liad Kaufman (3):
      iwlwifi: mvm: add tlc command name to output
      iwlwifi: mvm: config mac ctxt to HE before TLC
      iwlwifi: mvm: add read debugfs for he_sniffer_params

Lorenzo Bianconi (21):
      mt76x0: eeprom: fix VHT mcs{8,9} rate power offset
      mt76: move mt76_mcu_msg_alloc in mt76-core
      mt76: move mt76_mcu_get_response in mt76-core
      mt76: move mt76_mcu_rx_event in mt76-core
      mt76x0: mcu: remove useless commented configuration
      mt76: move mt76_dma_tx_queue_skb_raw in mt76-core module
      mt76: remove add_buf pointer in mt76_queue_ops
      mt76: move alloc_device common code in mt76_alloc_device
      mt76x2u: remove mt76x2u_alloc_device routine
      mt76x0: remove mt76x0u_alloc_device routine
      mt76x2: remove mt76x2_alloc_device routine
      mt76x0: phy: report target_power in debugfs
      mt76x0: init: introduce mt76x0_init_txpower routine
      mt76: usb: fix possible NULL pointer dereference in mt76u_mcu_deinit
      mt76: usb: fix possible memory leak in mt76u_buf_free
      mt76: usb: do not run mt76u_queues_deinit twice
      mt76: usb: move mt76u_check_sg in usb.c
      mt76: usb: do not use sg buffers for mcu messages
      mt76: usb: use a linear buffer for tx/rx datapath if sg is not suppor=
ted
      mt76: usb: introduce disable_usb_sg parameter
      mt76: usb: use dev_err_ratelimited instead of dev_err in mt76u_comple=
te_rx

Lubomir Rintel (7):
      libertas_tf: lower the debug level of command trace
      libertas_tf: don't set URB_ZERO_PACKET on IN USB transfer
      libertas_tf: move the banner to a more appropriate place
      libertas_tf: fix signal reporting
      libertas_tf: move hardware callbacks to a separate structure
      libertas_tf: don't defer firmware loading until start()
      libertas_tf: get the MAC address before registering the device

Luca Coelho (5):
      iwlwifi: bump FW API to 44 for 9000 and 22000 series
      iwlwifi: dvm: fix some fall through warnings
      iwlwifi: mvm: add fall through comments where needed
      iwlwifi: bump FW API to 45 for 9000 and 22000 series
      iwlwifi: start using B-step for some 9000 devices

Manikanta Pubbisetty (2):
      ath10k: add dynamic vlan support
      ath10k: report tx airtime provided by fw

Matteo Croce (1):
      brcmfmac: fix typos

Mordechay Goodstein (1):
      iwlwifi: add FW recovery flow

Naftali Goldstein (1):
      iwlwifi: mvm: add description to second BAD_COMMAND assert number

Oever Gonzalez (1):
      ath: regd: add extra US coutry codes

Pradeep Kumar Chitrapu (1):
      ath10k: add support to configure ftm responder role

Rafa=C5=82 Mi=C5=82ecki (10):
      brcmfmac: modify __brcmf_err() to take bus as a parameter
      brcmfmac: pass bus to the __brcmf_err() in pcie.c
      brcmfmac: add bphy_err() and use it in the cfg80211.c
      brcmfmac: support monitor frames with the hardware/ucode header
      brcmfmac: print firmware reported ring status errors
      brcmfmac: improve code handling bandwidth of firmware reported channe=
ls
      brcmfmac: support firmware reporting 160 MHz channels
      brcmfmac: rework bphy_err() to take struct brcmf_pub argument
      brcmfmac: use bphy_err() in all wiphy-related code
      brcmfmac: add basic validation of shared RAM address

Rakesh Pillai (7):
      ath10k: Set DMA address mask to 35 bit for WCN3990
      ath10k: Handle bundled tx completion for management frames
      ath10k: Enable bundle tx compl for management frames in WCN3990
      ath10k: fix dma unmap direction for management frames
      ath10k: fix hw-restart crash inject mode for WCN3990
      ath10k: enable Factory Test Mode for WCN3990
      ath10k: fix shadow register implementation for WCN3990

Ryder Lee (1):
      mt76: change the return type of mt76_dma_attach()

Sara Sharon (12):
      iwlwifi: mvm: simplify some return conditions
      iwlwifi: mvm: support CHANNEL_SWITCH_TIME_EVENT_CMD command
      iwlwifi: mvm: limit AMSDU size to 8K
      iwlwifi: mvm: fix RSS config command
      iwlwifi: pcie: fix emergency path
      iwlwifi: dvm: don't use IWL_DL_FW_ERRORS
      iwlwifi: pcie: add TPT oriented prints
      iwlwifi: mvm: support beacon IE injection
      iwlwifi: pcie: fix TX while flushing
      iwlwifi: mvm: reject new beacons when in inject mode
      iwlwifi: mvm: support non-transmitting AP
      iwlwifi: mvm: add some debug data to TX path

Sergey Matyukevich (2):
      qtnfmac: enable WPA3 OWE support
      qtnfmac: enable WPA3 SAE support

Shahar S Matityahu (33):
      iwlwifi dbg_ini: update ini structs doc
      iwlwifi: dbg_ini: fix iwl_fw_ini_buffer_location field enum bad naming
      iwlwifi: dbg_ini: give better naming to region struct fields
      iwlwifi: fix bad dma handling in page_mem dumping flow
      iwlwifi: differentiate between alive timeout and alive flow failure
      iwlwifi: dbg_ini: update ini triggers enum
      iwlwifi: dbg_ini: update max region id num to  support 64 regions
      iwlwifi: Fix pre operational dumping flows
      iwlwifi: dbg_ini: update ini structs meta doc
      iwlwifi: dbg_ini: remove redundant dram buffer allocation
      iwlwifi: dbg_ini: align struct iwl_fw_ini_region_cfg to the FW
      iwlwifi: dbg_ini: create new dump flow and implement prph dump
      iwlwifi: dbg_ini: implement csr memory dump
      iwlwifi: dbg_ini: implement device internal memory dump
      iwlwifi: dbg_ini: implement paging memory dump
      iwlwifi: fix send hcmd timeout recovery flow
      iwlwifi: dbg_ini: implement monitor sram memory dump
      iwlwifi: dbg_ini: implement monitor dram memory dump
      iwlwifi: receive umac and lmac error table addresses from TLVs
      iwlwifi: dbg_ini: rewrite trigger flow and align to FW API changes
      iwlwifi: mvm: add a debug_enable op
      iwlwifi: properly use delay option in dump trigger flow
      iwlwifi: dbg_ini: enable ignore consecutive trigger feature
      iwlwifi: dbg: buffer overflow in non_collect_ts_start array
      iwlwifi: dbg_ini: add early and after alive apply points to unified i=
mages
      iwlwifi: remove redundant condition from prior alive dump flow
      iwlwifi: dbg_ini: fix infinite time ignore consecutive dumps
      iwlwifi: dbg_ini: add print to iwl_dump_ini_mem in case of invalid ra=
nge
      iwlwifi: dbg_ini: make memory dump get_size handler include headers
      iwlwifi: dbg_ini: make fill_range handler accept generic range pointer
      iwlwifi: dbg_ini: add region to fill_header handler
      iwlwifi: dbg_ini: implement Tx fifos dump
      iwlwifi: dbg_ini: implement Rx fifos dump

Shaul Triebitz (5):
      iwlwifi: introduce device family AX210
      iwlwifi: do not fail on large amount of channels
      iwlwifi: dbg: temporarily skip periphery dump for AX210 devices
      iwlwifi: align to new periphery address space for AX210 family
      iwlwifi: add force NMI for AX210 devices

Siva Rebbagondla (6):
      rsi: Add debug support for wowlan wakeup confirmation
      rsi: add hci detach for hibernation and poweroff
      rsi: fix wowlan wakeup issue for hibernate(S4)
      rsi: resolve power save issue after S4 resume
      rsi: fix for wowlan wakeup failure
      rsi: fix spelling mistakes

Stanislaw Gruszka (12):
      mt76x02: use mask for vifs
      mt76x02: use commmon add interface for mt76x2u
      mt76x02: initialize mutli bss mode when set up address
      mt76x02: minor beaconing init changes
      mt76x02: init beacon config for mt76x2u
      mt76: beaconing fixes for USB
      mt76x02: enable support for IBSS and MESH
      mt76x02u: use usb_bulk_msg to upload firmware
      mt76x02u: remove bogus check and comment padding
      rt2800: enable TX_PIN_CFG_LNA_PE_ bits per band
      rt2800: enable TX_PIN_CFG_RFRX_EN only for MT7620
      rt2800: comment and simplify AGC init for RT6352

Stefan Agner (1):
      mwifiex: don't print error message on coex event

Surabhi Vishnoi (2):
      ath10k: add a condition to fill the LDPC capability correctly
      ath10k: fill tx_duration for each peer in Tx stats per STA

Toke H=C3=B8iland-J=C3=B8rgensen (2):
      ath9k: Switch to mac80211 TXQ scheduling and airtime APIs
      ath10k: migrate to mac80211 txq scheduling

Tomislav Po=C5=BEega (2):
      rt2x00: remove unneeded check
      rt2x00: remove confusing AGC register

Triebitz (1):
      iwlwifi: pcie: allocate rb_stts's for all queues in one place

Wen Gong (1):
      ath10k: change swap mail box check after htc ready

Yu Wang (1):
      ath10k: fix S5 power consumption issue for QCA9377

YueHaibing (7):
      iwlwifi: mvm: remove duplicated include from ops.c
      ath10k: snoc: remove set but not used variable 'ar_snoc'
      rtlwifi: remove set but not used variable 'cmd_seq'
      brcmfmac: remove set but not used variable 'old_state'
      rsi: remove set but not used variables 'info, vif'
      libertas_tf: remove set but not used variable 'flags'
      rtl818x_pci: Remove set but not used variables 'io_addr, mem_addr'

Zhiwei Jiang (1):
      ath: move spin_lock_bh to spin_lock in tasklet

 drivers/net/wireless/ath/ath10k/Makefile           |    2 +-
 drivers/net/wireless/ath/ath10k/ahb.c              |   16 +-
 drivers/net/wireless/ath/ath10k/ahb.h              |   13 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |   13 +-
 drivers/net/wireless/ath/ath10k/bmi.h              |   13 +-
 drivers/net/wireless/ath/ath10k/ce.c               |  117 ++-
 drivers/net/wireless/ath/ath10k/ce.h               |   29 +-
 drivers/net/wireless/ath/ath10k/core.c             |   45 +-
 drivers/net/wireless/ath/ath10k/core.h             |   42 +-
 drivers/net/wireless/ath/ath10k/coredump.c         |   15 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |   13 +-
 drivers/net/wireless/ath/ath10k/debug.c            |   17 +-
 drivers/net/wireless/ath/ath10k/debug.h            |   33 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |   23 +-
 drivers/net/wireless/ath/ath10k/hif.h              |   29 +-
 drivers/net/wireless/ath/ath10k/htc.c              |   22 +-
 drivers/net/wireless/ath/ath10k/htc.h              |   14 +-
 drivers/net/wireless/ath/ath10k/htt.c              |   15 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   49 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |  103 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   70 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   23 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   20 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  249 +++--
 drivers/net/wireless/ath/ath10k/mac.h              |   13 +-
 drivers/net/wireless/ath/ath10k/p2p.c              |   13 +-
 drivers/net/wireless/ath/ath10k/p2p.h              |   13 +-
 drivers/net/wireless/ath/ath10k/pci.c              |   62 +-
 drivers/net/wireless/ath/ath10k/pci.h              |   16 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |   13 +-
 drivers/net/wireless/ath/ath10k/qmi.h              |   13 +-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c     |  242 ++++-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h     |   47 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |   13 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   59 +-
 drivers/net/wireless/ath/ath10k/sdio.h             |   13 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   93 +-
 drivers/net/wireless/ath/ath10k/snoc.h             |   15 +-
 drivers/net/wireless/ath/ath10k/spectral.c         |   16 +-
 drivers/net/wireless/ath/ath10k/spectral.h         |   13 +-
 drivers/net/wireless/ath/ath10k/swap.c             |   13 +-
 drivers/net/wireless/ath/ath10k/swap.h             |   13 +-
 drivers/net/wireless/ath/ath10k/targaddrs.h        |   13 +-
 drivers/net/wireless/ath/ath10k/testmode.c         |   15 +-
 drivers/net/wireless/ath/ath10k/testmode.h         |   13 +-
 drivers/net/wireless/ath/ath10k/testmode_i.h       |   13 +-
 drivers/net/wireless/ath/ath10k/thermal.c          |   13 +-
 drivers/net/wireless/ath/ath10k/thermal.h          |   13 +-
 drivers/net/wireless/ath/ath10k/trace.c            |   13 +-
 drivers/net/wireless/ath/ath10k/trace.h            |   13 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |   19 +-
 drivers/net/wireless/ath/ath10k/txrx.h             |   13 +-
 drivers/net/wireless/ath/ath10k/usb.c              |   16 +-
 drivers/net/wireless/ath/ath10k/usb.h              |   13 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |   44 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   88 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |   23 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   95 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   98 +-
 drivers/net/wireless/ath/ath10k/wow.c              |   20 +-
 drivers/net/wireless/ath/ath10k/wow.h              |   13 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   12 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |   14 -
 drivers/net/wireless/ath/ath9k/common-spectral.c   |    3 +
 drivers/net/wireless/ath/ath9k/debug.c             |    3 -
 drivers/net/wireless/ath/ath9k/debug.h             |    8 -
 drivers/net/wireless/ath/ath9k/debug_sta.c         |   70 --
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    6 +-
 drivers/net/wireless/ath/ath9k/init.c              |    9 +-
 drivers/net/wireless/ath/ath9k/recv.c              |    9 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  244 ++---
 drivers/net/wireless/ath/carl9170/rx.c             |    2 +-
 drivers/net/wireless/ath/regd.h                    |    2 +
 drivers/net/wireless/ath/regd_common.h             |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |   22 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   10 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  577 +++++-----
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   46 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  135 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |   19 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   22 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |    4 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |    8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   25 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |   18 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |   10 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   38 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   90 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   88 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   65 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |   22 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.c   |    6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   71 +-
 .../broadcom/brcm80211/brcmfmac/tracepoint.c       |    9 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |  104 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |    9 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c   |   47 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   19 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |    6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   32 +
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   22 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |   48 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    5 +
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |  180 ++--
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |  191 +++-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |   27 +
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   24 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   18 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 1110 +++++++++++++++-=
----
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |   85 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |   11 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    |    9 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   95 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   25 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   31 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    3 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   23 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   52 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |    5 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   23 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h     |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   77 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |    3 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |   47 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   79 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |   44 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   31 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   41 +
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |    7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    7 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  138 ++-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  654 ++++++++++++
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |  244 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  141 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  124 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  292 ++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   61 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   63 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  103 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  152 +--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    3 +
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   31 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   16 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |    6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |  115 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   30 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  118 ++-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   28 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  213 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |    8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   30 +-
 drivers/net/wireless/intersil/orinoco/mic.c        |   10 +-
 drivers/net/wireless/marvell/libertas_tf/cmd.c     |    9 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   38 +-
 .../net/wireless/marvell/libertas_tf/libertas_tf.h |   18 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |  103 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   23 +-
 drivers/net/wireless/marvell/mwifiex/ioctl.h       |    1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   11 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |    3 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   29 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |    2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   11 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |   60 ++
 drivers/net/wireless/mediatek/mt76/mt76.h          |   32 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |   16 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |   39 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |    4 -
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |   19 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |   11 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |   26 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb_mcu.c    |    6 -
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   90 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |    8 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |   69 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |    6 +
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |   12 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   14 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |   72 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   79 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |    1 -
 .../net/wireless/mediatek/mt76/mt76x2/mt76x2u.h    |    1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |   26 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |   31 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_phy.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   24 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |   32 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   17 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    5 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  162 ++-
 drivers/net/wireless/mediatek/mt76/usb_mcu.c       |   13 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   40 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   29 +
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |    2 +
 drivers/net/wireless/quantenna/qtnfmac/event.c     |  185 +++-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |   36 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  141 +--
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    6 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |   29 +-
 drivers/net/wireless/realtek/rtlwifi/base.h        |   26 +-
 .../realtek/rtlwifi/btcoexist/halbt_precomp.h      |   27 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |   35 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.h    |   27 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |   26 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.h    |   27 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |   27 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.h    |   27 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |   26 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.h    |   26 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |   26 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.h    |   26 +-
 .../rtlwifi/btcoexist/halbtc8822bwifionly.c        |   17 +-
 .../rtlwifi/btcoexist/halbtc8822bwifionly.h        |   17 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |   26 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.h       |   27 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |   27 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.h   |   25 +-
 drivers/net/wireless/realtek/rtlwifi/cam.c         |   27 +-
 drivers/net/wireless/realtek/rtlwifi/cam.h         |   26 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |   26 +-
 drivers/net/wireless/realtek/rtlwifi/core.h        |   26 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   25 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h       |   27 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   71 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.h       |   28 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   26 +-
 drivers/net/wireless/realtek/rtlwifi/pci.h         |   26 +-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |   26 +-
 drivers/net/wireless/realtek/rtlwifi/ps.h          |   26 +-
 drivers/net/wireless/realtek/rtlwifi/pwrseqcmd.h   |   26 +-
 drivers/net/wireless/realtek/rtlwifi/rc.c          |   26 +-
 drivers/net/wireless/realtek/rtlwifi/rc.h          |   26 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c        |   34 +-
 drivers/net/wireless/realtek/rtlwifi/regd.h        |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/def.h   |   29 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.h    |   25 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/led.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/led.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.h   |   26 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/pwrseq.c    |   26 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/reg.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/rf.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/rf.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/sw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/table.c |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/table.h |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.h   |   26 +-
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  |   26 +-
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.h  |   30 +-
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  |   40 +-
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.h  |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192c/main.c   |   26 +-
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.c |   50 +-
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.h |   32 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/def.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/dm.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/dm.h    |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |   66 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/led.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/led.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/phy.c   |   36 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/phy.h   |   32 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/reg.h   |   85 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/rf.c    |  138 +--
 .../net/wireless/realtek/rtlwifi/rtl8192ce/rf.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/sw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/table.c |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/table.h |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/def.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/dm.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/dm.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  304 +++---
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.h    |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/led.c   |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/led.h   |   24 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/phy.c   |   42 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/phy.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/reg.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/rf.c    |  138 +--
 .../net/wireless/realtek/rtlwifi/rtl8192cu/rf.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/table.c |   34 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/table.h |   42 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |   88 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.h   |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/def.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/dm.c    |   50 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/dm.h    |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    |   42 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |   92 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/led.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/led.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |   94 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/reg.h   |   54 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/rf.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/rf.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/table.c |   27 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/table.h |   27 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/def.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/dm.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/dm.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.h    |   25 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/led.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/led.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.h   |   26 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/pwrseq.c    |   26 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/reg.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/rf.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/rf.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/sw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/table.c |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/table.h |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/def.h   |   27 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/dm.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/dm.h    |   29 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/fw.c    |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/fw.h    |   33 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |   48 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.h    |   27 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/led.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/led.h   |   27 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   |   70 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.h   |   27 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/reg.h   |   75 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/rf.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/rf.h    |   27 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.h    |   25 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/table.c |   27 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/table.h |   20 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.h   |   27 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/btc.h   |   25 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/def.h   |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/fw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/fw.h    |   25 +-
 .../realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c     |   26 +-
 .../realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h     |   25 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |   27 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.h   |   25 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |   34 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/led.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/led.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.h   |   28 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/pwrseq.c    |   26 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h    |   44 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/reg.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/rf.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/rf.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.c    |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/sw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/table.c |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/table.h |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/def.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.h    |   23 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.h    |   25 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |   40 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/led.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/led.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.h   |   26 +-
 .../wireless/realtek/rtlwifi/rtl8723be/pwrseq.c    |   26 +-
 .../wireless/realtek/rtlwifi/rtl8723be/pwrseq.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/reg.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/rf.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/rf.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/sw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/table.c |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/table.h |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.h   |   26 +-
 .../realtek/rtlwifi/rtl8723com/dm_common.c         |   26 +-
 .../realtek/rtlwifi/rtl8723com/dm_common.h         |   26 +-
 .../realtek/rtlwifi/rtl8723com/fw_common.c         |   26 +-
 .../realtek/rtlwifi/rtl8723com/fw_common.h         |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8723com/main.c |   26 +-
 .../realtek/rtlwifi/rtl8723com/phy_common.c        |   26 +-
 .../realtek/rtlwifi/rtl8723com/phy_common.h        |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/def.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.h    |   36 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  128 +--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.h    |   25 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  260 +++--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/led.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/led.h   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |  158 ++-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.h   |   30 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/pwrseq.c    |   26 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/reg.h   |   60 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/rf.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/rf.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.c    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/sw.h    |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c |  213 ++--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.h |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |   26 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.h   |   26 +-
 drivers/net/wireless/realtek/rtlwifi/stats.c       |   27 +-
 drivers/net/wireless/realtek/rtlwifi/stats.h       |   26 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   30 +-
 drivers/net/wireless/realtek/rtlwifi/usb.h         |   26 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |   52 +-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c         |    8 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   41 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |    6 -
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   37 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |   24 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |    9 +-
 drivers/net/wireless/rsi/rsi_main.h                |    1 +
 include/linux/ieee80211.h                          |    2 +
 include/net/ieee80211_radiotap.h                   |    6 +
 478 files changed, 8789 insertions(+), 10522 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ftm-responder.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mcu.c
