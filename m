Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2A54908B1;
	Sun, 26 Jul 2026 10:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785063135; cv=none; b=L3yBPofESaHRLs6+2u+msAe2Sb/9OzO4gjHEacfC4Lv4Id5YceuUgo/3sjH1PV63JHxW5pUEral8Cip8dqNBJLk3wXThkl9jyOBuc6v2eSaVvMdF9rb8AlvdvXfW19tPboPLckjblIfzJ6lY9N/AuoVuKFmLv4GGjzlKZse+tKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785063135; c=relaxed/simple;
	bh=GuEZie4FOWa1wGGJod3OZZ93EE8C1pGCM0yUDfee8Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U+gTFV+f/t1quzDTvN15PuOB3tSZNa9VyQ3V9euVyGzm6dRtr4ufyCuyprPIsCimrmuCJaRa1DijtDpJWtCGN+SjA9TT3xo5YOd+vCMrAs2diQ85oZJxFjgEwBg6mkaWOi6lPVwR4zEBtvKPS4iOcKctQ/JCAl+KIuljAlniXw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=q9wZ7k25; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="q9wZ7k25"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=afdKsJDhgGf2XHOgftXRj0l6HvTZvjbQurnhHGOG8kE=; t=1785063132; x=1786272732; 
	b=q9wZ7k25UltEUPrkhOKwyprAL4PseZ4n31xOxTevOe0IELU5Zw6b/7QjP4b/XFO4uHhSpbNw3Gj
	zXvPk8THpuUhaIGb/cTb/2K+V05yjPi3oGzH5akvD3Iw6LWFl2O2i65yEQhD3S2axW9EY2FlQeB78
	+V2ADDHgcQofIt2yHmAfKnDAMVq+4TgMlMGnzAUWp272WL2WYVZkox9nfY2pf8pm9Kzl7tmUs1mON
	P9HO9t2PLie1mRDpo0fjJkLa2Aq9lGhroejXr3Hmq/TRy+QhXKfX6t1Vv5M1YZ1VK9v9caxvUe8wf
	pEzXeF9pGRjpNQd/XnuoExGp05lkKJA/5RRQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wnwSo-0000000Aa66-0Uky;
	Sun, 26 Jul 2026 12:52:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-next-2026-07-26
Date: Sun, 26 Jul 2026 12:44:42 +0200
Message-ID: <20260726105205.942922-60-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Here's a new pull request, big simply because there are two new drivers,
otherwise nothing exciting is going on (yet, I have plenty WiFi8 work
in the pipeline, and so does Qualcomm, I believe).

Two things to note:

1) There's a merge confict, I've done a test merge of this into net-next
   and pushed the result to the merge-wireless-next-2026-07-26 tag. Doing
   only the actual conflict resolution will leave it not building. We've
   discussed which way it should be resolved in this thread:
   https://lore.kernel.org/all/b99e4a1428546030b61883063b9542dd953a69f2.camel@sipsolutions.net/
   and I think for now the "notify_driver" is the better resolution, even
   if that differs from the original way of handling this failure from
   035ed430ce6a ("wifi: mac80211: avoid non-S1G AID fallback for S1G assoc")

2) 0-day reported an internal compiler error reported on csky (!) in the new
   nxpwifi driver:
   https://lore.kernel.org/linux-wireless/202607251212.6TdnMBFC-lkp@intel.com/
   I've asked Jeff to take a look, and that function probably wants some
   cleanup anyway, but for now I don't think I'm going to worry about it,
   I doubt anyone really cares about csky and this driver. Though if we
   can't figure it out maybe we should just disable it there later.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit 2bb62a85aff6d4c14a62a476dfabaada3c1cc014:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-07-03 07:46:27 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2026-07-26

for you to fetch changes up to 90883c513ca01e77c56b8d94be7de11420c1dacf:

  Merge tag 'ath-next-20260722' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath (2026-07-22 18:37:59 +0200)

----------------------------------------------------------------
Mostly driver changes this time:
 - new driver mm81x for an S1G device
 - new driver nxpwifi for NXP devices
   (mostly forked off from mwifiex)
 - ath12k: much kernel infrastructure integration work
 - brcmfmac: DPP support, some Cypress part update
 - nl80211: per-link statistics support

----------------------------------------------------------------
Aaradhana Sahu (8):
      wifi: ath12k: remove unused QMI definitions
      wifi: ath12k: expand UserPD ID mask to support up to 8 PDs
      wifi: ath12k: correct monitor destination ring size
      wifi: ath12k: add QMI capability negotiation for dynamic memory mode
      wifi: ath12k: update IPQ5332 BDF address offset
      wifi: ath12k: switch to name-based reserved memory lookup
      wifi: ath12k: refactor QMI memory assignment
      wifi: ath12k: allocate HOST_DDR and BDF regions after Q6 RO region

Aishwarya R (1):
      wifi: ath12k: reset REOQ LUT addresses before firmware stop

Alexander Wilhelm (1):
      wifi: ath12k: fix scan command endianness on big endian

Anas Khan (1):
      wifi: p54: update stale wireless wiki URLs

Baochen Qiang (3):
      wifi: ath12k: fix dp_link_peer dangling references on AP vdev rollback
      wifi: ath12k: fix MLO peer delete race
      wifi: ath11k: cap out-of-range rx MCS instead of leaving bogus rate

Cen Zhang (2):
      wifi: mac80211_hwsim: clean up radio rhashtable on free
      wifi: mac80211_hwsim: avoid NULL skb in stop queue drain

Christophe JAILLET (2):
      wifi: ath12k: Constify struct ath12k_dp_arch_ops
      wifi: ath6kl: Constify struct cfg80211_ops

Daizhuang Bai (1):
      wifi: ath12k: Set DTIM policy to stick mode for station interface

Deepanshu Kartikey (1):
      wifi: mac80211: don't encrypt pre-auth (ETH_P_PREAUTH) frames

Dhanavandhana Kannan (1):
      wifi: cfg80211: Avoid UNPROT_BEACON on AP interfaces

Hangtian Zhu (2):
      genirq: export irq_can_set_affinity() for module drivers
      wifi: ath12k: enable threaded NAPI when DP IRQ affinity is unavailable

Ilan Peer (1):
      wifi: mac80211: Route (Re)association req/response to per-STA queue

Jason Huang (1):
      wifi: brcmfmac: add DPP support

Jeff Chen (2):
      mmc: core: add NXP IW61x base ID and block size quirk
      wifi: nxp: add nxpwifi driver for IW61x

Jeff Johnson (7):
      Merge qcom PAS TZ service series (20260702115835.167602-2-sumit.garg@kernel.org)
      wifi: ath12k: Fix ath12k_wifi7_mac_op_tx() style issues
      wifi: ath6kl: avoid buffer overreads in WMI event handlers
      wifi: ath12k: Correctly copy the hint BSSID in WMI scan request
      wifi: ath11k: Correctly copy the hint BSSID in WMI scan request
      wifi: ath12k: Avoid buffer overread in ath12k_wmi_op_rx()
      wifi: ath11k: Avoid buffer overread in ath11k_wmi_tlv_op_rx()

Jiajia Liu (1):
      wifi: cfg80211: reg: add a newline in DFS debug message

Johannes Berg (13):
      wifi: radiotap: add definitions for the new UHR TLVs
      wifi: nl80211: clarify NL80211_BAND_IFTYPE_ATTR_HE_6GHZ_CAPA content
      wifi: cfg80211: remove WIPHY_FLAG_DISABLE_WEXT
      Merge tag 'mm81x-driver-08-07-2026' of https://github.com/MorseMicro/linux
      wifi: mac80211: always send regulatory connectivity element
      wifi: use UHR operation field presence bits
      wifi: cfg80211: improve multi-BSSID profile continuation parser
      wifi: cfg80211: clarify and tighten key checks
      wifi: mac80211: fix monitor min_def bandwidth
      wifi: mac80211: refactor multi-link assoc response parsing
      wifi: mac80211: parse enhanced critical updates field
      Merge tag 'nxpwifi-2026-07-15' of https://github.com/jeffchen71/nxpwifi
      Merge tag 'ath-next-20260722' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath

Krzysztof Kozlowski (1):
      wifi: ath10k: Drop redundant NULL check on devm_clk_get()

Lachlan Hodges (5):
      wifi: cfg80211: introduce helper to get S1G primary width
      wifi: ieee80211: introduce generic KHZ_TO_HZ helper
      mmc: sdio: add Morse Micro vendor ids
      wifi: mm81x: add mm81x Wi-Fi HaLow driver
      wifi: cfg80211: include cf1 offset when sending chandef

Louis Kotze (2):
      wifi: cfg80211: say why the auth/assoc BSS lookup failed
      wifi: cfg80211: tests: check BSS lookup failure reasons

Manikanta Pubbisetty (1):
      wifi: ath10k: trigger hardware recovery upon rx failures

Manish Dharanenthiran (1):
      wifi: ath12k: advertise ieee_link_id in vdev start MLO params

Masi Osmani (3):
      wifi: carl9170: mac80211: document spatial multiplexing power save handler
      wifi: carl9170: rx: track PHY errors via debugfs
      wifi: carl9170: cmd: downgrade transient register I/O errors to wiphy_dbg

Matthew Leach (1):
      wifi: ath12k: fix survey indexing across bands

Miaoqing Pan (7):
      wifi: ath12k: fix TLV32 length mask
      wifi: ath12k: refactor HAL TLV32/64 decode helpers
      wifi: ath12k: add HAL ops for monitor TLV header decode and alignment
      wifi: ath12k: add dp_mon support 32-bit TLV headers
      wifi: ath12k: tighten RX monitor TLV bounds check
      wifi: ath12k: fix ML-STA authentication timeout on QCC2072
      wifi: ath11k: add purwa-iot-evk and qcs6490-rb3gen2 to usecase firmware table

Mike Rapoport (Microsoft) (4):
      wifi: b43, b43legacy: debugfs: use kzalloc() to allocate formatting buffers
      wifi: libertas: debugfs: use kzalloc() to allocate formatting buffers
      wifi: mwifiex: debugfs: use kzalloc() to allocate formatting buffers
      wifi: wlcore: allocate aggregation and firmware log buffers with kzalloc()

Nicolas Escande (1):
      wifi: ath12k: avoid setting 320MHz support on non 6GHz band

P Praneesh (5):
      wifi: cfg80211: Drop unused link stats handling in nl80211_send_station()
      wifi: cfg80211: Add helper to pack station-level STA_INFO
      wifi: cfg80211: Refactor nl80211_dump_station() to prepare for per-link stats
      wifi: cfg80211: Fragment per-link station stats in nl80211_dump_station()
      wifi: cfg80211: support MAC address filtering in station dump for link stats

Pagadala Yesu Anjaneyulu (1):
      wifi: mac80211: notify driver before destroying assoc link

Pengpeng Hou (1):
      wifi: ath11k: validate regulatory capability phy_id

Phil Elwell (1):
      wifi: brcmfmac: 43430 and 43455 are CYW parts

Priyansha Tiwari (4):
      wifi: nl80211/cfg80211: rename probe_client to probe_peer
      wifi: cfg80211/nl80211: add STA-mode peer probing
      wifi: mac80211: implement STA-mode peer probing
      wifi: mac80211_hwsim: report TX status link_id

Raj Kumar Bhagat (2):
      wifi: ath12k: Fix inconsistencies in struct qmi_elem_info initializers
      wifi: ath12k: use %u for unsigned variables in QMI debug logs

Shahar Tzarfati (1):
      wifi: mac80211: ibss: read deauth reason_code after frame length check

Sreeramya Soratkal (3):
      wifi: ath12k: Use runtime device count in dp stats display
      wifi: ath12k: Add timestamp to dp stats display
      wifi: ath12k: Show per-radio center freq in dp stats

Sumit Garg (5):
      firmware: qcom: Add a generic PAS service
      firmware: qcom_scm: Migrate to generic PAS service
      firmware: qcom: Add a PAS TEE service
      MAINTAINERS: Add maintainer entry for Qualcomm PAS TZ service
      wifi: ath12k: Switch to generic PAS TZ APIs

Sushant Butta (2):
      wifi: ath12k: Skip setting RX_FLAG_8023 for Ethernet-II (DIX) frames in monitor mode
      wifi: ath12k: Skip peer link info update in rx_status for monitor MSDUs

Tamizh Chelvam Raja (2):
      wifi: ath12k: Advertise multicast Ethernet encapsulation offload support
      wifi: ath12k: Set IEEE80211_OFFLOAD_ENCAP_4ADDR after tx_encap_type vdev param

Thiraviyam Mariyappan (2):
      wifi: ath12k: Reduce RX SRNG interrupt timer threshold to 200us
      wifi: ath12k: Set congestion control max MSDU count

Wei Zhang (1):
      wifi: ath12k: fix rx_mpdu_start layout for QCC2072

Yingying Tang (1):
      wifi: ath12k: change MAC buffer ring size to 4096

Zhao Li (2):
      wifi: mac80211_hwsim: authenticate PMSR report senders
      wifi: mac80211_hwsim: clear PMSR request state on abort

 MAINTAINERS                                        |   24 +
 drivers/firmware/qcom/Kconfig                      |   22 +-
 drivers/firmware/qcom/Makefile                     |    2 +
 drivers/firmware/qcom/qcom_pas.c                   |  298 ++
 drivers/firmware/qcom/qcom_pas.h                   |   50 +
 drivers/firmware/qcom/qcom_pas_tee.c               |  479 +++
 drivers/firmware/qcom/qcom_scm.c                   |  335 +-
 drivers/mmc/core/quirks.h                          |    3 +
 drivers/net/wireless/Kconfig                       |    2 +
 drivers/net/wireless/Makefile                      |    2 +
 drivers/net/wireless/ath/ath10k/ahb.c              |   12 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    6 +-
 drivers/net/wireless/ath/ath11k/core.c             |    4 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   32 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   16 +-
 drivers/net/wireless/ath/ath12k/Kconfig            |    2 +-
 drivers/net/wireless/ath/ath12k/ahb.c              |   29 +-
 drivers/net/wireless/ath/ath12k/ahb.h              |    2 +-
 drivers/net/wireless/ath/ath12k/core.c             |   34 +-
 drivers/net/wireless/ath/ath12k/core.h             |   13 +-
 drivers/net/wireless/ath/ath12k/debugfs.c          |   14 +-
 drivers/net/wireless/ath/ath12k/dp.c               |   14 +-
 drivers/net/wireless/ath/ath12k/dp.h               |    5 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |   70 +-
 drivers/net/wireless/ath/ath12k/dp_mon.h           |    4 +-
 drivers/net/wireless/ath/ath12k/hal.c              |   42 +-
 drivers/net/wireless/ath/ath12k/hal.h              |   15 +-
 drivers/net/wireless/ath/ath12k/hw.h               |    1 +
 drivers/net/wireless/ath/ath12k/mac.c              |  102 +-
 drivers/net/wireless/ath/ath12k/pci.c              |   12 +-
 drivers/net/wireless/ath/ath12k/peer.c             |  132 +-
 drivers/net/wireless/ath/ath12k/peer.h             |   14 +-
 drivers/net/wireless/ath/ath12k/qmi.c              |  429 ++-
 drivers/net/wireless/ath/ath12k/qmi.h              |   34 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp.c         |    2 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c     |   66 +-
 .../net/wireless/ath/ath12k/wifi7/hal_qcc2072.c    |    4 +-
 .../net/wireless/ath/ath12k/wifi7/hal_qcn9274.c    |   13 +-
 .../net/wireless/ath/ath12k/wifi7/hal_rx_desc.h    |   34 +-
 .../net/wireless/ath/ath12k/wifi7/hal_wcn7850.c    |   13 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |   73 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |  165 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |   26 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    2 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   17 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    1 +
 drivers/net/wireless/ath/carl9170/cmd.c            |    4 +-
 drivers/net/wireless/ath/carl9170/debug.c          |    2 +
 drivers/net/wireless/ath/carl9170/main.c           |    8 +-
 drivers/net/wireless/ath/carl9170/rx.c             |    4 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |   10 +-
 drivers/net/wireless/broadcom/b43/debugfs.c        |   12 +-
 drivers/net/wireless/broadcom/b43legacy/debugfs.c  |   12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    6 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  149 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   54 +-
 .../broadcom/brcm80211/include/brcmu_wifi.h        |    2 +
 drivers/net/wireless/intersil/p54/Kconfig          |    6 +-
 drivers/net/wireless/intersil/p54/fwio.c           |    4 +-
 drivers/net/wireless/intersil/p54/p54usb.c         |    2 +-
 drivers/net/wireless/marvell/libertas/debugfs.c    |   39 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |    8 +-
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |   62 +-
 drivers/net/wireless/morsemicro/Kconfig            |   15 +
 drivers/net/wireless/morsemicro/Makefile           |    2 +
 drivers/net/wireless/morsemicro/mm81x/Kconfig      |   24 +
 drivers/net/wireless/morsemicro/mm81x/Makefile     |   21 +
 drivers/net/wireless/morsemicro/mm81x/bus.h        |   99 +
 drivers/net/wireless/morsemicro/mm81x/command.c    |  563 +++
 drivers/net/wireless/morsemicro/mm81x/command.h    |   85 +
 .../net/wireless/morsemicro/mm81x/command_defs.h   | 1658 +++++++++
 drivers/net/wireless/morsemicro/mm81x/core.c       |  138 +
 drivers/net/wireless/morsemicro/mm81x/core.h       |  456 +++
 drivers/net/wireless/morsemicro/mm81x/fw.c         |  752 ++++
 drivers/net/wireless/morsemicro/mm81x/fw.h         |  143 +
 drivers/net/wireless/morsemicro/mm81x/hif.h        |  117 +
 drivers/net/wireless/morsemicro/mm81x/hw.c         |  367 ++
 drivers/net/wireless/morsemicro/mm81x/hw.h         |  159 +
 drivers/net/wireless/morsemicro/mm81x/mac.c        | 2443 ++++++++++++
 drivers/net/wireless/morsemicro/mm81x/mac.h        |   63 +
 drivers/net/wireless/morsemicro/mm81x/mmrc.c       | 1354 +++++++
 drivers/net/wireless/morsemicro/mm81x/mmrc.h       |  193 +
 drivers/net/wireless/morsemicro/mm81x/ps.c         |  120 +
 drivers/net/wireless/morsemicro/mm81x/ps.h         |   22 +
 drivers/net/wireless/morsemicro/mm81x/rate_code.h  |  177 +
 drivers/net/wireless/morsemicro/mm81x/rc.c         |  494 +++
 drivers/net/wireless/morsemicro/mm81x/rc.h         |   51 +
 drivers/net/wireless/morsemicro/mm81x/sdio.c       |  613 +++
 drivers/net/wireless/morsemicro/mm81x/skbq.c       | 1064 ++++++
 drivers/net/wireless/morsemicro/mm81x/skbq.h       |  218 ++
 drivers/net/wireless/morsemicro/mm81x/usb.c        |  943 +++++
 drivers/net/wireless/morsemicro/mm81x/yaps.c       |  704 ++++
 drivers/net/wireless/morsemicro/mm81x/yaps.h       |   77 +
 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c    |  702 ++++
 drivers/net/wireless/morsemicro/mm81x/yaps_hw.h    |   52 +
 drivers/net/wireless/nxp/Kconfig                   |   17 +
 drivers/net/wireless/nxp/Makefile                  |    3 +
 drivers/net/wireless/nxp/nxpwifi/11ac.c            |  280 ++
 drivers/net/wireless/nxp/nxpwifi/11ac.h            |   33 +
 drivers/net/wireless/nxp/nxpwifi/11ax.c            |  594 +++
 drivers/net/wireless/nxp/nxpwifi/11ax.h            |   73 +
 drivers/net/wireless/nxp/nxpwifi/11h.c             |  339 ++
 drivers/net/wireless/nxp/nxpwifi/11n.c             |  837 +++++
 drivers/net/wireless/nxp/nxpwifi/11n.h             |  158 +
 drivers/net/wireless/nxp/nxpwifi/11n_aggr.c        |  251 ++
 drivers/net/wireless/nxp/nxpwifi/11n_aggr.h        |   21 +
 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c   |  826 ++++
 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.h   |   71 +
 drivers/net/wireless/nxp/nxpwifi/Kconfig           |   22 +
 drivers/net/wireless/nxp/nxpwifi/Makefile          |   39 +
 drivers/net/wireless/nxp/nxpwifi/cfg.h             | 1019 +++++
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c        | 3931 ++++++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/cfg80211.h        |   18 +
 drivers/net/wireless/nxp/nxpwifi/cfp.c             |  478 +++
 drivers/net/wireless/nxp/nxpwifi/cmdevt.c          | 1310 +++++++
 drivers/net/wireless/nxp/nxpwifi/cmdevt.h          |  122 +
 drivers/net/wireless/nxp/nxpwifi/debugfs.c         | 1094 ++++++
 drivers/net/wireless/nxp/nxpwifi/ethtool.c         |   58 +
 drivers/net/wireless/nxp/nxpwifi/fw.h              | 2475 ++++++++++++
 drivers/net/wireless/nxp/nxpwifi/ie.c              |  480 +++
 drivers/net/wireless/nxp/nxpwifi/init.c            |  607 +++
 drivers/net/wireless/nxp/nxpwifi/join.c            |  787 ++++
 drivers/net/wireless/nxp/nxpwifi/main.c            | 1673 +++++++++
 drivers/net/wireless/nxp/nxpwifi/main.h            | 1429 +++++++
 drivers/net/wireless/nxp/nxpwifi/scan.c            | 2695 ++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.c            | 2327 ++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sdio.h            |  340 ++
 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c         | 1165 ++++++
 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c         | 3383 +++++++++++++++++
 drivers/net/wireless/nxp/nxpwifi/sta_event.c       |  862 +++++
 drivers/net/wireless/nxp/nxpwifi/sta_rx.c          |  242 ++
 drivers/net/wireless/nxp/nxpwifi/sta_tx.c          |  190 +
 drivers/net/wireless/nxp/nxpwifi/txrx.c            |  352 ++
 drivers/net/wireless/nxp/nxpwifi/uap_cmd.c         | 1256 +++++++
 drivers/net/wireless/nxp/nxpwifi/uap_event.c       |  488 +++
 drivers/net/wireless/nxp/nxpwifi/uap_txrx.c        |  478 +++
 drivers/net/wireless/nxp/nxpwifi/util.c            | 1381 +++++++
 drivers/net/wireless/nxp/nxpwifi/util.h            |  155 +
 drivers/net/wireless/nxp/nxpwifi/wmm.c             | 1318 +++++++
 drivers/net/wireless/nxp/nxpwifi/wmm.h             |   77 +
 drivers/net/wireless/realtek/rtw89/core.c          |    3 -
 drivers/net/wireless/ti/wlcore/main.c              |   14 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |   69 +-
 include/linux/firmware/qcom/qcom_pas.h             |   43 +
 include/linux/ieee80211-eht.h                      |   92 +
 include/linux/ieee80211-uhr.h                      |   44 +-
 include/linux/ieee80211.h                          |   12 +
 include/linux/mmc/sdio_ids.h                       |    4 +
 include/net/cfg80211.h                             |   48 +-
 include/net/ieee80211_radiotap.h                   |  190 +
 include/net/mac80211.h                             |   13 +-
 include/uapi/linux/nl80211.h                       |   46 +-
 kernel/irq/manage.c                                |    1 +
 net/mac80211/cfg.c                                 |  123 +-
 net/mac80211/chan.c                                |    6 +-
 net/mac80211/ibss.c                                |    4 +-
 net/mac80211/ieee80211_i.h                         |    8 +-
 net/mac80211/mlme.c                                |  178 +-
 net/mac80211/parse.c                               |    4 +-
 net/mac80211/status.c                              |    5 +-
 net/mac80211/tx.c                                  |   10 +
 net/mac80211/util.c                                |   24 +-
 net/wireless/core.h                                |    5 +-
 net/wireless/nl80211.c                             |  520 ++-
 net/wireless/rdev-ops.h                            |   10 +-
 net/wireless/reg.c                                 |    3 +-
 net/wireless/scan.c                                |   93 +-
 net/wireless/tests/scan.c                          |  121 +-
 net/wireless/trace.h                               |    2 +-
 net/wireless/util.c                                |  107 +-
 net/wireless/wext-compat.c                         |    3 +-
 net/wireless/wext-core.c                           |    6 +-
 172 files changed, 53107 insertions(+), 1402 deletions(-)
 create mode 100644 drivers/firmware/qcom/qcom_pas.c
 create mode 100644 drivers/firmware/qcom/qcom_pas.h
 create mode 100644 drivers/firmware/qcom/qcom_pas_tee.c
 create mode 100644 drivers/net/wireless/morsemicro/Kconfig
 create mode 100644 drivers/net/wireless/morsemicro/Makefile
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/Kconfig
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/Makefile
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/bus.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/command.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/command.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/command_defs.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/core.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/core.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/fw.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/fw.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/hif.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/hw.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/hw.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/mac.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/mac.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/mmrc.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/mmrc.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/ps.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/ps.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/rate_code.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/rc.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/rc.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/sdio.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/skbq.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/skbq.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/usb.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/yaps.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/yaps.h
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/yaps_hw.c
 create mode 100644 drivers/net/wireless/morsemicro/mm81x/yaps_hw.h
 create mode 100644 drivers/net/wireless/nxp/Kconfig
 create mode 100644 drivers/net/wireless/nxp/Makefile
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11ac.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11ac.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11ax.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11ax.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11h.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n_aggr.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n_aggr.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/Kconfig
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/Makefile
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cfg.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cfg80211.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cfg80211.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cfp.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cmdevt.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/cmdevt.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/debugfs.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/ethtool.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/fw.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/ie.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/init.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/join.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/main.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/main.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/scan.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sdio.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sdio.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_cfg.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_cmd.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_event.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_rx.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/sta_tx.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/txrx.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/uap_cmd.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/uap_event.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/uap_txrx.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/util.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/util.h
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/wmm.c
 create mode 100644 drivers/net/wireless/nxp/nxpwifi/wmm.h
 create mode 100644 include/linux/firmware/qcom/qcom_pas.h
