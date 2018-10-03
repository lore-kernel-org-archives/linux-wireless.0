Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0284C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D20520835
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 10:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D20520835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbeJCRkh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 13:40:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34799 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbeJCRkh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 13:40:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id z25-v6so7377759wmf.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 03:52:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lK8A+ScLheuUidpAFFkQWJ7iSC3gWLJJAqEZsJcbRqc=;
        b=c2WYM0VQzRtX9poPGLIFkw7dbdOLf/2x0hYVZ7V0rKhX+KOHS+e+/JV2Z/6RitAW0U
         x2hoSuyQIC6UznLT/6yR0kKBV7FvT7kdzDfBO5tvNr32deWCKwk6Rr8KkjO9g0GHhq/9
         YBdKaGM9F3LzlcmyBVh5LaIigWo/RWXQ61RaCV9Q7JnCHyf5kMSK+qKChPFX4OmOwUTa
         JVQjoGCdDGUQxBpaZxYo19+38uh581QOPFAbuaFNuA4m6FRj9ZqRdL+tCkIDS92c64fs
         kAGWCZHc1CAbXjCxO+36YF6EpIFV3fbds6FUmQH8+saIjhNdC7n7a0iIYpLi6PIHNB90
         S+7A==
X-Gm-Message-State: ABuFfojfJ7HWwTKgSTgYVrIxluNd9bV5RfUdd6rdJasa3uV65d1hMalF
        AziSks5MpvMsk2atPeDFT7gtYA==
X-Google-Smtp-Source: ACcGV62aE1GoI/sCacdGcCBqmHX6W2eLTC8nLgDS2IoDlpYFvFzfkk3FhOVlOGW/nMALXA/LdykIgg==
X-Received: by 2002:a1c:d785:: with SMTP id o127-v6mr1029343wmg.67.1538563964821;
        Wed, 03 Oct 2018 03:52:44 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id e67-v6sm1782486wmd.41.2018.10.03.03.52.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 03:52:44 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mt76: fix frag length allocation for usb
Date:   Wed,  3 Oct 2018 12:52:24 +0200
Message-Id: <e4e93439ffa75a94ae7f945100363e3417f76116.1538563675.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538563675.git.lorenzo.bianconi@redhat.com>
References: <cover.1538563675.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

This is correct fix for c12128ce44b0 ("mt76: use a per rx queue page
fragment cache"). We use wrong length when we allocate segments for
MCU transmissions, which require bigger segment size than e->buf_size.

Commit 481bb0432414 ("mt76: usb: make rx page_frag_cache access atomic")
partially solved the problem or actually mask it by changing
mt76u_mcu_init_rx() and mt76u_alloc_queues() sequence, so e->buf_size
become non zero any longer, but still not big enough to handle MCU data.

Patch fixes memory corruption which can manifest itself as random,
not easy to reproduce crashes, during mt76 driver load or unload.

Fixes: c12128ce44b0 ("mt76: use a per rx queue page fragment cache")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index de7785c4f6af..6b643ea701e3 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -286,7 +286,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		void *data;
 		int offset;
 
-		data = page_frag_alloc(&q->rx_page, q->buf_size, GFP_ATOMIC);
+		data = page_frag_alloc(&q->rx_page, len, GFP_ATOMIC);
 		if (!data)
 			break;
 
-- 
2.17.1

