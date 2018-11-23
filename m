Return-Path: <SRS0=iPli=OC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D1DC04EBA
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 21:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09C3120865
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Nov 2018 21:39:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fii6N9Yp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09C3120865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbeKXIXb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 24 Nov 2018 03:23:31 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45642 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbeKXIXa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Nov 2018 03:23:30 -0500
Received: by mail-ed1-f68.google.com with SMTP id d39so11215353edb.12
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2018 13:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2TsnoTzt7nMyhEJf0qrk+D/XMdg46HqMsOgCQBtd/M=;
        b=Fii6N9YpUQrpyy6pRyfB6/4Cc2IrDWUnae1dWNo2j4ipxa45s9esvcDYbcvmout8uS
         naGWT71z+02XXEXNaRiQPXop5WBcwgYqVbA0hbsbh7cvtqt4A0hdtyDutJfWNIGhcIXP
         25dUfVN7+W/9NjI2JTfUqVEYZmUtzdI7GF89cDjhN3q1sFFQl25iIJ4u7YMJBJXBErnc
         dyTjEpfgygybDSi3NF6PuEnucoLt8zz6mlT4LsoRy8FSwDFsuEB5nFWcHs/lpWyCAkty
         wzbnc45udxYsgUQXjcmv9HkDKZJhrASSGHItbOd2vUksC4KD6MdKfyRVTfL8TPz4mLHw
         JZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2TsnoTzt7nMyhEJf0qrk+D/XMdg46HqMsOgCQBtd/M=;
        b=WQ3YBbkN2Xy9AE+4uV+MLLp6looJhDVYxSlFDvb1XlRrTrMIiqpCoKLTKp3dyHEiFT
         YhHbg1vlyA6T3lQBXVFuClgoRqIseY5z9z7h3ESdOJlkGCbpBLdzppzwoAbJfXZ/G/gF
         LIA/VGp4OfD6ow2+cs72cZscsa+milj+ViPCwY6jCPtJ7N+S4HYNRPPxtQ4ONT+qQTt5
         t7ZXzg3Jy/FAk8McOm14qa9NZNCZgUMYXOjqLNsripHOIN0bUnBqvGXcGtGcX7su8/ts
         jczxTF48TZO6WKgVEQL+tCPwAz9KCIS/Gbzg8c/RMO4T1SQFZd5vkvyZDvmuVOHk2Hvd
         aCOQ==
X-Gm-Message-State: AGRZ1gLCHymAPwBsNOSiMDKV4IBCA+tZ+OlsUBsPR3eODr9dUAT0Naik
        Qn2IoacesJm9/qXMtKKxWPydHNFW
X-Google-Smtp-Source: AJdET5fSy60Nbe7Pm2rwIAPM4ddte4LVKU99l2y3X9NNhzfYKeAUX1IAifaBOKcN4X4zfCkE5fNncQ==
X-Received: by 2002:a17:906:2496:: with SMTP id e22-v6mr12666878ejb.84.1543009052273;
        Fri, 23 Nov 2018 13:37:32 -0800 (PST)
Received: from localhost.localdomain (ip5f5aff54.dynamic.kabel-deutschland.de. [95.90.255.84])
        by smtp.gmail.com with ESMTPSA id e14sm9015880edb.79.2018.11.23.13.37.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Nov 2018 13:37:31 -0800 (PST)
From:   Eduardo Abinader <eduardoabinader@gmail.com>
To:     linux-wireless@vger.kernel.org, nbd@nbd.name,
        lorenzo.bianconi@redhat.com, sgruszka@redhat.com
Cc:     Eduardo Abinader <eduardoabinader@gmail.com>
Subject: [PATCH] mt76: handle protocol error to proper deinit rx_tasklet
Date:   Fri, 23 Nov 2018 22:37:24 +0100
Message-Id: <20181123213724.14018-1-eduardoabinader@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

During removal of usb dongle, noticed many unhandled rx urb
below. This this patch, make it possible and early completion
of the rx tasklet.

mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
mt76x2u 1-3.4.3.1.2:1.0: rx urb failed: -71
...

Signed-off-by: Eduardo Abinader <eduardoabinader@gmail.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 5f0faf07c346..dc33df9cd155 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -446,6 +446,7 @@ static void mt76u_complete_rx(struct urb *urb)
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 	case -ENOENT:
+	case -EPROTO:
 		return;
 	default:
 		dev_err(dev->dev, "rx urb failed: %d\n", urb->status);
-- 
2.19.1

