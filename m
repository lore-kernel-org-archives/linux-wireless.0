Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED5744F566;
	Sat,  3 Oct 2026 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791042965; cv=none; b=FhTUDVq1Bm+VUpD/Gv858I8/2iOqaZ79TPQlUbHIYqYaXX/JBxBVqjH32/tH/kBbGyyasPm0sorsTdccRUjtE+FlsArI71xvySHOADgb+s8TzOs90tM6LSZXdPmuf5P49Zu9tNIOqgwMbHoAie7BEw114MkAVPxkLdLFth5vBz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791042965; c=relaxed/simple;
	bh=q4SP1PeCbVK8jyAhfSJBnYf0nqYW/pJ7yUHAiyTeZdU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rCUKwzhFmJOnmqLDLNNTh6LNG7YO2udEahLgiE28KEOjq7amSEM0MVI4V2MRazHFvJTEqfwHUi2ocxF5srucpzIJwEczf+Me+MLiXpOySfWoLcNlyoVTT+i4lNgX0HherLnlXFe25ZoPg1bgQzVKBVBv0NPuE7WLKMsXV8MqPwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=Dp7yRJmR; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="Dp7yRJmR"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 4FA71E1C3;
	Sat, 03 Oct 2026 18:55:48 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=sig1; bh=XvIrXc1fFfzKNgh15SbDAaaz7UPjmjrI0Y9cfPx7zxg=; b=
	Dp7yRJmRLVkGNZctwULHvBw+rfVifuZiaZfAnptPRTjFQlxDMpB3Hj5RiSI/PdBL
	xY1slMbiHdUXubmCQg6AH38Novku61Pw2dNrREroH0qnGZxkh0sihSGYQgcW8ebc
	SGlrHWmYAUyeF634OPJ9nxpaKCoX56KcZHl52M+/D36PxveF8vRRU8Kk5qfId7sH
	OWyWTlBcZ9GuIvVsbVWurqEPwS9ysW0Oe2PK+BCrodMKe4nJRZupuJcjeMkzRJvp
	4vSGTsCInEvpZayrCtPH+O3FiQTcDlcC58GCsF4Ubp74ifhnJKN/F3LRuytzMyxq
	HDLYTFjacItKqcXENnaSkA==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id D11DEE16F;
	Sat, 03 Oct 2026 18:55:47 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sat, 3 Oct 2026 18:55:47 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>, Johannes Berg
	<johannes@sipsolutions.net>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 0/4] wifi: ath11k: beacon protection and firmware airtime fairness
Date: Sat, 3 Oct 2026 18:55:38 +0300
Message-ID: <20261003155542.96363-1-me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

Firmware features ath11k does not use yet, found while bringing up a
Ubiquiti UniFi U6 Enterprise (IPQ5018 with two QCN9074) with the data
path offloaded to NSS: a debugfs view of the firmware's services, beacon
protection and firmware airtime fairness, plus the mac80211 change the
last one needs.

Patch 1 lists the firmware's WMI service bits in debugfs, as ath10k
does: whether a feature exists is usually a service bit, and ath11k only
logs part of the map at debug level.

Patch 2 is beacon protection, following ath12k's implementation: the
firmware signs beacons with the BIGTK. Checked over the air on both
chips: every beacon in a monitor capture carried a Management MIC
element whose BIP-CMAC-128 MIC verifies against the BIGTK hostapd
installed (624 of 624; none with another radio's key), and a
wpa_supplicant client verified the SSID from a protected beacon.

Patch 3 is Felix Fietkau's mac80211 change from OpenWrt, which gives
drivers the station airtime weight (sta_set_airtime_weight). Patch 4
needs it; it is included unchanged, with his authorship.

Patch 4 is firmware airtime fairness: per-station airtime shares the
firmware schedules by, derived from the stations' airtime weights. With
the data path offloaded, mac80211's own airtime scheduler never sees the
frames, so the firmware is the only place fairness can happen there. A
station capped at 10% under strict scheduling drops from 885 to
122 Mbit/s and recovers when uncapped; at its normal fair share
throughput is unchanged (900 Mbit/s on 5 GHz HE80). The firmware needs
its ATF group defined before it accepts shares, which the commit
message details.

Patch 3 is for mac80211; the others go through the ath tree, and patch 4
depends on patch 3.

The patches were written with an AI coding assistant (Claude Code),
which also drafted the changelogs; the testing above was done on the
device.

Andrei-Alexandru Bleortu (3):
  wifi: ath11k: add a debugfs file listing the firmware WMI services
  wifi: ath11k: support beacon protection
  wifi: ath11k: support firmware airtime fairness

Felix Fietkau (1):
  wifi: mac80211: notify driver on airtime weight changes

 drivers/net/wireless/ath/ath11k/core.h    |   2 +
 drivers/net/wireless/ath/ath11k/debugfs.c |  15 ++
 drivers/net/wireless/ath/ath11k/mac.c     | 166 +++++++++++++++++++++-
 drivers/net/wireless/ath/ath11k/wmi.c     |  99 +++++++++++++
 drivers/net/wireless/ath/ath11k/wmi.h     |  58 +++++++-
 include/net/mac80211.h                    |   5 +
 net/mac80211/cfg.c                        |   6 +-
 net/mac80211/driver-ops.c                 |   4 +
 net/mac80211/driver-ops.h                 |  19 +++
 net/mac80211/sta_info.c                   |   7 +-
 net/mac80211/trace.h                      |  27 ++++
 11 files changed, 400 insertions(+), 8 deletions(-)


base-commit: f0406245cb9855e6318335a8a223551354291a46

