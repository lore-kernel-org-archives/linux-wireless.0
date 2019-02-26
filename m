Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD63C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 03:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 575CF2147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 03:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MooY1OHe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfBZD2c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 22:28:32 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:44674 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfBZD2b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 22:28:31 -0500
Received: by mail-yw1-f66.google.com with SMTP id x21so4551195ywx.11;
        Mon, 25 Feb 2019 19:28:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=NxYjjTGqpZBjFr+8DOd2n5OIX7erXps59h4H0sSEweY=;
        b=MooY1OHe/0pqHOJDj963G7CSE+4komMoooChYrAPc9yK7vPNQKXMo8zgAORTBMTgUg
         RuSmhFqBnDoqwVFiynXRO1tiStKE3FBCZLVBH+zeTiCRu1nJWmKcl4+OlO9vDQidaA38
         BZWhDKGmn/zwXYxBw4CzobRR5agO/nYaFFURT/b2CcTfN48cIzHkPZZyGw2xTnsUCL+t
         gy+JrY5B30cYCIG1ByDVkIepoiOLTsgwIuOg2+cyZ345sDwCnzn45POx/uMiop1JhUWt
         ywYFN7PQEvd2Uiq0l7Q7kHZjLp7oxBN05wIPoiHwz4h/+O/9LioTutB8d+V4u0ik3FDe
         MmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NxYjjTGqpZBjFr+8DOd2n5OIX7erXps59h4H0sSEweY=;
        b=irP7OVI4su6nqEYw7oAa0fTHFVUieoIfsYpxuEmXthjL+e3fXx13XX71JdQfiKhTVM
         0lelP3O0GoXtkHzrvfQZFr3+v7Qg8FvneLTGEkXvzaicu3io743knTUcpvnnp4gs3Rjw
         0R2y3a+fmQw0W5Uky8P0TF+KjLFU1sbl4KwjOTIzwLZCzNnYiGZmnP6fCXQ1uHUfOZFC
         UkAwz48pcYds+9CYH4tZSkBdunbBU/9uByFBh02I2jMSFNk0S+rotcNerpYS+4v3zzTo
         dcNxbB0WhenVrv/eTE74J2QOH5/NamLu+oLZlM6Z74kI+9l9DCULwoTQMvkbymfJFdQi
         pLNw==
X-Gm-Message-State: AHQUAuYH6sDL0YrrfvYaA5ofM3eP6p5SNMUGDAXYWj87ZH2gJEy2T3yb
        SNzr6XAQOpDGzg0Inn4d9mY=
X-Google-Smtp-Source: AHgI3IYHU38QYRC295FR2tMWD5wBO8uuPAMEZt31uJHeQqsRbHGjSJHdmISpLwSekHvrnOscC/XI7Q==
X-Received: by 2002:a81:25d7:: with SMTP id l206mr16888875ywl.253.1551151711037;
        Mon, 25 Feb 2019 19:28:31 -0800 (PST)
Received: from localhost.localdomain ([191.101.9.198])
        by smtp.gmail.com with ESMTPSA id l144sm1983733ywb.75.2019.02.25.19.28.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 19:28:30 -0800 (PST)
From:   Bo YU <tsu.yubo@gmail.com>
To:     adham.abozaeid@microchip.com, ajay.kathat@microchip.com,
        gregkh@linuxfoundation.org
Cc:     Bo YU <tsu.yubo@gmail.com>, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        yuzibode@126.com
Subject: [PATCH] staging: wilc1000: Fix incorrent type in assignment
Date:   Mon, 25 Feb 2019 22:28:25 -0500
Message-Id: <20190226032825.26171-1-tsu.yubo@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The patch fixes following sparse warning:

drivers/staging/wilc1000/host_interface.c:450:30: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/host_interface.c:450:30:    expected restricted __le16 [usertype] beacon_period
drivers/staging/wilc1000/host_interface.c:450:30:    got unsigned short [usertype] beacon_interval
drivers/staging/wilc1000/host_interface.c:451:25: warning: incorrect type in assignment (different base types)
drivers/staging/wilc1000/host_interface.c:451:25:    expected restricted __le16 [usertype] cap_info
drivers/staging/wilc1000/host_interface.c:451:25:    got unsigned short [usertype] capability

Signed-off-by: Bo YU <tsu.yubo@gmail.com>
---
I have no hardware to test it and just to compile it
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 50dc2dd942f5..cdcb52aec779 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -106,10 +106,10 @@ struct wilc_join_bss_param {
 	u8 ssid_terminator;
 	u8 bss_type;
 	u8 ch;
-	__le16 cap_info;
+	u16 cap_info;
 	u8 sa[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
-	__le16 beacon_period;
+	u16 beacon_period;
 	u8 dtim_period;
 	u8 supp_rates[WILC_MAX_RATES_SUPPORTED + 1];
 	u8 wmm_cap;
-- 
2.11.0

