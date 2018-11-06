Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF294C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3A482081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 17:00:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3A482081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389472AbeKGC0T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 21:26:19 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39888 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389285AbeKGC0S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 21:26:18 -0500
Received: by mail-wr1-f67.google.com with SMTP id r10-v6so14348737wrv.6
        for <linux-wireless@vger.kernel.org>; Tue, 06 Nov 2018 09:00:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ApYZFf76b5XRsmIvDN9IPXMTLRw15PGsC2g0FCH5Zfg=;
        b=J87F8uJPBPGRXY4LjB2J4EH0mm3MWXSGUb8UknOJ7UMZh37csFb+XT/Pi5hRjNoLXY
         3WnG9xBJosfHdhCaxhsHheBcxj7Ikkvh7w711X8YZIXlJAbDhGntl8rC/WnuA/gh7Q1P
         O/oq/6V0tEbAJUWDlEtxewjun3HKRtY37TIUJhZpo6QOnNGpXgmlNd8xKEpkuCXutSZC
         QoGEOL2lH5baVxQvci0glk95WM4M/0v6Hsqf3CMlcp4kRDPJ2m0Ovrh4EyDjPHf8iTCN
         9Zo2lIsGkYn5xnrbBJdFF82JFuKAhUfibzRz7essg2AKTwB4Ke71LwnHRBs9fqgSfjDs
         Pvsg==
X-Gm-Message-State: AGRZ1gL4l2gszpOi6Yag07b4IdZTx1p47nRyX+Wk30HDdd0weKSZ+fPc
        vtWUAJyz6Wh4UEK9i4Vimd9Osg==
X-Google-Smtp-Source: AJdET5dCOy44sh/qlOCafTukmL1sdOf72rjNqvBXdy+L+uCUmx4uyzluv+V9LTCrA7IyN+iLpl/kuQ==
X-Received: by 2002:adf:fe44:: with SMTP id m4-v6mr7152359wrs.309.1541523609731;
        Tue, 06 Nov 2018 09:00:09 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id x142-v6sm649271wmd.20.2018.11.06.09.00.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Nov 2018 09:00:09 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] mt76x2u: phy: run phy_channel_calibrate after channel switch
Date:   Tue,  6 Nov 2018 17:59:46 +0100
Message-Id: <b61ef7cc5e7e940e168e95201bfb03cf8c205af5.1541522368.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1541522368.git.lorenzo.bianconi@redhat.com>
References: <cover.1541522368.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Perform channel calibration after each channel switch and not only after
connection establishment since NetworkManager perform multiple frequency
scanning if RSSI in lower a given threshold

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h    |  1 -
 .../wireless/mediatek/mt76/mt76x2/usb_main.c   |  5 -----
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c    | 18 +++++++++++++++---
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
index 833974de5c80..0b0075411b34 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
@@ -43,7 +43,6 @@ int mt76x2u_mac_stop(struct mt76x02_dev *dev);
 int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x2u_phy_calibrate(struct work_struct *work);
-void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev);
 
 void mt76x2u_mcu_complete_urb(struct urb *urb);
 int mt76x2u_mcu_init(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index c2e0a43082e5..cad99715997e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -91,11 +91,6 @@ mt76x2u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_lock(&dev->mt76.mutex);
 
-	if (changed & BSS_CHANGED_ASSOC) {
-		mt76x2u_phy_channel_calibrate(dev);
-		mt76x2_apply_gain_adj(dev);
-	}
-
 	if (changed & BSS_CHANGED_BSSID) {
 		mt76_wr(dev, MT_MAC_BSSID_DW0,
 			get_unaligned_le32(info->bssid));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index 24e292e895b6..a64268e8db42 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -18,15 +18,20 @@
 #include "eeprom.h"
 #include "../mt76x02_phy.h"
 
-void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev)
+static void
+mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev, bool mac_stopped)
 {
 	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
 	bool is_5ghz = chan->band == NL80211_BAND_5GHZ;
 
+	if (dev->cal.channel_cal_done)
+		return;
+
 	if (mt76x2_channel_silent(dev))
 		return;
 
-	mt76x2u_mac_stop(dev);
+	if (!mac_stopped)
+		mt76x2u_mac_stop(dev);
 
 	if (is_5ghz)
 		mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 0, false);
@@ -37,7 +42,11 @@ void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev)
 	mt76x02_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0, false);
 	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_SHAPING, 0, false);
 
-	mt76x2u_mac_resume(dev);
+	if (!mac_stopped)
+		mt76x2u_mac_resume(dev);
+	mt76x2_apply_gain_adj(dev);
+
+	dev->cal.channel_cal_done = true;
 }
 
 void mt76x2u_phy_calibrate(struct work_struct *work)
@@ -45,6 +54,7 @@ void mt76x2u_phy_calibrate(struct work_struct *work)
 	struct mt76x02_dev *dev;
 
 	dev = container_of(work, struct mt76x02_dev, cal_work.work);
+	mt76x2u_phy_channel_calibrate(dev, false);
 	mt76x2_phy_tssi_compensate(dev, false);
 	mt76x2_phy_update_channel_gain(dev);
 
@@ -165,7 +175,9 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 	if (scan)
 		return 0;
 
+	mt76x2u_phy_channel_calibrate(dev, true);
 	mt76x02_init_agc_gain(dev);
+
 	if (mt76x2_tssi_enabled(dev)) {
 		/* init default values for temp compensation */
 		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
-- 
2.17.2

