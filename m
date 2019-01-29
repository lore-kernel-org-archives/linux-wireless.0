Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967B1C282D0
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 23:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 620C42184D
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 23:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Tv91WTP1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbfA2XSI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 18:18:08 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:42137 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbfA2XSI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 18:18:08 -0500
Received: by mail-pl1-f194.google.com with SMTP id y1so10093008plp.9
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2019 15:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MZ/DdbeQn7CAyCekKMFuF2UcpgJJmHxGBqfuC9XeHKI=;
        b=Tv91WTP1jaB97yFmEnSDpjYezcdLkLhE2dy82hyp+RrGtE23FnP5F1B96H5HtcJCwD
         IqL0g3gM8rzJuARtywfzWCe1CFpuJ6CxjeLD9EJZn+4L3pmIpms5z/lMQQH/q8klh+P1
         U8dnzJ8Wg3lbSk/9byGVzqX+R1TuOEkfLEYRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MZ/DdbeQn7CAyCekKMFuF2UcpgJJmHxGBqfuC9XeHKI=;
        b=i7cl51n4yu57P2HiBI3FFpzgSYr/Z9Go31bOqFjFuMFf7hGWFcFT72c1GsOp7jxtKO
         iyUP50vKIBA4cN7ulYN6RAM7ymcho0AB8IFuCCjWLCtAkinPIROMbfRC/VOOSF8QyOjs
         YiHkEe2YhO4gir8Gyxyg28DBVcUp9XHBd5siLGHPEiMaJSIk0BKOtuJGkvV927CeWR2P
         dkYHbwro+0J02hdIe9/WOHVk98xRZElIpshpz/E+yXhn2vQ95msmtOFwNp4/0hdddtFS
         TpaIMbqUr7s6ZK8RiB4OwaEYM3N3OYegV8eIlJBoTWTsRymQ9cilR1OILToHgovUGn2Y
         xSQQ==
X-Gm-Message-State: AJcUukcyrXJvdugo4XZozDhsUm9hBz1mgv+J75McfLVf+zWUz+88GHtw
        jFT+4FgqtEp70P+yw6RObCELvg==
X-Google-Smtp-Source: ALg8bN7VBCDE0/zoF+Opol1KpqEnJkhDMFX3iQ3NtIYykELf8XA2yufVCHxgS3tEs883H9M0s4J6lA==
X-Received: by 2002:a17:902:8bc6:: with SMTP id r6mr27842288plo.67.1548803887519;
        Tue, 29 Jan 2019 15:18:07 -0800 (PST)
Received: from smtp.gmail.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id r8sm46949632pgr.48.2019.01.29.15.18.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 15:18:06 -0800 (PST)
From:   Brian Norris <briannorris@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Wen Gong <wgong@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] ath10k: sdio: add .owner field
Date:   Tue, 29 Jan 2019 15:14:48 -0800
Message-Id: <20190129231448.83305-1-briannorris@chromium.org>
X-Mailer: git-send-email 2.20.1.495.gaa96b0ce6b-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

sdio_register_driver() doesn't do this for us, unlike (for example)
platform_driver_register(). This is important for helping track
module-to-device relationships.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/sdio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 983ecfef1d28..2fc0c17c9672 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -2088,7 +2088,10 @@ static struct sdio_driver ath10k_sdio_driver = {
 	.id_table = ath10k_sdio_devices,
 	.probe = ath10k_sdio_probe,
 	.remove = ath10k_sdio_remove,
-	.drv.pm = ATH10K_SDIO_PM_OPS,
+	.drv = {
+		.owner = THIS_MODULE,
+		.pm = ATH10K_SDIO_PM_OPS,
+	},
 };
 
 static int __init ath10k_sdio_init(void)
-- 
2.20.1.495.gaa96b0ce6b-goog

