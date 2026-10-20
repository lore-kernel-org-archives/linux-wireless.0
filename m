Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464398;
	b=pHoxdiUo/jOZaesT0AsXNKTNy+5mWqi2JWbgTpJ2EN5I4yQPYVvcF5XRL5Bpne7lFLZT
	 oV+aE+YSKHCQbbBWfVqh5GV0V+w/TZa4gdboqb8Is+RpEnNgWl0MXlEc548mWubAUj9YI
	 lSk5K5a2FhxIv0Cty9xvAyKN6y0Pzwb9VEkaMHNJUJmxmNivfXp9jKwjGs75bfoR9Nwu8
	 9uig+7IzD+Ap8ItCXcLcyPQ7IghQkcMPxG0oxwDcm/yXyEpkJGoA1cOTTBbf9c2hXOLoZ
	 cgTRz8qfxTokqQNy8Jmon/BJA2hK4ZI4n2eQHi1qkPtsLKzskkgEJba6f5fo5IREmiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=LyA3JX14Q6WRUe8iSFtxvl8ukjUrydPdyqI0BYKCZIU=;
	b=ch+zyiMTlJB3fIrC4z+mrNNHCOwpUWJs9E0B+Zsd2N5mIlvKfETNDLvjRZQiQhbAQ2TT
	 V8Zc1RiBTcB2iDTGE20hf/lbdUtF78X1jcLjG3BIALm1AdB5/s8Tls9erDeemREmA4MSx
	 qaCBxQUFcB38OgIvNSGyyYHpLB4BNTteE9T3hDTOduQlLk1nIQ1cLTCvXNJL4ey+EFIDC
	 U9mCylsKRBNqxB9/iYO7pSx0xTAffRy5T48A3PO/ppOBJjEn881wcCTzE2NSHcd8QqlTe
	 O8H4gyojWdWl1WuNGmv7suGqpbi9S2xkaiHBn/5+LHo1/xj6gu95JtzLVSMvrqpyhFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=fvZV49Pp;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEE1606A325;
	Tue, 20 Oct 2026 02:46:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5EEE1606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=fvZV49Pp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ly
	A3JX14Q6WRUe8iSFtxvl8ukjUrydPdyqI0BYKCZIU=; b=fvZV49PpCPWdpYt7uA
	OrBd3+Ny9esLFTnFO3oqsVu9c5JQ5iZc40jWKguf6NXBD/s3+4ijLG+t9EA1lvbz
	MuPrTH5bORD/0GGSuDkyjpMeUFsEhmOtSfg3WqMkA6g2vASoUX3KTK8W0a/HfjaJ
	VSUQ6baCAS9Uz2UTT/MVw+6No=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S4;
	Tue, 20 Oct 2026 10:45:50 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 02/11] wifi: mt76: mt7921: validate EEPROM response length
Date: Tue, 20 Oct 2026 10:45:34 +0800
Message-Id: <20261020024544.3101738-3-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020024544.3101738-1-yaojiale02@163.com>
References: <20261020024544.3101738-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrKFW3tr15JFyxWF15AF13Jwb_yoWkZFg_ur
	1v9rn7Jr1UGw1UKr42kw13ZFZ0yay8A3W8ZrWrtrWYqFWUJrW7ur93ZrZ8GrZFkws2vF1U
	Cwn8Jay5X3sIvjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1XTmPUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzR78N2rW1d6CNQAA3Y

The EEPROM reader indexes the data array in a firmware response without
checking that the complete response structure is present. A truncated
response can therefore cause an out-of-bounds read.

Require the complete EEPROM response before indexing its data.

Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 782c8baaf776..ef6660653723 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -104,6 +104,10 @@ static int mt7921_mcu_read_eeprom(struct mt792x_dev *dev, u32 offset, u8 *val)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	res = (struct mt7921_mcu_eeprom_info *)skb->data;
 	*val = res->data[offset % MT7921_EEPROM_BLOCK_SIZE];
-- 
2.34.1

