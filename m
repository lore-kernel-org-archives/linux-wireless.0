Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AD4C6786C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0562820868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 10:16:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0562820868
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbeJLRs3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 13:48:29 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38345 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728366AbeJLRs3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 13:48:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id a13-v6so12828275wrt.5
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 03:16:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2ATLtAkzcEPk5OCpxxTHw0LmyDdWBGlGPeZAMdvHGt8=;
        b=DPOQBm+OsqUJ1xgTAaF1/g/UmxHASG9ix+OV1/ushLorUFMtIk4MdIHBT9mIDej/nN
         GeYcu5hC50bBgqzLua6GEoLTO7Vyy+AhJVkKMEXm2Q5fYhX7jcS4+aMIuuInVy0RkTkk
         4Sx3RJvvWzCCwYnvA0j4tVUXIE5oeXHSCwJYSP10wcukTnqf+i0yeEZ9KEFIeojiEuCV
         QR1TL7werBn13DEYTJaYlKCQ31ZfB4Fx5DCZVlmvCpQlM9+DUVISysv4IdbtLK1LuyoF
         um9m6q8Yw6Vi12ipnSsVZODFcwQb/ig59sSkyjvYGyP7rYefB3JuJ5yMPz4wADeEvTfU
         i2NA==
X-Gm-Message-State: ABuFfogqwU9zk1sZ8nG2McRCpon8g1aVZcnAH+ib9oYIfFgTG1k2KwcU
        Xlnf92YJJODydp239K6qlPlnAMdX/ns=
X-Google-Smtp-Source: ACcGV61JLBI2l8KyqjM6FjQQVCkAgKNWfdKYv2UO4Caukc6yc64qWEv6njC+cbuI7Rl238ZLDNYLkw==
X-Received: by 2002:adf:92e6:: with SMTP id 93-v6mr5004934wrn.124.1539339406765;
        Fri, 12 Oct 2018 03:16:46 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r2-v6sm473179wrq.1.2018.10.12.03.16.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 03:16:46 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 05/13] mt76x0: phy: update set_channel for mt76x0e devices
Date:   Fri, 12 Oct 2018 12:16:21 +0200
Message-Id: <ead039e4a294e4cba8784adbd2e1c0a203f068fe.1539338611.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not run mt76x0_vco_cal and mt76x0_bbp_set_bw routines and
configure MT_TX_SW_CFG0 register for pcie devices in
mt76x0_phy_set_channel function.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/phy.c    | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 6bd5aa67d400..fddfdb1e1756 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -682,7 +682,16 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 		break;
 	}
 
-	mt76x0_bbp_set_bw(dev, chandef->width);
+	if (mt76_is_usb(dev)) {
+		mt76x0_bbp_set_bw(dev, chandef->width);
+	} else {
+		if (chandef->width == NL80211_CHAN_WIDTH_80 ||
+		    chandef->width == NL80211_CHAN_WIDTH_40)
+			val = 0x201;
+		else
+			val = 0x601;
+		mt76_wr(dev, MT_TX_SW_CFG0, val);
+	}
 	mt76x02_phy_set_bw(dev, chandef->width, ch_group_index);
 	mt76x02_phy_set_band(dev, chandef->chan->band,
 			     ch_group_index & 1);
@@ -698,7 +707,6 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	mt76x0_phy_set_band(dev, chandef->chan->band);
 	mt76x0_phy_set_chan_rf_params(dev, channel, rf_bw_band);
-	mt76x0_read_rx_gain(dev);
 
 	/* set Japan Tx filter at channel 14 */
 	val = mt76_rr(dev, MT_BBP(CORE, 1));
@@ -708,17 +716,17 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 		val &= ~0x20;
 	mt76_wr(dev, MT_BBP(CORE, 1), val);
 
+	mt76x0_read_rx_gain(dev);
 	mt76x0_phy_set_chan_bbp_params(dev, rf_bw_band);
 
-	/* Vendor driver don't do it */
-	/* mt76x0_phy_set_tx_power(dev, channel, rf_bw_band); */
-
 	if (mt76_is_usb(dev)) {
 		mt76x0_vco_cal(dev, channel);
 		if (scan)
 			mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1,
 					      false);
 	} else {
+		/* enable vco */
+		rf_set(dev, MT_RF(0, 4), BIT(7));
 		mt76x0_phy_calibrate(dev, false);
 	}
 
-- 
2.17.2

