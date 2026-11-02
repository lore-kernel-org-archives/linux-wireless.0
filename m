Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793616423;
	b=DhldSIfdOU9on4WH/TphO1rhNCXMwlUvsk5IAfudqeelURTgQ7Pw7n2wCZYVA4MaepMs
	 TjOxEXjy0ZkqeYz7WTJ5klYJ7qRCs2rxvNXhjm+LXolFl5nDO1abPG947yYZ+6c48hks+
	 B6kkU2hvaKXrbpt23tSLTxsUjBOqmvlNhVBFLz3IR96ZziZWjRbp4SfhSPBcCzF5O70Vu
	 EPpIyXccEEZWKNzQRcs0aZCwohg9Oi3e+avKm3+Sdq3mx7AVE3/3DGs3d15L+gmqjGV6m
	 MHbT/cfSXorWJpUVTQVZAnV4HX66wypEAbphgb7Aurzj8MDcibZljKKUvJPIBt8Aijw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793616423;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-malware-bazaar;
	bh=a1hyRsSVfnRQQLUN3WZlL+5K9kv+c3Zmam9PH7DT4ho=;
	b=l6kLsw+LGW+tWQ/0DIuxZHw2vDf7d0Y0KgkvChsRpYDGgAe/ZEqh21zRZt8XvNEqr80S
	 eKWs2yC3dLfMwtZVkc1DTk4xu/5H7awSwFwmc+ztJjYcIQ+6M83CYvEUUdzu3Y1ETeDdR
	 kuWvKeYuIAvsAxd4/PnM+xhtceN9722e718OL3rvAvi6E6/uCVLPpm6NAfTHi5mDfsyw8
	 FjgT2RQFBoWmEnOQA7JHUj3F/R8v0xqZ+vAOmBUKYYTH1dE6XfSj55CGd/FgDncUO7rFp
	 KTiOpuHVffiShIzKGo3j4hoOPDiwex3ckGpMazAWw5LwxpSx1D0sfhstazozDqhTvnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=d1iDsCPs;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257D0606A324;
	Mon,  2 Nov 2026 10:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=d1iDsCPs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=a1hyRsSVfnRQQLUN3WZlL+5K9kv+c3Zmam9PH7DT4ho=; t=1793616421; x=1794826021; 
	b=d1iDsCPs/btZaYZvvfFoTqe6wCch5misfmPdmLpOOMoU87/o9GXs9g7Y60oLRN/78rPBGjyA8Y8
	pxmCHX+rpECL+ToQJtqAppYUYe1KZ6XN3VlIVKJhW3EYJ8KVvwht5u2Nl0aC9iLo1nHOMRSAOPOVL
	XcfKf91At9GJtSrVV2pb3R9ZGzYeTNP+WdGriFRJ7A1IMFuzZN+RaNPFVpFWLvMky1aA/9efUDr2R
	JnFUDLnK5RxcVTui3d033S/uX/6PuyzKH97scjimmfE3k34ewTiHa+HRKPJvDS/YseeOV8iWDi+3e
	haftrQukdJRqlyGwLLAiiVtMKVTpIu0fj5nQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNpYz-00000001ApN-1FxZ;
	Mon, 02 Nov 2026 11:46:53 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-11-02
Date: Mon,  2 Nov 2026 11:46:33 +0100
Message-ID: <20261102104649.727621-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned

Hi,

Just a handful of fixes I'd collected before, sending
them so I can get the latest versions once all the
merging happens.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit 045958acaa75205b31578cb22c4345e28dd2e4bf:

  Merge tag 'net-7.3-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-10-15 08:20:20 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-11-02

for you to fetch changes up to 25e73f1d6868c759c8eb56cad4e411692c5341b4:

  wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg() (2026-10-26 12:20:45 +0100)

----------------------------------------------------------------
A few fixes to start with:
 - wext: fix notifier netns interaction
 - rsi: avoid TID OOB access
 - mac80211: reload pointer, fix A-MPDU flags
 - brcmfmac: fix DMA regression
 - cfg80211: fix regdb validation

----------------------------------------------------------------
Alex Kazinsky (1):
      wifi: rsi: Skip TX aggregation setup for non-QoS frames

Cosmin Ratiu (1):
      wifi: wext: Limit notifier event flushes to the device's netns

Jason Perlow (1):
      wifi: brcmfmac: map msgbuf RX packet IDs bidirectional

Toke Høiland-Jørgensen (1):
      wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()

Weigang He (1):
      wifi: mac80211: reload TDLS header pointer after skb_linearize()

Zijing Yin (1):
      wifi: cfg80211: fix out-of-bounds read in valid_rule()

 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  2 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |  2 +-
 include/net/iw_handler.h                           |  8 ++++--
 net/mac80211/tdls.c                                |  3 +-
 net/mac80211/tx.c                                  |  2 ++
 net/wireless/core.c                                |  2 +-
 net/wireless/reg.c                                 |  3 ++
 net/wireless/wext-core.c                           | 33 +++++++++++-----------
 8 files changed, 32 insertions(+), 23 deletions(-)
