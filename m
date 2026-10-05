Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D643C9880
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 08:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189121; cv=none; b=BxwiOsXb2cdA5xpS/EcKPvrMSlVD0MkGQX700/B5lyNcgoYxa/+7tZR2OU6RKPLMDBq5aog8qVG0v0e9b7uiR8pfSR1aLfihRj+SERs30poIry6/nrMqea1ti7GFjrwpLge9ni1EoQKBxqsFDhvC+OVsLNlA+7ltW7ASbASu45U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189121; c=relaxed/simple;
	bh=Yom26i+bHKMHZsJ7KtA4YjRtFxhjChIbeP/SGucb9rM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=goOrfPitgEQBdi7bNmhPUV2wuzkzLLmZcLz5ZGlUGhVeaEuh87cY4GC0pTKK3lhLQl9WIoBLbbPD54T8CeWVewHk9jJ7NY2nJnHvTr+yiaop5VL6aI3hOOP6ZO6ESSfuRfD11ZiP68Ed/cd7fAVM3sRmObS2AD/H0sRfIYZcG8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gw4qfBL5; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gw4qfBL5"
X-UUID: 31d1cb22c09711f1b1788b6acf885367-20261005
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=ZpEvfrOsnzxI0Usk6ogp8zsWy48ijEzIpAKQBgY7nB8=;
	b=gw4qfBL59EbyaB5Ntx9htrNZMQEjymHihFj/l9otIRJGep48No7VopN8zy6eq0VpmeDe7Q7/1afMg+4ZsmXhxoxHBvnaCy1aFj3X1vCIluPFnYK1j5HpYlppFg5k2WOOOyJh6AqjthvFh+AG9JqbT0sQcxPK3dtudArfMUEYNt8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:199872b9-2d74-4022-adb7-dc0e0e5dd045,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:02133ef2-e4ea-449d-852e-8cc3f93cc1bb,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 31d1cb22c09711f1b1788b6acf885367-20261005
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1746189951; Mon, 05 Oct 2026 16:31:43 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Oct 2026 16:31:42 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 5 Oct 2026 16:31:42 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH v4 0/5] mt76: optimize mt7922/mt7928 T-put per Tx/Rx stats
Date: Mon, 5 Oct 2026 16:31:40 +0800
Message-ID: <20261005083140.104609-1-anthony.liu@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

This series adds:
1. Read the HW charactistics flag from ACPI BIOS.
2. If the HW needs, collect and update Tx/Rx statistics to FW.
3. FW can then decide how to adjust PCIe link to improve T-put.

Anthony Liu (5):
  [PATCH 01/05] wifi: mt76: refactor chip_config to accept generic
    commands
  [PATCH 02/05] wifi: mt76: refactor chip_cfg commands to be a generic
    API
  [PATCH 03/05] wifi: mt76: add ACPI MTFG option for bus configuration
  [PATCH 04/05] wifi: mt76: add PCIe speed tuning for mt7922/mt7928
  [PATCH 05/05] wifi: mt76: mt7922/mt7928: send Tx/Rx statistics to FW
    for link tuning

 .../wireless/mediatek/mt76/mt7615/debugfs.c   |   2 +-
 .../wireless/mediatek/mt76/mt76_connac_mcu.c  |  54 ++++-
 .../wireless/mediatek/mt76/mt76_connac_mcu.h  |  60 ++++-
 .../wireless/mediatek/mt76/mt7921/debugfs.c   |  38 +++-
 .../net/wireless/mediatek/mt76/mt7921/init.c  |   5 +
 .../net/wireless/mediatek/mt76/mt7921/mac.c   |   4 +
 .../net/wireless/mediatek/mt76/mt7921/main.c  |   2 +
 .../net/wireless/mediatek/mt76/mt7921/pci.c   |   8 +
 .../wireless/mediatek/mt76/mt7921/pci_mac.c   |   8 +
 .../wireless/mediatek/mt76/mt7925/debugfs.c   |  47 +++-
 .../net/wireless/mediatek/mt76/mt7925/init.c  |   2 +
 .../net/wireless/mediatek/mt76/mt7925/mac.c   |   4 +
 .../net/wireless/mediatek/mt76/mt7925/main.c  |   4 +
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt7925/mcu.h   |   1 -
 .../net/wireless/mediatek/mt76/mt7925/pci.c   |  14 ++
 .../wireless/mediatek/mt76/mt7925/pci_mac.c   |   8 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |  57 +++++
 .../wireless/mediatek/mt76/mt792x_acpi_sar.c  |   1 +
 .../net/wireless/mediatek/mt76/mt792x_core.c  | 211 ++++++++++++++++++
 20 files changed, 526 insertions(+), 10 deletions(-)


base-commit: 86b8d5b18d9712ae0001f078d1893c2dceac0bdb
-- 
2.45.2
---
V3 -> V4: Add cover letter, fix crash (misuse of deflink) in mt792x_perf_account_rx().
V2 -> V3: Remove Gerrit-only: Change-Id.
V1 -> V2: Remove not needed lines copied from internal commits.

