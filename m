Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98CB400DFF
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 08:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791189548; cv=none; b=PlSqN4B0/78n/+ipYWyZzWEYQpoMVASZPm9bgmRlQplcx8gC4rsNCvw64HRxuaTxVQK8xx1LBQh5LQ6lYibJobHi9LCosfPFvkEHBj14gUIIAszGP4+tlRSxBg+BK0SQaxWVPzszl0bH+LHujxb3/gRQIpJUqJ2xOtKq0ZlD7d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791189548; c=relaxed/simple;
	bh=mEZFXkJy2w7lyWq9xgivh1Jsnwd0LkYbs1ApgMyt0BU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C3FjawkH4Z3P9oFF4aIittpOnUr24Tf+B2hcMUzQNIKjvUJUcCLGDYE9mvSQRfG6dbIRagg8kcwJM53YGU80eoodv4QEjCSGtyMidYxBCIbkHzZkjlegL4nJuZoCEoHNYwXLKD3pMlD+2UUa6h/mHhmmmE2h6kMyGSaPXGFtKS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=S0fxLePZ; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="S0fxLePZ"
X-UUID: 34ea5e22c09811f18dc8c9802ae25ab1-20261005
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=kE+6XFeMKDa0LS+xV+tYro9ZbSI0C+U04y9XFOZqI+I=;
	b=S0fxLePZg6fPGd4msmF/jpRzdg7tHfIJ8QX5Qti+Os8zh3ts79Ja+BPbRXsOHWymSco6Em9GjyQVW2UpN6jHUlUrOth4uZ8gx85D1uMbU/QbeDJYdQXgs99IAEtrbVxBUN7y2QsYkQobpxQiyHz2vWDBjDlCRQ6oKOkgmjp9U08=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:dad9b947-7211-426c-b610-97a191d7d11b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:259fa094-f92e-44c1-a195-feed1a426245,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 34ea5e22c09811f18dc8c9802ae25ab1-20261005
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2126640061; Mon, 05 Oct 2026 16:38:58 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Oct 2026 16:38:56 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 5 Oct 2026 16:38:56 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH] wifi: mt76: logging FW return value when FW download fails
Date: Mon, 5 Oct 2026 16:38:55 +0800
Message-ID: <20261005083855.107460-1-anthony.liu@mediatek.com>
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

Add log messages for pinpointing FW download failures.

Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index eb4d02ec3ebe..9189ccdaa5e6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -3225,7 +3225,7 @@ int mt76_connac2_load_ram(struct mt76_dev *dev, const char *fw_wm,
 
 	ret = mt76_connac_mcu_send_ram_firmware(dev, hdr, fw->data, false);
 	if (ret) {
-		dev_err(dev->dev, "Failed to start WM firmware\n");
+		dev_err(dev->dev, "Failed to start WM firmware %d\n", ret);
 		goto out;
 	}
 
@@ -3396,7 +3396,7 @@ int mt76_connac2_load_patch(struct mt76_dev *dev, const char *fw_name)
 
 	ret = mt76_connac_mcu_start_patch(dev);
 	if (ret)
-		dev_err(dev->dev, "Failed to start patch\n");
+		dev_err(dev->dev, "Failed to start patch %d\n", ret);
 
 out:
 	sem = mt76_connac_mcu_patch_sem_ctrl(dev, false);
@@ -3518,7 +3518,7 @@ int mt76_connac3_load_cb_patch(struct mt76_dev *dev, const char *fw_name)
 
 	ret = mt76_connac_cb_mcu_start_patch(dev);
 	if (ret)
-		dev_err(dev->dev, "Failed to start cb patch\n");
+		dev_err(dev->dev, "Failed to start cb patch %d\n", ret);
 
 out:
 	sem = mt76_connac_cb_mcu_patch_sem_ctrl(dev, false);
-- 
2.45.2

