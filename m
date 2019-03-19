Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651DEC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 16:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C2C12077B
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 16:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NfmZbSOY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfCSQYS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 12:24:18 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41987 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727914AbfCSQYP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 12:24:15 -0400
Received: by mail-pg1-f195.google.com with SMTP id p6so1371298pgh.9;
        Tue, 19 Mar 2019 09:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nriVN6CznBWnvaz1cniK33cl59dItJ09H9B96QgY3HE=;
        b=NfmZbSOY4jmzet2MQdvs9yXkhWN07iLrvtK3IKNjVHdUFHLNTQUBRCKXgGfI0Lyhh8
         lmnaURKctCpM/Y5eBLdclkxPUHVuz7pmRivFuRv3b3Z65Xi1ld4S4573U9sY5OwAt/h5
         0qbhtApyk1oOLIYpxeOL/wLuXm4A/hOsnqjxSW8IDx8vu1UZKTtLSjOi5JuKmZ9kPJms
         kyvHtTDzTZUb8NSIb9Ty+nPvLeR4FpQyGgQf9ga3YbWB7VCSLbukjWp+kA7taBFSl88l
         eLVYPyOWVIg6HZ668HAChT9JElcwTf+1qLfOZaUJhcBU5RDue+sfZC5YYtviTt2I0Tod
         a53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nriVN6CznBWnvaz1cniK33cl59dItJ09H9B96QgY3HE=;
        b=pEoYZfnbnVwlV2SALFWBWUzoLlqoa3n4AeQ5WwOHYLbicp1j9WiOLaRSBHmoWp2wu/
         5bvDwl+vEkGM/e0FN+NNAGOQvA2mqq4TuPMgBHMlFmpUACx5whl52L1DeBbb3nRI69HB
         uipeJF8CJmNyHAifURJh+CAKtpQVDQS13GaEesSuDvWWtpGwVqQDqz/TTYBr46IJyveA
         C64h8dKvpZUPAJRSgdNw6wq6Osuw0jIZ0Naf85TulXVfnYZ27MAldAxqNTOiedj2FkkE
         dP92PX8wjEP++JyiaR2MgjmWc1rcvTrCPiYi8VbwmVquoQrnz4YjP89lcRRunS7Kh0za
         hcQg==
X-Gm-Message-State: APjAAAWX0oQRBnK7am9UhmSLeJeMPCKX5YtUCNoMX1VToH0OXE+lFzYv
        JRzdG3Wo+AAMgpQUBva/+hM=
X-Google-Smtp-Source: APXvYqyvtLCFs69v5GTy8No+vMEiIx/2wbmjJ2Qvl8xCS/DPTG9nCSjZZqpHwvjfUAImpdxhcxvFxA==
X-Received: by 2002:a63:4718:: with SMTP id u24mr23764938pga.381.1553012654464;
        Tue, 19 Mar 2019 09:24:14 -0700 (PDT)
Received: from localhost.localdomain ([47.91.249.165])
        by smtp.gmail.com with ESMTPSA id h23sm17626689pfn.68.2019.03.19.09.24.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Mar 2019 09:24:13 -0700 (PDT)
From:   Jeff Xie <chongguiguzi@gmail.com>
To:     buytenh@wantstofly.org, kvalo@codeaurora.org
Cc:     davem@davemloft.net, chongguiguzi@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net:mwl8k:move spin_lock_bh to spin_lock in tasklet
Date:   Wed, 20 Mar 2019 00:24:05 +0800
Message-Id: <1553012645-28989-1-git-send-email-chongguiguzi@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It is unnecessary to call spin_lock_bh in a tasklet.

Signed-off-by: Jeff Xie <chongguiguzi@gmail.com>
---
 drivers/net/wireless/marvell/mwl8k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 8e4e9b6..21a86cc 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -4631,7 +4631,7 @@ static void mwl8k_tx_poll(unsigned long data)
 
 	limit = 32;
 
-	spin_lock_bh(&priv->tx_lock);
+	spin_lock(&priv->tx_lock);
 
 	for (i = 0; i < mwl8k_tx_queues(priv); i++)
 		limit -= mwl8k_txq_reclaim(hw, i, limit, 0);
@@ -4641,7 +4641,7 @@ static void mwl8k_tx_poll(unsigned long data)
 		priv->tx_wait = NULL;
 	}
 
-	spin_unlock_bh(&priv->tx_lock);
+	spin_unlock(&priv->tx_lock);
 
 	if (limit) {
 		writel(~MWL8K_A2H_INT_TX_DONE,
-- 
2.7.4

