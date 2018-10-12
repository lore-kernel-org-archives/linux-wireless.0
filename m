Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C595C6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F4CD20868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F4CD20868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbeJLRs3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43020 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728426AbeJLRs2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id n1-v6so12810109wrt.10
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sMrbuVWxMZIXH9fBXlBOhvFBSqcfBOeh0Dbr0uv9+eM=;
        b=n/4RBpTw2bY/oLVMMtJsRO6q5oNbdhygvh42/N3yiwf5GZ1HyFtZncuvKbFM96LbmM
         rT9qvfvAL3eFe3H7NfLid4Rlg5G8G1oLMu206qGG/PX9LHQaT6Uoh8oc9XG6U/glSvVG
         I39TsX5YXWLD6xlAEL1dtDa1rU+WYZR5DZrmlIvr0K/su+IolNvumjDlN0tudHteedaF
         ROk/ZrCcK46tFqekXQCo9zuBPyotmVjFsUiz23QRhtQtrWTXKJndFd2Haq7UNzYbLZHz
         tWQWIN4nd8s7zDbr3X5d4a8iC341sHl98AFOeGqmWET7MJBBg0jF5Rfvsdofd/poYlAf
         b9Cg==
X-Gm-Message-State: ABuFfoiyVq7U6eABs3+J0RL/PpRIAqkeb98N9GEDYfTltj5V0jnvBwJw
        QUAhtKJmgMuNHvmhTc4IODfqdIQ1Ayw=
X-Google-Smtp-Source: ACcGV63CyhWItqKsDDZTeWf4YcG6VvlZPeNd2s9bc2CYv5bXCxsvSyQLldG0EENPMFXphQy1RYr/EA==
X-Received: by 2002:a5d:438e:: with SMTP id i14-v6mr5068822wrq.156.1539339405829;
        Fri, 12 Oct 2018 03:16:45 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:45 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 04/13] mt76x0: pci: introduce mt76x0_phy_calirate routine
Date:   Fri, 12 Oct 2018 12:16:20 +0200
Message-Id: <326458a15d0c242e7419e3bfc0033ccdc9083676.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add mt76x0_phy_calirate routine in order to perform
phy calibration for mt76x0e devices.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |  3 ++
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  1 +
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 53 +++++++++++++++++--
 4 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
index b66e70f6cd89..3b34e1d2769f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
@@ -39,6 +39,9 @@ enum mcu_calibrate {
 	MCU_CAL_TXDCOC,
 	MCU_CAL_RX_GROUP_DELAY,
 	MCU_CAL_TX_GROUP_DELAY,
+	MCU_CAL_VCO,
+	MCU_CAL_NO_SIGNAL = 0xfe,
+	MCU_CAL_FULL = 0xff,
 };
 
 int mt76x0e_mcu_init(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 1bff2be45a13..6717d83e0ff6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -72,6 +72,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			    struct cfg80211_chan_def *chandef);
 void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev);
 void mt76x0_phy_set_txpower(struct mt76x02_dev *dev);
+void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on);
 
 /* MAC */
 void mt76x0_mac_work(struct work_struct *work);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 10845f37af37..f31c63444c82 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -28,6 +28,7 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 	mutex_lock(&dev->mt76.mutex);
 
 	mt76x02_mac_start(dev);
+	mt76x0_phy_calibrate(dev, true);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mac_work,
 				     MT_CALIBRATE_INTERVAL);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 9a8e1fcee26b..6bd5aa67d400 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -581,6 +581,48 @@ void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
 	mt76x02_phy_set_txpower(dev, info[0], info[1]);
 }
 
+void mt76x0_phy_calibrate(struct mt76x02_dev *dev, bool power_on)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	u32 val, tx_alc, reg_val;
+
+	if (power_on) {
+		mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_VCO, chan->hw_value,
+				      false);
+		usleep_range(10, 20);
+		/* XXX: tssi */
+	}
+
+	tx_alc = mt76_rr(dev, MT_TX_ALC_CFG_0);
+	mt76_wr(dev, MT_TX_ALC_CFG_0, 0);
+	usleep_range(500, 700);
+
+	reg_val = mt76_rr(dev, MT_BBP(IBI, 9));
+	mt76_wr(dev, MT_BBP(IBI, 9), 0xffffff7e);
+
+	if (chan->band == NL80211_BAND_5GHZ) {
+		if (chan->hw_value < 100)
+			val = 0x701;
+		else if (chan->hw_value < 140)
+			val = 0x801;
+		else
+			val = 0x901;
+	} else {
+		val = 0x600;
+	}
+
+	mt76x02_mcu_calibrate(dev, MCU_CAL_FULL, val, false);
+	msleep(350);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 1, false);
+	usleep_range(15000, 20000);
+
+	mt76_wr(dev, MT_BBP(IBI, 9), reg_val);
+	mt76_wr(dev, MT_TX_ALC_CFG_0, tx_alc);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
+}
+EXPORT_SYMBOL_GPL(mt76x0_phy_calibrate);
+
 int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 			   struct cfg80211_chan_def *chandef)
 {
@@ -671,9 +713,14 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 	/* Vendor driver don't do it */
 	/* mt76x0_phy_set_tx_power(dev, channel, rf_bw_band); */
 
-	mt76x0_vco_cal(dev, channel);
-	if (scan)
-		mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
+	if (mt76_is_usb(dev)) {
+		mt76x0_vco_cal(dev, channel);
+		if (scan)
+			mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1,
+					      false);
+	} else {
+		mt76x0_phy_calibrate(dev, false);
+	}
 
 	mt76x0_phy_set_txpower(dev);
 
-- 
2.17.2

