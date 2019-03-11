Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B02C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E82120643
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:54:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="Dj+93rYb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfCKHyt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 03:54:49 -0400
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:59010 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfCKHyt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 03:54:49 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 75C4092C
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 07:54:47 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 7X3NLQabe0qa for <linux-wireless@vger.kernel.org>;
        Mon, 11 Mar 2019 02:54:47 -0500 (CDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 4FC9A9CC
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 02:54:47 -0500 (CDT)
Received: by mail-io1-f71.google.com with SMTP id k2so3569742ioj.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 00:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Hu9tC1WSl8tGjIx7E+uA6syKbui28C0mvmzOxgNZjNo=;
        b=Dj+93rYb73Zn70wTR81Bm4QFAZKNfexSP1mhUE058/V4XLAJNvbQQqXVWmHNKA1bJq
         GGyU+rlG2Eia9S9UDHyxXK4uMTVk9QvHZDqZqHvh4CKXnlZRlInRNEjU4ZaMvbo6yXv/
         dujngH9MaffKlochSn4d7yVX4xr3mf3SdKFgd8i3ALzzgrKjBRPwh9PPKEZ72IIDQoT5
         ElwRaCgDvSg+o/DkSyDElA7btRsXFfk0R/6qRDaTLTNuepxazh/SVlCzpeoFcp7TpIx5
         b2CJ3Ri/TzKUEeCys1P+6GUhuz4qbwDF3vFNC9s7PCiq7oO91j0zGcGw626kQYYnIqFa
         JCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Hu9tC1WSl8tGjIx7E+uA6syKbui28C0mvmzOxgNZjNo=;
        b=nj/LCR0JuqCABHUirVfvMOsUsKgeKYPUO6nOP/gu0trJItwQNY1orBm3uuyIz+/jod
         KfRMuP9bFd2yb6gxYZzv8T6QI2cJNe6zaeonIJm7eutyYUsk1YbeQ4CoUtVuTBYfWJVS
         ejPYF3SwMiN2g0EvhWFOfEWDQ2v1MxeZuZrrjpRaGBn3Zp8RGtUwqGYNW2nilyWO2lYn
         y0oFvDYcvvFdjbPArqWxX5g27KuQfTvcLeY//4ATz008NvB5itWvZERJRGtre38tkUVi
         yVlFLhM2Xr9BB++8xHR3iXbi4hUhEvc8tYWvFsTbNPANdies/5atThWDZgNSQ2/F7Jcz
         IGXg==
X-Gm-Message-State: APjAAAW9yLuHE9ADX9OoejqxkDJ+zw/z5zNn8zgMWqlwLo6Uaa8polil
        67HAScrMPnvGWZxxCvgcJNiNoxw9RpHQGnQRMwkWltEqgIK0Pw4+IadGwV9LDvnByOCXr4q8ul5
        9CfP1So3Kb/C89XWBS3EjwYE0eNAhCtw=
X-Received: by 2002:a5d:8c85:: with SMTP id g5mr503612ion.195.1552290886891;
        Mon, 11 Mar 2019 00:54:46 -0700 (PDT)
X-Google-Smtp-Source: APXvYqziUDffAPz74NCA/DrX+4s1tCw5RM2Q2Twx1MaeiywzFQZtGY8OY7YcMckfQMVrEBm0Jl7pug==
X-Received: by 2002:a5d:8c85:: with SMTP id g5mr503602ion.195.1552290886649;
        Mon, 11 Mar 2019 00:54:46 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id f17sm7231879itb.36.2019.03.11.00.54.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 00:54:45 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: fix missing checks for ioremap
Date:   Mon, 11 Mar 2019 02:54:40 -0500
Message-Id: <20190311075440.1513-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

ioremap could fail and returns NULL. The fix actively checks
its return value and handles potential failures.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/ray_cs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 44a943d18b84..cecd18a2f2de 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -394,6 +394,10 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->sram = ioremap(link->resource[2]->start,
 			resource_size(link->resource[2]));
+	if (!local->sram) {
+		ret = -ENOMEM;
+		goto failed;
+	}
 
 /*** Set up 16k window for shared memory (receive buffer) ***************/
 	link->resource[3]->flags |=
@@ -408,6 +412,10 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->rmem = ioremap(link->resource[3]->start,
 			resource_size(link->resource[3]));
+	if (!local->rmem) {
+		ret = -ENOMEM;
+		goto failed;
+	}
 
 /*** Set up window for attribute memory ***********************************/
 	link->resource[4]->flags |=
@@ -422,6 +430,10 @@ static int ray_config(struct pcmcia_device *link)
 		goto failed;
 	local->amem = ioremap(link->resource[4]->start,
 			resource_size(link->resource[4]));
+	if (!local->amem) {
+		ret = -ENOMEM;
+		goto failed;
+	}
 
 	dev_dbg(&link->dev, "ray_config sram=%p\n", local->sram);
 	dev_dbg(&link->dev, "ray_config rmem=%p\n", local->rmem);
-- 
2.17.1

