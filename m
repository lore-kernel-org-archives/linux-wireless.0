Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5AEC10F05
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 16:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C653206DF
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 16:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NfywIcbo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731782AbfCZQ3m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:29:42 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46492 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfCZQ3m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 12:29:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id r25so9148655lfn.13
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2019 09:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P2a+pksArilktpIno0JMNXxH8kvN+xM40RI8fuZabJc=;
        b=NfywIcboNE5CqBjVsWOmhM5pdYJQwKn1QqeHF0G2bT3+zzq3o89/ze8yh1CZDLWI5l
         KchsodG+3WNwK79kPwgOg8e/k8nvHTuAUjgDkm76a11bh6XevJPiALkwX1avM/SkNhXC
         tFq3kZjSQMHr8IABnnTu5oEbc4EVz9/BwpIu1GmJnCWJLW0RVLrRmLiMOci81PIgfrwz
         HanaMJRr2vnK7AvPvjWDu6tyfTwVHG+212rMH3oMIIfMl6q7tiGm0Zvpa6Gr6Bhkc71z
         drMUetLLKVuwlvO1znhYUy2EFLxfd6Uuufp+oXPy+r7L6CBYrbefrmF4GiuV26vizIKk
         B21g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P2a+pksArilktpIno0JMNXxH8kvN+xM40RI8fuZabJc=;
        b=LJKhxrQWLyOvTmgwFBWKzYmjqZRnU6dKUC/h4OIm7b6jBlYqsgr9eqDNUQn1Q4T5YQ
         +K00mFGpQK5FTWEJtRnvE/Bu052JofLrw5BCjaWLQ82VnzotAKzRLWl/Ragghy6cJYqm
         GHDWaU5/WlrR5roLJXniD2Im8/GcnEW5pIGcRNeZVBUT8mkdgkgNwQCpj+335OZgqRUK
         AhHwlVuuPbErKE04Gor4RahNlSfgMDkXMwkCnzPSenlQz0ElKG5oRLP+E8gZQMGeX6Nt
         SDgrEA/eCV9XmzZ39mvwYxrdy2RUunYoZv248S9ikazTeh18luB+AzNT0C0rOqJLgiJt
         q1og==
X-Gm-Message-State: APjAAAUl0LgdfW5Nl4SfZTdz4HLumncMNFYLLe6edgScfkLa8q6gDVla
        5VwG+/j6exAP+nwv+3wqXzfX+spA
X-Google-Smtp-Source: APXvYqyZYVq7va+M9fgvPGnHoNTUV0tpi6vzJ8iNU4Urt0avZqsF9sfxS0Iqam6PMxKWt0ZikyVDvw==
X-Received: by 2002:a19:c519:: with SMTP id w25mr15866268lfe.151.1553617778881;
        Tue, 26 Mar 2019 09:29:38 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id f19sm4104898lfk.69.2019.03.26.09.29.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 09:29:38 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 2/2] ath10k: add htt_h2t_aggr_cfg_msg op for high latency devices
Date:   Tue, 26 Mar 2019 17:29:04 +0100
Message-Id: <20190326162904.6737-2-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190326162904.6737-1-erik.stromdahl@gmail.com>
References: <20190326162904.6737-1-erik.stromdahl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Without this op, it will not be possible to configure aggregation for
high latency devices.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 8d533f5eb1aa..619c2b87b8bb 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -1746,6 +1746,7 @@ static const struct ath10k_htt_tx_ops htt_tx_ops_hl = {
 	.htt_send_rx_ring_cfg = ath10k_htt_send_rx_ring_cfg_hl,
 	.htt_send_frag_desc_bank_cfg = ath10k_htt_send_frag_desc_bank_cfg_32,
 	.htt_tx = ath10k_htt_tx_hl,
+	.htt_h2t_aggr_cfg_msg = ath10k_htt_h2t_aggr_cfg_msg_32,
 };
 
 void ath10k_htt_set_tx_ops(struct ath10k_htt *htt)
-- 
2.19.1

