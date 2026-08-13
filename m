Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5977C43C047
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 08:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611020; cv=none; b=UwOJ6gdkBeezTeMxkYsV9/T40mx3Z/s+VpQHU13k7aT1NFGAEL+FMZ5TpSgb40zhDGU+D8AkEqB10V00GjxpwtpMD1SYziPfbcuhb6VHBWZjie75yTHPXvdymE4zc44ksdZjBqO0pawahBxanmiBCXVjxfmeu9wBsUKF/eqwk4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611020; c=relaxed/simple;
	bh=+gslsG4bUmOGPru+1tx240C28r9IK3+X0GXk245Eykw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OIId9RTNgAx39qlYJVdiUIYZsJM+p1Vf+a7WuMJhIVypBaBQEvoD7OS2XmC96jhXkl0eTez9oKoMOq28Iomub0Qc/uNCKgq1A88Lp8WZkLtK3UMuTzBhdyNpPvZ8L127tYhsWy8w3jt5xa4n8vPg3tmhan1O54kFuw55FnlH6IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=PvOl19lL; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="PvOl19lL"
X-UUID: f9ebba3296f311f1b1788b6acf885367-20260813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=pNIT/tNOK9sW/rcuT+Bg8F67Y7BjyxTyHyIw82ypq+c=;
	b=PvOl19lLbSElced3PXyatwSOdvFDEIv1tbE0lYfmL4LyfWtxDDOeGwyp14ekbKcrtmz77N8DAxVusd6OiBe0ViIaLJnP1nnCyMQNzOE3otttLcIKqP/c1jYcEfndKf2myHj0mRnebIEC8mirkzQ2cxc+0A2Mc5DqzzpSi9YlI6Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:9bbe4dd2-1f69-4f1e-ae6d-322b274506fa,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:edfc6ee2-71f1-405e-92eb-6802d6af74fd,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f9ebba3296f311f1b1788b6acf885367-20260813
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1287873758; Thu, 13 Aug 2026 16:50:03 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 13 Aug 2026 16:50:02 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 13 Aug 2026 16:50:02 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Tony-TC.Lee@mediatek.com>,
	<jb.tsai@mediatek.com>, Tony-TC Lee <tony-tc.lee@mediatek.com>
Subject: [PATCH 1/3] wifi: mt76: mt7925: zero the whole testmode command buffer
Date: Thu, 13 Aug 2026 16:49:59 +0800
Message-ID: <20260813085001.1927426-1-jb.tsai@mediatek.com>
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

From: Tony-TC Lee <tony-tc.lee@mediatek.com>

pcmd is declared char *, so sizeof(*pcmd) is 1 and the memset clears a
single byte rather than struct mt7925_rftest_cmd. Everything the memcpy
that follows does not overwrite - padding[1..3] - reaches the firmware
as uninitialised stack content.

Use a correctly typed pointer, as mt7925_tm_set() already does, so
sizeof(*pcmd) covers the whole command. Addressing ctrl by name rather
than by a hand-computed +4 offset comes with it and is not optional:
pcmd + 4 on a struct pointer would advance by four whole structures.

Fixes: 0a41b6751e4f ("wifi: mt76: mt7925: add test mode support")
Signed-off-by: Tony-TC Lee <tony-tc.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/testmode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
index 22a8f1ddc321..6ff261dfeedd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
@@ -88,12 +88,12 @@ mt7925_tm_query(struct mt792x_dev *dev, struct mt7925_tm_cmd *req,
 		char *evt_resp)
 {
 	struct mt7925_rftest_cmd cmd;
-	char *pcmd = (char *)&cmd;
+	struct mt7925_rftest_cmd *pcmd = &cmd;
 	struct sk_buff *skb = NULL;
 	int ret = 1;
 
 	memset(pcmd, 0, sizeof(*pcmd));
-	memcpy(pcmd + 4, (char *)&req->c, sizeof(struct uni_cmd_testmode_ctrl));
+	memcpy(&pcmd->ctrl, &req->c, sizeof(struct uni_cmd_testmode_ctrl));
 
 	if (*((uint16_t *)req->padding) == MCU_UNI_CMD_TESTMODE_CTRL)
 		ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_UNI_QUERY(TESTMODE_CTRL),
-- 
2.45.2

