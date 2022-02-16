Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B43FEC433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Feb 2022 03:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344049AbiBPDJD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Feb 2022 22:09:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244275AbiBPDJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Feb 2022 22:09:00 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B339A995;
        Tue, 15 Feb 2022 19:08:49 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id z1so902444qto.3;
        Tue, 15 Feb 2022 19:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOLF11S1JYYqI6U+47HSETo9eTx5Je60O4tiRPf5gE0=;
        b=F1Qs45oCqOfVCG1pK8MitXaZcjoqD/I6qi0sZUEHm1CZfNhGlgexPj5QTdHh6k/9+c
         bhDFvT3XKe9ChamSboywP4z1kmqwSZrC9jr8JYkBbk2xPmKLDFrMOljIw5TdbPCgnGbk
         7mOvOpmGzsuPW9Q71I9lFNsrS6noWeBCv9ibA5+hmDSsF40UMnTJE/n893BpBtSjOMx4
         vCwH4KWhSx0azYtR3qZXyDr+g0Yi3pLa894QT82fsFrlUatytcwaKAkV58vRyfG4sfmu
         CtXU/DXTIJa7WMwOQBZdCLlT0IfladoT4jeh4DzCW4wamMFcTghQ3kDCScmjRQGOgWIg
         wE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qOLF11S1JYYqI6U+47HSETo9eTx5Je60O4tiRPf5gE0=;
        b=kpursKgneL6lpAp+PTCZ4L6OgUnCd/+ZmT9MgHzueAJ4w3Rinq5gzve3fB8Sp153uU
         dcY+ppPmZ0NYK79LEoJutrkl79UYmHGl7wWp0MHcbaA53IBAYrU6zryFzI3hYTsEoHM7
         p+r4ZxIn8vYMi1nvLjI3ODa9zWymHyGSG9qO5W0U9SP6yz1FkiNq1095mO8PwX9m12DM
         O053S3zJFsqwEoeen1Jha/Bo7Bo7vVL9zj/ZiOgnEkO6mlkJfqvKUvoFK5xTHDA91VSP
         Dl3q51x8uqK2oSHVU4WVuull+0wPyXW8rKq7ZfQ8XTQsgBxDu5bmLatugPDbgnuDYBZF
         n2nQ==
X-Gm-Message-State: AOAM530/2i1veHrlHgS1lH6wPVUl0lLq4byrR0YdruSBar6WQ3SwumAg
        dYs9tyw2DDc9kgZlbFGSah9z7UjmB2A=
X-Google-Smtp-Source: ABdhPJzCuayH5llcDXbdAsMnv3WZRFRU1DK5ovyk41ujPwvMo8cfEYp4qQAb0nunIgHHtQzRz7KlfQ==
X-Received: by 2002:ac8:7f50:0:b0:2da:74a3:c548 with SMTP id g16-20020ac87f50000000b002da74a3c548mr733829qtk.622.1644980928790;
        Tue, 15 Feb 2022 19:08:48 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id h23sm838898qto.36.2022.02.15.19.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:08:48 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     luciano.coelho@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] iwlwifi/fw: use struct_size over open coded arithmetic
Date:   Wed, 16 Feb 2022 03:08:41 +0000
Message-Id: <20220216030841.1839666-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>

Replace zero-length array with flexible-array member and make use
of the struct_size() helper in kzalloc().

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 7ad9cee925da..b147d38033d8 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2589,7 +2589,7 @@ int iwl_fw_dbg_collect(struct iwl_fw_runtime *fwrt,
 		delay = le32_to_cpu(trigger->stop_delay) * USEC_PER_MSEC;
 	}
 
-	desc = kzalloc(sizeof(*desc) + len, GFP_ATOMIC);
+	desc = kzalloc(struct_size(desc, trig_desc.data, len), GFP_ATOMIC);
 	if (!desc)
 		return -ENOMEM;
 
-- 
2.25.1

