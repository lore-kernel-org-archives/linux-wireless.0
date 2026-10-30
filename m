Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=60.244.123.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793351180;
	b=ZP3xaiEPWOa5BsU2JEMJ45nTvsD1Ji57N7KybdpR2TDqczxXUp0yKIEmAzW9wTCtzbpw
	 BIx1W4I7AvI41Sjsj5gh/IBcyxLl2bKZkucFNpJNYKXrE7wDEo10aOWn9JKXlKG3LeiLr
	 6heavFKXAyA0v403cKqu1o7fX2jNNIipfuSaWBZIt/o3M+WSimhSHiB/H8nfCJYLiCvPN
	 ts+bgP1rQhUPvA+eN56xwEeHvs+ptATEYsF0hDJ+nm1l0lik/cHoXv0DdYVrxRmJnu/8R
	 +3RJVSOgnctDQsEGZ+p6aPmUtWh9K5GUTp8Aap34nBugjudptLnRBNDnf15ykNdlvfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793351180;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-MTK;
	bh=allCNmaFVJOkun0guf6atPUY8ZdWYZb9ohX7ldq5iAo=;
	b=CHxRie8GfzGMpwTxot1ocw4F4SXvayqUBqWS0I31fAl7cEaRy6ydRzQE7qFZbFXyKyXI
	 KySJ7J4DYqvaC+TFAu7GDuMPTCfdtA4sKFjELyQG9gEG213BavWixOZEkzwpiaR9KjT77
	 CDuevO+LH5zvq5Z5k0a0/WgiDmv8qLdBf36WsGd7L62uJi2PfRYXX5a/ppF94ZwsrpPy0
	 zAPdXLbdnafqDzT/ANLUQzVOIh/DW/NLOw6vOfLy5W28zHJQlDUjjEcJdc5tXsQKeMcll
	 BXPJXgO6IbU57QNLBuHyroyBPjclmdPjJTPzg0cOPq5h6IY/qN+iAEmPjt9jHoDiWSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=tEhn0zt2;
	arc=none smtp.remote-ip=60.244.123.138
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5305F606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 09:06:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5305F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=tEhn0zt2
X-UUID: 27e7b564d44111f1b1788b6acf885367-20261030
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=allCNmaFVJOkun0guf6atPUY8ZdWYZb9ohX7ldq5iAo=;
	b=tEhn0zt2/G3cJZkY1eLS5WMNbOazQPG+oWaaLJWAkADRUfgV9FLud2+nj5SHFv8nOkEiXdZ+9l/SNeS3s4hepaltnATvvq8NMpoN8hq9iQXMhXz6nUOpNgF1RLewl4aszQILUQs/FGBm/gMkNF/r1jV6taxgPPtuHa/8qAEdvLQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:459bc8ee-112c-4f53-a5eb-0957bd4a46e0,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:b0318ac,CLOUDID:626c98ce-02bc-447e-ab88-2baec399874a,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:99|1,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI
	:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 27e7b564d44111f1b1788b6acf885367-20261030
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 560621230; Fri, 30 Oct 2026 17:06:13 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 30 Oct 2026 17:06:12 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 30 Oct 2026 17:06:12 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-arm-kernel@lists.infradead.org>,
	<ingyujang25@korea.ac.kr>, <shayne.chen@mediatek.com>,
	<angelogioacchino.delregno@collabora.com>, <lucid_duck@justthetip.ca>,
	<matthias.bgg@gmail.com>, <eason.lai@mediatek.com>,
	<linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	Anthony Liu <anthony.liu@mediatek.com>, kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH v2] mt76: fix buffer overrun in pkt buffer
Date: Fri, 30 Oct 2026 17:05:54 +0800
Message-ID: <bb9c40516e7379bf763b1ba7cec228c354494223.1793351111.git.anthony.liu@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <auQjsDPP1PeJg5sV@stanley.mountain>
References: <auQjsDPP1PeJg5sV@stanley.mountain>
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

The last patch (d4e5ca3483a0) addresses mt7928 F/W 4 byte-aligment
requirement by reducing pkt buffer by 2 bytes, causing the chance
of buffer overrun.

This patch reduces incoming skb length limit accordingly.

Fixes: d4e5ca3483a0 ("wifi: mt76: mt7928: makes struct beacon_tlv 4-byte aligned.")
Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202610172141.mmRmGqow-lkp@intel.com/
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 50f5f57b740e..37aeccb28efb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2537,7 +2537,7 @@ mt7925_mcu_uni_add_beacon_offload(struct mt792x_dev *dev,
 		return -EINVAL;
 	}
 
-	if (skb->len > 512) {
+	if (skb->len > sizeof(req.beacon_tlv.pkt)) {
 		dev_err(dev->mt76.dev, "beacon size limit exceed\n");
 		dev_kfree_skb(skb);
 		return -EINVAL;
-- 
2.45.2

