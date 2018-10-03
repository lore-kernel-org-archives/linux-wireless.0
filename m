Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FREEMAIL_REPLYTO_END_DIGIT,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C55C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 05:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C764205C9
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 05:41:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fcza3/Cw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C764205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbeJCM0y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 08:26:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39541 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbeJCM0x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 08:26:53 -0400
Received: by mail-pf1-f196.google.com with SMTP id c25-v6so789989pfe.6;
        Tue, 02 Oct 2018 22:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=Xfi1R2cm3rkIbhnYY15SS5fOYwTT3sOPSczrOQ5wKy0=;
        b=Fcza3/CwMkA9os0+ZRU9M97piAKH8FLoaKOxCLGcUj+/oB6VABQfGNTNMf3chHY1QE
         45S1OWHVUR+P3D1s7Q8ZvN5eCGRYK5sVuIHy9UEg4KitBvZcxTyaarOW3IqmOlyVciv0
         4JdY8YV+oIBOG8qebyNPz/lWOf+pon/LHDRBHUmCnt7VenZwDs4GN+AhpP9eT/HMIeDM
         P6oJDOpoelDnJMbjplPOHkqhB7NxZeyreIzNDZg8qeScva2KsTHQbcg72IJ+Zl7vDwsj
         k7HArV8AV1NNxiOZH8ogBKsxzv2rGISdLXSnxKTUznXquBo1Ifw3ifVS1QFYLlCG0+5j
         hj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=Xfi1R2cm3rkIbhnYY15SS5fOYwTT3sOPSczrOQ5wKy0=;
        b=rlqfpVEQHEWOaGR3ht4qGL/aN5gXWU6rqL4NlVOCovAjcnC407G0sCdlF4B/Yu6Knf
         YiLTJY47w3JCiIH8B71DopOpAhbwz86a30tXsNdKUKJURqV4P3Yv05GFSyWAiMrnT8CX
         4ogEMUc5pPxq/btEKC4EInyHgjuaTOrpxJk0Cere5D0Jxnn3Mz9UM79BFO67Rqw3pCKc
         nTeUp41p7IDTVFkjENGmNUT9umA5HgaPpcuWBF09arLmrGYP56y8nBKPwOnQ0R2RdhvN
         Kv4A7GgL9X6Lmeh2hqpqZENd83AYh7r9hW8Mw49f4w/aYMBDuF3inIe2Q2KXCatw2R0V
         xSvA==
X-Gm-Message-State: ABuFfogIOvOgpUA9eoOu7RuK9hqwiERRav2IKvGQalQdknuWnT17PSgD
        kl9jPwmTPxXjdr+4Dl3GV9Q=
X-Google-Smtp-Source: ACcGV63PcEGCuCdfJZPAWI4tseEy9hqKsmzlO6GZZ9GU1HyJrT7KQMr4ZJbta9wUmjsv5Z1RzpQZ9w==
X-Received: by 2002:a63:b709:: with SMTP id t9-v6mr8580557pgf.366.1538545202720;
        Tue, 02 Oct 2018 22:40:02 -0700 (PDT)
Received: from E570.localdomain (c-24-21-68-121.hsd1.or.comcast.net. [24.21.68.121])
        by smtp.gmail.com with ESMTPSA id h19-v6sm711320pfk.71.2018.10.02.22.40.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Oct 2018 22:40:02 -0700 (PDT)
Received: by E570.localdomain (Postfix, from userid 1000)
        id 790A11643D0; Tue,  2 Oct 2018 22:40:01 -0700 (PDT)
From:   Lance Roy <ldr709@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Lance Roy <ldr709@gmail.com>, Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 08/16] wireless: Replace spin_is_locked() with lockdep
Date:   Tue,  2 Oct 2018 22:38:54 -0700
Message-Id: <20181003053902.6910-9-ldr709@gmail.com>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20181003053902.6910-1-ldr709@gmail.com>
References: <20181003053902.6910-1-ldr709@gmail.com>
Reply-To: Lance Roy <ldr709@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

lockdep_assert_held() is better suited to checking locking requirements,
since it won't get confused when someone else holds the lock. This is
also a step towards possibly removing spin_is_locked().

Signed-off-by: Lance Roy <ldr709@gmail.com>
Cc: Daniel Drake <dsd@gentoo.org>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
---
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
index 1f6d9f357e57..9ccd780695f0 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_mac.c
@@ -235,7 +235,7 @@ void zd_mac_clear(struct zd_mac *mac)
 {
 	flush_workqueue(zd_workqueue);
 	zd_chip_clear(&mac->chip);
-	ZD_ASSERT(!spin_is_locked(&mac->lock));
+	lockdep_assert_held(&mac->lock);
 	ZD_MEMCLEAR(mac, sizeof(struct zd_mac));
 }
 
-- 
2.19.0

