Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5323D47DD
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708784; cv=none; b=s+qjyNgcnBFrcKQtMevwyQ/tplgBMkEaSl7MzkhK0NdFeYESFTbN0Wezu5eHr2BfZ3QRcQHrooZ2bwmvhsBK1J9e98z3m74HKiOJfHL9qboOBliHK54mUDHiUcBdorIEq5yNwTCqesfOSJ+UYxhF/rLExTadvVS14kTedFOU8FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708784; c=relaxed/simple;
	bh=3XTNBSUGQVr9nf8Gw6BIla+9BdgG0dDmVfeyhqgc1mI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBK5ctdA9TOM4g0Bi3SN5lfROBJqIULXwbiqRQiJlBoK48dU8DPnhgYAA/jXXNNPYJYUMKO8jibj9a0jAbk4HiF3FIJzNJdzkrALOOx3umfxK6RliTYJYcDH6DayLjt3POScJ1vj2ox6o/9aXged/bnV2m/BQjDOwMeN2ndbDGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=NSvcukJh; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="NSvcukJh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uIfymp2t5xHyoj+ph5JVxuGCl1fdw+IX2RH+vyPa1J0=; b=NSvcukJhpSvFOhkIclSzWV3ZXA
	ne25JJoyzTBN725inxoEcDug3CdO+dKTIblDUI1X8qjrzaIhAfmrn1Jo1hERPg9EoS2pAurcc13kg
	hRHWEFXZa+KjMw1HP12WNGnDOGL3978PghAKkpEqsrRywxctj7ocfrQEFyVgbZXo6+0o=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHR-005AHx-01
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:17 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 13/18] wifi: mt76: mt7996: fix TX DMA mapping leak for AddBA req frames
Date: Wed, 22 Jul 2026 08:26:05 +0000
Message-ID: <20260722082610.2699628-13-nbd@nbd.name>
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

mt7996/mt7992 hand the firmware a HW MAC-TXP for AddBA req action frames
(MT_TXD7_MAC_TXD, set in mt7996_mac_write_txwi_80211()), but are otherwise
FW-TXP devices. On tx free mt76_connac_txp_skb_unmap() therefore decodes
the per-frame txp as a struct mt76_connac_fw_txp. For a MAC-TXP the
fw_txp.nbuf byte aliases the AddBA TID word (MT_TXP1_TID_ADDBA), which is
always zero, so the unmap loop runs zero times and the skb DMA mapping in
buf[1] is never unmapped. buf[1].skip_unmap is set unconditionally, so the
generic DMA-ring cleanup skips it as well.

Each AddBA req therefore leaks one TX DMA mapping, roughly one per
(re)association. With WED enabled these mappings are bounced through the
WED swiotlb pool, so under continuous client reconnect churn the pool is
exhausted after ~1-2 days, after which DMA mapping fails for WED, the WiFi
MCU and other on-SoC consumers.

Keep the deferred (token release) unmap that the design relies on, and add
an mt7996-specific txp unmap that inspects MT_TXD7_MAC_TXD and unmaps
buf[1] from the MAC-TXP layout for those frames, delegating to
mt76_connac_txp_skb_unmap() otherwise.

Cc: stable@vger.kernel.org
Fixes: cb6ebbdffef2 ("wifi: mt76: mt7996: support writing MAC TXD for AddBA Request")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 26 ++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 531b5bee3f48..552b59c6e6b8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1283,6 +1283,30 @@ mt7996_tx_check_aggr(struct ieee80211_link_sta *link_sta,
 		clear_bit(tid, &wcid->ampdu_state);
 }
 
+static void
+mt7996_txp_skb_unmap(struct mt76_dev *mdev, struct mt76_txwi_cache *t)
+{
+	u8 *txwi_ptr = mt76_get_txwi_ptr(mdev, t);
+	__le32 *txwi = (__le32 *)txwi_ptr;
+	__le32 *txp;
+	dma_addr_t addr;
+	u32 val;
+
+	if (!(le32_to_cpu(txwi[7]) & MT_TXD7_MAC_TXD)) {
+		mt76_connac_txp_skb_unmap(mdev, t);
+		return;
+	}
+
+	txp = (__le32 *)(txwi_ptr + MT_TXD_SIZE);
+	val = le32_to_cpu(txp[3]);
+	addr = le32_to_cpu(txp[2]);
+#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
+	addr |= (dma_addr_t)FIELD_GET(MT_TXP3_DMA_ADDR_H, val) << 32;
+#endif
+	dma_unmap_single(mdev->dma_dev, addr, FIELD_GET(MT_TXP_BUF_LEN, val),
+			 DMA_TO_DEVICE);
+}
+
 static void
 mt7996_txwi_free(struct mt7996_dev *dev, struct mt76_txwi_cache *t,
 		 struct ieee80211_link_sta *link_sta,
@@ -1292,7 +1316,7 @@ mt7996_txwi_free(struct mt7996_dev *dev, struct mt76_txwi_cache *t,
 	__le32 *txwi;
 	u16 wcid_idx;
 
-	mt76_connac_txp_skb_unmap(mdev, t);
+	mt7996_txp_skb_unmap(mdev, t);
 	if (!t->skb)
 		goto out;
 
-- 
2.53.0

