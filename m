Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702DB34752F
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 21:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790543007; cv=none; b=itr9nT9LTe8DGWJ+zV7+HHt7OrXxLj2UrdrZrhSlkG63OdXQuk8MmCJueZ1DU9YY9ZIqDDKv0TNPnoh0WKHkuxWbWHQVnm/jXx9oi5Jb82VKqMVQEcK+p+L74rHMfqB8WRCdWW2GvGTh5xIqguGq8GCJ+RDcIGNgpmthE2L2HlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790543007; c=relaxed/simple;
	bh=MpAYE6Fxuc+UvJx17R79zeNymilRt484na3SOlgHB40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i53LW70XxJ7s19rvnO6zXivt5KDEp9pA30dcNtkt5kmkrenQUT2oKXBJJ7xwLeyfGUR1h4a/lqdR5leFOyMirmHVL+DS1IgqrYfqWSc/YbXJ3KZKXJ9NuIpPueXilLMf2NHZ9uNVgobTC2hU64/qBWbXT0Q0b7BAmj61fc0Asro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-8a87bc01e19so12427577b3.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 14:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790543005; x=1791147805;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EnjocpIIeGqdu9+YauQPign5rooTvBtAV96XTWEwWn8=;
        b=IzGfIDx5+KXIt1axRG2O4rGiNwF0uV1U+KHauOeK8BNrtKmP1IYz+16KeMaqhmi/5x
         iz89PObd/9W6HHn5Ng80FRcvR6yhexDp9jWKkBKcBsXfSSEfwatk2HBx3LLH5FkaJA8A
         uwTlqoZK9I2HnT3h9boRI7cskDGkLpFZGj6JUew3oiEN3eUiahFiQUvIpFN+9Dn0tczE
         YfM9cheVmXs5jS3l/PjtB6v77m5NNBElUz24Tu7sLl7BjW/KARahyWGKEvaFfNantyRr
         bIsWvEqmaSq+HczLK4KuYwTVpOIeU60uJMdXGLHKBuMhvtD9xqCdxmvpKxsvrcs/Iuik
         er2Q==
X-Gm-Message-State: AFq9FYKmnKZkudglG3umgvTruvGM1l5YK9YK7aDCEL7VzsNSCejtrYQj
	zWEV8CRvcVweOGxaIar2Wph4eQgRhEVMFFhxaAbxufL/zIVxuSXJHyjQ
X-Gm-Gg: AYBFou3qfeI1dJ+qIKS4NnaeERKjSL1qDNUaYN86IQPkPBoX9QiAx7fdiH2FIGj1vZM
	eoORJ3gQ0Ql0BRMPFtAbS/Oy/b14n7k6J+YoPeJ2ruuTeunWqO4nW9QUba/hXol7KxAlXaAUW/E
	vmXg2biMbAkC+0lZnS0LGnAIQmIeFtoRCyOWooxKu3ni2sanJay/xv7OXQnI7HtqV9DJzsNkzDf
	Ce6zbzC/PrGs51RhmUSuCajvlIOurcYYpSJocqLzDggOhQU9HGj5sE6j+BcxZSIEx/pOxKTECYL
	qwqMJMmaXfbD4iWwzO2vCLjn1gBa9BB+H1BpyAuNNrMsQdKjaBll110ihtSYIRY3F7vbEFRin2r
	3ZAbXfOEuTFy1YZSCLdZxIhnCouYieN3tZwzKEVoPtLMyUvvg3dVzuc/4YR8syqbEW1BuEvpHYy
	wrxY7pxQxOLj28DxOSFkt+7VRWpJsPoLJLcKtKQnAPIt7K6z7CxcybC2u32Tq1NjLsqRsXn2+pf
	shnPwaiYdLJFQIJNMwn08EhZ9r8lLjRUwC2Rwsvh0ZJUERa7v6KCG7X5EjjP+y3dEOfeg==
X-Received: by 2002:a05:690c:e242:20b0:8a5:9519:c62d with SMTP id 00721157ae682-8a64bb0346dmr38127527b3.12.1790543005496;
        Sun, 27 Sep 2026 14:03:25 -0700 (PDT)
Received: from sean-HP-EliteBook-830-G6.attlocal.net ([2600:1702:5083:7610:5dd7:b9c7:1078:5394])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8a86103149dsm35389017b3.40.2026.09.27.14.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Sep 2026 14:03:24 -0700 (PDT)
From: Sean Wang <sean.wang@kernel.org>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	yu-ching.liu@mediatek.com,
	jenhao.yang@mediatek.com,
	posh.sun@mediatek.com,
	Chengwei Yu <chengwei.yu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 02/23] wifi: mt76: mt7925: add NMI/NDI MAC address setter helpers
Date: Sun, 27 Sep 2026 16:02:44 -0500
Message-ID: <20260927210306.737669-3-sean.wang@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927210306.737669-1-sean.wang@kernel.org>
References: <20260927210306.737669-1-sean.wang@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengwei Yu <chengwei.yu@mediatek.com>

Add mt7925_nan_set_nmi_address() and mt7925_nan_set_ndi_address() for
runtime MAC address changes: NMI goes through the MCU (firmware owns
the hardware address), NDI updates vif->addr directly.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chengwei Yu <chengwei.yu@mediatek.com>
---
 .../net/wireless/mediatek/mt76/mt7925/nan.c   | 48 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7925/nan.h   |  8 ++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 8a59f7b1aee2..abbd3f7b081c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -697,6 +697,54 @@ void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
 	}
 }
 
+int mt7925_nan_set_nmi_address(struct ieee80211_vif *vif,
+			       struct mt792x_dev *dev,
+			       const u8 *mac_address)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	struct {
+		u8 rsv[4];
+		struct mt7925_nan_nmi_addr_tlv nmi_addr_tlv;
+	} nmi_cmd = {
+		.nmi_addr_tlv = {
+			.tag = cpu_to_le16(NAN_UNI_CMD_CHANGE_NMI_ADDRESS),
+			.len = cpu_to_le16(sizeof(struct mt7925_nan_nmi_addr_tlv)),
+		},
+	};
+
+	if (!dev || !vif || !mac_address)
+		return -EINVAL;
+
+	if (is_zero_ether_addr(mac_address) ||
+	    is_multicast_ether_addr(mac_address))
+		return -EINVAL;
+
+	memcpy(nmi_cmd.nmi_addr_tlv.nmi_addr, mac_address, ETH_ALEN);
+
+	return mt76_mcu_send_msg(mdev, MCU_UNI_CMD(NAN), &nmi_cmd,
+				 sizeof(nmi_cmd), true);
+}
+
+int mt7925_nan_set_ndi_address(struct ieee80211_vif *vif,
+			       struct mt792x_dev *dev,
+			       const u8 *mac_address)
+{
+	if (!dev || !vif || !mac_address)
+		return -EINVAL;
+
+	if (is_zero_ether_addr(mac_address) ||
+	    is_multicast_ether_addr(mac_address))
+		return -EINVAL;
+
+	/*
+	 * The NDI address is not managed by firmware; it is the vif's own
+	 * hardware address, so updating it locally is sufficient.
+	 */
+	memcpy(vif->addr, mac_address, ETH_ALEN);
+
+	return 0;
+}
+
 static int mt7925_nan_avail_ctrl_tlv(struct sk_buff *skb,
 				     struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 297c2856578e..9fd349e1cdab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -495,6 +495,14 @@ int mt7925_nan_change_configure(struct ieee80211_vif *vif,
 
 void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb);
 
+int mt7925_nan_set_nmi_address(struct ieee80211_vif *vif,
+			       struct mt792x_dev *dev,
+			       const u8 *mac_address);
+
+int mt7925_nan_set_ndi_address(struct ieee80211_vif *vif,
+			       struct mt792x_dev *dev,
+			       const u8 *mac_address);
+
 void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 				    struct ieee80211_vif *vif);
 
-- 
2.43.0

