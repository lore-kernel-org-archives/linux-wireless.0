Return-Path: <SRS0=Lfj+=PJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E795AC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Jan 2019 23:00:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2F432073F
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Jan 2019 23:00:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iRsDxNzm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfAAXAY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Jan 2019 18:00:24 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41717 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfAAXAY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Jan 2019 18:00:24 -0500
Received: by mail-lj1-f196.google.com with SMTP id k15-v6so25727978ljc.8
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jan 2019 15:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iUipszXqg+UCsaAP2Zv0lD7DMU9EtOWuUga15ntSNuI=;
        b=iRsDxNzmHmSZLEPPdUSF1uALCXhgVlKu/xJYBpw0UoebHWmfL1VUpaP790ETAnr9p4
         Kq9zHUYdCg7pi+SCXLWDJ9ZuFhrlP3wIKaNwvC9zdCssV57bmEsrM2pZScGPjp1DVuk3
         bz6QgS2p5KYgSZYLqmxbW1yclseoceoqy8ghD+389HS4VQz/9Yn/LgPjjEHYTYaRnUVu
         k2ZEPtI7XLKEz/kztrabopn5fwJMk92Org4YzYZRg00vuuK9UYw+CwXvPM4BEWpkIScK
         d9Fm7H+OaT8mfXzQvrWDbZlwUBnl5wS777t4iq9DlAZYdw+FeiaZXxYANKgiXJFu0l7/
         oIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iUipszXqg+UCsaAP2Zv0lD7DMU9EtOWuUga15ntSNuI=;
        b=H/2bamjm5jzUd17dZd/UCUpD9PVSCKcYv/igL8HuxXA71y97rP4YF4jmj0uCqNUBT/
         mKplStygAHceztmWNzU2+MjqlOnV2Ndh+4cSqOFR4Mk536GphVLfSn/RY8I33fwwapQZ
         eOPL0cBGWGRE4KqyMlwipzE9ISX7u1EVaQPpmKsUaYgtd0IJpdtJmlfjPXRuzAHaOG/b
         NNarBIABNhhBi6icCKJRW2e0DuJyTbk2JWkI+bUQWHMLeZdq5IM1104pLGT84TdRMRLQ
         Wh3cQh3dQ3yNyamu/TWJuxzQoGkqgTVfNRfy+j61bwdWq8PBmDpPPd8CsO8oyvU9+SUa
         ptZQ==
X-Gm-Message-State: AJcUukcEWn4j7srFnvmuH+rFvtobFF1onyjKwnI5nN/hdpou0jc16ZzD
        Wm5OoFKj1oPn0a6esadrIDE=
X-Google-Smtp-Source: ALg8bN4+cwlqqugePwJ/TRQ4VlsZRIY/2g1YP7RJVHg5hDw+RFTqSK9al0XSp0tNXuEouByXSg6YUQ==
X-Received: by 2002:a2e:8945:: with SMTP id b5-v6mr20402894ljk.55.1546383622658;
        Tue, 01 Jan 2019 15:00:22 -0800 (PST)
Received: from linux-veee.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e97-v6sm10994589lji.51.2019.01.01.15.00.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 01 Jan 2019 15:00:22 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/2] bcma: use dev_* printing functions
Date:   Wed,  2 Jan 2019 00:00:02 +0100
Message-Id: <20190101230002.18845-2-zajec5@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190101230002.18845-1-zajec5@gmail.com>
References: <20190101230002.18845-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

It provides more meaningful messages.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/bcma/bcma_private.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 1f0e66310b23..6eded32d1aac 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -10,13 +10,13 @@
 #include <linux/delay.h>
 
 #define bcma_err(bus, fmt, ...) \
-	pr_err("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
+	dev_err((bus)->dev, "bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
 #define bcma_warn(bus, fmt, ...) \
-	pr_warn("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
+	dev_warn((bus)->dev, "bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
 #define bcma_info(bus, fmt, ...) \
-	pr_info("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
+	dev_info((bus)->dev, "bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
 #define bcma_debug(bus, fmt, ...) \
-	pr_debug("bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
+	dev_dbg((bus)->dev, "bus%d: " fmt, (bus)->num, ##__VA_ARGS__)
 
 struct bcma_bus;
 
-- 
2.20.1

