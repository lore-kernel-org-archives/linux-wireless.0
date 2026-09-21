Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C745848EC69;
	Mon, 21 Sep 2026 12:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789993005; cv=none; b=dIHEqpmSjj7TXkGH4BdSuIoZofJWkFdsy1Oa8rYnt7um1/MPjRcIM5gEUBAODXEJg+khet3WfF092U2nRCro2WtMb65pWvEEXDkZNgIUYWY9jn4w/hWRGtO4MWzbhSmWmriq1UJhKGkA9BqMHyAkF9tO8k3jHPjfKh5FNXQCe8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789993005; c=relaxed/simple;
	bh=HoRUWZxhCAqdw+8+a4EFqtX1hL+OT8uB4TMYYLT4HNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=F/aHOloRAy+rvG3Kln8jC4ARYbJ1fOiXoEbgLQzH5InWLij+T84SOWP+GSrg57Hte+0o9SKikDca2Ara+OihL8nHPh0mCbwwuinvLJeOoks+fRdq8bClkqfy+hMuR4uhYdVoCapjagtqcD63duZ+KNqp/aXLHF+n1Tw+SRql2Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=shNsvkIf; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="shNsvkIf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=SQLcL0EabcuQ20fdleihUVnZe9ujpz9riTTTswoADpw=; t=1789993002; x=1791202602; 
	b=shNsvkIfwxB2iYLgwGOOg1dziy85O1B01PGFGSemIh9HTxi5uogRVhcXvNsPvAZ5mXe6y5mNyED
	qQ+8P0Jnoq+zUg0dTwr2pzxTQMz4WIrt8d7oYBxtqhdqZ0yeyKQig3+fKBZ3hSTybn7Ur3PViG3pM
	eGNb38gAOdhNjzr/6Ypb8mH5OPtj/kTd0KAqhR5DpdUJKxEwmdX93SoSv5Q5X9TMLiBtFmQvUmRUp
	yw5LcryNHhxVvuV18b8DaFFBNe68HDQeML/ezevJZByEvcfl5elfqDjWM+vpNjmI4mF1cNdyDmzh6
	GOZk8qsOA4k04T1qtZucAMs4xQU60H1qS/PA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8cwo-00000005nuT-2ISf;
	Mon, 21 Sep 2026 14:16:39 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-next-2026-09-21
Date: Mon, 21 Sep 2026 14:13:46 +0200
Message-ID: <20260921121635.195723-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
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

Some more changes - mostly not very interesting I guess.
I haven't received most driver updates yet.

Note there are some merge conflicts - most are reasonably
easy but the bigger net/mac80211/tx.c one is a bit annoying,
but it's "take the wireless-next version". I've pushed an
example resolution to the 'merge-2026-09-21' branch in my
(wireless-next) tree.
(I had fixed an issue in wireless, but also did some bigger
refactoring/cleanup in wireless-next that fixed the same
issue as well, just differently.)

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit a5249d1d9a618b31e15e191faa4122dc5d9912b1:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-09-03 10:48:16 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2026-09-21

for you to fetch changes up to 6c0b7357e3c7f365ec51dd8d2b626130ee983ce1:

  dt-bindings: net: wireless: Convert WL1251 to DT schema (2026-09-21 10:54:26 +0200)

----------------------------------------------------------------
More changes, including drivers:
 - brcmfmac: FT/OKC roaming offload
 - ath12k: IPQ5332 platform infrastructure
 - cfg80211/mac80211: non-STA TX/RX infrastructure
   for MLO to fix address translation bugs
 - the rest is mostly minor cleanups etc.

----------------------------------------------------------------
Aaradhana Sahu (4):
      mailmap: add entries for Aaradhana Sahu
      wifi: ath12k: Free allocated CE IRQs on request_irq() failure
      wifi: ath12k: Free allocated external IRQs on request_irq() failure
      wifi: ath12k: add support to load shared firmware on multiPD

Abdun Nihaal (1):
      wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()

Andrew LaMarche (2):
      wifi: ath12k: support calibration-variant from device tree
      dt-bindings: wireless: ath12k: drop qcom,ath12k-calibration-variant

Baochen Qiang (8):
      wifi: ath12k: signal regd update completion when reg event is dropped
      wifi: ath12k: use per-radio ab in ath12k_mac_hw_register()
      wifi: ath12k: protect new_alpha2 access with base_lock
      wifi: ath12k: skip setting country code during registration when unchanged
      mailmap: add entries for Baochen Qiang
      wifi: ath12k: use kernel types instead of userspace stdint types
      wifi: ath12k: fix stale skb pointers after aligned TX payload shift
      wifi: ath12k: fix truncated TX buffer DMA address in MSDU ext descriptor

Benjamin Berg (8):
      wifi: iwlwifi: use link_sta internally to the driver
      wifi: mac80211: change public RX API to use link stations
      wifi: mac80211: refactor RX link_id and station handling
      wifi: mac80211: rework RX packet handling
      wifi: cfg80211: add attribute for TX/RX denoting there is no station
      wifi: mac80211: report to cfg80211 when no STA is known for a frame
      wifi: mac80211: pass station to ieee80211_tx_skb_tid
      wifi: mac80211: pass error station if non-STA transmit was requested

Bert Karwatzki (1):
      mac80211: tx: Use info->flags in ieee80211_tx_h_select_key()

Carella Chen (3):
      wifi: nl80211: add fast roam offload extended feature
      wifi: brcmfmac: detect firmware FBT and OKC support
      wifi: brcmfmac: advertise firmware fast roam offload support

Darren Li (2):
      wifi: brcmfmac: add PMK programming for firmware roaming offload
      wifi: brcmfmac: report port authorization after offloaded roaming

Deepanshu Kartikey (1):
      wifi: mac80211: fix stats/preemption in ieee80211_tx_control_port()

Devin Wittmayer (1):
      wifi: mac80211: fix monitor filter refcount leak

Eduard Bostina (1):
      dt-bindings: net: wireless: Convert WL1251 to DT schema

Georgi Valkov (2):
      dt-bindings: net: wireless: add flag marvell,invalid-reg-hint-in-rom
      wifi: mwifiex: add dt flag to avoid conflict with platform reg domain

Heiner Kallweit (1):
      libertas: mesh: remove unused and undocumented sysfs attribute groups

Jeff Johnson (3):
      wifi: ath12k: remove skb->data check in ath12k_wmi_process_tpc_stats()
      wifi: ath9k: use rcu_dereference_bh() for sta->rates in ath_merge_ratetbl()
      MAINTAINERS: Replace wireless.wiki.kernel.org links

Johannes Berg (26):
      wifi: skip DUO params when looking for NPCA
      wifi: update UHR to Draft_P802.11bn D1.5
      wifi: mac80211: fix unauthorised port check for encap offload
      wifi: mac80211: fix key selection for encap offload frames
      wifi: mac80211: don't send encap offload frames unencrypted
      wifi: mac80211: drop encap offload frames with a tainted key
      wifi: nl80211: don't export nl80211_mlo_reconf_add_done()
      wifi: mac80211: remove ieee80211_sta_ps_transition() return value
      wifi: mac80211: make ieee80211_is_tx_data() internal
      wifi: mac80211: fix IEEE80211_TX_CTL_REQ_TX_STATUS mixup
      wifi: mac80211: tx: simplify control port frame transmission
      wifi: mac80211: remove cookie from __ieee80211_subif_start_xmit()
      wifi: mac80211: unshare the skb before building the header
      wifi: mac80211: report multicast transmission from lookup_ra_sta()
      wifi: mac80211: set flags/ctrl_flags before ieee80211_build_hdr()
      wifi: mac80211: store the ack skb before building the header
      wifi: mac80211_hwsim: fix potential channel crash
      wifi: mac80211_hwsim: overwrite report SKB
      Merge tag 'ath-next-20260916' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath
      wifi: mac80211: tests: fix memory leak
      wifi: mac80211: WARN on 40 MHz HT/HE mismatch
      wifi: mac80211: allow advertising 20 MHz-only non-AP STA
      wifi: ieee80211: fix FTM bufferable check
      wifi: radiotap: correct EHT TB U-SIG 1 B20:25
      wifi: nl80211: rename no-ACK bitmap to TID bitmap
      wifi: mac80211: fix multi-link UHR association

Julius Bairaktaris (4):
      wifi: ath11k: implement CE interrupt enable/disable for AHB
      wifi: ath11k: disable interrupts during firmware crash recovery
      wifi: mac80211: fix swapped fq_overlimit/fq_overmemory in aqm debugfs
      wifi: mac80211: don't reset the TXQ scheduling round number

Jérôme Pouiller (4):
      wifi: wfx: fix possible device hang during init
      dt-bindings: net: wireless: wfx: discourage OOB IRQ with SDIO
      wifi: wfx: fix use-after-free of the cooling work on device removal
      wifi: wfx: fix error code on unsupported firmware

Kamil Bienkiewicz (1):
      wifi: ath12k: advertise AP_VLAN interface mode for IPQ5332

Kang Yang (1):
      wifi: ath12k: preserve PPDU state across monitor status buffers

Karl Mehltretter (1):
      wifi: mac80211: Fix the return value in mesh_path_add() kernel-doc

Lachlan Hodges (4):
      wifi: mac80211: don't seed an S1G sta's last_rate
      wifi: cfg80211: remove duplicate s1g_cap kerneldoc
      wifi: radiotap: add S1G TLVs and channel frequency
      wifi: mac80211: report 900MHz channel for S1G band radiotap header

Linkai Gong (1):
      wifi: ath12k: clear dangling channel pointers on error paths

Manish Dharanenthiran (2):
      mailmap: add entries for Manish Dharanenthiran
      wifi: nl80211: add support to configure 6 GHz non-HT duplicate transmission

Maoyi Xie (1):
      wifi: mac80211_hwsim: send config events to the radio's net namespace

Mariano Baragiola (1):
      wifi: mac80211: avoid trimming injected FCS twice

Miaoqing Pan (3):
      wifi: ath11k: fix sporadic WLAN initialization failures
      wifi: ath11k: fix NULL dereference in ahb remove when QMI init incomplete
      wifi: ath11k: unregister PM notifier on QMI init failure path

Mikhail Lobanov (1):
      wifi: ath11k: modify null check logic in ath11k_ce_rx_post_pipe()

Nicolas Escande (1):
      wifi: ath11k: fix locking problem in ath11k_dp_rx_tid_del_func()

Peng Fan (1):
      wifi: mac80211: use assign_bit() where applicable

Pengpeng Hou (2):
      wifi: libertas_tf: validate firmware block extents
      wifi: libertas: validate firmware block extents

Rameshkumar Sundaram (2):
      mailmap: add entries for Rameshkumar Sundaram
      wifi: ath12k: fix DMA unwind for ext MSDU descriptor retry

Rosen Penev (3):
      wifi: mwifiex: Use flexible array for RX reorder table
      wifi: b43legacy: Use flexible array for DMA metadata
      wifi: rt2x00: Use device-managed register buffers

Ryohei Hashimoto (1):
      wifi: brcmfmac: log the firmware status when a connect fails

Sriram R (1):
      mailmap: add entries for Sriram R

Stanislaw Gruszka (1):
      wifi: mac80211: queue frames while off-channel

Vasanthakumar Thiagarajan (1):
      mailmap: update email address for Vasanthakumar Thiagarajan

Zhiling Zou (1):
      wifi: mac80211: serialize debugfs netdev rename with recreate

 .mailmap                                           |  13 +-
 .../bindings/net/wireless/marvell,sd8787.yaml      |   6 +
 .../bindings/net/wireless/qcom,ath12k-wsi.yaml     |   7 -
 .../bindings/net/wireless/silabs,wfx.yaml          |   3 +
 .../devicetree/bindings/net/wireless/ti,wl1251.txt |  64 ---
 .../bindings/net/wireless/ti,wl1251.yaml           |  85 ++++
 MAINTAINERS                                        |  40 +-
 drivers/net/wireless/ath/ath11k/Kconfig            |   3 +
 drivers/net/wireless/ath/ath11k/ahb.c              |  16 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath11k/core.c             |  10 +
 drivers/net/wireless/ath/ath11k/dp.c               |   2 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  21 +-
 drivers/net/wireless/ath/ath12k/ahb.c              | 166 ++++++-
 drivers/net/wireless/ath/ath12k/ahb.h              |   9 +
 drivers/net/wireless/ath/ath12k/ce.c               |   2 +-
 drivers/net/wireless/ath/ath12k/core.c             |  23 +
 drivers/net/wireless/ath/ath12k/dp.c               |   2 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   2 -
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  20 +-
 drivers/net/wireless/ath/ath12k/hw.h               |  20 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  45 +-
 drivers/net/wireless/ath/ath12k/pci.c              |  55 ++-
 drivers/net/wireless/ath/ath12k/qmi.c              |   4 +
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c        |   3 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c     |  23 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      |  20 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h      |  12 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c      |  17 +-
 drivers/net/wireless/ath/ath12k/wifi7/hal_tx.c     |   2 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |   9 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |  22 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |   2 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c      |  24 +-
 drivers/net/wireless/broadcom/b43legacy/dma.h      |   4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 129 +++++-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/agg.c       |  17 +-
 drivers/net/wireless/intel/iwlwifi/mld/agg.h       |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c        |  50 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.h        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mld/tests/agg.c |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   6 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |  10 +-
 drivers/net/wireless/marvell/libertas/mesh.c       | 506 ---------------------
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |  10 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |  20 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   7 +
 drivers/net/wireless/marvell/mwifiex/main.h        |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  25 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00pci.c     | 104 +----
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |  67 +--
 drivers/net/wireless/realtek/rtw89/core.c          |   7 -
 drivers/net/wireless/silabs/wfx/bh.c               |   6 +-
 drivers/net/wireless/silabs/wfx/bus_sdio.c         |   1 +
 drivers/net/wireless/silabs/wfx/main.c             |  37 +-
 drivers/net/wireless/virtual/mac80211_hwsim.h      |   5 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |  98 +++-
 include/linux/ieee80211-eht.h                      |  18 +-
 include/linux/ieee80211-uhr.h                      | 101 ++--
 include/linux/ieee80211.h                          |   3 +-
 include/net/cfg80211.h                             |   6 +-
 include/net/ieee80211_radiotap.h                   |  68 ++-
 include/net/mac80211.h                             |  65 +--
 include/uapi/linux/nl80211.h                       |  27 +-
 net/mac80211/agg-tx.c                              |   9 +-
 net/mac80211/ap.c                                  |   3 -
 net/mac80211/debugfs.c                             |   2 +-
 net/mac80211/debugfs_netdev.c                      |   8 +-
 net/mac80211/ht.c                                  |   2 +-
 net/mac80211/ieee80211_i.h                         |  30 +-
 net/mac80211/iface.c                               |  12 +-
 net/mac80211/main.c                                |  13 +-
 net/mac80211/mesh_pathtbl.c                        |   2 +-
 net/mac80211/mlme.c                                |  48 +-
 net/mac80211/offchannel.c                          |  13 +-
 net/mac80211/rate.c                                |   1 -
 net/mac80211/rx.c                                  | 466 ++++++++++---------
 net/mac80211/s1g.c                                 |   8 -
 net/mac80211/scan.c                                |  10 +-
 net/mac80211/tdls.c                                |   4 +-
 net/mac80211/tests/chan-mode.c                     |   6 +-
 net/mac80211/tests/util.c                          |   6 +-
 net/mac80211/tx.c                                  | 420 +++++++++--------
 net/mac80211/util.c                                |   2 +-
 net/wireless/chan.c                                |  11 +-
 net/wireless/nl80211.c                             |  38 +-
 90 files changed, 1667 insertions(+), 1626 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl1251.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wl1251.yaml
