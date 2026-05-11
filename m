Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66088364EB8
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2026 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778524337; cv=none; b=G2JVjruiV7/5elHieRgFZtpM0NFX4rkdhJVo6iP+thAW5NFXg4QXeVp5uoTGBQZrV29SatHcqk3XYqIO7QFwRjMbqvcf2cVurSltkBI2tTkmBwfYEWh1qcAfeYdDPARYRBRLeyoiZxeXdOQJnJ4lBplqi4uQWe57lJCPvNXKG90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778524337; c=relaxed/simple;
	bh=U7DyHDFWsODzrIE5Y5zvUxa2K2N31v7JVT1aqndTGfk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LQ4IzjlfqAFoO+pKK6G6ck6hmRM5tvm3sdmaWaZ3Y616ioh1Vnyqqji20rnf9S8wADDjF/wLZDF8w2Sekmn2R1ipP5sNRVeZTuevld+jlKQKXktv/YU9tpBSAIENtWkSjQ1WyWhcb0/lIhUQvxrfYgWRDePyQksNIHRsc3cWBAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jlTNHED6; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jlTNHED6"
X-UUID: b84117564d6711f1b96f91537e34a508-20260512
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=euveLJGxSvPWJZ9qF7eSEYwUYjl8arjj3nB8s2YoTmk=;
	b=jlTNHED6xHfLdzPUt2j+xAZu67e+ISIgwpA6aHj+k0/C1+kpR3eF98ubEH1nrwiQAfqTWTdv2DSCG/IAlAXRbnpNBXKDs4HPXwvCkwmcx8avNfwZ+AVDZqOH4TtumjT2ChGVwVIgnBREBKZZ44OhYsoc1Kvov9qkHzpWOqBN1js=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:4481a882-580a-4bc4-a01d-4a8ccb69bfc2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:e56c4771-3b7f-4b26-b2f9-40f0deecb36d,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|865|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b84117564d6711f1b96f91537e34a508-20260512
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <ryder.lee@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 337347264; Tue, 12 May 2026 02:32:09 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 12 May 2026 02:32:08 +0800
Received: from mussdccf250.eus.mediatek.inc (10.73.250.250) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 12 May 2026 02:32:07 +0800
From: Ryder Lee <ryder.lee@mediatek.com>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-mediatek@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Shayne Chen <shayne.chen@mediatek.com>, Roy Luo <roy-ch.luo@mediatek.com>,
	Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7996: avoid memset overwriting tx_info->control.flags
Date: Mon, 11 May 2026 11:32:04 -0700
Message-ID: <5ecac6a9b7d29526e8438dea105b58f5487c93aa.1778521232.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

mt76_tx_status_skb_add uses memset on status.status_driver_data, which
overwrite  info->control.flags in ieee80211_tx_info. Copy tx_info before
calling mt76_tx_status_skb_add to ensure control fields are preserved
and remain valid for later processing.

Reported-By: Roy Luo <roy-ch.luo@mediatek.com>
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 17 +++++++++--------
 .../net/wireless/mediatek/mt76/mt7996/mt7996.h  |  2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index e2a83da3a09c..a59c14c8f2af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -855,11 +855,12 @@ mt7996_mac_write_txwi_80211(struct mt7996_dev *dev, __le32 *txwi,
 
 void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
-			   struct ieee80211_key_conf *key, int pid,
+			   struct ieee80211_tx_info *tx_info, int pid,
 			   enum mt76_txq_id qid, u32 changed)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_key_conf *key = tx_info ? tx_info->control.hw_key : NULL;
+	struct ieee80211_tx_info *info = tx_info ? tx_info : IEEE80211_SKB_CB(skb);
 	struct ieee80211_vif *vif = info->control.vif;
 	u8 band_idx = (info->hw_queue & MT_TX_HW_QUEUE_PHY) >> 2;
 	u8 p_fmt, q_idx, omac_idx = 0, wmm_idx = 0;
@@ -1006,15 +1007,15 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx_info->skb->data;
 	struct mt7996_dev *dev = container_of(mdev, struct mt7996_dev, mt76);
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx_info->skb);
-	struct ieee80211_key_conf *key = info->control.hw_key;
-	struct ieee80211_vif *vif = info->control.vif;
+	struct ieee80211_tx_info info = *IEEE80211_SKB_CB(tx_info->skb);
+	struct ieee80211_key_conf *key = info.control.hw_key;
+	struct ieee80211_vif *vif = info.control.vif;
 	struct mt7996_vif *mvif = vif ? (struct mt7996_vif *)vif->drv_priv : NULL;
 	struct mt7996_sta *msta = sta ? (struct mt7996_sta *)sta->drv_priv : NULL;
 	struct mt76_vif_link *mlink = NULL;
 	struct mt76_txwi_cache *t;
 	int id, i, pid, nbuf = tx_info->nbuf - 1;
-	bool is_8023 = info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP;
+	bool is_8023 = info.flags & IEEE80211_TX_CTL_HW_80211_ENCAP;
 	__le32 *ptr = (__le32 *)txwi_ptr;
 	u8 *txwi = (u8 *)txwi_ptr;
 	u8 link_id;
@@ -1031,7 +1032,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 
 		link_id = (tid % 2) ? msta->seclink_id : msta->deflink_id;
 	} else {
-		link_id = u32_get_bits(info->control.flags,
+		link_id = u32_get_bits(info.control.flags,
 				       IEEE80211_TX_CTRL_MLO_LINK);
 	}
 
@@ -1095,7 +1096,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	memset(txwi_ptr, 0, MT_TXD_SIZE);
 	/* Transmit non qos data by 802.11 header and need to fill txd by host*/
 	if (!is_8023 || pid >= MT_PACKET_ID_FIRST)
-		mt7996_mac_write_txwi(dev, txwi_ptr, tx_info->skb, wcid, key,
+		mt7996_mac_write_txwi(dev, txwi_ptr, tx_info->skb, wcid, &info,
 				      pid, qid, 0);
 
 	/* MT7996 and MT7992 require driver to provide the MAC TXP for AddBA
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index bdcf72457954..319fcc4fb469 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -854,7 +854,7 @@ void mt7996_mac_cca_stats_reset(struct mt7996_phy *phy);
 void mt7996_mac_enable_nf(struct mt7996_dev *dev, u8 band);
 void mt7996_mac_write_txwi(struct mt7996_dev *dev, __le32 *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
-			   struct ieee80211_key_conf *key, int pid,
+			   struct ieee80211_tx_info *tx_info, int pid,
 			   enum mt76_txq_id qid, u32 changed);
 void mt7996_mac_update_beacons(struct mt7996_phy *phy);
 void mt7996_mac_set_coverage_class(struct mt7996_phy *phy);
-- 
2.45.2

