Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464398;
	b=iyCk9ERbyWlpa0o9z0E0Yo229HrVB2haK330S7B/RwifNdcRTfpdw2Fhq5cG8BGeA0wO
	 9ehuhOxgp9aiuqTLyvR3fK7boGC/ucD0Cv47zILedTYRAqRltQkZOE/O2wdc4zAu69X5b
	 Fo39OBubpnbw86Ln2vxScQtcl3BIQx+LnihFUI5NJ8xdsQ6pk31D6n6Gpnw2YBoAol7Yo
	 IOnWDC8HpAhCuTQkyvykJilD17DK1fj7Ow+jwdmadu8tfVOw89Z/M8YdwnV+iHyOnTkPI
	 8zydEohs7b7oePS1SI4DSHwkI0ejlKzxDMV8YP0HFAmGrotRa119uASBO2lHpz9brkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=cb9ewf3o3LE8X+Qeg+i0VTACWRFyz4Qa+t6SXIrAGc0=;
	b=eJfj/q7gUNqmaX0j2FelFrczA6LtBzF1X1iWysnlKu7AUU9mEaVs9kn/K5LqmLlwuQUt
	 oKJxNeCR28qPdfjWJWAefS6ozAC6RvhNqCop/p/7mBEjj/qA70hvuMweP5Cbt4OMCRL6B
	 gCCjfL8K0Nv15eU2ebn6S9WSCabn+qT1LgmWCQHPhmryc1INW6WDGk8Gi6GgnfHgsdp3J
	 kqecN6WH65Bg1O2KmN2vJ+1BpKxKMbvN+EI3gdDIf+GRP1gTih+k3HBCmTEX2+0DOImVR
	 ZGHSbfhxr1BGFHzfMPde71Y5rwcZzVpmGVDXnj2m66K3sd+2uA2YqEIX+FHUTAR8ruA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=XPonYUPZ;
	arc=none smtp.remote-ip=117.135.210.3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A5D606A327;
	Tue, 20 Oct 2026 02:46:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5A5D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=XPonYUPZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=cb
	9ewf3o3LE8X+Qeg+i0VTACWRFyz4Qa+t6SXIrAGc0=; b=XPonYUPZzhgmzkdkXw
	ad6gx6Y8ilyg+c4YFZR6D6CnB1FQY1xh5mLBDTfupWpTKuT2dOOVrN9RS1FNBIWh
	74x3t4bMLdwAyFHg8FRYvtape4970kVw2DhfkcfS2YxaWMHjKjU/i56NiO2Grdqp
	gdUlUzcVYeqBIzZZ88ZErjIwc=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S10;
	Tue, 20 Oct 2026 10:45:58 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Deren Wu <deren.wu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 08/11] wifi: mt76: mt7925: validate temperature response length
Date: Tue, 20 Oct 2026 10:45:40 +0800
Message-Id: <20261020024544.3101738-9-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S10
X-Coremail-Antispam: 1Uf129KBjvdXoW7Gr1DCF1furW8Xr4UCrW3KFg_yoWkCrc_ur
	n2vr97Jr18Gwn8Kr42krW7GF90k395uF1rurWrtrWfX3y7JFWxurZ3Zrn7GrZFkwn7ZF98
	Crn8Aa42q343ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbW8BUUUUUU==
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC8Ab+OWrW1eYclAAA32

The temperature query removes a fixed prefix and TLV header and then
reads the event without validating the response length. A truncated
firmware response can cause an out-of-bounds read.

Require the prefix, TLV header, and complete temperature event before
pulling the skb.

Fixes: 396e41a74a88 ("wifi: mt76: mt7925: support temperature sensor")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index e5cacb12d367..d768002c64c2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -1037,6 +1037,10 @@ int mt7925_mcu_get_temperature(struct mt792x_phy *phy)
 					&req, sizeof(req), true, &skb);
 	if (ret)
 		return ret;
+	if (skb->len < 4 + sizeof(struct tlv) + sizeof(*evt)) {
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
 
 	skb_pull(skb, 4 + sizeof(struct tlv));
 	evt = (struct mt7925_thermal_evt *)skb->data;
-- 
2.34.1

