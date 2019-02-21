Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3EBC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 23:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B57D206A3
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 23:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=4sigma.it header.i=@4sigma.it header.b="QUQr1CTi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfBUXNR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 18:13:17 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38915 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbfBUXNR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 18:13:17 -0500
Received: by mail-wr1-f67.google.com with SMTP id l5so324141wrw.6
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 15:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=4sigma.it; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=qtJLFBXgkYdI/h6OpEbdGjMWc1iqyJYezad5IMGHUs0=;
        b=QUQr1CTiQz/wn4QX2q46U63jvxZvqc0ODSsIMrQRU0QW7sSKm+pDVhlBX5100VIo5/
         iwF9A0CdUTPLsOogGJlmojT2ebuBqKJT6y91llkn4fp9qcpXo4/zRItsO8cnfUb+2nwg
         iVU/f9qD28DneH7TbUYV/+3c1rOhH1Hy4RXes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qtJLFBXgkYdI/h6OpEbdGjMWc1iqyJYezad5IMGHUs0=;
        b=tWHLxZX5tahoZbmkKM9n7wrCwDvRQgav43fRdMr1h9gjzXHUVTxdjABVTihelsK9mt
         FKhAvyZ558xHJEnChThCnL7v7ajYeshPJjT3pRYWejoox81EgRAbCUZ2GdIa8jbiA4tK
         tgHl0+OHMgHGvDAWQ9Nk/uXXBfGjgAUsttJvxf/gIH/CFCJOvERODn2OJhXM1vhY8V43
         xjkVL46wYrWzxKQ/2eF/zVzt9OOmWuIFc7jLp3wIwAuHuC9vXZR17Derb3TmANL9w/0v
         hlfAwYWs6vsoIko211golPLxIC595WOzVTb3Pww53VzOV5zVn2FqXQR4IAEEhD/aMSEJ
         u6Eg==
X-Gm-Message-State: AHQUAubzNdBfuDVnYk5TUUKwEPhAudz5K7PBfwGP7U07nwaylTvM2DKq
        ldDbSkbi8iY7HG49JLd7rxLo7Q==
X-Google-Smtp-Source: AHgI3IY7mT0sBYWrazgq7Q+AUwdUjpvxDh/i2fHqI+OleshXAnRa3sMPgNShvQu0hT+qOrF2GgAJQQ==
X-Received: by 2002:a5d:5504:: with SMTP id b4mr571750wrv.291.1550790795261;
        Thu, 21 Feb 2019 15:13:15 -0800 (PST)
Received: from localhost.localdomain (host121-71-dynamic.24-79-r.retail.telecomitalia.it. [79.24.71.121])
        by smtp.googlemail.com with ESMTPSA id i13sm144959wrm.86.2019.02.21.15.13.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 21 Feb 2019 15:13:14 -0800 (PST)
From:   Andrea Greco <a.greco@4sigma.it>
X-Google-Original-From: Andrea Greco <andrea.greco.gapmilano@gmail.com>
To:     johannes.berg@intel.com
Cc:     Andrea Greco <a.greco@4sigma.it>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ath9K: debugfs: Fix SPUR-DOWN field
Date:   Fri, 22 Feb 2019 00:12:57 +0100
Message-Id: <20190221231257.6221-1-andrea.greco.gapmilano@gmail.com>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrea Greco <a.greco@4sigma.it>

SPUR DOWN field return spurup inside of spurdown

Signed-off-by: Andrea Greco <a.greco@4sigma.it>
---
 drivers/net/wireless/ath/ath9k/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 4399e9ad058f..d4a2cdf9212c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -148,7 +148,7 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 		{ "OFDM LEVEL", ah->ani.ofdmNoiseImmunityLevel },
 		{ "CCK LEVEL", ah->ani.cckNoiseImmunityLevel },
 		{ "SPUR UP", ah->stats.ast_ani_spurup },
-		{ "SPUR DOWN", ah->stats.ast_ani_spurup },
+		{ "SPUR DOWN", ah->stats.ast_ani_spurdown },
 		{ "OFDM WS-DET ON", ah->stats.ast_ani_ofdmon },
 		{ "OFDM WS-DET OFF", ah->stats.ast_ani_ofdmoff },
 		{ "MRC-CCK ON", ah->stats.ast_ani_ccklow },
-- 
2.17.2

