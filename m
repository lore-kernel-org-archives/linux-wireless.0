Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6473B47F7;
	Sun, 30 Aug 2026 13:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788095461; cv=none; b=LiDTrl9PPQaDhWBGhto4p581nawbvQAVn0dHMlFcYRDTLUfjSL1M2FI1zWaNVFZptQmn54kB7HcNUOvkO7TRaccdWmXWa0m6VyUs5lNne9opjIgbMwFPlfbuCZc3H9DQ/z4cLlBEGV82VdO90O23L+Wgtsw1/cbhEajwH95rK0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788095461; c=relaxed/simple;
	bh=X4r92/t6pk8o6AWocdvpZdh0ZxRn0z8KXqjbM/EwlPw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pK+A4bUYi4oulIePgBw8rusw4FNyNacsdj8TLds3XJlwiFPaAeSo1rdeAi52TEZDHkVB9xkAoumAf0h7dy46tarP2zZCmj2jWJFc5kvMMVAfTesHtansRTXom0QyGkN+fZK/3vI6zEq9UYALJ1vJmh9Ar/OCRE+pOeGzD7TPXoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-03 (Coremail) with SMTP id rQCowACnrjzbK5Rq7N+aBg--.43594S2;
	Sun, 30 Aug 2026 21:10:52 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Felix Fietkau <nbd@nbd.name>
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
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
Subject: [PATCH] wifi: mt76: mt7615: validate MCU response lengths
Date: Sun, 30 Aug 2026 21:10:49 +0800
Message-ID: <20260830131049.2097-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACnrjzbK5Rq7N+aBg--.43594S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Zry7CryUJw47uF18Jry5urg_yoW5JFWxpF
	WjgFyayr4DJrsFga10vw1ku3yaq3s3tFyaqa4DW3s5J3s5C3WrCF4F9a4Fvr1rJFZ8Cr1r
	Jw4qqrsxuFZ0q3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9I14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r
	4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJb
	IYCTnIWIevJa73UjIFyTuYvjfU5dgADUUUU
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

mt7615_mcu_parse_response() reads the common response header before
checking its size and then consumes command-specific fields after unchecked
skb_pull() calls. A short firmware response can therefore be read beyond
its current extent.

Validate the common header and each command-specific payload before reading
it.

Fixes: 0e6a29e477f3 ("mt76: mt7615: add support to read temperature from mcu")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index ff57ede87f717..084949dd3e94e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -143,18 +143,26 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 			cmd, seq);
 		return -ETIMEDOUT;
 	}
+	if (skb->len < sizeof(*rxd))
+		return -EMSGSIZE;
 
 	rxd = (struct mt7615_mcu_rxd *)skb->data;
 	if (seq != rxd->seq)
 		return -EAGAIN;
 
 	if (cmd == MCU_CMD(PATCH_SEM_CONTROL)) {
+		if (skb->len < sizeof(*rxd) - 4 + sizeof(skb->data[0]))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd) - 4);
 		ret = *skb->data;
 	} else if (cmd == MCU_EXT_CMD(THERMAL_CTRL)) {
+		if (skb->len < sizeof(*rxd) + sizeof(__le32))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		ret = le32_to_cpu(*(__le32 *)skb->data);
 	} else if (cmd == MCU_EXT_QUERY(RF_REG_ACCESS)) {
+		if (skb->len < sizeof(*rxd) + 8 + sizeof(__le32))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		ret = le32_to_cpu(*(__le32 *)&skb->data[8]);
 	} else if (cmd == MCU_UNI_CMD(DEV_INFO_UPDATE) ||
@@ -165,12 +173,16 @@ int mt7615_mcu_parse_response(struct mt76_dev *mdev, int cmd,
 		   cmd == MCU_UNI_CMD(SUSPEND)) {
 		struct mt76_connac_mcu_uni_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt76_connac_mcu_uni_event *)skb->data;
 		ret = le32_to_cpu(event->status);
 	} else if (cmd == MCU_CE_QUERY(REG_READ)) {
 		struct mt76_connac_mcu_reg_event *event;
 
+		if (skb->len < sizeof(*rxd) + sizeof(*event))
+			return -EMSGSIZE;
 		skb_pull(skb, sizeof(*rxd));
 		event = (struct mt76_connac_mcu_reg_event *)skb->data;
 		ret = (int)le32_to_cpu(event->val);

base-commit: 08dbfad3f5040f5bdb6c529da20d6d4e81fefd72
-- 
2.50.1

