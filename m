Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B9CC65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 13:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0C75206B2
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 13:56:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N1vak8b5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0C75206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728751AbeJEUys (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 16:54:48 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46040 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbeJEUys (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 16:54:48 -0400
Received: by mail-pg1-f193.google.com with SMTP id t70-v6so4766074pgd.12;
        Fri, 05 Oct 2018 06:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZJ3IGXH0brX7jc6O3u+EPbBsEwSKUB3OqsRntJHEE74=;
        b=N1vak8b5D47HTrlkt/KJpO43Vz1Fz3JASn6Va4wGY1zIjtNPEfLgIP7wL1nPxYuP2v
         unkNOb+GWmbMMc41hTnUr+RysQw+bLCYO0zklHOznb9DarKYG+yMnkr+ZwVDnmYFj8Pu
         4UU+okgNKL3TZ79Yr3yDCqTKHECyK6r12bzSxX+hwZ53AG8t3uUFFB727tCW9XFNhC+3
         60KgQN556XshhiSVNHwd2omPafCRQLFrGznvdpZlvtnXCKwdhMxWXvxXBjY+Fmya968r
         My1ghL5MBbcmPaxAofY7rHUtH/0bkK0wkBmwpZCSEVvZ9j/HHSHJf9ijjMkBa7WpV2+D
         7D3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZJ3IGXH0brX7jc6O3u+EPbBsEwSKUB3OqsRntJHEE74=;
        b=JmNlChWZf4tq11HI8qsbAtcOpa8cJukW63BhwuSP2gZse1KDwNVB8ME85YK8Ls65+u
         Ut5KMtsa1f9alYvKtZlLCzi0C6NSv8eulZud5J7NhWQR3CCb0yJA5TeU2y2WgZ5ysQ29
         atbWvOqvcJEq0FrgBRIrLdBCWdHnPHN0BRI2tgsW4kadUU+ZTzpluj+lLmwhyOE00ITw
         ihQvovAy42QNoEhlXUZKCHHxsVHHfj3rTqDr/xz07VBex18htes8tRHZ9EsrOh66qZxo
         23Ugkp0/IQwY7I5MccTwuG24oibXgSAMDh6guqFjo8icAnlh1tzsGcaErPGZreDbLwM0
         DaHQ==
X-Gm-Message-State: ABuFfoipUQzAA+I020JUVgMukEvPvDkgSCHmSDETJXzEu8KBLzFGSLMf
        BHlO8Ia7gpTAF2QgJd9K3+A=
X-Google-Smtp-Source: ACcGV61uvxfx8GIZNUS9WXq1cgKf7kUDaTQiExB3A3EuvlhQJScRE/JNwhA2M57q5Y5RYFSrFplLeQ==
X-Received: by 2002:a62:830e:: with SMTP id h14-v6mr12329045pfe.29.1538747757146;
        Fri, 05 Oct 2018 06:55:57 -0700 (PDT)
Received: from localhost.localdomain ([2402:f000:1:4414:51be:f9f2:35c8:7b56])
        by smtp.gmail.com with ESMTPSA id r73-v6sm17988049pfk.157.2018.10.05.06.55.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Oct 2018 06:55:56 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     sgruszka@redhat.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: wireless: iwlegacy: Add a lock assertion in il4965_send_rxon_assoc()
Date:   Fri,  5 Oct 2018 21:55:46 +0800
Message-Id: <20181005135546.21011-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The variables il->staging.filter_flags, rxon1->filter_flags and 
rxon2->filter_flags need to be protected by the mutex lock il->mutex.
This patch adds a lock assertion of il->mutex to check whether 
this lock is held.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/4965.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965.c b/drivers/net/wireless/intel/iwlegacy/4965.c
index c3c638ed0ed7..ce4144a89217 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965.c
@@ -1297,6 +1297,8 @@ il4965_send_rxon_assoc(struct il_priv *il)
 	const struct il_rxon_cmd *rxon1 = &il->staging;
 	const struct il_rxon_cmd *rxon2 = &il->active;
 
+	lockdep_assert_held(&il->mutex);
+
 	if (rxon1->flags == rxon2->flags &&
 	    rxon1->filter_flags == rxon2->filter_flags &&
 	    rxon1->cck_basic_rates == rxon2->cck_basic_rates &&
-- 
2.17.0

