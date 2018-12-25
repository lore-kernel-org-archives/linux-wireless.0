Return-Path: <SRS0=458R=PC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A758EC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Dec 2018 22:30:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C1012173B
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Dec 2018 22:30:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i0G9zIVU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbeLYWan (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Dec 2018 17:30:43 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36838 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbeLYWan (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Dec 2018 17:30:43 -0500
Received: by mail-wr1-f66.google.com with SMTP id u4so14384845wrp.3;
        Tue, 25 Dec 2018 14:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5fOGnKGi1KW1Jz4CcUtu1Z5DWuG3MIq7WLWqYoCdj+0=;
        b=i0G9zIVULg6wysgzMHHWGPaxxb4UNe82SN18TMCQ6Lc3KO2Zq+eAYoFbrl5T0k1lbL
         FzEyrzVAf8vA0Xnb4LuAg05b2Pq36eR8M0pcMiuXHAPxrBysJ7+nN/rzvNvPXbmyeynZ
         8zZD9wVAALKj9KJFeEBD4bWBQme1rO1OFZW/NaNQCjr8RqV+i46mTwJiNUgVsLgU8ird
         y+hGG7FMXQmCj+pFHW6CqWF2I/kDUkTCMBR50cB97kTmB1H9Ik05GC1gf74NA949rB0k
         G5ekO0+WzMSfMW60cdJ5ywVZBIEdfH4oUj6N97xGOhgBpbhiBigO3071vV4jxmwNti8B
         UP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5fOGnKGi1KW1Jz4CcUtu1Z5DWuG3MIq7WLWqYoCdj+0=;
        b=ZqWewqxWsZO2CMypSbaqjUKBD5O7PArJ9jOuqQKZJoYnE3hGRGQtcImmYaYQZjIR5F
         ESgYkkNjtOc9G/VCQ3n/FC0ILehACVMPPXFEfKtdXlvKP0jA6Za5hA/dS+eSgG+KyFbe
         GJGJg66IW5uJR8k2tv/RZEqaqjD0ixacE56+vabOf8dIH0Xw0aY7EneCtefO8L5YuaEl
         /yHeqhHwUdFOfAMM/CjQtpjRWBeeWXW7kuQdpUz3rY1vtfjlmksjk0HoEtIrWP+jpXCf
         W8BG3SN0rVZOGbNtEdk4FAwB5KXYCE7dVa+GyMh7sgBACJMU45r9+P5i9gErduM7YeD7
         J0fg==
X-Gm-Message-State: AJcUukfqeuh9Kdc+1DmauoukZ+t8619I9KEYVul2nz9gRHmlQUAOwF47
        QMYWem7lo8Ramn2FAPbVA9s=
X-Google-Smtp-Source: ALg8bN7qcloBxVo2png8In1e9y60PRsMVNRz2cpsyjVKaWFS7RWKJ3/fT0IwOC0wQJXtATa523GMmQ==
X-Received: by 2002:adf:e983:: with SMTP id h3mr15930540wrm.232.1545777041603;
        Tue, 25 Dec 2018 14:30:41 -0800 (PST)
Received: from norris-440-G3 ([5.134.110.166])
        by smtp.gmail.com with ESMTPSA id y145sm20951699wmd.30.2018.12.25.14.30.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Dec 2018 14:30:40 -0800 (PST)
From:   Marko Stankovic <dartnorris@gmail.com>
To:     adham.abozaeid@microchip.com, ajay.kathat@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marko Stankovic <dartnorris@gmail.com>
Subject: [PATCH] staging: wilc100: make function wilc_get_stats_async static
Date:   Tue, 25 Dec 2018 23:30:15 +0100
Message-Id: <20181225223015.7352-1-dartnorris@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Makes local function wilc_get_stats_async() static

Cleans up sparse warning:
symbol 'wilc_get_stats_async' was not declared. Should it be static?

Signed-off-by: Marko Stankovic <dartnorris@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 70c854d939ce..5dae6e7155d3 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1992,7 +1992,7 @@ int wilc_get_rssi(struct wilc_vif *vif, s8 *rssi_level)
 	return result;
 }
 
-int wilc_get_stats_async(struct wilc_vif *vif, struct rf_info *stats)
+static int wilc_get_stats_async(struct wilc_vif *vif, struct rf_info *stats)
 {
 	int result;
 	struct host_if_msg *msg;
-- 
2.17.1

