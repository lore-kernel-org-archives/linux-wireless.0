Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3D1EC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 728522085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 728522085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbeJKQSz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:55 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35130 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbeJKQSz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id w5-v6so8725385wrt.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6cbIDBsQ9O533WRPhqzY+Nhu9ZHlv9v1zfVgNFeHhtw=;
        b=eLI9S/nnFxX0A9EHmgAPdF4ZHvORodoviCYFLheMS1tC+ZKl8G7i8wG8SYuZJ8TfXj
         Rxm0LDaYW5F9z22lMYCMR8GTsh+Ow5Q2mvIxodtOkY5dz+2Dp3qAEVxsFqfFkj168W5q
         OXLFsDyqeDOWka21EWYIgZPGdJsG+1YRZqCYyJeFB9fl5JWxoEFYFMia70epC1YJddWs
         A3OcJLwDTsaP3Ekvv5zeHx46R9owbIDerWlxM0GjxzHYpZu76tiilZqHKVDM4YwMAt2x
         fcTf7Dkbg1myD4xz2DLvOh5GKKsSD0SnSpNLNAcjha+M77Ag0fzLlW2PLxMM0n07Q/p5
         em2w==
X-Gm-Message-State: ABuFfohF5xORXxfH21an+1bcwSCnv9KVp7qMqRlRzVkDwXHEUgkoEvUb
        Ah/SvmzX6kTgHadMtTWnxaG7mQ==
X-Google-Smtp-Source: ACcGV63EoWwVq2aHRpz5YPJOj8SECkOotxTg7kDgMg9hiRzxCxXeisd3dVjuesUQGfdCnVGLqHJNfA==
X-Received: by 2002:adf:db45:: with SMTP id f5-v6mr684195wrj.237.1539247954182;
        Thu, 11 Oct 2018 01:52:34 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:33 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 12/12] mt76x0: phy: do not run calibration during channel switch
Date:   Thu, 11 Oct 2018 10:52:09 +0200
Message-Id: <dd905ebc10df7e40db65f46fd9b1c1e44fd21256.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not perform phy/vga calibration during channel switch.
Moreover remove mt76x0_agc_save and mt76x0_agc_restore routines
since they are no longer necessary. Furthermore run mt76_set_channel
in order to check if there are pending frame during channel switch

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/main.c  | 22 +++++++++++++------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 --
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 20 +++++------------
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  2 --
 4 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index c9cd0254a979..9273d2d2764a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -16,6 +16,20 @@
 #include <linux/etherdevice.h>
 #include "mt76x0.h"
 
+static int
+mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
+{
+	int ret;
+
+	cancel_delayed_work_sync(&dev->cal_work);
+
+	mt76_set_channel(&dev->mt76);
+	ret = mt76x0_phy_set_channel(dev, chandef);
+	mt76_txq_schedule_all(&dev->mt76);
+
+	return ret;
+}
+
 int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct mt76x02_dev *dev = hw->priv;
@@ -25,7 +39,7 @@ int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		ieee80211_stop_queues(hw);
-		ret = mt76x0_phy_set_channel(dev, &hw->conf.chandef);
+		ret = mt76x0_set_channel(dev, &hw->conf.chandef);
 		ieee80211_wake_queues(hw);
 	}
 
@@ -114,8 +128,6 @@ void mt76x0_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt76x02_dev *dev = hw->priv;
 
-	cancel_delayed_work_sync(&dev->cal_work);
-	mt76x0_agc_save(dev);
 	set_bit(MT76_SCANNING, &dev->mt76.state);
 }
 EXPORT_SYMBOL_GPL(mt76x0_sw_scan);
@@ -125,11 +137,7 @@ void mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
 {
 	struct mt76x02_dev *dev = hw->priv;
 
-	mt76x0_agc_restore(dev);
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
-
-	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
-				     MT_CALIBRATE_INTERVAL);
 }
 EXPORT_SYMBOL_GPL(mt76x0_sw_scan_complete);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 6717d83e0ff6..2187bafaf2e9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -66,8 +66,6 @@ int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value);
 /* PHY */
 void mt76x0_phy_init(struct mt76x02_dev *dev);
 int mt76x0_wait_bbp_ready(struct mt76x02_dev *dev);
-void mt76x0_agc_save(struct mt76x02_dev *dev);
-void mt76x0_agc_restore(struct mt76x02_dev *dev);
 int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 22ef733cacd6..a3c27dc6bb56 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -721,11 +721,11 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	mt76x0_phy_set_chan_bbp_params(dev, rf_bw_band);
 	mt76x02_init_agc_gain(dev);
 
+	if (scan)
+		return 0;
+
 	if (mt76_is_usb(dev)) {
 		mt76x0_vco_cal(dev, channel);
-		if (scan)
-			mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1,
-					      false);
 	} else {
 		/* enable vco */
 		rf_set(dev, MT_RF(0, 4), BIT(7));
@@ -734,6 +734,9 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	mt76x0_phy_set_txpower(dev);
 
+	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+
 	return 0;
 }
 
@@ -770,17 +773,6 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
 }
 
-void mt76x0_agc_save(struct mt76x02_dev *dev)
-{
-	/* Only one RX path */
-	dev->agc_save = FIELD_GET(MT_BBP_AGC_GAIN, mt76_rr(dev, MT_BBP(AGC, 8)));
-}
-
-void mt76x0_agc_restore(struct mt76x02_dev *dev)
-{
-	mt76_rmw_field(dev, MT_BBP(AGC, 8), MT_BBP_AGC_GAIN, dev->agc_save);
-}
-
 static void mt76x0_temp_sensor(struct mt76x02_dev *dev)
 {
 	u32 rf_b7_73, rf_b0_66, rf_b0_67;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index f375fdcbd2bf..47c42c607964 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -102,8 +102,6 @@ struct mt76x02_dev {
 
 	bool no_2ghz;
 
-	u8 agc_save;
-
 	u8 coverage_class;
 	u8 slottime;
 
-- 
2.17.2

