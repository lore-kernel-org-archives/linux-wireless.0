Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDBD3BE659;
	Wed, 22 Jul 2026 09:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784712417; cv=none; b=exmsfg4Aai/Im0XjFPL2J//ODaP8jFa9CyOMDOyMqNHW5laI1UAFGEuVCtuZDoVHnYK6hOGRRM5z5+g0tl+tZJH6g/SXS1nqRtzik1ufBv1LwdvipCJHOY+qaLI+4lV0w+U8geMUb33loPPPV8yHFxRcFlx1kVu3Woi3myan5eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784712417; c=relaxed/simple;
	bh=UQ6DyOCieraBnN8bHwqFFkRd/yx83WscBhPAr+VifWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bz4xrHEyPsSDgbTMZd628+F0oSE8CuUDPTg10XW6r5GqHv90B+b7z0XAeIV9fsJf8neG7pOxTnKH9TWSo92++nwqBThvDYvmiy01FyScHs8a1jt+sRm2m4NTqxjIUuxD13FopHEshP7Pmtu5CpwZZKtZLvtkykH4VIVQoXKeqDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=c88ytS6z; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="c88ytS6z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=iJONQAS6oG+naxITi2YrXAvxMse5p8AXp4XzVE+w7a0=; t=1784712413; x=1785922013; 
	b=c88ytS6zugDVcSMEoRn3RQfYNx/obp6UrvQKMiggrwb21xOIPuvUyPKVmslzSGEEq7yGZZvaAyp
	z46yY4pMwjBfNDqSsjFk7dfaoXfknGDDXgSfX8Ay6OZ+GaWLjsdUcD+IYBAI+6YAAoIXsDGFuf+to
	gQv0HH/npzikUVLlr12qKTSHP0BheT+y5/C1YrebMYfRXIYJ6uDabvCJk5r5anUpcQ9NG0VtYvYM2
	Dkjh2Hku0hGhMeifJZx/HrwL7rDin5D6EFP4HpWotAbWPtSMvDZFGN7SJFAXE1nM07ayTI9M71aHi
	c39EAlLX0okf+0guWaSaNqy60sBUoYo/DStw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmTE2-00000004f7s-1fn4;
	Wed, 22 Jul 2026 11:26:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-07-22
Date: Wed, 22 Jul 2026 11:24:38 +0200
Message-ID: <20260722092647.119094-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
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

So unfortunately this is really big, in part due to the
conference last week which caused me to miss that week,
but also mostly recentlky drivers coming with alrge pull
requests with a whole lot of security/robustness fixes.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit e13caf1c26587434f0b768193100440939c0fb91:

  Merge tag 'net-7.2-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-07-17 10:25:13 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-07-22

for you to fetch changes up to 7cb34f6c4fe8a68af621d870abe63bfca2275dd6:

  wifi: brcmfmac: fix 802.1X-SHA256 call trace warning (2026-07-22 11:18:02 +0200)

----------------------------------------------------------------
Lots of fixes:
 - mostly driver security/robustness/warning fixes
 - ath12k: fix MLO throughput regression
 - iwlwifi: add UNII-9 to avoid regression
 - brcmfmac:
   - fix 802.1X-SHA256
   - SDIO fix for some boards
 - mac80211:
   - fix traffic indication for sleeping STAs
   - fix NAN throughput

----------------------------------------------------------------
Andrew Pope (1):
      wifi: mac80211: recalculate TIM when a station enters power save

Arnd Bergmann (1):
      wifi: mt76: fix airoha_npu dependency tracking

Avraham Stern (2):
      wifi: iwlwifi: mvm: verify scan id reported by firmware
      wifi: iwlwifi: mvm: copy the correct TK length for ranging

Benjamin Berg (1):
      wifi: mac80211: copy aggregation information

Cheng Yongkang (1):
      wifi: ath9k: hif_usb: don't dereference hif_dev after re-arming firmware request

Daniel Hodges (1):
      wifi: ath6kl: fix use-after-free in aggr_reset_state()

Devin Wittmayer (4):
      wifi: mt76: mt7921: drop TXRX_NOTIFY on non-mmio buses
      wifi: mt76: mt7925: drop TXRX_NOTIFY on non-mmio buses
      wifi: mt76: mt7615: drop TXRX_NOTIFY on non-mmio buses
      wifi: mt76: restrict NPU/PPE active checks to MMIO devices

Dmitry Morgun (1):
      wifi: ath11k: fix potential buffer underflow in ath11k_hal_rx_msdu_list_get()

Doruk Tan Ozturk (1):
      wifi: mwifiex: fix NULL dereference when the AP has HT-cap but no HT-oper

Emmanuel Grumbach (30):
      wifi: iwlwifi: mvm: fix an off-by-1 boundary check
      wifi: iwlwifi: mld: fix an off-by-1 boundary check
      wifi: iwlwifi: mld: don't parse a notif before checking its length
      wifi: iwlwifi: mvm: fix the FCS truncation logic in d3
      wifi: iwlwifi: mld: validate reorder BAID
      wifi: iwlwifi: mvm: parse beacon notif per layout
      wifi: iwlwifi: mvm: validate MCC header before n_channels
      wifi: iwlwifi: mvm: validate sta_id in TLC notif
      wifi: iwlwifi: mvm: validate sta_id in BA window status notif
      wifi: iwlwifi: mvm: validate mac_link_id in session protect notif
      wifi: iwlwifi: mld: clear tzone on fail
      wifi: iwlwifi: mvm: fix sched scan IE sizing
      wifi: iwlwifi: pcie: null RX pointers after free
      wifi: iwlwifi: mvm: d3: validate D3 resume notification payloads
      wifi: iwlwifi: mld: validate txq_id in TX response handler
      wifi: iwlwifi: add support for additional channels in NVM_GET_INFO
      wifi: iwlwifi: mvm: validate TX_CMD response layout
      wifi: iwlwifi: fix pointer arithmetic in iwl_add_mcc_to_tas_block_list
      wifi: iwlwifi: validate payload length in iwl_pnvm_complete_fn
      wifi: iwlwifi: mvm: ptp: free response on success path
      wifi: iwlwifi: pcie: validate FW section counts in iwl_pcie_init_fw_sec
      wifi: iwlwifi: mvm: fix out-of-bounds tid_data access in BA notif
      wifi: iwlwifi: mvm: add a check on the tid coming from the firmware
      wifi: iwlwifi: mvm: fix a possible underflow
      wifi: iwlwifi: adapt ND match notif sizing to fixed matches array
      wifi: iwlwifi: bound aligned TLV advance in FW parser
      wifi: iwlwifi: dbg-tlv: bound aligned TLV walk length
      wifi: iwlwifi: acpi: validate WGDS table revision index
      wifi: iwlwifi: uefi: bound PPAG revision bitmap shift
      wifi: iwlwifi: validate SEC_RT TLV minimum size

Fan Wu (2):
      wifi: brcmfmac: make release_scratchbuffers idempotent
      wifi: brcmfmac: drain bus_reset work on device removal

Gaole Zhang (1):
      wifi: ath11k: fix NULL pointer dereference in ath11k_hal_srng_access_begin

Georgi Valkov (2):
      wifi: mwifiex: fix freeze for 60 seconds caused by request_firmware
      wifi: mwifiex: replace one-element arrays with flexible array members

Guangshuo Li (1):
      wifi: mt76: mt7925: guard link STA in decap offload

HE WEI (ギカク) (1):
      wifi: mwifiex: bound uAP association event IEs to the event buffer

Huihui Huang (2):
      wifi: wilc1000: validate assoc response length before subtracting header
      wifi: at76c50x-usb: avoid length underflow in at76_guess_freq()

Ibrahim Hashimov (1):
      wifi: mac80211_hwsim: reject undersized HWSIM_ATTR_TX_INFO

Johannes Berg (3):
      Merge tag 'ath-current-20260713' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath
      Merge tag 'iwlwifi-fixes-2026-07-21' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'mt76-fixes-2026-07-22' of https://github.com/nbd168/wireless

Jose Ignacio Tornos Martinez (1):
      wifi: ath12k: fix NULL pointer dereference in rhash table destroy

LiangCheng Wang (1):
      wifi: brcmfmac: set F2 blocksize to 256 for BCM43752

Lorenzo Bianconi (4):
      wifi: mt76: connac: fix possible NULL-pointer deref in mt76_connac_mcu_uni_bss_he_tlv()
      wifi: mt76: mt7925: fix possible NULL-pointer deref in mt7925_mcu_bss_he_tlv()
      wifi: mt76: mt7996: check pointer returned by mt76_connac_get_he_phy_cap()
      wifi: mt76: mt7996: fix possible NULL-pointer deref in mt7996_mcu_sta_bfer_eht()

Manikanta Pubbisetty (1):
      wifi: ath10k: fix skb leak on incomplete msdu during rx pop

Manivannan Sadhasivam (2):
      wifi: ath11k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET
      wifi: ath12k: Flush the posted write after writing to PCIE_SOC_GLOBAL_RESET

Nicolas Cavallari (1):
      wifi: mt76: Disable napi when removing device

Pagadala Yesu Anjaneyulu (1):
      wifi: iwlwifi: mvm: validate SAR GEO response payload size

Rosen Penev (1):
      wifi: mt76: fix MAC address for non OF pcie cards

Ruoyu Wang (1):
      wifi: mt76: mt7915: guard HE capability lookups

Sean Wang (1):
      wifi: mt76: mt7925: fix crash in reset link replay

Shahar Tzarfati (2):
      wifi: iwlwifi: fw: validate SMEM response size
      wifi: iwlwifi: mvm: fix read in wake packet notification handler

Shelley Yang (1):
      wifi: brcmfmac: fix 802.1X-SHA256 call trace warning

Tristan Madani (6):
      wifi: ath6kl: fix OOB access from firmware ADDBA window size
      wifi: ath6kl: fix OOB read from firmware num_msg in TX complete handler
      wifi: ath6kl: fix OOB read from firmware IE lengths in connect event
      wifi: carl9170: bound memcpy length in cmd callback to prevent OOB read
      wifi: carl9170: fix OOB read from off-by-two in TX status handler
      wifi: carl9170: fix buffer overflow in rx_stream failover path

Wentao Liang (1):
      wifi: ath11k: fix refcount leak in ath11k_ahb_fw_resources_init()

Xiang Mei (1):
      wifi: mac80211: tear down new links on vif update error path

Yingying Tang (1):
      wifi: ath12k: Fix low MLO RX throughput on WCN7850

Zhao Li (1):
      wifi: cfg80211: guard optional PMSR nominal time

 drivers/net/wireless/ath/ath10k/htt_rx.c           |  2 +
 drivers/net/wireless/ath/ath11k/ahb.c              |  1 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  3 +
 drivers/net/wireless/ath/ath11k/pci.c              |  4 ++
 drivers/net/wireless/ath/ath11k/qmi.c              | 11 +++-
 drivers/net/wireless/ath/ath12k/dp_peer.c          | 11 +++-
 drivers/net/wireless/ath/ath12k/dp_peer.h          |  1 +
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  7 +--
 drivers/net/wireless/ath/ath12k/hw.h               | 16 ++++++
 drivers/net/wireless/ath/ath12k/mac.c              | 10 +++-
 drivers/net/wireless/ath/ath12k/pci.c              |  4 ++
 drivers/net/wireless/ath/ath12k/peer.c             |  3 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      | 33 +++++++++++
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h      |  6 ++
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |  3 +
 drivers/net/wireless/ath/ath6kl/txrx.c             | 12 ++--
 drivers/net/wireless/ath/ath6kl/wmi.c              | 20 +++++++
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  7 +--
 drivers/net/wireless/ath/carl9170/rx.c             |  7 ++-
 drivers/net/wireless/ath/carl9170/tx.c             |  2 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |  7 ++-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 14 +++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  6 ++
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 46 ++++++++++++++--
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 14 ++++-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  6 ++
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  3 +
 drivers/net/wireless/intel/iwlwifi/cfg/rf-pe.c     |  1 +
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  5 ++
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    | 33 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |  4 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  9 ++-
 drivers/net/wireless/intel/iwlwifi/fw/regulatory.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       | 28 ++++++++--
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  2 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   | 13 ++++-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       | 18 +++++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 64 ++++++++++++++--------
 drivers/net/wireless/intel/iwlwifi/mld/agg.c       |  7 ++-
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/mld/mcc.c       | 10 +++-
 drivers/net/wireless/intel/iwlwifi/mld/thermal.c   |  9 ++-
 drivers/net/wireless/intel/iwlwifi/mld/tx.c        |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        | 46 +++++++++++-----
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 55 +++++++++++++------
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 10 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  | 25 +++++----
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  7 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  3 -
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       | 43 ++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c       |  4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 10 +++-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |  5 ++
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 45 ++++++++++++++-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |  7 ++-
 .../net/wireless/intel/iwlwifi/pcie/gen1_2/rx.c    |  9 ++-
 drivers/net/wireless/marvell/mwifiex/fw.h          | 18 +++---
 drivers/net/wireless/marvell/mwifiex/join.c        |  8 +--
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   | 14 +++--
 drivers/net/wireless/marvell/mwifiex/tdls.c        |  2 +-
 drivers/net/wireless/marvell/mwifiex/uap_event.c   | 24 +++++++-
 drivers/net/wireless/mediatek/mt76/Kconfig         |  4 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |  6 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  5 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |  6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  6 ++
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  2 +
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 18 ++++--
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 10 +++-
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c    | 13 ++++-
 drivers/net/wireless/mediatek/mt76/mt7925/main.c   |  3 +
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c    |  2 +
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    | 19 +++++--
 drivers/net/wireless/microchip/wilc1000/hif.c      |  5 ++
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |  6 +-
 net/mac80211/cfg.c                                 |  3 +
 net/mac80211/link.c                                |  4 ++
 net/mac80211/rx.c                                  |  2 +
 net/wireless/pmsr.c                                |  5 +-
 87 files changed, 745 insertions(+), 204 deletions(-)
