Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793152639;
	b=Un1/V/6eoJq0fmcNq88r6zBlALw4QaUOWJ27AWrS1k5+yP23f6YDlAO3NUXGA+4WWd3z
	 9OW4D6lri1dwUir2DkRxAtwllBToy00tByAqW7KsCjT9zqROhEw0Of4AoiscE4/eZcZqm
	 j5a1p2Du1nYIHz+7yonWyyGB3NYnorxaknChoxGVuB8phqV9IMwepYC8q/CNo+A0FzI47
	 VX15Qk58EOQ1MhTqYrjESWCKYTBKrqXR0x7XtYV0ynpCtYLQ+ePpRC6uYxGlbJSWRzpbn
	 cd/7t2/5195A78VB65XYIN2ClgTN1rte55jIj6exGk6tKcMUZ5P82CwNa4HnFclUCPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793152639;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:Content-Type;
	bh=iQ/pzyfu6F1FUV/I3BMrou23p3S0m7NUJAnaI6wqWf8=;
	b=rZQw6xVAtcSolfAXWAhvTNvM4mEuyzUjALqPdcMUpsMc28XAJvdbDNiTkG6FvxtuCl5N
	 1jK+tSXx5LPFU5bx1B/BzrYgewZXcia0MIuqe708m2qNlG6N0qU5L3UnVIn2VI+nue0kG
	 qoXeszvmljZpPRr49tPKLH9cB3pXgLTUT6jNpe9jdncG37yD73/r/1pp54FuC5VDSjOuY
	 la+dKLGq/qwWVLvoGA6aq6E5+YeIVVS7I6S6B7WJCjdx+MeemiV9WCmQKpfuj3A6G52Rw
	 R61q0Y2hB2PSbzuEclt6i2nKpWJDY5x1cVtNKY0v7T1GXf0e2DCL6yOixXP1l744rKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=B0BsWC8P;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D32606A31A
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 01:57:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68D32606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=B0BsWC8P
X-UUID: e33b6cd2d27211f18dc8c9802ae25ab1-20261028
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=iQ/pzyfu6F1FUV/I3BMrou23p3S0m7NUJAnaI6wqWf8=;
	b=B0BsWC8PfaRmbfe2aXJYcz/glg6szGNyRyyEdTZa8LamIeiPxWnqP2YHosOVdKaGMny8F/DPA+CYZGsaoq66GnkgJylEkcCmAJub9dlOkcRzAOYk0y3D3nMYh0esi/tq8IDGlTL0ARDkvQyHmV3lk+jBL6GSabG5izr3yKJa5DE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:b72d5b03-96e0-4214-991e-4a388d7e5c10,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:351980ce-02bc-447e-ab88-2baec399874a,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e33b6cd2d27211f18dc8c9802ae25ab1-20261028
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2050947089; Wed, 28 Oct 2026 09:57:10 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 28 Oct 2026 09:57:09 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 28 Oct 2026 09:57:09 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <jeff.hsu@mediatek.com>,
	<eason.lai@mediatek.com>, Jeff Hsu <Jeff.Hsu@mediatek.com>
Subject: [PATCH] wifi: mt76: Fix coverity issue for dma init
Date: Wed, 28 Oct 2026 09:57:07 +0800
Message-ID: <20261028015707.2214888-1-eason.lai@mediatek.com>
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

From: Jeff Hsu <Jeff.Hsu@mediatek.com>

Check the snprintf return value writing napi_dev->name
free both netdevs and return -EINVAL when < 0

Signed-off-by: Jeff Hsu <Jeff.Hsu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a67880a9281c..2c5d67a5bb81 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -1157,8 +1157,12 @@ mt76_dma_init(struct mt76_dev *dev,
 	priv = netdev_priv(dev->tx_napi_dev);
 	*priv = dev;
 
-	snprintf(dev->napi_dev->name, sizeof(dev->napi_dev->name), "%s",
-		 wiphy_name(dev->hw->wiphy));
+	if (snprintf(dev->napi_dev->name, sizeof(dev->napi_dev->name), "%s",
+		     wiphy_name(dev->hw->wiphy)) < 0) {
+		free_netdev(dev->tx_napi_dev);
+		free_netdev(dev->napi_dev);
+		return -EINVAL;
+	}
 	dev->napi_dev->threaded = 1;
 	init_completion(&dev->mmio.wed_reset);
 	init_completion(&dev->mmio.wed_reset_complete);
-- 
2.45.2

