Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6609E4734EF;
	Wed, 16 Sep 2026 08:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789547811; cv=none; b=WYNVYI96xDREE9cGoqmzO/DssVZS0ef3tHfcOVP8rUHm59G3nLIyjJ6MUAfjwHVeY5nqfLde53aGeKRbmwJkDwAg9bAbss1A7s0s/q3OTnY9KRd3A4Soqci2lMjBHBTW21NMeeE67v3tkzBdpm6LH2iT80zCUnN//TVoe2pUDsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789547811; c=relaxed/simple;
	bh=PMQFmPxypefDsDInVFMie6lTBo2CFEOggSIRsn23rJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fu5k+iw1BXi9i/5TDhFBZcsvU6NpMF5l54ItYEV4sntvmavbd1VCbcv0RttY5AMPX7v1/26DXQozMG/qeixjWOSYNnI75ecpYH52iEep5mWxUDhJzJXDbh5p9F9cEEQOTE0sfjb5YkGP/OLbuWs9F1EvaCKHNUSFJwfGRg+kdqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aX+BQbgJ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aX+BQbgJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=3y0ffgBYe0x0G3FqzpZgiy6yuK/kmiHQ6LmN1/Pon0w=; t=1789547809; x=1790757409; 
	b=aX+BQbgJM0WxjV0VnunTN1sJdzhCxPH1uMdDyj8GfKA+ifmudIfvRahXaYQ9QrpgnkWCgvwfrH2
	82XN/WCPFYaHdZRgjLnBBCjPzCfjW+5foPwY0gm90ROIglRMBVaZAjqMt7USu7fmLJQ0CNYIMTEBC
	MSJBNQvr8YCZbgATZpEbkrjAv9BJrOApj1c1acYd1pcap9+IfEQeWtuxSXaVsLpXkl9Pmwiy4/bz7
	/Afm9DDffOl/Bmq3/RiNDTfzbJTl7g52xpQxXqRA/PoiBb3ODDsd5xMu9G0NMxwPGV9EqL2pJnGfh
	BG8FUg40YQL8S77T8H9//69E9HtqzKETiiCQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x6l8H-00000000Z3x-3jzT;
	Wed, 16 Sep 2026 10:36:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-09-16
Date: Wed, 16 Sep 2026 10:35:55 +0200
Message-ID: <20260916083642.110609-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

First pull for this fixes cycle, I missed the cutoff last week
and was catching up from vacation before. Quite a few changes,
but mostly syzbot and/or LLM fixes.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit adf50c47a47f0f0f0b79dd58ffade9919cddebea:

  Merge tag 'net-7.3-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-09-03 10:18:12 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-09-16

for you to fetch changes up to 1eeca1d5e0920fbdad6449768fd2d4364e714180:

  wifi: brcmsmac: fix UAF in brcms_free_timer() (2026-09-15 11:52:56 +0200)

----------------------------------------------------------------
Many fixes:
 - mac80211: S1G TIM bitmap fix
 - ath12k: remove undocumented DT ABI implementation
 - various firmware API and over-the-air hardening changes
 - fixes for most cfg80211/mac80211 syzbot reports

----------------------------------------------------------------
Ali Ahmet Memis (1):
      wifi: wilc1000: fix out-of-bounds read in P2P public action frames

Bogdan Nicolae (1):
      wifi: brcmfmac: cyw: pass PMKID to firmware if present

Daehyeon Ko (1):
      wifi: libipw: reject TKIP frames without a full MIC

Devin Wittmayer (1):
      wifi: mac80211: refuse to make a monitor active when it has no queue

Doruk Tan Ozturk (1):
      wifi: mwifiex: bound the pairwise-cipher OUI walk to the IE length

Fan Wu (1):
      wifi: wcn36xx: Fix potential use-after-free in TX ack timer teardown

Ivan Pustogarov (1):
      wifi: mac80211: avoid out-of-bounds read for empty PREQ elements

Jiangshan Yi (2):
      wifi: libertas_tf: fix UAF in lbtf_free_adapter()
      wifi: brcmsmac: fix UAF in brcms_free_timer()

Johannes Berg (35):
      .get_maintainer.ignore: add myself
      wifi: cfg80211: don't get the radio mask for netdev-less wdevs
      wifi: cfg80211: check IP header size in cfg80211_classify8021d()
      wifi: cfg80211: don't free driver-owned scan requests
      wifi: cfg80211: only group hidden BSSes with beacon entries
      wifi: cfg80211: don't filter by BSS type when removing stale entries
      wifi: cfg80211: ibss: ref BSS entry for joined event
      wifi: cfg80211: fix NAN regulatory enforcement
      wifi: cfg80211: reduce RTNL holding in regulatory enforcement
      wifi: mac80211: don't apply peer rates to off-channel frames
      wifi: mac80211: don't drop scan probe requests for lack of peer rates
      wifi: mac80211: don't start a ROC while scanning
      wifi: mac80211: don't warn when an IBSS has no channel to scan
      wifi: mac80211: don't offload TC setup on AP_VLAN interfaces
      wifi: mac80211: suppress chanctx warning for debugfs reset
      wifi: mac80211: abort chanswitch when leaving a mesh
      wifi: mac80211: reset state when starting AP fails
      wifi: mac80211: reset the LED state when ifup fails
      wifi: mac80211: only operate on TDLS peers in the TDLS code
      wifi: cfg80211: restore netns_immutable on failures
      wifi: cfg80211: undo netns switch if renaming the wiphy fails
      wifi: mac80211: unlist vifs when their netdev is unregistered
      wifi: cfg80211: get the wiphy out of a dying network namespace
      wifi: mac80211_hwsim: don't hand frames to mac80211 while stopping
      wifi: mac80211: don't allow injecting frames wider than the chanctx
      wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown
      wifi: mac80211: require a peer station for TDLS setup confirm
      wifi: mac80211: don't allow link changes when iface is down
      wifi: mac80211: don't RCU-dereference the mesh CSA settings we just set
      wifi: mac80211: don't access the TSF of a down interface
      wifi: mac80211: add HE 6 GHz capability in the scan elems len
      wifi: mac80211: mesh: reset the CSA state when leaving
      wifi: mac80211: mesh: release the channel if start fails
      wifi: mac80211: set up the TX info early to fix failure paths
      Merge tag 'ath-current-20260914' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath

Karl Mehltretter (1):
      wifi: brcmfmac: fix lost 802.1x TX completion wakeup

Krzysztof Kozlowski (1):
      wifi: ath12k: ahb: Revert undocumented ABI and dead code

Lachlan Hodges (1):
      wifi: mac80211: include TIM bitmap control for buffered S1G mcast traffic

Linmao Li (1):
      wifi: mwifiex: prevent authentication frame length truncation

Mariano Baragiola (1):
      wifi: virt_wifi: free skb when disconnected

Nicolas Escande (1):
      wifi: ath11k: cleanup arsta in ath11k_mac_peer_cleanup_all()

Peng Hao (1):
      wifi: mwifiex: fix IRQ leak using wrong index in MSI-X error path

Pengpeng Hou (1):
      wifi: mwifiex: validate scan response extents

Rik van Riel (1):
      wifi: mac80211: avoid WARN in set_bitrate_mask when sdata not in driver

Runyu Xiao (1):
      wifi: wlcore: release runtime PM ref on regdomain config failure

Shengzhuo Wei (2):
      wifi: p54: validate curve data length in the calibration curve converters
      wifi: p54: require a full exp_if record in PDR_INTERFACE_LIST

Shmulik Cohen (3):
      wifi: libipw: reject too-short beacon and probe responses
      wifi: libipw: reject too-short association responses
      wifi: ipw2x00: bound management frame length to the receive buffer

Slawomir Stepien (4):
      wifi: cfg80211: verify if AP_VLAN belongs to the correct AP
      wifi: cfg80211: do not support direct add of station to AP_VLAN interfaces
      wifi: cfg80211: move link_id validation earlier in nl80211_new_station()
      wifi: cfg80211: check if AP has been started or joined a mesh before adding new station

Stanislaw Gruszka (1):
      wifi: iwlegacy: fix broadcast stations deallocation

Tianchu Chen (2):
      wifi: rsi: fix heap OOB write on key removal
      wifi: wilc1000: fix RX buffer OOB-write in wilc_wlan_handle_isr_ext()

Zhao Li (1):
      wifi: mwifiex: validate action frame fixed fields

Zihan Xi (1):
      wifi: virt_wifi: don't transfer operstate before register

 .get_maintainer.ignore                             |   2 +
 drivers/net/wireless/ath/ath11k/mac.c              |  25 +++-
 drivers/net/wireless/ath/ath12k/wifi7/ahb.c        |  51 +------
 drivers/net/wireless/ath/wcn36xx/dxe.c             |   2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   2 +
 .../broadcom/brcm80211/brcmfmac/cyw/core.c         |   5 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   4 +
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   9 ++
 .../wireless/intel/ipw2x00/libipw_crypto_tkip.c    |  12 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |   6 +
 drivers/net/wireless/intel/iwlegacy/common.c       |   2 +-
 drivers/net/wireless/intersil/p54/eeprom.c         |  22 ++-
 drivers/net/wireless/marvell/libertas_tf/main.c    |   2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  12 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   2 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |  54 ++++++--
 drivers/net/wireless/marvell/mwifiex/util.c        |  10 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  14 ++
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   9 ++
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   2 -
 drivers/net/wireless/ti/wlcore/main.c              |   4 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |  39 ++++--
 drivers/net/wireless/virtual/virt_wifi.c           |   4 +-
 include/linux/ieee80211-mesh.h                     |   4 +-
 include/net/mac80211.h                             |   5 +-
 net/mac80211/cfg.c                                 |  18 ++-
 net/mac80211/debugfs.c                             |   2 +-
 net/mac80211/debugfs_netdev.c                      |   9 ++
 net/mac80211/ieee80211_i.h                         |   2 +-
 net/mac80211/iface.c                               |  39 +++++-
 net/mac80211/main.c                                |   4 +
 net/mac80211/mesh.c                                |  34 +++--
 net/mac80211/offchannel.c                          |   7 +
 net/mac80211/pm.c                                  |   8 +-
 net/mac80211/rate.c                                |   8 ++
 net/mac80211/scan.c                                |   2 +-
 net/mac80211/tdls.c                                |  40 ++++--
 net/mac80211/tx.c                                  | 115 ++++++++++------
 net/wireless/core.c                                | 153 ++++++++++++---------
 net/wireless/core.h                                |  18 ++-
 net/wireless/ibss.c                                |  38 ++---
 net/wireless/nl80211.c                             |  64 +++++----
 net/wireless/rdev-ops.h                            |   3 +
 net/wireless/reg.c                                 |  52 +++++--
 net/wireless/reg.h                                 |  16 +++
 net/wireless/scan.c                                |  43 +++++-
 net/wireless/util.c                                |  38 +++--
 48 files changed, 694 insertions(+), 326 deletions(-)
