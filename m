Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F418B4DAF9A;
	Mon, 19 Oct 2026 10:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404955; cv=none; b=th8SAfvWb7gP/tyWXYTFvYBGrt1Ss3fTXu5B/wR07zXNkvCVV9sN7HGLJtH0rkPRS6aE/hDVusqWQY8pxFT2qBd3lrojpOPvR1cYLU2pmGxby6ALSk1vcKI98loDlTkYZtCAXdF6KEbKHmqBIBHSWRfkGfXF3xYIV39yF/Y91F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404955; c=relaxed/simple;
	bh=SY86Jl5UexkZuxGdq7gJhE4YV1odw0kDSsu3W2A64hU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oB3skSrZTaW6WfmQ1xNKU7O0eahSi1TNE8zv8wcogP2MhBjBqD0krY9fetgMeqsEzHa8KSITIbVGXdwC75F+83IVEiibevVo+bz0gwXii1AIdpVeJfjki/P55QV27Hclk0SZVyxoBK+aX7btgITr/mBeGT6+0hHGAewxpLlKgEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=AxMSFrFD; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="AxMSFrFD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=qO
	ehNbT+F+RAH22AKHx6kqc1rYrnpUKwENVvTT9d5L0=; b=AxMSFrFDYp6ctSyjNQ
	Wee2EmVhamVOtUFLi0mvSrfWUKKCxq11pDTdrUWI90l0zIFII7hNcHqX8NLyOLmJ
	Oo8qsVYtuw8Qb0CNvOq0hkNT0dp1YkPaJEBRUBxZA0DN5X8ElwC6AV3pE0ppdidO
	AMFttAqcOpnKXqoNZIG1JK3Nk=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S6;
	Mon, 19 Oct 2026 18:15:23 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Money Wang <Money.Wang@mediatek.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 04/10] wifi: mt76: mt7915: validate MURU statistics response
Date: Mon, 19 Oct 2026 18:14:59 +0800
Message-Id: <20261019101506.1926943-5-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S6
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF48WrWrAw15Gw43ZF43ZFb_yoWkGFgE9r
	ZYvry3Gr10kw1qvw42kw4a9FWqka95J3WkZrWrtrWfZw47AFZrCr9avwn3JrW7uw4xZF15
	Gr9xXa4UW34agjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRiCzuDUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8Bu582rV7buzyAAA3z

mt7915_mcu_muru_debug_get() treats the firmware response as a complete
statistics structure without checking its length. A truncated response
can cause out-of-bounds reads while accumulating the counters.

Reject responses shorter than the expected statistics structure.

Fixes: 1966a5078f2d ("mt76: mt7915: add mu-mimo and ofdma debugfs knobs")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 3643906cbdf2..6d777dcfa2c1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2256,6 +2256,10 @@ int mt7915_mcu_muru_debug_get(struct mt7915_phy *phy)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(*mu_stats)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	mu_stats = (struct mt7915_mcu_muru_stats *)(skb->data);
 
-- 
2.34.1

