Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BDA47668D
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787148202; cv=none; b=gH2lP6rfKHl31a8kMvh66HqnBhnS3aNE/guM91F7GrT1YlWNBRbLwtMof8Ng08OPyFnQXj54MlSm4t6wfPYcQH48SjWLcPG5Xmf9WRB/waMh7H5JqVH9k734EIMYOSL6uWMVCZW1PB392qm06DBiHMP11PVE9hEdBbiNgh0Yp3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787148202; c=relaxed/simple;
	bh=xetvrMQ5loH1ZYh93j+X2hcsCcHsLLEVP9ACkJZ+keM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ouCIgpz/UwcBwVNKhjf7lPnClBiiV91ql3PszFbs9WEv+WT6/95IhXLGJ2CKXBQf3K77FdzDhMf2fp3JHv/jDJ7eP6rpx8VYHuBRw8tmdT/7VrYDgQAj1loNlFI1PZuIx9QqUdD7vbEx9L/PbcqxB3iKV2090sVIkrcaHFyhpvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ZsRqXDbz; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ZsRqXDbz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=JyWaVN4KsyNUfHuv/LCeryFcTXMO5aKjG2j+HSmhUrw=; t=1787148200; x=1788357800; 
	b=ZsRqXDbz6XF1EWrSsdmxPdwZ/5UZchPZ8DB3fapgDIDTOfmhGUpbzbOIGL0EPfsB4H5vL7K0vLS
	XdcB446DSYsT/WGCcI8ZXlLZxjjkCAn8ubDlztq0nYHN6O1M1M+d9l+2StHoZnsL+71MBhjoZSw84
	+Ngr6lXz/pCJvYrpq3fulsQmzkzltH38O7+HXcDy+62boKJDxeS2+pGxNABlBq01+UDf/xuo1+TwM
	TRqskSKuigORce4dNw1aZGmN4wx2V8aJz2F4xqGteA5CnIJtVTWH5s8BKXgneLPGaNA2IOvOBHq+a
	hAOFRZUWUvhNA9zSPj3qAYqa65pzVdLUzTCg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <benjamin@sipsolutions.net>)
	id 1wwgsn-0000000B7qc-2IRf;
	Wed, 19 Aug 2026 16:03:10 +0200
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	Benjamin Berg <benjamin.berg@intel.com>
Subject: [PATCH wireless-next v3 0/8] Adding NO_STA flag and reworking RX link resolution
Date: Wed, 19 Aug 2026 15:57:04 +0200
Message-ID: <20260819135703.4072215-10-benjamin@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Benjamin Berg <benjamin.berg@intel.com>

Hi,

This patchset refactors the RX link resolution a bit to fix some issues
where mac80211 might accept frames on the wrong link and incorrectly
translate the address. It also adds a new NL80211_ATTR_FRAME_CMD_NO_STA
flag so that userspace can know whether address translation was done by
the kernel on RX and can also prevent address translation for management
frames during TX.

This together should be enough to fix the existing issues in hostapd
where stations that are still associated try to authenticate again but
hostapd for example ends up sending the frame to an old link address.

Benjamin

PS: Sorry, the last mail had various issues, so resending properly now.

v3:
 * Fix issues found during review

v2:
 * Remove unused variable in rtw89

Changes in v1:
 * Add NAN_DATA interface handling
 * Handle NO_STA flag correctly for NAN
 * Fixed forwarding of station parameter
 * Rebase and other small fixes

Changes in RFCv2:
 * Port other drivers to new API (untested)
 * Fix a checkpatch warning

Benjamin Berg (8):
  wifi: iwlwifi: use link_sta internally to the driver
  wifi: mac80211: change public RX API to use link stations
  wifi: mac80211: refactor RX link_id and station handling
  wifi: mac80211: rework RX packet handling
  wifi: cfg80211: add attribute for TX/RX denoting there is no station
  wifi: mac80211: report to cfg80211 when no STA is known for a frame
  wifi: mac80211: pass station to ieee80211_tx_skb_tid
  uwifi: mac80211: pass error station if non-STA transmit was requested

 drivers/net/wireless/ath/ath11k/dp_rx.c       |   2 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c      |   2 -
 drivers/net/wireless/ath/ath12k/dp_rx.c       |  20 +-
 drivers/net/wireless/ath/ath12k/hw.h          |  20 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c |  20 +-
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.h |  12 +-
 drivers/net/wireless/ath/ath12k/wifi7/hw.c    |   6 +-
 drivers/net/wireless/ath/ath12k/wmi.c         |   6 -
 drivers/net/wireless/intel/iwlwifi/mld/agg.c  |  17 +-
 drivers/net/wireless/intel/iwlwifi/mld/agg.h  |   4 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.c   |  50 +-
 drivers/net/wireless/intel/iwlwifi/mld/rx.h   |   2 +-
 .../wireless/intel/iwlwifi/mld/tests/agg.c    |   7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c   |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |   6 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c |  22 +-
 drivers/net/wireless/realtek/rtw89/core.c     |   7 -
 .../wireless/virtual/mac80211_hwsim_main.c    |   3 -
 include/net/cfg80211.h                        |   4 +
 include/net/mac80211.h                        |  25 +-
 include/uapi/linux/nl80211.h                  |   7 +
 net/mac80211/agg-tx.c                         |   4 +-
 net/mac80211/ap.c                             |   3 -
 net/mac80211/ht.c                             |   2 +-
 net/mac80211/ieee80211_i.h                    |  11 +-
 net/mac80211/iface.c                          |   7 +-
 net/mac80211/mlme.c                           |  10 +-
 net/mac80211/offchannel.c                     |  13 +-
 net/mac80211/rx.c                             | 447 ++++++++++--------
 net/mac80211/scan.c                           |  10 +-
 net/mac80211/tdls.c                           |   2 +-
 net/mac80211/tx.c                             |  10 +-
 net/wireless/nl80211.c                        |   8 +-
 33 files changed, 413 insertions(+), 358 deletions(-)

-- 
2.55.0

