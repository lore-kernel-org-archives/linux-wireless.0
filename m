Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A97A4D5998;
	Mon, 19 Oct 2026 10:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404964; cv=none; b=n/Z3s3QTBGABqNYr/Ig6+MbSLIQLrC/eM96gqqtSyrVR/xtI7qoJ+S0g/4DwR0P51kQwgFFurUCSEweb/y50IrP5LldTKAy5QCZ2ZY6mojOoZ7NJ6NUy4UsRT/AjG9XdY9OcA8IWQ0QK9VPG3SbMPzosPjsPQbXNj2+b8Uwm/jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404964; c=relaxed/simple;
	bh=dpzmwJV62+t0xTY5yjTcO6Xr5Xidgy9JXeC34dlb7rc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QkXndql8MWeUUAEWiBCj6pFW+El0DYiHDOMBgE8qej9xZSG68UjjFmBzgUSK5ntBPqXr4yaxLhHO5KAoyQdirjwiZBSBXv0nb9dlGC/KSaxeZqdOt4DMYytiXxDk3d0gcTOgw0G7scE8t1jBiXNlHWM2BMmRImzrTYcC89ZRaLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=llrw0tNC; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="llrw0tNC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=8Z
	uSQdKZoDodfXxINakcZgz8RnopRM3PGkhuKFq6Br8=; b=llrw0tNCTChbZehVDx
	RV91p4ULKg983lsJVa3RKZaRjNQdhv9GGtAcLYehB9+67LiNeAuVRSClyo4vHiYV
	uXmZHnVFJJIlta1yHjVLzs5X5x8Mvm2U+FU2XDqfd1yjMdbbL2KuOMCUFGzlA5s5
	aDOquwbsQvqxjfftKWf4HZH3E=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S5;
	Mon, 19 Oct 2026 18:15:22 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	YF Luo <yf.luo@mediatek.com>,
	Yiwei Chung <yiwei.chung@mediatek.com>,
	Chih-Min Chen <chih-min.chen@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Cc: Jiale Yao <yaojiale02@163.com>
Subject: [PATCH 03/10] wifi: mt76: mt7915: validate MCU response lengths
Date: Mon, 19 Oct 2026 18:14:58 +0800
Message-Id: <20261019101506.1926943-4-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S5
X-Coremail-Antispam: 1Uf129KBjvJXoW7ur43Jw4kAr1Duw4kZw1fZwb_yoW8Xw47pF
	W7Kay5ArW5Jr4jqw409w4kZayYv3Z5GFy2gFykZwn5JrZ5AF1rGFW09Fyqvr1rAFZ8C3Wf
	Xr4qqrsxWrZ8Xw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pMnmirUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7xq582rV7bo2gwAA3i

The MCU response parser accesses receive descriptor fields and some
command payloads without checking their lengths. A truncated firmware
response can therefore cause an out-of-bounds read.

Validate the descriptor and the patch semaphore and thermal payloads
before accessing them.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 5bfe0366562f..3643906cbdf2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -174,6 +174,11 @@ mt7915_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 
 		return -ETIMEDOUT;
 	}
+	if (cmd == MCU_CMD(PATCH_SEM_CONTROL) &&
+	    skb->len < sizeof(*rxd) - 4 + sizeof(u8))
+		return -EINVAL;
+	if (cmd != MCU_CMD(PATCH_SEM_CONTROL) && skb->len < sizeof(*rxd))
+		return -EINVAL;
 
 	rxd = (struct mt76_connac2_mcu_rxd *)skb->data;
 	if (seq != rxd->seq &&
@@ -185,6 +190,9 @@ mt7915_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		skb_pull(skb, sizeof(*rxd) - 4);
 		ret = *skb->data;
 	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
+		if (skb->len < sizeof(*rxd) + 4 + sizeof(__le32))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd) + 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else {
-- 
2.34.1

