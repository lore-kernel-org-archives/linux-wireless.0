Return-Path: <SRS0=9ImR=NH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C0AECDE44
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Oct 2018 19:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A5232085B
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Oct 2018 19:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A5232085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbeJ1Dsi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Oct 2018 23:48:38 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38707 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728472AbeJ1Dsi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Oct 2018 23:48:38 -0400
Received: by mail-wr1-f66.google.com with SMTP id d10-v6so4489008wrs.5
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2018 12:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=muqHFFsStRQkuS0kxwGr5kmHZIQ0sCqNlE9WKxjsFVY=;
        b=nE1JpHXoG7WL9OkbTqu9tTcPfdkJXRGfA9U/ICOh3oVuMLA2f+3IaGpehyQIqTtnnu
         dxg+/ugv5moRX8A5htld/q5OyKEvtBsV5xVWrSYn2JqklKGA8gcIFX/HlVYpY7Ww0rhA
         24q1Kp4senbXv9r79hNP19nOD17jXAhOWg78NMkovHzlO82hT3bEL5iKFEeVGSh5rSjz
         W2sf4lTWfmwcXE2/Zwklwgx6QA4wnspJ87EbjMQJ9GLWmjAi2eTJfMovXQ6l/tn0Uo4m
         lHb+3csqby5Sji2Ov63ih8XRj2ec2B7EZXzJbnCLKoq8XN5eEgMIf8i6GWofOeizK1rM
         BIKw==
X-Gm-Message-State: AGRZ1gKnsgEA2mqIOLRdYLnwbqfTvNIwjUrxsQbsMKVefqWUGci7vKUb
        al+aPdQN/vWuAToebZsMfQfedA0Qof0=
X-Google-Smtp-Source: AJdET5fKj0Tue9yD5z/PNXht6oDQN0o7ph0NIACUmwa+10pRxbhzxdPAYb4TJtNI76ZaNgpNk4bxLw==
X-Received: by 2002:adf:e651:: with SMTP id b17-v6mr9508366wrn.254.1540667200697;
        Sat, 27 Oct 2018 12:06:40 -0700 (PDT)
Received: from localhost.localdomain ([151.66.52.234])
        by smtp.gmail.com with ESMTPSA id 125-v6sm10642175wmm.25.2018.10.27.12.06.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Oct 2018 12:06:40 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x0: phy: use mt76_poll_msec in mt76x0_phy_temp_sensor
Date:   Sat, 27 Oct 2018 21:06:25 +0200
Message-Id: <9156c75f22776e304b562654fff027f8c91e0943.1540666225.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540666225.git.lorenzo.bianconi@redhat.com>
References: <cover.1540666225.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76_poll_msec utility routine for CORE_R34 register polling
instead of mt76_poll in order to allow the hw to complete requested
calibration since on slow devices (e.g. mt7620 based boards) calibration
takes longer than 2ms

Fixes: 66a34c66e0cb ("mt76x0: phy: add phy/vco temperature compensation")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index c734987a344c..830ea6047f10 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -686,8 +686,7 @@ static void mt76x0_phy_temp_sensor(struct mt76x02_dev *dev)
 	mt76x0_rf_wr(dev, MT_RF(0, 67), 0x01);
 
 	mt76_wr(dev, MT_BBP(CORE, 34), 0x00080055);
-
-	if (!mt76_poll(dev, MT_BBP(CORE, 34), BIT(4), 0, 2000)) {
+	if (!mt76_poll_msec(dev, MT_BBP(CORE, 34), BIT(4), 0, 200)) {
 		mt76_clear(dev, MT_BBP(CORE, 34), BIT(4));
 		goto done;
 	}
-- 
2.19.1

