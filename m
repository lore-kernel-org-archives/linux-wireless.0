Return-Path: <SRS0=8fA2=BS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B29C433E0
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Aug 2020 23:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3507D206D8
	for <linux-wireless@archiver.kernel.org>; Sat,  8 Aug 2020 23:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EALBCitN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgHHXdM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 8 Aug 2020 19:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgHHXdL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Aug 2020 19:33:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD12C061756
        for <linux-wireless@vger.kernel.org>; Sat,  8 Aug 2020 16:33:11 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c10so7550972pjn.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2020 16:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MiFBfnWypR0YGSvpgtvcreCv7+Z/0yNDMPT+dO+XVAc=;
        b=EALBCitNAMQOy+Evcvz730wxfSe5B//4UNGbrEquEfBnQLt7nNdbVt1Cn9rzJN7HEt
         16ucuJb5cQKr16Dz+BpVKPOdERaWKjHMw/CFq4kw6+wajUea0Iw/i+VM/UQhTu6lNvaG
         V/4YxXmzZTuqfMNVsGGvQnwFxOb4Bug60x3eXjsP/VcSNMq3EOr5YyRz9yMwL1kpxyR4
         TQZpTOlIu3/fZ2Ku0aNhDkvUC5gqS1Hsj2Uuv1odcJcQzoheLGpEx0Mg1oXpnfXnzBwz
         gnOOPUhLxBJYnIRx1ZjF92WqJdhzlnCeLbifFRHtKwBYRqgpcn91gKK2RZkcbthDNpCU
         IPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MiFBfnWypR0YGSvpgtvcreCv7+Z/0yNDMPT+dO+XVAc=;
        b=KNOCSm7vIOa7Xo/IUELXdYDwESzZd5Iditdss/iF/f9pvbOaKLgV+0+4FS06QbyD5q
         DRPZ0YhUP0SNPab9U9Jlw67YseEHteX4W8MuwjJSkbmCbkiyY4pOvKPNOWez9AZxfIod
         +Q1mleWq1pAOXgF98YIJpv5yYoYrlGb43GP8tJzhLaZcV7OsUyisAtD0mZpz5YxxPFnX
         C86SIN1x07NVTsnFg5E1AqDb5G+02O8RH/OPdF/1DnmRLw7feHoiVkKMzd9hRsHT/k1H
         p3Ccy97pvqhgjXMAen5U5oloZLnHvCV7SIdhSV1LPVBX6GZrNLStUkHR1J3GPhKkx2zG
         kpsA==
X-Gm-Message-State: AOAM5329beBO2Fb+tp9gY+BUYkIX7J3TTXnm/1L8tiHkVwu7pdNnsXkZ
        Xt1yIJOEQp0SDHEANwtDTvo+fQn0
X-Google-Smtp-Source: ABdhPJzlOYmyIkuN/YKPRSfsxIVQocMFpz9xY3wPHmNlcaAIVWVyLDbh2lP9zcag447GnuTpRd6ztg==
X-Received: by 2002:a17:902:fe17:: with SMTP id g23mr18762152plj.30.1596929590617;
        Sat, 08 Aug 2020 16:33:10 -0700 (PDT)
Received: from gtx1060.flets-east.jp ([2409:11:53c0:1f00:c0ae:f86d:a2c9:4739])
        by smtp.gmail.com with ESMTPSA id lb1sm15059222pjb.26.2020.08.08.16.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 16:33:10 -0700 (PDT)
From:   Masashi Honma <masashi.honma@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     ath9k-devel@qca.qualcomm.com,
        Masashi Honma <masashi.honma@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] ath9k_htc: Use appropriate rs_datalen type
Date:   Sun,  9 Aug 2020 08:32:58 +0900
Message-Id: <20200808233258.4596-1-masashi.honma@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

kernel test robot says:
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:987:20: sparse: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:987:20: sparse:    expected restricted __be16 [usertype] rs_datalen
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:987:20: sparse:    got unsigned short [usertype]
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:988:13: sparse: warning: restricted __be16 degrades to integer
drivers/net/wireless/ath/ath9k/htc_drv_txrx.c:1001:13: sparse: warning: restricted __be16 degrades to integer

Indeed rs_datalen has host byte order, so modify it's own type.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: cd486e627e67 ("ath9k_htc: Discard undersized packets")
Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index b353995bdd45..f4c2a8d83f50 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -974,7 +974,7 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 	struct ath_htc_rx_status *rxstatus;
 	struct ath_rx_status rx_stats;
 	bool decrypt_error = false;
-	__be16 rs_datalen;
+	u16 rs_datalen;
 	bool is_phyerr;
 
 	if (skb->len < HTC_RX_FRAME_HEADER_SIZE) {
-- 
2.25.1

