Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07F01C64E7B
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Dec 2020 09:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8662520657
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Dec 2020 09:58:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oiq/gHe1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729029AbgLAJ5y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbgLAJ5y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Dec 2020 04:57:54 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61397C0613CF;
        Tue,  1 Dec 2020 01:57:08 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id j13so924291pjz.3;
        Tue, 01 Dec 2020 01:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=naxLmxIxKMiRhcFuT02Go1SvWGj3swfBgg3giEZB8os=;
        b=oiq/gHe1/j9+lZ+Qpe/zFr1jdnZAyjspcgdfp4rwa82cQBho5T4vH9uFESiqbT+2J8
         b1iIscyCcn0zZNiJrN0TfFfGPXgyewf3CuOz/9iuZhK8zynfcqlViJHNVXD+S51WRZuw
         rh4q65mez32lgy2xwBPBKFzBB09WDLcVDWlLuGQU2hCejGZb82dDyqPHhs/6Hlwqfi+g
         VdDnU+2woA4q6ssaLr/bcS7z06Yj3qkbW6Fh0bnP6+thFhBf8kdOJDy8NTXKPNEEIsXA
         iBAxLsCg10uORVQpUFae/BQCWNN8nDxMjVn8Xl9X5tZF/M0bNXIWOyxcfwGEDmQxCXyg
         IXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=naxLmxIxKMiRhcFuT02Go1SvWGj3swfBgg3giEZB8os=;
        b=rciLbMEl9/QnNezcmY9hlYzjXAdtQ/XeuWHaxhb/yXCuymmT0PPLqrVrgPTeX3Q2L7
         AiAu1+D4IKzBGG3J+IyAgpygdmPjUncRoQg9KPOM+61i6LPTm/Eikyx/SXJLBhVu5BRH
         lMSksMUJpv02S7JJIl73HbzOkMSpub/Wp8hUMekwGF9ULf3JCH2JVxwc2LsmM0G2t9Af
         ycQPoUR0jWtmga0Z7cGO5UQAccS2cy566lOyEOjyk2lEQ2sExujY0RKc0DaN67x40pf+
         GQYVvBV4YTRBe2U2E4mAclWf8dc0rdWyTzjOTbx1trsjleDYnUo88k2UasBesQ2o9bl4
         8wlA==
X-Gm-Message-State: AOAM533xyK6ErC5LBFHwtfYwSkZvIv/3ej9c6Y0CKGJgEXFt3oqr43eO
        Aa6oqAs29RcxcV4sH61U65Y=
X-Google-Smtp-Source: ABdhPJyBRDsw07YuiGBpqhCeKmlXB65kDJWlFTLleytuHhQXSWlHHvUZ+jfRuasd0yL2igBmrJ8ocQ==
X-Received: by 2002:a17:90a:5898:: with SMTP id j24mr1974277pji.67.1606816627841;
        Tue, 01 Dec 2020 01:57:07 -0800 (PST)
Received: from localhost.localdomain ([49.207.197.72])
        by smtp.gmail.com with ESMTPSA id m14sm2114827pgu.0.2020.12.01.01.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 01:57:07 -0800 (PST)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Subject: [PATCH] net: mac80211: cfg: enforce sanity checks for key_index in ieee80211_del_key()
Date:   Tue,  1 Dec 2020 15:26:39 +0530
Message-Id: <20201201095639.63936-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently, it is assumed that key_idx values that are passed to
ieee80211_del_key() are all valid indexes as is, and no sanity checks
are performed for it.
However, syzbot was able to trigger an array-index-out-of-bounds bug
by passing a key_idx value of 5, when the maximum permissible index
value is (NUM_DEFAULT_KEYS - 1).
Enforcing sanity checks helps in preventing this bug, or a similar
instance in the context of ieee80211_del_key() from occurring.

Reported-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Tested-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
 net/mac80211/cfg.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7276e66ae435..d349e33134e6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -516,12 +516,30 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 		if (!sta)
 			goto out_unlock;
 
-		if (pairwise)
+		if (pairwise) {
+			if (key_idx >= NUM_DEFAULT_KEYS) {
+				ret = -EINVAL;
+				goto out_unlock;
+			}
 			key = key_mtx_dereference(local, sta->ptk[key_idx]);
-		else
+		} else {
+			if (key_idx >= (NUM_DEFAULT_KEYS +
+					NUM_DEFAULT_MGMT_KEYS +
+					NUM_DEFAULT_BEACON_KEYS)) {
+				ret = -EINVAL;
+				goto out_unlock;
+			}
 			key = key_mtx_dereference(local, sta->gtk[key_idx]);
-	} else
+		}
+	} else {
+		if (key_idx >= (NUM_DEFAULT_KEYS +
+				NUM_DEFAULT_MGMT_KEYS +
+				NUM_DEFAULT_BEACON_KEYS)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
 		key = key_mtx_dereference(local, sdata->keys[key_idx]);
+	}
 
 	if (!key) {
 		ret = -ENOENT;
-- 
2.25.1

