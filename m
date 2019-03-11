Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C210BC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91F502075C
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="pUtXmU+k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfCKHiR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 03:38:17 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:47938 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfCKHiR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 03:38:17 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id ECAFD943
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 07:38:15 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZijoDd7tY13C for <linux-wireless@vger.kernel.org>;
        Mon, 11 Mar 2019 02:38:15 -0500 (CDT)
Received: from mail-it1-f200.google.com (mail-it1-f200.google.com [209.85.166.200])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id BC247975
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 02:38:15 -0500 (CDT)
Received: by mail-it1-f200.google.com with SMTP id i4so4353220itb.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 00:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=t2u+k+1lf2yxQwwxdGnoBM7qwW0LxgJjzCrp1mwq8jU=;
        b=pUtXmU+kvD7hKowimvcLtlRIGxficvLngQAKJIzeLOH59fvQTIuUemnVUvtS7Z3FKd
         IFxbqxioRXqukwnJooVRSIaccCtewLiHdjTzs/FkaSx1YQoDe4HSYNxaXjVnki1jR+AQ
         FYs+zN/FQVjseujvexwMJm0+wFwQEAzJdt3oVNm1bOUJ+dUMG4gd4xMnALN/m65kymFi
         pAOg4BFNTeDa4X3f72hrtoiw30cm9RhQQ0Dtlao3dhnh8BulPxhruePxERcMAMJj/itu
         P2moWWVVSHGnYmlrmfarOqf3qyrItAErVD76m5l/BDPC8fh2s8X5pR3wM+Kxnx/7KrWw
         PQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t2u+k+1lf2yxQwwxdGnoBM7qwW0LxgJjzCrp1mwq8jU=;
        b=gnj2hqirv20m7O3H+aEz0aoSl5vsDmxY41YjkwzsEGnqnf83igZPSMtBBlpKvP+QIm
         sIJv9Bcad58p8yK4ODoxa5E3FHzKa54y3vE1vYkb5LXf5PH5ZqYy8YsqXcCaq3BgcIP8
         KVsmvWzZea5VdL356YqxC0KZxyT56qutalEAJTFATW4WAtkbyS0yzx+EywcoRnbZ5yk6
         ucZ+O+7oXs9in9Qtg4umY5XHu2mivc8T/yfpjH03A8UEXcVmxU1hdb2Hr2IhbqKNNNt8
         FNE8SY6Sw3ChPW70hUXL3Nedqx/187GiW8aG0Pt9Kmqyl4c52YSxPKv3WXBQYvz9vRuZ
         JIRA==
X-Gm-Message-State: APjAAAU7aW3LVZwCRCVpJHEymXAOTQ9YTbxMCjwvFHrb6ZfaGbCzbHBa
        cmQcaWQaCqga8hZ42347/7QtnQWFy5YAxtma3VIlfiLYELCXB4ZJ2ZqEe5dAIUizyQUuDtMTcWZ
        zbrN1hBJ5e9cV2er+Vxus/KUex4yizRM=
X-Received: by 2002:a6b:f201:: with SMTP id q1mr351402ioh.197.1552289895337;
        Mon, 11 Mar 2019 00:38:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwoWZ0Oa20v+BcKj7fhpbi64/UlR5Yp89qS45DPTBEralAWQPfRB09AkPviqrtpVPkWmUL9Aw==
X-Received: by 2002:a6b:f201:: with SMTP id q1mr351392ioh.197.1552289895117;
        Mon, 11 Mar 2019 00:38:15 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id y16sm1902555ion.64.2019.03.11.00.38.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 00:38:14 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: iwlegacy: fix potential NULL pointer dereferences
Date:   Mon, 11 Mar 2019 02:37:57 -0500
Message-Id: <20190311073758.31038-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case create_singlethread_workqueue fails, the fix immediately
return to avoid NULL pointer dereferences.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 2 ++
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 271977f7fbb0..d23ee2ca0c8e 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3403,6 +3403,8 @@ static void
 il3945_setup_deferred_work(struct il_priv *il)
 {
 	il->workqueue = create_singlethread_workqueue(DRV_NAME);
+	if (!il->workqueue)
+		return;
 
 	init_waitqueue_head(&il->wait_command_queue);
 
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 94222ae464ae..2c555c9f1ff4 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -6236,6 +6236,8 @@ static void
 il4965_setup_deferred_work(struct il_priv *il)
 {
 	il->workqueue = create_singlethread_workqueue(DRV_NAME);
+	if (!il->workqueue)
+		return;
 
 	init_waitqueue_head(&il->wait_command_queue);
 
-- 
2.17.1

