Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D558632B
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 09:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785921943; cv=none; b=UK8cyDNTh2mFOjdGBF4a3AAUmF/ZThMgsZqgsFr9gncT9JOSMSD07CJJw9xWT3L6ywwwqwSIqGa7Qpo/0HlixcWhbQ5qiZm0ur37TFDPa6LMydtxregmQo0RiONIF/3SJ7JABtZytooZe9885HCM6vWLbxdLGxpqzqcgbvM7Buc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785921943; c=relaxed/simple;
	bh=kuNk8LmjYHLI1cNSHGBBkkldEG7G6rna/ffvQrO0dAk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cSJRc3Ev+oL25BOsEsps/2gQCTMLM9chYr9Ny2NiStcFtRfaRu/FqX5bhuZjXEGrBWEBL1Wb95294ebPH15AXGOUd7HfOjPhzi7AgNKwk/GJsyK7tgShvkXe2+D9mU4q+iYsxdp35g23ep+Tj7gHYAiCaNNzgWSfwKo67tIia6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=KnHpePGX; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KnHpePGX"
X-UUID: 9ca8deee90af11f1b1788b6acf885367-20260805
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=yzil/Mlf3ePuxeRuT5OEh2LZy0rHiWskGCYU7Mq6F4o=;
	b=KnHpePGXcyZcamOUwQfzcxzCE/BNS4/HmtbFoEg6x9+w4eYZd24CUN8La8l4aBQHqHvp6N6Q20pn0jusDcCq9i+8A1P2SJMIIB0lnwVKQjOGcc11axH5mW0bP38iOWc1+gDaZjWwYjO8FI9AFLavPXj1sMHNIk05q1FyDczLCJQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:dcb0db8a-4520-45a2-85c7-e696037ac74c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:b8e9aea7-8a7b-4c49-a0c0-42d13e7adac0,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9ca8deee90af11f1b1788b6acf885367-20260805
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2077732410; Wed, 05 Aug 2026 17:25:34 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 5 Aug 2026 17:25:33 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 5 Aug 2026 17:25:33 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <ck.chang@mediatek.com>,
	<eason.lai@mediatek.com>
Subject: [PATCH v1 0/2] wifi: mt76: mt7925: Fix coredump issue and add coredump end collect mechanism
Date: Wed, 5 Aug 2026 17:25:29 +0800
Message-ID: <20260805092531.1490746-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: "ck.chang" <ck.chang@mediatek.com>

This series fix coredump file size not enough issue, and add coredump end collect mechanism

ck.chang (2):
  wifi: mt76: mt7925: Fix coredump size not enough issue
  wifi: mt76: mt7925: Add coredump end collect mechanism

 .../net/wireless/mediatek/mt76/mt76_connac.h  |  1 +
 .../net/wireless/mediatek/mt76/mt7925/mac.c   | 52 +++++++++++++------
 .../net/wireless/mediatek/mt76/mt7925/mcu.c   | 10 +++-
 3 files changed, 47 insertions(+), 16 deletions(-)

-- 
2.45.2

