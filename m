Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464398;
	b=cGgwy0fZFmC7XPozpGbsHrgc2YEsI9ZIf3iEnt+g1RqhNco4b96Yjv/5FH5v3B93pPC4
	 D8OveeHhVwg794Xob1yKaDiQW+e8SddaZapyrHcithPR7mqi7BuI2KdP3bo8SWXfUGYlO
	 9Ehl640JQ/orvb8Ux8lqEWicsfsjpRxGgvJZXZvWj6MC/sCPt61JDGVYi0UvFhya2azdx
	 LXKGXLMp4CEN6FZE4BchvW/Wpn7RQC9I0JWQw9tSfMiBOKDLQzVMTBK3h8vMCWVbHSLAV
	 G5FDEkzWL1AbEH4IYeE26VGXCgMQUbgcWv8QnLDsb4xpa3uy1hxIDU1YhqnyNMC8kfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=qG7JtnRczNxt1kKLbkWdEV0AOLzF5wKtMwKHYhdEecc=;
	b=lrums+7hG0yQshzIaoEiYBk9FqzqIeTmrQWjIXly38+AVNGyFYlZlNXWKTFQmybYlA92
	 vV3/6ZcUOWXkLQ5raKwEhG9km1BPR3l0vTrD/QI10UYoatNEQewW5WaDHIcmSOua4U5hw
	 EN14AImTQtSmRaQwDq0LqIpgKT7mPBjelShTU4uPEV1E2xdoMWfuH47fh6WKwPak0MYMN
	 weayVlmrgeCagqNJaWWZ82WH2miocdJCQMxMT8jL7SOYJw8yH5DYqiWKY9lX3DKgACcMs
	 q+/Ux1tsyv+RYYpfeSReltw677tECjWDdB2qFCbfJFNUds8WSlN2Fke4nJVeUVSGGnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=UXYUz7po;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499D0606A320;
	Tue, 20 Oct 2026 02:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 499D0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=UXYUz7po
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=qG
	7JtnRczNxt1kKLbkWdEV0AOLzF5wKtMwKHYhdEecc=; b=UXYUz7poemjlMN23To
	m6wrUyhgSoSVHHRAoRUS/d7WnKTPTmkz3slpM6wEOjY6eBGD9UtXB5P7RqM0Yh0I
	jHSBuhgRofCvFinlCWmhjtQb20oqvHU25l1Q5MQs5NmkjiKHkUZtLJjyEUqIzdPd
	eYNbwoW9XwnkaSL7qORyho6zE=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S8;
	Tue, 20 Oct 2026 10:45:55 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hao Zhang <hao.zhang@mediatek.com>,
	Quan Zhou <quan.zhou@mediatek.com>,
	Rong Yan <rong.yan@mediatek.com>,
	Leon Yen <leon.yen@mediatek.com>,
	Nelson Yu <nelson.yu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 06/11] wifi: mt76: mt7925: validate register query response
Date: Tue, 20 Oct 2026 10:45:38 +0800
Message-Id: <20261020024544.3101738-7-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S8
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw4rGryUXF4xCr18uw4DArb_yoW8WFyUpa
	yUK3y5Ar1UJrsrXw4xCan3ZF43K3Z3KF17CFWxWwn5W3s5Aw1rA3WYvFyYqr43CFZYkrW8
	Xr4qqFZxurnrWaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j1zuXUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wP9OGrW1eN6KgAA3z

The register query reads either a basic or RF register response without
checking its length. A truncated firmware response can cause an
out-of-bounds read.

Calculate the response size for the selected register type and reject
short responses before reading the value.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index bca753d8ce71..ce860e63a108 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -113,7 +113,7 @@ int mt7925_mcu_regval(struct mt792x_dev *dev, u32 regidx, u32 *val, bool set)
 		};
 	} __packed * res, req;
 	struct sk_buff *skb;
-	int ret;
+	int len, ret;
 
 	if (u32_get_bits(regidx, MT_RF_REG_HDR) == RF_REG_PREFIX) {
 		req.rf_reg.tag = cpu_to_le16(UNI_CMD_ACCESS_RF_REG_BASIC);
@@ -138,6 +138,17 @@ int mt7925_mcu_regval(struct mt792x_dev *dev, u32 regidx, u32 *val, bool set)
 	if (ret)
 		return ret;
 
+	len = sizeof(res->__rsv);
+	if (u32_get_bits(regidx, MT_RF_REG_HDR) == RF_REG_PREFIX)
+		len += sizeof(res->rf_reg);
+	else
+		len += sizeof(res->reg);
+
+	if (skb->len < len) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
 	res = (void *)skb->data;
 	if (u32_get_bits(regidx, MT_RF_REG_HDR) == RF_REG_PREFIX)
 		*val = le32_to_cpu(res->rf_reg.data);
-- 
2.34.1

