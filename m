Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617D44D0CE2;
	Wed, 30 Sep 2026 12:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790772355; cv=none; b=OVDDeDevSzYsb7hEvYqFDECiAngvIXrIBAzg+iKx1SW2+PIOu3BNPG4PhHqq7mcHG0S9bd+WJ3Dd3ZX/4/VFHds6mx+0UJX+bB7i8qvocbLKReOwG89jc+pdEj142mVQIWEggu6NHmp/kz8uJ+oBg5BSmY9PgSY1lHuYTyE+E7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790772355; c=relaxed/simple;
	bh=5h0+aw16tg1nmjfU7J5w/VDEyUtLf2ZMLVkYpyGcWS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H9HGvSlmHsERhD71AUJ0I2KzZymEudQMgKZkidaOIWtfeJ+HmczVGc8gtWXbmMXeexroDT4r/t1mtKGl3aBEAl49vrHUztnMKHZEr1f1uEX1F/FygjHh16/BMkXPjQ94s1LA9NrYaR/f4xVMBQqahbEiRrexg+M/Q0j3EiKFsuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=i0t3CaIz; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="i0t3CaIz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=i/m1FbtznmZ5mQ6t7zRv+GlyAzbijuXesHOici+FOHM=; t=1790772353; x=1791981953; 
	b=i0t3CaIzRfLx9f85c0BXrjKdMNwP/pdLIlnF1s74MRVrT/J4CY8jD3z4e7p63H9LrHDduH67TuC
	fIO/n1zEn/2c3G/hD02A5yirpUbD6f5WH9RrOqLcxHUWZV/1J7i8zhgqMLyXewL8kR7lRjoc7IVzh
	h0mp7p+98UxSns24RSg6WFOuDzlDquYAd62oTcBteusjkxR5ZGV2bgJlysLV7FT+89dEUQCjyUDNg
	mz6C7CqvDhQWubHHkRfRlElASx/0PdodN4eeYNOjWS+KJ9TSgpGr792xWoOevMRLm4C3gKDwuFS+P
	uJCbotfzGSKR1DJ4S/7uJ5SfSOp5TeUVgiZQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBth0-0000000GPb0-27NV;
	Wed, 30 Sep 2026 14:45:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-next-2026-09-30
Date: Wed, 30 Sep 2026 14:45:08 +0200
Message-ID: <20260930124547.228697-29-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Also for -next we have quite a bit of new things, but apart from
CIP (control frame integrity protection) support it's mostly driver
changes.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit 42a9fb3382fc2573e92f41d203b095d9a372cfc9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-09-24 13:32:50 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git tags/wireless-next-2026-09-30

for you to fetch changes up to 21b4248bfa0f410fa22202fc2c82f4808d672cda:

  Merge tag 'ath-next-20260927' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath (2026-09-28 11:49:26 +0200)

----------------------------------------------------------------
More features:
 - ath10k: NVMEM device tree bindings
 - ath12k: QMI firmware alignments
 - mm81x: AP improvements
 - mac80211:
   - CIP (control frame integrity) support
   - NAN improvements
 - cfg80211:
   - improvements for AP regulatory checks

----------------------------------------------------------------
Aaradhana Sahu (7):
      wifi: ath12k: move dp_profile_params to dp.h
      wifi: ath12k: convert DP_TX_COMP_RING_SIZE to inline helper
      wifi: ath12k: convert DP_RXDMA_MONITOR_BUF_RING_SIZE to inline helper
      wifi: ath12k: convert DP_RXDMA_MONITOR_DST_RING_SIZE to inline helper
      wifi: ath12k: convert ATH12K_NUM_POOL_TX_DESC to inline helper
      wifi: ath12k: convert ATH12K_RX_DESC_COUNT to inline helper
      wifi: ath12k: convert DP_RX_RELEASE_RING_SIZE to inline helper

Andrei Otcheretianski (4):
      wifi: cfg80211: add NL80211_CMD_NAN_SET_NON_EVAC_CHANNELS
      wifi: mac80211: implement NAN non-evacuable channels
      wifi: cfg80211: fix NAN local schedule update ordering and allocation
      wifi: mac80211_hwsim: Support NAN deferred schedule completion

Aniruddha Mishra (2):
      wifi: ath12k: add WBM RX error drop statistics
      wifi: ath12k: add WBM SW desc fallback counter

Arnd Bergmann (1):
      wifi: b43legacy: work around stack frame size warning

Baochen Qiang (3):
      wifi: ath12k: use per-device max QMI chunk size
      wifi: ath12k: clear chunk paddr and size in ath12k_qmi_free_target_mem_chunk()
      wifi: ath12k: align QMI target memory to 64 KB

Benjamin Berg (6):
      wifi: mac80211: add key link_id to debugfs
      wifi: cfg80211: add Control Integrity Protocol (CIP) APIs
      wifi: mac80211: add cigtk parameter to ieee80211_gtk_rekey_add
      wifi: mac80211: add helpers to parse/generate CIP Capabilities
      wifi: mac80211: add Control Integrity Protocol handling
      wifi: mac80211_hwsim: claim support for Control Integrity Protocol

Brian Norris (1):
      wifi: mwifiex: Reattach interfaces on suspend failure

Dan Carpenter (1):
      wifi: mm81x: fix type bugs handling sdio_readl/writel()

Emmanuel Grumbach (2):
      wifi: cfg80211: require zero terminator in valid_regdb country table
      wifi: cfg80211: use sysfs_emit_at() in addresses_show

Ginger Li (1):
      wifi: mac80211: Fix a race when expiring a mesh path

Hariharan Ramanathan (4):
      wifi: ath12k: rename wbm_status to htt_status in HTT TX completion
      wifi: ath12k: add TCL ring TX buffer allocation failure counter
      wifi: ath12k: add device DP stats reset support via debugfs
      wifi: ath12k: track per-ring RX sent-to-stack count

Ilan Peer (2):
      wifi: mac80211: Restrict probe request rates for minimal content
      wifi: mac80211: Gracefully deauthenticate on association timeout

Jeff Johnson (1):
      wifi: ath11k: fix reg_info_store leak in ath11k_service_ready_ext_event()

Johannes Berg (6):
      wifi: mac80211: add key flags to debugfs
      wifi: radiotap: add definitions for UHR U-SIG
      wifi: mac80211: mesh: don't send peering close in listen
      wifi: mac80211: fix potential ack-skb leak on error path
      Merge tag 'mm81x-next-2026-09-24' of https://github.com/MorseMicroLabs/linux-wireless
      Merge tag 'ath-next-20260927' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath

Kang Yang (6):
      wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
      wifi: ath12k: free pending MSDUs on duplicate mon link descriptor
      wifi: ath12k: fix stale tail_msdu pointer returned from mpdu_pop
      wifi: ath12k: place dp_mon_mpdu on stack in mon dst reap loop
      wifi: ath12k: fix skb leak on monitor PPDU ID wraparound
      wifi: ath12k: avoid double DMA unmap of held monitor RX buffers

Lachlan Hodges (8):
      wifi: mm81x: move beacon work and init below the tx op
      wifi: mm81x: release buffered broadcast frames after DTIM
      wifi: mm81x: do not drop PS filtered frames in AP mode
      wifi: mm81x: implement .tx_frames_pending() mac op
      wifi: mm81x: factor out tx width selection
      wifi: mm81x: tx EAPOLs at primary width
      wifi: mm81x: clamp tx width to stas max supported width
      wifi: mm81x: tx multicast frames from AP at primary width

Linmao Li (2):
      wifi: mm81x: free the firmware scratch buffer on parse failures
      wifi: mm81x: do not discard a failed firmware segment write

Loic Poulain (1):
      dt-bindings: net: wireless: qcom,ath10k: Document NVMEM cells

Miaoqing Pan (1):
      wifi: ath12k: remove unused ath12k_dp_rx_h_find_link_peer()

Miri Korenblit (1):
      wifi: nl80211: allow a NAN peer schedule with 2 channels in the same slot

Pagadala Yesu Anjaneyulu (2):
      wifi: nl80211: defer AP beacon regulatory check to start_ap
      wifi: nl80211: reject color-change requests that change 6 GHz power type

Pardeep Kaur (2):
      wifi: ath12k: fix out-of-bounds access on TX stats arrays
      wifi: ath12k: fix 1-based ring index in REO Rx Received debugfs output

Rory Little (1):
      wifi: cfg80211: validate monitor channel set against radio usage

Ruide Cao (1):
      wifi: mac80211: start next ROC after purging an interface

Tianchu Chen (3):
      wifi: mwifiex: bound SDIO fw dump count by memory table size
      wifi: cw1200: fix link_id_db OOB access via device-controlled link ID
      wifi: libertas: fix RX OOB access from device-controlled pkt_ptr

 .../bindings/net/wireless/qcom,ath10k.yaml         |  16 ++
 drivers/net/wireless/ath/ath11k/wmi.c              |   9 +
 drivers/net/wireless/ath/ath12k/core.h             |   9 -
 drivers/net/wireless/ath/ath12k/debugfs.c          |  78 ++++++-
 drivers/net/wireless/ath/ath12k/dp.c               |  90 +++++---
 drivers/net/wireless/ath/ath12k/dp.h               | 114 ++++++---
 drivers/net/wireless/ath/ath12k/dp_mon.c           |  15 +-
 drivers/net/wireless/ath/ath12k/dp_mon.h           |   2 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |  33 +--
 drivers/net/wireless/ath/ath12k/dp_rx.h            |   3 -
 drivers/net/wireless/ath/ath12k/dp_stats.h         |  25 ++
 drivers/net/wireless/ath/ath12k/hw.h               |   1 +
 drivers/net/wireless/ath/ath12k/mac.c              |   5 +-
 drivers/net/wireless/ath/ath12k/qmi.c              | 102 +++++---
 drivers/net/wireless/ath/ath12k/qmi.h              |   4 +
 drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c     |  22 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c      |  52 ++++-
 drivers/net/wireless/ath/ath12k/wifi7/dp_tx.c      |  39 ++--
 drivers/net/wireless/ath/ath12k/wifi7/hal_rx.c     |   5 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |   7 +
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |  10 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |  13 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   3 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  11 +-
 drivers/net/wireless/intel/iwlwifi/mld/d3.c        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   6 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |   6 +-
 drivers/net/wireless/marvell/libertas/rx.c         |   9 +
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |  20 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   3 +
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  13 +-
 drivers/net/wireless/morsemicro/mm81x/core.h       |   7 +-
 drivers/net/wireless/morsemicro/mm81x/fw.c         |   9 +-
 drivers/net/wireless/morsemicro/mm81x/mac.c        | 181 +++++++++------
 drivers/net/wireless/morsemicro/mm81x/sdio.c       |   9 +-
 drivers/net/wireless/morsemicro/mm81x/skbq.c       |   7 +-
 drivers/net/wireless/nxp/nxpwifi/cfg80211.c        |  11 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   8 +-
 drivers/net/wireless/realtek/rtw89/wow.c           |   6 +-
 drivers/net/wireless/st/cw1200/txrx.c              |   2 +-
 drivers/net/wireless/virtual/mac80211_hwsim_main.c |  35 +++
 drivers/net/wireless/virtual/mac80211_hwsim_nan.c  |  22 ++
 drivers/net/wireless/virtual/mac80211_hwsim_nan.h  |   3 +
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |   9 +-
 include/linux/ieee80211.h                          |  22 ++
 include/net/cfg80211.h                             |  45 +++-
 include/net/ieee80211_radiotap.h                   |  45 +++-
 include/net/mac80211.h                             |  13 +-
 include/uapi/linux/nl80211.h                       |  55 ++++-
 net/mac80211/cfg.c                                 |  54 ++++-
 net/mac80211/debugfs_key.c                         |  18 +-
 net/mac80211/ieee80211_i.h                         |   7 +
 net/mac80211/key.c                                 |  96 ++++++--
 net/mac80211/key.h                                 |   3 +-
 net/mac80211/mesh_pathtbl.c                        |  13 +-
 net/mac80211/mesh_plink.c                          |   4 +-
 net/mac80211/mlme.c                                |  84 ++++++-
 net/mac80211/nan.c                                 |  33 +++
 net/mac80211/offchannel.c                          |  10 +
 net/mac80211/parse.c                               |   4 +
 net/mac80211/sta_info.h                            |   2 +
 net/mac80211/tx.c                                  |   2 +-
 net/mac80211/util.c                                |  41 ++++
 net/wireless/ap.c                                  |   7 +-
 net/wireless/chan.c                                |  33 ++-
 net/wireless/core.c                                |  87 +++++--
 net/wireless/core.h                                |  11 +-
 net/wireless/ibss.c                                |   3 +-
 net/wireless/nl80211.c                             | 257 +++++++++++++++++----
 net/wireless/rdev-ops.h                            |  40 +++-
 net/wireless/reg.c                                 |  13 +-
 net/wireless/sme.c                                 |  10 +-
 net/wireless/sysfs.c                               |  12 +-
 net/wireless/trace.h                               |  62 +++--
 net/wireless/util.c                                |  40 +++-
 net/wireless/wext-compat.c                         |   8 +-
 76 files changed, 1688 insertions(+), 486 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_stats.h
