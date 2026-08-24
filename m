Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E065369D74
	for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2026 09:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787563790; cv=none; b=WFXIho04o73JIaMYGGA1XS6tnPqa2bv66yMcXctlwHWyrdMN6NOcqhB3hJEKAfm/D6Mu7EOjq3/0q/F0tieKj3dp9n4LF7xL9gkyhraSekSiL6rgG1x7JM51vT06TgOkEhEXrBaFk0wavK2NH6uQ3GZoauQfDABRf/VUwSt5id0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787563790; c=relaxed/simple;
	bh=8KgY8sDk6Ne+oeJJfNf+e0Zi+VAaTd9oWU0rqeJtLCk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EMCd0340W9ew+pTEByWl/9Y13w0L4WXPt58i7F0DN/V8wkQ4IfF1OY5Wee0VLxFtgLaJjHj+eWc4pt+dwnlSGdkAnIl0tVy+FPKBzELDmwC+EDPsFHWRoNx2oS+cNgmpgfd+ZJ4+QhNUaGzuwAX51RF5Ql3XXZ5Jzcy2Hded57c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 54eaaa3a9f9e11f19a56ed5b684f684d-20260824
X-CID-CACHE: Type:Local,Time:202608241723+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:cda5c3d9-b263-410f-b639-37a3da5ba6f4,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:7db8b62,CLOUDID:119daf2823df0184fc5bef992ff405cc,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 54eaaa3a9f9e11f19a56ed5b684f684d-20260824
X-User: yanglinlin@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <yanglinlin@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1986925294; Mon, 24 Aug 2026 17:29:40 +0800
From: Linlin Yang <yanglinlin@kylinos.cn>
To: linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Linlin Yang <yanglinlin@kylinos.cn>
Subject: [PATCH] wifi: mt76: mt7996: fix PCI device reference leak in mt7996_pci_init_hif2()
Date: Mon, 24 Aug 2026 17:29:37 +0800
Message-Id: <20260824092937.683240-1-yanglinlin@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pci_get_device() increments the reference count on the returned
struct pci_dev. In mt7996_pci_init_hif2(), three pci_get_device()
calls are made but their return values are only checked for NULL
and then discarded. pci_dev_put() is never called, causing a PCI
device reference count leak.

Fix this by storing the return value and calling pci_dev_put()
before returning, following the same pattern already used in the
sibling driver mt7915/pci.c.

Signed-off-by: Linlin Yang <yanglinlin@kylinos.cn>
---
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index b7d9193e042f..a7c23b33dde0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -63,12 +63,18 @@ static void mt7996_put_hif2(struct mt7996_hif *hif)
 
 static struct mt7996_hif *mt7996_pci_init_hif2(struct pci_dev *pdev)
 {
+	struct pci_dev *tmp_pdev;
+
 	hif_idx++;
 
-	if (!pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7996_DEVICE_ID_2, NULL) &&
-	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7992_DEVICE_ID_2, NULL) &&
-	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7990_DEVICE_ID_2, NULL))
+	tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7996_DEVICE_ID_2, NULL);
+	if (!tmp_pdev)
+		tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7992_DEVICE_ID_2, NULL);
+	if (!tmp_pdev)
+		tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, MT7990_DEVICE_ID_2, NULL);
+	if (!tmp_pdev)
 		return NULL;
+	pci_dev_put(tmp_pdev);
 
 	writel(hif_idx | MT_PCIE_RECOG_ID_SEM,
 	       pcim_iomap_table(pdev)[0] + MT_PCIE_RECOG_ID);
-- 
2.25.1

