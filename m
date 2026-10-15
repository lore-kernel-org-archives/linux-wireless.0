Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDA34D7D4D;
	Thu, 15 Oct 2026 10:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792061452; cv=none; b=hpLRmFD7lYPrlMqXnSE/UtWF9zoC1T4vOaw4R2wuTfAWQBpvHyZdvOz3UO0OQbGuC3sm6e1h9yeD+BrBVWQAYDkEUBVShPLma5fSmv2rrfZNqAgElJ+YT3LbXyf82jk32y6SFvPJyF0IVvc8L/O+ykVT+OFSb+e5iEOb5pA0PYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792061452; c=relaxed/simple;
	bh=b11Zi1varZ7pXGcY1PnedcANXAcqX1pKhCi5cRPO4Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=tEtZ3Xn8Po4nquSHaGqQCCig24EnI3mWYazM5ywAhIcrAURWQonegTlJtsRPMXT9yzV+xBbnwvmXNj95LaHaSNiAbHjSQjZKYD0APuojdiprYAv+N7Uo/kPZrAEnaZXj9Mz3EdgJguS2AUtxTzAktOnBTJzPAuWRPYNplviVfeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rsV4bVyh; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rsV4bVyh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=Dx1nI988PQQgvubvZmbA70aS9eIilmKkOnsh8zmStiM=; t=1792061441; x=1793271041; 
	b=rsV4bVyheNv7pT3Oiwywdv322Yq1KWLE9aD2ulCdTRPBLQ3I8KnqgyMg7L0iyvyq7HNs1C7BcnI
	2ZEOugffygzFYwhrcvr9cR3OwPmxfDQ1vnThfIzUJRuikKkW4MSna5mwIIzfzQ9yU2WuzYf9WdGqf
	7yiFAajl03ehfO+bxuV1TV+koXdez0uG3wS/vr6ukp3ldlm8s2jT2q8WAfyQMdmSd9qsrjI+X6Z5y
	3FnQtxYusnuI/ZF2WCWIDESAbWGiO5DE1fuwhjtUHjkS22kTgJ0PHVNjiYHx62T46g3y6EsP6EcwO
	jSp2d/PWYQ8luATBrVALb1bB2vHghXDL8HPA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xHJ2k-00000003SmB-0rWx;
	Thu, 15 Oct 2026 12:50:38 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-next-2026-10-15
Date: Thu, 15 Oct 2026 12:47:49 +0200
Message-ID: <20261015105035.137870-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned

Hi,

Quite a lot of content, some drivers came quite late
with a lot of content, I've asked them to send stuff
earlier... But there's the promised RTNL reduction
here now, after some shaking down.

There's an open 0-day bot report on a smatch warning,
I believe it to be a false positive, but might add a
change to suppress it later.

The biggest change is deleting a staging driver that
we replaced (Greg says he's OK with that) which may
cause merge conflicts, obviously the solution is to
just delete it.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit d8674294aefef02266c4d47ad10131f1bffbe534:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-08 22:21:56 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2026-10-15

for you to fetch changes up to a4190accbf7e05496754004bb701fb3e7d04e57f:

  wifi: cfg80211: fix potential requested_regd leak (2026-10-14 12:19:59 +0200)

----------------------------------------------------------------
Lots of updates:
 - mt76
   - mt7625 NAN fixes
   - mt7996 connection monitor fix
   - offchannel/scan improvements
   - MLO fixes
 - rtw88
   - RTL8723BS support
   - SDIO TX performance improvements
 - rtw89
   - P2P_DEVICE support
   - BT-coex updates
 - mm81x
   - monitor mode support
   - rx improvements
   - fix persistent NO_IR flag bug
 - iwlwifi
   - UHR sniffer support
   - support for newer UEFI/BIOS
 - cfg80211/mac80211
   - latency improvements (e.g. some lockless ops)
   - RTNL reduction & locking cleanups

----------------------------------------------------------------
Aamir Ahmed (2):
      wifi: mm81x: validate n_channels in disabled channels response
      wifi: mt76: mt7996: validate TLV length in mt7996_mcu_ie_countdown()

Aaradhana Sahu (2):
      wifi: ath12k: Make RXDMA buffer ring size configurable per memory profile
      wifi: ath12k: Fix NAPI resource leaks in AHB external IRQ paths

Abdurrahman Karadag (1):
      wifi: rtw88: debugfs: don't vzalloc(0) when rsvd_page is read unconfigured

Ahmed Naseef (1):
      wifi: mt76: mt7615: read MT7663 temperature from the correct offset

Albert Esteve (1):
      wifi: ath10k: clear QMI if failed during init

Allan Wang (1):
      wifi: mt76: mt7925: add AXI DMA calibration cache for MT7928

Allen Chien (1):
      wifi: mt76: mt7921: enable thermal protection

Andreas Wendleder (1):
      wifi: b43: fix use-after-free in b43_bcma_remove()

Andrei Rusu de Castro (1):
      wifi: mt76: mt7925: keep MLD membership consistent during link add

Anthony Liu (1):
      wifi: mt76: mt7928: makes struct beacon_tlv 4-byte aligned.

Arnd Bergmann (1):
      wifi: mt76: mt7996: add NET_AIROHA dependency

Aryan Sinha (1):
      wifi: nxpwifi: use str_on_off() for carrier state

Ata İlhan Köktürk (1):
      wifi: rtw88: disable ASPM for Lenovo IdeaPad S340-14IWL

Avraham Stern (1):
      wifi: iwlwifi: mld: config TLC only after attaching station to a link

Ayala Beker (1):
      wifi: iwlwifi: mld: remove NAN keys before removing internal stations

Baochen Qiang (1):
      wifi: ath11k: fix unbalanced IRQ enable/disable during suspend/resume

Benjamin Berg (3):
      wifi: iwlwifi: document MIC delay resolution
      wifi: iwlwifi: mld: pass phy status explicitly for sniffer
      wifi: iwlwifi: mld: report RX time from channel survey

Bitterblue Smith (2):
      wifi: rtw89: usb: Avoid crash with dynamically added device ID
      wifi: rtw89: Override antenna number for RTL8852BE-VS

Branislav Klocok (1):
      wifi: rtw88: add quirks to disable PCI ASPM and deep LPS for Dell Vostro 15 3530

Bui Viet Dung (3):
      wifi: mac80211: Pin module for hwflags debugfs file operations
      wifi: cfg80211: Pin module for debugfs file operations
      wifi: mac80211_hwsim: Pin module for debugfs file operations

Charlie-cy Wu (1):
      wifi: mt76: connac2: fill TXD spe_idx for connac2 fixed-rate frames

Chelsy Ratnawat (3):
      wifi: rtlwifi: rtl8192cu: Remove logically dead code in rtl92cu_update_hal_rate_mask()
      wifi: rtlwifi: rtl8192cu: Remove logically dead code in rtl92cu_update_hal_rate_table()
      wifi: rtlwifi: remove dead mimo_ps handling from rate update code

Chien Wong (2):
      wifi: mac80211: fix encryption tailroom
      wifi: mac80211: reserve MME tailroom for protected beacons

Chih-Kang Chang (4):
      wifi: rtw89: 8851b: avoid using CPUIO feature with old firmware
      wifi: rtw89: wow: check AOAC report C2H event length
      wifi: rtw89: wow: check AOAC report key index
      wifi: rtw89: ps: send H2C command related to MLO info when FWIPS

Chih-Wen Hsiao (1):
      wifi: rtw89: 8922d: disable VCORE for thermal protection by default

Chin-Yen Lee (1):
      wifi: rtw89: pci: disable D3cold on ASUS ExpertBook B3/P3 series

Ching-Te Ku (39):
      wifi: rtw89: coex: cancel RF band return condition at _set_bt_tx_power()
      wifi: rtw89: coex: fix SET_H2C_MACRO not sent for BTC_FEAT_H2C_MACRO chips
      wifi: rtw89: coex: fix out-of-bounds read of report gnt_val
      wifi: rtw89: coex: fix rlink index bound check in _update_wl_info
      wifi: rtw89: coex: support version 8 for gpio_dbg FCX report
      wifi: rtw89: coex: support fcxtdma version 8 in TDMA policy
      wifi: rtw89: coex: add fcxcysta v8 report support
      wifi: rtw89: coex: route BT sub-reports by bt_id for dual-BT support
      wifi: rtw89: coex: split bt_profile into per-device fields in trx H2C
      wifi: rtw89: coex: add fcxtxpwr version dispatch for CXDRVINFO_TXPWR
      wifi: rtw89: coex: set dbcc_en for dual-band-active MLO modes
      wifi: rtw89: coex: evaluate CO-RX Hi-LNA request per band
      wifi: rtw89: coex: detect BT HID activity from scoreboard
      wifi: rtw89: coex: check null-tx fail ratio in nullsta report
      wifi: rtw89: coex: detect BT slot flood via A2DP empty-streak in cysta
      wifi: rtw89: coex: add AFH conflict detection on BT AFH report
      wifi: rtw89: coex: log FCX report version mismatch without dropping
      wifi: rtw89: coex: add fbtc_rpt_ctrl v205 report struct and handling
      wifi: rtw89: coex: Add firmware 0.27.130.1 support for RTL8852C
      wifi: rtw89: coex: fix BT scoreboard update for non-C2H paths
      wifi: rtw89: coex: offload 8852C IO writes via firmware CMD pack region
      wifi: rtw89: coex: batch PTA init with masked IO offload
      wifi: rtw89: coex: fix RF band check in _set_rf_trx_para() and its propagation
      wifi: rtw89: coex: track per-HW-band WL role fields with arrays
      wifi: rtw89: coex: show per-HW-band MLO state in WL status dump
      wifi: rtw89: coex: add outsrc-set-info v7 for BT SPDT state
      wifi: rtw89: coex: compute WL/BT cross-talk interference maps
      wifi: rtw89: coex: add 1SS MIMO-PS decision for dual-BT CIS
      wifi: rtw89: coex: add firmware 0.35.119.3 support for RTL8922A/D
      wifi: rtw89: coex: raise default BT TX power to 10 dBm
      wifi: rtw89: coex: bind the RF band in use while WL is doing RFK
      wifi: rtw89: coex: store BT TX power per device and per RF band
      wifi: rtw89: coex: set the WL/BT antenna map on shared-antenna chips
      wifi: rtw89: coex: use the right switch-type enum on RTL8922D
      wifi: rtw89: phy: Implement API to control BTG to turn on/off BT TX/RX
      wifi: rtw89: coex: turn BT TX/RX on and off through the BTG control
      wifi: rtw89: coex: set rf_combination in _update_wl_mlo_info()
      wifi: rtw89: coex: fix off-by-one in H2C macro buffer full check
      wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to 9.24.2

Chris Scott (1):
      wifi: mt76: mt7996: refresh the tx BA session timer on NPU devices

Colin Ian King (3):
      wifi: rtw89: coex: Fix spelling mistake "verseion" -> "version"
      wifi: mt76: Fix spelling mistake "dowload" -> "download"
      wifi: mt76: mt7996: Fix spelling mistake "retriving" -> "retrieving"

Cristian Deluxe (2):
      wifi: rtw88: 8703b: complete the card-disable to card-emulation transition
      wifi: rtw88: 8703b: stop the PCIe DMA write reaching SDIO

Cristian Papa (2):
      wifi: mt76: mt7603: don't drop short frames looped back on PS entry
      wifi: mt76: feed the station RSSI average from the chain signals

Daniel Gabay (2):
      wifi: iwlwifi: mld: add gp2 timestamps to TX commands
      wifi: iwlwifi: mld: test TX gp2 timestamps

Devin Wittmayer (12):
      wifi: mt76: mt7921: fix lock inversion between dev->mutex and iflist_mtx
      wifi: mt76: mt7925: fix lock inversion between dev->mutex and iflist_mtx
      wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
      wifi: mt76: mt7925: check drv_pmctrl return in the PCIe reset path
      wifi: mt76: mt7921: fix the lock inversion in suspend and resume
      wifi: mt76: mt7925: fix the lock inversion in suspend and resume
      wifi: mt76: mt7921: honour FIF_FCSFAIL instead of hardcoding drop_err
      wifi: mt76: take rcu_read_lock in the USB/SDIO tx completion path
      wifi: mt76: mt7925: cancel mlo_pm_work on the USB stop path
      wifi: mt76: move the channel survey when the channel changes
      wifi: mt76: mt792x: defer the MCU shutdown past unregister on USB
      wifi: rtw89: usb: shorten the RX aggregation hold on RTL8922AU over USB 3

Dian-Syuan Yang (1):
      wifi: rtw89: 8922d: update BA cam format to G7

Eason Lai (3):
      wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory
      wifi: mt76: fix memory leak in USB TX path
      wifi: mt76: mt7925: Fix MCU command timeouts during module unload

Eduard Zateev (1):
      wifi: cfg80211: validate WEXT station BSSID

Emmanuel Grumbach (24):
      wifi: iwlwifi: mvm: wait for 6 missed beacons before disconnection
      wifi: iwlwifi: pcie: validate txq_id in txq_disable
      wifi: iwlwifi: mvm: remove SRAM access through debugfs
      wifi: iwlwifi: dbg: validate dram_alloc_id from debug TLV
      wifi: iwlwifi: mld: explicitly include mld.h in hcmd.h
      wifi: iwlwifi: mld: explicitly include ieee80211-p2p.h in mac-cfg.h
      wifi: iwlwifi: mld: support operational statistics notif ver 5
      wifi: iwlwifi: poke the config space in case of command timeout
      wifi: iwlwifi: pcie: remove monitor_data debugfs file
      wifi: iwlwifi: mld: stop filling link fields unused by the firmware
      wifi: iwlwifi: add multi-BSS/EMCCA max BSSID indicator to LINK cmd
      wifi: iwlwifi: pcie: fix TSO page leak in iwl_pcie_prep_tso()
      wifi: iwlwifi: fix ctxt-info-v2 unwind UAF
      wifi: iwlwifi: mvm: remove indirection_tbl debugfs entry
      wifi: iwlwifi: pcie: order RX reads after the write pointer
      wifi: iwlwifi: add support for the new MPDU descriptor
      wifi: iwlwifi: support RX BAID modify command version 3
      wifi: iwlwifi: mld: fake a valid NSS field when needed
      wifi: iwlwifi: mld: remove unused fields from the firmware API
      wifi: iwlwifi: mld: add STA_CONFIG_CMD version 4
      wifi: iwlwifi: mld: add support for WoWLAN CIGTK API
      wifi: iwlwifi: don't mask ucode_ver in iwl_sar_geo_support()
      wifi: iwlwifi: mvm: fix the VHT MCS sent to a v1 firmware
      wifi: iwlwifi: mvm: remove dead sta check in rx_monitor_no_data

Endrik Einberg (1):
      wifi: iwlwifi: mld: include VI packets in low latency detection

Eric Huang (4):
      wifi: rtw89: 8922d: update BB wrapper RFSI ctrl to v4
      wifi: rtw89: 8922d: add extra data to PS H2C
      wifi: rtw89: phy: correct PHY-1 EDCCA report register access
      wifi: rtw89: phy: write full data for BB gain table type 15

Ethan Tidmore (1):
      wifi: mt76: mt7925: Remove useless condition

Felix Fietkau (45):
      wifi: mt76: mt7996: program a link again if the driver holds it
      wifi: mt76: check the owner of a remain-on-channel request
      wifi: mt76: mt7996: take over connection monitoring
      wifi: mt76: clear offchannel state if a scan has no channel to restore
      wifi: mt76: account non-AQL frames per peer rather than per link
      wifi: mt76: mt7915: check default EEPROM firmware size before copying
      wifi: mt76: mt7996: validate firmware event lengths before parsing
      wifi: mt76: mt7915: unregister thermal cooling device on hwmon failure
      wifi: mt76: mt7915: guard firmware memory dump write on disabled memdump
      wifi: mt76: mt7996: bound RRO session id before indexing addr_elem[]
      wifi: mt76: mt7925: restore the reset state when fw_pmctrl fails
      wifi: mt76: connac: pass the command to mt76_connac_mcu_chip_config()
      wifi: mt76: abort a scan only for a link change on the scanning radio
      wifi: mt76: mt7996: enable the SKU power limit table
      wifi: mt76: mt7996: set sniffer mode on a radio that is already running
      wifi: mt76: mt7996: update the address of an AP link that is added again
      wifi: mt76: mt7996: size the MLD setup TLV by the links it describes
      wifi: mt76: mt7996: find the last MLD link among the links torn down
      wifi: mt76: mt7996: upload only the keys of the link being set up
      wifi: mt76: mt7996: do not walk the vif keys when a link is destroyed
      wifi: mt76: mt7996: report station statistics from the primary link
      wifi: mt76: mt7996: clear all link wcid entries in sta_pre_rcu_remove
      wifi: mt76: mt7996: free the WTBL index if a link allocation fails
      wifi: mt76: mt7996: pick the secondary link from links with driver state
      wifi: mt76: mt7996: make a returning link primary if a station has none
      wifi: mt76: mt7996: do not reuse the deflink of a removed station link
      wifi: mt76: mt7996: keep a returning link when adding station links fails
      wifi: mt76: mt7996: add the station BMC entry as new once per BSSID
      wifi: mt76: mt7996: keep 4-address and decap state per station
      wifi: mt76: mt7996: record the connection state of a station
      wifi: mt76: mt7996: keep the block ack session parameters per station
      wifi: mt76: mt7996: set up the BSS of a late station link before its peer
      wifi: mt76: mt7996: bring up station links added after association
      wifi: mt76: mt7996: set up block ack sessions on station links added later
      wifi: mt76: mt7996: restore a station link that returns after a removal
      wifi: mt76: mt7996: fix PLE free page and AC queue register offsets
      wifi: mt76: mt7996: fix the hw-queues debugfs queue requests
      wifi: mt76: mt7996: refuse scan and ROC until the hardware restart is done
      wifi: mt76: report an aborted scan or ROC to mac80211 during a reset
      wifi: mt76: mt7921: fix of_node reference leaks in regd update
      wifi: mt76: mt792x: compute the assoc RSSI from the chain signals
      wifi: mt76: remove the unused signal field from struct mt76_rx_status
      wifi: mt76: mt7996: take the offchannel link of a frame from its wcid
      wifi: mt76: keep beacons from queueing the scan work during an abort
      wifi: mac80211: use link address as TA for non-MLO 4-addr station on MLD AP

Felix Hoffmann (1):
      wifi: mm81x: validate YAPS receive framing

François Roux (1):
      wifi: ath12k: skip hardware rfkill setup on Microsoft Surface devices

Gongwei Li (2):
      wifi: rtw89: coex: Fix wrong constant check of GPIO MUX signal
      wifi: rtw89: fw: propagate real error code in rtw89_fw_h2c_add_general_pkt()

Hemanth Selam (2):
      wifi: rtl8xxxu: fix typo "Tranceiver" in comment
      wifi: rtlwifi: fix typos in comments

Howard Hsu (1):
      wifi: mt76: mt7996: do not add a station link in disconnected state

Hsiao-Yung Chen (1):
      wifi: rtw89: allow two station interfaces in SCC

Ilan Peer (2):
      wifi: iwlwifi: mld: Add support for (Re)association req/resp encryption
      wifi: iwlwifi: mld: Add support for scan iteration complete notification v3

Jacobs Wu (2):
      wifi: mt76: mt7925: support deferred NAN schedule update and cluster events
      wifi: mt76: mt7925: fix HT/VHT caps and rates for NAN NDP peers

Jeff Chen (2):
      wifi: mwifiex: append hotfix number to firmware version string
      wifi: mwifiex: validate GET_HW_SPEC TLV lengths before parsing

Jeff Johnson (2):
      wifi: cfg80211: fix kernel-doc %field -> @field cross-references
      wifi: ath12k: Remove unused HAL_RX_REO_QUEUE_INFO macros

Jiale Yao (11):
      wifi: ath12k: Reserve space for a string terminator
      wifi: mt76: mt76x02: validate RX padding before use
      wifi: mt76: mt7615: cancel reset work during unregister
      wifi: mt76: usb: fix source overread in mt76u_copy
      wifi: mt76: mt7615: usb: fix source overread in mt7663u_copy
      wifi: ath12k: validate MAC/PHY capability count before saving
      wifi: ath10k: avoid IDR mutation during TX cleanup
      wifi: ath11k: avoid IDR mutation during pending mgmt TX cleanup
      wifi: ath11k: avoid IDR mutation during vif mgmt TX cleanup
      wifi: ath12k: avoid IDR mutation during pending mgmt TX cleanup
      wifi: ath12k: avoid IDR mutation during vif mgmt TX cleanup

Johannes Berg (93):
      wifi: rtw89: avoid iter_keys_rcu() where not needed
      wifi: mt76: avoid iter_keys_rcu() where not needed
      wifi: ath6kl: don't take RTNL in del_virtual_intf
      wifi: mac80211: clear fragment cache entry 'is_protected'
      wifi: mac80211: mesh: use hlist_add_head_rcu()
      wifi: mac80211: kill wake_txqs_tasklet on unregistration
      wifi: nl80211: reject zero RNR/MBSSID elements
      wifi: mac80211: init radiotap iter after length checks
      wifi: mac80211: limit injected HT/VHT MCSes
      wifi: mac80211: mesh: fix path table generation counters
      wifi: mac80211: fix mbssid/rnr allocation in beacon data
      wifi: mac80211: don't read runt headers in injection
      wifi: mac80211: fix TDLS setup frame length check
      Merge tag 'mt76-next-2026-10-07' of https://github.com/nbd168/wireless
      wifi: cfg80211: reg: protect regdb pointer with RCU
      wifi: cfg80211: track netdev running state under wiphy mutex
      wifi: nl80211: allow device lookup under RCU
      wifi: nl80211: avoid rtnl for commands that don't want it
      wifi: nl80211: don't take rtnl for most dumps
      wifi: cfg80211: reg: update channels under wiphy mutex
      wifi: cfg80211: reg: set intersected regd under wiphy mutex
      wifi: cfg80211: update channel DFS data under wiphy mutex
      wifi: mac80211_hwsim: call cfg80211 event with wiphy mutex
      wifi: cfg80211: document wiphy mutex for radar/CAC events
      wifi: cfg80211: add a mutex for regulatory/device list
      wifi: cfg80211: allow walking wiphy list under cfg80211_mutex
      wifi: ath: use freq_reg_info() under RCU
      wifi: brcmsmac: use freq_reg_info() under RCU
      wifi: rtlwifi: use freq_reg_info() under RCU
      wifi: nl80211: read WMM reg rule under RCU
      wifi: ath11k: read wiphy regd under RCU
      wifi: ath12k: read wiphy regd under RCU
      wifi: cfg80211: regulatory: stop using RTNL
      Merge tag 'rtw-next-2026-10-08' of https://github.com/pkshih/rtw
      Merge tag 'mm81x-next-2026-10-09' of https://github.com/MorseMicroLabs/linux-wireless
      wifi: nl80211: add NL80211_CMD_UPDATE_BEACON
      wifi: mac80211: protect AP template pointers with a spinlock
      wifi: mac80211: refactor beacon allocation
      wifi: mac80211: implement lockless beacon updates
      wifi: mac80211_hwsim: support lockless beacon updates
      wifi: nl80211: prepare for unlocked wdev-only ops
      wifi: nl80211: allow mgmt frame TX without wiphy mutex
      wifi: cfg80211: make cookie counter atomic
      wifi: mac80211: refactor mgmt frames TX
      wifi: mac80211: implement mgmt_tx_unlocked()
      wifi: mac80211: don't require wiphy mutex for probe_peer
      wifi: nl80211: probe peers without wiphy mutex
      wifi: mac80211: don't require wiphy mutex for control port TX
      wifi: nl80211: transmit control port frames without wiphy mutex
      wifi: cfg80211: support unlocked station get/dump
      wifi: mac80211: refactor station statistics
      wifi: mac80211: implement unlocked STA statistics
      wifi: nl80211: fix BSS reference leak
      wifi: nl80211: avoid RTNL in nl80211_get_reg_do()
      wifi: cfg80211: drop RTNL from disconnect_work
      wifi: nl80211: don't hold RTNL for SET_SAR_SPECS
      wifi: cfg80211: switch wiphy netns under cfg80211_mutex
      wifi: nl80211: avoid RTNL for wiphy/interface netlink dumps
      wifi: cfg80211: protect wiphy names with cfg80211_mutex
      wifi: mac80211_hwsim: get wiphy_name() after registration
      wifi: cfg80211: check wiphy name in wiphy_register()
      wifi: mac80211: don't hold RTNL for rate control algo
      wifi: mac80211: fix interface registration error path order
      Merge tag 'ath-next-20261012' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath
      wifi: iwlwifi: mld: separate HT/VHT/HE/EHT LDPC/STBC capabilities
      wifi: iwlwifi: advertise 2xLDPC RX support for UHR
      wifi: iwlwifi: mld: fix some UHR ELR bits
      wifi: iwlwifi: mld: correct EHT U-SIG-1 B20:25 report
      wifi: iwlwifi: mld: add UHR sniffer support
      wifi: iwlwifi: mld: report UHR LTF symbols for non-TB PPDUs
      wifi: iwlwifi: mld: fix some radiotap field reports
      wifi: iwlwifi: mld: report UHR per-user NSS
      wifi: iwlwifi: mld: report beamforming in UHR sniffer
      wifi: iwlwifi: correctly report TB sounding PPDUs in sniffer
      wifi: iwlwifi: mld: remove UHR TB U-SIG2 B2 validate bit
      wifi: iwlwifi: mld: detect UHR sounding packets
      wifi: iwlwifi: mld: report the guard interval for UHR
      wifi: iwlwifi: mld: set RX_FLAG_FAILED_PLCP_CRC for bad U-SIG CRC
      wifi: iwlwifi: advertise UHR Co-BF support
      wifi: iwlwifi: dbg: validate the index before accessing an array
      wifi: iwlwifi: fw: api: fix D3 sequence counter docs
      wifi: iwlwifi: pcie: correctly read WFPM_OTP_CFG1_ADDR
      wifi: iwlwifi: mld: avoid const in iwl_mld_chan_load_update_iter()
      wifi: iwlwifi: mld: fix const in iwl_mld_mu_mimo_iface_iterator
      wifi: iwlwifi: mvm: fix beacon flags compiler warning
      wifi: iwlwifi: mvm: uninline iwl_mvm_ftm_start versions
      wifi: iwlwifi: support SCD_QUEUE_CONFIG_CMD version 4
      Merge tag 'nxpwifi-next-20261014' of https://github.com/nxp-upstream/nxpwifi-next
      Merge tag 'iwlwifi-next-2026-10-14' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      wifi: mac80211: tests: fix stack variable bug
      wifi: cfg80211: track SSID regardless of country data
      wifi: cfg80211: reject WEP/TKIP with multi-link
      wifi: cfg80211: fix potential requested_regd leak

John Crispin (3):
      wifi: mt76: mt7996: disable the RX NAPIs before the DMA cleanup
      wifi: mt76: scan all radios of a request at the same time
      wifi: mt76: mt7996: scan all bands with one request

Johnson Tsai (1):
      wifi: rtw89: pack I/O during RF nctl init to reduce execution time

Karl Mehltretter (1):
      wifi: nxpwifi: return timeout error from nxpwifi_sdio_poll_card_status()

Kim Wooseok (3):
      wifi: rtl8xxxu: free RX skb when URB submission fails
      wifi: rtl8xxxu: unwind incomplete receive startup
      wifi: rtl8xxxu: preserve RX requests across recoverable transfer errors

Lachlan Hodges (5):
      wifi: mm81x: provide the station to mac80211 on rx
      wifi: mm81x: add monitor mode support
      wifi: mm81x: copy new sband for each module
      wifi: mac80211: handle shorter S1G TIM when parsing elements
      wifi: mac80211: set conn mode prior to parsing elements in beacon

Laxman Acharya Padhya (1):
      wifi: rtw89: cap firmware section_num before parsing

Linlin Yang (1):
      wifi: mt76: mt7996: fix PCI device reference leak in mt7996_pci_init_hif2()

Luka Gejak (15):
      wifi: rtw88: add the RTL8723B chip type and SDIO helper
      wifi: rtw88: rx: mark zero length packets on RTL8723BS
      wifi: rtw88: tx: extend the TX report purge timeout to RTL8723BS
      wifi: rtw88: sdio: zero the padding added to a TX transfer
      wifi: rtw88: sdio: track free TX pages and OQT credits for RTL8723BS
      wifi: rtw88: sdio: set up RX aggregation and interrupts for RTL8723BS
      wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
      wifi: rtw88: move the 88xxa CCK power detect setter to phy.c
      wifi: rtw88: 8723b: add the RTL8723B register definitions
      wifi: rtw88: 8723b: add the RTL8723B BB, RF and AGC tables
      wifi: rtw88: move the shared 8723x definitions to rtw8723x.h
      wifi: rtw88: 8723b: add the RTL8723B chip driver
      wifi: rtw88: 8723bs: add the RTL8723BS SDIO bind
      wifi: rtw88: 8723bs: enable building the RTL8723BS driver
      staging: rtl8723bs: remove the obsolete driver

Mahesh Saran (1):
      wifi: mt76: mt7921: clear WM2 from MT7902 RX all_complete_mask

Mark Anthony Agarro (5):
      wifi: mt76: mt76x02: validate TX-status rate index before mac80211 handoff
      wifi: mt76: mt7925: honour mac80211's FIF_FCSFAIL instead of hardcoding drop_err
      wifi: mt76: mt7615: do not tear down BSS/STA state for monitor vifs
      wifi: mt76: mt7921: keep the join ROC until the station is authorized
      wifi: mt76: mt7925: keep the join ROC until the station is authorized

Maxim Skokov (1):
      wifi: rtw89: fix typos in comments, debug messages and struct field

Mehmet Fide (5):
      wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery
      wifi: rtw88: usb: do not log transfers lost to a mode switch
      wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
      wifi: rtw88: usb: only let the frames a dozing station needs use the after-DTIM queue
      wifi: rtw88: widen the ATIM window while an AP interface is up

Miri Korenblit (29):
      wifi: iwlwifi: mld: don't use bss_conf in NAN
      wifi: iwlwifi: Don't allocate a DRAM buffer with an invalid ID
      wifi: iwlwifi: mld: log error when missing a recovery buffer
      wifi: iwlwifi: mld: avoid leaking error recovery buffer
      wifi: iwlwifi: support net detect match info version 3
      wifi: iwlwifi: bump maximum core version for BZ/SC/DR to 108
      wifi: iwlwifi: mvm: validate mpdu len before relying on it
      wifi: iwlwifi: support for another device ID
      wifi: iwlwifi: pcie: drop gen1_2 prefix from several functions
      wifi: iwlwifi: Revert "wifi: iwlwifi: gen1_2: move gen specific code to a function"
      wifi: iwlwifi: Revert "wifi: iwlwifi: pcie: move generation specific files to a folder"
      wifi: iwlwifi: pcie: remove iwl_dbgfs_fh_reg_read
      wifi: iwlwifi: open code iwl_trans_sync_nmi_with_addr()
      wifi: iwlwifi: move iwl_force_nmi() to where it belongs
      wifi: iwlwifi: drop the orphaned nic_access annotations
      wifi: iwlwifi: add _no_grab postfix to some functions
      wifi: iwlwifi: move pcie-only functions to pcie
      wifi: iwlwifi: avoid unnecessary indirection
      wifi: iwlwifi: rename iwl_trans_read_prph
      wifi: iwlwifi: collapse iwl_read_prph_no_grab() into the transport API
      wifi: iwlwifi: pcie: rename pcie-internal functions
      wifi: iwlwifi: rename io helpers to iwl_trans_ prefix
      wifi: iwlwifi: move iwl-io functions to iwl-trans
      wifi: iwlwifi: call generic trans API and not pcie one
      wifi: iwlwifi: trans: bring virtualization back
      wifi: iwlwifi: bump maximum core version for BZ/SC/DR to 109
      wifi: iwlwifi: move context info APIs to a separate file
      wifi: iwlwifi: mld: don't enable RSS if there is one queue.
      wifi: iwlwifi: trans: remove the unused write8 operation

Muhammad Bilal (1):
      wifi: mm81x: check bytes_remaining before reading delimiter

Myeonghun Pak (1):
      wifi: mt76: mt7615: restore DBDC state after ext PHY failure

Nerijus Bendžiūnas (1):
      wifi: ath9k: refuse spectral scan control while the hardware is disabled

Nick Venenga (2):
      wifi: rtw89: 8922au: Add support for TP-Link TBE400U
      wifi: rtw89: 8922au: add ASUS BE93

Pagadala Yesu Anjaneyulu (11):
      wifi: iwlwifi: fw: add Google-ASUS TAS approved DMI match
      wifi: iwlwifi: mvm: validate NVM read response length
      wifi: iwlwifi: fw: reject empty UEFI DSM query bitmap
      wifi: iwlwifi: fw: fix dbg dest TLV size check by version
      wifi: iwlwifi: mvm: debugfs: validate TAS response and loop bounds
      wifi: iwlwifi: mvm: fix LARI_CONFIG_EXTENSION version check
      wifi: iwlwifi: add standalone WRSS/EWSS BIOS table loading
      wifi: iwlwifi: send standalone SAR to firmware
      wifi: iwlwifi: uefi: Fix SAR enable check to use mode parameter correctly
      wifi: iwlwifi: fw: harden UEFI reduced-power TLV parsing
      wifi: iwlwifi: fw: add Samsung to TAS and PPAG allow lists

Pavankumar Nandeshwar (1):
      wifi: ath12k: Increase RXDMA buffer ring size for default memory profile

Pengpeng Hou (1):
      wifi: mt76: mt7615: validate MCU response lengths

Ping-Ke Shih (18):
      wifi: rtw89: 8922d: set BB wrapper settings according to operating channel
      wifi: rtw89: 8922d: move conditionally disabled TX shape to common flow
      wifi: rtw89: 8922d: update BB wrapper RFSI ctrl to v5
      wifi: rtw89: 8922d: send RFE type to firmware
      wifi: rtw89: 8922d: bypass RX IQK when scan
      wifi: rtw89: 8922d: correct selection of CCK rate circuit
      wifi: rtw89: consider sta maximum AMSDU subframes number to decide TX work waiting
      wifi: rtw89: mac: change beamformee CSI direct forward to CMAC_TXDMA
      wifi: rtw89: fw: extend ch_info format of hw_scan to v2
      wifi: rtw89: 8851b: rfk: set DCK start and delay time
      wifi: rtw89: 8852b: update default value for ANA SWR
      wifi: rtw89: correct dependency of the multicolor LED
      wifi: rtw89: fw: duplicate recognized firmware elements
      wifi: rtw89: fw: release firmware after recognizing firmware elements
      wifi: rtw89: fw: duplicate firmware suit data by vmalloc to reduce memory fragment
      wifi: rtw88: TX report with long timeout for non-PCIE devices
      wifi: rtw89: remove discouraged imply from Kconfig LED
      wifi: rtw89: 8922d: update supported firmware format to 1

Po-Hao Huang (4):
      wifi: rtw89: add p2p device declaration
      wifi: rtw89: mlo: update link id to FW upon connection
      Revert "wifi: rtw89: fix unable to receive probe responses under MLO connection"
      wifi: rtw89: modify active scan rule for 6GHz band

Rahul Kumar Rai (1):
      wifi: rtw88: disable ASPM and deep PS on ASUS TUF Gaming A15 FA506IH

Rosen Penev (1):
      wifi: ath9k: delete channel-context timers on deinit

Ryan Leung (5):
      wifi: mt76: mt7915: publish wcid before MCU add commands
      wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
      wifi: mt76: fix wcid teardown ordering in mt76_reset_device()
      wifi: mt76: mt7915: fix thermal zone use-after-free
      wifi: mt76: fix wcid->pktid corruption in mt76_wcid_cleanup()

Samuele Yang (1):
      wifi: mm81x: start beaconing on beacon enable not interface add

Shahar Tzarfati (7):
      wifi: iwlwifi: fw: fix integer overflow in INI dump size calc
      wifi: iwlwifi: validate TLV length before reading fields
      wifi: iwlwifi: uefi: add UEFI GUID Lock Indicator (GLUI) definitions
      wifi: iwlwifi: uefi: add a way to probe connectivity UEFI variables
      wifi: iwlwifi: regulatory: use GLUI as root-of-trust for connectivity variables
      wifi: iwlwifi: mvm: validate BAID from FW
      wifi: iwlwifi: disable HE ER mode

Slavin Liu (1):
      wifi: mt76: mt7996: guard station-only MLO TX handling

Stella Liu (13):
      wifi: mt76: mt7925: fix NAN NDP STA record role index
      wifi: mt76: mt7925: fix NAN start failure
      wifi: mt76: mt7925: fix NAN committed CRB timeline layout
      wifi: mt76: mt7925: report only 2.4 GHz NAN supported band
      wifi: mt76: mt7925: drop unused NAN 2.4/5 GHz support config
      wifi: mt76: mt7925: drop deferred NAN local schedule update handling
      wifi: mt76: mt7925: use OFDM-only PHY mode for NAN STA records
      wifi: mt76: mt7925: share TLV setup for NAN enable command
      wifi: mt76: mt7925: replace NAN DW end event with DW start
      wifi: mt76: mt7925: fill all DW intervals in NAN avail_map
      wifi: mt76: mt7925: clear CRB before deactivating NAN peer record
      wifi: mt76: mt7925: add ULW event handling and peer ULW update
      wifi: mt76: mt7925: configure NAN PHY setting on enable

Tristan Madani (1):
      wifi: rtw89: fix IE length passed to cfg80211_find_ie() in WoW AKM

Vitor Soares (1):
      wifi: ath12k: advertise interface MAC address pool

Wentao Liang (1):
      wifi: mt76: Fix of_node reference leak in mt76_get_rate_power_limits()

Yi Cong (2):
      wifi: rtw89: 8851b: fix swapped DPK channel/bandwidth backup fields
      wifi: mt76: mt792x: fix negative errno truncation in offload capability

YuChia-Kan (1):
      wifi: rtw88: use firmware MAC address as fallback

Yury Norov (2):
      wifi: mm81x: switch to use fns()
      wifi: mm81x: use hweight16() to calculate bit index

Zhao Li (1):
      wifi: mt76: mt7996: unlink TWT flow if the MCU rejects the agreement

Zong-Zhe Yang (17):
      wifi: rtw89: chan: introduce helper and refine active list iteration
      wifi: rtw89: regd: check only active vifs when recalculating 6 GHz power type
      wifi: rtw89: skip tracking things when entity is paused
      wifi: rtw89: fix ctrl_sco_cck for Wi-Fi 7
      wifi: rtw89: 8852a: prevent potential OOB in ctrl_sco_cck
      wifi: rtw89: fw: cmd_ofld_flush always reset counter
      wifi: rtw89: explicitly declare TX queue flags by DECLARE_BITMAP()
      wifi: rtw89: use one single BA CAM entry per MLD instead of per link
      wifi: rtw89: led: check if board variant assigns led desc
      wifi: rtw89: support variants of FW elements
      wifi: rtw89: 8852cu: take board ID 1 for FW elements 28de/2432
      wifi: rtw89: add instance of IO ops for (un)pack and [um]delay
      wifi: rtw89: ser: reset map of associated links when L2 SER
      wifi: rtw89: pci: fix typo of "deliver"
      wifi: rtw89: rx: refine skb/desc naming to improve readability
      wifi: rtw89: rx: no need to cancel 6 GHz probe per vif
      wifi: rtw89: regd: add NZ/BR/AR for individual TX power settings

ck.chang (1):
      wifi: mt76: mt7925: fix reset panic caused by the WM2 rx irq mask

イムティヤズ (1):
      wifi: rtw88: fix out-of-bounds CAM write when key table is full

 drivers/net/wireless/ath/ath10k/htt_tx.c           |   12 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |    1 +
 drivers/net/wireless/ath/ath11k/core.c             |   21 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   33 +-
 drivers/net/wireless/ath/ath11k/mac.h              |    2 +-
 drivers/net/wireless/ath/ath11k/reg.c              |    4 +-
 drivers/net/wireless/ath/ath12k/ahb.c              |   41 +-
 drivers/net/wireless/ath/ath12k/core.c             |   37 +-
 .../net/wireless/ath/ath12k/debugfs_htt_stats.c    |    2 +-
 drivers/net/wireless/ath/ath12k/dp.h               |    8 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |    2 +-
 drivers/net/wireless/ath/ath12k/hw.h               |    1 +
 drivers/net/wireless/ath/ath12k/mac.c              |   87 +-
 drivers/net/wireless/ath/ath12k/mac.h              |    2 +-
 drivers/net/wireless/ath/ath12k/reg.c              |    6 +-
 drivers/net/wireless/ath/ath12k/wifi7/hal_desc.h   |   26 -
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |    6 +
 drivers/net/wireless/ath/ath12k/wmi.c              |   17 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    2 -
 drivers/net/wireless/ath/ath9k/channel.c           |    2 +
 drivers/net/wireless/ath/ath9k/common-spectral.c   |    9 +
 drivers/net/wireless/ath/regd.c                    |    2 +
 drivers/net/wireless/broadcom/b43/main.c           |    5 +-
 .../wireless/broadcom/brcm80211/brcmsmac/channel.c |    2 +
 drivers/net/wireless/intel/iwlwifi/Makefile        |    7 +-
 drivers/net/wireless/intel/iwlwifi/cfg/bz.c        |    8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/dr.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/rf-fm.c     |    4 +
 drivers/net/wireless/intel/iwlwifi/cfg/sc.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c   |    5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c   |   32 +-
 drivers/net/wireless/intel/iwlwifi/dvm/eeprom.c    |   88 +-
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |   11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |   11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   36 +-
 drivers/net/wireless/intel/iwlwifi/dvm/power.c     |    3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |   19 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c        |   14 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |    3 +-
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c     |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  306 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   20 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    5 +-
 .../wireless/intel/iwlwifi/fw/api/ctxt-info-v2.h   |  328 ++
 .../net/wireless/intel/iwlwifi/fw/api/ctxt-info.h  |  185 +
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   88 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |   51 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |   53 +-
 .../net/wireless/intel/iwlwifi/fw/api/offload.h    |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   14 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   23 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h  |   60 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   11 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg-old.c    |  120 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  156 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |   16 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    2 +
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c |   97 +-
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.h |   26 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |  412 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |   26 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   54 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace-io.h   |   18 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    9 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |  448 --
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |  107 -
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   33 +-
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h       |   22 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |  354 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  228 +-
 drivers/net/wireless/intel/iwlwifi/mld/agg.c       |    7 +-
 drivers/net/wireless/intel/iwlwifi/mld/constants.h |    4 +
 drivers/net/wireless/intel/iwlwifi/mld/d3.c        |   76 +-
 drivers/net/wireless/intel/iwlwifi/mld/debugfs.c   |    4 +-
 .../net/wireless/intel/iwlwifi/mld/ftm-initiator.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/mld/fw.c        |   22 +-
 drivers/net/wireless/intel/iwlwifi/mld/hcmd.h      |    2 +
 drivers/net/wireless/intel/iwlwifi/mld/key.c       |    6 +
 drivers/net/wireless/intel/iwlwifi/mld/link.c      |   14 +-
 .../net/wireless/intel/iwlwifi/mld/low_latency.c   |    3 +-
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c  |    6 +
 drivers/net/wireless/intel/iwlwifi/mld/mld.c       |   20 +
 drivers/net/wireless/intel/iwlwifi/mld/mld.h       |    6 +
 drivers/net/wireless/intel/iwlwifi/mld/mlo.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mld/nan.c       |   35 +-
 drivers/net/wireless/intel/iwlwifi/mld/notif.c     |   10 +-
 drivers/net/wireless/intel/iwlwifi/mld/power.c     |    2 +-
 drivers/net/wireless/intel/iwlwifi/mld/ptp.c       |   12 +-
 .../net/wireless/intel/iwlwifi/mld/regulatory.c    |   83 +-
 .../net/wireless/intel/iwlwifi/mld/regulatory.h    |    4 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c        |  752 ++-
 drivers/net/wireless/intel/iwlwifi/mld/scan.c      |   20 +-
 drivers/net/wireless/intel/iwlwifi/mld/scan.h      |    4 +-
 drivers/net/wireless/intel/iwlwifi/mld/sta.c       |    7 +-
 drivers/net/wireless/intel/iwlwifi/mld/stats.c     |   35 +-
 .../net/wireless/intel/iwlwifi/mld/tests/Makefile  |    2 +-
 .../net/wireless/intel/iwlwifi/mld/tests/tx-gp2.c  |  154 +
 drivers/net/wireless/intel/iwlwifi/mld/tlc.c       |  184 +-
 drivers/net/wireless/intel/iwlwifi/mld/tx.c        |  135 +
 drivers/net/wireless/intel/iwlwifi/mld/tx.h        |   41 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   89 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |  141 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   51 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   44 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   15 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   31 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |    4 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |    1 -
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |    8 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info-v2.c |   30 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |    5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   14 +-
 .../intel/iwlwifi/pcie/{gen1_2 => }/internal.h     |  136 +-
 .../intel/iwlwifi/pcie/iwl-context-info-v2.h       |  320 +-
 .../wireless/intel/iwlwifi/pcie/iwl-context-info.h |  177 +-
 .../wireless/intel/iwlwifi/pcie/{gen1_2 => }/rx.c  |  198 +-
 .../intel/iwlwifi/pcie/{gen1_2 => }/trans-gen2.c   |   96 +-
 .../intel/iwlwifi/pcie/{gen1_2 => }/trans.c        |  929 ++-
 .../intel/iwlwifi/pcie/{gen1_2 => }/tx-gen2.c      |    9 +-
 .../wireless/intel/iwlwifi/pcie/{gen1_2 => }/tx.c  |  167 +-
 drivers/net/wireless/intel/iwlwifi/pcie/utils.c    |   91 +-
 drivers/net/wireless/intel/iwlwifi/pcie/utils.h    |   46 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |   22 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    6 +
 drivers/net/wireless/marvell/mwifiex/init.c        |    1 +
 drivers/net/wireless/marvell/mwifiex/main.h        |    1 +
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |    3 +-
 drivers/net/wireless/mediatek/mt76/Kconfig         |    1 +
 drivers/net/wireless/mediatek/mt76/channel.c       |   26 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   17 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   32 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   31 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   18 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   13 +
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |    1 +
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |   17 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   20 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   19 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   30 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt7915/coredump.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    6 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   14 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   48 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   26 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    6 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |    1 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regd.c   |   28 +-
 drivers/net/wireless/mediatek/mt76/mt7925/Makefile |    2 +-
 .../net/wireless/mediatek/mt76/mt7925/cached_cal.c |  298 +
 .../net/wireless/mediatek/mt76/mt7925/cached_cal.h |  151 +
 drivers/net/wireless/mediatek/mt76/mt7925/init.c   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |  115 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |   73 +-
 drivers/net/wireless/mediatek/mt76/mt7925/mt7925.h |   10 +-
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c    |  694 ++-
 drivers/net/wireless/mediatek/mt76/mt7925/nan.h    |  103 +-
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c    |   66 +-
 .../net/wireless/mediatek/mt76/mt7925/pci_mac.c    |    8 +-
 .../net/wireless/mediatek/mt76/mt7925/pci_mcu.c    |    2 +
 drivers/net/wireless/mediatek/mt76/mt7925/regs.h   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |   26 +-
 drivers/net/wireless/mediatek/mt76/mt792x.h        |   18 +
 drivers/net/wireless/mediatek/mt76/mt792x_core.c   |   12 +-
 drivers/net/wireless/mediatek/mt76/mt792x_mac.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig  |    1 +
 .../net/wireless/mediatek/mt76/mt7996/coredump.c   |    7 +-
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |  319 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |    7 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   23 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  784 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  153 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   23 +
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   42 +-
 drivers/net/wireless/mediatek/mt76/mt7996/npu.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |   38 +-
 drivers/net/wireless/mediatek/mt76/scan.c          |  227 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    9 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   47 +-
 drivers/net/wireless/morsemicro/mm81x/command.c    |    5 +-
 drivers/net/wireless/morsemicro/mm81x/core.h       |   16 +-
 drivers/net/wireless/morsemicro/mm81x/mac.c        |  297 +-
 drivers/net/wireless/morsemicro/mm81x/mmrc.c       |   34 +-
 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c    |   14 +-
 drivers/net/wireless/nxp/nxpwifi/debugfs.c         |    5 +-
 drivers/net/wireless/nxp/nxpwifi/main.c            |    5 +-
 drivers/net/wireless/nxp/nxpwifi/sdio.c            |    2 +-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  154 +-
 drivers/net/wireless/realtek/rtl8xxxu/regs.h       |    2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    2 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |    2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |    2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |    2 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |    2 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |    4 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h       |    2 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c        |    4 +
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.h   |    2 +-
 .../wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/reg.h   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |   92 +-
 .../net/wireless/realtek/rtlwifi/rtl8192d/reg.h    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192du/phy.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |    1 -
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |    2 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/pwrseq.h    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |  102 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   |   10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/reg.h   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |    4 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |    1 -
 .../wireless/realtek/rtlwifi/rtl8723ae/pwrseq.h    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |    2 +-
 .../wireless/realtek/rtlwifi/rtl8723be/pwrseq.h    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/reg.h   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |   12 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |   73 +-
 .../wireless/realtek/rtlwifi/rtl8821ae/pwrseq.h    |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/reg.h   |   14 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |    2 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |    2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    6 +-
 drivers/net/wireless/realtek/rtw88/Kconfig         |   18 +
 drivers/net/wireless/realtek/rtw88/Makefile        |    6 +
 drivers/net/wireless/realtek/rtw88/debug.c         |    5 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    4 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    7 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    8 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   29 +
 drivers/net/wireless/realtek/rtw88/phy.c           |   39 +
 drivers/net/wireless/realtek/rtw88/phy.h           |    1 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   36 +
 drivers/net/wireless/realtek/rtw88/rtw8703b.c      |   36 +-
 drivers/net/wireless/realtek/rtw88/rtw8703b.h      |   63 -
 drivers/net/wireless/realtek/rtw88/rtw8723b.c      | 2534 +++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723b.h      |   14 +
 .../net/wireless/realtek/rtw88/rtw8723b_table.c    |  861 +++
 .../net/wireless/realtek/rtw88/rtw8723b_table.h    |   17 +
 drivers/net/wireless/realtek/rtw88/rtw8723bs.c     |   59 +
 drivers/net/wireless/realtek/rtw88/rtw8723x.h      |   60 +
 drivers/net/wireless/realtek/rtw88/rtw8812a.c      |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c      |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw88xxa.c      |   38 -
 drivers/net/wireless/realtek/rtw88/rtw88xxa.h      |    1 -
 drivers/net/wireless/realtek/rtw88/rx.c            |    8 +-
 drivers/net/wireless/realtek/rtw88/sdio.c          |  506 +-
 drivers/net/wireless/realtek/rtw88/sdio.h          |   24 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |    9 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |    3 +-
 drivers/net/wireless/realtek/rtw88/usb.c           |   90 +-
 drivers/net/wireless/realtek/rtw88/usb.h           |    5 +
 drivers/net/wireless/realtek/rtw89/Kconfig         |    4 +-
 drivers/net/wireless/realtek/rtw89/cam.c           |    4 +-
 drivers/net/wireless/realtek/rtw89/chan.c          |   28 +-
 drivers/net/wireless/realtek/rtw89/chan.h          |    1 +
 drivers/net/wireless/realtek/rtw89/coex.c          | 1465 ++++-
 drivers/net/wireless/realtek/rtw89/coex.h          |    1 -
 drivers/net/wireless/realtek/rtw89/core.c          |  174 +-
 drivers/net/wireless/realtek/rtw89/core.h          |  349 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |   10 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  895 ++-
 drivers/net/wireless/realtek/rtw89/fw.h            |  136 +-
 drivers/net/wireless/realtek/rtw89/led.c           |    2 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   16 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    6 +-
 drivers/net/wireless/realtek/rtw89/mac_be.c        |    3 +
 drivers/net/wireless/realtek/rtw89/pci.c           |   62 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |    4 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   37 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |   32 +-
 drivers/net/wireless/realtek/rtw89/phy_be.c        |  219 +-
 drivers/net/wireless/realtek/rtw89/ps.c            |   15 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |   32 +-
 drivers/net/wireless/realtek/rtw89/regd.c          |    8 +-
 drivers/net/wireless/realtek/rtw89/rtw8851b.c      |    5 +
 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk.c  |    4 +-
 .../wireless/realtek/rtw89/rtw8851b_rfk_table.c    |    3 +-
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c     |    8 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   13 +
 drivers/net/wireless/realtek/rtw89/rtw8852au.c     |    8 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   34 +-
 drivers/net/wireless/realtek/rtw89/rtw8852bt.c     |    6 +
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c     |    8 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   17 +
 drivers/net/wireless/realtek/rtw89/rtw8852cu.c     |    9 +-
 drivers/net/wireless/realtek/rtw89/rtw8922a.c      |    4 +-
 drivers/net/wireless/realtek/rtw89/rtw8922au.c     |   14 +-
 drivers/net/wireless/realtek/rtw89/rtw8922d.c      |  260 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |   13 +-
 drivers/net/wireless/realtek/rtw89/usb.c           |   18 +-
 drivers/net/wireless/realtek/rtw89/usb.h           |    3 +-
 drivers/net/wireless/realtek/rtw89/util.h          |    4 +
 drivers/net/wireless/realtek/rtw89/wow.c           |   27 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |   11 +-
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/rtl8723bs/Kconfig                  |   13 -
 drivers/staging/rtl8723bs/Makefile                 |   60 -
 drivers/staging/rtl8723bs/TODO                     |    7 -
 drivers/staging/rtl8723bs/core/rtw_ap.c            | 1943 -------
 drivers/staging/rtl8723bs/core/rtw_btcoex.c        |   75 -
 drivers/staging/rtl8723bs/core/rtw_cmd.c           | 1936 -------
 drivers/staging/rtl8723bs/core/rtw_efuse.c         |  253 -
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     | 1206 ----
 drivers/staging/rtl8723bs/core/rtw_io.c            |  145 -
 drivers/staging/rtl8723bs/core/rtw_ioctl_set.c     |  494 --
 drivers/staging/rtl8723bs/core/rtw_mlme.c          | 2568 ---------
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      | 5901 --------------------
 drivers/staging/rtl8723bs/core/rtw_pwrctrl.c       | 1139 ----
 drivers/staging/rtl8723bs/core/rtw_recv.c          | 2249 --------
 drivers/staging/rtl8723bs/core/rtw_security.c      | 1470 -----
 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c       |  549 --
 drivers/staging/rtl8723bs/core/rtw_wlan_util.c     | 1759 ------
 drivers/staging/rtl8723bs/core/rtw_xmit.c          | 2569 ---------
 drivers/staging/rtl8723bs/hal/Hal8723BReg.h        |   65 -
 drivers/staging/rtl8723bs/hal/HalBtc8723b1Ant.c    | 2595 ---------
 drivers/staging/rtl8723bs/hal/HalBtc8723b1Ant.h    |  184 -
 drivers/staging/rtl8723bs/hal/HalBtc8723b2Ant.c    | 2624 ---------
 drivers/staging/rtl8723bs/hal/HalBtc8723b2Ant.h    |  146 -
 drivers/staging/rtl8723bs/hal/HalBtcOutSrc.h       |  426 --
 drivers/staging/rtl8723bs/hal/HalHWImg8723B_BB.c   |  556 --
 drivers/staging/rtl8723bs/hal/HalHWImg8723B_BB.h   |   39 -
 drivers/staging/rtl8723bs/hal/HalHWImg8723B_MAC.c  |  237 -
 drivers/staging/rtl8723bs/hal/HalHWImg8723B_MAC.h  |   19 -
 drivers/staging/rtl8723bs/hal/HalHWImg8723B_RF.c   |  554 --
 drivers/staging/rtl8723bs/hal/HalHWImg8723B_RF.h   |   40 -
 drivers/staging/rtl8723bs/hal/HalPhyRf.c           |  268 -
 drivers/staging/rtl8723bs/hal/HalPhyRf.h           |   39 -
 drivers/staging/rtl8723bs/hal/HalPhyRf_8723B.c     | 1767 ------
 drivers/staging/rtl8723bs/hal/HalPhyRf_8723B.h     |   66 -
 drivers/staging/rtl8723bs/hal/HalPwrSeqCmd.c       |  144 -
 drivers/staging/rtl8723bs/hal/Mp_Precomp.h         |   23 -
 drivers/staging/rtl8723bs/hal/hal_btcoex.c         | 1303 -----
 drivers/staging/rtl8723bs/hal/hal_com.c            |  767 ---
 drivers/staging/rtl8723bs/hal/hal_com_phycfg.c     |  973 ----
 drivers/staging/rtl8723bs/hal/hal_intf.c           |  283 -
 drivers/staging/rtl8723bs/hal/hal_pwr_seq.c        |  128 -
 drivers/staging/rtl8723bs/hal/hal_sdio.c           |  100 -
 drivers/staging/rtl8723bs/hal/odm.c                |  988 ----
 drivers/staging/rtl8723bs/hal/odm.h                | 1109 ----
 drivers/staging/rtl8723bs/hal/odm_CfoTracking.c    |  210 -
 drivers/staging/rtl8723bs/hal/odm_CfoTracking.h    |   39 -
 drivers/staging/rtl8723bs/hal/odm_DIG.c            |  799 ---
 drivers/staging/rtl8723bs/hal/odm_DIG.h            |  164 -
 .../rtl8723bs/hal/odm_DynamicBBPowerSaving.c       |   81 -
 .../rtl8723bs/hal/odm_DynamicBBPowerSaving.h       |   31 -
 drivers/staging/rtl8723bs/hal/odm_DynamicTxPower.c |   22 -
 drivers/staging/rtl8723bs/hal/odm_DynamicTxPower.h |   29 -
 drivers/staging/rtl8723bs/hal/odm_EdcaTurboCheck.c |  158 -
 drivers/staging/rtl8723bs/hal/odm_EdcaTurboCheck.h |   23 -
 drivers/staging/rtl8723bs/hal/odm_HWConfig.c       |  439 --
 drivers/staging/rtl8723bs/hal/odm_HWConfig.h       |   85 -
 drivers/staging/rtl8723bs/hal/odm_RegConfig8723B.c |  176 -
 drivers/staging/rtl8723bs/hal/odm_RegConfig8723B.h |   45 -
 drivers/staging/rtl8723bs/hal/odm_RegDefine11N.h   |  160 -
 drivers/staging/rtl8723bs/hal/odm_interface.h      |   29 -
 drivers/staging/rtl8723bs/hal/odm_precomp.h        |   47 -
 drivers/staging/rtl8723bs/hal/odm_reg.h            |   91 -
 drivers/staging/rtl8723bs/hal/odm_types.h          |   40 -
 drivers/staging/rtl8723bs/hal/rtl8723b_cmd.c       |  933 ----
 drivers/staging/rtl8723bs/hal/rtl8723b_dm.c        |  256 -
 drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c  | 2826 ----------
 drivers/staging/rtl8723bs/hal/rtl8723b_phycfg.c    |  759 ---
 drivers/staging/rtl8723bs/hal/rtl8723b_rf6052.c    |  135 -
 drivers/staging/rtl8723bs/hal/rtl8723b_rxdesc.c    |   69 -
 drivers/staging/rtl8723bs/hal/rtl8723bs_recv.c     |  477 --
 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c     |  568 --
 drivers/staging/rtl8723bs/hal/sdio_halinit.c       | 1192 ----
 drivers/staging/rtl8723bs/hal/sdio_ops.c           |  859 ---
 drivers/staging/rtl8723bs/include/Hal8192CPhyReg.h |  232 -
 drivers/staging/rtl8723bs/include/HalPwrSeqCmd.h   |  111 -
 drivers/staging/rtl8723bs/include/basic_types.h    |  175 -
 drivers/staging/rtl8723bs/include/cmd_osdep.h      |   16 -
 drivers/staging/rtl8723bs/include/drv_types.h      |  431 --
 drivers/staging/rtl8723bs/include/drv_types_sdio.h |   25 -
 drivers/staging/rtl8723bs/include/hal_btcoex.h     |   54 -
 drivers/staging/rtl8723bs/include/hal_com.h        |  152 -
 drivers/staging/rtl8723bs/include/hal_com_h2c.h    |   28 -
 drivers/staging/rtl8723bs/include/hal_com_phycfg.h |  108 -
 drivers/staging/rtl8723bs/include/hal_com_reg.h    |  594 --
 drivers/staging/rtl8723bs/include/hal_data.h       |  276 -
 drivers/staging/rtl8723bs/include/hal_intf.h       |  250 -
 drivers/staging/rtl8723bs/include/hal_pg.h         |   63 -
 drivers/staging/rtl8723bs/include/hal_phy.h        |   73 -
 drivers/staging/rtl8723bs/include/hal_phy_cfg.h    |   63 -
 drivers/staging/rtl8723bs/include/hal_phy_reg.h    |   17 -
 drivers/staging/rtl8723bs/include/hal_pwr_seq.h    |  226 -
 drivers/staging/rtl8723bs/include/hal_sdio.h       |   18 -
 drivers/staging/rtl8723bs/include/ieee80211.h      |  748 ---
 drivers/staging/rtl8723bs/include/ioctl_cfg80211.h |   58 -
 drivers/staging/rtl8723bs/include/osdep_intf.h     |   42 -
 drivers/staging/rtl8723bs/include/osdep_service.h  |   53 -
 .../rtl8723bs/include/osdep_service_linux.h        |  118 -
 drivers/staging/rtl8723bs/include/rtl8192c_recv.h  |   33 -
 drivers/staging/rtl8723bs/include/rtl8723b_cmd.h   |  182 -
 drivers/staging/rtl8723bs/include/rtl8723b_dm.h    |   32 -
 drivers/staging/rtl8723bs/include/rtl8723b_hal.h   |  246 -
 drivers/staging/rtl8723bs/include/rtl8723b_recv.h  |   95 -
 drivers/staging/rtl8723bs/include/rtl8723b_rf.h    |   17 -
 drivers/staging/rtl8723bs/include/rtl8723b_spec.h  |  237 -
 drivers/staging/rtl8723bs/include/rtl8723b_xmit.h  |  421 --
 drivers/staging/rtl8723bs/include/rtw_ap.h         |   39 -
 drivers/staging/rtl8723bs/include/rtw_btcoex.h     |   27 -
 drivers/staging/rtl8723bs/include/rtw_byteorder.h  |   16 -
 drivers/staging/rtl8723bs/include/rtw_cmd.h        |  705 ---
 drivers/staging/rtl8723bs/include/rtw_eeprom.h     |  118 -
 drivers/staging/rtl8723bs/include/rtw_efuse.h      |   78 -
 drivers/staging/rtl8723bs/include/rtw_event.h      |   92 -
 drivers/staging/rtl8723bs/include/rtw_ht.h         |   83 -
 drivers/staging/rtl8723bs/include/rtw_io.h         |   58 -
 drivers/staging/rtl8723bs/include/rtw_ioctl_set.h  |   27 -
 drivers/staging/rtl8723bs/include/rtw_mlme.h       |  397 --
 drivers/staging/rtl8723bs/include/rtw_mlme_ext.h   |  708 ---
 drivers/staging/rtl8723bs/include/rtw_pwrctrl.h    |  254 -
 drivers/staging/rtl8723bs/include/rtw_qos.h        |   15 -
 drivers/staging/rtl8723bs/include/rtw_recv.h       |  457 --
 drivers/staging/rtl8723bs/include/rtw_rf.h         |  100 -
 drivers/staging/rtl8723bs/include/rtw_security.h   |  272 -
 drivers/staging/rtl8723bs/include/rtw_version.h    |    3 -
 drivers/staging/rtl8723bs/include/rtw_wifi_regd.h  |   16 -
 drivers/staging/rtl8723bs/include/rtw_xmit.h       |  470 --
 drivers/staging/rtl8723bs/include/sdio_hal.h       |   14 -
 drivers/staging/rtl8723bs/include/sdio_ops.h       |   33 -
 drivers/staging/rtl8723bs/include/sdio_ops_linux.h |   29 -
 drivers/staging/rtl8723bs/include/sta_info.h       |  330 --
 drivers/staging/rtl8723bs/include/wifi.h           |  409 --
 drivers/staging/rtl8723bs/include/wlan_bssdef.h    |  195 -
 drivers/staging/rtl8723bs/include/xmit_osdep.h     |   43 -
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  | 2798 ----------
 drivers/staging/rtl8723bs/os_dep/os_intfs.c        | 1189 ----
 drivers/staging/rtl8723bs/os_dep/osdep_service.c   |  201 -
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c       |  465 --
 drivers/staging/rtl8723bs/os_dep/sdio_ops_linux.c  |  495 --
 drivers/staging/rtl8723bs/os_dep/wifi_regd.c       |  129 -
 drivers/staging/rtl8723bs/os_dep/xmit_linux.c      |  216 -
 include/net/cfg80211.h                             |   93 +-
 include/net/mac80211.h                             |   25 +
 include/uapi/linux/nl80211.h                       |   16 +
 net/mac80211/cfg.c                                 |  552 +-
 net/mac80211/debugfs.c                             |    1 +
 net/mac80211/driver-ops.c                          |   76 +
 net/mac80211/driver-ops.h                          |   62 +-
 net/mac80211/ieee80211_i.h                         |   25 +-
 net/mac80211/link.c                                |    1 +
 net/mac80211/main.c                                |   10 +-
 net/mac80211/mesh_pathtbl.c                        |   25 +-
 net/mac80211/offchannel.c                          |  334 +-
 net/mac80211/parse.c                               |    7 +-
 net/mac80211/rate.c                                |    5 -
 net/mac80211/rx.c                                  |    1 +
 net/mac80211/scan.c                                |   18 +-
 net/mac80211/sta_info.c                            |  133 +-
 net/mac80211/sta_info.h                            |   10 +-
 net/mac80211/tests/chan-mode.c                     |   19 +-
 net/mac80211/trace.h                               |   28 +
 net/mac80211/tx.c                                  |  128 +-
 net/wireless/chan.c                                |    2 +-
 net/wireless/core.c                                |   97 +-
 net/wireless/core.h                                |   47 +-
 net/wireless/debugfs.c                             |    3 +
 net/wireless/mlme.c                                |  152 +-
 net/wireless/nl80211.c                             |  977 +++-
 net/wireless/rdev-ops.h                            |   50 +
 net/wireless/reg.c                                 |  235 +-
 net/wireless/reg.h                                 |    2 +-
 net/wireless/sme.c                                 |   42 +-
 net/wireless/trace.h                               |   47 +-
 net/wireless/util.c                                |   11 +
 net/wireless/wext-sme.c                            |    3 +
 507 files changed, 18522 insertions(+), 72339 deletions(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/ctxt-info-v2.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/api/ctxt-info.h
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-io.c
 delete mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-io.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mld/tests/tx-gp2.c
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/internal.h (92%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/rx.c (93%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/trans-gen2.c (87%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/trans.c (84%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/tx-gen2.c (99%)
 rename drivers/net/wireless/intel/iwlwifi/pcie/{gen1_2 => }/tx.c (94%)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/cached_cal.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723bs.c
 delete mode 100644 drivers/staging/rtl8723bs/Kconfig
 delete mode 100644 drivers/staging/rtl8723bs/Makefile
 delete mode 100644 drivers/staging/rtl8723bs/TODO
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_ap.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_btcoex.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_cmd.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_efuse.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_ieee80211.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_io.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_ioctl_set.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_mlme.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_pwrctrl.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_recv.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_security.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_wlan_util.c
 delete mode 100644 drivers/staging/rtl8723bs/core/rtw_xmit.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/Hal8723BReg.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalBtc8723b1Ant.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalBtc8723b1Ant.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalBtc8723b2Ant.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalBtc8723b2Ant.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalBtcOutSrc.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalHWImg8723B_BB.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalHWImg8723B_BB.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalHWImg8723B_MAC.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalHWImg8723B_MAC.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalHWImg8723B_RF.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalHWImg8723B_RF.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalPhyRf.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalPhyRf.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalPhyRf_8723B.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalPhyRf_8723B.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/HalPwrSeqCmd.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/Mp_Precomp.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/hal_btcoex.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/hal_com.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/hal_intf.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/hal_pwr_seq.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/hal_sdio.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_CfoTracking.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_CfoTracking.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_DIG.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_DIG.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_DynamicBBPowerSaving.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_DynamicBBPowerSaving.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_DynamicTxPower.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_DynamicTxPower.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_EdcaTurboCheck.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_EdcaTurboCheck.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_HWConfig.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_HWConfig.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_RegConfig8723B.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_RegConfig8723B.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_RegDefine11N.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_interface.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_precomp.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_reg.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/odm_types.h
 delete mode 100644 drivers/staging/rtl8723bs/hal/rtl8723b_cmd.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/rtl8723b_dm.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/rtl8723b_phycfg.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/rtl8723b_rf6052.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/rtl8723b_rxdesc.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/rtl8723bs_recv.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/sdio_halinit.c
 delete mode 100644 drivers/staging/rtl8723bs/hal/sdio_ops.c
 delete mode 100644 drivers/staging/rtl8723bs/include/Hal8192CPhyReg.h
 delete mode 100644 drivers/staging/rtl8723bs/include/HalPwrSeqCmd.h
 delete mode 100644 drivers/staging/rtl8723bs/include/basic_types.h
 delete mode 100644 drivers/staging/rtl8723bs/include/cmd_osdep.h
 delete mode 100644 drivers/staging/rtl8723bs/include/drv_types.h
 delete mode 100644 drivers/staging/rtl8723bs/include/drv_types_sdio.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_btcoex.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_com.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_com_h2c.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_com_phycfg.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_com_reg.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_data.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_intf.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_pg.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_phy.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_phy_cfg.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_phy_reg.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_pwr_seq.h
 delete mode 100644 drivers/staging/rtl8723bs/include/hal_sdio.h
 delete mode 100644 drivers/staging/rtl8723bs/include/ieee80211.h
 delete mode 100644 drivers/staging/rtl8723bs/include/ioctl_cfg80211.h
 delete mode 100644 drivers/staging/rtl8723bs/include/osdep_intf.h
 delete mode 100644 drivers/staging/rtl8723bs/include/osdep_service.h
 delete mode 100644 drivers/staging/rtl8723bs/include/osdep_service_linux.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtl8192c_recv.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtl8723b_cmd.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtl8723b_dm.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtl8723b_hal.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtl8723b_recv.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtl8723b_rf.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtl8723b_spec.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtl8723b_xmit.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_ap.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_btcoex.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_byteorder.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_cmd.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_eeprom.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_efuse.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_event.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_ht.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_io.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_ioctl_set.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_mlme.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_mlme_ext.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_pwrctrl.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_qos.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_recv.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_rf.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_security.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_version.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_wifi_regd.h
 delete mode 100644 drivers/staging/rtl8723bs/include/rtw_xmit.h
 delete mode 100644 drivers/staging/rtl8723bs/include/sdio_hal.h
 delete mode 100644 drivers/staging/rtl8723bs/include/sdio_ops.h
 delete mode 100644 drivers/staging/rtl8723bs/include/sdio_ops_linux.h
 delete mode 100644 drivers/staging/rtl8723bs/include/sta_info.h
 delete mode 100644 drivers/staging/rtl8723bs/include/wifi.h
 delete mode 100644 drivers/staging/rtl8723bs/include/wlan_bssdef.h
 delete mode 100644 drivers/staging/rtl8723bs/include/xmit_osdep.h
 delete mode 100644 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
 delete mode 100644 drivers/staging/rtl8723bs/os_dep/os_intfs.c
 delete mode 100644 drivers/staging/rtl8723bs/os_dep/osdep_service.c
 delete mode 100644 drivers/staging/rtl8723bs/os_dep/sdio_intf.c
 delete mode 100644 drivers/staging/rtl8723bs/os_dep/sdio_ops_linux.c
 delete mode 100644 drivers/staging/rtl8723bs/os_dep/wifi_regd.c
 delete mode 100644 drivers/staging/rtl8723bs/os_dep/xmit_linux.c
