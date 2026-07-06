Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F29C3A7F68
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 02:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783305803; cv=none; b=DweDfvqrprEs1vna3DF0G9ttIAOlk8EttLQ7O2gtaYaJ4hPfzqEUviEf+PyaXnHlfiKGJxnKEmB4JpenVoEH6mkETpSoIuUwbTf6rhngMIeT8pYdtUhbfouIipaR5l24pCEqBpstdhXYSm0e5LhSPGpWgoXo4XGCw9EhhHKxIAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783305803; c=relaxed/simple;
	bh=+JX9LegM787optVTrWnQ7Dvu9v+ikRk2iKWXP5K/rjY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pn8JqLqm+UojSdrKwhYbxGS2DrtfK7EeLluSkK9LiKhyhKwVMcii1W/zIVTSwzFfMWlVjzr68fQ0wcIJq0VlnYSm3hoteCq6JwnTl7iFfalibVSqM0X7Gpou0yBTPbNmk70WLORwc7Th6O48VnznRhcxfFcKd85bplfyGzW9ikc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bVeSfQgx; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bVeSfQgx"
X-UUID: 6c22db0e78e411f18dc8c9802ae25ab1-20260706
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=OQJi2yYr5F1UUcKiQuDU1gdz3ijCZmWXgkUNEcU9N1k=;
	b=bVeSfQgxOrNUR50hoshwN9Yxxo6tXjvZDySEBxR40bWJkHXZOtSFAgS9V4clsMdQR2ILMsY/0yVPyNwcRcEHFy8jKaqVpssRRN6P39KI3Y8zxpPwubmVx2nYOGjbk+f+Nt1MEhJ8EGQUqN8fwyh7fBiXz7xYOvlI9BRn409vgOU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:a14556d9-ba23-4f60-a3be-25ea418899c2,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:d497b38,CLOUDID:97b00a82-6310-4e6b-a6b1-aca20d98ed8b,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6c22db0e78e411f18dc8c9802ae25ab1-20260706
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1146115879; Mon, 06 Jul 2026 10:43:08 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 6 Jul 2026 10:43:07 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 6 Jul 2026 10:43:07 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<Leon.Yen@mediatek.com>, <litien.chang@mediatek.com>,
	<jeff.hsu@mediatek.com>, <jb.tsai@mediatek.com>, Jeff Hsu
	<Jeff.Hsu@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925: Add flag to control if need DMA re-init
Date: Mon, 6 Jul 2026 10:43:06 +0800
Message-ID: <20260706024306.47806-1-jb.tsai@mediatek.com>
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

From: Jeff Hsu <Jeff.Hsu@mediatek.com>

Add flag(skip_wpdma_reinit) to control if need do DMA re-init

Signed-off-by: Jeff Hsu <Jeff.Hsu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt792x.h     | 1 +
 drivers/net/wireless/mediatek/mt76/mt792x_dma.c | 5 +++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index c8537a5cdf67..154e4372664e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -650,6 +650,10 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 	if (!mt7925_disable_aspm && mt76_pci_aspm_supported(pdev))
 		dev->aspm_supported = true;
 
+	/* MT7935 does not need wpdma reinit */
+	if (is_mt7928(&dev->mt76))
+		dev->skip_wpdma_reinit = true;
+
 	ret = __mt792x_mcu_fw_pmctrl(dev);
 	if (ret)
 		goto err_free_dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index 8c7ecd3ce126..18d6e2c35606 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -271,6 +271,7 @@ struct mt792x_dev {
 	bool hif_idle:1;
 	bool hif_resumed:1;
 	bool regd_change:1;
+	bool skip_wpdma_reinit:1;
 	wait_queue_head_t wait;
 
 	struct work_struct init_work;
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
index 8ad94fa58340..8308935491d3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_dma.c
@@ -418,6 +418,11 @@ int mt792x_wpdma_reinit_cond(struct mt792x_dev *dev)
 	struct mt76_connac_pm *pm = &dev->pm;
 	int err;
 
+	/* Skip wpdma reinit if chip doesn't need it */
+	if (dev->skip_wpdma_reinit) {
+		return 0;
+	}
+
 	/* check if the wpdma must be reinitialized */
 	if (mt792x_dma_need_reinit(dev)) {
 		/* disable interrutpts */
-- 
2.45.2

