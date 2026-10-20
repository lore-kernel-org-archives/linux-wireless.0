Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792466533;
	b=CG3+lKD7FBK94T3eZSqUeAO+6TkBk+ygq6cRQ7OtkiePst4Oc2kdUSlgK0ZW/ozVK4p0
	 HELYYO/FAqu+1U2NwnSl3Fjw2JcXYlyIcwZH0IgfDKjsjLfrqPzthJB1D22DRjv0OfeA5
	 835onfYJQhJPEEO42xTo3m4wusYQto76c3Z/u20E4je8kyBzXqpMudb0QzOVoKBNmWyYm
	 Auzb4vaBDNfKiGZVm+IRRmVwmCgqRO2J84tMW4iR4x/NQ8qftk8tR7rRbyN7kTjYnaxbv
	 DVcNYZ7Q+L+qMSzQyGfWbVuMY7J3CuvdiFdZKIHdYHqsR09UUx0NVhPSxnYW/wM4vIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792466533;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:Received:From:To:CC:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:Content-Type:X-MTK;
	bh=vzB8bOhRMVsM/l3vKVMzGaagbjzIcswgNfzTUtBt8JA=;
	b=Ukr5hH+KIbCZVxGGlCx1FqzZwDT4WAgfnYtXMkKMVYYXnikAwxb/hqnqHiXZXQFkAJT9
	 y1WuiwR5DDgPw1b5FRlDp3c4+tuYRHAM5qCZpoic1iNoo584vtYLlH7q44x+shyza1rN2
	 7yYBROEM0AntDQUF9nRnzL6VvieHVQ65nB6wugCY1RBVnL5o8W2ycUDDfXf45WkfuSJdX
	 ZCgRrjTfx5Ka+PfMg5WOUrGltyylhUYM9/OcSTiDjyw2MVNhmtE5GfSoPjGdW9+PzXZ4a
	 IM7szXDI+abVRDrmsD7QXHLWZDeUpQdxWjZjBbVlxtaVlxuyOOd1YCSG7p8SvJBm5dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=qkQYZz5B;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F59606A31B
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 03:22:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A4F59606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=qkQYZz5B
X-UUID: 6c617856cc3511f18dc8c9802ae25ab1-20261020
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=vzB8bOhRMVsM/l3vKVMzGaagbjzIcswgNfzTUtBt8JA=;
	b=qkQYZz5BJmSVVTp2oiQXEZnQcneG1KC6+Uxm1T5ic/mpLSo1g4kfw4KlfUQUlBp5XOGIrvbbgbQgotbJuBnqh9RJz2ljNC0CExTb17hH+856O1avhvei5rA4Aq9RE8u2IFrr1FSvRCWaMwPj45KLuJVbi61VX0miHDdwen4ArqI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:012f7e6e-ebdb-4bde-af18-1c9f9a44991d,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:291e20b,CLOUDID:b6479c69-07af-4b28-8d80-56e9e7a260a7,B
	ulkID:nil,BulkQuantity:0,SF:102|123|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6c617856cc3511f18dc8c9802ae25ab1-20261020
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <mtk10484@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2109566017; Tue, 20 Oct 2026 11:22:04 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 20 Oct 2026 11:22:04 +0800
Received: from mediatek.com (10.233.130.16) by mtkmbs13n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.2562.29 via Frontend
 Transport; Tue, 20 Oct 2026 11:22:04 +0800
Received: by mediatek.com (Postfix, from userid 10010484)
	id 15E37200C5; Tue, 20 Oct 2026 11:22:04 +0800 (CST)
From: <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Leon.Yen@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.lee@mediatek.com>, <Sean.Wang@mediatek.com>,
	<emery.hsin@mediatek.com>, <jb.tsai@mediatek.com>, <kun.wu@mediatek.com>,
	<linux-mediatek@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<litien.chang@mediatek.com>, Anthony Liu <anthony.liu@mediatek.com>, kernel
 test robot <lkp@intel.com>, Dan Carpenter <error27@gmail.com>
Subject: [PATCH] mt76: fix buffer overrun in pkt buffer
Date: Tue, 20 Oct 2026 11:22:00 +0800
Message-ID: <20261020032201.568970-1-anthony.liu@mediatek.com>
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
