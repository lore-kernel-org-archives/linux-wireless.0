Return-Path: <SRS0=ouYR=46=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FE4C1975A
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Mar 2020 03:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF484206F7
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Mar 2020 03:06:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ISqN9RT/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgCMDGK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Mar 2020 23:06:10 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33506 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgCMDGJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Mar 2020 23:06:09 -0400
Received: by mail-qk1-f193.google.com with SMTP id p62so10227297qkb.0
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2020 20:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QxUZH968NsebJI0V6t/Th5HFXTkE6PzeKq4CICK6/pA=;
        b=ISqN9RT/F9wMUXM3Hosb0Vxr2X9FKEBYIktTiPQXLBnrlUyT1/a5AmypSbyqSHoS2p
         KhdD1A03TMalKqt2PYZEkP1fmjmiXqq7+fn5gfsjvhaIy3XomEEvAOiIJyTG3sja8cNI
         ykCR5Dip7iNKkuza0fs4MVy/hSv0PJ+HfLWeKaxYnVYnHnoUZPsHhXAYlYc1i1ox543u
         yLKqabp8v1TiO/zYeT+6PjC6YiU3h7pRe1aiASztXzpfF+xXCjbYmfahgiKjSvrqir+7
         i9/Mr5H+yft4H/5bHz3ozeIPL70W2zS4GPLzd7riPcWxHEHc5i+gwJNZcKiw5MwdQmlb
         03Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=QxUZH968NsebJI0V6t/Th5HFXTkE6PzeKq4CICK6/pA=;
        b=SLCy7UDOmVIqv19UPq+qZdTjOabfHx5MLr8yKt/5R9P7xEBg9dSHLXrPrvRsvpZJXT
         iq1TqaWBhVvrl8OfaK0Tv4LeTxIIg6UObYWDtWi1j5qDWJDYM9yYpRtICPGi5idZ/7rP
         pKC8kUedzqpAu2L+aEokIj4ioTXyvFCvt71FLkYm7erN28jxpX8sBL9bYTEaC3gL8Oxt
         Z6FgRmwgVTK/RZiCP0KncQlhhW5ywu4JNqCK3d8VvnAFBX+yEkYXM9jkx7hGYGPCKKTZ
         OSWmuJrO5nNYemxaTQrL8HsQy7ANVoc+1AaVPKU0hF0HuYXQT+sZnUM7icKkkZj474wB
         Q74A==
X-Gm-Message-State: ANhLgQ0LWqDWo+VJYKdYS5nDw+Ji5qFIu1Rnb5Q9b8/84RMi1vsApcEx
        8U11pSEim1M8nuJpZuRjtHc=
X-Google-Smtp-Source: ADFU+vvkrDuUOCRl4zAgTSpvIQLn+HaNvEKbEgjR8kWnvteXSu7aH/UdAVa/mTHeXQ31qFf5j5NNyQ==
X-Received: by 2002:a05:620a:848:: with SMTP id u8mr10699672qku.495.1584068768938;
        Thu, 12 Mar 2020 20:06:08 -0700 (PDT)
Received: from yow-masselst-lx1.corp.ad.wrs.com (198-84-181-245.cpe.teksavvy.com. [198.84.181.245])
        by smtp.gmail.com with ESMTPSA id f71sm8328205qke.57.2020.03.12.20.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 20:06:08 -0700 (PDT)
From:   Mark Asselstine <mark.asselstine@windriver.com>
To:     johannes.berg@intel.com, linux-wireless@vger.kernel.org
Cc:     Mark Asselstine <asselsm@gmail.com>
Subject: [PATCH] iwlwifi: set 'free_queue' to the loop variable, not a meaningless bool
Date:   Thu, 12 Mar 2020 23:05:45 -0400
Message-Id: <20200313030545.9184-1-mark.asselstine@windriver.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mark Asselstine <asselsm@gmail.com>

The loop variable 'i' is passed to iwl_mvm_remove_inactive_tids() as
the queue number to operate on. iwl_mvm_remove_inactive_tids()
operates on that queue number then returns true if the queue can be
reused, the returned bool is stored in 'ret'. We do not want to set
'free_queue' to the returned bool stored in 'ret' but rather the loop
variable, so we are actually operating on the right queue through the
rest of iwl_mvm_inactivity_check() and have it return a proper queue
number.

Signed-off-by: Mark Asselstine <asselsm@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 9db2555518aa..2fcaf779649a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1166,7 +1166,7 @@ static int iwl_mvm_inactivity_check(struct iwl_mvm *mvm, u8 alloc_for_sta)
 						   &changetid_queues);
 		if (ret >= 0 && free_queue < 0) {
 			queue_owner = sta;
-			free_queue = ret;
+			free_queue = i;
 		}
 		/* only unlock sta lock - we still need the queue info lock */
 		spin_unlock_bh(&mvmsta->lock);
-- 
2.20.1

