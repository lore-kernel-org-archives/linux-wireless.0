Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464398;
	b=23OE912g4F1PsgjN5h4S1qwFiYOO8IGodwTLaZtfncUFN+nZSAStCOxbTB4YbXb66Xl0
	 aU6hLFjsZhXNtXpSQhOwasfIhggjsHQBycczoenpTyPx8SWJdCtMAdUTto+9wQF4PHDKm
	 D1bH6vf8R+V152yi7w7FjlWAb/0Ww42vYV+9fFZgcpHf8wNaD8JHEN1EsumLC1+8+P268
	 Hmyt98Bjyz8TxzQ1Rs03ZcUklDkA4qiWC8M615Ue86Swi4InXb8LOJ+hZnihJNr3UOx2q
	 vq3N09fnwWWgbynN//VwSGObZlZo64wbCZSiDUK4ek6bpG3JN4fU6WE0ZgxnWduVOyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=datRhPKvUt8Wm3BSwDl6dFeqU17AfptMGzHaScRNqKs=;
	b=dVJwmzHWPvZEcNnO45zAD0mDWGqZIbodEVCT2Mi9IBUd7JTMz6WJD0UlcfFezbyTrtiv
	 DmTFif5REsFBGTjuHuhXzXQJYj82Ddu4iiVwmtPzPkLZXGznKZ3deLNRQxngYmLZwMNtu
	 +Ol+bsZJAw+IwNjMSXkAAcVIFYRlJmko2jQE22wZ9373N8LVDB2RVt/pm1D+AEvQMXN1N
	 zJ0q5cU+nHHtM+DP0wMPS0tl6Gjk1GCrv1g3zujVGGBMyZcMecCwv162Bk2Q7K/3vxeYg
	 7qfLgcomlQQiaVmUUaDeJF+d/pCwKj7V9eK9wdPJj4OVbEn2WjK9l4GuyPRcUE3QDAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=UVUf0h9l;
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD71606A31D;
	Tue, 20 Oct 2026 02:46:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AD71606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=UVUf0h9l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=da
	tRhPKvUt8Wm3BSwDl6dFeqU17AfptMGzHaScRNqKs=; b=UVUf0h9l1rqCxWV+ou
	TQMAA0aj0AtvHKUeLPukGq5Dye1+QxBBUOZ+R+XK7d5ZRA4WkPKmqFWPwasaWQSP
	x4aZoSFcQqkZKBa0cxd8xl4JAyEgpMFsAjpIQPxpQiH2HDNsYBMqoNflg+wgnD6U
	/2XZDzhHBTDDwPT/pYHPUZQ9w=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S5;
	Tue, 20 Oct 2026 10:45:51 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 03/11] wifi: mt76: mt7921: reject malformed TX power responses
Date: Tue, 20 Oct 2026 10:45:35 +0800
Message-Id: <20261020024544.3101738-4-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFWfXF1fXr1fJr13WrWrAFb_yoW8Gryfpa
	y0gayYkr4UGr4vqw1rAF4kAFySyan5KF13GFyruwn5WryfJrn0kF4F9Fyjqr4Yya1vkF1f
	Jr4YqF9xGr9Yv37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j7J5rUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzR-8N2rW1d+CUgAA3-

mt7921_get_txpwr_info() only warns when the firmware length differs from
the skb length and then copies the response anyway. It also reads the
length field before ensuring that the response header is present.

Require the complete event and reject a mismatched firmware length
before copying the TX power data.

Fixes: ea29acc97c55 ("mt76: mt7921: add dumping Tx power table")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index ef6660653723..96e5e13d3c47 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1167,8 +1167,17 @@ int mt7921_get_txpwr_info(struct mt792x_dev *dev, struct mt7921_txpwr *txpwr)
 	if (ret)
 		return ret;
 
+	if (skb->len < sizeof(*event)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
 	event = (struct mt7921_txpwr_event *)skb->data;
-	WARN_ON(skb->len != le16_to_cpu(event->len));
+	if (skb->len != le16_to_cpu(event->len)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
 	memcpy(txpwr, &event->txpwr, sizeof(event->txpwr));
 
 	dev_kfree_skb(skb);
-- 
2.34.1

