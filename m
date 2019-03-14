Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A7DC10F06
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B2A62070D
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:08:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I5g+yOIn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbfCNOIF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:08:05 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50780 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbfCNOIF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 10:08:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id x7so3163600wmj.0
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2019 07:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jsUyLRLziJ6dyhty5uCMt9SOzOgYYNIhxD1vrGAqY6E=;
        b=I5g+yOIn943XA048LSccpSxvxJyE/8Ke5HOfHPRUQGKR99OsCxMwxZryHs9LsB+NAN
         mSJ/6F7/RvoynK3ZKlPW1lH5eF9LG24pWTB8oPUElVnvc2jd0ZcVsH0RGqnC50pHz9gZ
         f1gQP1E3XgQgzBsFK6CJarGsfSSfceHX6zaaOulKe05NwsVGv7NDtFGW27YCfJE1dBuV
         iHVK9JPu0IRVkMnRZtdDQS56A3JaZ1yeKm8L019BnCRHpH7LoAL0W451ORCK1ildKQJa
         tLfggsmZEfHbok2/XpYnx2FXFhxYn76yN847/e6CxIXa7tBYuZBloTkZ08WmegYXl/CZ
         LriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jsUyLRLziJ6dyhty5uCMt9SOzOgYYNIhxD1vrGAqY6E=;
        b=p38S6waFeKgIDvm7aUfbEgQHkUWRbepyUCN5gZ36xYaHfczx1CEy45ebPCYUYrRZuP
         hWvHfza/5k1BIiqkYFbgqutth5zi0pBSBRxl2mvZcI7VB0BdMJomZ7qflicTaGHzXZtq
         QsKnLHK2apQ2mB6UtGrI0OZjo2EgvyoM0Lzeia+r31XdA3Oid2fJnyaEv4sO8/HPkFee
         XZc7PQXWIUEMxNZhea2xG5K/ailsDnQ+brO1Gt+8LzpWzkc7spxavQPIknsvtSq8VE/h
         q5K5pfvH/vbyRLLhE4NIuyjdTxzygylrQNQgihZ1tS5gvIGUJXBbQbzhmPb5ElCNyg08
         J41Q==
X-Gm-Message-State: APjAAAVxz4hM104eWufidNE6/OjiJqMscVEHi4iLkJQg4cJRmGDd4r83
        AbhWW0yzUEsjcF9mrtCyZkZv2aY3
X-Google-Smtp-Source: APXvYqxIy/Df/PnQeqRLrrQBmfdkMI1EWgMeFen3mShflQPQh+hLDxWPSbkvxgXpmKMrr2Hf5AjrDQ==
X-Received: by 2002:a7b:c1cf:: with SMTP id a15mr2723982wmj.60.1552572483451;
        Thu, 14 Mar 2019 07:08:03 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id i12sm23127722wrq.21.2019.03.14.07.08.02
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 14 Mar 2019 07:08:02 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org
Subject: [PATCH v2 2/2] ath9k: drop redundant code in ar9003_hw_set_channel
Date:   Thu, 14 Mar 2019 15:07:50 +0100
Message-Id: <1552572470-2656-2-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1552572470-2656-1-git-send-email-pozega.tomislav@gmail.com>
References: <1552572470-2656-1-git-send-email-pozega.tomislav@gmail.com>
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

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
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

