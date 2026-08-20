Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7390C418A29
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 11:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787224355; cv=none; b=FQjj6+l2qBy16EKyOQ1M9/xogdKm84KJX95XJrOnKWZqAepslsX8Y6oMGHetEgeXawAXHnACS0ADZT8eo5XuVFCeoxR2SEbPDtF1CS16YXun+trghlbgEEAKjJ3T1QMcSIfJw+Rb2+WtJGubHH6RDoHt52f8lJa4GxlcZ4CmoGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787224355; c=relaxed/simple;
	bh=41Ban4+7UAnMokEl38Ik/dm0WL/wHNH0pgDIo85f5DA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EdJAx56vd5imq+SJVwe7Ge5BaZDyXXtAePjAFXPlJUQWhsCmlU8mRS67VIy0iXSIGCTYDN8tSuoZrSS17B/mLtzNn/ewAP/2y52ggCmJkYTqB30e/U4TyCHp7Jch1J7PfQTvrazbJ6v9LyMmJpCfozRkSq5jj1KWZMIrqcixQHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=C4aX7Loj; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="C4aX7Loj"
X-UUID: ffab61409c8711f18dc8c9802ae25ab1-20260820
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=IokGN/BgcpgUvROnkPq/p85oGGiZeBiuq4lIOBgjG2Q=;
	b=C4aX7LojRqHKuO0/HgqH1mJKWwN2WLJL2/tqMdNfc1alPCrhl0aFW9Fw1HXZ1a2M/1vkOiX8nmPO/tMVml99iSbcrqHVR8dY8u9ydr2ku0Yw6H3UQU/iBp/mVE64ZSuuaG4htSOehG5fIgd8KiWcMbobvMfz+a2AK3o6O35kadY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:e1a00b08-e21c-484a-b15e-e3a134e34d86,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:056594ad-0ff9-4d54-aff2-bb01eaf823d8,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:1,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ffab61409c8711f18dc8c9802ae25ab1-20260820
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1492645626; Thu, 20 Aug 2026 19:12:14 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 20 Aug 2026 19:12:13 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Thu, 20 Aug 2026 19:12:13 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH v1] [PATCH 03/05] wifi: mt76: add ACPI MTFG option for bus configuration
Date: Thu, 20 Aug 2026 19:12:00 +0800
Message-ID: <20260820111202.1935373-3-anthony.liu@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260820111202.1935373-1-anthony.liu@mediatek.com>
References: <20260820111202.1935373-1-anthony.liu@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

Extend ACPI MTFG table parsing to support an additional MTFG bus
configuration option.

Change-Id: Ic8b9b4a70280439fd940dd96ca84d269b4817d31
CR-Id: WCNCR00542202
Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
Reviewed-on: https://gerrit.mediatek.inc/c/neptune/oss/nbd168_wireless/+/12378112
GAI-Code-Review: srv_ai_review001 <srv_ai_review001@mediatek.com>
AutoUT-Review-Label: srv_neptune_adm <srv_neptune_adm@mediatek.com>
Reviewed-by: jb.tsai <jb.tsai@mediatek.com>
Commit-Check: srv_check_service <srv_check_service@mediatek.com>
Code-Review-Course-Train: srv_check_service <srv_check_service@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd7956e4a..227a6960f135 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -355,6 +355,7 @@ u8 mt792x_acpi_get_flags(struct mt792x_phy *phy)
 	} map[] = {
 		{ 1, 1 },
 		{ 4, 2 },
+		{ 13, 3 },
 	};
 	u8 flags = BIT(0);
 	int i, j;
-- 
2.45.2

