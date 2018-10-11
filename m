Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 781EEC32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4294D2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4294D2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbeJKQSs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:48 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52386 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbeJKQSr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id 189-v6so8132144wmw.2
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i8XCdI2miXIuRdILZIQ9sM8gG8WfnSojPJ0lQ/HOOBo=;
        b=T68+eBOgue2V+CmiFD5IGDFmRRzahYadMVwCEC4W4n7+IsM3di313nUoFJIUbnGkAF
         E+JN+FbLCx+COIVCFV3Mij/UutZ8JGPxZmC5z9c9TDq6p5RPRxqW1t43ggq9549HLFOv
         eT1trUhg9h6OcliaVaYp1QL5rtlzn1R4I2scZCjv0BCa18bSZ1oGdJ/lPNvHsjIpd4xN
         5icB62znuVHDkqNYocsz20j9xmD5w7P1ZvG6dFTuT1B+R2e8roM8vBHW6IP620FpPX8c
         H9sqhHhMtc+sdvzcupxku0V9n/NXVVrwflflJM1JmxvxHXdl+/8CxJ+h7sbqa2/iCv1M
         gPvw==
X-Gm-Message-State: ABuFfoi9Q/8K0dENbtVADJVUFIexRi3nVtLn4cW4207dz2YCUMwXyg7A
        9hc+aTjb5pfa8BvMFTr0pS7WDuNISb0=
X-Google-Smtp-Source: ACcGV62vRAJlnNMyLsubbPeF8nyj9HgscpBgLTtIXYUIhBZPaYhY/HFT/q1yY/VmTnoycNuRrOOqzg==
X-Received: by 2002:a1c:7dce:: with SMTP id y197-v6mr915086wmc.78.1539247947365;
        Thu, 11 Oct 2018 01:52:27 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:26 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 05/12] mt76x0: phy: update set_channel for mt76x0e devices
Date:   Thu, 11 Oct 2018 10:52:02 +0200
Message-Id: <be7ad20f046edd95602b13952def636e80af83a1.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
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
index 96be496e5ee3..049e750457e6 100644
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

