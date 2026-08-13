Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DE038333C
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 08:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611023; cv=none; b=lhEfYBTUziBlO3o9AWmZ1XhkXDpjiywqiDXHm1f43baKYcGDoXa5uI19j2LIQ5CLh+4pZDYimkxaPNdHeufW8i5npaPBqVWo/+/N3B8IiiOCsyitUJtZ2X7Hu5fzLt5C7rscjdjjVjWzFtIr+ZLhI5izVVa0Dnjo83ETKUmyl84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611023; c=relaxed/simple;
	bh=5WL2eEcyR6iWTbQkF5u7KbRLI6Rbu1dpGM/fJb7jZEc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MuuYh5q6WFTcSibBBbxj3k/+H1k+YxzphNHa3KL8J3a5ApzM5/aY0FpZp1By9raHcr9Vz6BBdfxK56q70SnjXPLeXVMSlTVJBiaY8EyVyPjOEqNLTWAU+bPL736z3YLxUIFW8lJT18jviBPUWHwgmc6Z6wfsJOQbtlF5vowRDDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VfbAV+yr; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VfbAV+yr"
X-UUID: fb3636f696f311f1b1788b6acf885367-20260813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=eYOnRr3mn+TrX0E7QTTOqKUlGuBSIH8SKZRatU/uMlg=;
	b=VfbAV+yr69nhjVJlFFYorLw6GkHP+aSrFKbHPr4OZhn1ldWdyGTyOM6rrASqmiZo/So+vLPTcaIvZuTSok7riFXL7+qFvTQPA4cEqtUIlY+UxeJSYQ5jSDNSwth532V3iHDb+c4N2QhX9lZRl7lAcNIGChZF44Snj7qsfKSEw1k=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:56e8cd40-2e77-4fe8-bf9e-3d56af899aaf,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:63644541-051c-4757-9871-8fe24bc417f4,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: fb3636f696f311f1b1788b6acf885367-20260813
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1159819922; Thu, 13 Aug 2026 16:50:06 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 13 Aug 2026 16:50:05 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 13 Aug 2026 16:50:05 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Tony-TC.Lee@mediatek.com>,
	<jb.tsai@mediatek.com>, Tony-TC Lee <tony-tc.lee@mediatek.com>
Subject: [PATCH 3/3] wifi: mt76: mt7925: accept testmode replies shorter than the buffer
Date: Thu, 13 Aug 2026 16:50:01 +0800
Message-ID: <20260813085001.1927426-3-jb.tsai@mediatek.com>
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

The length check guarding the memcpy requires every event to carry a
full MT7925_EVT_RSP_LEN (512) byte payload. That suits
MCU_UNI_QUERY(TESTMODE_RX_STAT), whose reply is described by
union testmode_evt, but a MCU_UNI_QUERY(TESTMODE_CTRL) reply - an AT
command read - is laid out as struct uni_cmd_testmode_ctrl: an 8 byte
header followed by a union testmode_data of 84 bytes, 92 in total.
Measured on MT7925, cid 0x0046 answers with skb->len = 92, so every RF
test read fails with -EINVAL even though the firmware answered
correctly. The failure is invisible from userspace: a dump ending in an
error carries it in the NLMSG_DONE payload, which netlink libraries
routinely discard, so it looks like an empty reply.

Keep the over-read fixed, but step over the header with skb_pull() so
the bounds check and the advance are one operation and the offset comes
from offsetof() rather than a literal, then copy whatever payload did
arrive. Zero evt_resp at its declaration in the caller, which owns it
and hands it to userspace at full MT7925_EVT_RSP_LEN however much the
firmware sent, so the part left unfilled cannot leak stack content.

Fixes: c7369a00860a ("wifi: mt76: mt7925: validate skb length in testmode query")
Signed-off-by: Tony-TC Lee <tony-tc.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/testmode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
index bf9516bc7bd1..dbf1159effeb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/testmode.c
@@ -87,6 +87,7 @@ static int
 mt7925_tm_query(struct mt792x_dev *dev, struct mt7925_tm_cmd *req,
 		char *evt_resp)
 {
+	const unsigned int hdr = offsetof(struct uni_cmd_testmode_ctrl, data);
 	struct mt7925_rftest_cmd cmd;
 	struct mt7925_rftest_cmd *pcmd = &cmd;
 	struct sk_buff *skb = NULL;
@@ -107,12 +108,12 @@ mt7925_tm_query(struct mt792x_dev *dev, struct mt7925_tm_cmd *req,
 	if (ret)
 		goto out;
 
-	if (skb->len < MT7925_EVT_RSP_LEN + 8) {
+	if (!skb_pull(skb, hdr)) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	memcpy((char *)evt_resp, (char *)skb->data + 8, MT7925_EVT_RSP_LEN);
+	memcpy(evt_resp, skb->data, min_t(u32, skb->len, MT7925_EVT_RSP_LEN));
 
 out:
 	dev_kfree_skb(skb);
@@ -192,7 +193,7 @@ int mt7925_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *msg,
 
 		data = drv_tb[MT7925_TM_ATTR_QUERY];
 		if (data) {
-			char evt_resp[MT7925_EVT_RSP_LEN];
+			char evt_resp[MT7925_EVT_RSP_LEN] = {};
 
 			err = mt7925_tm_query(phy->dev, nla_data(data),
 					      evt_resp);
-- 
2.45.2

