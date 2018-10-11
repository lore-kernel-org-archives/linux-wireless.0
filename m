Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7E4C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C4D02085B
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 08:52:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C4D02085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbeJKQSv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 12:18:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55139 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbeJKQSu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 12:18:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id r63-v6so8134887wma.4
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2018 01:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qR+uKpaaCgGMjthr8Yfn4/BLbCmOB28YTW/lMus9v4M=;
        b=Dpb0mWLuVwX3bB20fwe7O1xXc4w3B6CDWaC90wKXWRIRrLipoX/o7MkVm4CKFMEAGr
         FXRn78MMc1nILc56+QjmFeWzPBe1RcBoOTuUNnAUmgOQhDipqkU8xoo6vtkBbGsUO+Tq
         IA9QvJqLi3UHX/IlZurE8rdwTkWlQMzgjxhA0LH3y5Ae11XW86Fc1Im8V09A4wSQiguS
         hXItbJSmsBJ6HhZzuSGIG2ZOkig5s6+3T4WNEyPE8a8gEbHFyJ9LQh0cur4b9DRGosOi
         rkVrjAuXU5lpOt+yZ1aT6dlOn96mSf/j80LQO5MUwJVhA4XhSTcpkhxGhkx1FFGhgx7+
         2Djg==
X-Gm-Message-State: ABuFfogHU1+hYp0nR006AIpkcTU4Mw0dKhOp3wn3cIOrOQw2Wupgm+zr
        RC3bg6hM0lFdzRHSZSnQvtGHnw==
X-Google-Smtp-Source: ACcGV62A8QRtvUkCGstixgaYJwKzC9Zc/dy7rKK9ABL14h9ppLwwjkHQpdgvZXE+egy/sdhngyLHvw==
X-Received: by 2002:a1c:d712:: with SMTP id o18-v6mr917416wmg.54.1539247950095;
        Thu, 11 Oct 2018 01:52:30 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id v184-v6sm950839wme.3.2018.10.11.01.52.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Oct 2018 01:52:29 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 08/12] mt76: move rssi_gain_thresh routines in mt76x02-lib module
Date:   Thu, 11 Oct 2018 10:52:05 +0200
Message-Id: <2f17bb0361a2759ede6d383e8d8f9250720242b3.1539247493.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
References: <cover.1539247493.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x2_get_rssi_gain_thresh and mt76x2_get_low_rssi_gain_thresh
routines in mt76x02-lib module in order to be reused by mt76x0 driver
for dynamic vga calibration

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x02_phy.h  | 26 ++++++++++++++++
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   | 30 ++-----------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
index 1a20c1852dbf..3a5ba5d209ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_phy.h
@@ -19,6 +19,32 @@
 
 #include "mt76x02_regs.h"
 
+static inline int
+mt76x02_get_rssi_gain_thresh(struct mt76x02_dev *dev)
+{
+	switch (dev->mt76.chandef.width) {
+	case NL80211_CHAN_WIDTH_80:
+		return -62;
+	case NL80211_CHAN_WIDTH_40:
+		return -65;
+	default:
+		return -68;
+	}
+}
+
+static inline int
+mt76x02_get_low_rssi_gain_thresh(struct mt76x02_dev *dev)
+{
+	switch (dev->mt76.chandef.width) {
+	case NL80211_CHAN_WIDTH_80:
+		return -76;
+	case NL80211_CHAN_WIDTH_40:
+		return -79;
+	default:
+		return -82;
+	}
+}
+
 void mt76x02_add_rate_power_offset(struct mt76_rate_power *r, int offset);
 void mt76x02_phy_set_txpower(struct mt76x02_dev *dev, int txp_0, int txp_2);
 void mt76x02_limit_rate_power(struct mt76_rate_power *r, int limit);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 55708b8e6e10..86b87d896b46 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -131,32 +131,6 @@ mt76x2_get_agc_gain(struct mt76x02_dev *dev, u8 *dest)
 	dest[1] = mt76_get_field(dev, MT_BBP(AGC, 9), MT_BBP_AGC_GAIN);
 }
 
-static int
-mt76x2_get_rssi_gain_thresh(struct mt76x02_dev *dev)
-{
-	switch (dev->mt76.chandef.width) {
-	case NL80211_CHAN_WIDTH_80:
-		return -62;
-	case NL80211_CHAN_WIDTH_40:
-		return -65;
-	default:
-		return -68;
-	}
-}
-
-static int
-mt76x2_get_low_rssi_gain_thresh(struct mt76x02_dev *dev)
-{
-	switch (dev->mt76.chandef.width) {
-	case NL80211_CHAN_WIDTH_80:
-		return -76;
-	case NL80211_CHAN_WIDTH_40:
-		return -79;
-	default:
-		return -82;
-	}
-}
-
 static void
 mt76x2_phy_set_gain_val(struct mt76x02_dev *dev)
 {
@@ -212,8 +186,8 @@ mt76x2_phy_update_channel_gain(struct mt76x02_dev *dev)
 
 	dev->cal.avg_rssi_all = mt76x02_phy_get_min_avg_rssi(dev);
 
-	low_gain = (dev->cal.avg_rssi_all > mt76x2_get_rssi_gain_thresh(dev)) +
-		   (dev->cal.avg_rssi_all > mt76x2_get_low_rssi_gain_thresh(dev));
+	low_gain = (dev->cal.avg_rssi_all > mt76x02_get_rssi_gain_thresh(dev)) +
+		   (dev->cal.avg_rssi_all > mt76x02_get_low_rssi_gain_thresh(dev));
 
 	gain_change = (dev->cal.low_gain & 2) ^ (low_gain & 2);
 	dev->cal.low_gain = low_gain;
-- 
2.17.2

