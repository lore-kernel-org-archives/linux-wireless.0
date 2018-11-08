Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927D9ECDE4B
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66E522081D
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 14:47:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 66E522081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbeKIAXq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 19:23:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727752AbeKIAXq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 19:23:46 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5A41B9091A;
        Thu,  8 Nov 2018 14:47:56 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3B1518C41;
        Thu,  8 Nov 2018 14:47:55 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC/RFT 4/4] mt76x02: set protection according to ht capabilities
Date:   Thu,  8 Nov 2018 15:47:10 +0100
Message-Id: <1541688430-31855-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
References: <1541688430-31855-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Thu, 08 Nov 2018 14:47:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use information about protection that mac80211 provide to us.
Used protection should be part of ht capabilites that either
remote AP provde to us in STA mode or is set in hostapd.conf
in ht_capab option.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 58 +++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c |  4 ++
 3 files changed, 64 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 567a7ab47fab..6096efc4119b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -753,6 +753,64 @@ void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val)
 		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
 }
 
+void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, bool legacy_prot,
+				   int ht_mode)
+{
+	int mode = ht_mode & IEEE80211_HT_OP_MODE_PROTECTION;
+	bool non_gf = !!(ht_mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
+	u32 prot[6];
+	bool ht_rts[4] = {};
+	int i;
+
+	for (i = 0; i < 6; i++) {
+		prot[i] = mt76_rr(dev, MT_CCK_PROT_CFG + i * 4);
+		if (i >= 2)
+			prot[i] &= ~(MT_PROT_CFG_CTRL | MT_PROT_CFG_RATE);
+	}
+
+	if (legacy_prot) {
+		prot[1] &= ~MT_PROT_CFG_CTRL;
+		prot[1] |= MT_PROT_CTRL_CTS2SELF;
+
+		prot[2] |= MT_PROT_RATE_CCK_11;
+		prot[3] |= MT_PROT_RATE_CCK_11;
+		prot[4] |= MT_PROT_RATE_CCK_11;
+		prot[5] |= MT_PROT_RATE_CCK_11;
+	} else {
+		prot[2] |= MT_PROT_RATE_OFDM_24;
+		prot[3] |= MT_PROT_RATE_DUP_OFDM_24;
+		prot[4] |= MT_PROT_RATE_OFDM_24;
+		prot[5] |= MT_PROT_RATE_DUP_OFDM_24;
+	}
+
+	switch (mode) {
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONE:
+		break;
+
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONMEMBER:
+		ht_rts[0] = ht_rts[1] = ht_rts[2] = ht_rts[3] = true;
+		break;
+
+	case IEEE80211_HT_OP_MODE_PROTECTION_20MHZ:
+		ht_rts[1] = ht_rts[3] = true;
+		break;
+
+	case IEEE80211_HT_OP_MODE_PROTECTION_NONHT_MIXED:
+		ht_rts[0] = ht_rts[1] = ht_rts[2] = ht_rts[3] = true;
+		break;
+	}
+
+	if (non_gf)
+		ht_rts[2] = ht_rts[3] = true;
+
+	for (i = 0; i < 4; i++)
+		if (ht_rts[i])
+			prot[i + 2] |= MT_PROT_CTRL_RTS_CTS;
+
+	for (i = 0; i < 6; i++)
+		mt76_wr(dev, MT_CCK_PROT_CFG + i * 4, prot[i]);
+}
+
 void mt76x02_update_channel(struct mt76_dev *mdev)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 34da8c600db8..9035397ae081 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -197,6 +197,8 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 			    struct mt76x02_tx_status *stat, u8 *update);
 int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			   void *rxi);
+void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, bool legacy_prot,
+				   int ht_mode);
 void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val);
 void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr);
 void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index fda67b0923a6..51db4d3dcc13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -682,6 +682,10 @@ void mt76x02_bss_info_changed(struct ieee80211_hw *hw,
 		tasklet_enable(&dev->pre_tbtt_tasklet);
 	}
 
+	if (changed & BSS_CHANGED_HT || changed & BSS_CHANGED_ERP_CTS_PROT)
+		mt76x02_mac_set_tx_protection(dev, info->use_cts_prot,
+					      info->ht_operation_mode);
+
 	if (changed & BSS_CHANGED_BASIC_RATES &&
 	    vif->type == NL80211_IFTYPE_STATION) {
 		mt76_wr(dev, MT_LEGACY_BASIC_RATE, info->basic_rates);
-- 
1.9.3

