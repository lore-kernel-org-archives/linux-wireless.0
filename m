Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943FE4DAF86;
	Wed, 30 Sep 2026 12:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790772293; cv=none; b=MF2yzDfzI5F5wC9Y3D4q4L6eQMrtjg7OmBcyU1I9JfFLZRCjl9l9OXtMCh7pipJ1Wd79Mtz5TnCT7yX2quDkCqs3T9wrN/3XIYpFgC/WrUHUGibPf6ZLo+V74jMtkMqdXoSdj4N/F+tKFFZ/v2vXBqn4pYTN/xrLwYMiCCXnWrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790772293; c=relaxed/simple;
	bh=BdwF+8ZzyQ042BBSxwyVYcS3B9mwB4pPVPRu+FMrADk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ihyIoga9Kq66ISzURp8Is4HPPOgaQ8HAGMXB0jXf9Bogh7ZS9aZ+9/d9ffoaw+9mOrXlchV8s6OZOVkZ8CQfhswaIexK4zu6zhip3sFC4JqjCDi1FrubHgYqaE78I3EG3fRoU813OxCg08DGB787jhdGOoMeDXaPEa0nd5dUtb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=I32Saich; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="I32Saich"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=8g32t+zO2en2kH3VFzkAJ6Vw2Oa4E3Ow1IoHEpnHW7Q=; t=1790772289; x=1791981889; 
	b=I32SaichSKa8uPtYDj9/X2ZHMSnYDWSpClmq3cspPNwuJZUPiZctsnlEhIYRo+Fflq53COLYn36
	fjIodEuSpMja8mbKZi9DLL5XyT3DA7u+Of5w48H+IS2dYuEx9n5LJBdxIFbudvVFOB8yaHqEEUj6i
	vtzg6wSn8Y/P8oqGteorTR+ykL/Ic/WsJh6j2cBor08DOzvdUuEFSZbT/DbCXCxgHJOhsNNh1XeUQ
	CXLKyU9VrnokWjw4QQXUMPILjRPdCnCSfK0tZfPKxLiOy2Bf0yIGQVZEmU8Lj8tnV/+DAr7VSjhyE
	DVtXheGqiS2jf4sSqhHnrI4qFbf18KSaxzeQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xBtfx-0000000GPWy-1bTn;
	Wed, 30 Sep 2026 14:44:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-09-30
Date: Wed, 30 Sep 2026 14:43:00 +0200
Message-ID: <20260930124440.224799-3-johannes@sipsolutions.net>
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

Things aren't really slowing down by that much, unfortunately, but
these are mostly fairlyh obvious changes.

Note there will be a merge conflict with ieee80211_lookup_ra_sta()
when this gets pulled into net-next which made it static, and here
we add another argument to the function.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit b5a051f6b840d48f159166ef073d3021989bfb50:

  Merge tag 'net-7.3-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-09-17 10:40:48 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-09-30

for you to fetch changes up to 6f63e919fe1e335b8abcb3a28bfd4804a98d875a:

  wifi: mac80211: fix slab-out-of-bounds read in ieee80211_monitor_select_queue() (2026-09-28 11:11:19 +0200)

----------------------------------------------------------------
Still more fixes coming in, notably:
 - ath11k: avoid running out of stations on HW restart
 - mac80211:
   - drop too large fragmented MPDUs
   - mesh path handling fixes
   - validation improvements
   - reject CSA with bad 320 MHz bandwidth
 - cfg80211: fix RTS for single radio devices

----------------------------------------------------------------
Aamir Ahmed (1):
      wifi: wfx: validate MIB read length before copying to caller

Cen Zhang (Microsoft) (1):
      wifi: mac80211: fix slab-out-of-bounds read in ieee80211_monitor_select_queue()

Felix Fietkau (2):
      wifi: mac80211: prevent AP VLAN tx from other interfaces
      wifi: mac80211: set info->band for 802.3 encap offload frames

Georgios Karantzas (1):
      wifi: ath9k_htc: bound TX aggregation to MAX_TX_BUF_SIZE

Guangshuo Li (1):
      wifi: iwlegacy: 3945: free EEPROM data on remove

Heyang Tan (1):
      wifi: p54: validate firmware record lengths

Johannes Berg (1):
      Merge tag 'ath-current-20260921' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath

Nicolas Escande (1):
      wifi: ath11k: reset ar->num_stations on hardware start

Pengpeng Hou (1):
      wifi: ath9k: reject short WMI command responses

Ruide Cao (1):
      wifi: mac80211: reject invalid 320 MHz CSA bandwidth

Stanislaw Gruszka (1):
      wifi: cfg80211: fix RTS threshold setting for single-radio PHY

Tianchu Chen (1):
      wifi: cw1200: fix TX padding OOB read leaking heap data to device

Toke Høiland-Jørgensen (1):
      wifi: ath9k: Clean up device initialisation guards

Wentao Liang (1):
      wifi: wlcore: Fix runtime PM leak in wlcore_remove()

Yuchao Zhang (1):
      wifi: mac80211: drop oversized fragments to avoid extra_len overflow

Yuqi Xu (3):
      wifi: mac80211: minstrel_ht: validate fixed rate index
      wifi: mac80211: handle empty FILS association request payload
      wifi: mac80211: validate TX status rate metadata

Zhao Li (6):
      wifi: mac80211: release mesh path quota on failed additions
      wifi: mac80211: account proxy paths against the mesh path limit
      wifi: mac80211: drain PS delivery work during station teardown
      wifi: mac80211: shut down RX BA session timer on teardown
      wifi: mac80211: keep fallback association elements alive
      wifi: cfg80211: preserve hidden-group beacon IE ownership

Zhiling Zou (2):
      wifi: mac80211: count only matching reservations in reserved switch
      wifi: mac80211: keep paired old chanctx alive

Zihan Xi (1):
      wifi: mac80211: fix mesh fast xmit path deletion UAF

 drivers/net/wireless/ath/ath11k/mac.c          |  1 +
 drivers/net/wireless/ath/ath9k/hif_usb.c       | 21 +++---
 drivers/net/wireless/ath/ath9k/htc.h           |  1 -
 drivers/net/wireless/ath/ath9k/htc_drv_init.c  |  7 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c  |  8 +--
 drivers/net/wireless/ath/ath9k/wmi.c           | 28 +++++---
 drivers/net/wireless/ath/ath9k/wmi.h           |  1 +
 drivers/net/wireless/intel/iwlegacy/3945-mac.c |  1 +
 drivers/net/wireless/intersil/p54/fwio.c       | 42 ++++++++++--
 drivers/net/wireless/silabs/wfx/hif_tx.c       |  4 +-
 drivers/net/wireless/st/cw1200/bh.c            |  8 ++-
 drivers/net/wireless/st/cw1200/txrx.c          | 14 ++++
 drivers/net/wireless/ti/wlcore/main.c          |  4 +-
 net/mac80211/agg-rx.c                          |  2 +-
 net/mac80211/chan.c                            | 50 ++++++++++++---
 net/mac80211/drop.h                            |  1 +
 net/mac80211/fils_aead.c                       |  8 +++
 net/mac80211/ieee80211_i.h                     |  2 +-
 net/mac80211/iface.c                           |  4 +-
 net/mac80211/mesh_pathtbl.c                    | 30 +++++++--
 net/mac80211/mlme.c                            |  4 +-
 net/mac80211/rc80211_minstrel_ht.c             | 89 +++++++++++++++++++++++---
 net/mac80211/rx.c                              |  6 ++
 net/mac80211/spectmgmt.c                       |  4 +-
 net/mac80211/sta_info.c                        |  6 +-
 net/mac80211/status.c                          | 70 ++++++++++++++++++++
 net/mac80211/tx.c                              | 45 +++++++++----
 net/wireless/nl80211.c                         | 11 ++--
 net/wireless/scan.c                            | 22 ++++---
 29 files changed, 395 insertions(+), 99 deletions(-)
