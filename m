Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93FFAC4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 619062087C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:10:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QwEZv+Wp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfCLTKv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:10:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34121 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfCLTKv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 15:10:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id o10so2827763wmc.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 12:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H0tAd2LI+YPMBO2eWV2mFbo6wqrST4ZGXxxjWgdDWOY=;
        b=QwEZv+WpKyHxyVO9JdkNfTBm/K0UzwXKcUazBCIm/v1pDYQ73lLzU9t1rJVOtRRiOb
         HK90mi/syhaAOMUFWi10BV2TvNGC063vJUHVcK7Ed6kwMUdoxNhjMNzdeRUSJQiUj6Xd
         K/IzPQ89tvzpmFIOiyhI/qP6eQ5/nezAdIkqFTBgi2ItDADaHifFTKjvtVL09bxAdLIU
         pJXRDiG7JRHtXhOFQfb480lv81fxY+aI30TA8a6LwYyuK3FTmV5O6jdjcpXot+py0OkS
         w4tO4rY1uIUj0r6l/zaClzSan0q6BPBbF3QX28NR5kVSR3GjxIN2qosLN2YCcqObe/7y
         8PRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H0tAd2LI+YPMBO2eWV2mFbo6wqrST4ZGXxxjWgdDWOY=;
        b=WVTKgw21wfsSWMIG/D5CZjklQFyo5lF5y5fITUZbwtXhmX+ZhnWIdKzOAiIpq0CvtE
         H4comR/csfbH8v8evETCNLVJVUcjMW2ekD86M0ePNuInRX9vIv8zNXs/AjVyRuJmRRGN
         wMlsd5XxWGHKOsc4g7MyitcGzbQ3r6lOL8jQqo13Le+gndm7B1VYm2+ZOPjQ/8a/UA2w
         CfPO3ov0seMuOeMod1k+HYxBJYZJp37jrUKeIWwK/N6V94YJ2wr1Ac+PWvwUJnRCbFQO
         V4NmcwAPlywaGkiqlYGV6HRA3gZIak2SrRyohpio7U9A5wNefpOXdxPna0qYDEIntM9L
         mFUQ==
X-Gm-Message-State: APjAAAXCOJfBkqPebL1aH61b2z/VYIh6Q+BIU+/uNVIzthFChpAVCsj8
        4UiUObsggF4UZlxT0f9d4QQxXVAX
X-Google-Smtp-Source: APXvYqx23Cj20NfMSEqK33ZE3D1sjiQi+HgOhPW26yNWLywNIOGTGeOoHi3N/DkE/NC/jjtch5dE0w==
X-Received: by 2002:a7b:cb54:: with SMTP id v20mr3668104wmj.0.1552417849022;
        Tue, 12 Mar 2019 12:10:49 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id o8sm4918493wma.1.2019.03.12.12.10.48
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 12 Mar 2019 12:10:48 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org,
        =?UTF-8?q?Tomislav=20Po=B8ega?= <pozega.tomislav@gmail.com>
Subject: [PATCH 2/2] ath9k: drop redundant code in ar9003_hw_set_channel
Date:   Tue, 12 Mar 2019 20:10:43 +0100
Message-Id: <1552417843-10935-2-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
References: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

AR9330, AR9485, AR9531, AR9550, AR9561 and AR9565 all use same
channel set register configuration which allows for small code
size reduction.

Signed-off-by: Tomislav Po¸ega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |   24 +++---------------------
 1 files changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 98c5f52..daf30f9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -157,7 +157,9 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 	freq = centers.synth_center;
 
 	if (freq < 4800) {     /* 2 GHz, fractional mode */
-		if (AR_SREV_9330(ah)) {
+		if (AR_SREV_9330(ah) || AR_SREV_9485(ah) ||
+		    AR_SREV_9531(ah) || AR_SREV_9550(ah) ||
+		    AR_SREV_9561(ah) || AR_SREV_9565(ah)) {
 			if (ah->is_clk_25mhz)
 				div = 75;
 			else
@@ -166,16 +168,6 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			channelSel = (freq * 4) / div;
 			chan_frac = (((freq * 4) % div) * 0x20000) / div;
 			channelSel = (channelSel << 17) | chan_frac;
-		} else if (AR_SREV_9485(ah) || AR_SREV_9565(ah)) {
-			/*
-			 * freq_ref = 40 / (refdiva >> amoderefsel);
-			 * where refdiva=1 and amoderefsel=0
-			 * ndiv = ((chan_mhz * 4) / 3) / freq_ref;
-			 * chansel = int(ndiv), chanfrac = (ndiv - chansel) * 0x20000
-			 */
-			channelSel = (freq * 4) / 120;
-			chan_frac = (((freq * 4) % 120) * 0x20000) / 120;
-			channelSel = (channelSel << 17) | chan_frac;
 		} else if (AR_SREV_9340(ah)) {
 			if (ah->is_clk_25mhz) {
 				channelSel = (freq * 2) / 75;
@@ -184,16 +176,6 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			} else {
 				channelSel = CHANSEL_2G(freq) >> 1;
 			}
-		} else if (AR_SREV_9550(ah) || AR_SREV_9531(ah) ||
-			   AR_SREV_9561(ah)) {
-			if (ah->is_clk_25mhz)
-				div = 75;
-			else
-				div = 120;
-
-			channelSel = (freq * 4) / div;
-			chan_frac = (((freq * 4) % div) * 0x20000) / div;
-			channelSel = (channelSel << 17) | chan_frac;
 		} else {
 			channelSel = CHANSEL_2G(freq);
 		}
-- 
1.7.0.4

