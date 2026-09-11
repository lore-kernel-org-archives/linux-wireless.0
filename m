Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4A633F59A;
	Fri, 11 Sep 2026 06:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106971; cv=none; b=EuzzyjsqRYuvObWCH9zXiNUCd0kx3w3wOeOAX+Q1exA5R6pNc5JgcFdLm9NEokfJA9jaFl8ZEJ/pc/BahKKr9tl/9oVaNW/Jw2nSnXlF4/Jt3lrtLU5o9f+Ji/DqxCMWIv1WDWIARKKZe5Xpfc/c9udQLUnizWF6rqiKJAAZ+Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106971; c=relaxed/simple;
	bh=+hUjj2CaaHPOHpUgbRHx0MCwnHgWThEuLR3wioY7QaU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GoQgnYhNXFJrtgarEDWZyLbkAb3yx5n6t3bQElvMXyhYQhrk6fHXlU2YdxtyDWJWwP3vLlrC2o+3vU+tqc7og9qf5YcBGstWo2oVXTHK0+f0bujkXW58e6LlOX62Kx9E2JCv5wCQEI2CF0UkfdV1Yp1tQy2Eg85WboSKTXIQcJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=KmpRcIo4; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="KmpRcIo4"
Received: from seu.edu.cn (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4d62c4fb7;
	Fri, 11 Sep 2026 14:09:23 +0800 (GMT+08:00)
From: Slavin Liu <bolin.liu@seu.edu.cn>
To: nbd@nbd.name,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com
Cc: shayne.chen@mediatek.com,
	sean.wang@mediatek.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	bolin.liu@seu.edu.cn
Subject: [PATCH RFC net] wifi: mt76: mt7996: guard station-only MLO TX handling
Date: Fri, 11 Sep 2026 14:09:22 +0800
Message-Id: <20260911060922.94383-1-bolin.liu@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa08f15c19903a1kunm3f9087f41c7355
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGUtIVklKGE1IThpDTk9IHlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSU
	hOQ0NVSktLVUtZBg++
DKIM-Signature: a=rsa-sha256;
	b=KmpRcIo4HhataD46neMm5mjBpxhLA7cwHRwITzsoQngB8Q1+TReXPqBFyaGZFTPgqSRbkVVrbg1vrq0+2+FY7zL3yA5cifwzEo9cn43y+8+dqpZO2kizTH4Yc4oQl+wQi/yYR+j+qOJ4ljV0JSj/Mhl1jwg9z25jf1SaGhQltDs=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=9qPNY3Uu4k+FecCTTTG7VYnLoe6+q61r76rTHiKu0vo=;
	h=date:mime-version:subject:message-id:from;

Pending frames can be retried after their station is no longer
available. Require a station for both MLO-specific branches and retain
the existing non-station transmission path for valid vif traffic.

Detected by static analysis and reviewed with AI-assisted source auditing.

Fixes: 7ef0c7ad735b ("wifi: mt76: mt7996: Implement MLD address translation for EAPOL")
Fixes: 85cd5534a3f2 ("wifi: mt76: mt7996: use correct link_id when filling TXD and TXP")
Assisted-by: LLM
Signed-off-by: Slavin Liu <bolin.liu@seu.edu.cn>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 1cba381a78b8..e24dd530486c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1057,7 +1057,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	if (!wcid)
 		wcid = &dev->mt76.global_wcid;
 
-	if ((is_8023 || ieee80211_is_data_qos(hdr->frame_control)) && sta->mlo &&
+	if (sta && (is_8023 || ieee80211_is_data_qos(hdr->frame_control)) && sta->mlo &&
 	    likely(tx_info->skb->protocol != cpu_to_be16(ETH_P_PAE))) {
 		u8 tid = tx_info->skb->priority & IEEE80211_QOS_CTL_TID_MASK;
 
@@ -1097,7 +1097,7 @@ int mt7996_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
 	 * compatible with 802.11 EAPOL frame, we do the translation by
 	 * software
 	 */
-	if (tx_info->skb->protocol == cpu_to_be16(ETH_P_PAE) && sta->mlo) {
+	if (sta && tx_info->skb->protocol == cpu_to_be16(ETH_P_PAE) && sta->mlo) {
 		struct ieee80211_hdr *hdr = (void *)tx_info->skb->data;
 		struct ieee80211_bss_conf *link_conf;
 		struct ieee80211_link_sta *link_sta;
