Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8759B3AEF59;
	Thu, 22 Jan 2026 11:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769079783; cv=none; b=WA8B4jnlOrloZUGW/dZTGosQQmmN5TFxF1pVTu7xZ67XljsK3prRJ8NNPAczmIz0tdsCIKuf2qyV6nsgnvAYGPlk8bx6yrb+m7wbAoWj6YO1kR5VuQCnzMdbM7pIDw16IYG/wUFAo2K9/7cFIlo7j9TwpvmR49CTwZ4vVAVpKMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769079783; c=relaxed/simple;
	bh=EJ9ib7F0K5Rqn/pUdIC06L4e/j5Oko3L1qHs+r39AQw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e5reT8Scsd5OimhJ0ArYIqUDf61q6d2QJEOoFOmUOc09LgNCne62xzFPrer6ky4/nGt5+nPeKkpfvFZitqS/fhfUgL9YBY1fxyJ8B50HRaKTyT6uLaRDItFcEmRiTNyK/eL78pLzEdphJlo+nsOmMcrKNvxGZjALWIxuafx+nns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=RnJE88ZB; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="RnJE88ZB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=PMYkWZ+WB18SE6UeamFhFApshl5FD7b6rWVwoxj0pwc=; t=1769079781; x=1770289381; 
	b=RnJE88ZBeT62+pft3dgD1G2DNHnHQk9rR4fehIO+nq9fbzbsjML/NUCDl6ZQlmv6h5Gv7wMs72z
	ieM8XLsu2t6VK15pBonaqjYwi7ByshG2/LX1XS+CiU1GpHqAL2Fl1lpvjLwaykx42TTJ7s9nagVnT
	cyKw8St8eVUP81S1wxlnZnVCIiLhsXbmndU0hFVcz7RFSTThXOFY8i/aZVJBwxnm8QNR60waJegj2
	b6Sqxl7Fxh+ozy9t5gD8qPV19USQIKox42T5hjaurQFt430HHoZ19q2ylND8t8BV1oeZ1Wgai58Bc
	lqkuSFW/LwEW2g8Q6b7blHuq6rwUaI2HoPRg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1visSh-00000000ofa-3gIK;
	Thu, 22 Jan 2026 12:02:52 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-11-22
Date: Thu, 22 Jan 2026 12:00:15 +0100
Message-ID: <20260122110248.15450-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Some more updates from wireless. The only interesting thing here is
that there's a merge conflict with net-next, see here:
https://lore.kernel.org/all/98386125-c0bb-495e-b2ba-2765aaed19d8@oss.qualcomm.com/

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit f2a3b12b305c7bb72467b2a56d19a4587b6007f9:

  Merge tag 'net-6.19-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-01-08 08:40:35 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-11-22

for you to fetch changes up to 50b359896fe55d0443ed550e1fabba71d242031a:

  wifi: cfg80211: ignore link disabled flag from userspace (2026-01-20 10:02:01 +0100)

----------------------------------------------------------------
Another set of updates:
 - various small fixes for ath10k/ath12k/mwifiex/rsi
 - cfg80211 fix for HE bitrate overflow
 - mac80211 fixes
   - S1G beacon handling in scan
   - skb tailroom handling for HW encryption
   - CSA fix for multi-link
   - handling of disabled links during association

----------------------------------------------------------------
Baochen Qiang (2):
      wifi: ath12k: don't force radio frequency check in freq_to_idx()
      wifi: ath12k: fix dead lock while flushing management frames

Benjamin Berg (3):
      wifi: mac80211: parse all TTLM entries
      wifi: mac80211: apply advertised TTLM from association response
      wifi: cfg80211: ignore link disabled flag from userspace

Dan Carpenter (1):
      wifi: mwifiex: Fix a loop in mwifiex_update_ampdu_rxwinsize()

Johannes Berg (1):
      Merge tag 'ath-current-20260113' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath into wireless

Lachlan Hodges (1):
      wifi: mac80211: don't perform DA check on S1G beacon

Manish Dharanenthiran (1):
      wifi: ath12k: cancel scan only on active scan vdev

Marek Vasut (1):
      wifi: rsi: Fix memory corruption due to not set vif driver data size

Miri Korenblit (2):
      wifi: mac80211: correctly check if CSA is active
      wifi: mac80211: don't increment crypto_tx_tailroom_needed_cnt twice

Thomas Fourier (2):
      wifi: ath10k: fix dma_free_coherent() pointer
      wifi: ath12k: fix dma_free_coherent() pointer

Veerendranath Jakkam (1):
      wifi: cfg80211: Fix bitrate calculation overflow for HE rates

Yingying Tang (2):
      wifi: ath12k: Fix scan state stuck in ABORTING after cancel_remain_on_channel
      wifi: ath12k: Fix wrong P2P device link id issue

 drivers/net/wireless/ath/ath10k/ce.c               |  16 +-
 drivers/net/wireless/ath/ath12k/ce.c               |  12 +-
 drivers/net/wireless/ath/ath12k/mac.c              |  16 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |   9 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   6 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   1 +
 include/net/cfg80211.h                             |   3 -
 include/uapi/linux/nl80211.h                       |   5 +-
 net/mac80211/ieee80211_i.h                         |   2 -
 net/mac80211/iface.c                               |   8 +-
 net/mac80211/key.c                                 |   3 +-
 net/mac80211/mlme.c                                | 213 ++++++++++++---------
 net/mac80211/scan.c                                |   9 +-
 net/wireless/nl80211.c                             |  10 -
 net/wireless/util.c                                |   8 +-
 15 files changed, 171 insertions(+), 150 deletions(-)
