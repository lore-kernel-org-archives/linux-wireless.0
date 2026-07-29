Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202C93F23BD;
	Wed, 29 Jul 2026 07:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785309609; cv=none; b=TY/xYe9N1eWBzXk+5RvAMEvoEIgXLEXx+e29SeiQLCnrMv9V3LZemz9HgqIz+UscKGoNC1eVjOSnFjB687SdYx08/G+sqm3mq7kLom4e/rOyhbXt9MyKBqnsVQgio0fYIvn/3IcgJTMZ6++fgHItMP70FTnUeZoJh8Rj4ZIpQ2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785309609; c=relaxed/simple;
	bh=V7hWWO6mhuQqEW9REQVaHEQj9LnMTlK7Pk4hG+CxxjI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jeluTU2l2fOUkIQfNgXENSPc+OCiNwMhcQtXejFaJFXg9lwevXxcz7DwiXsCFrqaV8RR+m+vWF5tqdCiQ8GADGIYniAqKDU9eaIpB0Nswc+zBnuFWN+FdY6Lu5+JzEL/k2arg3VWKFBjq7rnSLNGFnUPfKFRhUSQkKaTymNcWEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qrbUX6z1; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qrbUX6z1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=jN5Og704DD+cr7s0QTEbW7DW1bfVaR+PYmPPBHoGk2s=; t=1785309601; x=1786519201; 
	b=qrbUX6z1i+io+D0dCs5ebIQCYtI+4hI/iZ1rPaa5/gxWjwhOyol7NMOESVvTU/61NdxRRY2/+Z/
	mS4xjbm7RgXkCyCW0DEQOZPQGwNFNVvbtleF7ID4bK8HxiE70cJ0fJ2HyGZKQ+mmyn3kIRv//mSnS
	lnrtTtx0KufVbVm70ExBhor8KoqaRpd70QABb9m4S1rvi2+7cZJQqtGPnTQZ+ST9mqIsEkFR7t086
	MJXa2HbqSWhFYhxPJGvU0ofRCkG91KkdhJlYlLN9l2gTyJ/sYHjY/FMTSskfpxpmunPX1+NfqI5D8
	e9SjeIBL0Ftvdfzaru9l7+j0OLRYXX/Wsa+A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1woya5-0000000HJeF-06Rd;
	Wed, 29 Jul 2026 09:19:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-07-29
Date: Wed, 29 Jul 2026 09:18:13 +0200
Message-ID: <20260729071954.45655-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

So this week is _far_ less, thankfully. A couple more
fixes that seemed important enough, but I've also been
much more selective, in particular the 'mwifiex' driver
seems to be a train-wreck, and has a lot of fixes and
associated discussions still open - but I think I'll be
leaving those for -next.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit d326f83e819c53aa05c40d64f5805d6237b6aa1b:

  Merge tag 'net-7.2-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-07-23 12:58:08 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-07-29

for you to fetch changes up to 57aa1718d5953dd532137d43b696c68545c2e0b3:

  wifi: iwlegacy: replace BUG_ON() with WARN_ON() on num_stations check (2026-07-28 15:35:37 +0200)

----------------------------------------------------------------
Much quieter, thankfully:
 - a set of ath12k fixes, including a recent
   MLO regression for WCN7850/QCC2072
 - iwlegacy gets rid of a BUG_ON that triggered
 - a couple more robustness/security fixes

----------------------------------------------------------------
Baochen Qiang (8):
      wifi: ath12k: fix out-of-bounds clear_bit in ath12k_mac_dp_peer_cleanup()
      wifi: ath12k: factor out peer assoc send-and-wait into a helper
      wifi: ath12k: keep ATH12K_PEER_ML_ID_VALID set in ath12k_sta::ml_peer_id
      wifi: ath12k: add support for HTT_T2H_MSG_TYPE_MLO_RX_PEER_MAP
      wifi: ath12k: introduce host_alloc_ml_id hardware parameter
      wifi: ath12k: do not advertise MLD peer ID for firmware-allocate devices
      wifi: ath12k: defer dp_peer registration when firmware allocates MLD peer ID
      wifi: ath12k: resolve PENDING ML peer ID from MLO_PEER_MAP HTT event

Deepanshu Kartikey (1):
      wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()

Johannes Berg (1):
      Merge tag 'ath-current-20260727' of git://git.kernel.org/pub/scm/linux/kernel/git/ath/ath

Stanislaw Gruszka (1):
      wifi: iwlegacy: replace BUG_ON() with WARN_ON() on num_stations check

Zhao Li (4):
      wifi: mac80211: fix tid_tx use-after-free on BA session stop
      wifi: mwifiex: use the subframe length when parsing A-MSDU TDLS frames
      wifi: cfg80211: publish PMSR request before starting the driver
      wifi: mac80211: validate individual TWT params before driver setup

 drivers/net/wireless/ath/ath12k/core.c             |   2 +
 drivers/net/wireless/ath/ath12k/core.h             |   3 +
 drivers/net/wireless/ath/ath12k/dp_htt.c           |  49 ++++++
 drivers/net/wireless/ath/ath12k/dp_htt.h           |  12 ++
 drivers/net/wireless/ath/ath12k/dp_peer.c          |  75 +++++++++-
 drivers/net/wireless/ath/ath12k/dp_peer.h          |   2 +
 drivers/net/wireless/ath/ath12k/hw.h               |   2 +
 drivers/net/wireless/ath/ath12k/mac.c              | 165 ++++++++++++++-------
 drivers/net/wireless/ath/ath12k/peer.c             |  31 +++-
 drivers/net/wireless/ath/ath12k/peer.h             |   1 +
 drivers/net/wireless/ath/ath12k/wifi7/hw.c         |  12 ++
 drivers/net/wireless/intel/iwlegacy/common.c       |   7 +-
 drivers/net/wireless/intel/iwlegacy/debug.c        |   2 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |   2 +-
 net/mac80211/agg-tx.c                              |   4 +-
 net/mac80211/s1g.c                                 |   4 +
 net/wireless/pmsr.c                                |  22 ++-
 net/wireless/wext-sme.c                            |   9 ++
 18 files changed, 333 insertions(+), 71 deletions(-)
