Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1C5C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 09:41:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 002A62086C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 09:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHw9bZFD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbfBAJlc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 04:41:32 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38887 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728565AbfBAJlb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 04:41:31 -0500
Received: by mail-pl1-f195.google.com with SMTP id e5so2932130plb.5
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 01:41:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=afYNNUIqj614GIt3cZog6W2GaWx16zdMs8O2HbR59zU=;
        b=EHw9bZFDobO1dxPOvFxkRfiEgpk6xm7DLdgfexYN4LmPeeCvGLMsj0/MpagHIGRGqD
         tx1rYvHXPZRYwJwuaofzUNMgnOOnLaDt8b4DVoySmsM514fmaTAknSg1rHw1kb8mzfb0
         FXmQy3jomojxxpNwvUBMFHJEN8wUg+wdZviBvVXqSj4GszVnrIiw/o5bLTrGvAPgiNgP
         5p48iORexDghipmxVtzICy+Hf+F5arAzP7eINBjX9ibFB0tkU8P4nnd+5ELSwpV3x0qD
         zV7xrzOAXI6PfoEhn0QT5IIDBo0JeXMAL44VD+wqa47ApbqWKGGAuAd0E6kSgafEPA3E
         DPZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=afYNNUIqj614GIt3cZog6W2GaWx16zdMs8O2HbR59zU=;
        b=lPKtDpyoSIj+GBS3SqtPUA1zjvweybyd84LwtfHeYed3Lskp0pygrl5ZnpxwVON/P/
         0THUmaWnGuzwrD8Evcf/1xLUPnXdYKMWpw9ekxw1Q0hj/J5wPMcVJsoDuD5POzWi4NlJ
         PWE4IySyT9O4yVa+HKrYC53+NoZF97P6bWYNt0W5pKYNbjO2rSLbY/h2ZDEnpSpKXXFc
         uGFiYX6FTAqlMv/QC3GkUtOACxGOZhA0zT5xxYe0tUD3dN2OzJKaBVGkrDvbxkzLoGCa
         So00Qb21NebAwvGWnBW3BWBqYIKJbGGngf+YhPmwhvngxfxt3VIVb4ERprEwb/SEMosv
         5AMg==
X-Gm-Message-State: AJcUukd7BxBLqUl1Kk4B6vCTmXHaq1lwZ0POG3VS1ZkVIR1OkNW9Q3Hh
        mvQ5nGxR1KMJCgzcV4bmiMw=
X-Google-Smtp-Source: ALg8bN64beDIlOnWBHsa8TUPgYNJdABBNxJxgOYg8g2C5bj98OLkg96UwLRpTk52DycS92ID+oAdKQ==
X-Received: by 2002:a17:902:76cb:: with SMTP id j11mr39674010plt.179.1549014090998;
        Fri, 01 Feb 2019 01:41:30 -0800 (PST)
Received: from cpu459.localdomain ([203.196.161.90])
        by smtp.gmail.com with ESMTPSA id d21sm9098618pfo.162.2019.02.01.01.41.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Feb 2019 01:41:30 -0800 (PST)
From:   Siva Rebbagondla <siva8118@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [PATCH] MAINTAINERS: add entry for redpine wireless driver
Date:   Fri,  1 Feb 2019 15:11:10 +0530
Message-Id: <1549014070-3930-1-git-send-email-siva8118@gmail.com>
X-Mailer: git-send-email 2.5.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

Create an entry for Redpine wireless driver and add Amit and myself as
maintainers.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 32d44447..c4e8fb4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16923,6 +16923,13 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
 
+REDPINE WIRELESS DRIVER
+M:	Siva Rebbagondla <siva8118@gmail.com>
+M:	Amitkumar Karwar <amitkarwar@gmail.com>
+L:	linux-wireless@vger.kernel.org
+S:	Maintained
+F:	drivers/net/wireless/rsi/
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.5.5

