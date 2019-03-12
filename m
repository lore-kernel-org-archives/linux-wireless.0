Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C33C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66BB82087C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 19:10:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MzQHwLiP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfCLTKu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 15:10:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35810 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbfCLTKu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 15:10:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id y15so3854247wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 12:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xRksfCFcNa5dR4gm6FIaNcFmm16UamfEA8BuCwpKgM0=;
        b=MzQHwLiPVyxL6bk8S8V5sStoYPEjeu3XC8303hc+g3oRBHlvGN4eKoSWENHTexCpy5
         J+y96hnbFYkDar8FJAz8uXGVWHi2QOYumWgp7qwAO5GLQu+0tYs5Tf5UKtdk81cG2vEK
         3IBqFrEkmaqtZj99eO/yxGqr2L4ZQSuV+DYDthgKo/paE9HQMIDxUQzNGb4zjH8PH0jN
         ObbtDa2ywySWurDmtuXqeJP4uV4CzQSK2N8bOjpc77l2Cj62/8xRHCHw5NymOUiqEsjd
         dHsp4egFpVpAK6ncF89k880XNfvvfMCnF4H54VXyxeo5eQDH1OFd6GqpPHdnzSNpytJP
         7qqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xRksfCFcNa5dR4gm6FIaNcFmm16UamfEA8BuCwpKgM0=;
        b=cGV99Qof+3Ee7zEt5f3MheilEuyhBzL9yafekfMwqoaA4JyPVvCSCcgeqPKqUUEvpi
         krAAqw9MkLzXss9BeYjZU9N0v2BFtTV2Zk3bMsJjwPzlK9euaBWDdobw0pfpiTqfV88q
         UlT7+oDUPElIET/FNnzJQJn9fK5PX9NhxSOb4beTuWFiHKJIP86oJhN35omblXd01fF6
         vPqZTFXIawSDb6prsUDMdNlwh3VTp09oyf35J++Qf6SbBa53usH2STaGOncsLfASd7Z7
         qhgHDBoHF0pZ5wKUZD6SFoD8AtpIOPfC1q/s/BhHwz51ward//1LkLUAFHsyFpMLo0Qi
         0nqA==
X-Gm-Message-State: APjAAAU9pIO7op/NxRbu5dItnkAUOM6JaH91eQcy6+sFI+JDf0wglLK6
        Sh12iqkGWxqP5h8s/pllg19KqSbM
X-Google-Smtp-Source: APXvYqx1pBuRpjd9sX7aFp1xqMe8Qhikh4Yj+PJwHGDyb2outO+nBkMCBT6UNXIldOQ7CPYvyQ9brA==
X-Received: by 2002:a1c:7306:: with SMTP id d6mr3114062wmb.40.1552417848130;
        Tue, 12 Mar 2019 12:10:48 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id o8sm4918493wma.1.2019.03.12.12.10.47
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 12 Mar 2019 12:10:47 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org,
        =?UTF-8?q?Tomislav=20Po=B8ega?= <pozega.tomislav@gmail.com>
Subject: [PATCH 1/2] ath: drop duplicated include
Date:   Tue, 12 Mar 2019 20:10:42 +0100
Message-Id: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Signed-off-by: Tomislav Po¸ega <pozega.tomislav@gmail.com>
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

