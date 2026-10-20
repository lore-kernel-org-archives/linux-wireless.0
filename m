Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792475529;
	b=NLMCUB6ZAQ8vDI3LoQyO7VTOmk9wIaB1d6/9tN2zSNMEbg6lbNrMKK9fN5N8+d6R5toE
	 psJgpMk+6DqL/QHc4nOr2IkXzpKbw9KCVAiLFGwhdju9eCje6vK/v1xrRpYqe9BIf7ZmC
	 2K1US+cwbnXMJJaJZamMNpEK2LWpdaI9HSAwmYSRQCOXn1L67kVKPQIOS84JfSqXXpakS
	 wqTyTq4sBYJ/LiJ3X4ThofO4ZYwDvfvpb2ZP9ivdQUBwNBM5C2jG6aNzolmPCRTozGA45
	 oob31WQmhoYSvlcCXhwoPe7Hz+hrU2kTlvaNqbN76vQ/2YKqEGc8dyouL0vMpbfd3SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792475529;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Received:From:To:CC:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:Content-Type:X-MTK;
	bh=lwMfD33O/UCpOPSaaljyLp+k79x3VcyaXaZXjd7PWXg=;
	b=R1v+u44Awg/Q1qxj9sFGeSLB5uvyIiuwStj46QqpCFw9UdUYYJfGEGyvKPecPrTL/T76
	 DNHQ/2TJyWZAMjJvu0SrWXAk4O9q2bD0Kg152KqYaUNcZua8Dte94Um42hZNoSMRrQ10Y
	 oxqHWaHZM53bnsooFaD8M90SCNb7ziUbVCCnivhnVYnJDgpvN90J5+ldzkQxv5C7cJt0Q
	 OCsLaPamhQb600lEw8pUB2ZThcGg6O8/DdNJOsICTrFCEsGrATlPcE+zhO+eQwonlSNOM
	 aWkPSikzx7MDSl6JtM5pGRBMrCo/7YGQDfcR1f+0BlK0bXs2fSoTTDXZr8aHu0Gtrvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=lDvN09eF;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E306606A319
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 05:52:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7E306606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=lDvN09eF
X-UUID: 5ea057fecc4a11f1b1788b6acf885367-20261020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=lwMfD33O/UCpOPSaaljyLp+k79x3VcyaXaZXjd7PWXg=;
	b=lDvN09eFJ+xhosKu248qyiMdcFU2NH6JHC4LnLP0ZFlI/Lr12IxBqIkyUPIf4hcLQ/KKT5FWMnezLp123iqLAD+7wKbJf8Q5quIKkT58em0hw74ScWSadbFDLN2nLTo8J3Zr3uVc0IzJ1+xuI5C998z9R/xXKBi56gX2Wc47Qqk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:98579560-ceaf-462d-81fd-9db15c7ecbed,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:291e20b,CLOUDID:9d399e52-f045-4ad1-9cb8-676649b6821d,B
	ulkID:nil,BulkQuantity:0,SF:102|123|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5ea057fecc4a11f1b1788b6acf885367-20261020
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <mtk10484@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1476715558; Tue, 20 Oct 2026 13:52:01 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 20 Oct 2026 13:51:59 +0800
Received: from mediatek.com (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 20 Oct 2026 13:51:59 +0800
Received: by mediatek.com (Postfix, from userid 10010484)
	id E6C61200C5; Tue, 20 Oct 2026 13:51:59 +0800 (CST)
From: <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Leon.Yen@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.lee@mediatek.com>, <Sean.Wang@mediatek.com>,
	<emery.hsin@mediatek.com>, <jb.tsai@mediatek.com>, <kun.wu@mediatek.com>,
	<linux-mediatek@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<litien.chang@mediatek.com>, Anthony Liu <anthony.liu@mediatek.com>, kernel
 test robot <lkp@intel.com>, Dan Carpenter <error27@gmail.com>
Subject: [PATCH v1] mt76: fix buffer overrun in pkt buffer
Date: Tue, 20 Oct 2026 13:51:58 +0800
Message-ID: <20261020055158.621615-1-anthony.liu@mediatek.com>
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

From: Anthony Liu <anthony.liu@mediatek.com>

The last patch (d4e5ca3483a0) addresses mt7928 F/W 4 byte-aligment
requirement by reducing pkt buffer by 2 bytes, causing the chance
of buffer overrun.

This patch reduces incoming skb length limit accordingly.

Fixes: d4e5ca3483a0 ("wifi: mt76: mt7928: makes struct beacon_tlv 4-byte aligned.")
Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202610172141.mmRmGqow-lkp@intel.com/
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 26cdb3f0a98a..131585b3359d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2479,7 +2479,7 @@ mt7925_mcu_uni_add_beacon_offload(struct mt792x_dev *dev,
 		return -EINVAL;
 	}
 
-	if (skb->len > 512) {
+	if (skb->len > 510) {
 		dev_err(dev->mt76.dev, "beacon size limit exceed\n");
 		dev_kfree_skb(skb);
 		return -EINVAL;
-- 
2.53.0

