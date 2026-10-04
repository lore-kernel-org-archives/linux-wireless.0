Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F0A3B585F;
	Sun,  4 Oct 2026 11:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112697; cv=none; b=FMRHFnjj26ZN7sKONNVHTQehpO1MxZGEM0v4LBqKShPFUUV3bTwfDs6HS77Wv8s8OgOm9tv0mbDuU1k+OvSREGO1E2Wk8YqZsNVcs03ElnJSYDmkoAoHSPCSFablzIPH4kqJQ17elzUsy/BYJiaFvpO53pR1wiVYzO8Quu4fe1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112697; c=relaxed/simple;
	bh=gHUiKaMXzHFbFuj9bt+g89vOWaKFGoV4n+t64jc33yI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=af7aDF0bKGGa5+FpHfdmHAneJm5Y8LgkYyALcTpXOsv6vQTaddGlA6KTB3nELYxt5+IHMh8/HPPPDmfGAy5Tk99jhEAxyX4X88C6o+ccBz+KS7hnTsKque7l2zxy+2mLOA2LLQctvt+nQG5p3Xx85SRS2KZuKkDOy/deYiC19fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=RLLwMX1J; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="RLLwMX1J"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 078F513C31;
	Sun, 04 Oct 2026 14:18:14 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=sig1; bh=z14jOlj3j4hOPmIKQRS6Z8i1b6d3wA/Dft6otIb+H9I=; b=
	RLLwMX1JL8m8yq+zaea709O7zEBxrAHDafnrzB/a9G0abCAfrRJOX9v9Oog7VeTl
	w2TsY8PYRrOZx49n4+j0r4XgLKP8nrGCSas1cCvU51oA16hZf0dPp42qN/ACTSIW
	o1IA6B9BDJGLdwoMoRw6lWhgLuBA2mdkPC6CbdMa7DEeeUAL2eGeUnlEz5//jWoh
	mildzP0VPI8TB+geuIGtnBMNoPH7HaoZeBrMqxK5+BRzz4oS00oZkG6+5MIWOqcr
	kf6ow7AQWcFaHRyxet+6rIfuu0mTf0aL5WkK3xv00cQbj5vVIa/h2fp9M+1i5AYL
	LFxN7heTXbph1htDKTeJHw==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 086F413C30;
	Sun, 04 Oct 2026 14:18:13 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:18:12 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH ath-next 0/5] wifi: ath11k: WMI services debugfs and HE AP fixes
Date: Sun, 4 Oct 2026 14:18:02 +0300
Message-ID: <cover.1791111135.2.git.me@andrei-z.com>
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

A debugfs file listing the firmware's WMI services, and fixes for an
ath11k HE AP found by checking it against IEEE Std 802.11-2024, each
tested on a QCN9074:

1. debugfs: wmi_services lists the services the firmware advertises.
   Earlier posted in the airtime fairness series, now split by tree;
   since v2 the commit message no longer claims to match ath10k's
   output.
2. Probe Responses during a channel switch carried the initial count:
   ath11k never counted down mac80211's CSA counter (as ath12k does).
3. Without spatial reuse parameters, an AP enabled non-SRG OBSS PD at
   -62 dBm; it now stays off, as in ath12k.
4. A 6 GHz AP never sent its per-20 MHz power limits to firmware (the
   TPC command was station only); it now does as an LPI AP, as in
   ath12k.
5. The hardware DSCP-TID tables used the class selector bits, while
   cfg80211 maps DSCP to UP per RFC 8325 section 4; checked on air
   through the firmware's per-TID peer statistics (CS1->1, AF21->3,
   EF->6, CS6->7).

None of them depends on the mac80211 series sent alongside.

The patches by me were written with an AI coding assistant (Claude
Code), which also drafted the changelogs; the testing described was done
on the hardware.

v2 of patch 1: https://lore.kernel.org/all/20261003155542.96363-2-me@andrei-z.com/

Andrei-Alexandru Bleortu (5):
  wifi: ath11k: add a debugfs file listing the firmware WMI services
  wifi: ath11k: count down channel switch announcements in mac80211
  wifi: ath11k: leave OBSS PD off when spatial reuse is not configured
  wifi: ath11k: set the 6 GHz transmit power limits of an AP
  wifi: ath11k: map DSCP to TID as cfg80211 does by default

 drivers/net/wireless/ath/ath11k/core.h    |  2 ++
 drivers/net/wireless/ath/ath11k/debugfs.c | 15 +++++++++++
 drivers/net/wireless/ath/ath11k/hal_tx.c  | 30 +++++++++++-----------
 drivers/net/wireless/ath/ath11k/mac.c     | 31 +++++++++++++++--------
 drivers/net/wireless/ath/ath11k/wmi.c     | 23 +++++++++++++----
 5 files changed, 71 insertions(+), 30 deletions(-)


base-commit: f49defea7668d8c68ec19fa085ef3da6075561c7
-- 
2.47.3


