Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523AA4D599A;
	Mon, 19 Oct 2026 10:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404963; cv=none; b=m2e2vxlIip1cXHJZ7JjrhspNAMSSD5aSUV6L6Ut9r6eF/SMsjfbHJqeha7/vF/40EVm0csncDyrN30sxGx81sd6KCYtOA00cz+6pL/H+AvGuSsqXfIiiIeL1HTqsQ81EVsBrojPZL8rdWc3uElrraf2hecNtpAunnRPwqXtj44k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404963; c=relaxed/simple;
	bh=juL+/6QopFo0lMtDSEd6YUYjqWNo+eh+aqmt7qJK1U8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DxnHdyxp8UqcOfdcfo2reMCEEOJBw6NlMfCl14i3PHYskviV96rHnWaXz+PO1Cor3dhq93er8CuiJvSeuXkZwMXv4XBC/NDxsTzTmbf/17EP7zCgs3z4JEOswAcO2SfqX/RVZVjV4x9XSOCoElUTdtDeMd8w+cHrQPt/hgr9KBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ZuXFd512; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ZuXFd512"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=39
	+rHsUPFz0jl7q8duyowDHk9CeWNhUTVpMmdClsFH4=; b=ZuXFd512IHtJ/b4N2p
	wotEEk2Zr2eACFmk57qGCownmvG4BxCzr8lS9U1j9M5dffpLLjBxiTlM1sLVsB30
	RHbs6PP7YL0NQRP+BrxpS5z+juLT/I9Usj4KEyCA9eAqHq5pwtaiVnDI5jeBiBHo
	Pazr9cyVppiGrnx9zsavVPFWY=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S11;
	Mon, 19 Oct 2026 18:15:30 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Peter Chiu <chui-hao.chiu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 09/10] wifi: mt76: mt7915: validate WED TX statistics response
Date: Mon, 19 Oct 2026 18:15:04 +0800
Message-Id: <20261019101506.1926943-10-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S11
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFWfZFyDXrWkAw18CFWkCrg_yoW8XF48pF
	W8Ka4Yvr4UGF4vq3y8Aa1kZayrtanYgryxCrW8Ww1rGryvyF1rCFWq9Fy5KryFya1vkF17
	Xr4YvFnxWrZxZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRl_MxUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8AK79WrV7cK0PAAA3k

The WED statistics query optionally skips a response prefix and then
reads a fixed statistics structure without validating either range. A
truncated firmware response can cause out-of-bounds reads.

Calculate the chip-specific prefix and require the complete response
before pulling the prefix.

Fixes: 161a7528e407 ("wifi: mt76: mt7915: rework tx packets counting when WED is active")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 00a528694255..4a11a4a0dbde 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -4183,7 +4183,7 @@ int mt7915_mcu_wed_wa_tx_stats(struct mt7915_dev *dev, u16 wlan_idx)
 	} __packed *res;
 	struct mt76_wcid *wcid;
 	struct sk_buff *skb;
-	int ret, len;
+	int ret, len, offset;
 	u16 ret_wcid;
 
 	if (is_mt7915(&dev->mt76)) {
@@ -4200,8 +4200,13 @@ int mt7915_mcu_wed_wa_tx_stats(struct mt7915_dev *dev, u16 wlan_idx)
 	if (ret)
 		return ret;
 
-	if (!is_mt7915(&dev->mt76))
-		skb_pull(skb, 4);
+	offset = is_mt7915(&dev->mt76) ? 0 : 4;
+	if (skb->len < offset + sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	skb_pull(skb, offset);
 
 	res = (struct mt7915_mcu_wa_tx_stat *)skb->data;
 
-- 
2.34.1

