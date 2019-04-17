Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0627EC282DC
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7ED92073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 19:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWRLc+yF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733217AbfDQTP3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 15:15:29 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34366 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732634AbfDQTP3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 15:15:29 -0400
Received: by mail-lf1-f65.google.com with SMTP id h5so16794646lfm.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2019 12:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3PWgHfylOd7/V9eOJa0wx2I7Oy4kUSx7mENXgzd+VbU=;
        b=HWRLc+yFxQlwK+CEpkR3LXV53WlERIeIrLrw6DA1BhigJdzDhKLIZYviSHMFWtY6SP
         Q+m4Cwiz1oomdi0Fj44wYrhEj7CTdyjZ8fXYrY3LS3qOSJUvdAtJC4fCnt9mui8AImXI
         HkLdSM8uodtiPd5EYgbpwF5Jxzrmfk00BkACG0mkfmGn0fJ20Ielr9F7d8NNsCGLlg1S
         orTceo4QNfPLJsT2AlqhmuYfuHvtS2w+PLEGDcroXvR44oa9vS4L+41wSLlz7qwmgvIw
         KKFGyy7PNw+950VlcGz0c7XWzZoQHej4kU7t+uPnb3dvSeWhf2PxO5+8IzpL8RPH15Mm
         TZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3PWgHfylOd7/V9eOJa0wx2I7Oy4kUSx7mENXgzd+VbU=;
        b=UPPcwsPI+EP1qgSRjAe1PGW6anktQ3snlsGQ+zZ7pQIOs1CSuHM8tE2nJ0bKgXl0dQ
         99IFnFMzA2F3x3Zxlva0oqKBpHGcw2rXQEWLoqIqrTaTyPiKd10I5T4b8f1eAk7GYnQw
         tSFys95WrTksJnMa6rLFNdsBtga4EvZLbbieVCPCkk36H9lw0drds9yA4ClLd+aDWKyj
         PEhX5rtWalj6Li4twB4pvjV5Lg1XwulX7si+9o5ReCsskDZT03QemThQqaosm5h4oEgr
         hPX/us6VwBMRxF/8p6y2gzDYtau8ha7iDGrJUooWec4XfUWjdfzse2KU/kkft9ckvcXg
         yUbQ==
X-Gm-Message-State: APjAAAWOXhqBYA8J97PPoN9A/uIJ3qEZgkR4KM/U5BDNzuFIWx0vheXl
        OAz2Y4paZ8abVFB5Ov8jE4iP5EvX
X-Google-Smtp-Source: APXvYqxEDdzjflNKkq3brx8QJS5ylSinjqXQiW3VUQW54xKF9eDMUBpmMvxA2PGQX/+JX6kZ5JUsGA==
X-Received: by 2002:ac2:5495:: with SMTP id t21mr12020513lfk.3.1555528526847;
        Wed, 17 Apr 2019 12:15:26 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id j27sm11387203lfk.97.2019.04.17.12.15.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 12:15:26 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH v2 1/5] ath10k: add initialization of HTC header
Date:   Wed, 17 Apr 2019 21:14:59 +0200
Message-Id: <20190417191503.18814-2-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417191503.18814-1-erik.stromdahl@gmail.com>
References: <20190417191503.18814-1-erik.stromdahl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alagu Sankar <alagusankar@silex-india.com>

HTC header carries junk values that may be interpreted by the firmware
differently. Enable credit update only if flow control is enabled for
the corresponding endpoint.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 805a7f8a04f2..1d4d1a1992fe 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -73,6 +73,7 @@ static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 	struct ath10k_htc_hdr *hdr;
 
 	hdr = (struct ath10k_htc_hdr *)skb->data;
+	memset(hdr, 0, sizeof(struct ath10k_htc_hdr));
 
 	hdr->eid = ep->eid;
 	hdr->len = __cpu_to_le16(skb->len - sizeof(*hdr));
-- 
2.19.1

