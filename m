Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E90C004D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B65F2172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 06:40:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B65F2172C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbeI1NCm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 09:02:42 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39252 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbeI1NCm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 09:02:42 -0400
Received: by mail-wm1-f68.google.com with SMTP id q8-v6so992271wmq.4
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 23:40:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HB1OoSZlkw0rh4TD3tTpYJC1r4uovVON5wUZjwGUgg0=;
        b=Ucqa18UBYWJkJMuLUHI7FARqhBH9QpP9vJMj12+UbTAq/nUCWC1OZtmAsQPsPI4vj/
         JDlXs+sM4Dlhg9X7c6KrnQh19bWk32m+PskxHrteyJm88o2ey32u+6s4qj3IYYdzMuMJ
         Mi2nRRC5SFqcvsiBrcuy4tKPAWl5WeEj4XjpHoK2MNHrajaohu4vWi39NkYCp9E6CLqh
         mnBzwRp1k/5I+W96fnKnziymxnz1eXDLkSZBTcKonz/33/ZFQV/VQa9GNvyY7x5WIw8T
         fvrHFBgQU0cuwBvaWgMyfVlWgAT8adHIjmxpz3JKfk/xn1zEKmAwWW7q2AfFDMZdIzrt
         4Jiw==
X-Gm-Message-State: ABuFfoiHcE8dELekY04tsLlNAd7VKnSVLBItAITSXtrmdgfC7OH6ld8G
        wohBkeH52d4MCBCizsTqvXyQhQ==
X-Google-Smtp-Source: ACcGV620it9X2aTM1CBOrJp07FWXYqGkmcLm1V9qGZLqfht4KsB7lrbtwBcYAiY6Cvot5i1wIo2atA==
X-Received: by 2002:a1c:3795:: with SMTP id e143-v6mr673574wma.9.1538116828509;
        Thu, 27 Sep 2018 23:40:28 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id y4-v6sm5605105wrd.25.2018.09.27.23.40.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 23:40:27 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 01/24] mt76x0: use mt76_poll in mt76x0_set_wlan_state
Date:   Fri, 28 Sep 2018 08:39:54 +0200
Message-Id: <20180928064017.26870-2-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.19.0

