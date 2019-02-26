Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10096C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 07:26:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF4C4217F5
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 07:26:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nv/ZdFrV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfBZH0B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 02:26:01 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37174 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfBZH0B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 02:26:01 -0500
Received: by mail-yb1-f194.google.com with SMTP id k1so2594160ybf.4;
        Mon, 25 Feb 2019 23:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LZ4DUBnEU88jzCbE5YnRANEXwzzeho3P2WNEh7r15j8=;
        b=nv/ZdFrVxYBJAw8uOrb2pQroMNU1ew+d1Nyw64K+nDaElDgigWDJF1qy94T7jm94O1
         fEZkyIcJeRvRQ91bqNNEIzHgDo7jxk0lsyjAm77tzeIJWHeo187vszRGP21NDbOGg9jM
         hJ7oqogcNyBZmyvPtxEqbmZmRaNam6AkXZNdLMxJTqnwtKIG7S3WAc/9j9Bv46NDjV87
         aiHBbOpxEUjfu4Xr26SJ7JVk+bhDqudkjceqqkgy+J0TWYxewIAt4mmEeHtJ+/mKqT4z
         4W0TM7J0McUu9cYIyUhpJWBFAXOpMcRbqwHaAS1ODDJc1UXiVyAi2bEUBAAam+hIvwGw
         QNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LZ4DUBnEU88jzCbE5YnRANEXwzzeho3P2WNEh7r15j8=;
        b=BmFNkjAYaIxJK9M6+p8BS4Y3O9LhjedhbJofPTNDscy3DGOE1Z/LTKGFifETsCefGC
         gF+YI3p8eaE5oI0Gvd0Mq4lYcmYMQTVFdi1CqGWpL7tOdB4qua2qDb9VcuP4L4rMBMJ5
         7j1+FnpOOzOmmceA6ccfDf1CFO5tJ+X6QLEeJf5f5E2Kfu3CQBCBng8rhDAwKJ1nygTF
         QMi1v5KAewzJFWeyTv5zrdswPPtopADlEZlUgsTzd4PRYoKAwBIo9l+Noj5wVWUwNeZk
         Eg764+8cUzlUbCnisV79j53gat/GD7Dd7KIYTjVJZzRMB9MTr6eYqQS4LzpQw/JvzZEJ
         cttQ==
X-Gm-Message-State: AHQUAuZjM6lboroNZTYrEYtT9QEw3KCXr94KgUSLiKPowg9E02qZSxIz
        tFI96dfLmV+hYhFI6ky81HM=
X-Google-Smtp-Source: AHgI3Ib98sbe7NLUC6w6QPxxOPQ7wrXcW470FfqdDI9cqRVXaqyp5fC8yFtaXS288kTET/J5lNK2+A==
X-Received: by 2002:a25:71c2:: with SMTP id m185mr16730018ybc.162.1551165960493;
        Mon, 25 Feb 2019 23:26:00 -0800 (PST)
Received: from localhost.localdomain ([191.101.9.198])
        by smtp.gmail.com with ESMTPSA id m67sm3951777ywe.56.2019.02.25.23.25.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 23:26:00 -0800 (PST)
From:   Bo YU <tsu.yubo@gmail.com>
To:     adham.abozaeid@microchip.com, ajay.kathat@microchip.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        yuzibode@126.com
Cc:     Bo YU <tsu.yubo@gmail.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH V2] staging: wilc1000: fix incorrent type assignment
Date:   Tue, 26 Feb 2019 02:25:56 -0500
Message-Id: <20190226072556.26745-1-tsu.yubo@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix sparse warning:

drivers/staging/wilc1000/host_interface.c:450:30: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/host_interface.c:450:30:    expected restricted __le16 [usertype] beacon_period
drivers/staging/wilc1000/host_interface.c:450:30:    got unsigned short [usertype] beacon_interval
drivers/staging/wilc1000/host_interface.c:451:25: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/host_interface.c:451:25:    expected restricted __le16 [usertype] cap_info
drivers/staging/wilc1000/host_interface.c:451:25:    got unsigned short [usertype] capability

Signed-off-by: Bo YU <tsu.yubo@gmail.com>
---
V2: use cpu_to_le16 assign valid type according to Ajay's suggestions
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 50dc2dd942f5..20349af2ed30 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -447,8 +447,8 @@ void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
 	if (!param)
 		return NULL;
 
-	param->beacon_period = bss->beacon_interval;
-	param->cap_info = bss->capability;
+	param->beacon_period = cpu_to_le16(bss->beacon_interval);
+	param->cap_info = cpu_to_le16(bss->capability);
 	param->bss_type = WILC_FW_BSS_TYPE_INFRA;
 	param->ch = ieee80211_frequency_to_channel(bss->channel->center_freq);
 	ether_addr_copy(param->bssid, bss->bssid);
-- 
2.11.0

