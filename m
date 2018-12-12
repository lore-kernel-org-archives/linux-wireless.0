Return-Path: <SRS0=wq86=OV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 050FAC67839
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 21:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC69220849
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Dec 2018 21:52:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC69220849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbeLLVwH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 16:52:07 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42653 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbeLLVwG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 16:52:06 -0500
Received: by mail-wr1-f65.google.com with SMTP id q18so19190845wrx.9
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2018 13:52:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dSFLOUbsHZRMFeHzVgb5nhnpQVbD+3Km0i2kq+NOmEI=;
        b=Em2c5GpiuHk9u8Av8Y7+qSP+60UQK+nRU/lhRH9NqLrkudWlKmqCAHuuPquLaifEO+
         uRCvWKu2VqrqOfL2LMqsBszvX2lxE8qnCJIAfHTMqbyFYCFMtQdLAGYYSZf426agQjMe
         kQ5i/Lz/1+riwntAg+a4WBJlcc8uRypr1UKLh3K7ZoJjGViJ08fw7WOkq6qxTGb1sN/D
         6MjdpmCGs54HLkCX5fE7LMv0W/vCCxuHvTV13fEsjpUo1LwB6RoczIgWVVFqlulY8aXx
         vbTYQO3I0IBYh2u9cNfN0SQtjWi/+5iquHd01xAkABKR5tmLmcWRYEg9gJ5wf8S10T7D
         Njyw==
X-Gm-Message-State: AA+aEWaqq1JZyVIRVXMIGua+WgrYLseu9x9YF2pVThdG9tP+jgfmnPTI
        +oKagDVDOs2GWopAK7hQpNlziQ==
X-Google-Smtp-Source: AFSGD/W8NvCyKe3oWIpFVN/cMISTSYPOQFLHdc8TdMnUL9AofnJEaEbnblFmmWdIKtBEnnliaQWNoQ==
X-Received: by 2002:a5d:5443:: with SMTP id w3mr17457638wrv.4.1544651525023;
        Wed, 12 Dec 2018 13:52:05 -0800 (PST)
Received: from localhost.localdomain ([151.66.36.11])
        by smtp.gmail.com with ESMTPSA id o17sm225615wmg.35.2018.12.12.13.52.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Dec 2018 13:52:04 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 1/3] mt76: dfs: run mt76x02_dfs_set_domain atomically
Date:   Wed, 12 Dec 2018 22:51:53 +0100
Message-Id: <b314693b76b509e357110cf148aa3f83410b5d00.1544568618.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1544568618.git.lorenzo.bianconi@redhat.com>
References: <cover.1544568618.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Grab mt76_dev mutex in mt76x02_dfs_set_domain since it runs
concurrently with mt76x{0,2}_set_channel routines

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
index 054609c634a2..5bd523b091b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c
@@ -881,12 +881,14 @@ mt76x02_dfs_set_domain(struct mt76x02_dev *dev,
 {
 	struct mt76x02_dfs_pattern_detector *dfs_pd = &dev->dfs_pd;
 
+	mutex_lock(&dev->mt76.mutex);
 	if (dfs_pd->region != region) {
 		tasklet_disable(&dfs_pd->dfs_tasklet);
 		dfs_pd->region = region;
 		mt76x02_dfs_init_params(dev);
 		tasklet_enable(&dfs_pd->dfs_tasklet);
 	}
+	mutex_unlock(&dev->mt76.mutex);
 }
 
 void mt76x02_regd_notifier(struct wiphy *wiphy,
-- 
2.19.2

