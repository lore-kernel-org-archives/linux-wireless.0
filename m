Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B394748F037;
	Mon, 19 Oct 2026 10:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792404948; cv=none; b=gJNK9ERUDdrOy/JlAEpeM7cm4ycfIReIBosstMMIpqnPbpXosfJRTbEwG1qeqIST1g6x45Wihy8k0fk7WiIrq1QUCzWdMv6cjTUN9cejR5Z8kLhUMOfCy0gGDSib2V9i9OhKIvdKATralmjb2X0nf6LFCUTLqXHsHbP6IbVWZ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792404948; c=relaxed/simple;
	bh=Fsnq+mcpslfiLoiVRTc3E/G/zndGzUivmpgt7PQnrTk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=r/Fvgel5Hq1ye1OrqcoqBeKoOb3FNw9ZVE8Hgq/R9DNa8eOvRrlnmIfia/qPvO1rupXD5wa9HuYKiV1NCYbXLMFpUNM7psQQjrsmz5YYLgqHF6P2EgXOfEb15H6HRZZq3Q4MWXdYtXwWMvcJXKsmpKs3jceUJ+M5Yiln1zAapUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=aqvtdUPL; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="aqvtdUPL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=QI
	tUMk3/faB0K9oWLrR1Ff3bacbZI0KfxrnOXxLHV5I=; b=aqvtdUPLqi+92VWng/
	GFce4w5gpDl3SLFNh2knSg9vnaordKHUTYVMkjRRXHIkEs2YJCgw/6T4ce/EEux2
	dknKqG6HH3KQNomY9jSCurmHS3ajgsSsJZPfXYDwAUk62tVid1HAnUue4Y6kE+QV
	818ofSh4lsjO7JdB8HVno2u18=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3Hxax7dVq4twABQ--.41578S3;
	Mon, 19 Oct 2026 18:15:19 +0800 (CST)
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
Subject: [PATCH 01/10] wifi: mt76: mt7603: validate MCU response length
Date: Mon, 19 Oct 2026 18:14:56 +0800
Message-Id: <20261019101506.1926943-2-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3Hxax7dVq4twABQ--.41578S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw1UXFyUZr1UKryrKFWxZwb_yoWkXFX_ur
	1v9ry7trWUG3ZYkw42kr43uryak3y8Zr95Z3y3t3yFg3y7JrWDCFs3Zry7Jryq9347uFyq
	yrnxJ3W8X34avjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRil1v3UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzRi582rV7biLfQAA3D

The MCU response parser reads the sequence number from the receive
descriptor without first ensuring that the descriptor is present. A
truncated firmware response can therefore cause an out-of-bounds read.

Reject responses shorter than the receive descriptor before accessing
the sequence number.

Fixes: f320d812b7bb ("mt76: implement .mcu_parse_response in struct mt76_mcu_ops")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index e432cce97640..b231fb2d3752 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -26,6 +26,8 @@ mt7603_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		dev->mcu_hang = MT7603_WATCHDOG_TIMEOUT;
 		return -ETIMEDOUT;
 	}
+	if (skb->len < sizeof(*rxd))
+		return -EINVAL;
 
 	rxd = (struct mt7603_mcu_rxd *)skb->data;
 	if (seq != rxd->seq)
-- 
2.34.1

