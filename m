Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464608;
	b=nXYwDrN8ymbBw7mtIAwStj1tuhgwzktDkZQx+JWdyuThdSacJkLmXca1h9b7gPtB4xw5
	 eqdbRkTCG/uG8D6GJuIznNUbPGo/TarK0sywE8XmNEEJ9MYSLkV/ubWrJ8G8ihhL7vPxq
	 gBMw9vuBJt+kyN+rqpGDuv5K4/C+Qe6xaQqACyOS5brb1qyoC2RnG61Ncwa9qebvjqAgu
	 jzGtnO83lOr+l527uUMSLrojNEuXrjWqbOz75yVN+cP0qhDg4xTAOJJZVrMJaQSVEI9w8
	 q9/deKigQizeu3H/R8jG/o3HNVEatIzdsGDarnOJ48mzAm7c20SqhNkhZn83YoGqgaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464608;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=QWWVKdiYGbmvOs6BNs5U4wYjRvABmR24ib21cCIkM/M=;
	b=TV3/SnPiQQEkIrzf1KFYv8+lRbRGuOo3YAh59FQ7vMGzN4QJMLOfnZHxFallBZNKm3QN
	 8dZOt1JxmROwkCOS2B0n4K39V4HaOd3IT+Aq/w+Us2E3D5TJv/tkA2Wov1TVCViXGiTSp
	 lLfn6zCgCuwi/Wia5t9oj+dhYI4tuWz5+aZ6w+u/jzC7eMOxbybfNvlNa+xi/SDDSbEfX
	 vZUBsdRW5uleotBHSLVffdzHpxr6nnh4oI0v9wPg8YAM+ywATifLWw39i5CXm2/q4NGkT
	 /9CQ+mFCyfNmAYr9UkaYsBSqCuOlbyUdFB+zVvW7Fc7vj4ByIDoqNwfnVVPe+DE1VvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LzXmEMM1;
	arc=none smtp.remote-ip=117.135.210.4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0F606A325;
	Tue, 20 Oct 2026 02:50:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9D0F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=LzXmEMM1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=QW
	WVKdiYGbmvOs6BNs5U4wYjRvABmR24ib21cCIkM/M=; b=LzXmEMM16FGmg6Z00P
	g8iLkfXXvZzqo050H19DLXnlACdRkcKa3KYU0MG16CPp0okQ2RarrGVtdFi7wL30
	+nuoqCzulFrDyqW071gNbUDeRJNeYtWWnHPEdlBTHsFSpRk7ddDVU0V27eESUHeO
	MiFFVL+318dajv4FDmLi1QmAk=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr8C+1tZqMLhIBA--.5123S3;
	Tue, 20 Oct 2026 10:49:38 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 1/7] wifi: mt76: mt7996: validate MCU response lengths
Date: Tue, 20 Oct 2026 10:49:27 +0800
Message-Id: <20261020024933.3205681-2-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020024933.3205681-1-yaojiale02@163.com>
References: <20261020024933.3205681-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnr8C+1tZqMLhIBA--.5123S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw4rJw13CF1kWFyDWr1kuFg_yoW8ur4xpF
	Wjka4Yvr48Ars2qw18Ca1vya1Yq3WrGF13tFZ5WwnYvrZ3C3Z5JF1xKFnFvr45AFZxCF1f
	Jr4jqF13WF98X37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UlfO7UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wI2cGrW1sKSwAAA3R

The MCU receive and response paths access descriptor fields without
checking that they are present. The response parser can also read a UNI
event payload beyond a truncated skb.

Require enough descriptor data at the receive entry point, account for
the shorter patch response, and validate UNI event payloads before
accessing them.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index cd7587ce5b8a..d661ff1e4a20 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -238,6 +238,11 @@ mt7996_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 
 		return -ETIMEDOUT;
 	}
+	if (cmd == MCU_CMD(PATCH_SEM_CONTROL) &&
+	    skb->len < offsetofend(struct mt7996_mcu_rxd, ext_eid))
+		return -EINVAL;
+	if (cmd != MCU_CMD(PATCH_SEM_CONTROL) && skb->len < sizeof(*rxd))
+		return -EINVAL;
 
 	rxd = (struct mt7996_mcu_rxd *)skb->data;
 	if (seq != rxd->seq)
@@ -248,6 +253,9 @@ mt7996_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		ret = *skb->data;
 	} else if ((rxd->option & MCU_UNI_CMD_EVENT) &&
 		    rxd->eid == MCU_UNI_EVENT_RESULT) {
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt7996_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
@@ -943,6 +951,11 @@ void mt7996_mcu_rx_event(struct mt7996_dev *dev, struct sk_buff *skb)
 {
 	struct mt7996_mcu_rxd *rxd = (struct mt7996_mcu_rxd *)skb->data;
 
+	if (skb->len < offsetofend(struct mt7996_mcu_rxd, ext_eid)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
 	if (rxd->option & MCU_UNI_CMD_UNSOLICITED_EVENT) {
 		mt7996_mcu_uni_rx_unsolicited_event(dev, skb);
 		return;
-- 
2.34.1

