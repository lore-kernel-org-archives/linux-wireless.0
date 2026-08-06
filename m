Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62CF3CF1FF;
	Thu,  6 Aug 2026 12:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018398; cv=none; b=mG1VKmhe3GSlv9tWrJWH7wSxEqed6RU6q40AdIHvvFQDTGx6uRbAFYaUBZoDq2O42HVydpiWD2BSEuDOrI/ECOlZZqNG5H+vU2AClimS+xAIXew69HTlLsOElQjoQK6+0rvifT0Hy+xPXhnpFvP1pNRwBn6Qd1GRUNV0FfRZsaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018398; c=relaxed/simple;
	bh=7wwdJSnf6OzGmZl5jCNyXDsWajurURWGOU8EfJh8sfA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AtdqclZVVqO8JfLklYpeLHLlfhld87Po1loyvZeKMmeKWBE3dYFevYdTIHMWb1pjsOy+z3mev4bz2kZV7eJl2FxP1YZ7clkSZDVECQvJFDbx/iCt+j2zgSgKQZ8DZgX5uYQABZw1Ygqfx48IFovjoVCTDEaNxtQW/uYX4mKWiF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nWXjENmU; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nWXjENmU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=X4GDSKBG21qU6xjRd16+MkJUPjKptCO53l3IyOheKPk=; t=1786018394; x=1787227994; 
	b=nWXjENmUhlIM8osXMS+Je6EJYlG9Vi6KnZfWJuHDeUogu9DsNuP98D9gTmM25M9AH7qP7zcHITu
	2xc4eZDefv7HLgS1KCvPqJOdNzI7ZbFAIydNkvMxh1tnyjSlpOFPPIYe/V1RTw8VHpIePCRhp3qLA
	uwEydZvLVlt7+Ko8myu2Uf9stPlG+L/CgRQLkMlJ5oY3fx81KmtNbUKodI/nc+Qm1+vZi0hwjCoHk
	X5ZSMOmZwH879TTrcWwkHpWYE2Ie9Q61wfeY2/u65wj5zedWEhnqoS2iSbEhbwPqg9Vl8/bGPnRZs
	A69frp01UWcO9KWl4Hps5LpBTvDI9XNR5ELw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wrwyC-00000004q7q-036j;
	Thu, 06 Aug 2026 14:13:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-next-2026-08-06
Date: Thu,  6 Aug 2026 14:12:35 +0200
Message-ID: <20260806121304.190084-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Last code for this cycle :-)

Nothing really to say - beyond the tag it's mostly
small cleanups and fixes here and there.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit edc84a9396acf1a0e78c46230dd0bcee1b84ac53:

  Merge tag 'wireless-2026-07-26' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next (2026-07-27 16:03:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2026-08-06

for you to fetch changes up to ca800a9302764c445de0da0e84d2252400a770ee:

  wifi: nxpwifi: bound uAP association event IEs to the event buffer (2026-08-06 14:04:51 +0200)

----------------------------------------------------------------
Quite a bunch more work, of note:
 - iwlwifi: new FW version support
 - mt76:
   - mt7928 support
   - mt7925 NAN support
   - mt7996 AP powersave improvements
 - rtw89:
   - LED support
   - RTL8922DE support
   - dual-BT coex for RTL8922D
 - ath12k: AHB platform MultiPD support
 - cfg80211: pre-assign cookies for operations
 - mac80211: AQL support for multicast

----------------------------------------------------------------
Aaradhana Sahu (2):
      wifi: ath12k: add AHB platform descriptor support
      wifi: ath12k: Share RootPD state across UserPDs to avoid duplicate operations

Abdun Nihaal (4):
      wifi: rtlwifi: rtl8192du: Fix possible memory leak in rtl92du_init_sw_vars()
      wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
      wifi: rtw88: Fix potential memory leak in rtw_txq_push_skb()
      wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()

Ahmed Naseef (1):
      wifi: mt76: mt7603: add 0x7592 EEPROM chip ID

Anirudh Srinivasan (2):
      PCI: Move Spacemit vendor and device IDs to linux/pci_ids.h
      wifi: rtw89: pci: enable 36-bit DMA on spacemit K3

Arend van Spriel (13):
      wifi: cfg80211: pre-assign cookie for driver callbacks
      wifi: mac80211: stop using ieee80211_mgmt_tx_cookie()
      wifi: ath6kl: use pre-assigned cookie for remain_on_channel and mgmt_tx
      wifi: wil6210: use pre-assigned cookie for remain_on_channel, mgmt_tx and probe_peer
      wifi: brcmfmac: use pre-assigned cookie for remain_on_channel and mgmt_tx
      wifi: mwifiex: use pre-assigned cookie for remain_on_channel and mgmt_tx
      wifi: wilc1000: use pre-assigned cookie for remain_on_channel and mgmt_tx
      wifi: nxpwifi: use pre-assigned cookie for remain_on_channel and mgmt_tx
      wifi: qtnfmac: use pre-assigned cookie for mgmt_tx
      wifi: rtl8723bs: use pre-assigned cookie for mgmt_tx
      wifi: cfg80211: convert cookie output to input parameter
      wifi: cfg80211: convert tx_control_port cookie to input parameter
      wifi: nl80211: send frame tx status event only for non-zero cookie

Avinash Bhatt (1):
      wifi: iwlwifi: fw: move SAR defines from acpi.h to regulatory.h

Avraham Stern (4):
      wifi: iwlwifi: mld: support aborting an ongoing ftm request
      wifi: iwlwifi: mei: check SAP message length before reading it
      wifi: iwlwifi: mei: skip data read if length is too short
      wifi: iwlwifi: mei: pass correct argument to function

Ayala Beker (1):
      wifi: iwlwifi: mld: drop connection on D3 resume failure

Ben Greear (1):
      wifi: iwlwifi: Clean dangling pointer in tx path

Bitterblue Smith (2):
      wifi: rtw88: 8822c: Don't process RF path C in query_phy_status_page{0,1}
      wifi: rtw88: 8822b: Don't process RF path C in query_phy_status_page1

Bitterblue Smith (S.E.A. Datentechnik GmbH) (1):
      wifi: rtw88: Enable receiving control frames in monitor mode

Bryam Vargas (2):
      wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy
      wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy

Can Peng (2):
      wifi: brcmfmac: validate msgbuf flowring IDs before use
      wifi: brcmfmac: Set DMA direction for msgbuf packet IDs

Chad Monroe (7):
      wifi: mt76: mt7996: fix EAPOL source BSS for non-MLD stations
      wifi: mt76: mt7996: fix non-MLD station num_sta leak
      wifi: mt76: mt7996: select net_setup_tc handler at runtime
      wifi: mt76: fix stuck TX queues after SER with no active interfaces
      wifi: mt76: mt7915: trigger L1 SER on PLE MDP RIOC hang
      wifi: mt76: serialize scan-link teardown with dev->mutex
      wifi: mt76: mt7996: hold dev->mutex in remove_interface teardown

Charlie-cy Wu (3):
      wifi: mt76: mt7921: refactor regd update to fix recursive mutex deadlock
      wifi: mt76: mt7925: add regulatory wiphy self manager support
      wifi: mt76: mt7921: add regulatory wiphy self manager support

Chelsy Ratnawat (1):
      wifi: rtlwifi: rtl8192d: remove dead SMPS rate mask code

Chen Jung Ku (1):
      wifi: rtw88: 8822c: replace msleep() with fsleep() for DPK delays

Chia-Yuan Li (1):
      wifi: rtw89: fw: use MAC source for IO offload delay command

Chih-Kang Chang (6):
      wifi: rtw89: disable sniffer mode in RX filter when initialization for Wi-Fi 7 chips
      wifi: rtw89: pci: disable phy error flag related to refclk
      wifi: rtw89: wow: only WiFi 6 chips initialize RF registers in WoWLAN mode
      wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready
      wifi: rtw89: rfk: update TXIQK H2C command format to v1
      wifi: rtw89: 8922d: bypass TXIQK when scan

Chin-Yen Lee (2):
      wifi: rtw89: wow: use MLD address in WoWLAN ARP replies for MLO stations
      wifi: rtw89: wow: add QoS control field to WoWLAN ARP response for MLO

Ching-Te Ku (63):
      wifi: rtw89: coex: force to exit Wi-Fi LPS while Bluetooth profile exist
      wifi: rtw89: coex: offset current BT info to BT0 for dual BT configuration
      wifi: rtw89: coex: Move wifi related counters to wifi info
      wifi: rtw89: coex: Extend bt_slot_req for dual MAC wifi
      wifi: rtw89: coex: Move Bluetooth related counters to BT info
      wifi: rtw89: coex: Refine third party module related coexistence
      wifi: rtw89: coex: Add TX/RX RF parameter format version 9
      wifi: rtw89: coex: Renaming drvinfo_type to drvinfo_ver
      wifi: rtw89: coex: Add Wi-Fi firmware 0.35.94.1 support for RTL8922D
      wifi: rtw89: coex: Add RTL8922D chip string
      wifi: rtw89: coex: Add Init info version 10
      wifi: rtw89: coex: add rtw89_btc_init() entry for initialization once
      wifi: rtw89: coex: Update TDMA descriptor for dual MAC
      wifi: rtw89: coex: Add Bluetooth binding for Bluetooth TX power setting
      wifi: rtw89: coex: Add Bluetooth binding for Bluetooth RX gain setting
      wifi: rtw89: coex: Add WiFi/Bluetooth adapter binding info
      wifi: rtw89: coex: Add TDMA binding for dual MAC
      wifi: rtw89: coex: Update scoreboard related logic for dual Bluetooth
      wifi: rtw89: coex: Add Co-RX logic
      wifi: rtw89: coex: Add Wi-Fi role info version 10
      wifi: rtw89: coex: Rearrange coexistence control structure
      wifi: rtw89: coex: Update driver outsource info to firmware version 6
      wifi: rtw89: ceox: Update antenna & grant signal setting
      wifi: rtw89: coex: Rearrange Bluetooth firmware report entry
      wifi: rtw89: coex: Refine send firmware command function
      wifi: rtw89: coex: Refine _reset_btc_var()
      wifi: rtw89: coex: Correct SET_RFE settings
      wifi: rtw89: coex: Add firmware report control report v11
      wifi: rtw89: coex: update external control length by case
      wifi: rtw89: coex: Update coexistence version to 9.24.0
      wifi: rtw89: coex: Add version 107 TX/RX info for firmware feature
      wifi: rtw89: coex: Add version 9 report control info
      wifi: rtw89: coex: Fix unexpected grant-signal assignee
      wifi: rtw89: coex: Branch out version 105 firmware report map index
      wifi: rtw89: coex: Refine chip initial related structure
      wifi: rtw89: coex: Add driver info H2C command index version 103
      wifi: rtw89: coex: Fix Wi-Fi role info H2C command header issue
      wifi: rtw89: coex: Add firmware 0.29.133.X support for RTL8852B family
      wifi: rtw89: coex: Add TDMA version 4
      wifi: rtw89: coex: Add slots version 2
      wifi: rtw89: coex: Add cycle status report version 105
      wifi: rtw89: coex: Add wifi role info version 101
      wifi: rtw89: coex: Add firmware 0.27.97.X support for RTL8852C
      wifi: rtw89: coex: Add chip initial info version 11 for RTL8922A/D
      wifi: rtw89: coex: Add Wi-Fi MLO info version 2 H2C command
      wifi: rtw89: coex: Add firmware 0.35.111.X support for RTL8922A/D
      wifi: rtw89: coex: Rearrange _ntfy_role_info info
      wifi: rtw89: coex: Separate _ntfy_role_info into two function
      wifi: rtw89: coex: Decrease Wi-Fi special packet protect time
      wifi: rtw89: coex: complete GPIO debug configuration handler
      wifi: rtw89: coex: Refine RF calibration notify flow
      wifi: rtw89: coex: Fix log dump format with proper newline
      wifi: rtw89: coex: Add BTC report version 8 support for BT sub-reports
      wifi: rtw89: coex: Add dual Bluetooth debug info dump
      wifi: rtw89: coex: Fix TDMA v8 handling to unblock BTC report parsing
      wifi: rtw89: coex: Fix H2C command redundant send & version fall through
      wifi: rtw89: coex: Handle Bluetooth LE-Audio related coexistence feature
      wifi: rtw89: coex: Fix Bluetooth link weight not updated on profile change
      wifi: rtw89: coex: Fix BT-info parsing for 5/6 GHz band & dual Bluetooth
      wifi: rtw89: coex: Clear BT link weight when BT is disabled
      wifi: rtw89: coex: Change Wi-Fi link_mode_v0 translating timing
      wifi: rtw89: coex: Port _update_bt_ctrl_lps() for BT profile-based LPS control
      wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to 9.24.1

Dan Carpenter (1):
      wifi: rtw89: debug: fix off by on in rtw89_ppdu_str()

David Bauer (2):
      wifi: mt76: mt7915: configure noise floor reporting on reset
      wifi: mt76: mt7603: free beacon SKB on error

David Lee (1):
      wifi: rtw89: 8852cu: add quirk to disable 2.4 GHz band

Dawei Feng (2):
      wifi: rtw88: pci: fix resource leak on failed NAPI setup
      wifi: iwlwifi: dvm: fix memory leak in iwl_op_mode_dvm_start()

Devin Wittmayer (5):
      wifi: mt76: mt76x02: do not WARN on invalid rx descriptor length
      wifi: mt76: mt76x02: report rx FCS errors to mac80211
      wifi: mt76: mt7925: ensure tx headroom in usb_sdio_tx_prepare_skb
      wifi: mt76: mt7925: cancel mlo_pm_work on stop
      wifi: mt76: mt792x: do not advertise active monitor

Dian-Syuan Yang (2):
      wifi: rtw89: drop packet offload entry on H2C addition failure to avoid scan issue
      wifi: rtw89: refine RX filter configuration for WiFi 7 generation

Dmitry Antipov (2):
      wifi: mac80211: simplify airtime_flags_write()
      wifi: mt76: mt7915: simplify mt7915_sys_recovery_set()

Dmitry Gomzyakov (1):
      wifi: mt76: connac: add MT7991A (0x7991) to is_mt7996()

Dmitry Morgun (1):
      wifi: rtw89: check return values in rtw89_ops_start_ap()

Doruk Tan Ozturk (1):
      wifi: ath6kl: clamp assoc request/response lengths before subtracting IE offsets

Eason Lai (3):
      wifi: mt76: mt792x: fix use-after-free in mt76_rx_poll_complete
      wifi: mt76: mt7921: Add PCIe AER handler support to prevent system crash
      wifi: mt76: mt792x: Fix memory leak in SDIO TX path

Emery Hsin (21):
      wifi: mt76: mt792x: consolidate rx interrupt masks into all_complete_mask
      wifi: mt76: connac2: apply new rx all_complete_mask
      wifi: mt76: mt7925: replace shared rx irq masks with per-chip definitions
      wifi: mt76: mt7925: add MT7927 per-chip rx irq definitions
      wifi: mt76: mt792x: add per-chip PCIe register struct
      wifi: mt76: connac2: add per-chip PCIe register definitions
      wifi: mt76: mt7925: add per-chip PCIe register definitions
      wifi: mt76: mt792x: replace shared PCIe MAC macros with per-chip struct
      wifi: mt76: mt792x: rename WFDMA DMASHDL enable bit to follow the convention
      wifi: mt76: mt7925: rename WTBL registers to chip-specific format
      wifi: mt76: mt792x: add tx_done ring to common DMA queue allocation
      wifi: mt76: connac3: update basic rate table starting index
      wifi: mt76: mt7925: fix MMIO dynamic remap window size
      wifi: mt76: mt7925: add MT7928 FWDL support
      wifi: mt76: mt7925: add MT7928 irq_map with chip-specific rx masks
      wifi: mt76: mt7925: add MT7928 DMA configuration
      wifi: mt76: mt7925: add MT7928 TXD/TXS/TX_DONE support
      wifi: mt76: mt7925: add MMIO register remapping table for MT7928
      wifi: mt76: mt7925: align scan IE and EFUSE TLV lengths to 4 bytes for MT7928
      wifi: mt76: mt7925: add MT7928 per-chip PCIe register definitions
      wifi: mt76: mt7925: add MT7928 PCIe support

Emmanuel Grumbach (16):
      wifi: iwlwifi: mvm: fix the FCS truncation logic in d3
      wifi: iwlwifi: mld: treat valid BAID without STA as a FW error
      wifi: iwlwifi: mvm: validate monitor notif link_id
      wifi: iwlwifi: mld: validate D3_END notif size
      wifi: iwlwifi: pcie: validate txq_id in txq_enable
      wifi: iwlwifi: mvm: reset the smart fifo state upon FW stop
      wifi: iwlwifi: mvm: cleanup the driver state after device_powered_off
      wifi: iwlwifi: mld: reset the driver state upon firmware recovery
      wifi: iwlwifi: mld: validate WoWLAN notif header
      wifi: iwlwifi: fix counter type in iwl_fwrt_dump_error_logs
      wifi: iwlwifi: mld: fix validation fallback in iwl_mld_notif_is_valid
      wifi: iwlwifi: mvm: fix off-by-one in TXF key sanitiser
      wifi: iwlwifi: guard against division by zero in iwl_dbg_tlv_alloc_fragments
      wifi: iwlwifi: mld: validate wake packet crypto overhead
      wifi: iwlwifi: mld: initialize scan-abort status
      wifi: iwlwifi: mvm: ignore sync frames when sync is disabled

Eric Huang (5):
      wifi: rtw89: 8922d: remove CCK bandwidth compensation
      wifi: rtw89: 8922d: dynamic adjust channel smoothing
      wifi: rtw89: 8922d: fix EMLSR BB switch sequence for MLO mode transition
      wifi: rtw89: phy: fix bandedge primary channel for 2.4GHz 40MHz and 6GHz
      wifi: rtw89: pack I/O during bb_sethw to reduce API execution time

Ethan Nelson-Moore (2):
      wifi: mt76: mt7925: remove code guarded by nonexistent config option
      wifi: mt76: mt7996: remove code guarded by nonexistent config option

Fabio Estevam (2):
      wifi: mwifiex: Detach sync cmd buffer on interrupted wait
      wifi: mwifiex: Remove WQ_HIGHPRI from main workqueue

Fan Wu (1):
      wifi: rtl8xxxu: fix use-after-free from rx_urb_wq on stop

Felix Fietkau (59):
      wifi: mac80211: factor out part of ieee80211_calc_expected_tx_airtime
      wifi: mac80211: estimate expected throughput if not provided by driver/rc
      wifi: mac80211: add AQL support for multicast packets
      wifi: mac80211: add ieee80211_txq_aql_pending()
      wifi: mt76: mt7996: validate RX band_idx before dereferencing phys[]
      wifi: mt76: mt7996: set MT76_MCU_RESET before waking MCU waiters on full reset
      wifi: mt76: mt7915: clear wcid mask under mutex after RCU pointer clear
      wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss
      wifi: mt76: mt7996: don't report a zero TX bitrate
      wifi: mt76: mt7915: write RX header translation bit to the correct register
      wifi: mt76: fix 4th chain ACK RSSI bitmask in sta_poll
      wifi: mt76: mt7996: fix TX DMA mapping leak for AddBA req frames
      wifi: mt76: fix stranded frames in mt76_txq_schedule_pending
      wifi: mt76: allow TX aggregation on the VO queue
      wifi: mt76: fix uninitialised RXDMAD_C descriptor info
      wifi: mt76: fix RXDMAD_C buffer recycling race
      wifi: mt76: mt7915: poll the correct SLP CTRL register for the second adie
      wifi: mt76: fix HE DCM max-RU capability encoding
      wifi: mt76: mt7996: bound TLV walk in mt7996_mcu_get_chip_config
      wifi: mt76: fix out-of-bounds access in mmio copy helpers
      wifi: mt76: mt7915: unwind state on add_interface failure
      wifi: mt76: mt7996: hold dev->mt76.mutex while disabling tx worker in SER
      wifi: mt76: decode the full VHT Rx STBC capability field
      wifi: mt76: fix ER-SU 106-tone RU check in RX rate decode
      wifi: mt76: mt7996: reserve space for the CSA-abort countdown TLV
      wifi: mt76: mt7996: don't leak MLD group index on remap alloc failure
      wifi: mt76: cancel reset and rc work on device unregister
      wifi: mt76: report data NSS for STBC frames in RX rate decode
      wifi: mt76: mt7915: use little-endian for bss_info_ra wire fields
      wifi: mt76: only consume the WO drop bit on WED v2 devices
      wifi: mt76: mt7915: unlink TWT flow if the MCU rejects the agreement
      wifi: mt76: mt7996: skip key upload when adding an offchannel link
      wifi: mt76: mt7996: wake MCU waiters before aborting scan in L1 SER
      wifi: mt76: fix queue reg access when building WED and NPU together
      wifi: mt76: mt7615: fix NULL deref in mt7615_mac_set_rates
      wifi: mt76: mt7996: free vif links after clearing wcid entries on full reset
      wifi: mt76: mt7996: clear stale link state on full reset
      wifi: mt76: set MT76_SCANNING when starting a hw scan
      wifi: mt76: mt7996: fix MIB TX aggregation counter registers for mt7990
      wifi: mt76: mt7915: fix double hif2 init on the non-WED path
      wifi: mt76: mt7915: fix ext PHY use-after-free on register error path
      wifi: mt76: mt7915: release hif2 reference on probe IRQ failure
      wifi: mt76: mt7996: do not attach hif2 WED when the main WED attach failed
      wifi: mt76: mt7996: do not leave state behind after a failed WED attach
      wifi: mt76: mt7915: fix chainmask handling for non-dbdc phys on band 1
      wifi: mt76: mt7915: report RX chain signal for all RX paths
      wifi: mt76: mt7915: update SKU power limits after changing antennas
      wifi: mt76: mt7925: fix infinite loop in UNI event TLV parsing
      wifi: mt76: add PS buffering support for HW-managed TIM drivers
      wifi: mt76: mt7915: handle MCU PS sync events
      wifi: mt76: mt7996: handle UNI PS sync events
      wifi: mt76: set the EOSP bit in the QoS header of the last released frame
      wifi: mt76: mt7603: fix U-APSD service period termination
      wifi: mt76: mt7603: tell mac80211 when the PS queue has run empty
      wifi: mt76: mt7603: restore hardware PS buffering after a service period
      wifi: mt76: mt7603: file buffered frames under the TID reported to mac80211
      wifi: mt76: reject out-of-range link ids in mt76_vif_link()
      wifi: mt76: mt7996: fix out-of-bounds link array access in mt7996_tx()
      wifi: mac80211: skip default WMM setup for AP_VLAN links

Filip Bakreski (1):
      wifi: mt76: mt76u: use a threaded NAPI for the RX path

Geert Uytterhoeven (2):
      wifi: nxp: NXPWIFI should be invisible and selected by its users
      wifi: morsemicro: MM81X should be invisible and selected by its users

GuoHan Zhao (1):
      wifi: rtw89: wow: fix unsupported cipher debug messages

Haoxiang Li (1):
      iwlwifi: dvm: add missing cleaup for on error path

Howard Hsu (1):
      wifi: mt76: mt7996: reject iTWT setup requests from MLD stations

Ilan Peer (1):
      wifi: iwlwifi: mld: Do not cleanup FW state when the device is dead

JB Tsai (1):
      wifi: mt76: mt7925: Fix unregister deadlock

Jared.Huang (2):
      wifi: mt76: mt7925: update clc before setting sar power table
      wifi: mt76: mt7925: fix msg len mismatch between driver and firmware

Jason Huang (1):
      wifi: brcmfmac: fix P2P action frame handling without device vif

Jeff Chen (1):
      wifi: nxpwifi: fix multiple static analysis errors and warnings

Jeff Hsu (1):
      wifi: mt76: mt7925: skip DMA re-init selectively

Jeff Johnson (8):
      wifi: ath12k: fix overreads in ath12k_wmi_process_csa_switch_count_event()
      wifi: ath11k: fix overreads in ath11k_wmi_process_csa_switch_count_event()
      wifi: ath12k: validate TLV length in process_tpc_stats()
      wifi: ath12k: move firmware_mode enum to qmi.h
      wifi: ath12k: rename firmware_mode enum members to use QMI namespace
      wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()
      wifi: ath11k: fix stride mismatch in mac_phy_caps_parse()
      wifi: ath11k: fix leak in ath11k_service_ready_ext_event()

Johannes Berg (12):
      wifi: iwlwifi: mvm: remove iwl_mvm_recalc_tcm()
      wifi: iwlwifi: claim UHR DBE capability for UHR devices
      wifi: iwlwifi: mvm/mld: fix PPE threshold debug print loop
      Merge tag 'iwlwifi-next-2026-07-23' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Revert "wifi: mac80211: don't encrypt pre-auth (ETH_P_PREAUTH) frames"
      wifi: mac80211: fix RCU dereference in throughput estimate
      wifi: mac80211: fix RCU usage in peer probing
      Merge tag 'mm81x-next-2026-07-31' of https://github.com/MorseMicroLabs/linux-wireless
      Merge tag 'mt76-next-2026-08-01' of https://github.com/nbd168/wireless
      Merge tag 'rtw-next-2026-08-02' of https://github.com/pkshih/rtw
      wifi: mac80211: disconnect on CSA to channel 0
      Merge tag 'ath-next-20260803' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath

Johnson Tsai (2):
      wifi: rtw89: add LED support to reflect the wireless association status
      wifi: rtw89: add multicolor LED support for RTL8852CU valve board

Jose Ignacio Tornos Martinez (1):
      wifi: mt76: mt7996: remove beacon_int_min_gcd from ADHOC interface combinations

Kenneth Kasilag (1):
      wifi: mt76: mt7996: expose per-band MAC addresses to cfg80211

Laxman Acharya Padhya (2):
      wifi: mt76: mt7921: validate CLC firmware records
      wifi: mt76: mt7996: validate default EEPROM firmware size

Linghui Wu (2):
      wifi: ath10k: filter non-UTF testmode events
      wifi: ath10k: snoc: use memcpy_fromio() for MSA ramdump

Linmao Li (4):
      wifi: nxpwifi: reject zero-length extension elements in beacon IEs
      wifi: mm81x: prevent timers from outliving teardown
      wifi: nxpwifi: detach sync command buffer on interrupted wait
      wifi: nxpwifi: bound uAP association event IEs to the event buffer

Mariano Baragiola (1):
      wifi: wilc1000: validate monitor transmit frame headers

Michael-CY Lee (2):
      wifi: mt76: fix non-AQL packet accounting for MLO stations
      wifi: mt76: assign link_id when sending probe request during scan

Mihail Dimoski (1):
      wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming A15 FA506II

Miri Korenblit (6):
      wifi: iwlwifi: add a compile time check for too long hcmds
      wifi: iwlwifi: support TTL platform device ID
      wifi: iwlwifi: mld: cancel wiphy work before freeing wiphy
      wifi: iwlwifi: mld: add PNVM_INIT_COMPLETE_NTFY to the hcmd names
      wifi: iwlwifi: mld: move BIOS reading code to where it belongs
      wifi: iwlwifi: bump core version for BZ/SC/DR

Pagadala Yesu Anjaneyulu (7):
      wifi: iwlwifi: ignore raw-DSM TLV for LARI cmd version 13 and above
      wifi: iwlwifi: regulatory: add LARI_CONFIG_CHANGE command v14 support
      wifi: iwlwifi: mld: honor FW puncturing capability in MCC response
      wifi: iwlwifi: mvm: add LARI_CONFIG_EXTENSION command
      wifi: iwlwifi: mld: support update_mcc notification v2
      wifi: iwlwifi: mld: add debug log after AP type command
      wifi: iwlwifi: regulatory: add LARI v15 DSM support bitmap

Panagiotis Petrakopoulos (1):
      wifi: rtw89: use str_enable_disable() helper

Pavankumar Nandeshwar (2):
      wifi: ath12k: Use different RX release ring sizes as per memory profiles
      wifi: ath12k: skip MLO multicast links during crash recovery in Tx path

Pengpeng Hou (3):
      wifi: rtw89: fix HE extended capability length check
      wifi: iwlwifi: validate PNVM SKU TLV length
      wifi: iwlwifi: validate UEFI reduced-power SKU TLV length

Peter Chiu (4):
      wifi: mt76: mt7996: fix MLD ID in MAC TXD and HIF TXP
      wifi: mt76: mt7996: add mcu command to set bssid mapping address
      wifi: mt76: mt7996: leave PS when a 4-address connection is established
      wifi: mt76: fix queue assignment for disassoc packets

Ping-Ke Shih (24):
      wifi: rtw89: fw: add first set of firmware features by version for RTL8922D
      wifi: rtw89: fw: support scan offload v2 for WiFi 7 chips
      wifi: rtl8xxxu: 8723bu: remove reference of non-existing firmware rtl8723bu_bt.bin
      wifi: rtw89: mac: finish active TX immediately without waiting for DMAC
      wifi: rtw89: mac: pass chip version to firmware
      wifi: rtw89: fw: lower debug level for UDM1 debug register
      wifi: rtw89: 8922d: set TX compensation by format v2
      wifi: rtw89: efuse: no need to export rtw89_efuse_read_ecv_be()
      wifi: rtw89: efuse: read thermal calibration value for RTL8922D
      wifi: rtw89: 8922d: read default digital voltage calibration values
      wifi: rtw89: add thermal protect by digital voltage reduction
      wifi: rtw89: 8922d: set ANA CLK enter to 500KHz
      wifi: rtw89: 8922d: update scaling factor for RX path
      wifi: rtw89: phy: add NCTL check for WiFi 7 chips
      wifi: rtw89: unify access struct of TX power track tables
      wifi: rtw89: set needed firmware elements for early chips transition
      wifi: rtw89: mac: abstract register definition of firmware boot debug
      wifi: rtw89: 8922d: add TX time limit for 2GHz band
      wifi: rtw89: fw: do bb_preinit before downloading firmware
      wifi: rtw89: wow: extend timeout unit to avoid SER false alarm
      wifi: rtw89: pci: set PCIe maximum TS1 for RTL8922DE
      wifi: rtw89: 8922d: reduce IO in power-on function
      wifi: rtw89: phy: set CFR to manual mode for some 2GHz channels
      wifi: rtw89: 8922d: enable Makefile and Kconfig for RTL8922DE

Po-Hao Huang (2):
      wifi: rtw89: fix scan offload version check logic
      wifi: rtw89: change scan offload format to V3 for WiFi 7 IC

Prashant Rahul (1):
      wifi: mt76: mt7921: fix memory leak when skb_linearize fails in mcu rx event

Praveen Rajendran (1):
      wifi: iwlwifi: fw: Fix spelling typo in error-dump.h

Randy Dunlap (1):
      rfkill: repair malformed kernel-doc and add some descriptions

Reshma Immaculate Rajkumar (1):
      wifi: ath12k: fix encrypted EAPOL TX in encap offload mode

Rex Lu (2):
      wifi: mt76: fix RX data queuing of RRO 3.0
      wifi: mt76: check txfree done event on the WED hw path

Rosen Penev (1):
      wifi: nxpwifi: embed rx_reorder_ptr

Runyu Xiao (2):
      wifi: rtlwifi: rtl8192du: check QoS TID before indexing tids
      wifi: mt76: mt7615: avoid waiting for mac work under the mt76 mutex

Ryan Leung (1):
      wifi: mt76: mt7915: add thermal zone device registration

Sang-Heon Jeon (3):
      wifi: rtlwifi: rtl8821ae: remove conditional return with no effect in _rtl8821ae_llt_write()
      wifi: rtw89: remove conditional return with no effect in sys_init_*()
      wifi: ath6kl: return 0 explicitly in ath6kl_init_upload()

Sean Wang (18):
      wifi: mt76: mt792x: advertise mgmt frame registration
      wifi: mt76: mt7925: guard BSS capability lookups
      wifi: mt76: connac: add NAN connection type
      wifi: mt76: mt7925: add NAN MCU helpers
      wifi: mt76: mt7925: add NAN MCU handling
      wifi: mt76: add init_wiphy callback
      wifi: mt76: mt7925: wire up NAN operations
      wifi: mt76: mt792x: build iface combinations dynamically
      wifi: mt76: mt792x: advertise NAN data support
      wifi: mt76: mt7925: stop init retries on hung bus
      wifi: mt76: mt7925: skip reset work on hung bus
      wifi: mt76: mt792x: stop USB register access after bus hang
      wifi: mt76: mt792x: drain USB UDMA before WFSYS reset
      wifi: mt76: mt792x: enable USB UDMA TX timeout
      wifi: mt76: mt792x: quiesce USB paths on disconnect
      wifi: mt76: mt7927: set band index for sniffer mode
      wifi: mt76: mt7927: use real monitor vifs for dual-band monitors
      wifi: mt76: mt7925: support new WoW pattern TLV

Shahar Tzarfati (1):
      wifi: iwlwifi: mld: fix read in wake packet notification handler

Shayne Chen (2):
      wifi: mt76: fix handling channel context with different bands in mt76_switch_vif_chanctx()
      wifi: mt76: mt7996: fix capability of EHT-MCS 15 in MRU

Slawomir Stepien (1):
      wifi: zd1211rw: reject secondary interfaces to prevent conflicts

Srinivas Achary (1):
      wifi: cfg80211: change mesh_setup::ie_len to size_t

Stanislaw Gruszka (1):
      wifi: rtl818x: initialize eeprom_93cx6 struct to zero

StanleyYP Wang (4):
      wifi: mt76: mt7996: add missing rdd_idx check when enabling background radar
      wifi: mt76: mt7996: fix reg addr remap when addr is 0
      wifi: mt76: mt7996: remove repeater muar config
      wifi: mt76: mt7996: add scan dwell time hw cap

Stefan Hansson (1):
      wifi: rsi: Fix types to appease CFI

Wentao Guan (2):
      wifi: rtw89: fw: correct preload field of w2 in rtw89_fw_h2c_default_cmac_tbl_be()
      wifi: mt76: mt7925: cancel pending mlo_pm_work

William Hansen-Baird (4):
      wifi: rtlwifi: rtl8723be: Remove unnecessary irq save/restore in hw_init()
      wifi: rtlwifi: fix disabling of ASPM for RTL8723BE with AER flooding
      wifi: rtlwifi: convert pci if-statement to ID table
      wifi: rtlwifi: disable ASPM for RTL8723BE with subsystem ID 17aa:b736

Yuhang.chen (1):
      wifi: rtw89: pci: add .shutdown callback to stop rfkill polling on reboot

Zhao Li (5):
      wifi: mac80211: fix per-STA profile length in cross-link CSA parsing
      wifi: mac80211: send TWT teardown to peer after setup TX failure
      wifi: nl80211: clean up color-change beacon data on errors
      wifi: mac80211: skip unused probe response countdown offsets
      wifi: cfg80211: stop PMSR before P2P and NAN teardown

ZhaoJinming (1):
      wifi: ath11k: fix resource leak on error in ext IRQ setup

Zhi-Jun You (2):
      wifi: mt76: wed: fix kernel panic on non-DBDC MT7986
      wifi: mt76: mt7915: fix net_fill_forward_path for non-DBDC mt7986

Zong-Zhe Yang (5):
      wifi: rtw89: fw: fix link ID filling for LPS MLO common info
      wifi: rtw89: introduce helper to get tx shape index
      wifi: rtw89: add tx shape v0 to keep built-in arrays compatible during transitions
      wifi: rtw89: extend tx shape format for regulatory 6 GHz power type
      wifi: rtw89: debug: add diagnosis for RF

shengwei.lu (1):
      wifi: mt76: mt7925: Fix EHT Beamformee SS subfields to meet 802.11be minimum

 drivers/net/wireless/ath/ath10k/snoc.c             |    9 +-
 drivers/net/wireless/ath/ath10k/testmode.c         |   14 +
 drivers/net/wireless/ath/ath11k/ahb.c              |   79 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   30 +-
 drivers/net/wireless/ath/ath12k/ahb.c              |  215 +-
 drivers/net/wireless/ath/ath12k/ahb.h              |   34 +-
 drivers/net/wireless/ath/ath12k/core.c             |    7 +-
 drivers/net/wireless/ath/ath12k/core.h             |   11 +-
 drivers/net/wireless/ath/ath12k/dp.c               |    2 +-
 drivers/net/wireless/ath/ath12k/dp.h               |    3 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |   46 +
 drivers/net/wireless/ath/ath12k/dp_tx.h            |    2 +
 drivers/net/wireless/ath/ath12k/hw.h               |    1 -
 drivers/net/wireless/ath/ath12k/mac.c              |    2 +-
 drivers/net/wireless/ath/ath12k/pci.c              |    3 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |    8 +-
 drivers/net/wireless/ath/ath12k/qmi.h              |   14 +-
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c        |   90 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c      |   64 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |    3 +
 drivers/net/wireless/ath/ath12k/wmi.c              |   32 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |   27 +-
 drivers/net/wireless/ath/ath6kl/core.h             |    5 +-
 drivers/net/wireless/ath/ath6kl/init.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c             |    1 +
 drivers/net/wireless/ath/ath6kl/txrx.c             |    1 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h              |    1 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   12 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |    2 +-
 drivers/net/wireless/ath/wil6210/p2p.c             |    6 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |    4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   12 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |    2 +-
 .../broadcom/brcm80211/brcmfmac/cyw/core.c         |    8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |   47 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   14 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.h |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |    5 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   51 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |    6 +
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.h |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   28 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    8 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   33 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |   22 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |   28 +-
 drivers/net/wireless/intel/iwlwifi/mld/agg.c       |    9 +-
 drivers/net/wireless/intel/iwlwifi/mld/d3.c        |  136 +-
 .../net/wireless/intel/iwlwifi/mld/ftm-initiator.c |   21 +
 .../net/wireless/intel/iwlwifi/mld/ftm-initiator.h |    1 +
 drivers/net/wireless/intel/iwlwifi/mld/hcmd.h      |    9 +-
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c  |   19 +-
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.h  |    2 +
 drivers/net/wireless/intel/iwlwifi/mld/mcc.c       |   26 +-
 drivers/net/wireless/intel/iwlwifi/mld/mld.c       |    7 +-
 drivers/net/wireless/intel/iwlwifi/mld/mld.h       |    2 -
 drivers/net/wireless/intel/iwlwifi/mld/notif.c     |    5 +-
 .../net/wireless/intel/iwlwifi/mld/regulatory.c    |   90 +-
 drivers/net/wireless/intel/iwlwifi/mld/scan.c      |    3 +-
 drivers/net/wireless/intel/iwlwifi/mld/sta.c       |    5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   36 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   23 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h |    4 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   54 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |    1 +
 .../wireless/intel/iwlwifi/pcie/gen1_2/tx-gen2.c   |    2 +
 .../net/wireless/intel/iwlwifi/pcie/gen1_2/tx.c    |   11 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   20 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    4 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   12 +
 drivers/net/wireless/mediatek/mt76/channel.c       |   98 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   48 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |  112 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   20 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |   12 +-
 drivers/net/wireless/mediatek/mt76/mmio.c          |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   11 +
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |    2 +
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |    1 +
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   73 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   89 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    4 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    5 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |    5 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   16 +-
 .../net/wireless/mediatek/mt76/mt76_connac3_mac.h  |   42 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    8 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  267 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   47 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    5 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   41 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   34 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   25 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   43 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   20 +
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |    2 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   35 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  112 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regd.c   |  219 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regd.h   |   57 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    5 +
 drivers/net/wireless/mediatek/mt76/mt7925/Makefile |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |   37 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |  241 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.h    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |  279 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  267 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.h    |   43 +
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |    9 +
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c    | 1098 +++
 drivers/net/wireless/mediatek/mt76/mt7925/nan.h    |  421 ++
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |  305 +-
 .../net/wireless/mediatek/mt76/mt7925/pci_mac.c    |    8 +-
 .../net/wireless/mediatek/mt76/mt7925/pci_mcu.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/regd.c   |  250 +-
 drivers/net/wireless/mediatek/mt76/mt7925/regd.h   |   57 +
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h   |   67 +-
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |    8 +
 drivers/net/wireless/mediatek/mt76/mt792x.h        |   85 +-
 drivers/net/wireless/mediatek/mt76/mt792x_core.c   |  146 +-
 drivers/net/wireless/mediatek/mt76/mt792x_dma.c    |  124 +-
 drivers/net/wireless/mediatek/mt76/mt792x_regs.h   |   25 +-
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c    |  138 +-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |    6 +
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   30 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   96 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   75 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  205 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   42 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   93 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |   24 +-
 drivers/net/wireless/mediatek/mt76/scan.c          |   26 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |   11 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  102 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   75 +-
 drivers/net/wireless/mediatek/mt76/wed.c           |    7 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   19 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |   30 +-
 drivers/net/wireless/morsemicro/mm81x/Kconfig      |    8 +-
 drivers/net/wireless/morsemicro/mm81x/mac.c        |    2 +-
 drivers/net/wireless/morsemicro/mm81x/rc.c         |    2 +-
 drivers/net/wireless/morsemicro/mm81x/yaps.c       |    2 +-
 drivers/net/wireless/nxp/nxpwifi/11ax.c            |    5 +-
 drivers/net/wireless/nxp/nxpwifi/11n.c             |    7 +-
 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c   |   23 +-
 drivers/net/wireless/nxp/nxpwifi/Kconfig           |    5 +-
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c        |   34 +-
 drivers/net/wireless/nxp/nxpwifi/main.c            |    2 +-
 drivers/net/wireless/nxp/nxpwifi/main.h            |   23 +-
 drivers/net/wireless/nxp/nxpwifi/scan.c            |    3 +
 drivers/net/wireless/nxp/nxpwifi/sdio.c            |    3 +-
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c         |   12 +
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c         |   10 +
 drivers/net/wireless/nxp/nxpwifi/uap_event.c       |   22 +-
 drivers/net/wireless/nxp/nxpwifi/uap_txrx.c        |    4 +-
 drivers/net/wireless/nxp/nxpwifi/util.c            |   51 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |    4 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |    2 +-
 drivers/net/wireless/realtek/rtl8xxxu/8723b.c      |   11 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |   20 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |   49 +-
 .../wireless/realtek/rtlwifi/rtl8192d/hw_common.c  |   21 +-
 .../net/wireless/realtek/rtlwifi/rtl8192du/sw.c    |   12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192du/trx.c   |    3 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    6 -
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |    7 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |    6 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    8 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    1 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   14 +-
 drivers/net/wireless/realtek/rtw88/rtw8723x.c      |    3 +-
 drivers/net/wireless/realtek/rtw88/rtw8814a.c      |    3 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    4 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |    3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    9 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   15 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c      |    3 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |    1 +
 drivers/net/wireless/realtek/rtw89/Kconfig         |   29 +
 drivers/net/wireless/realtek/rtw89/Makefile        |    9 +
 drivers/net/wireless/realtek/rtw89/coex.c          | 7136 ++++++++++++--------
 drivers/net/wireless/realtek/rtw89/coex.h          |  155 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  128 +-
 drivers/net/wireless/realtek/rtw89/core.h          | 1397 +++-
 drivers/net/wireless/realtek/rtw89/debug.c         |  124 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/efuse.h         |    7 +
 drivers/net/wireless/realtek/rtw89/efuse_be.c      |  117 +-
 drivers/net/wireless/realtek/rtw89/fw.c            | 1522 ++++-
 drivers/net/wireless/realtek/rtw89/fw.h            |  366 +-
 drivers/net/wireless/realtek/rtw89/led.c           |  139 +
 drivers/net/wireless/realtek/rtw89/led.h           |   37 +
 drivers/net/wireless/realtek/rtw89/led_mc.c        |   81 +
 drivers/net/wireless/realtek/rtw89/mac.c           |   71 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   52 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   38 +-
 drivers/net/wireless/realtek/rtw89/mac_be.c        |   87 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   17 +
 drivers/net/wireless/realtek/rtw89/pci.h           |    6 +-
 drivers/net/wireless/realtek/rtw89/pci_be.c        |   11 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   95 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |   28 +-
 drivers/net/wireless/realtek/rtw89/phy_be.c        |   53 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |  100 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b.c      |  146 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c  |   22 +-
 .../net/wireless/realtek/rtw89/rtw8851b_table.c    |   23 +-
 .../net/wireless/realtek/rtw89/rtw8851b_table.h    |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8851be.c     |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   91 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |   36 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    |   27 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.h    |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852au.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   80 +-
 .../net/wireless/realtek/rtw89/rtw8852b_common.c   |    7 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c  |   36 +-
 .../net/wireless/realtek/rtw89/rtw8852b_table.c    |   31 +-
 .../net/wireless/realtek/rtw89/rtw8852b_table.h    |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852bt.c     |   80 +-
 drivers/net/wireless/realtek/rtw89/rtw8852bte.c    |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   87 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |  101 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    |   39 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.h    |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852cu.c     |   57 +-
 drivers/net/wireless/realtek/rtw89/rtw8922a.c      |  142 +-
 drivers/net/wireless/realtek/rtw89/rtw8922ae.c     |    3 +
 drivers/net/wireless/realtek/rtw89/rtw8922au.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8922d.c      |  521 +-
 drivers/net/wireless/realtek/rtw89/rtw8922de.c     |    3 +
 drivers/net/wireless/realtek/rtw89/wow.c           |   27 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c            |    3 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |    7 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |    3 +-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c         |    7 +-
 drivers/net/wireless/rsi/rsi_common.h              |    2 +-
 drivers/net/wireless/rsi/rsi_sdio.h                |    2 +-
 drivers/net/wireless/rsi/rsi_usb.h                 |    2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |    8 +
 drivers/pci/controller/dwc/pcie-spacemit-k1.c      |    3 -
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |    7 +-
 include/linux/pci_ids.h                            |    4 +
 include/linux/rfkill.h                             |    9 +-
 include/net/cfg80211.h                             |   17 +-
 include/net/mac80211.h                             |   14 +-
 net/mac80211/airtime.c                             |   87 +-
 net/mac80211/cfg.c                                 |   20 +-
 net/mac80211/debugfs.c                             |   32 +-
 net/mac80211/ieee80211_i.h                         |   18 +-
 net/mac80211/link.c                                |    3 +-
 net/mac80211/main.c                                |    1 +
 net/mac80211/mlme.c                                |    2 +-
 net/mac80211/offchannel.c                          |   27 +-
 net/mac80211/s1g.c                                 |    2 +-
 net/mac80211/spectmgmt.c                           |   11 +-
 net/mac80211/sta_info.c                            |   66 +-
 net/mac80211/sta_info.h                            |    3 +-
 net/mac80211/status.c                              |    5 +-
 net/mac80211/tdls.c                                |    2 +-
 net/mac80211/tx.c                                  |  107 +-
 net/wireless/core.c                                |    3 +
 net/wireless/core.h                                |    2 +-
 net/wireless/mlme.c                                |    2 +-
 net/wireless/nl80211.c                             |   28 +-
 net/wireless/rdev-ops.h                            |   16 +-
 300 files changed, 16510 insertions(+), 5415 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/nan.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/nan.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/led.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/led.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/led_mc.c
