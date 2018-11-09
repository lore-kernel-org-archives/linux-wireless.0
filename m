Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5D2C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4563720825
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 16:23:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JYNw3e4J"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4563720825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbeKJCEm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 21:04:42 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39439 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727941AbeKJCEm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 21:04:42 -0500
Received: by mail-wm1-f68.google.com with SMTP id u13-v6so2463255wmc.4
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 08:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uFNSWfjEVRjxBVi/h0p6c5lkg8AafdP2KyZdJzBrb98=;
        b=JYNw3e4JXPurJLVbVKsKlXe4aWnP+mmgFjbPALew/gjv2XixpxlfkX6sfLc76E8nKb
         Xyf+VBf21x80Yy+X35kN9okgvYamvvm7VjM8n++8SAOY1CJnV+4qMR505dbVr+ank8ED
         ZKnsToQ0XofGGAbDf87NhARNitwpMhm/w2kqjFt0XaxtqM0Vmd5SzxLvglC0WrVTlpsr
         HluLqmG7FAD4d8APdJtaKquQscmsdeiktTEpHwRHYBNyXNS4lJXdy4unF67zdSVtj6CT
         tkE3yG3H8d6cGIALbG8k5K8Hb5RwasE8HY0+iZEdhOqN71IFYpamofwqrbC1LQR9yZK1
         GPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uFNSWfjEVRjxBVi/h0p6c5lkg8AafdP2KyZdJzBrb98=;
        b=fE0B2xnAymQE49W+FehL6iRgGK/L5f45hxfY4wR1S3Upr7Ac69+7KKyKrrnesRqnnF
         Zm/6m7bsOUyqui+Eon6JlS7U0bWiopa6dQWkuC4QhsfYVZvsTA/rDHZWxaSrg8bYW6oG
         LyavAguA6Tq2x2NkwZwupEDZnPAGFT10SmZLnnjzqYk77EOt0ymcEB0lSAvI9cz/L/qW
         4MqVebwvzJBW3RwWqIRqQJd9LkEni09XBH5Kr921Qd4aDQsQ/xN85sqT8wn5PQQmR6rR
         HESnWJrsAAB9PLidXO/HKrLLh7ch1Pj68zBc0uig7/gXhGngKL8qDMxX6KtqmSMvU+ub
         pHsw==
X-Gm-Message-State: AGRZ1gLTXUVgS7dpyICdmR8o/S3cmKEFI7ebuj6Vm4eRx/MOoeuuL4Mn
        HZdD6Od6VDjV4a7s0d0IuA==
X-Google-Smtp-Source: AJdET5ew6RHzpVOD2yK/zhFG9zEd3eThKJAlO3e1ciSCKXBz5kaeyqgXXq6Ua5uIz7wzAaSdSaCBXQ==
X-Received: by 2002:a1c:f008:: with SMTP id a8-v6mr17800wmb.5.1541780605237;
        Fri, 09 Nov 2018 08:23:25 -0800 (PST)
Received: from localhost (1.red-83-37-105.dynamicip.rima-tde.net. [83.37.105.1])
        by smtp.gmail.com with ESMTPSA id r76-v6sm2462842wmb.21.2018.11.09.08.23.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 08:23:24 -0800 (PST)
From:   Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     Xose Vazquez Perez <xose.vazquez@gmail.com>,
        "Luis R . Rodriguez" <mcgrof@kernel.org>,
        WIRELESS ML <linux-wireless@vger.kernel.org>,
        REGDB ML <wireless-regdb@lists.infradead.org>
Subject: [PATCH] crda: add URLs to README
Date:   Fri,  9 Nov 2018 17:23:23 +0100
Message-Id: <20181109162323.25024-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Cc: Luis R. Rodriguez <mcgrof@kernel.org>
Cc: WIRELESS ML <linux-wireless@vger.kernel.org>
Cc: REGDB ML <wireless-regdb@lists.infradead.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 README | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/README b/README
index 5d89b83..88f2623 100644
--- a/README
+++ b/README
@@ -1,5 +1,6 @@
  Central Regulatory Domain Agent (CRDA)
 ========================================
+<https://wireless.wiki.kernel.org/en/developers/regulatory/crda>
 
 This is the Central Regulatory Domain Agent for Linux. It serves one
 purpose: tell Linux kernel what to enforce. In essence it is a udev
@@ -46,6 +47,7 @@ with this package as regulatory.rules
 
  OVERVIEW
 ==========
+<https://wireless.wiki.kernel.org/en/developers/regulatory>
 
 The database is maintained on the wireless-regdb.git tree. This git
 tree maintains a binary regulatory database file which is produced
-- 
2.19.1

