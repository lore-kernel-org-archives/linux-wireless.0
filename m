Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75ED0C282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 506872148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfA1MWG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 07:22:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfA1MWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 07:22:06 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 29C5788E51;
        Mon, 28 Jan 2019 12:22:05 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EA11962957;
        Mon, 28 Jan 2019 12:22:01 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v2 3/7] mt76x02: initialize mutli bss mode when set up address
Date:   Mon, 28 Jan 2019 13:21:44 +0100
Message-Id: <1548678108-9526-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 28 Jan 2019 12:22:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

BSSID is not strtirct related with beaconing (for example we can have
2 STA vifs) and more related with MAC address, so initaize BSSID when
setting MAC address.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 15 ++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 13 ++-----------
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c  |  4 +---
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 63fa27d2c404..ae1727e433f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -548,8 +548,11 @@ mt76x02_mac_process_rate(struct mt76x02_dev *dev,
 	return 0;
 }
 
-void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr)
+void mt76x02_mac_setaddr(struct mt76x02_dev *dev, const u8 *addr)
 {
+	static const u8 null_addr[ETH_ALEN] = {};
+	int i;
+
 	ether_addr_copy(dev->mt76.macaddr, addr);
 
 	if (!is_valid_ether_addr(dev->mt76.macaddr)) {
@@ -563,6 +566,16 @@ void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr)
 	mt76_wr(dev, MT_MAC_ADDR_DW1,
 		get_unaligned_le16(dev->mt76.macaddr + 4) |
 		FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
+
+	mt76_wr(dev, MT_MAC_BSSID_DW0,
+		get_unaligned_le32(dev->mt76.macaddr));
+	mt76_wr(dev, MT_MAC_BSSID_DW1,
+		get_unaligned_le16(dev->mt76.macaddr + 4) |
+		FIELD_PREP(MT_MAC_BSSID_DW1_MBSS_MODE, 3) | /* 8 APs + 8 STAs */
+		MT_MAC_BSSID_DW1_MBSS_LOCAL_BIT);
+
+	for (i = 0; i < 16; i++)
+		mt76x02_mac_set_bssid(dev, i, null_addr);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_setaddr);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 940c07f665cd..76e564b8f5da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -191,7 +191,7 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, bool legacy_prot,
 				   int ht_mode);
 void mt76x02_mac_set_rts_thresh(struct mt76x02_dev *dev, u32 val);
-void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr);
+void mt76x02_mac_setaddr(struct mt76x02_dev *dev, const u8 *addr);
 void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta, int len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 187e600cf22e..361811d6510c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -667,16 +667,8 @@ static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 
 void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
 {
-	static const u8 null_addr[ETH_ALEN] = {};
 	int i;
 
-	mt76_wr(dev, MT_MAC_BSSID_DW0,
-		get_unaligned_le32(dev->mt76.macaddr));
-	mt76_wr(dev, MT_MAC_BSSID_DW1,
-		get_unaligned_le16(dev->mt76.macaddr + 4) |
-		FIELD_PREP(MT_MAC_BSSID_DW1_MBSS_MODE, 3) | /* 8 beacons */
-		MT_MAC_BSSID_DW1_MBSS_LOCAL_BIT);
-
 	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
 	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
 		       8 << 4);
@@ -686,10 +678,9 @@ void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
 
 	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
 
-	for (i = 0; i < 8; i++) {
-		mt76x02_mac_set_bssid(dev, i, null_addr);
+	for (i = 0; i < 8; i++)
 		mt76x02_mac_set_beacon(dev, i, NULL);
-	}
+
 	mt76x02_set_beacon_offsets(dev);
 }
 EXPORT_SYMBOL_GPL(mt76x02_init_beacon_config);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 4347d5e7a915..0ccaa64d97ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -119,9 +119,7 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 	mt76_wr(dev, MT_MCU_CLOCK_CTL, 0x1401);
 	mt76_clear(dev, MT_FCE_L2_STUFF, MT_FCE_L2_STUFF_WR_MPDU_LEN_EN);
 
-	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(macaddr));
-	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(macaddr + 4));
-
+	mt76x02_mac_setaddr(dev, macaddr);
 	mt76x02_init_beacon_config(dev);
 	if (!hard)
 		return 0;
-- 
2.19.2

