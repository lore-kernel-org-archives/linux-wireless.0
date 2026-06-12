Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E93305684
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250829; cv=none; b=hPbW2vccoReOHJIIARxbkLxsGOPa2UZxZ2bZzpzD0qUcXOODWoqYksxOnFIUYhfbIepNs7jgYw+QTnF9m+N83rgSFBv5KDlv/RIQ5LK/D0nl8Vdv/Q/DsEpzUVxQdqzzF+tUZ4vwuYmTPAKxAvh3mVRa+ex5OxQCK571b3iUsbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250829; c=relaxed/simple;
	bh=U40raKl2rcgkTITtmwT0mqGRedgt4QAEF/a/czvD0J0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8nRKTOY29MIzasBlQ+UJDzIdO4xEGBxkT6uIFZgpc2Vs0tAwElvZpp9ngrSY+AJMXXHYH69jH3t8v/kv7tJgrcZw2vjssIwjMDdWNGWTel8xKUijPkjXmEpmXBMRfpFGZgipqzHfi0q1c7Yf0TD+uiz+tBNw4p2g+WXLGJyKdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jsNdpgAF; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jsNdpgAF"
X-UUID: d5f3e618663311f1b1788b6acf885367-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=zkgX4HMDo7kRNN7r03RSMvNWryWUuw2b/BlzG7F+3oY=;
	b=jsNdpgAFgrGyvNxpcXaNk17U52pv8VZacfA64HSue44vfDlCjMXQ6FF13UEDt7honSx3GvlNSb+Ty/IoNnhTbXng96zxIxf+lIt53cotzaALAevDwknG1sSOZwqOYVxUhW/IyN44voYPl+bgKJR4vuqv0oTqRo0UfD1jTSXx5xc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:79b8163b-0280-438a-9bf4-243a723fa476,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:e276073,CLOUDID:14536397-22d1-4176-b420-d0d82ac3f01a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|136|836|865|888|898,TC:-5,
	Content:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d5f3e618663311f1b1788b6acf885367-20260612
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1990842173; Fri, 12 Jun 2026 15:53:44 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 15:53:43 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 15:53:43 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <emery.hsin@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH 20/20] wifi: mt76: mt7925: add MT7928 PCIe support
Date: Fri, 12 Jun 2026 15:53:39 +0800
Message-ID: <20260612075339.2578327-5-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260612075339.2578327-1-jb.tsai@mediatek.com>
References: <20260612075339.2578327-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Emery Hsin <emery.hsin@mediatek.com>

Register MT7928 (0x7928, 0x7935) in the PCI device table and
declare MODULE_FIRMWARE for all four MT7928 firmware blobs.

Signed-off-by: Emery Hsin <emery.hsin@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 1ad5847d4a8c..1514494f6c7b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -22,6 +22,10 @@ static const struct pci_device_id mt7925_pci_device_table[] = {
 		.driver_data = (kernel_ulong_t)MT7927_FIRMWARE_WM },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x0738),
 		.driver_data = (kernel_ulong_t)MT7927_FIRMWARE_WM },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x7928),
+		.driver_data = (kernel_ulong_t)MT7928_FIRMWARE_WM },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x7935),
+		.driver_data = (kernel_ulong_t)MT7928_FIRMWARE_WM },
 	{ },
 };
 
@@ -663,6 +667,11 @@ static int mt7925_pci_probe(struct pci_dev *pdev,
 			 "MT7927 raw CHIPID=0x%04x, forcing chip=0x7927\n",
 			 mt76_chip(mdev));
 		mdev->rev = (0x7927 << 16) | (mdev->rev & 0xff);
+	} else if (is_mt7928_hw && mt76_chip(mdev) != 0x7928) {
+		dev_info(mdev->dev,
+			 "MT7928 raw CHIPID=0x%04x, forcing chip=0x7928\n",
+			 mt76_chip(mdev));
+		mdev->rev = (0x7928 << 16) | (mdev->rev & 0xff);
 	}
 
 	mt76_rmw_field(dev, MT_HW_EMI_CTL, MT_HW_EMI_CTL_SLPPROT_EN, 1);
@@ -913,6 +922,10 @@ MODULE_FIRMWARE(MT7925_FIRMWARE_WM);
 MODULE_FIRMWARE(MT7925_ROM_PATCH);
 MODULE_FIRMWARE(MT7927_FIRMWARE_WM);
 MODULE_FIRMWARE(MT7927_ROM_PATCH);
+MODULE_FIRMWARE(MT7928_FIRMWARE_WM);
+MODULE_FIRMWARE(MT7928_ROM_PATCH);
+MODULE_FIRMWARE(MT7928_CB_ROM_PATCH);
+MODULE_FIRMWARE(MT7928_PHY_RAM);
 MODULE_AUTHOR("Deren Wu <deren.wu@mediatek.com>");
 MODULE_AUTHOR("Lorenzo Bianconi <lorenzo@kernel.org>");
 MODULE_DESCRIPTION("MediaTek MT7925E (PCIe) wireless driver");
-- 
2.45.2

