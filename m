Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63B3223708
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2026 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783040410; cv=none; b=M0sjq2BvS1935SAJYRFfd1MVjfDXAREHlCRRjmn7EaCnr5Cd/K8gdX7mXxlFzIS0DM9TqSM0E9985FEyHnmHks5ZxpPEpKqepbYubm0SYAMb3UnbSZgXJonfa/B+6HbPaXfC4tskdFI2mMKAj+TLrtnc6k9hAb06emRu5owV2VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783040410; c=relaxed/simple;
	bh=7MFbkA4zkaz0nke1s9QOo514SJJDftz2G2j1aK0m16M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sAAGnlJRNFBaqB2oI7p4/rwOaRt+Ak5x8q1yzGeGWNGI/jfL0buNRpgT0vxZ4FJ3rQyPZGX0WUoW+Qf4dWGEpOR+1TeDSH5uGyqjHkatlo/kTq5L7C3lezdnol8+Lh+5/ej0qUBLpRSIt7sFK6XC90wfhZYHxEqjvNDceKHzHGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=o1bC3HFj; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="o1bC3HFj"
X-UUID: 837043e4767a11f1b1788b6acf885367-20260703
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=OG+AH5OioDQ5bL6HxNycjtqG2Tg+0W/zAAEWZHSKmng=;
	b=o1bC3HFj0D09cn61QkAUg+9v4gS8yNzlvKafvMRwEkYJR8NcgjW6L9JpNC7idd4556t6EX3JGfREKBPQDHZ3zq8o3yQx6cE9r5ZHCRoa2Iozl+PGCKpzQPDW0oVYJ0RzrjIce47xGOmPIJxiEkqKztbH4XbRe2mVTkJzRdsshH4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:c1b24417-3393-47a8-b81a-b9070bcacc32,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:d497b38,CLOUDID:8b42ad14-ea64-44d4-98db-4e1fb89955a3,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 837043e4767a11f1b1788b6acf885367-20260703
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 369863272; Fri, 03 Jul 2026 08:59:58 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 3 Jul 2026 08:59:57 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 3 Jul 2026 08:59:57 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Yf.Luo@mediatek.com>, <kun.wu@mediatek.com>, <deren.wu@mediatek.com>,
	<sean.wang@mediatek.com>, <quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>,
	<leon.yen@mediatek.com>, <litien.chang@mediatek.com>, <jb.tsai@mediatek.com>,
	<eason.lai@mediatek.com>, Eason Lai <Eason.Lai@mediatek.com>
Subject: [PATCH v1 1/1] wifi: mt76: mt792x: Fix memory leak in SDIO TX path
Date: Fri, 3 Jul 2026 08:59:45 +0800
Message-ID: <20260703005945.2244533-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Eason Lai <Eason.Lai@mediatek.com>

When tx_prepare_skb() returns an error in the SDIO TX path, the
skb is not freed, leading to a memory leak. This can occur when
zero-length frames (such as WNM NULL frames) are dropped to prevent
potential hardware TX hangs.

Fix this by properly releasing the skb with ieee80211_tx_status_ext()
when tx_prepare_skb() fails.

Fixes: b747fa343817 ("mt76: mt7915: drop zero-length packet to avoid Tx hang")
Signed-off-by: Eason Lai <Eason.Lai@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/sdio.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/sdio.c b/drivers/net/wireless/mediatek/mt76/sdio.c
index 8bae77c761be..ba5f123f7e39 100644
--- a/drivers/net/wireless/mediatek/mt76/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/sdio.c
@@ -519,6 +519,10 @@ mt76s_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
 		   enum mt76_txq_id qid, struct sk_buff *skb,
 		   struct mt76_wcid *wcid, struct ieee80211_sta *sta)
 {
+	struct ieee80211_tx_status status = {
+		.sta = sta,
+	};
+
 	struct mt76_tx_info tx_info = {
 		.skb = skb,
 	};
@@ -531,8 +535,13 @@ mt76s_tx_queue_skb(struct mt76_phy *phy, struct mt76_queue *q,
 
 	skb->prev = skb->next = NULL;
 	err = dev->drv->tx_prepare_skb(dev, NULL, qid, wcid, sta, &tx_info);
-	if (err < 0)
+	if (err < 0) {
+		status.skb = tx_info.skb;
+		spin_lock_bh(&dev->rx_lock);
+		ieee80211_tx_status_ext(dev->hw, &status);
+		spin_unlock_bh(&dev->rx_lock);
 		return err;
+	}
 
 	q->entry[q->head].skb = tx_info.skb;
 	q->entry[q->head].buf_sz = len;
-- 
2.45.2

