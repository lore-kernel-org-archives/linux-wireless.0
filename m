Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464398;
	b=Uloq4ECvRs65Mipy5OfKU/MZwF1euieCnQiMqU/d9U0t2txqILC9p6bOVxC/f41h41TW
	 3XKlUP3o9uMZEP4ZHRbCCvnX/uke6J4OAQ96BhSzsjVD9dnw7NQQotmd9vjhlwCFu6eAp
	 Q9VqfsqOi9gFFyIk+EG//VOhVi1bDUXgEMVM7w57qvKtELW/VX8DaCPpuc+8LpJBa696y
	 ivmNPIQw2YPRQ8u/x+ZL+ZgGUvJQ0p+eDHuxOBfLgGhGUOSREH0yYv7MyObxNCayHz5gN
	 x41QyEUOBw/UVnQd/xHvWdIYTt8e/UBcRbrh1M7dOSoc44B4jArhe7si8HNbfGWGRJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=f7Pzuz7LE/Ym3T5iLUPnrRl+jMU1QyIKfb/Jk5nU0JY=;
	b=E3Jh//KMOUgk49LOmiX+mev/kZzuVp6gjaLvhx+7M6R3oT00xqUpbdtlz4l4iPHbRC3x
	 lP6SFemiDOhuO4r9f4U6uS2qk9Zf+ozAUZvtjTOzPxKxZJxRg8+cYSnySUlU7jk+/4LNh
	 /1LhqrdPNZCV76RMtZeRNuYlPM21QypJ/uJOutFwJ9Bg8frAmebE00sknHjdggeG3D9wP
	 2UitgN+Jb+91oOIqPrhgdQEppqPU1s33+vHVLiQJF27/LzXK1XrGU1ry3InG02Lx94aRG
	 GieLy9VN6YPdgR6zCGI3tPeQYdY3Df3vj8z9zfsEjaQCPOfbYLauyq3YnpMctE7vGTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=OYDLZ7sX;
	arc=none smtp.remote-ip=220.197.31.3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE4606A32E;
	Tue, 20 Oct 2026 02:46:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AAAE4606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=OYDLZ7sX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=f7
	Pzuz7LE/Ym3T5iLUPnrRl+jMU1QyIKfb/Jk5nU0JY=; b=OYDLZ7sXNHapi0fR65
	FOlODgEfr8fwz3OofDGQsVoabF2NQq3hDbHj9LkOEzXLjJzdjeGHsvzfNwRQ252o
	ONyOxWiQrmEfXBRlggIGpqz2yM1DpPx/OR01/QJ2iHIo5nr9/A42fFjVZIlPcWo1
	GsQ/omq140ZFlESL7Ra2pESnc=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S7;
	Tue, 20 Oct 2026 10:45:54 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Hao Zhang <hao.zhang@mediatek.com>,
	Leon Yen <leon.yen@mediatek.com>,
	Mingyen Hsieh <mingyen.hsieh@mediatek.com>,
	Rong Yan <rong.yan@mediatek.com>,
	Nelson Yu <nelson.yu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 05/11] wifi: mt76: mt7925: validate MCU response lengths
Date: Tue, 20 Oct 2026 10:45:37 +0800
Message-Id: <20261020024544.3101738-6-yaojiale02@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261020024544.3101738-1-yaojiale02@163.com>
References: <20261020024544.3101738-1-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S7
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw4rGryUXrWDXw1kCrW3Jrb_yoW8CrWxpF
	W2ga4akryUJrsrWw4093Z7Z3yYq3Z5GFnrJrWxXwn5XrZ5Aa4rGFWYvFy2vr4rAFZ5CF1r
	Gw4vv3W3WF98X3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ug2-OUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wL9OGrW1eJ6BwAA3e

The MCU parser reads receive descriptor and UNI event fields without
checking whether they are present. Truncated firmware responses can
therefore cause out-of-bounds reads.

Account for the shorter patch responses and validate all other receive
descriptors and UNI event payloads before accessing them.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index fa29c486a455..bca753d8ce71 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -32,6 +32,17 @@ int mt7925_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 
 		return -ETIMEDOUT;
 	}
+	if ((cmd == MCU_CMD(PATCH_SEM_CONTROL) ||
+	     cmd == MCU_CMD(PATCH_FINISH_REQ) ||
+	     cmd == MCU_CMD(CB_PATCH_SEM_CONTROL) ||
+	     cmd == MCU_CMD(CB_PATCH_FINISH_REQ)) &&
+	    skb->len < sizeof(*rxd) - 4 + sizeof(u8))
+		return -EINVAL;
+	if (cmd != MCU_CMD(PATCH_SEM_CONTROL) &&
+	    cmd != MCU_CMD(PATCH_FINISH_REQ) &&
+	    cmd != MCU_CMD(CB_PATCH_SEM_CONTROL) &&
+	    cmd != MCU_CMD(CB_PATCH_FINISH_REQ) && skb->len < sizeof(*rxd))
+		return -EINVAL;
 
 	rxd = (struct mt7925_mcu_rxd *)skb->data;
 	if (seq != rxd->seq) {
@@ -60,6 +71,9 @@ int mt7925_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		   cmd == MCU_UNI_CMD(NAN)) {
 		struct mt7925_mcu_uni_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt7925_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
-- 
2.34.1

