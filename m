Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A65C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 12:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DACB206B7
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 12:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DACB206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hauke-m.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbeLBMHD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 07:07:03 -0500
Received: from mx1.mailbox.org ([80.241.60.212]:11446 "EHLO mx1.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbeLBMHD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 07:07:03 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx1.mailbox.org (Postfix) with ESMTPS id 130D640570;
        Sun,  2 Dec 2018 13:07:01 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id qiWc_kGCrmVv; Sun,  2 Dec 2018 13:06:59 +0100 (CET)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     nbd@nbd.name
Cc:     kvalo@codeaurora.org, lorenzo.bianconi@redhat.com,
        linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] mt76: Add missing include of linux/module.h
Date:   Sun,  2 Dec 2018 13:06:34 +0100
Message-Id: <20181202120634.4323-1-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

MODULE_FIRMWARE() is used in usb_mcu.c and provided by linux/module.h,
but this header file is not directly included. This causes problems in
backports with some kernel versions.

Add the missing include.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
index a9f14d5149d1..b2b3fd0db4bb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
@@ -15,6 +15,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/firmware.h>
+#include <linux/module.h>
 
 #include "mt76x0.h"
 #include "mcu.h"
-- 
2.11.0

