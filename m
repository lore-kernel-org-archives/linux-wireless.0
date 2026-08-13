Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6730038DC47
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 08:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611023; cv=none; b=jPzTwEtN3iz85RKErLxevlMwCzDqN+rtQkCzV6eVsJNedepIcc6QpuD1Y0+AaLbIpKzaBBxA0kG77+G6MwXsx88OvQBq9a+LT1+zW5r1J1fm5tzYwuhmg0MlpfGwadn4zXuLf5SULBOWiVwydg7nqVf0P5FKDEvMlPlJPEvzeLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611023; c=relaxed/simple;
	bh=Kh8Amgvm866yconF250mVeSQ9UsYdlgOFui/4YWHXGc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DaGoQOQ8FPqAxHS1irPR2zCk4OUDfdyHTYPOXSx30KQIvvmmyfsd7Vj2xWYykyYdl3I3im+AeJcgNcuoJU3QiAs352AE41E9tg8jUZKZ8v2fIPLRrwsD1A2ZSTL4lqDsdU7gvBwAaDDf/OfUeyWIlCOnrAKXNRcxqFS98Iyem54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=lP4bzoxi; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="lP4bzoxi"
X-UUID: fa9303dc96f311f18dc8c9802ae25ab1-20260813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=f9a1oE+xZzthJ4yfyqZ4rZ0cQw4Jw7Q4c7EYOaL87J0=;
	b=lP4bzoximNi/ZRiS6TngHXmCMqkvMATDryw36NamjWGAHUdhk6csa7o/slry13tfOoCxeAb9fXKSmVaansHmnDpbDiq0Zgg6pKAt3rSzfHtTTwVyQJ6soT3f3/ZFCSqc1VMdKpvnA/S4KT33Y7sESYVUBT5w5dHCaALo9ApI7uQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ef8da0bf-e537-4113-a3b8-68b5828bc79a,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:e661f6a7-8a7b-4c49-a0c0-42d13e7adac0,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|136|836|865|888|898,TC:-5,Content:0|
	15|50|99,EDM:-3|-100,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fa9303dc96f311f18dc8c9802ae25ab1-20260813
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1319884839; Thu, 13 Aug 2026 16:50:05 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 13 Aug 2026 16:50:03 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 13 Aug 2026 16:50:03 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Tony-TC.Lee@mediatek.com>,
	<jb.tsai@mediatek.com>, Tony-TC Lee <tony-tc.lee@mediatek.com>
Subject: [PATCH 2/3] wifi: mt76: mt7925: report an error for an unknown testmode query id
Date: Thu, 13 Aug 2026 16:50:00 +0800
Message-ID: <20260813085001.1927426-2-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260813085001.1927426-1-jb.tsai@mediatek.com>
References: <20260813085001.1927426-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Tony-TC Lee <tony-tc.lee@mediatek.com>

ret is preseeded with 1, so a padding[0..1] matching neither
MCU_UNI_CMD_TESTMODE_CTRL nor MCU_UNI_CMD_TESTMODE_RX_STAT falls through
both branches and leaves it at 1. mt7925_testmode_dump() returns that to
netlink_dump(), where a positive value means "more data follows", so the
dump is held open and retried rather than failing.

Answer -EINVAL for an id that is neither, and drop the initialiser now
that every path assigns ret, which also lets the compiler check that.

Fixes: 0a41b6751e4f ("wifi: mt76: mt7925: add test mode support")
Signed-off-by: Tony-TC Lee <tony-tc.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/testmode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
index 6ff261dfeedd..bf9516bc7bd1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
@@ -90,7 +90,7 @@ mt7925_tm_query(struct mt792x_dev *dev, struct mt7925_tm_cmd *req,
 	struct mt7925_rftest_cmd cmd;
 	struct mt7925_rftest_cmd *pcmd = &cmd;
 	struct sk_buff *skb = NULL;
-	int ret = 1;
+	int ret;
 
 	memset(pcmd, 0, sizeof(*pcmd));
 	memcpy(&pcmd->ctrl, &req->c, sizeof(struct uni_cmd_testmode_ctrl));
@@ -101,6 +101,8 @@ mt7925_tm_query(struct mt792x_dev *dev, struct mt7925_tm_cmd *req,
 	else if (*((uint16_t *)req->padding) == MCU_UNI_CMD_TESTMODE_RX_STAT)
 		ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_UNI_QUERY(TESTMODE_RX_STAT),
 						&cmd, sizeof(cmd), true, &skb);
+	else
+		ret = -EINVAL;
 
 	if (ret)
 		goto out;
-- 
2.45.2

