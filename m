Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E987FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 14:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B884E2133D
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 14:31:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhZYE8vc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfCSObW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 10:31:22 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35207 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfCSObV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 10:31:21 -0400
Received: by mail-pg1-f193.google.com with SMTP id g8so3322971pgf.2;
        Tue, 19 Mar 2019 07:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pXyy2XHMRXdAboB3MaHiFHNZNQs1N3M7YhVrRSI+uBE=;
        b=fhZYE8vcjy3XP2SayoF6sCH4JnUBNKUpDRCrLWplNMd7V8Ptjp6TtEWEZ/iAngJ0f8
         VTjdorw0ojy5q9Vw3AJ9ApdBTyu3nFjR5WkXgYvx4MDWMqYmNc5Wqn3Tksp4USxpYHOi
         FrMGR8vZLI3foBSTblKuK5FIeuXn6cvZMQWXnaFgQUuc/RaSMZunrg2PrnLxFk1aHUsu
         /xgpPWVrXA83GUH6Iq1zA5Ax0LUt4s0nEqzn2CZPrQTQVv9Qe5N5a4OAhy39sM6GWMRl
         bqeaQEdyhFsu1L9VLLlILVanCRcGPhWdXShLYpWZXcssao0H2lKHRfAIuWOCNk9II5IR
         67Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pXyy2XHMRXdAboB3MaHiFHNZNQs1N3M7YhVrRSI+uBE=;
        b=a/aLaM/xnkIVH4tffuXIZ0NgtaDS35rWbfnMkWPSbho3GFOAtLOqypnl0GDSzJxf74
         72rz/9b+AliH+F6G+o44x6gd53UkjoSOPm0e/ahL9qtxmPrS/SnPXvcIliQ3aSHN9JUY
         5YB/dar7n2Qp6IxdHL1U9hM4x2EkfRVHtgUhoW1t4O0ZrTyeSi3wQYl3CWuzU0PaigXD
         F7/g6Nv8p58kOB5yAd5GGnVnmlUvBk68pWN5HztNkzEQLJqfjxkFrxXTauKuukvpexVC
         GngJKcod6hvZ9w9mCQl0no3Ak5wVFkFDzaKd1u3ykOz2OHIh/F2NlLqnAYTc4NdJ2GTa
         0RrQ==
X-Gm-Message-State: APjAAAUpUDxyv9qvGZCiA56oJtPjJZJlhr4ZGoCuvU/+sb7e/frDY6hj
        HaWcLLzAJqWt36ccSIk3YHc=
X-Google-Smtp-Source: APXvYqwGjxWurLHDOcF2Rda1fE6VmYzruBeTGkW6QsyKNaJJbKF0lo8D2R8gQVR03qUGi0hy/u7NHg==
X-Received: by 2002:a65:4385:: with SMTP id m5mr2067440pgp.406.1553005880760;
        Tue, 19 Mar 2019 07:31:20 -0700 (PDT)
Received: from localhost.localdomain ([47.91.249.165])
        by smtp.gmail.com with ESMTPSA id f10sm15839243pgo.55.2019.03.19.07.31.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Mar 2019 07:31:20 -0700 (PDT)
From:   Jeff Xie <chongguiguzi@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chongguiguzi@gmail.com
Subject: [PATCH] net:rtlwifi:move spin_lock_bh to spin_lock in tasklet
Date:   Tue, 19 Mar 2019 22:31:10 +0800
Message-Id: <1553005870-28018-1-git-send-email-chongguiguzi@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It is unnecessary to call spin_lock_bh in a tasklet.

Signed-off-by: Jeff Xie <chongguiguzi@gmail.com>

---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 48ca521..4055e0a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -499,16 +499,16 @@ static void _rtl_pci_tx_chk_waitq(struct ieee80211_hw *hw)
 
 			memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 
-			spin_lock_bh(&rtlpriv->locks.waitq_lock);
+			spin_lock(&rtlpriv->locks.waitq_lock);
 			if (!skb_queue_empty(&mac->skb_waitq[tid]) &&
 			    (ring->entries - skb_queue_len(&ring->queue) >
 			     rtlhal->max_earlymode_num)) {
 				skb = skb_dequeue(&mac->skb_waitq[tid]);
 			} else {
-				spin_unlock_bh(&rtlpriv->locks.waitq_lock);
+				spin_unlock(&rtlpriv->locks.waitq_lock);
 				break;
 			}
-			spin_unlock_bh(&rtlpriv->locks.waitq_lock);
+			spin_unlock(&rtlpriv->locks.waitq_lock);
 
 			/* Some macaddr can't do early mode. like
 			 * multicast/broadcast/no_qos data
-- 
2.7.4

