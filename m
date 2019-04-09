Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B6CAC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14E872084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pA1pFrjM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfDITNL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 15:13:11 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:42057 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfDITNK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 15:13:10 -0400
Received: by mail-lj1-f193.google.com with SMTP id v22so15495905lje.9
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2019 12:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W6Bi6Zd+xlYB7BEidk7J7o7FjU63HXTJmOjt8n1/y+Y=;
        b=pA1pFrjMlmq/KfbLyF/VAyaYXoH2Q5994JlraOctwdYvWkL3xYb6KB1U6RbWdPnulD
         /B9R5lREwV1h7BEMP5P8+vvIs8PVa93rIDwzHZsNBRu5wAfKGUqBYSmKYNOGLAsQR1J3
         uhRMEJEYDG6DqXqsqxo68pYGTr52yfyELS1bwGS0EYNeN8a+s4qXWGuLB5KC8QLICWdk
         esvq61U+VUADIRPcUGXlSyq8/eU5IBEBd4+bvEhdNhTTl25fguvyYgYvEbH9WLUsQ7eo
         a/EADjKFEDaz3q9V4v6dO9milFRsVt349gu52JForlIIBuzSRZP8qfkYak34C4way+cR
         N2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W6Bi6Zd+xlYB7BEidk7J7o7FjU63HXTJmOjt8n1/y+Y=;
        b=NCwF7PLAziPQuNiRPpVJ5CgEEtds2wUmG6gN2h9Q7NVUaiPDA4prrFsMHuSwrY6c4T
         6e5O+Hai+gKpEZAD86Lw+/l2ov3vK8SaqEG3nRbeZ0weLWDHkhuR7I0J/MLSY33s09Wv
         oS4AJ8b9SKPUNmRxG/0TXyGx2mXRh2yLpFqOMSmkAIGjNe9TOICo1szowVnknkEoP2F3
         3j7PmjMVKB/zzj4xdRlMk8wM+MJrOcWLFfcViVQ+IXtFtgOMHscLrkTx90IydsiO1NiV
         PEQV+j+4T12v0QJM51tEfy6xcp9TaIatkKb4qTBK3iSmSS8BGQJ0lkzRZJrbiVwQROqM
         UXkA==
X-Gm-Message-State: APjAAAVbwYgCG14GuRtUQIRwUaCu9vC/6U91xBBgEBWJlLECvRts86Vr
        6igJ/i22aC2YXJQCbLov+fM=
X-Google-Smtp-Source: APXvYqydxppC0vLz3qTRX6s6ocXeNZ3M89n4OLaqN5PDKlo1Tp4x4UhEQnDYhnI1zwO0e1Iu6MD5jw==
X-Received: by 2002:a2e:9a91:: with SMTP id p17mr20553831lji.127.1554837188123;
        Tue, 09 Apr 2019 12:13:08 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id q64sm6807848ljq.76.2019.04.09.12.13.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Apr 2019 12:13:07 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Alagu Sankar <alagusankar@silex-india.com>
Subject: [PATCH 1/6] ath10k: use clean packet headers
Date:   Tue,  9 Apr 2019 21:08:46 +0200
Message-Id: <20190409190851.4557-2-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190409190851.4557-1-erik.stromdahl@gmail.com>
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
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

PLL clock setting sequence does not mask the PLL_CONTROL
register value. Side effect of not masking the values is not known as
the entire pll clock setting sequence is undocumented.

Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 1 +
 drivers/net/wireless/ath/ath10k/hw.c  | 2 ++
 2 files changed, 3 insertions(+)

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
diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index ad082b7d7643..cfc232f1fdbc 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -814,6 +814,8 @@ static int ath10k_hw_qca6174_enable_pll_clock(struct ath10k *ar)
 	if (ret)
 		return -EINVAL;
 
+	reg_val &= ~(WLAN_PLL_CONTROL_REFDIV_MASK | WLAN_PLL_CONTROL_DIV_MASK |
+		     WLAN_PLL_CONTROL_NOPWD_MASK);
 	reg_val |= (SM(hw_clk->refdiv, WLAN_PLL_CONTROL_REFDIV) |
 		    SM(hw_clk->div, WLAN_PLL_CONTROL_DIV) |
 		    SM(1, WLAN_PLL_CONTROL_NOPWD));
-- 
2.19.1

