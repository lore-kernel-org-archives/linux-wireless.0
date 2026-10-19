Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD11B4CE693;
	Mon, 19 Oct 2026 10:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404949; cv=none; b=Gt+gz/AgkJNLUZxHnUfwPXgJLW6w3WsT9TUmaKd4d5qxtT/42ZXf0SHCAEb81jTDbi893NMLre0O/amAjqU4grzoN/BiI3jTViFrlO2cEmqRLTZB2CjmnImhGrxTtDA+4eScEN9Ol5bwD65th++47JZVEYKbMafAcVBYCg+wahE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404949; c=relaxed/simple;
	bh=0Z9FsHrvUGwgrOw9SZyxCZZ6XkW6olFRTUfmd1lYF1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LlmWzo5+AElgli3+2qapRjgB6N3RJdA8gtC927Jn/vAHPWtEkSjg4oaDWv25zGwSsZnN/d/oLlW+JYEy196KGVzDcuSg/MOGK5xBG7a72CJSlOXQoeInv6XUnGmecnPSOpYanWqiUE3hKWI5hBQlkdc9yX76On4SIIRE7ojCrCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DtsOfq1p; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DtsOfq1p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=6P
	ghorHOmeojsuMzVoaD7X2T5RS+ugW/hws9X0wYBOs=; b=DtsOfq1pK5F2hh82nl
	qZuFoJhfO4Jn+Drwiie3LsEgZEVVQ1UEBGerhdOs0NNp/5B2xqI/Hr3l4jtuPcj8
	vVBnW52TysLionW1B70fogy4Gg10iZMbqv5jyDJZinoSiCezDtY7rE5ZG7n2lz6A
	ICh3eVqhn5DVn4q93MswhuolM=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S7;
	Mon, 19 Oct 2026 18:15:24 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chih-Min Chen <chih-min.chen@mediatek.com>,
	YF Luo <yf.luo@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 05/10] wifi: mt76: mt7915: validate EEPROM response length
Date: Mon, 19 Oct 2026 18:15:00 +0800
Message-Id: <20261019101506.1926943-6-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S7
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr48CrWxKrWxKFyrAF1xuFg_yoWkXrb_u3
	4v9rnrGr1UG3Wqkw42kr429FZ0y395Aa4kCrWrtrWFq3y7ArW7urZ3Aw4fGrZruws2vFW5
	Grn8Ja4UX34a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRiuWl7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8B269GrV7b2z5gAA3Z

The EEPROM query copies a complete firmware response block without
checking that the response contains the address and data fields. A
truncated response can cause an out-of-bounds read.

Require the complete EEPROM response structure before processing it.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 6d777dcfa2c1..7009a3a3edd2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2945,6 +2945,10 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset, u8 *read_buf)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	res = (struct mt7915_mcu_eeprom_info *)skb->data;
 	if (!buf) {
-- 
2.34.1

