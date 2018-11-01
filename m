Return-Path: <SRS0=HAyh=NM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA05AC0044C
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 09:46:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B03362081B
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Nov 2018 09:46:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="AD/3Lu6Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B03362081B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbeKASsU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Nov 2018 14:48:20 -0400
Received: from nbd.name ([46.4.11.11]:53304 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727608AbeKASsS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Nov 2018 14:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZwY2dRzSmJ+hJAvhevPKOmnNohf9XaX8F31IlfpdtJU=; b=AD/3Lu6QGMEVSH17hN0CbE5vdE
        1fax0SEKLmXJbJO25DHZcMfVuYOvut9MCuOlTW/Tdbxv17428SLar8/bjhmX71L64IQ1yDnd8uGS0
        LjxVguGvgm8lr4XH1Q0uAgkan/UTe7p9c7FiYKrnaXpm/iePOXhF3f/G2/La+0g6Xzuo=;
Received: by maeck.local (Postfix, from userid 501)
        id 494F2427BB60; Thu,  1 Nov 2018 10:46:00 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, sgruszka@redhat.com
Subject: [PATCH v2 1/4] mt76: clean up more unused EXPORT_SYMBOLs
Date:   Thu,  1 Nov 2018 10:45:57 +0100
Message-Id: <20181101094600.37077-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make functions static where possible

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  | 9 +--------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h  | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 1 -
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 4fb9f095ffec..34fc9f2eb51f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -128,7 +128,6 @@ void mt76x02_mac_wcid_set_drop(struct mt76x02_dev *dev, u8 idx, bool drop)
 	if ((val & bit) != (bit * drop))
 		mt76_wr(dev, MT_WCID_DROP(idx), (val & ~bit) | (bit * drop));
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_set_drop);
 
 void mt76x02_txq_init(struct mt76x02_dev *dev, struct ieee80211_txq *txq)
 {
@@ -220,7 +219,6 @@ void mt76x02_mac_set_short_preamble(struct mt76x02_dev *dev, bool enable)
 	else
 		mt76_clear(dev, MT_AUTO_RSP_CFG, MT_AUTO_RSP_PREAMB_SHORT);
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_set_short_preamble);
 
 bool mt76x02_mac_load_tx_status(struct mt76x02_dev *dev,
 				struct mt76x02_tx_status *stat)
@@ -491,7 +489,7 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 	rcu_read_unlock();
 }
 
-int
+static int
 mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate)
 {
 	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
@@ -557,7 +555,6 @@ mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_process_rate);
 
 void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr)
 {
@@ -823,7 +820,6 @@ void mt76x02_mac_work(struct work_struct *work)
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
 				     MT_CALIBRATE_INTERVAL);
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_work);
 
 void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
 {
@@ -832,7 +828,6 @@ void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
 	mt76_rmw_field(dev, MT_MAC_APC_BSSID_H(idx), MT_MAC_APC_BSSID_H_ADDR,
 		       get_unaligned_le16(addr + 4));
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_set_bssid);
 
 static int
 mt76x02_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
@@ -914,7 +909,6 @@ int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 		       bcn_idx - 1);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_set_beacon);
 
 void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 				   u8 vif_idx, bool val)
@@ -946,4 +940,3 @@ void mt76x02_mac_set_beacon_enable(struct mt76x02_dev *dev,
 	else
 		mt76x02_irq_disable(dev, MT_INT_PRE_TBTT | MT_INT_TBTT);
 }
-EXPORT_SYMBOL_GPL(mt76x02_mac_set_beacon_enable);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index f65157600779..e2c47ca18d85 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -216,7 +216,6 @@ void mt76x02_send_tx_status(struct mt76x02_dev *dev,
 			    struct mt76x02_tx_status *stat, u8 *update);
 int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 			   void *rxi);
-int mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate);
 void mt76x02_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
 void mt76x02_mac_setaddr(struct mt76x02_dev *dev, u8 *addr);
 void mt76x02_mac_write_txwi(struct mt76x02_dev *dev, struct mt76x02_txwi *txwi,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 9f083008dbd4..c0f923942edc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -606,7 +606,6 @@ const u16 mt76x02_beacon_offsets[16] = {
 	0xc000,
 	0xc000,
 };
-EXPORT_SYMBOL_GPL(mt76x02_beacon_offsets);
 
 static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 {
-- 
2.17.0

