Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A49C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D042070D
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xg47XYns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727542AbfCNOIE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:08:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41404 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727164AbfCNOIE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 10:08:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id p1so6010167wrs.8
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2019 07:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K7qDNYQhuNVtmRf9iZuFYX3oKITVG4bK/5SK8vlyYcw=;
        b=Xg47XYns4SuKqiAtvK0Nr9zsF5Pycn94F4ZyOdNrPTeeVVteIs6yfTwD1eg2DAvwjf
         dZ0cl7kKvYYoLoGwyiWfXHA4z7y7HiA7uFuS/zjSMxWhsLAhczhKzaUPFAi1+1uk5DZI
         jpB6EQS1gYkkXPU4vAcA5tKF/M2rEFZW1Nl7+lTxfimZ6ew+0OzKXUJOWUZfyDqsHA5m
         7n/qqBNezyjBhqSe5pYVJ04aFQshsLuuC9NXMk3WubtHdlXaZ+JSvZVVIfjdC/uw1rsm
         J6wFQIY6dt/Cy/vgQRsXWwb1wsDumnI/FOgHA3Tg0oWPm7M+IOnzC1jS6TL90oaeq6By
         bjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K7qDNYQhuNVtmRf9iZuFYX3oKITVG4bK/5SK8vlyYcw=;
        b=qf9TuLx6Stp/INEao7Q7+H6PZD/zJlEQ3QhvYlJc+4R/gGwFa22T/5kvHKS0SLnMSz
         +MB3W+j4h6CY6XTUbYG2JWwqWVxxZ5ciqadrgMLT8342h3oR79QC9ikVp7CxeHyHw8Wv
         BUKRxv/vdnrvxxQKkcMZAlqqZvQRWI5fwPJYJEQNN3ZUsYlUhkfhBfG92qaAVONNmGXg
         204zGFBcJ391F3AhQSXMqZfPo0yTgLW6LfzG5LVW5R6DwwfiD2FP4szzncnkeI4Hed+8
         p5tLyuv4D9OvZVMgsPjUSw/Yz7LHc++8Ao5JeXor8xwblzfd6qXtuZ8hpu4b7FV2EbG+
         iu9A==
X-Gm-Message-State: APjAAAUdD+SKTJCY/7Ed2c8F1S7Fq47bjOjJCTKeU58yIfDyy6Viy+qJ
        4zy+DeVRPuwsqCPFBQ/+zBP9FtsK
X-Google-Smtp-Source: APXvYqz8zyXdEGQZ89S4w2OS7xE4cKNV4VxRJ/BJjBFZeC7jr1nsp1XHLrz+P4Y+SI+cHWWVwH2cMQ==
X-Received: by 2002:adf:f5cf:: with SMTP id k15mr13761076wrp.218.1552572482495;
        Thu, 14 Mar 2019 07:08:02 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id i12sm23127722wrq.21.2019.03.14.07.08.01
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 14 Mar 2019 07:08:01 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org
Subject: [PATCH v2 1/2] ath: drop duplicated define
Date:   Thu, 14 Mar 2019 15:07:49 +0100
Message-Id: <1552572470-2656-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove duplicate NO_CTL that is just 2 lines below.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ath/regd.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 75ddaef..8d5a16b 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -28,7 +28,6 @@ enum ctl_group {
 	CTL_ETSI = 0x30,
 };
 
-#define NO_CTL 0xff
 #define SD_NO_CTL               0xE0
 #define NO_CTL                  0xff
 #define CTL_11A                 0
-- 
1.7.0.4

