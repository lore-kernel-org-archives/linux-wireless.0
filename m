Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464610;
	b=J1pbQVbzzIcMBWPmmOhV+r/GIoHW164UiTojgrtqHt9ukM1Vedxqb32l7rEGqy0Sm4ll
	 ZxrCZX4xOviuPSbTJj1/pt8vmrp7/HiMOkklPsZIwYlrHtccegKKfPccf8XZlYIidCLcs
	 QYG5eZruDJ657QRRKCIPtjKtuF306Ed0B5asBCdKSfxNsddagbajQDWvS+SFfebA87Y0o
	 uAJkG6qOWXM5B9W79XckO2hG+fwu2uEVJ9WaSdRpOegxVIlY/FjeWdef4SZt7f1yvvCE0
	 ZYVbEQm/d79v1zXxG+mziFDq2TUY9mOroQ7ysQtxlGcSac8bWcxv9dcy5DoDandm02A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464610;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=qSqZs6kvQ73jpKV//X6SsqeslDJs9OL8i3dqvINNPv8=;
	b=CEMyVBPJjtDwDNDIIlpCnXl0mz9jOXuGq5Pb7Vpx4PlWTHJ+a2YSXVZD5eMGh3ojjcLl
	 u/obrvi4NKQvylU8p5hESWMLtY6iZOTfG7LO/frkmnm0v4iiEmSyjgm/3XAD3QadNQMFR
	 cyrIqer8XWvXMUaOjSUusPh82NvRVqaoIr8aTlgkr4Z4NCxaY19p04WCy2JjieyKHeURT
	 3B5g7MT0sPQH/r2RWVnSZtJQHek7uJ7QxilPEJr7D7WU7odnap4aIsNFRTsboxdNc1nFK
	 cXMsUWUwMcxINiYXrVGoEelC+Pj5erbj5q9aVO6qOuqJX3DpcHXHuflvNYfmipTJVzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b="Cr+WWcS/";
	arc=none smtp.remote-ip=220.197.31.5
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525C606A334;
	Tue, 20 Oct 2026 02:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2525C606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Cr+WWcS/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=qS
	qZs6kvQ73jpKV//X6SsqeslDJs9OL8i3dqvINNPv8=; b=Cr+WWcS/vDlwgfM9TA
	zmmFWxnFaSAEYN63MwVeOVcDhXvfSNnGubjHlrqRnHSnNrO1vfOkIRVSERO0ttAo
	WuK8zUU5xV1iiA3Rqfk9s4fpu3Lb5lyImNu3vk8JMpjAz42X/hnh/ljCme2SJOO3
	eq+WG1WycGCfdg+MHkLKxM+FY=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr8C+1tZqMLhIBA--.5123S8;
	Tue, 20 Oct 2026 10:49:44 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 6/7] wifi: mt76: mt7996: validate temperature response length
Date: Tue, 20 Oct 2026 10:49:32 +0800
Message-Id: <20261020024933.3205681-7-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnr8C+1tZqMLhIBA--.5123S8
X-Coremail-Antispam: 1Uf129KBjvdXoW7Xw4rAFW3AF48uryDAr1fJFb_yoWDZFg_uw
	na9FnxJr18Kw4UKr42kwsrCryakay8u3Z5C3yrt3yfJay7JFW7ur93Zrn3GrZ2k3Z29F1D
	Grn8Za47Za43ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbG-e7UUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzgg4cmrW1sildwAA38

The temperature query reads a fixed firmware event without checking the
response length. A truncated response can cause an out-of-bounds read.

Require the complete thermal event before accessing its temperature.

Fixes: 6879b2e94172 ("wifi: mt76: mt7996: add thermal sensor device support")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 5391666553d9..d87851c5fc1d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4702,6 +4702,10 @@ int mt7996_mcu_get_temperature(struct mt7996_phy *phy)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < sizeof(*res)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	res = (void *)skb->data;
 	temp = le32_to_cpu(res->temperature);
-- 
2.34.1

