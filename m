Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEB2C64EB1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C8C720892
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 13:27:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C8C720892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbeLGN1Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:27:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbeLGN1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 08:27:25 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E006AC049D7A;
        Fri,  7 Dec 2018 13:27:24 +0000 (UTC)
Received: from localhost (unknown [10.43.2.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F9325EDE0;
        Fri,  7 Dec 2018 13:27:21 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 3/5] mt76x02: set protection according to ht operation element
Date:   Fri,  7 Dec 2018 14:27:09 +0100
Message-Id: <1544189231-3676-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1544189231-3676-1-git-send-email-sgruszka@redhat.com>
References: <1544189231-3676-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 07 Dec 2018 13:27:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Configure protection based on information that are provided to
us either by remote AP or by hostapd via HT operation IE.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 83 +++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  4 ++
 4 files changed, 90 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 9693d6140b3d..3fc7a722ea53 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -731,6 +731,89 @@ void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val)
 		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
 }
 
+void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, bool legacy_prot,
+				   int ht_mode)
+{
+	int mode = ht_mode & IEEE80211_HT_OP_MODE_PROTECTION;
+	bool non_gf = !!(ht_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+	u32 prot[6];
+	u32 vht_prot[3];
+	int i;
+	u16 rts_thr;
+
+	for (i = 0; i < ARRAY_SIZE(prot); i++) {
+		prot[i] = mt76_rr(dev, MT_CCK_PROT_CFG + i * 4);
+		prot[i] &= ~MT_PROT_CFG_CTRL;
+		if (i >= 2)
+			prot[i] &= ~MT_PROT_CFG_RATE;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(vht_prot); i++) {
+		vht_prot[i] = mt76_rr(dev, MT_TX_PROT_CFG6 + i * 4);
+		vht_prot[i] &= ~(MT_PROT_CFG_CTRL | MT_PROT_CFG_RATE);
+	}
+
+	rts_thr = mt76_get_field(dev, MT_TX_RTS_CFG, MT_TX_RTS_CFG_THRESH);
+
+	if (rts_thr != 0xffff)
+		prot[0] |= MT_PROT_CTRL_RTS_CTS;
+
+	if (legacy_prot) {
+		prot[1] |= MT_PROT_CTRL_CTS2SELF;
+
+		prot[2] |= MT_PROT_RATE_CCK_11;
+		prot[3] |= MT_PROT_RATE_CCK_11;
+		prot[4] |= MT_PROT_RATE_CCK_11;
+		prot[5] |= MT_PROT_RATE_CCK_11;
+
+		vht_prot[0] |= MT_PROT_RATE_CCK_11;
+		vht_prot[1] |= MT_PROT_RATE_CCK_11;
+		vht_prot[2] |= MT_PROT_RATE_CCK_11;
+	} else {
+		if (rts_thr != 0xffff)
+			prot[1] |= MT_PROT_CTRL_RTS_CTS;
+
+		prot[2] |= MT_PROT_RATE_OFDM_24;
+		prot[3] |= MT_PROT_RATE_DUP_OFDM_24;
+		prot[4] |= MT_PROT_RATE_OFDM_24;
+		prot[5] |= MT_PROT_RATE_DUP_OFDM_24;
+
+		vht_prot[0] |= MT_PROT_RATE_OFDM_24;
+		vht_prot[1] |= MT_PROT_RATE_DUP_OFDM_24;
+		vht_prot[2] |= MT_PROT_RATE_SGI_OFDM_24;
+	}
+
+	switch (mode) {
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+		prot[2] |= MT_PROT_CTRL_RTS_CTS;
+		prot[3] |= MT_PROT_CTRL_RTS_CTS;
+		prot[4] |= MT_PROT_CTRL_RTS_CTS;
+		prot[5] |= MT_PROT_CTRL_RTS_CTS;
+		vht_prot[0] |= MT_PROT_CTRL_RTS_CTS;
+		vht_prot[1] |= MT_PROT_CTRL_RTS_CTS;
+		vht_prot[2] |= MT_PROT_CTRL_RTS_CTS;
+		break;
+	case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
+		prot[3] |= MT_PROT_CTRL_RTS_CTS;
+		prot[5] |= MT_PROT_CTRL_RTS_CTS;
+		vht_prot[1] |= MT_PROT_CTRL_RTS_CTS;
+		vht_prot[2] |= MT_PROT_CTRL_RTS_CTS;
+		break;
+	}
+
+	if (non_gf) {
+		prot[4] |= MT_PROT_CTRL_RTS_CTS;
+		prot[5] |= MT_PROT_CTRL_RTS_CTS;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(prot); i++)
+		mt76_wr(dev, MT_CCK_PROT_CFG + i * 4, prot[i]);
+
+	for (i = 0; i < ARRAY_SIZE(vht_prot); i++)
+		mt76_wr(dev, MT_TX_PROT_CFG6 + i * 4, vht_prot[i]);
+}
+
 void mt76x02_update_channel(struct mt76_dev *mdev)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index d1a8ed171537..91c76a050f7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -194,6 +194,8 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 			    struct mt76x02_tx_status *stat, u8 *update);
 int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			   void *rxi);
+void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, bool legacy_prot,
+				   int ht_mode);
 void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val);
 void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr);
 void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
index d1ac847adce5..20ad07638699 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_regs.h
@@ -443,6 +443,7 @@
 #define MT_PROT_RATE_OFDM_6		0x2000
 #define MT_PROT_RATE_OFDM_24		0x2004
 #define MT_PROT_RATE_DUP_OFDM_24	0x2084
+#define MT_PROT_RATE_SGI_OFDM_24	0x2104
 #define MT_PROT_TXOP_ALLOW_ALL		GENMASK(25, 20)
 #define MT_PROT_TXOP_ALLOW_BW20		(MT_PROT_TXOP_ALLOW_ALL &	\
 					 ~MT_PROT_TXOP_ALLOW_MM40 &	\
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index e7ee2cc76edf..e6f3de0d2a4b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -661,6 +661,10 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 		tasklet_enable(&dev->pre_tbtt_tasklet);
 	}
 
+	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
+		mt76x02_mac_set_tx_protection(dev, info->use_cts_prot,
+					      info->ht_operation_mode);
+
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
 			       MT_BEACON_TIME_CFG_INTVAL,
-- 
1.9.3

