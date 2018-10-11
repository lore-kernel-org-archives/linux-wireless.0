Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C08C46464
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4D4C2085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4D4C2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbeJKQSw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:52 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41915 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbeJKQSv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id x12-v6so8699380wru.8
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9088u/jGIS6A7miZmt1wFY22zB47wMtCMBFuElZaetY=;
        b=PdZarXIpRpOLCBJdlyAc4jAo0tjokFYPZZhaueP5nlbBiYuQK78OdJkpncD+Mp5CTD
         DQpqG8VcBvrBRcH/+q+kK9Ct21jKf7cGSN4px3/v3vwnVHhHe4+g1/POiahT8/ZeR449
         VsaXqo54apv7WozP5tp35/aPh7EmQg61rlWfP+RJFBj41+I5ryHLfMYk80CJakDnerSF
         xVoe2zZ8WANAvWvBKc01RqalC+XVqbXjMenAol740/50Cig4ilXS9Z6imyl9SZ0QS+xf
         dcGzZXWTP7GImlTiiOhFv6b1RbLZXgoDQEQrIs7XtuNfObCP0bVj5lOKUIO+sdvmjq3z
         4vNw==
X-Gm-Message-State: ABuFfogXQrNLKDCHjL0A8Ptw6C+Ik72bzmqgv7D2TXJqgFrvXEROAt0d
        sJB5Basnr3j/6lQ55Q96gLOt+NrXXzY=
X-Google-Smtp-Source: ACcGV62DAuj6PCTX+GMmVhOIiJNImbJ/4f2GR/tQQ/yX30NnT3mwj4X07p04adwfMLijCN7nJFfRdw==
X-Received: by 2002:adf:e18e:: with SMTP id k14-v6mr733910wri.36.1539247951141;
        Thu, 11 Oct 2018 01:52:31 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:30 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 09/12] mt76: move mt76x02_phy_adjust_vga_gain in mt76/mt76x02_phy.c
Date:   Thu, 11 Oct 2018 10:52:06 +0200
Message-Id: <9cf9211a960b640ceb0508b138ea918b3f89eceb.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_phy_adjust_vga_gain routine in mt76x02-lib module
in order to be reused by mt76x0 driver for vga calibration

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_phy.c  | 21 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  |  1 +
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   | 22 ++-----------------
 3 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
index b0c78ab97ad7..97310da37d77 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.c
@@ -223,3 +223,24 @@ void mt76x02_phy_set_band(struct mt76x02_dev *dev, int band,
 		       primary_upper);
 }
 EXPORT_SYMBOL_GPL(mt76x02_phy_set_band);
+
+bool mt76x02_phy_adjust_vga_gain(struct mt76x02_dev *dev)
+{
+	u8 limit = dev->cal.low_gain > 0 ? 16 : 4;
+	bool ret = false;
+	u32 false_cca;
+
+	false_cca = FIELD_GET(MT_RX_STAT_1_CCA_ERRORS, mt76_rr(dev, MT_RX_STAT_1));
+	dev->cal.false_cca = false_cca;
+	if (false_cca > 800 && dev->cal.agc_gain_adjust < limit) {
+		dev->cal.agc_gain_adjust += 2;
+		ret = true;
+	} else if ((false_cca < 10 && dev->cal.agc_gain_adjust > 0) ||
+		   (dev->cal.agc_gain_adjust >= limit && false_cca < 500)) {
+		dev->cal.agc_gain_adjust -= 2;
+		ret = true;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mt76x02_phy_adjust_vga_gain);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index 3a5ba5d209ba..8e3a0f93ca80 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -55,5 +55,6 @@ int mt76x02_phy_get_min_avg_rssi(struct mt76x02_dev *dev);
 void mt76x02_phy_set_bw(struct mt76x02_dev *dev, int width, u8 ctrl);
 void mt76x02_phy_set_band(struct mt76x02_dev *dev, int band,
 			  bool primary_upper);
+bool mt76x02_phy_adjust_vga_gain(struct mt76x02_dev *dev);
 
 #endif /* __MT76x02_PHY_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 86b87d896b46..818d2f3e8ac9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -156,25 +156,6 @@ mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
 		mt76x2_dfs_adjust_agc(dev);
 }
 
-static void
-mt76x2_phy_adjust_vga_gain(struct mt76x02_dev *dev)
-{
-	u32 false_cca;
-	u8 limit = dev->cal.low_gain > 0 ? 16 : 4;
-
-	false_cca = FIELD_GET(MT_RX_STAT_1_CCA_ERRORS, mt76_rr(dev, MT_RX_STAT_1));
-	dev->cal.false_cca = false_cca;
-	if (false_cca > 800 && dev->cal.agc_gain_adjust < limit)
-		dev->cal.agc_gain_adjust += 2;
-	else if ((false_cca < 10 && dev->cal.agc_gain_adjust > 0) ||
-		 (dev->cal.agc_gain_adjust >= limit && false_cca < 500))
-		dev->cal.agc_gain_adjust -= 2;
-	else
-		return;
-
-	mt76x2_phy_set_gain_val(dev);
-}
-
 static void
 mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 {
@@ -193,7 +174,8 @@ mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 	dev->cal.low_gain = low_gain;
 
 	if (!gain_change) {
-		mt76x2_phy_adjust_vga_gain(dev);
+		if (mt76x02_phy_adjust_vga_gain(dev))
+			mt76x2_phy_set_gain_val(dev);
 		return;
 	}
 
-- 
2.17.2

