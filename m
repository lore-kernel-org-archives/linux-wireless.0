Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607483939B1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785596028; cv=none; b=Z6JRCDIvXkctBqTj7p/YkiOU4e8erlaexuOzDUPhoAMV8mnQczTN5r4Nb7fuhFUZmApdCKO7tF1Mq6y7bxw1Zh3jN+6AN7mlSVJCEkxwkYHW6YFhObQIXSVsuTjiWP+jC/vNELZruDwB9mHTM8ErtWeBxzqxSi1J2aRQ8mNVu98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785596028; c=relaxed/simple;
	bh=5Ute1sbGfGFRceve8ol7fk11zQqcuBKRh1vLvHfnIaI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V69Py2lSs7lTF0eszijLJxZMNkV2dkK+yZpwELyBH/s6pqFw8bC9BkGMNQAc5tbOrcuzw/ED8G8tncAa7FMQGekJmQpZdIzzFAvohQCGMzFgUFHbP+YNbtISh5OQGhsA1xJVQo56Br5Azx+zX7h9KDlhDqR4OG8IdY8yd03wwkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=t+XBsueT; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="t+XBsueT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oDAuX3XcyC2qKMD6H08sgScd5EuDkGy+eCyyMxEhRcw=; b=t+XBsueTSepqyyST1yUOmUDCuD
	9d9PZ397eTTvQA2PKOBxlTXcFfSojVoSQTdJzaiajlSF+HNeFXytCJ6pepnS+02Go981yhvFzJ2Aj
	e9mcAzXuWJdTHVKquTM1WUDUay/Limc+TeOlZ4RYfeThiBCmMhNV4E28FVLAVj0SKpt4=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wqB5l-009znC-2D
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 16:53:37 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 03/10] wifi: mt76: mt7996: handle UNI PS sync events
Date: Sat,  1 Aug 2026 14:53:27 +0000
Message-ID: <20260801145334.1166751-3-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260801145334.1166751-1-nbd@nbd.name>
References: <20260801145334.1166751-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable MT_DRV_HW_PS_BUFFERING and handle MCU_UNI_EVENT_PS_SYNC with
all three TLV formats (single client, multi-client packed entries,
and bitmap).

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/mcu.c   | 86 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/mcu.h   | 33 +++++++
 .../net/wireless/mediatek/mt76/mt7996/mmio.c  |  3 +-
 3 files changed, 121 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 8aab91810135..cd7587ce5b8a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -826,6 +826,89 @@ mt7996_mcu_wed_rro_event(struct mt7996_dev *dev, struct sk_buff *skb)
 	}
 }
 
+static void
+mt7996_mcu_ps_transition(struct mt7996_dev *dev, u16 wcid_idx, bool ps)
+{
+	struct mt76_wcid *wcid;
+
+	wcid = mt76_wcid_ptr(dev, wcid_idx);
+	if (!wcid || !wcid_to_sta(wcid))
+		return;
+
+	mt76_sta_ps_transition(&dev->mt76, wcid, ps);
+}
+
+static void
+mt7996_mcu_rx_ps_sync(struct mt7996_dev *dev, struct sk_buff *skb)
+{
+	struct mt7996_mcu_ps_sync_event *event = (void *)skb->data;
+	struct tlv *tlv;
+	int len;
+
+	if (skb->len < sizeof(*event))
+		return;
+
+	skb_pull(skb, sizeof(*event));
+
+	len = skb->len;
+	while (len >= sizeof(*tlv)) {
+		u16 tag, tag_len;
+
+		tlv = (struct tlv *)skb->data;
+		tag = le16_to_cpu(tlv->tag);
+		tag_len = le16_to_cpu(tlv->len);
+		/* a tag_len below the header size would not advance the buffer */
+		if (tag_len < sizeof(*tlv) || tag_len > len)
+			break;
+
+		switch (tag) {
+		case UNI_PS_CLIENT_INFO: {
+			struct mt7996_mcu_ps_client_info *info = (void *)tlv;
+
+			if (tag_len < sizeof(*info))
+				break;
+
+			mt7996_mcu_ps_transition(dev,
+						 le16_to_cpu(info->wlan_idx),
+						 info->ps_bit);
+			break;
+		}
+		case UNI_PS_MULTI_CLIENT_INFO: {
+			struct mt7996_mcu_ps_multi_client_info *info = (void *)tlv;
+			u16 cnt;
+			int i;
+
+			if (tag_len < sizeof(*info))
+				break;
+
+			cnt = min_t(u16, le16_to_cpu(info->sta_cnt),
+				    (tag_len - sizeof(*info)) / sizeof(info->sta_ps_info[0]));
+			for (i = 0; i < cnt; i++) {
+				u16 entry = le16_to_cpu(info->sta_ps_info[i]);
+
+				mt7996_mcu_ps_transition(dev,
+					FIELD_GET(MT7996_PS_MULTI_WCID, entry),
+					!!(entry & MT7996_PS_MULTI_PS_BIT));
+			}
+			break;
+		}
+		case UNI_PS_MULTI_CLIENT_INFO_BITMAP: {
+			u8 *bitmap = tlv->data;
+			int bitmap_len = tag_len - sizeof(*tlv);
+			int i;
+
+			for (i = 0; i < bitmap_len * 8; i++)
+				mt7996_mcu_ps_transition(dev, i,
+					!!(bitmap[i / 8] & BIT(i % 8)));
+			break;
+		}
+		}
+
+		skb_pull(skb, tag_len);
+		len -= tag_len;
+	}
+}
+
 static void
 mt7996_mcu_uni_rx_unsolicited_event(struct mt7996_dev *dev, struct sk_buff *skb)
 {
@@ -847,6 +930,9 @@ mt7996_mcu_uni_rx_unsolicited_event(struct mt7996_dev *dev, struct sk_buff *skb)
 	case MCU_UNI_EVENT_WED_RRO:
 		mt7996_mcu_wed_rro_event(dev, skb);
 		break;
+	case MCU_UNI_EVENT_PS_SYNC:
+		mt7996_mcu_rx_ps_sync(dev, skb);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
index 1487d33a8dbb..74b70fb6da3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
@@ -293,6 +293,39 @@ enum  {
 	UNI_WED_RRO_BA_SESSION_DELETE,
 };
 
+struct mt7996_mcu_ps_sync_event {
+	struct mt7996_mcu_rxd rxd;
+
+	u8 bss_idx;
+	u8 __rsv[3];
+} __packed;
+
+struct mt7996_mcu_ps_client_info {
+	__le16 tag;
+	__le16 len;
+	u8 ps_bit;
+	u8 __rsv;
+	__le16 wlan_idx;
+	u8 buffer_size;
+	u8 __rsv2[3];
+} __packed;
+
+struct mt7996_mcu_ps_multi_client_info {
+	__le16 tag;
+	__le16 len;
+	__le16 sta_cnt;
+	__le16 sta_ps_info[];
+} __packed;
+
+#define MT7996_PS_MULTI_WCID	GENMASK(10, 0)
+#define MT7996_PS_MULTI_PS_BIT	BIT(15)
+
+enum {
+	UNI_PS_CLIENT_INFO = 0,
+	UNI_PS_MULTI_CLIENT_INFO = 1,
+	UNI_PS_MULTI_CLIENT_INFO_BITMAP = 2,
+};
+
 struct mt7996_mcu_thermal_notify {
 	struct mt7996_mcu_rxd rxd;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index ac81be5fe023..fbfbb96a742f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -838,7 +838,8 @@ struct mt7996_dev *mt7996_mmio_probe(struct device *pdev,
 		.link_data_size = sizeof(struct mt7996_vif_link),
 		.drv_flags = MT_DRV_TXWI_NO_FREE |
 			     MT_DRV_AMSDU_OFFLOAD |
-			     MT_DRV_HW_MGMT_TXQ,
+			     MT_DRV_HW_MGMT_TXQ |
+			     MT_DRV_HW_PS_BUFFERING,
 		.survey_flags = SURVEY_INFO_TIME_TX |
 				SURVEY_INFO_TIME_RX |
 				SURVEY_INFO_TIME_BSS_RX,
-- 
2.53.0

