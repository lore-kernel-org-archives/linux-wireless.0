Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948D2C5ACC6
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 556512145D
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 21:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 556512145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbeJQFQY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 01:16:24 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41782 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbeJQFQY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 01:16:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id x12-v6so27216676wru.8
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 14:24:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zBarh2AOAOMe3qCnl0tRJZ/o9vM2EqfygA6d30+GKzw=;
        b=RHHmYJizGusMb7hfHHqkUOkyXA5XStZSVZ6h9C6aK3EVKVVhUrU0/19TXWPat+BfSW
         O/KTTPI/FPSF+BvQKIT1YAZez5TYPmQkE8A97vHY/f30zbfYCxjVjxgD3lLAhMHy1xrP
         XM1qqvg7sEPIlABZ48AEvkKKKxwoc7RajRRPrPh8iD1lYXkyMdZAdUyFo+Rb5DSKrz+r
         QHTJnERI98LCKla9gOBnbhl0WCVRxTTugIOxXSwGVDpY6dm1dogxmA9QKamGlBhmYlZ3
         jgN+0RUBmgvrXBbOYkflnbKQyv0V9vlMG1XSprdOMug8aYdoBzvxnt82kjqJwtzpOHU+
         a/iQ==
X-Gm-Message-State: ABuFfoi/ZJkr1XfttULTo0bkbTJ9/YpFlsvLAwlGInDLEJa5ZSiMDmC4
        zgqPJaW8CuzUjjovYlPYCSwUiTwJIZs=
X-Google-Smtp-Source: ACcGV621iNgY7oXZ1vML9fgLbDtApwH//g1Yu7aQJCBJ4Dbfn9+5DaS8KJs+VcYwaieamC2VNpOtJQ==
X-Received: by 2002:adf:91a4:: with SMTP id 33-v6mr20330393wri.37.1539725044697;
        Tue, 16 Oct 2018 14:24:04 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id 193-v6sm14390046wmj.21.2018.10.16.14.24.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Oct 2018 14:24:04 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 8/9] mt76: introduce mt76x02_init_beacon_config routine
Date:   Tue, 16 Oct 2018 23:23:30 +0200
Message-Id: <336b03019b72fcb7b34003a9007101e60d1e40d6.1539723134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
References: <cover.1539723134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x02_init_beacon_config utility routine in mt76x02-lib
module in order to be reused by mt76x0 driver configuring
BSSID registers and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  8 +----
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 30 +++++++++++++++++--
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 19 +-----------
 4 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 0c4999342e01..dc19dc5e11d9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -136,8 +136,6 @@ static void mt76x0_init_mac_registers(struct mt76x02_dev *dev)
 {
 	RANDOM_WRITE(dev, common_mac_reg_table);
 
-	mt76x02_set_beacon_offsets(dev);
-
 	/* Enable PBF and MAC clock SYS_CTRL[11:10] = 0x3 */
 	RANDOM_WRITE(dev, mt76x0_mac_reg_table);
 
@@ -298,11 +296,6 @@ int mt76x0_init_hardware(struct mt76x02_dev *dev)
 	if (ret)
 		return ret;
 
-	mt76_clear(dev, MT_BEACON_TIME_CFG, (MT_BEACON_TIME_CFG_TIMER_EN |
-					     MT_BEACON_TIME_CFG_SYNC_MODE |
-					     MT_BEACON_TIME_CFG_TBTT_EN |
-					     MT_BEACON_TIME_CFG_BEACON_TX));
-
 	mt76x0_reset_counters(dev);
 
 	ret = mt76x0_eeprom_init(dev);
@@ -310,6 +303,7 @@ int mt76x0_init_hardware(struct mt76x02_dev *dev)
 		return ret;
 
 	mt76x0_phy_init(dev);
+	mt76x02_init_beacon_config(dev);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 1733226b657d..a4141265d7a9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -156,7 +156,7 @@ int mt76x02_get_txpower(struct ieee80211_hw *hw,
 void mt76x02_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
 extern const u16 mt76x02_beacon_offsets[16];
-void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev);
+void mt76x02_init_beacon_config(struct mt76x02_dev *dev);
 void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
 void mt76x02_mac_start(struct mt76x02_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 4e358066bf9b..2a81d2fc5d4d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -560,7 +560,7 @@ const u16 mt76x02_beacon_offsets[16] = {
 };
 EXPORT_SYMBOL_GPL(mt76x02_beacon_offsets);
 
-void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
+static void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 {
 	u16 val, base = MT_BEACON_BASE;
 	u32 regs[4] = {};
@@ -574,6 +574,32 @@ void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev)
 	for (i = 0; i < 4; i++)
 		mt76_wr(dev, MT_BCN_OFFSET(i), regs[i]);
 }
-EXPORT_SYMBOL_GPL(mt76x02_set_beacon_offsets);
+
+void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
+{
+	static const u8 null_addr[ETH_ALEN] = {};
+	int i;
+
+	mt76_wr(dev, MT_MAC_BSSID_DW0,
+		get_unaligned_le32(dev->mt76.macaddr));
+	mt76_wr(dev, MT_MAC_BSSID_DW1,
+		get_unaligned_le16(dev->mt76.macaddr + 4) |
+		FIELD_PREP(MT_MAC_BSSID_DW1_MBSS_MODE, 3) | /* 8 beacons */
+		MT_MAC_BSSID_DW1_MBSS_LOCAL_BIT);
+
+	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
+		       8 << 4);
+	mt76_wr(dev, MT_INT_TIMER_EN, 0);
+
+	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
+
+	for (i = 0; i < 8; i++) {
+		mt76x02_mac_set_bssid(dev, i, null_addr);
+		mt76x02_mac_set_beacon(dev, i, NULL);
+	}
+	mt76x02_set_beacon_offsets(dev);
+}
+EXPORT_SYMBOL_GPL(mt76x02_init_beacon_config);
 
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index c3c2f4441777..f561f5916625 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -79,7 +79,6 @@ mt76x2_fixup_xtal(struct mt76x02_dev *dev)
 
 static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 {
-	static const u8 null_addr[ETH_ALEN] = {};
 	const u8 *macaddr = dev->mt76.macaddr;
 	u32 val;
 	int i, k;
@@ -123,19 +122,10 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(macaddr));
 	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(macaddr + 4));
 
-	mt76_wr(dev, MT_MAC_BSSID_DW0, get_unaligned_le32(macaddr));
-	mt76_wr(dev, MT_MAC_BSSID_DW1, get_unaligned_le16(macaddr + 4) |
-		FIELD_PREP(MT_MAC_BSSID_DW1_MBSS_MODE, 3) | /* 8 beacons */
-		MT_MAC_BSSID_DW1_MBSS_LOCAL_BIT);
-
-	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
-	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
-		       8 << 4);
 	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
 		       MT_DFS_GP_INTERVAL);
-	mt76_wr(dev, MT_INT_TIMER_EN, 0);
 
-	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
+	mt76x02_init_beacon_config(dev);
 	if (!hard)
 		return 0;
 
@@ -152,11 +142,6 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 		for (k = 0; k < 4; k++)
 			mt76x02_mac_shared_key_setup(dev, i, k, NULL);
 
-	for (i = 0; i < 8; i++) {
-		mt76x02_mac_set_bssid(dev, i, null_addr);
-		mt76x02_mac_set_beacon(dev, i, NULL);
-	}
-
 	for (i = 0; i < 16; i++)
 		mt76_rr(dev, MT_TX_STAT_FIFO);
 
@@ -168,8 +153,6 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 		MT_CH_TIME_CFG_EIFS_AS_BUSY |
 		FIELD_PREP(MT_CH_TIME_CFG_CH_TIMER_CLR, 1));
 
-	mt76x02_set_beacon_offsets(dev);
-
 	mt76x2_set_tx_ackto(dev);
 
 	return 0;
-- 
2.19.0

