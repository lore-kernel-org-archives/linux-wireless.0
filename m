Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2AFFC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 948652085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 948652085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727670AbeJKQSp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:45 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53386 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbeJKQSp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:45 -0400
Received: by mail-wm1-f66.google.com with SMTP id y11-v6so8110176wma.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b5WwaW4si7bw34Y7AH9984pXepEksr2eQHK2C8Ct4Hs=;
        b=SeviFw9GcpjalrwWn0TwhWWnx2fgLClX+ZYrzQaffhyXFx+fpWRMBmERZBtjHhFpHz
         WDIZXn19px3+cOyOEqcpZHD//S2dXCdLYIpmFiulT3k4gG9bdqvOC8xoDJPx55glZijH
         Vamy3JX0/mHStf0FdAMgznCL55q6k+T/Z8nziSQPyQNikdmgaMJFGJ3j2y9n/TyEWzYh
         LTXv28F1vftDKN2dhMppGrn1KVPLPexUoFWmmtxfHc5uAiqrxJX3ppW2yrtpABUzd1Or
         IJJWun9GqYdTfvcXQtQXRW8HJQeAIFAwNQ7X/n8ri2iDjY9stNaVMCL88J4M41gkgOE2
         Wnkg==
X-Gm-Message-State: ABuFfoh0vxdliG2PtLh2OlvcXfn/8ojDdN4n94lJRI4HXsW4LLhvRb9k
        0UY9Jcp/xMoGE2OkAWLw6UMKSOM0bmk=
X-Google-Smtp-Source: ACcGV617LKKSv5nLCbI2h9hOFUnDWVkYTbyoL+XUykDUvTDYxZMiCWEO5GZZKxu0/horTpe/aTTcqw==
X-Received: by 2002:a1c:a851:: with SMTP id r78-v6mr852730wme.97.1539247943609;
        Thu, 11 Oct 2018 01:52:23 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:23 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 01/12] mt76: move mt76x02_phy_set_bw in mt76x02-lib module
Date:   Thu, 11 Oct 2018 10:51:58 +0200
Message-Id: <a086a2e7a0195f33d04f2439af1fffa4efd9fd78.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_phy_set_bw routine in mt76x02_phy.c since
it is shared between mt76x0 and mt76x2 drivers and remove
duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 29 +------------------
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  | 26 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  1 +
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   | 26 -----------------
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   |  2 +-
 7 files changed, 30 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 7c30ba47c7f4..3bc6d7b0914a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -214,33 +214,6 @@ int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev)
 	return 0;
 }
 
-static void
-mt76x0_bbp_set_ctrlch(struct mt76x02_dev *dev, enum nl80211_chan_width width,
-		      u8 ctrl)
-{
-	int core_val, agc_val;
-
-	switch (width) {
-	case NL80211_CHAN_WIDTH_80:
-		core_val = 3;
-		agc_val = 7;
-		break;
-	case NL80211_CHAN_WIDTH_40:
-		core_val = 2;
-		agc_val = 3;
-		break;
-	default:
-		core_val = 0;
-		agc_val = 1;
-		break;
-	}
-
-	mt76_rmw_field(dev, MT_BBP(CORE, 1), MT_BBP_CORE_R1_BW, core_val);
-	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_BW, agc_val);
-	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_CTRL_CHAN, ctrl);
-	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
-}
-
 static void mt76x0_vco_cal(struct mt76x02_dev *dev, u8 channel)
 {
 	u8 val;
@@ -681,7 +654,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	}
 
 	mt76x0_bbp_set_bw(dev, chandef->width);
-	mt76x0_bbp_set_ctrlch(dev, chandef->width, ch_group_index);
+	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 	mt76x0_mac_set_ctrlch(dev, ch_group_index & 1);
 	mt76x0_ant_select(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index c398471b6376..3de7170db111 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -178,3 +178,29 @@ int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev)
 	return min_rssi;
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_get_min_avg_rssi);
+
+void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl)
+{
+	int core_val, agc_val;
+
+	switch (width) {
+	case NL80211_CHAN_WIDTH_80:
+		core_val = 3;
+		agc_val = 7;
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		core_val = 2;
+		agc_val = 3;
+		break;
+	default:
+		core_val = 0;
+		agc_val = 1;
+		break;
+	}
+
+	mt76_rmw_field(dev, MT_BBP(CORE, 1), MT_BBP_CORE_R1_BW, core_val);
+	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_BW, agc_val);
+	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_CTRL_CHAN, ctrl);
+	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
+}
+EXPORT_SYMBOL_GPL(mt76x02_phy_set_bw);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index c370b4cc68ee..e0ca44ed5081 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -26,5 +26,6 @@ int mt76x02_get_max_rate_power(struct mt76_rate_power *r);
 void mt76x02_phy_set_rxpath(struct mt76x02_dev *dev);
 void mt76x02_phy_set_txdac(struct mt76x02_dev *dev);
 int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev);
+void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl);
 
 #endif /* __MT76x02_PHY_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index cbec8c6f1b2d..8b18acafedb2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -100,7 +100,6 @@ void mt76x2_phy_set_txpower_regs(struct mt76x02_dev *dev,
 				 enum nl80211_band band);
 void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 			       enum nl80211_band band, u8 bw);
-void mt76x2_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl);
 void mt76x2_phy_set_band(struct mt76x02_dev *dev, int band, bool primary_upper);
 void mt76x2_apply_gain_adj(struct mt76x02_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index dbb63d4c3bad..991db4f48d94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -338,7 +338,7 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x2_phy_set_txpower(dev);
 
 	mt76x2_phy_set_band(dev, chan->band, ch_group_index & 1);
-	mt76x2_phy_set_bw(dev, chandef->width, ch_group_index);
+	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
 		 (MT_EXT_CCA_CFG_CCA0 |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index fd077e8d8dcb..dcb3381cab91 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -210,32 +210,6 @@ void mt76x2_configure_tx_delay(struct mt76x02_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_configure_tx_delay);
 
-void mt76x2_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl)
-{
-	int core_val, agc_val;
-
-	switch (width) {
-	case NL80211_CHAN_WIDTH_80:
-		core_val = 3;
-		agc_val = 7;
-		break;
-	case NL80211_CHAN_WIDTH_40:
-		core_val = 2;
-		agc_val = 3;
-		break;
-	default:
-		core_val = 0;
-		agc_val = 1;
-		break;
-	}
-
-	mt76_rmw_field(dev, MT_BBP(CORE, 1), MT_BBP_CORE_R1_BW, core_val);
-	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_BW, agc_val);
-	mt76_rmw_field(dev, MT_BBP(AGC, 0), MT_BBP_AGC_R0_CTRL_CHAN, ctrl);
-	mt76_rmw_field(dev, MT_BBP(TXBE, 0), MT_BBP_TXBE_R0_CTRL_CHAN, ctrl);
-}
-EXPORT_SYMBOL_GPL(mt76x2_phy_set_bw);
-
 void mt76x2_phy_set_band(struct mt76x02_dev *dev, int band, bool primary_upper)
 {
 	switch (band) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index 422114de695a..ff2fd71a0c14 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -156,7 +156,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x2_phy_set_txpower(dev);
 
 	mt76x2_phy_set_band(dev, chan->band, ch_group_index & 1);
-	mt76x2_phy_set_bw(dev, chandef->width, ch_group_index);
+	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 
 	mt76_rmw(dev, MT_EXT_CCA_CFG,
 		 (MT_EXT_CCA_CFG_CCA0 |
-- 
2.17.2

