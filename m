Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3209D4825C1;
	Mon, 19 Oct 2026 10:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404948; cv=none; b=CaZ/GzCCN/1cL73fRlykGBocTPzBK7lFuh7KW7lP3uURHwVuQCqHBvkTnjQilIp/pIfD6SPS2dlFek+ghtzrT0f0ET3fLd6ineuD5h+6E6tqmj97s51sJjyAa+Ym9XopG7OF9bXJb2qjMOfq1D6btK+wj6+LflLBwvucruBE9pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404948; c=relaxed/simple;
	bh=f7kuSizI1kkNXAoxIfA5lpSBH7MLm4mxm3E4wXWJpH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a5vdnYPX9hFt2orfElBsJeAkV17xaabi0VZw0t9czrtaI02hoVTNw7lBJe1kUNYQZFPfY45uvtIiNeTUi92S0JfT10VQXMBxfo7e7SLMO+4s9agqe/Y2VPLzkl+acKrEXgjMBOCb5xHnrZE/H59sAcK+KyZMtUTH0L5Zzkf1J+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=cgT1r3Jz; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="cgT1r3Jz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=D3
	2FpQGazZvJhAchTXEiSni/VM614GAKI9AEvzA1OLo=; b=cgT1r3JzizIqNc5R2L
	uRpLW7NyXdj+O+dWxx9D34TqM/evP5SBnpvB3q523EvlOCnyaFc0tZgPhvqV8QP+
	c9MV6ygiHqvp0ly/sUwgAUQShBmVM9inVXc+QR0mk5ykiBqXYZ5WwDrkCpOAygSW
	Saup8uir7rykpKV6MZ2HfkMEU=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S8;
	Mon, 19 Oct 2026 18:15:26 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 06/10] wifi: mt76: mt7915: validate free-block response length
Date: Mon, 19 Oct 2026 18:15:01 +0800
Message-Id: <20261019101506.1926943-7-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261019101506.1926943-1-yaojiale02@163.com>
References: <20261019101506.1926943-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S8
X-Coremail-Antispam: 1Uf129KBjvdXoWrKr1Uur4rWr1fXryUAF48tFb_yoWDtwb_ur
	nYvr17Gr18Gw4qkr42kr47urWak395Aas5ZrWftrWrXay7AFW7GFsxZwn8JrZxu3Z29F15
	Grn8Zay7J34a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRiuWl7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzR669GrV7b6MCgAA33

The free-block query reads the first response byte without checking that
the firmware returned any payload. A zero-length response can therefore
cause an out-of-bounds read.

Require the block-count byte before accessing it.

Fixes: bbc1d4154ec1 ("mt76: mt7915: add default calibrated data support")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 7009a3a3edd2..05614b99165b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2985,6 +2985,10 @@ int mt7915_mcu_get_eeprom_free_block(struct mt7915_dev *dev, u8 *block_num)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(*block_num)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	*block_num = *(u8 *)skb->data;
 	dev_kfree_skb(skb);
-- 
2.34.1

