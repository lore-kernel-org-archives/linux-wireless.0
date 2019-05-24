Return-Path: <SRS0=H164=TY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E603C282E1
	for <linux-wireless@archiver.kernel.org>; Fri, 24 May 2019 21:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27D5D21848
	for <linux-wireless@archiver.kernel.org>; Fri, 24 May 2019 21:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPKd2Ovy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404250AbfEXVdM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 May 2019 17:33:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53613 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391745AbfEXVdM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 May 2019 17:33:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id 198so10698284wme.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 May 2019 14:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xFni9jtRRxUdDmA43yqyYLPLzOMVbPJFUYV2ZNviRZU=;
        b=JPKd2OvyYiPKIe1EP5/4psKek2cFxS4SjLNRtJO4vT1BoMcUheBPcf3oWgdvdpgCu3
         eAnNlzHYSGsIHRbkkoe9OuQFVNZLjKpoDjD4ugTA/2pnII5VL5Fz6h1NLH7MLUR71nXY
         /cuaoiGZ+WLuQ72RbIkhVjGqkVgppnx7ITW5/kHHyO/5IHo34mmYNIOZp8AIr+LFd97h
         IF+0Fiyb0AOyZhEV/132L1yLUCfQOGU7o8tXDVE4qrhuMWS4ePSK28Jet9naGXAL8d74
         r0b2FEn+kZkQSYcro66MsWxrk0F/jJAy8N4wPXt/APl338HT9M7XT66r39BaIdz8pYzR
         YAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xFni9jtRRxUdDmA43yqyYLPLzOMVbPJFUYV2ZNviRZU=;
        b=H2DwrklSrrLCJA7lJ//TN+roIJ14W13wWYnJpTtAj7MsFhzKTRUx013T+1veeYwpsd
         Nvou6KmNj05KEfTy0CdRdNHcVV/Fy31No8oFSdabM8K6+LMxnjvgtOVNPEMBtYAdRFw6
         sJXV5G9ib2+gEgWnJHYFYT9RxFyTrgsjY7dLCDppiBFodi6fdoO3bZTfZReAPhhSlmv8
         hanBkANP/XnE78A+YMQaBqzXbrdyu8R1p0UutiPAI3bOB1Cb1TUB142hLuBPs5ryLxId
         VAL4GF5CiNLQINWnkfuLyYgiv867CfYtJUPhV5wJFnPzovZdetsJhgsaE+pbVPsRIO/A
         MGNg==
X-Gm-Message-State: APjAAAWnzCXmZO02BoQR2YX7YR/06EB/VI71rJBxUNppWzfZwWMqBoyQ
        2eC2W4D8sVtZ5fS2NQJzs8HKDQni
X-Google-Smtp-Source: APXvYqxoXB5MRns7ZIeS670XOiVB5Yp4SoMl8mRpqW5urMQWbe4CmO1ptUSsX01MqqcJpiSbjjR64A==
X-Received: by 2002:a1c:96c9:: with SMTP id y192mr17072667wmd.75.1558733589552;
        Fri, 24 May 2019 14:33:09 -0700 (PDT)
Received: from debian64.daheim (p4FD09F8E.dip0.t-ipconnect.de. [79.208.159.142])
        by smtp.gmail.com with ESMTPSA id j206sm6247678wma.47.2019.05.24.14.33.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 24 May 2019 14:33:09 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hUHoK-0004qL-CA; Fri, 24 May 2019 23:33:08 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] p54: Support boottime in scan results
Date:   Fri, 24 May 2019 23:33:08 +0200
Message-Id: <20190524213308.18575-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch fixes an issue with wpa_supplicant dropping all scan
results because their where considered to be "too old" (e.g.:
"skip - scan result not recent enough (121056.086325 seconds too old)")
which is very weird because this looks like that the scan results have
been received before a scan started. This is due to the inaccuracy of
the default timing mechanism for calculating the BSS entry age.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/wireless/intersil/p54/txrx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
index 5bf1c19ecced..f80c5056ccb7 100644
--- a/drivers/net/wireless/intersil/p54/txrx.c
+++ b/drivers/net/wireless/intersil/p54/txrx.c
@@ -334,6 +334,7 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 	u16 freq = le16_to_cpu(hdr->freq);
 	size_t header_len = sizeof(*hdr);
 	u32 tsf32;
+	__le16 fc;
 	u8 rate = hdr->rate & 0xf;
 
 	/*
@@ -382,6 +383,11 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 
 	skb_pull(skb, header_len);
 	skb_trim(skb, le16_to_cpu(hdr->len));
+
+	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
+	if (ieee80211_is_probe_resp(fc) || ieee80211_is_beacon(fc))
+		rx_status->boottime_ns = ktime_get_boot_ns();
+
 	if (unlikely(priv->hw->conf.flags & IEEE80211_CONF_PS))
 		p54_pspoll_workaround(priv, skb);
 
-- 
2.20.1

