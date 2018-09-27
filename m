Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADEEC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35DB2156B
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B35DB2156B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbeI0PTQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36003 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbeI0PTQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id l10-v6so1713288wrp.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UPi+Ozi5hq3DT/rpyIQpoXgcGDcvVQraZYfmRsgnS7Q=;
        b=goDD4MKBcMqWLz6XLhzZKfA51z4Xj6s9xYJWJauIcq6/bYoOJLoX0bYI3a5bnwDjEG
         Eb6o8RQZzYmC5G3Bp33ldSNd9NEd5bXybpTFJcw4kn8pJBSBnfu1Ex98vvOcNslPVQ1P
         8n5Tsdco72ObpO3zRCUugQ8xniPLYgdvVg514lVGjoKsZ9wPdhWuCpPgcxdHJsxGNGOY
         0gZvkwS3g65u+91RuioC53akJIiLoXNFjv5UD23SIFg3gp+H7HCGvHfI0urCCk5jZoQP
         w3hzJ87AVaeJPNFD/LuxfuQjTvB5r0IGblZeYkqyW/g1nV/3eP7JFjY7nwiNNIOhT2Rj
         BdFA==
X-Gm-Message-State: ABuFfoiFvvs9GTmwQ17WAhSOYFxw4TvNp8PINgcs2QMCYQeXEnM3cKiS
        PrrHxE6xm8Nhhs/52/i5+ln5dEQ++fE=
X-Google-Smtp-Source: ACcGV60zK/7QVBr8ltw8RnNB4dxqV4TMC9zIVms5myp4fR2gnq8ymKT33WeM/IOvQWF3S8tZJM8J7g==
X-Received: by 2002:adf:afdd:: with SMTP id y29-v6mr4111263wrd.176.1538038922639;
        Thu, 27 Sep 2018 02:02:02 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:01 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 01/26] mt76x0: use mt76_poll in mt76x0_set_wlan_state
Date:   Thu, 27 Sep 2018 11:01:30 +0200
Message-Id: <995c4f1662edc0fe8f3fc1ed7901de3d59916a05.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76_poll utility routine in mt76x0_set_wlan_state to check
if the PLL/XTAL is ready

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c   | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 3a88be267daf..5e3ec1bef144 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -43,7 +43,7 @@ static void mt76x0_vht_cap_mask(struct ieee80211_supported_band *sband)
 static void
 mt76x0_set_wlan_state(struct mt76x0_dev *dev, u32 val, bool enable)
 {
-	int i;
+	u32 mask = MT_CMB_CTRL_XTAL_RDY | MT_CMB_CTRL_PLL_LD;
 
 	/* Note: we don't turn off WLAN_CLK because that makes the device
 	 *	 not respond properly on the probe path.
@@ -60,24 +60,12 @@ mt76x0_set_wlan_state(struct mt76x0_dev *dev, u32 val, bool enable)
 	mt76_wr(dev, MT_WLAN_FUN_CTRL, val);
 	udelay(20);
 
-	if (!enable)
-		return;
-
-	for (i = 200; i; i--) {
-		val = mt76_rr(dev, MT_CMB_CTRL);
-
-		if (val & MT_CMB_CTRL_XTAL_RDY && val & MT_CMB_CTRL_PLL_LD)
-			break;
-
-		udelay(20);
-	}
-
 	/* Note: vendor driver tries to disable/enable wlan here and retry
 	 *       but the code which does it is so buggy it must have never
 	 *       triggered, so don't bother.
 	 */
-	if (!i)
-		dev_err(dev->mt76.dev, "Error: PLL and XTAL check failed!\n");
+	if (enable && !mt76_poll(dev, MT_CMB_CTRL, mask, mask, 2000))
+		dev_err(dev->mt76.dev, "PLL and XTAL check failed\n");
 }
 
 void mt76x0_chip_onoff(struct mt76x0_dev *dev, bool enable, bool reset)
-- 
2.17.1

