Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B49411A0B;
	Sun,  4 Oct 2026 11:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791113089; cv=none; b=b1KX9kqRNrdn4/N+eLwx3HZhATAs/1lzmnY/anyKcoFi3kbyMFdDAaqOqD32nc1JtN7O/H2ev+H311ePNOfliiRBqQ4Zu/p6freGBb7YaR+RR0ugf9F70+IluiV3ynJ6+X6EzkW8GNwZH/xCKR3vzSCAzRnQsUOoHBlVy8P6uzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791113089; c=relaxed/simple;
	bh=mkS23j0OH2i2rWCyMiqhNF7buEnTprSLfoy3D6h4Mw4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RJ7eTwt2DHP93TKdDQ0DY30Qq7NES5nr9rXoUNMm+ZrX8HMurY11KnPz2L1JXNakSHW2SlCXA2ohp4p4ojLgRRwmdhtgdqAj5oeUGQJFhrb+fFZ3A+6NkuLN9ny42CiAzeL8zhYlAp10tYpr03Sh3e6jg5RBUeIGbDefa6v83ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=bny5b1ky; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="bny5b1ky"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 90DDD13D2B;
	Sun, 04 Oct 2026 14:24:46 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=sig1; bh=KMk7EA10g1nkTDaHhk/5Ru/VTE9WAOox/BmBAwF5SKg=; b=
	bny5b1kyzHoXCdfkgciYDzScUPd9nqJMLyql3fxR9canggn0jUfkxK/qEO9DZdX8
	KQ13EOwZydxJa8rWQQtZCugzj5U5FQb8gT6FJZj2u8Xx/54+RTH5o99B2pHm3jtv
	VbU/v8fG1Pcak7fxhFeOyC99VUwLGqPiE0shpLLKf6OJOYPHTr2gpLJ0iJEmOL2S
	5Ybs4svX1vZoxy7ixN/B951Pdg+bXc+NvwxPJ0XCrgAbjheTsJq+zupWkYefSfZo
	ydRXcd5eLi9ZN2DigOIWC36d8q+kVtnSjoWV4Ad4voxvLm/qPpfJdmh91PhI0qVD
	aan9KDLEahH+xrC3yK1Njg==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 993B413D2A;
	Sun, 04 Oct 2026 14:24:45 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:24:45 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH ath-next 0/2] wifi: ath11k: firmware airtime fairness, BSS color while disabled
Date: Sun, 4 Oct 2026 14:24:38 +0300
Message-ID: <cover.1791111135.3.git.me@andrei-z.com>
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

Two ath11k patches that need the mac80211 changes in "[PATCH
wireless-next 0/2] wifi: mac80211: airtime weight op, BSS color during
a color change" (<cover.1791111135.1.git.me@andrei-z.com>):

1. Firmware airtime fairness (ATF) on the QCN9074 and IPQ5018, using
   Felix Fietkau's sta_set_airtime_weight op. Changes since v2: the
   command ID and TLV tags sit in their enums; a radio whose firmware
   refuses ATF keeps working without it; the commit message says the
   122 Mbit/s cap was measured with the firmware's strict scheduling
   set, which the patch does not do.
2. Keep the BSS color in the vdev parameter while the color is disabled
   during a color change (IEEE Std 802.11-2024, 26.11.4); with mac80211
   now keeping the color, the firmware gets it instead of 0.

They are based on ath-next with that series applied, and can wait for
it to reach ath-next.

The patches by me were written with an AI coding assistant (Claude
Code), which also drafted the changelogs; the testing described was done
on the hardware.

v2 also carried beacon protection, now dropped: with the firmware
signing beacons, a client that enforces beacon protection (Intel BE200,
iwlmld) lost every beacon on QCN9074 and IPQ5018, with either BIGTK
index and with or without a host-built MME. Until it is known what the
firmware needs, BIP stays in software and the feature is not advertised.

v2: https://lore.kernel.org/all/20261003155542.96363-1-me@andrei-z.com/

Andrei-Alexandru Bleortu (2):
  wifi: ath11k: support firmware airtime fairness
  wifi: ath11k: keep the BSS color while it is disabled

 drivers/net/wireless/ath/ath11k/core.h |   1 +
 drivers/net/wireless/ath/ath11k/mac.c  | 116 +++++++++++++++++++++++--
 drivers/net/wireless/ath/ath11k/wmi.c  |  97 +++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/wmi.h  |  51 +++++++++++
 4 files changed, 260 insertions(+), 5 deletions(-)


base-commit: f49defea7668d8c68ec19fa085ef3da6075561c7
prerequisite-patch-id: 0ce384d8e432a5ffedf43b8e02dd2576a52fb3fb
prerequisite-patch-id: f606f9dee7c5cdf33bf5f06e985885fd9deaf90a
-- 
2.47.3


