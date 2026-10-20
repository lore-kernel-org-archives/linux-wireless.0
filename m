Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464398;
	b=RHFgkmtdtbXJV3l2DA/gkNwbHnm+EigWS/4nl+a1q+VPGfWrUVUbn+pcQpVH/D2u9IIa
	 DKPB4juSGe4Mpx94uEQHC3cYnu4Zdymib1MawKYToNvVoKxSowM6qa/gwDBvu/T3qZF31
	 oBE2UBiHJ/ddqtM/Ha/bFMiJGg8wrif3+wKOhMhMNT+5nri4+L03aaJ/Fn1N42zBbvs/m
	 Q5SOYLYNvD/QPrIqrMp8gY56rWUD1k4jx1FsWtHdOF0GW+wdds1k8z4B7p5P+32au4wV/
	 GMjqW/jYKS7H9zq9a/pLBa7xmDhw7IuMy5jmYqx5qVUCqamWcsq++kfrBlfgffr4AGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464398;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=qs8cAxhySWBLyThS4ZeIA5H/vVY6IeEZqZKTZ+G87Dk=;
	b=3/Ct1YX/AjyLdl0+mNOxK56FK2JBhk9aAfdX/j1lCvv877M7YiM45sY/RIKguNvnnhHc
	 eKSc2raBhAPYY/ZDtDG4cz5/3uQeACRiInzGuXMTjbx8cLzR/cDBngu9h1Jpbt4BADais
	 j10v8fjzKdduqmFkDhpv2I9XakFnFERc7XdoJxvml4iD0EneArNYScHFtyz9KkkPGZ2sQ
	 3iK6RT7I89lqDvx/qp6jsU4nJxl26Pm4D3aqQREs8LCd0qU2W09qsknYYp88mMETkYvHD
	 oJtTIwMVbnamrg7+hESYg+7w2S9WX5UU+9XH0R6F0viJc7qHsmdc9DNFvJSpZtBgIBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=MIfIiYqP;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B70D606A31E;
	Tue, 20 Oct 2026 02:46:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B70D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=MIfIiYqP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=qs
	8cAxhySWBLyThS4ZeIA5H/vVY6IeEZqZKTZ+G87Dk=; b=MIfIiYqPZ+OUUruick
	eS45VmzaiTWCBPK7QMmD7e+7KqAAc7jLH3ZZ0G7QtVAeSQIPghwaOyZMJ3etO+4V
	9fG6Vs5PuFkeBlImlkYS4KycTD2Ea0RI4LPjFmAySSEEOg6hUPEPpl1zcyarIcf9
	P5IeNUi7ooKTFNU9SmWtv6A9g=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3H9HZ1dZq2OtmBQ--.60682S3;
	Tue, 20 Oct 2026 10:45:48 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Soul Huang <Soul.Huang@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 01/11] wifi: mt76: mt7921: validate MCU response lengths
Date: Tue, 20 Oct 2026 10:45:33 +0800
Message-Id: <20261020024544.3101738-2-yaojiale02@163.com>
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
X-CM-TRANSID:_____wD3H9HZ1dZq2OtmBQ--.60682S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxXryDWFy7CF17tF18GF13twb_yoW5XF15pF
	WYgas8KryUJrsFgw109F4kAa15twn5JFnrtFy8uwnYqrW3A3Z8GF4F9FyYvr15tFZ5CF1r
	Jw4vq3ZxWrWDXwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UHUDXUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzhz8N2rW1dyLCQAA3u

The MCU parser reads receive descriptor and command payload fields
without checking whether they are present. Truncated firmware responses
can therefore cause out-of-bounds reads.

Validate the descriptor and each command-specific payload before
accessing or removing it from the skb.

Fixes: 1c099ab44727 ("mt76: mt7921: add MCU support")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 40546005c743..782c8baaf776 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -26,6 +26,13 @@ int mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 
 		return -ETIMEDOUT;
 	}
+	if ((cmd == MCU_CMD(PATCH_SEM_CONTROL) ||
+	     cmd == MCU_CMD(PATCH_FINISH_REQ)) &&
+	    skb->len < sizeof(*rxd) - 4 + sizeof(u8))
+		return -EINVAL;
+	if (cmd != MCU_CMD(PATCH_SEM_CONTROL) &&
+	    cmd != MCU_CMD(PATCH_FINISH_REQ) && skb->len < sizeof(*rxd))
+		return -EINVAL;
 
 	rxd = (struct mt76_connac2_mcu_rxd *)skb->data;
 	if (seq != rxd->seq)
@@ -36,6 +43,9 @@ int mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		skb_pull(skb, sizeof(*rxd) - 4);
 		ret = *skb->data;
 	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
+		if (skb->len < sizeof(*rxd) + 4 + sizeof(__le32))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd) + 4);
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else if (cmd == MCU_UNI_CMD(DEV_INFO_UPDATE) ||
@@ -46,6 +56,9 @@ int mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		   cmd == MCU_UNI_CMD(SUSPEND)) {
 		struct mt76_connac_mcu_uni_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt76_connac_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
@@ -55,12 +68,18 @@ int mt7921_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 	} else if (cmd == MCU_CE_QUERY(REG_READ)) {
 		struct mt76_connac_mcu_reg_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt76_connac_mcu_reg_event *)skb->data;
 		ret = (int)le32_to_cpu(event->val);
 	} else if (cmd == MCU_EXT_CMD(WF_RF_PIN_CTRL)) {
 		struct mt7921_wf_rf_pin_ctrl_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EINVAL;
+
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt7921_wf_rf_pin_ctrl_event *)skb->data;
 		ret = (int)event->result;
-- 
2.34.1

