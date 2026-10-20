Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464398;
	b=2M8ajll0cu8jOjQREGUw0H2BGRdjLDOcFy77pjMag2FX5KH/sYwsKofaKM7JoqiY5z6g
	 WWvaH4dFwXStwig8j9ySuPjOdCvS9Zh2AanO1mvTQnRJkLlcdDWnjwTunozPnFQLyoBEL
	 IxBdaVoh62gcBdY9cVADah83tZmhmp7jtg4Kdu6Y2GN9MZ4DkuWUl0++0nT77RZQbBfJO
	 mLBuZ/bwwU8raxqFM5xrAZM80+SJr8dVhSmVbgGqHs6zJlB6A7IXuW5aFVeOZQKEXCA0c
	 8C7/ApRLMynt4CPWcs4lT/DmrtLSqd6KKbFdLS50JkWGtmg9jO4avBMeNSAy2Cjrxbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=RN3k8czzMRgmOq/HRFi3+tQnogP9QGjQCyHmUCQ+VUg=;
	b=DJH+HZWxU/h+YQJZJVuBniqBAIR6QGAbMI3nhss5vGUUL4kciD6cuRZ1/FMKpHUz8hhT
	 VEe7/AXF+v6c9aMshXGxjI113eUdmGNXz3yH+G6lcwlQLPxbL6a5YU1Lf2XEzHVhdzYCM
	 5VuEA40CJpwrbPGFXn3Ws8uFOomKygQcEgcZLcTNENpeOYqWlRkYQQRPcuNmlxipC1/mi
	 N7S/m+ZIeuTUHdBkDnUuqmfnw69FZRIJs1ji57e84KB1BeBBkLAjIt0POsIj6E9RIsaJV
	 2L0NjGfLkg0ixnpsd0Wd+UgYFJeHdBz2SDBbog1vsAG/6lkS+F9rGU58WoCvfYBISiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mxGw2sQB;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AEC606A322;
	Tue, 20 Oct 2026 02:46:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26AEC606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=mxGw2sQB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=RN
	3k8czzMRgmOq/HRFi3+tQnogP9QGjQCyHmUCQ+VUg=; b=mxGw2sQB8hYJH4gYCq
	2y4+hkmlB0hxn0pMepd5zM3sa7gANUfKHPDFUk4XIvbM0B51vDMd6CIxr/lVIOEW
	ehDF12aKnU4q8pZf/Qr6WpplhraUTr7OnxhBx03JOvMHTtN61a0teSjPmIWpkE4/
	+Kr/JD49adTnwyQe4Y5MUaTr8=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S11;
	Tue, 20 Oct 2026 10:45:59 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Deren Wu <deren.wu@mediatek.com>,
	Hao Zhang <hao.zhang@mediatek.com>,
	Mingyen Hsieh <mingyen.hsieh@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 09/11] wifi: mt76: mt7925: validate TX power response length
Date: Tue, 20 Oct 2026 10:45:41 +0800
Message-Id: <20261020024544.3101738-10-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S11
X-Coremail-Antispam: 1Uf129KBjvdXoW7GF45uryktFy3XryDtFy3CFg_yoWkWFcE9r
	4v9r97Jr18G3yDtr42kF43WFZFy3y8X3WkArWrtrWrWa17J3y7Cr9ayrsxWr9ruws7ZF45
	Gwn8Aa4UX34SgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbAsqtUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8Af+OWrW1eccuwAA3Z

The TX power query copies a complete event payload without checking the
firmware response length. A truncated response can cause an
out-of-bounds read.

Require the complete TX power event before copying its payload.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index d768002c64c2..f37d2a8eafe6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -2287,6 +2287,10 @@ int mt7925_get_txpwr_info(struct mt792x_dev *dev, u8 band_idx, struct mt7925_txp
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(*event)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	event = (struct mt7925_txpwr_event *)skb->data;
 	memcpy(txpwr, &event->txpwr, sizeof(event->txpwr));
-- 
2.34.1

