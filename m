Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C9C4D09F1;
	Mon, 19 Oct 2026 10:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404950; cv=none; b=eiX8B3vFtyR4IrbhzQ3DzUXHPqSXxSoEvXVydhAP+CZ1yrMTA4CTlvuXlCeylu2SCIMrKSZw9B6em1tVnNRuENCd1VDczE2KkGcN9hJvQq4f1p57JnxqVxG4kgCgkULZagkX6zW6NLnzH6vtmDm0TZtBXaO9vTmSn3PXt8Kd4io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404950; c=relaxed/simple;
	bh=juftEZkWdMIqYhZQ0T4hmWgHzkiBpY6PqB+t2sTLc0o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t44FKB8FwpwRVhcPQXFm6RCxn9x9aKLJ7HOnc9dbKqFfjbXLv2mAzkJ1um9Jx9ZiEfiOSLfNiqx7Si0XpWUzK3jWmPHG+8YR3xbMmW/lbBXCplfU9HFNVqXjbGhS/0pcmd2eAVoO5voAsEglOz2d/RmEEbPCKT0ZDgBfoQDvjjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Tld/xJBg; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Tld/xJBg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=44
	nY6J6XiDlqL4AiN+jyRzejpQtk9NdoZSmq8/1VDHg=; b=Tld/xJBgjfHpuHYLHb
	8hpQdwil+6PAYmsQYiJDg6bRVnHsNC2becAn/o/s2Tn4iHuXWK9A02lAHy5Uk40O
	6X4x0QeDI9bQMbWWow4A8d47vhroeeTYg57JeoixGBcLq73qP7UaKMyeWBy52OcH
	NrmgjWg0tJh3M23r8p79EetRI=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S10;
	Mon, 19 Oct 2026 18:15:28 +0800 (CST)
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
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 08/10] wifi: mt76: mt7915: validate RX rate response length
Date: Mon, 19 Oct 2026 18:15:03 +0800
Message-Id: <20261019101506.1926943-9-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S10
X-Coremail-Antispam: 1Uf129KBjvdXoWrur4Utr1rGFWkCry5Ww43GFg_yoWkJrX_ur
	4v9r9xGr18Gw4qkr12kr47uFWqyaykA3Z5urWrt3yrJ3y7ArWDCrn7ZwnrGrZrW3Z2vF45
	Jrn8Xa45X34a9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRiuWl7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8AG79WrV7cG0KgAA3y

The RX rate query reads a complete PHY information structure without
checking the response length. A truncated firmware response can cause
out-of-bounds reads while decoding the rate.

Require the complete PHY RX information structure before using it.

Fixes: 11553d88d0b9 ("mt76: mt7915: query station rx rate from firmware")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 955c0e6c7cb6..00a528694255 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3942,6 +3942,10 @@ int mt7915_mcu_get_rx_rate(struct mt7915_phy *phy, struct ieee80211_vif *vif,
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	res = (struct mt7915_mcu_phy_rx_info *)skb->data;
 
-- 
2.34.1

