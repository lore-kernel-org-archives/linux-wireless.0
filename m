Return-Path: <SRS0=gO0h=QY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54815C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 21:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2323E217F5
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Feb 2019 21:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EJ9/DT3D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbfBQV0M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 17 Feb 2019 16:26:12 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41486 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfBQV0L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 17 Feb 2019 16:26:11 -0500
Received: by mail-qt1-f193.google.com with SMTP id v10so17170842qtp.8;
        Sun, 17 Feb 2019 13:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kDNQwzUrWUBbefyEc2Id23W24JWPHbwanzy1PDDivVI=;
        b=EJ9/DT3D+oY3dsx6Gbla5n/8EjWPIa2JfIDSrz1NotPmeWovkgK1KIsT63Kms6kGr/
         XNPG5K1f0MyAku1beLTNnAmkxcUkFafl39tnYk/VoLZ08/o0VJKPPYVS9NUFOXPkOD1P
         X3BwCduvrQefreXqdMoOq+FFw0TOVSheo8ccMs01bdohgZhf34VjWb2HVQqPbMrZiznq
         V+kxOeGWq1rCtqapH1u/8mK6roPFxinlbmtlsBt9u0Bb9qpx7xtP3H+Q9VZttjW7vftF
         GdxOVz2qtpXQKD3i40c9hVArskwXptV8BMSy/PKooJYguqN0oxOhtPbJoT+I93KRhRNf
         UpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kDNQwzUrWUBbefyEc2Id23W24JWPHbwanzy1PDDivVI=;
        b=RA+gJ2ATBTW8vDddDns6RbrPXQqi45ZV722IVFyA4O2RNIKcmRNsZ5MDtlXz/MlKGT
         JBLBiyt7ZMxT3a6Hy9gKDLmThHOQcviWwg8LeBoJj+7DdJ3irTo2KuHRZh/G8P+jxvxl
         8n3hvHcRQonbVLNMEOmqBb0GhmpTbk7i4Eo9Brim6sW+CcRGkJUXBWWe66BzCZR74Uux
         PIOBg58/WsptgOk4jg2vzwVJ4dZjed+chFAbNceaxq1WltNJlY5ZvmcWuMayH/4VV92i
         AMkv2s6e+r3EKQ39v6Rc5UiwFcyIKFu4mTgCoNp75QA2ZA2+f1doV9wBt3GFEzVJmoaZ
         YASA==
X-Gm-Message-State: AHQUAuaR8o5qgrzwoEbAYSYKLc/QPjIEHqsqaLVZNLi275/X8E5Vyva5
        8B0qBWTSynnXzyNDjPSWxVUsQ5bdmPcK
X-Google-Smtp-Source: AHgI3IYisINQJ1uef4yQQKykIc2WqcS+kk3XkhXnsYRpyWeqjaiZ8ZqXvjXMTmfmvxkzdlvZDabsJQ==
X-Received: by 2002:a0c:eaca:: with SMTP id y10mr14894486qvp.176.1550438769961;
        Sun, 17 Feb 2019 13:26:09 -0800 (PST)
Received: from localhost.localdomain (modemcable148.230-83-70.mc.videotron.ca. [70.83.230.148])
        by smtp.gmail.com with ESMTPSA id a6sm5156150qkk.5.2019.02.17.13.26.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Feb 2019 13:26:09 -0800 (PST)
From:   Keyur Patel <iamkeyur96@gmail.com>
X-Google-Original-From: Keyur Patel
Cc:     iamkeyur96@gmail.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] orinoco : Replace function name in string with __func__
Date:   Sun, 17 Feb 2019 11:25:45 -0500
Message-Id: <20190217162548.18257-1-iamkeyur96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Keyur Patel <iamkeyur96@gmail.com>

Replace hard coded function name with __func__, to
improve robustness and to conform to the Linux kernel coding
style. Issue found using checkpatch.

Signed-off-by: Keyur Patel <iamkeyur96@gmail.com>
---
 drivers/net/wireless/intersil/orinoco/mic.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/mic.c b/drivers/net/wireless/intersil/orinoco/mic.c
index 709d9ab3e7bc..67b0c05afbdb 100644
--- a/drivers/net/wireless/intersil/orinoco/mic.c
+++ b/drivers/net/wireless/intersil/orinoco/mic.c
@@ -18,16 +18,16 @@ int orinoco_mic_init(struct orinoco_private *priv)
 {
 	priv->tx_tfm_mic = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->tx_tfm_mic)) {
-		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
-		       "crypto API michael_mic\n");
+		printk(KERN_DEBUG "%s: could not allocate "
+		       "crypto API michael_mic\n", __func__);
 		priv->tx_tfm_mic = NULL;
 		return -ENOMEM;
 	}
 
 	priv->rx_tfm_mic = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->rx_tfm_mic)) {
-		printk(KERN_DEBUG "orinoco_mic_init: could not allocate "
-		       "crypto API michael_mic\n");
+		printk(KERN_DEBUG "%s: could not allocate "
+		       "crypto API michael_mic\n", __func__);
 		priv->rx_tfm_mic = NULL;
 		return -ENOMEM;
 	}
@@ -52,7 +52,7 @@ int orinoco_mic(struct crypto_shash *tfm_michael, u8 *key,
 	int err;
 
 	if (tfm_michael == NULL) {
-		printk(KERN_WARNING "orinoco_mic: tfm_michael == NULL\n");
+		printk(KERN_WARNING "%s: tfm_michael == NULL\n", __func__);
 		return -1;
 	}
 
-- 
2.20.1

