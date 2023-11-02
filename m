Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFA2C4332F
	for <linux-wireless@archiver.kernel.org>; Thu,  2 Nov 2023 10:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346230AbjKBKEo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 2 Nov 2023 06:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346256AbjKBKEn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2023 06:04:43 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8992F189
        for <linux-wireless@vger.kernel.org>; Thu,  2 Nov 2023 03:04:21 -0700 (PDT)
X-UUID: 2df1d6a2796711eea33bb35ae8d461a2-20231102
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=X5py3cy/xu4oqRWHELduhlbDNGtG9oSPSUrEgSMyuSY=;
        b=OKzgji8JPctjRJRLQYOzfWrQa6DlkdXWETRT4ZoDZGai1FHvcFzTylXFsqrxFMA6VAj+cxrqi8wIlsoXAFvzMRsf/9JVICOOD41f/YyTsvkljrCO1PY82lFr1PrHEnv2Ip3Mbr1duMaVlhNUojjZL3pXOyyfOtSlKEHq8kn76/Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.33,REQID:05c405a8-06fd-4465-bedd-2899ae62c5ab,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:364b77b,CLOUDID:199112fc-4a48-46e2-b946-12f04f20af8c,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,
        DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 2df1d6a2796711eea33bb35ae8d461a2-20231102
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
        (envelope-from <shayne.chen@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 32215017; Thu, 02 Nov 2023 18:04:15 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 2 Nov 2023 18:04:14 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 2 Nov 2023 18:04:14 +0800
From:   Shayne Chen <shayne.chen@mediatek.com>
To:     Felix Fietkau <nbd@nbd.name>
CC:     linux-wireless <linux-wireless@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        linux-mediatek <linux-mediatek@lists.infradead.org>,
        MeiChia Chiu <meichia.chiu@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>
Subject: [PATCH 8/8] wifi: mt76: connac: fix EHT phy mode check
Date:   Thu, 2 Nov 2023 18:03:02 +0800
Message-ID: <20231102100302.22160-8-shayne.chen@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20231102100302.22160-1-shayne.chen@mediatek.com>
References: <20231102100302.22160-1-shayne.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: MeiChia Chiu <meichia.chiu@mediatek.com>

Add a BSS eht_support check before returning EHT phy mode. Without this
patch, there might be an inconsistency where the softmac layer thinks
the BSS is in HE mode, while the FW thinks it is in EHT mode.

Signed-off-by: MeiChia Chiu <meichia.chiu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index ae6bf3c968df..b475555097ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -1359,7 +1359,7 @@ u8 mt76_connac_get_phy_mode_ext(struct mt76_phy *phy, struct ieee80211_vif *vif,
 	sband = phy->hw->wiphy->bands[band];
 	eht_cap = ieee80211_get_eht_iftype_cap(sband, vif->type);
 
-	if (!eht_cap || !eht_cap->has_eht)
+	if (!eht_cap || !eht_cap->has_eht || !vif->bss_conf.eht_support)
 		return mode;
 
 	switch (band) {
-- 
2.39.2

