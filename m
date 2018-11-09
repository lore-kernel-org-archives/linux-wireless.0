Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2900AC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6D0E20827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6D0E20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbeKIUAk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:00:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727537AbeKIUAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 15:00:39 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DAD33DD47;
        Fri,  9 Nov 2018 10:20:43 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8981960C60;
        Fri,  9 Nov 2018 10:20:38 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 2/5] mt76x02: initalize mutli bss mode by default
Date:   Fri,  9 Nov 2018 11:20:11 +0100
Message-Id: <1541758814-2046-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 09 Nov 2018 10:20:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Configure multi bss mode by default on all devices. That mean we
use MAC address for MT_MAC_BSSID_DW and use MT_MAC_APC_BSSID
for configuree bssid for each vif.

This is separe from beaconing as we can have for example 2 STA vifs,
so do not mix bssid init and beacon init.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c     | 17 +++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h     |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c    | 13 ++-----------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c |  4 +---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c |  3 ---
 7 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 497e762978cc..5036b61b66f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -347,7 +347,7 @@ int mt76x0_eeprom_init(struct mt76x02_dev *dev)
 	dev_info(dev->mt76.dev, "EEPROM ver:%02hhx fae:%02hhx\n",
 		 version, fae);
 
-	mt76x02_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
+	mt76x02_mac_init_mbss(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
 	mt76x0_set_chip_cap(dev);
 	mt76x0_set_freq_offset(dev);
 	mt76x0_set_temp_offset(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index cfeae5586897..b19f9f5b8b89 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -566,8 +566,11 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 	return 0;
 }
 
-void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr)
+void mt76x02_mac_init_mbss(struct mt76x02_dev *dev, const u8 *addr)
 {
+	static const u8 null_addr[ETH_ALEN] = {};
+	int i;
+
 	ether_addr_copy(dev->mt76.macaddr, addr);
 
 	if (!is_valid_ether_addr(dev->mt76.macaddr)) {
@@ -581,8 +584,18 @@ void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr)
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
-EXPORT_SYMBOL_GPL(mt76x02_mac_setaddr);
+EXPORT_SYMBOL_GPL(mt76x02_mac_init_mbss);
 
 static int
 mt76x02_mac_get_rssi(struct mt76x02_dev *dev, s8 rssi, int chain)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index b076c4305585..c09181f2da2e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -198,7 +198,7 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			   void *rxi);
 void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
-void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr);
+void mt76x02_mac_init_mbss(struct mt76x02_dev *dev, const u8 *addr);
 void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta, int len);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 87ce6a51fb05..2aa3f4b15fd9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -631,16 +631,8 @@ static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 
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
@@ -650,10 +642,9 @@ void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
 
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
index 076b7479ba99..d2ef68c48ea5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -119,9 +119,7 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 	mt76_wr(dev, MT_MCU_CLOCK_CTL, 0x1401);
 	mt76_clear(dev, MT_FCE_L2_STUFF, MT_FCE_L2_STUFF_WR_MPDU_LEN_EN);
 
-	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(macaddr));
-	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(macaddr + 4));
-
+	mt76x02_mac_init_mbss(dev, macaddr);
 	mt76x02_init_beacon_config(dev);
 	if (!hard)
 		return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index de0fbdb02c4d..4fb87deff261 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -189,7 +189,7 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 	if (err < 0)
 		return err;
 
-	mt76x02_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
+	mt76x02_mac_init_mbss(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
 	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
 	if (!mt76x02_wait_for_txrx_idle(&dev->mt76))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index a9ecc92875ae..977e74091a27 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -52,9 +52,6 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 	struct mt76x02_dev *dev = hw->priv;
 	unsigned int idx = 8;
 
-	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
-		mt76x02_mac_setaddr(dev, vif->addr);
-
 	mt76x02_vif_init(dev, vif, idx);
 	return 0;
 }
-- 
1.9.3

