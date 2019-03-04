Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D00C10F03
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 067E42082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 08:02:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Zajn9z9Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfCDICs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 03:02:48 -0500
Received: from nbd.name ([46.4.11.11]:40458 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbfCDICs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 03:02:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IvSZuw5p7F5Ht9ULV0h6lg7jmbnnKpDGHFmsoHabPqU=; b=Zajn9z9ZZc3uWEL5F+pdzCffSe
        ckifK6OexEKPnQSaR7qmxKpvEmPvyJyVNbVU3ICdE1XAJuijtdpoTKuDsYVCnoib3Rsco4O5+zsFP
        edrifNbfUtBZvsg4jzFKEeRqT49hYuk8ATJOwig/y6FrYbDzlgfFD8u70EDgzqGaEifI=;
Received: by maeck.lan (Postfix, from userid 501)
        id 198F450E5414; Mon,  4 Mar 2019 09:02:34 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 01/11] mt76: mt76x02: reduce false positives in ED/CCA tx blocking
Date:   Mon,  4 Mar 2019 09:02:24 +0100
Message-Id: <20190304080234.3221-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Full tx blocking (as opposed to CCA blocking) should only happen if there
is a continuous non-802.11 signal above the energy detect threshold.
Unfortunately the ED/CCA counter can't detect that, as it also counts 802.11
signals as busy.

Similar to the vendor code, implement a learning mode that waits until the AGC
gain has already been adjusted to the lowest value (due to false CCA events),
and the number of false CCA events still remains high, and the blocking
threshold is exceeded for more than 5 seconds.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  3 +++
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 25 ++++++++++++++++---
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  |  2 ++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 3d93017c3227..0f0fab54e4f1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -51,6 +51,7 @@ struct mt76x02_calibration {
 	u16 false_cca;
 	s8 avg_rssi_all;
 	s8 agc_gain_adjust;
+	s8 agc_lowest_gain;
 	s8 low_gain;
 
 	s8 temp_vco;
@@ -114,8 +115,10 @@ struct mt76x02_dev {
 	struct mt76x02_dfs_pattern_detector dfs_pd;
 
 	/* edcca monitor */
+	unsigned long ed_trigger_timeout;
 	bool ed_tx_blocked;
 	bool ed_monitor;
+	u8 ed_monitor_learning;
 	u8 ed_trigger;
 	u8 ed_silent;
 	ktime_t ed_time;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index e1e0c8da5a8c..9ed231abe916 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -960,6 +960,7 @@ void mt76x02_edcca_init(struct mt76x02_dev *dev, bool enable)
 		}
 	}
 	mt76x02_edcca_tx_enable(dev, true);
+	dev->ed_monitor_learning = true;
 
 	/* clear previous CCA timer value */
 	mt76_rr(dev, MT_ED_CCA_TIMER);
@@ -969,6 +970,10 @@ EXPORT_SYMBOL_GPL(mt76x02_edcca_init);
 
 #define MT_EDCCA_TH		92
 #define MT_EDCCA_BLOCK_TH	2
+#define MT_EDCCA_LEARN_TH	50
+#define MT_EDCCA_LEARN_CCA	180
+#define MT_EDCCA_LEARN_TIMEOUT	(20 * HZ)
+
 static void mt76x02_edcca_check(struct mt76x02_dev *dev)
 {
 	ktime_t cur_time;
@@ -991,11 +996,23 @@ static void mt76x02_edcca_check(struct mt76x02_dev *dev)
 		dev->ed_trigger = 0;
 	}
 
-	if (dev->ed_trigger > MT_EDCCA_BLOCK_TH &&
-	    !dev->ed_tx_blocked)
+	if (dev->cal.agc_lowest_gain &&
+	    dev->cal.false_cca > MT_EDCCA_LEARN_CCA &&
+	    dev->ed_trigger > MT_EDCCA_LEARN_TH) {
+		dev->ed_monitor_learning = false;
+		dev->ed_trigger_timeout = jiffies + 20 * HZ;
+	} else if (!dev->ed_monitor_learning &&
+		   time_is_after_jiffies(dev->ed_trigger_timeout)) {
+		dev->ed_monitor_learning = true;
+		mt76x02_edcca_tx_enable(dev, true);
+	}
+
+	if (dev->ed_monitor_learning)
+		return;
+
+	if (dev->ed_trigger > MT_EDCCA_BLOCK_TH && !dev->ed_tx_blocked)
 		mt76x02_edcca_tx_enable(dev, false);
-	else if (dev->ed_silent > MT_EDCCA_BLOCK_TH &&
-		 dev->ed_tx_blocked)
+	else if (dev->ed_silent > MT_EDCCA_BLOCK_TH && dev->ed_tx_blocked)
 		mt76x02_edcca_tx_enable(dev, true);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index a020c757ba5c..a54b63a96eae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -194,6 +194,8 @@ bool mt76x02_phy_adjust_vga_gain(struct mt76x02_dev *dev)
 		ret = true;
 	}
 
+	dev->cal.agc_lowest_gain = dev->cal.agc_gain_adjust >= limit;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_adjust_vga_gain);
-- 
2.17.0

