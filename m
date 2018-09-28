Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45620C04E87
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 088EE21547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 088EE21547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbeI1SCl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:41 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40817 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729479AbeI1SCk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id o2-v6so1849317wmh.5
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UPi+Ozi5hq3DT/rpyIQpoXgcGDcvVQraZYfmRsgnS7Q=;
        b=mWuehR5RgX2jhKYA4n21MH/bfDE1pqkyUUxIKyWSYCFpQmhDrOW569qwKl5QvfsJYe
         E4O9iPhCBxp/gfQUky8VqGUSM6nP8tONNJmCstbyNf1jCf0F7weLXxntzPKDspxMOHaZ
         kLcxwm8IWSXkZ+06nEZNcJ5NTvchW52dAAtFmGwbC88gSB8dVYAnzU9B8zoTCHoXpOnc
         +NtrzWVGx0r8AmNECs8m4lkKafPIpp5VhBSOLfDee0xshMmqO5hLs2L/LbbjuKS+VFBy
         EaNQv8AlwMePeW7MNm7gpilUb7urnv8ytC2UKMnX8HxibxrpSCYQV6VAJ0QIxYwXCcf5
         fclA==
X-Gm-Message-State: ABuFfojUR+ZnI3j8esDBXa5C9HvX6q79AgVzNjMGtkyaoid72eqAKZO7
        ApNnYZxTLMpY+A2OrsY4XxkjeA==
X-Google-Smtp-Source: ACcGV62D0fOgtlTcRp84XFzBqkcbVN5um1gQDsJ/Mes1A/0Kl/2VWDgOFu6KYBJvv2eYHPb3FLqoDQ==
X-Received: by 2002:a1c:9141:: with SMTP id t62-v6mr1403473wmd.69.1538134757319;
        Fri, 28 Sep 2018 04:39:17 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:16 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 01/24] mt76x0: use mt76_poll in mt76x0_set_wlan_state
Date:   Fri, 28 Sep 2018 13:38:44 +0200
Message-Id: <995c4f1662edc0fe8f3fc1ed7901de3d59916a05.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
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

