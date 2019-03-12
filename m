Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3811C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 11:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C8C0206DF
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 11:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfCLLGH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:06:07 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:46142 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726008AbfCLLGG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 07:06:06 -0400
Received: from mr3.cc.vt.edu (mr3.cc.vt.edu [IPv6:2607:b400:92:8500:0:7f:b804:6b0a])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x2CB65xk009366
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 07:06:05 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        by mr3.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x2CB60TM008916
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 07:06:05 -0400
Received: by mail-qt1-f199.google.com with SMTP id x12so1896364qtk.2
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 04:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=fHbH8xXrsdcVp7DgI6FhDseV5/05/lU0RAksNhHFrTE=;
        b=TtRIGj3JKHFCMhjInuNsEuYO4DY4sZS1//7/U22jklt5gI7aiAvMYMHPdlTPz6OErJ
         Sx/m6+oAkqW+NP412TmOccLa9/KM1gqtuZ9epq45EVvVsJvSa5AOqYQY11259oYKFRFx
         STZkmclIAkgjQHE3bt7FoCEyAoVh9GnGnSTztQGql12wcaOBLpFa45KxkonxcfJddfDy
         d/jPsH6OOxSVL7vRK4W8PJPz4NDSDAXq11UEt9EmMjhVYR/k5WWTxCPvX8dlmAbssgaI
         QjJ9ksxdqM8QA2D9L1oy3d0XzCjmfWcHgpd6pXOECMyLHwG41dqy0HVFNbVUK6airRMC
         kzmQ==
X-Gm-Message-State: APjAAAVqB0cZhjLAWKpDt/v8AcWfjubTkS4i9gxLvB7RmgIFOpcFhUZI
        csNfkCvxL1aPF3Z0TIU+rJp/rLL53lF46CV7dJUUGIuFTecW2aTB3WnGxWXCzmKEiTyIU+bZIeT
        IYebJPCgDur515jP+j8ImfOtjjTKX8Koh6kRidA==
X-Received: by 2002:a37:b704:: with SMTP id h4mr19373796qkf.39.1552388759941;
        Tue, 12 Mar 2019 04:05:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzc3WkjPFIew0rUJ4rvq+sC1ihUc28g1hckhy15AZ++tjWJ/KJPi6jAT6PWskJO+gQkvMlrZA==
X-Received: by 2002:a37:b704:: with SMTP id h4mr19373775qkf.39.1552388759653;
        Tue, 12 Mar 2019 04:05:59 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::3b7])
        by smtp.gmail.com with ESMTPSA id f13sm5575421qto.80.2019.03.12.04.05.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Mar 2019 04:05:58 -0700 (PDT)
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/wireless/realtek/rtlwifi/usb.c - fix some non-kerneldoc comments
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Tue, 12 Mar 2019 07:05:57 -0400
Message-ID: <15731.1552388757@turing-police>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Building with W=1:
  CC [M]  drivers/net/wireless/realtek/rtlwifi/usb.o
drivers/net/wireless/realtek/rtlwifi/usb.c:243: warning: Cannot understand  *
 on line 243 - I thought it was a doc line
drivers/net/wireless/realtek/rtlwifi/usb.c:760: warning: Cannot understand  *
 on line 760 - I thought it was a doc line
drivers/net/wireless/realtek/rtlwifi/usb.c:790: warning: Cannot understand  *
 on line 790 - I thought it was a doc line

Fix comment blocks so they don't look like kerneldoc lines

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index e24fda5e9087..9478cc0d4f8b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -239,7 +239,7 @@ static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
 	mutex_destroy(&rtlpriv->io.bb_mutex);
 }
 
-/**
+/*
  *
  *	Default aggregation handler. Do nothing and just return the oldest skb.
  */
@@ -756,7 +756,7 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
 	return err;
 }
 
-/**
+/*
  *
  *
  */
@@ -786,7 +786,7 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
 	usb_kill_anchored_urbs(&rtlusb->tx_submitted);
 }
 
-/**
+/*
  *
  * We may add some struct into struct rtl_usb later. Do deinit here.
  *

