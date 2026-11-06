Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793953814;
	b=VbFlMb7sWr/6Pi+HNhr0wKYKpEwYM3iivhKsia/q5XXK9AL+z5bYG8Fu6ulTWYSeYxzg
	 W2bQOHEdbmNyBai4NR4dNxzdFBSV3LuxjSiwZbITfcVtxpDUf255u+rAPIYofSDDzbcwu
	 gSitvu9+nE84wKeI2mzz/q+AsBAGtMBXhyY1z14L3SlZCcFWL4xWP9D4CVufX6I+RtxbI
	 +uj6Fq91W3nQYTftZO1O7ILurvw88TSseNyqVVgocHsuSYmPYkX1l5QUjPbwYFvQv9bB1
	 K5eVYKIw+7dTl2u5XzVAS4wLFLWF/HlWw8FGsADkxx4B5qrzEPynpsH0EySfcoS75Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793953814;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-MTK;
	bh=tjFsiMVo8kskclVrKY52p1ozW8t/WABGAqJnNi55a5M=;
	b=MR8mRoOq3n8Vk0YrJaMcsODqw1j1mwTfbTY8HOA3O3Tn3pIf+M1LqA0ah/h5jGe9aAfd
	 joQ6U1WFH8mlQDuqWCzJjFArTVlFsLb79WrZA7Oh9yPuC0OmVqlmjVH30A7ZON27y8Xks
	 Ta8yCLwKUWMNp+p2C6vksyJL1FuXV3IgLRRN7v+pv3I2rM0nA2gWXDFhvcFdi7dLOjGv6
	 PFzcGU9XdLhFKypz9snPXked79vhKifjcHFxE6bHFBEKEKgkS0IwaO36tMK4NPuseX8XK
	 Cg1FPliq+/J0h1A1AgKZ8MpXW54Jp40NUZzzW+1rSHfPZWkLkm/BmrfOSZCvaphwBqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=fVUGvFDI;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1FD606A32F
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 08:30:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C1FD606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=fVUGvFDI
X-UUID: 477bdcf4d9bc11f18dc8c9802ae25ab1-20261106
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=tjFsiMVo8kskclVrKY52p1ozW8t/WABGAqJnNi55a5M=;
	b=fVUGvFDI3XcoDP4WP3WRR2BruAOB5An7Q1cRz04D6eBCW0Os8aHXhvSiHmUyGz0vKI0Fy4W8pMNSx2vUwENhwnOx5cJxwYT/630+Ndi3fHPBmcuK4GlbwCmZCVFfs5VMC9wAuX/iwhogXO+Nf9DZYYmqC9uLF8uXo9BuM1fXMtc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:85bf6426-1f1d-44db-9675-6355fb755657,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:8895d850-c3c8-4d20-8dd5-7bb1d154dc26,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 477bdcf4d9bc11f18dc8c9802ae25ab1-20261106
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <james-ly.huang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1791327382; Fri, 06 Nov 2026 16:30:10 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 6 Nov 2026 16:30:08 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 6 Nov 2026 16:30:08 +0800
From: James-LY Huang <james-ly.huang@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<sean.wang@mediatek.com>, <jb.tsai@mediatek.com>, <kun.wu@mediatek.com>,
	<James-LY.Huang@mediatek.com>, mtk18285 <james-ly.huang@mediatek.com>
Subject: [PATCH v2 0/9] wifi: mt76: mt7925: make P2P operation robust off-channel
Date: Fri, 6 Nov 2026 16:29:55 +0800
Message-ID: <20261106083004.3156085-1-james-ly.huang@mediatek.com>
X-Mailer: git-send-email 2.45.2
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: mtk18285 <james-ly.huang@mediatek.com>

This series fixes a number of P2P (WiFi Direct) issues seen on mt7925
when a GO or client has to operate or answer on a channel other than
its own operating channel, or while the firmware is busy granting one.

Off-channel traffic breaks in both directions today: frames received
while P2P discovery walks the social channels can carry IEs for
another band than the one they were received on, GO probe responses
and off-channel management TX outlive the ROC window they were
admitted under, and a GO BSS gets programmed without the channel
being requested first, which the firmware rejects.

The series starts a dedicated p2p.c/p2p.h module for the P2P-only
logic, and moves through:

  - RX side: drop P2P management frames received on a foreign
    channel, drop stale GO probe responses after the BSS went away
  - TX side: bound GO probe response and off-channel management TX
    lifetime to the ROC window, send the common scan IEs and size
    the scan request for its IEs
  - ROC: harden the channel-grant handshake, describe the real
    chandef in the requests made to the firmware
  - GO bring-up: request the channel before programming a BSS,
    inject a deauth when the firmware reports an aging-timeout SAP
    event
  - give every P2P interface a BMC wcid of its own

The series has been verified to build against 7.3.0-rc5 as an
out-of-tree module for all PCI/USB chips (mt7603e, mt7615e, mt76x0e/u,
mt76x2e/u, mt7915e, mt7921e/u, mt7925e/u, mt7996e) and passes
scripts/checkpatch.pl with no errors or warnings.

Changes in v2:
  - patch 7/9 (inject the deauth): drop a redundant __packed from
    the synthesized deauth frame, which -Wpacked-not-aligned flags
    in builds that do not suppress the warning; no functional
    change, the struct layout is identical.

Jacobs Wu (1):
  wifi: mt76: mt7925: send the common scan IEs and size the request

james-ly huang (8):
  wifi: mt76: mt7925: drop P2P mgmt frames received on foreign channel
  wifi: mt76: mt7925: bound P2P off-channel mgmt TX lifetime
  wifi: mt76: mt7925: give every P2P interface a BMC wcid of its own
  wifi: mt76: mt7925: harden the ROC channel-grant handshake
  wifi: mt76: mt7925: describe the real chandef in ROC requests
  wifi: mt76: mt7925: request the channel before programming a GO BSS
  wifi: mt76: mt7925: inject the deauth for an aging-timeout SAP event
  wifi: mt76: mt7925: track BSS absence and drop stale GO probe
    responses

 drivers/net/wireless/mediatek/mt76/mt76.h     |   1 +
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  |   3 +-
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |   2 +
 .../wireless/mediatek/mt76/mt7925/Makefile    |   2 +-
 .../net/wireless/mediatek/mt76/mt7925/init.c  |   5 +
 .../net/wireless/mediatek/mt76/mt7925/mac.c   |  12 +
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 189 ++++-
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 220 ++++--
 .../net/wireless/mediatek/mt76/mt7925/mt7925.h |   29 +-
 .../net/wireless/mediatek/mt76/mt7925/p2p.c   | 702 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/p2p.h   |   93 +++
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  28 +
 drivers/net/wireless/mediatek/mt76/mt792x_core.c |  27 +
 13 files changed, 1256 insertions(+), 57 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/p2p.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7925/p2p.h

--
2.45.2

