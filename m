Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792464606;
	b=Evoi70ibsx1IA+Kt5CjMEV4272HhBielBdC2KwAseUpsJZJH10LleDYiMtGpld9xd6JH
	 Kn2RD2kg3aGngzW9UWOMIusopkHvSi2V19xowDYks9mU/sfDtaB+WnGhTOz1LIT4fAFv5
	 MkL26DC3anQKk4rGBfBRLn9w48V1uYXKOjG1WCVSwgQsmvKhyDdYwo7R4wMsmUxE8cgJV
	 1gqPX60kVfk29BIHC6XIjmOUksLsve/r1a4LOolm5AWmmbCJk6Vbde4b1X8EI5a1fuRlD
	 oZPleSAmyMGQkopNj72nkiGF3K4/QDB0lHQDv7ZQ2mpgb/Jjg+gD6UCu9sdPwmX67zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792464606;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=7ASGar675lziP9Lhne+zcfjAyNbEwAZOOXLcfTSeQQE=;
	b=Rsr9oq9HTTovUK2U1RI8iE5Y/CfOGuPSgSYyaYG5/yJYJRI5MM1IKSyt6Lgmi5vQaHM5
	 ouKGVYqgN/iLSvZrPdi2+qoNW5b2c+5a3m8PI4MFZ3gacRHYCuCZq05oBkvdm2cD5czTZ
	 jxbGTXKZplRrKR590wd7ROwSrO0FnZrfynqUe671k6H+nivuF/o8ZuRf34VmSpRiy6Xby
	 AmBux20d7g+ZK+7UQMSNfbZLiSgUo+8DjvSF6degO83VNcXYGziqY20MCQbVQd59AYrJJ
	 KkiiSBaE7KEfbZsjDvvG9XXaB0RUNJeb+/uKgQvnNFuJIiQbyXdx5XkuXjHBlKvIDeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=VX7JUUPE;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75B3606A31A;
	Tue, 20 Oct 2026 02:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C75B3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=VX7JUUPE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=7A
	SGar675lziP9Lhne+zcfjAyNbEwAZOOXLcfTSeQQE=; b=VX7JUUPE9xnLdJKjsX
	LI090qXDvHxi4ugkSicQnypg6OEDAibZAdFmluCovYljojP5Rop+Kw07mhwKJ66h
	fmoHy3/Bj6a/mGElxinKTB8Y7/1ALeZFBUivAcSlMzjXhvlQKA9ukRAyKrgmZn+p
	JhHQrtNQflIr9mMijevkbDFQc=
Received: from pc.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDnr8C+1tZqMLhIBA--.5123S4;
	Tue, 20 Oct 2026 10:49:39 +0800 (CST)
From: Jiale Yao <yaojiale02@163.com>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	MeiChia Chiu <meichia.chiu@mediatek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH 2/7] wifi: mt76: mt7996: bound IE countdown event parsing
Date: Tue, 20 Oct 2026 10:49:28 +0800
Message-Id: <20261020024933.3205681-3-yaojiale02@163.com>
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
X-CM-TRANSID:_____wDnr8C+1tZqMLhIBA--.5123S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxGr15Xw1fZr1DXryUurWUtwb_yoW5CrWrpa
	4j9a4Fq3ykAr4UWr18ArWvyay5twn5K3Way3yvyws0qFn2kr1kJF48XFyjvr4Yka43uw17
	Xr1j9wnrCFn5Zr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U_UUbUUUUU=
X-CM-SenderInfo: x1dryxhdohiji6rwjhhfrp/xtbC7wM2cGrW1sOS6gAA37

The IE countdown handler reads its fixed header before checking the skb
length. Its TLV loop also accepts lengths smaller than the TLV header or
larger than the remaining data and reads the event payload unchecked.

Validate the fixed fields and constrain every TLV and known countdown
payload to the response buffer.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
---
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 38 ++++++++++++++-----
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index d661ff1e4a20..1f7af6359dd7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -489,12 +489,20 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 		u8 band;
 		u8 rsv[3];
 	};
-	struct mt7996_mcu_rxd *rxd = (struct mt7996_mcu_rxd *)skb->data;
-	const char *data = (char *)&rxd[1], *tail;
-	struct header *hdr = (struct header *)data;
-	struct tlv *tlv = (struct tlv *)(data + 4);
+	struct mt7996_mcu_rxd *rxd;
+	const char *data, *tail;
+	struct header *hdr;
+	struct tlv *tlv;
 	struct mt7996_mcu_countdown_notify *event;
 	struct mt7996_mcu_countdown_data cdata;
+	u16 tlv_len;
+
+	if (skb->len < sizeof(*rxd) + sizeof(*hdr))
+		return;
+
+	rxd = (struct mt7996_mcu_rxd *)skb->data;
+	data = (char *)&rxd[1];
+	hdr = (struct header *)data;
 
 	if (hdr->band >= ARRAY_SIZE(dev->mt76.phys))
 		return;
@@ -505,18 +513,29 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 
 	tail = skb->data + skb->len;
 	data += sizeof(*hdr);
-	while (data + sizeof(*tlv) < tail && le16_to_cpu(tlv->len)) {
-		event = (struct mt7996_mcu_countdown_notify *)tlv->data;
-
-		cdata.omac_idx = event->omac_idx;
+	while (tail - data >= sizeof(*tlv)) {
+		tlv = (struct tlv *)data;
+		tlv_len = le16_to_cpu(tlv->len);
+		if (tlv_len < sizeof(*tlv) || tlv_len > tail - data)
+			return;
 
 		switch (le16_to_cpu(tlv->tag)) {
 		case UNI_EVENT_IE_COUNTDOWN_CSA:
+			if (tlv_len < sizeof(*tlv) + sizeof(*event))
+				return;
+
+			event = (struct mt7996_mcu_countdown_notify *)tlv->data;
+			cdata.omac_idx = event->omac_idx;
 			ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
 					IEEE80211_IFACE_ITER_RESUME_ALL,
 					mt7996_mcu_csa_finish, &cdata);
 			break;
 		case UNI_EVENT_IE_COUNTDOWN_BCC:
+			if (tlv_len < sizeof(*tlv) + sizeof(*event))
+				return;
+
+			event = (struct mt7996_mcu_countdown_notify *)tlv->data;
+			cdata.omac_idx = event->omac_idx;
 			ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
 					IEEE80211_IFACE_ITER_RESUME_ALL,
 					mt7996_mcu_cca_finish, &cdata);
@@ -525,8 +544,7 @@ mt7996_mcu_ie_countdown(struct mt7996_dev *dev, struct sk_buff *skb)
 			break;
 		}
 
-		data += le16_to_cpu(tlv->len);
-		tlv = (struct tlv *)data;
+		data += tlv_len;
 	}
 }
 
-- 
2.34.1

