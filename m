Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C954DAF95;
	Mon, 19 Oct 2026 10:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404954; cv=none; b=g/jB+TuPMTAiIOLQRl9SkfJvHZWQJ2i9jGgP/d7b+ISRdRRLBjVeR9tssNJz7huAk5AEK+aVhLKsnFSZzO2coV9hAZbHGt6jev3L3odyT28pwr/IEgv0gLy6gcZKv6XdXSihJCS7ct16gTWO2iEH0E5m8CbDeGYyQ6wPGCeqYL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404954; c=relaxed/simple;
	bh=JrvyCfAxcRUTujWeSI6wnDcPFoF4NLnijiprEh4DoO0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ScV7d7wEOK+7mh8P80XNd/ha2ZtcwPCXlyootpLtBHZNkvysYC1yypSze4CCG26kgB7ieJK9PV0dcziOo+LIY5l0a+gRkk3654ZAZDpGbFWj6DMSa+emVJrjGa8lXlBxgfYoRc7QDD0bZJXFw3vrVLb0A0ynSmeLcFITs/TRSyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bmM23mX7; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bmM23mX7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Vf
	Oo1Gz+lA1SKNNUpWE+MzAGtSNDgpxabOAYAnI4anM=; b=bmM23mX7OCWym4JS8S
	VCnruMtsb95J64mQyc/UA4/Zk1UyMdlzn2Nh5Fsr2o6q3DhL/GRI67brvB7i20uD
	+BHAvK9v7SLom8W4FMnI+0gKX646PmO9cmodV0PV6K1L2JsR4IJY2CvHS3wkfBGh
	c8PmUpv6jXSyHcExVQgxboquc=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S4;
	Mon, 19 Oct 2026 18:15:21 +0800 (CST)
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
Subject: [PATCH 02/10] wifi: mt76: mt7615: validate MCU response lengths
Date: Mon, 19 Oct 2026 18:14:57 +0800
Message-Id: <20261019101506.1926943-3-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7WFy3JrWrWry7JrWkKr1UGFg_yoW5JFy5pF
	Wqga4Yyr1UJrsFgw10vw1kA3yaqwn3KFnxtF9rWwn5J3yrA3WrGF409a4Yvr1rJrZ5Cr1r
	Jw4kXFnxWrWDX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRwjjDUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRm582rV7bmLoAAA3e

The MCU response parser reads descriptor and command payload fields
without checking whether they are present. Truncated firmware responses
can therefore cause out-of-bounds reads.

Validate the descriptor and the command-specific payload before reading
or removing them from the skb.

Fixes: 0e6a29e477f3 ("mt76: mt7615: add support to read temperature from mcu")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index ff57ede87f71..4e33c6a618f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -143,6 +143,11 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 			cmd, seq);
 		return -ETIMEDOUT;
 	}
+	if (cmd == MCU_CMD(PATCH_SEM_CONTROL) &&
+	    skb->len < sizeof(*rxd) - 4 + sizeof(u8))
+		return -EINVAL;
+	if (cmd != MCU_CMD(PATCH_SEM_CONTROL) && skb->len < sizeof(*rxd))
+		return -EINVAL;
 
 	rxd = (struct mt7615_mcu_rxd *)skb->data;
 	if (seq != rxd->seq)
@@ -152,9 +157,15 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		skb_pull(skb, sizeof(*rxd) - 4);
 		ret = *skb->data;
 	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
+		if (skb->len < sizeof(*rxd) + sizeof(__le32))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd));
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else if (cmd == MCU_EXT_QUERY(RF_REG_ACCESS)) {
+		if (skb->len < sizeof(*rxd) + 8 + sizeof(__le32))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd));
 		ret = le32_to_cpu(*(__le32 *)&skb->data[8]);
 	} else if (cmd == MCU_UNI_CMD(DEV_INFO_UPDATE) ||
@@ -165,12 +176,18 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		   cmd == MCU_UNI_CMD(SUSPEND)) {
 		struct mt76_connac_mcu_uni_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt76_connac_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
 	} else if (cmd == MCU_CE_QUERY(REG_READ)) {
 		struct mt76_connac_mcu_reg_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt76_connac_mcu_reg_event *)skb->data;
 		ret = (int)le32_to_cpu(event->val);
-- 
2.34.1

