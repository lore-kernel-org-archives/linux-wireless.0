Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343153ACA7B
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708782; cv=none; b=HmW0WIXeffQN52c2xWkEJPdYYPR6ZnuzOVeCD88LWdcg1nTeBz12lYvox/9ycjUIDvAs0PmDi30D7oeaWECNeVnDAF17F9MGSZMrn2MAzoYTF5iGamMEDeA9NDeqcGS4IAZvzCxmqu0gTGa9Ml2fk9C4KfBlVyAvISBJBv4ELM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708782; c=relaxed/simple;
	bh=jCAegO7js1875fsdbyCkjukvL9khcZPdHZJ44xYSlLM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+Y4YNxHy3pIHDWyYdHxYy5Dgsg1A5pJQ3w6SomWKp8iXSg28cFqFzgJKCNyTbqC2v1iLeLGCRsgdgD6X9hV+MvA91MJcK3CiS8x3KcPiZyZyxD2yO7H/7o0E63AqOWjT0wvTXg+kaaciAoPyvjVjBoFUxPEVVs9nJEbf+arZFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=OrHIIBsN; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="OrHIIBsN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=StXxBl8uCzRky2wBeyIKWSNIRgt8kUN7TTCWtS5j0iI=; b=OrHIIBsNYlyWbBBJfvf49JJ7ES
	yfYI/U5+agDHULyid/Jd+qOkWXmKtr03GzJjqOWUeWuOo3Tn+AhrkunffsClOkY4Mw5LGC0BqQpiQ
	obECoz/wTPiKcGgPTkYJk0KtoWZrxYePnxB32v4Or7EppCSyQ1w8DmjCvMSeyqbg93ZY=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHP-005AHx-1C
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 03/18] wifi: mt76: mt7996: fix MLD ID in MAC TXD and HIF TXP
Date: Wed, 22 Jul 2026 08:25:55 +0000
Message-ID: <20260722082610.2699628-3-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722082610.2699628-1-nbd@nbd.name>
References: <20260722082610.2699628-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Peter Chiu <chui-hao.chiu@mediatek.com>

Problem:
MCU command timeout while the firmware state is normal, and the
firmware keeps showing the error log "ERROR!! NO PAUSE...".

Root cause:
If the MLD_ID field in the TXD is neither the primary link id nor the
secondary link id, it may lead to a firmware busy loop when the third
link is in power saving mode.

Remap frames directed to a third link to the primary link wcid. Since
TX status events and txfree completions carry the wcid the firmware
saw, use the remapped wcid for packet id tracking and non-AQL packet
accounting as well, while the frame keeps its original link context
for addressing, band and OMAC selection.

Fixes: 85cd5534a3f2 ("wifi: mt76: mt7996: use correct link_id when filling TXD and TXP")
Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 29 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/main.c  |  2 +-
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index cf7b65684b94..eea53aa55e4f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -858,6 +858,33 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 		txwi[6] |= cpu_to_le32(MT_TXD6_DIS_MAT);
 }
 
+/* The WLAN_IDX in the TXD and TXP must belong to the primary or secondary
+ * link of an MLD station; any other link id can make the firmware spin when
+ * that link is in powersave. Completion events carry the same index, so the
+ * wcid used for status tracking and accounting must match it
+ */
+struct mt76_wcid *mt7996_get_tx_wcid(struct mt76_wcid *wcid)
+{
+	struct mt7996_sta_link *msta_link;
+	struct mt7996_sta *msta;
+
+	if (!wcid->sta)
+		return wcid;
+
+	msta_link = container_of(wcid, struct mt7996_sta_link, wcid);
+	msta = msta_link->sta;
+
+	if (!msta || wcid->link_id == msta->seclink_id ||
+	    wcid->link_id == msta->deflink_id)
+		return wcid;
+
+	msta_link = mt7996_sta_link(msta, msta->deflink_id);
+	if (msta_link)
+		return &msta_link->wcid;
+
+	return wcid;
+}
+
 void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key, int pid,
@@ -1095,6 +1122,8 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 					   tx_info->buf[1].len, DMA_TO_DEVICE);
 	}
 
+	wcid = mt7996_get_tx_wcid(wcid);
+
 	pid = mt76_tx_status_skb_add(mdev, wcid, tx_info->skb);
 	memset(txwi_ptr, 0, MT_TXD_SIZE);
 	/* Transmit non qos data by 802.11 header and need to fill txd by host*/
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/main.c b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
index d9df17a21f06..ea5ad495664a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/main.c
@@ -1579,7 +1579,7 @@ static void mt7996_tx(struct ieee80211_hw *hw,
 		if (msta_link)
 			wcid = &msta_link->wcid;
 	}
-	mt76_tx(mphy, control->sta, wcid, skb);
+	mt76_tx(mphy, control->sta, mt7996_get_tx_wcid(wcid), skb);
 unlock:
 	rcu_read_unlock();
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 5f5a093283c9..2a0cdb56f822 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -873,6 +873,7 @@ bool mt7996_mac_wtbl_update(struct mt7996_dev *dev, int idx, u32 mask);
 void mt7996_mac_reset_counters(struct mt7996_phy *phy);
 void mt7996_mac_cca_stats_reset(struct mt7996_phy *phy);
 void mt7996_mac_enable_nf(struct mt7996_dev *dev, u8 band);
+struct mt76_wcid *mt7996_get_tx_wcid(struct mt76_wcid *wcid);
 void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_key_conf *key, int pid,
-- 
2.53.0

