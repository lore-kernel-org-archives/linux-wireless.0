Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BD5369224
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 02:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785292487; cv=none; b=SOQ14qJsSpbCFULGt+kdTOE517bm2CV81O/1oHAzH8wqbxEnSu1Dm65ANl4k9eg5NkjfP6MDnITDsqRmhIBkGM0ZVwpPT1bVLB6uJCNIJmlFVxbrGHZVXkp0fo0TL52AAM9iTpj+NVzateqtDvSuiQyVOcbj2H/9yVJfpqD2DRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785292487; c=relaxed/simple;
	bh=WkG/oJZD1KcU7poB04laa7mxoxcnVNM0lK7i/xQEE4E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nN1HdG2GNSg0XGwPqzeCwF8gwmhISZwf897zpNsJwzwCWHAA/pOKOy43c5kiSFFgD6oE0Qgbkjtds/usqTxsPefQQlrsxdKlcdwoV/hqNmeFmgQlTN/eT21G3XkQa+cA64AgLJ80qZyjjvr4gGEZFsejF1GCqv3jL0A/4vUuQ1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=WuOhQ1q5; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WuOhQ1q5"
X-UUID: 0aec31e08af611f1b1788b6acf885367-20260729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=nyD2ZLyTq5wiEGeeAjWZ6IXuUql2AWbemWMgNg/K29s=;
	b=WuOhQ1q5eRTNAVVfACdte3xw3F4tgtWoZG47rptcSEiPcCKS2mVMM7IpRZbMbEP5AzISyq9SPIpbwkP5tZ7/yELI3DWbSWGbfdFieiAU4GE4LKSArhqiiMtE0MA8WgYW9FRzli5CF/5QMkSCIwStD8D5UACIhJdn/ijn6pfK3v4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.18,REQID:ad428a62-84cb-45b4-bd72-2060db15041c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:8a735a6,CLOUDID:e5dae5e1-71f1-405e-92eb-6802d6af74fd,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 0aec31e08af611f1b1788b6acf885367-20260729
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 118028244; Wed, 29 Jul 2026 10:34:37 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 29 Jul 2026 10:34:36 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 29 Jul 2026 10:34:36 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <eason.lai@mediatek.com>
Subject: [PATCH v2 0/3] wifi: mt76: Fix TX performance degradation when IOMMU is enabled
Date: Wed, 29 Jul 2026 10:34:31 +0800
Message-ID: <20260729023434.1105517-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260709075558.1654164-1-eason.lai@mediatek.com>
References: <20260709075558.1654164-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

This series adds a TX preallocated buffer mechanism to fix the TX performance degradation observed after enabling IOMMU.

Currently this feature is only enabled on MT8196, where it has been validated.

Changes in v2:
 - Reword cover letter subject to add wifi: mt76: prefix

Eason Lai (3):
  wifi: mt76: Separate skb and ptr pointers in mt76_txwi_cache
  wifi: mt76: mt792x: Add TX page pool support for IOMMU-enabled systems
  wifi: mt76: mt792x: Restrict TX page pool to MT8196  platform

 drivers/net/wireless/mediatek/mt76/dma.c      |  28 +-
 drivers/net/wireless/mediatek/mt76/dma.h      |   3 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |   9 +-
 .../wireless/mediatek/mt76/mt76_connac_mac.c  |   6 +
 .../net/wireless/mediatek/mt76/mt7925/pci.c   |   2 +
 drivers/net/wireless/mediatek/mt76/mt792x.h   |   1 +
 .../net/wireless/mediatek/mt76/mt792x_dma.c   | 279 +++++++++++++++++-
 7 files changed, 317 insertions(+), 11 deletions(-)

-- 
2.45.2

