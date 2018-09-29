Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF967C43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 22:31:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7916F20684
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 22:31:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pMS749zP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7916F20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726286AbeI3FBL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 01:01:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39767 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbeI3FBL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 01:01:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id r9-v6so3027092pgv.6
        for <linux-wireless@vger.kernel.org>; Sat, 29 Sep 2018 15:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=A9N3caMl+Ong3pap83HKSoroSQUazkfxuD2J09RQa2g=;
        b=pMS749zPnCgWXBTPqa9+sJsTZ1zaDD+uTn9Jj+wI9gYJSTrb6vOtOuicDLpW3WFl3X
         nwA6ZpAWWq9Qw01yjwYgY0X7zIaws5xFGQM7rIyeLJyLeLfoVpv0R7MeUGzb+0WVdOfB
         MDIfjGgbajq4AN97QSfOqmIA1HxurYSSsz/FiqFYctGObgxKIJF7rEcwZ4mbvXMna4F/
         FQyi+cAszRabyxeL+7BFpPWnRBg+eGCHQwoihlFltCwLzg8vOjv2NV52eqfzLBByouLv
         pyoI/wssogluPpDBQgfcV5j6fTopTtolnJBZ40MyTdwt2ZLnMUxgE/3XsMAfcPgnUF4Z
         XONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=A9N3caMl+Ong3pap83HKSoroSQUazkfxuD2J09RQa2g=;
        b=eZRs3JeS900jnoK4MwIn02R7R5H3ca1Kwmf+zAx09+lTfE4mYvdj27So4/ccQZb9Y+
         AuPHEWTDIY9rOHOPLkVRHNQj63zbm5rutGUztYOkkoNEKU98AkpbQh3j7ImhJi4oC5am
         4Ozf2lHbi+hVn0oe0oETdUw3LwCm3vHjzj42h7lZJ/D0gR1CCt4EiMtna9dd8z1tssgt
         k9Q9ZdRKqJGMXCn6fAE4lpIS7VOKb411Kp5HGPBVdNB+iOp6qeoVFljLW6G/9wPKnO5l
         t2h+7Pnin7lIzktOWhrztHeBab3sm3nlem++RQYQmojkB1E21xbeyUTciLGgtmLuWHLS
         282g==
X-Gm-Message-State: ABuFfogrhECwPbAeWKRDOoJZ59eWBGRSUqOiv5JxDX277RmlK4RBXU4c
        /LKzcPoIxs+9Eps9rzV6LXt8/buv
X-Google-Smtp-Source: ACcGV61Dh0nZaAHhHSBtjAzVWsLJ5Nir5rvBES5mD7kKhIYNVrMlTvt+MqQXlGykGAZ0RBtmxqVK/Q==
X-Received: by 2002:a17:902:6e17:: with SMTP id u23-v6mr4897590plk.28.1538260258484;
        Sat, 29 Sep 2018 15:30:58 -0700 (PDT)
Received: from corei7.flets-east.jp ([2409:11:321:2100:a0a7:3aa1:8e46:84a2])
        by smtp.gmail.com with ESMTPSA id p1-v6sm223305pfj.72.2018.09.29.15.30.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sat, 29 Sep 2018 15:30:57 -0700 (PDT)
From:   Masashi Honma <masashi.honma@gmail.com>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Masashi Honma <masashi.honma@gmail.com>
Subject: [PATCH] mac80211: Remove unused initialization
Date:   Sun, 30 Sep 2018 07:30:45 +0900
Message-Id: <1538260245-15467-1-git-send-email-masashi.honma@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The variable j will be initialized at trailing step.

Signed-off-by: Masashi Honma <masashi.honma@gmail.com>
---
 net/mac80211/rc80211_minstrel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 07fb219..fc6134c 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -632,7 +632,7 @@ minstrel_init_cck_rates(struct minstrel_priv *mp)
 	if (!sband)
 		return;
 
-	for (i = 0, j = 0; i < sband->n_bitrates; i++) {
+	for (i = 0; i < sband->n_bitrates; i++) {
 		struct ieee80211_rate *rate = &sband->bitrates[i];
 
 		if (rate->flags & IEEE80211_RATE_ERP_G)
-- 
2.7.4

