Return-Path: <SRS0=Edxh=DP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C415C47095
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 15:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44EA820B1F
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Oct 2020 15:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/yCldQm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731137AbgJHP65 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Oct 2020 11:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729249AbgJHP5c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Oct 2020 11:57:32 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32756C0613D5;
        Thu,  8 Oct 2020 08:57:32 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b26so4352945pff.3;
        Thu, 08 Oct 2020 08:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b5XH8VB0Qc/fJW/TLis8ZtXssZ0nTmQ5NAZeJ30/k9k=;
        b=I/yCldQmgyTcFnF/2uTiFisKzEgLO+jXPAEAFN22uwDyFMcsL8eXy6FrBhze8yHA5G
         BPfVGCs9yHXlT8RmFOI3INNLn6JRhcc3OyeQKjVIj/2Dc/+ueIg0GzDzZI6fbw8KF+bt
         A/EKqFRWgnp5PWtsh7vikCBmLgxvd8eTO16X+ef4mP1OgeRUr3K2AO8XGt1K/n6SODSw
         S2pyAfDYHZbdOEc0uWIcYyznji6FZ8/Vy61T2KM9gnOS6rLa3d68LmgxrAk6sE6rJGOo
         rzfHYEBoPvYhWlwEDKO6LCiG2WHLlUDkIzCEukyIbTNWegq2ojjnUz6zPzaxUnrfBi8x
         /Wxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b5XH8VB0Qc/fJW/TLis8ZtXssZ0nTmQ5NAZeJ30/k9k=;
        b=RjEOEtiHluTXXEFoG7fZHdyjCb2OkU+Ea+y4LVl/z1G4cOq2eF3W2cHjzNCFuHPwAm
         kzeKCXTKPxzogCrQqUIz3zPb6QZpBOVbeMnHk0uiGURavFmLaOoVr/wnyY69/BFM287I
         PuX/mU58j5sctXDo60qKBk5vJVGeUaMFOSMweLRgwYvRDPLf53s0S32mx2PeqkODIfqj
         weg8/XOQRTM2it1ggcNGUsoS8Duwe6zWVlOua2dbTT+yr8BqQ0X58kjsi2xZ++5N+lGV
         6ZSs2spvtzZmk326tEdWf7iWi00Ar/pqWAvMMz9gp11JPBX/Rw1BcpnmSvAuT5YcYh/M
         J7og==
X-Gm-Message-State: AOAM532I41JdDzMYXmRlf/lCehe64BsaqG/eavyVepNM0WJH3pM8k1vg
        UxrXB0ryXdS5JjxHTh1JF6E=
X-Google-Smtp-Source: ABdhPJx8EkzDFXVeswhPWDjNIVZU2LLE6jNldSEO99k3w/+DquRYaqMnz5ZD7p5kghXtmn/EaAl83A==
X-Received: by 2002:a17:90a:1ce:: with SMTP id 14mr8985881pjd.209.1602172651735;
        Thu, 08 Oct 2020 08:57:31 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:57:30 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 100/117] net: mt7601u: set fops_eeprom_param.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:52 +0000
Message-Id: <20201008155209.18025-100-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c869f77d6abb ("add mt7601u driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/mediatek/mt7601u/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
index 03f7235a90ab..3edf153dc68c 100644
--- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
@@ -143,6 +143,7 @@ static const struct file_operations fops_eeprom_param = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 void mt7601u_init_debugfs(struct mt7601u_dev *dev)
-- 
2.17.1

