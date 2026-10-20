Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=220.197.31.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464620;
	b=OfAIHBf96y4tX4pq7z2D4wlcywp9ZYWdih0EyEE80NJB5mGb6M6h5y5cGaCuo1z+ERzP
	 G8+GZ8LvRpXn5AYA/9SYnVYMjpVa//0WguA8pY+MQyKZo/+WUz9bebK82wJ1IbUyYCorP
	 wukWWg1OXUDJ8HXMm6XjaQN/B7pGHP8QyngVaVULMD+y6JngCCq2Q8D1DQPaHSsvo6FXM
	 B+BHJ1Gd0SQqLCuxLQf6RHr6q+i6i077D+/6Qz8YwI9dl0HUKD34zMVUvrMCjBDjEhZV7
	 QTD0zgWRXqGQxLoCaEYOxusWII6G2smYGO+/9SUbq9CNWF9XwWilq/0WNP1PHC/ns4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464620;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=uD9iLC9u0+i53WqbXenU4Sedkd6VmeyujwIgM/Ul8mg=;
	b=d4qdYERzVOcdFy/jGB4mEdwJvByU5H5NpcJJlqwzI90R9opXq9V0YsRRxYzcjdaxpiCU
	 ni3Wo+Ge/3p/+juZXTG5Oh+3un5AVHlX0Lo7zcy9umrYDB8yQfdA93ldvkHLHrsJfVTqJ
	 PRt34FEfyzNKxebbt4X4tUsRKFRf9qxSjc5Mhk7x1mzLjR6sdKkNogYhBK73TQ4r4dmn1
	 f9CAcCEyouRSSE6o6fLThpdujAcBQFD02BWb+vHuwpUNBRO1xf/L8OtYsQVIBa042Ei16
	 vwf6jPhzsKvjsJkRnfqQWUshCveLwP3WXyrwSr0NaE1mOqVJLFEkGHXvU4kbPHWgs/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Ys3yJNEl;
	arc=none smtp.remote-ip=220.197.31.2
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0013D60A3815;
	Tue, 20 Oct 2026 02:50:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0013D60A3815
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=Ys3yJNEl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=uD
	9iLC9u0+i53WqbXenU4Sedkd6VmeyujwIgM/Ul8mg=; b=Ys3yJNElDXDx/8YhgS
	5kz6NqPdGdOB3IDzNisIIiXWme0srucIdVdUoxGdTKwxoj7V5Y14EkWjKQECDwkT
	WvVHRpgMjBSZ+aZgN2Ck8A/jaWsk6i0P79Bmv+aNl2WwMeWiJQmHFhaXP6NfEBDJ
	AFn6xfXhZhDKISWStm8xFLpis=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr8C+1tZqMLhIBA--.5123S5;
	Tue, 20 Oct 2026 10:49:40 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Evelyn Tsai <evelyn.tsai@mediatek.com>,
	Bo Jiao <Bo.Jiao@mediatek.com>,
	Elwin Huang <s09289728096@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 3/7] wifi: mt76: mt7996: validate EEPROM response lengths
Date: Tue, 20 Oct 2026 10:49:29 +0800
Message-Id: <20261020024933.3205681-4-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnr8C+1tZqMLhIBA--.5123S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxur1xZr1UZrWrWw4rZrWrXwb_yoW5WFWfpF
	y3KFyjyr1rJr1kXr4SyFs2ya4Fg3WrWr13Kw43Wwn8W34aywn5AayFvFyvgr1YkrWUA3W8
	Gw4UtFnrGF90qrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j7a9-UUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbCzQQ3cWrW1sScIQAA3c

The EEPROM query reads fixed event fields and copies EFUSE or external
EEPROM data without checking the firmware response length. A truncated
response or an oversized external data length can cause out-of-bounds
reads.

Validate the fixed event, the requested EFUSE bytes, and both the
external data-length field and its payload before copying data.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Fixes: f456e1f56c4c ("wifi: mt76: add external EEPROM support for mt799x chipsets")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 30 +++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 1f7af6359dd7..eb868c2d5108 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -4399,6 +4399,7 @@ int mt7996_mcu_get_eeprom(struct mt7996_dev *dev, u32 offset, u8 *buf, u32 buf_l
 	};
 	struct mt7996_mcu_eeprom_access_event *event;
 	struct sk_buff *skb;
+	size_t data_offset;
 	int ret, cmd;
 	u32 addr;
 
@@ -4424,9 +4425,14 @@ int mt7996_mcu_get_eeprom(struct mt7996_dev *dev, u32 offset, u8 *buf, u32 buf_l
 	if (ret)
 		return ret;
 
+	data_offset = offsetof(struct mt7996_mcu_eeprom_access_event, eeprom);
+	if (skb->len < data_offset) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	event = (struct mt7996_mcu_eeprom_access_event *)skb->data;
 	if (event->valid) {
-		u32 ret_len = le32_to_cpu(event->eeprom.ext_eeprom.data_len);
 		u32 block = mode == EEPROM_MODE_EXT ? MT7996_EXT_EEPROM_BLOCK_SIZE :
 						      MT7996_EEPROM_BLOCK_SIZE;
 
@@ -4444,16 +4450,35 @@ int mt7996_mcu_get_eeprom(struct mt7996_dev *dev, u32 offset, u8 *buf, u32 buf_l
 		case EEPROM_MODE_EFUSE:
 			if (!buf_len || buf_len > MT7996_EEPROM_BLOCK_SIZE)
 				buf_len = MT7996_EEPROM_BLOCK_SIZE;
+			if (skb->len - data_offset < buf_len) {
+				ret = -EINVAL;
+				break;
+			}
 
 			memcpy(buf, event->eeprom.efuse, buf_len);
 			break;
-		case EEPROM_MODE_EXT:
+		case EEPROM_MODE_EXT: {
+			u32 ret_len;
+
+			if (skb->len - data_offset < sizeof(__le32)) {
+				ret = -EINVAL;
+				break;
+			}
+
+			ret_len = le32_to_cpu(event->eeprom.ext_eeprom.data_len);
+			data_offset += sizeof(__le32);
+			if (ret_len > skb->len - data_offset) {
+				ret = -EINVAL;
+				break;
+			}
+
 			if (!buf_len || buf_len > MT7996_EXT_EEPROM_BLOCK_SIZE)
 				buf_len = MT7996_EXT_EEPROM_BLOCK_SIZE;
 
 			memcpy(buf, event->eeprom.ext_eeprom.data,
 			       ret_len < buf_len ? ret_len : buf_len);
 			break;
+		}
 		default:
 			ret = -EINVAL;
 			break;
@@ -4462,6 +4487,7 @@ int mt7996_mcu_get_eeprom(struct mt7996_dev *dev, u32 offset, u8 *buf, u32 buf_l
 		ret = -EINVAL;
 	}
 
+out:
 	dev_kfree_skb(skb);
 
 	return ret;
-- 
2.34.1

