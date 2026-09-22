Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4574752FE59
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072338; cv=none; b=glED7/1IiWe/83bO/j86FtyA17ZLbk59xZAHnPIwbwA/eRlXfsATfh6EPLnS9KLmCnzkyPsfwTmioUzpT+rfGoEfk4VhpwL+kghfnEoSVD/qb9wvqTd6JTW3dL4dw85qDgn3+xv7S7wkPJqT+nKB7e9K84+sZrmMPqNE7r1IhNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072338; c=relaxed/simple;
	bh=1U8Bqm3rxsXz234pxrxMCdV0ym/zlCrblTZewzk3fJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2wDgEvOtwnJwmYE1/uI67PmyvFePmsXIHgE/Hhd5/xnulFkmccGtukGeC+rJFAKcrcN9FfNaz1ejD+dEQyF1LaULleM40w0PrAHF5wse6WZcV5uuECbrcp9MRqeAWO7DPbRvY2lws86+U/N/FXzTbMm/yzOuCzEglgQxQ4Ap60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=m9sfCta+; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="m9sfCta+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dxt8WV9+hhqtxqHlq7T9XoUkzTEawo6LDidlya57OZ8=; b=m9sfCta+QTZwmUw7xkejwFlb7L
	CXKVtz1osrCc60RRId1kB2Yt85buHnVn4lBOAuvzl173YS33qgTgtLmY7kcdSm6ts557Qq9jmMU1g
	zOcMlynAuhJuMi0E9mPsZ/ZmMFbaxqhISxDYu52CEYR8tcfyMA4lKOZ2atnRNIikHq4U=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xaO-0080aD-0b;
	Tue, 22 Sep 2026 12:18:52 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH 5/5] wifi: mt76: answer the flow priority query
Date: Tue, 22 Sep 2026 12:18:48 +0200
Message-ID: <4f90614d7002b336a5974045312816f6641662c4.1790072192.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
References: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement the WED flow_prio callback by mapping the station index of
the entry back to the station and passing the query to mac80211. This
gives offloaded flows the same user priority that the software path
assigns to their frames.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h        |  2 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c |  1 +-
 drivers/net/wireless/mediatek/mt76/wed.c         | 17 +++++++++++++++++-
 3 files changed, 20 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 62b41c8bb7c0..911fc82305e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1252,6 +1252,8 @@ int mt76_wed_net_setup_tc(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  void *type_data);
 #ifdef CONFIG_NET_MEDIATEK_SOC_WED
 u32 mt76_wed_init_rx_buf(struct mtk_wed_device *wed, int size);
+int mt76_wed_flow_prio(struct mtk_wed_device *wed, u16 idx,
+		       const struct cfg80211_flow_info *info, u8 *prio);
 int mt76_wed_offload_enable(struct mtk_wed_device *wed);
 int mt76_wed_dma_setup(struct mt76_dev *dev, struct mt76_queue *q, bool reset);
 #else
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index fbfbb96a742f..17cbdc570530 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -616,6 +616,7 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 	wed->wlan.release_rx_buf = mt76_wed_release_rx_buf;
 	wed->wlan.offload_enable = mt76_wed_offload_enable;
 	wed->wlan.offload_disable = mt76_wed_offload_disable;
+	wed->wlan.flow_prio = mt76_wed_flow_prio;
 	if (!hif2) {
 		wed->wlan.reset = mt7996_mmio_wed_reset;
 		wed->wlan.reset_complete = mt76_wed_reset_complete;
diff --git a/drivers/net/wireless/mediatek/mt76/wed.c b/drivers/net/wireless/mediatek/mt76/wed.c
index f210a0c57d81..fee172303877 100644
--- a/drivers/net/wireless/mediatek/mt76/wed.c
+++ b/drivers/net/wireless/mediatek/mt76/wed.c
@@ -83,6 +83,23 @@ u32 mt76_wed_init_rx_buf(struct mtk_wed_device *wed, int size)
 }
 EXPORT_SYMBOL_GPL(mt76_wed_init_rx_buf);
 
+/* Called from the PPE receive path under RCU, must not sleep */
+int mt76_wed_flow_prio(struct mtk_wed_device *wed, u16 idx,
+		       const struct cfg80211_flow_info *info, u8 *prio)
+{
+	struct mt76_dev *dev = mt76_wed_to_dev(wed);
+	struct ieee80211_sta *sta;
+	struct mt76_wcid *wcid;
+
+	wcid = __mt76_wcid_ptr(dev, idx);
+	sta = wcid_to_sta(wcid);
+	if (!sta)
+		return 0;
+
+	return ieee80211_sta_flow_prio(sta, info, prio);
+}
+EXPORT_SYMBOL_GPL(mt76_wed_flow_prio);
+
 int mt76_wed_offload_enable(struct mtk_wed_device *wed)
 {
 	struct mt76_dev *dev = mt76_wed_to_dev(wed);
-- 
git-series 0.9.1
