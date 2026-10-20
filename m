Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464618;
	b=oCIv6a0Sh5Gd3mptUczy7YG+EPAc0LqHc5VZFnPN27oVzm1wsPgaf1ILB3V+BIAtRWJW
	 DoydtzRfPE1wyx16QHrvM34Nqyd8EZIge4MGeWoWYzMwHaG5WpFYx3UR+J+X9rTijGP+q
	 axuBEPpCT9FDEu3PaR7ZdsiZnogDrXIyJkzS+JAULWS82SYs2RzwBEIqse+sUIfn9Z76y
	 r7hvt1jqDc4d/NTNDoxLbiAfT5i9VNWCkc6YdbwExtNExGvKawKL6w3G7nxSmq72w72ec
	 0DUFingmQtOcDDqQPGzcLHf5B6q8QN5TTD9fw0i6t9+8HEa1xrN7mZq+F2HNOORo9GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464618;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=tmELMb3Iy2dsfsnzN/3kQI/Gin1VtfTa2L18IbfBUSs=;
	b=H742CH721uww6dA1pkk93DrwR7rKbNcaYsyIJ2hVBu/Ob1eouJBXbueZBgDfbYVX9u+t
	 FuWbC129PuGmhEpDdVBYZ1sDoxoDMiO4GH34bgP1EUymyU2HORC/5B+C23Vd5S4Rg764H
	 qJvWXap4yHmlncD6joYc8LPNNNpBsrrcgZQ6qqFapl/W7ZLfBRRnCrUbSVjzK2gvwUkeb
	 yLB4FqvIErD7+9pb/JEuZt6gnYm/Bx3WCFfUayT58SpR+4GV1+gI2wdGLGM3zRnso203u
	 X/Cdx1LTg2EFrIehD89AXltqm25/ewt08GWQvJ8I/7LTv9PVtlmEIAZhJSQntgQWBdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=aYuPUjTx;
	arc=none smtp.remote-ip=220.197.31.4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA80A606A328;
	Tue, 20 Oct 2026 02:50:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA80A606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=aYuPUjTx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=tm
	ELMb3Iy2dsfsnzN/3kQI/Gin1VtfTa2L18IbfBUSs=; b=aYuPUjTxOkibfJ0V6A
	wWXrD62G/n0sMSOCPSktGZY2mXc9pjkrtGkmnUpd+lmos+nzkjh9EiTnKrQ6KMMs
	NEn/Ee8rc6sczw3FCh4orn7wKFoPhRIRIXXkVlO/dLRywmzpB7zKZ7QZdufwOADI
	FbLQVz95OMy8mGjz3KGjbWPfY=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr8C+1tZqMLhIBA--.5123S6;
	Tue, 20 Oct 2026 10:49:41 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Elwin Huang <s09289728096@gmail.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 4/7] wifi: mt76: mt7996: validate free-block response length
Date: Tue, 20 Oct 2026 10:49:30 +0800
Message-Id: <20261020024933.3205681-5-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnr8C+1tZqMLhIBA--.5123S6
X-Coremail-Antispam: 1Uf129KBjvdXoWrZFWDXr4fKry8tFyUWw1xXwb_yoWkJwb_uw
	4vvr9xJr10kws0kr47Cw47Cryak3ykZry8urW3tw45XFW7JFW7Grs3Zw15Gr9I93ZrZF98
	Gr1DXa1UAa4aqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbG-e7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgU3cWrW1sWlMgAA31

The EFUSE free-block query reads a byte after an eight-byte prefix
without checking the firmware response length. A truncated response can
cause an out-of-bounds read.

Require the prefix and block-count byte before accessing the response.

Fixes: f456e1f56c4c ("wifi: mt76: add external EEPROM support for mt799x chipsets")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index eb868c2d5108..c70d7ad3148c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4516,6 +4516,10 @@ int mt7996_mcu_get_efuse_free_block(struct mt7996_dev *dev, u8 *block_num)
 					sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < 8 + sizeof(*block_num)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	*block_num = *(u8 *)(skb->data + 8);
 	dev_kfree_skb(skb);
-- 
2.34.1

