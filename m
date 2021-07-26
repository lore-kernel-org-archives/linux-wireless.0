Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED15C4338F
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Jul 2021 11:56:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7023960F22
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Jul 2021 11:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233640AbhGZLPn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbhGZLPm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Jul 2021 07:15:42 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E27C061757;
        Mon, 26 Jul 2021 04:56:11 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c11so11204766plg.11;
        Mon, 26 Jul 2021 04:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Br3Rygrceikh+egpBafkuMHhS17q8AtpKYbcy30kWyk=;
        b=X3yX6J3IcdR1vyvYidVE9wtrepuqM3yzkOdsiOh169BEiDq9tuM9R/Jc9o0jn4eFS+
         g/PsiKVRKOVIvfjjMn/gKPt6moMCe+e0szrD4BBUtDzZK3c7X7KRw8I0zoCDDjzYBAML
         eUUKRiFjWoyGqsYLYwcb/1hchc4O1Daq+cHNbwNzxl0bS2X4pRb1/JO0eWo4/qf6ZWtJ
         zd4nYhiSIygMaGUJNvO8b0/Soq4wtKuAz2JMLeavZxwviVa5RUnY4eMvv36vHmthCXz1
         neQhn608epsSE6LNB0AvTs3bW1+qz9WsH9jVmkx9MWEk4WkliRp+4zKQlaSHxiwV48fI
         CRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Br3Rygrceikh+egpBafkuMHhS17q8AtpKYbcy30kWyk=;
        b=i1gxKHWTZJm83uI02RDJWpIHGmG86i0jCsWRxp5K9liPihoPmVLUfn+jcJOm4LJQLi
         GLYUz17txWg4TITOWW5GLWjNRLlUwzU+la58DWdDsJk5fKRLScJ88nqkdYOQedbspnkE
         t0o6weHKaYhFJxZkGz3B4UeuLRBtzeejtr752opaN5Ia5mi9NF56z2UKfmjyZ7NkDR+o
         +Smq9e7l0sHix09An4cQOoz1/FfACYYar7bqHkfOCo5/mmMOKg0Z4y6mYiy9RA1JZe9Q
         v08KqtlmWiXbe9O1qbGUuDQ0GzsWs4Y39AEDlC1RgBBmPtTMDgdlHqlNzkRg1fKddFXD
         iePg==
X-Gm-Message-State: AOAM532yV2FacQGkufocnjaPhj2kGUYAarInMdpA4FDg9RdxKY2Jdloz
        kb6nXVTfzkREV40e8TX8XpQ=
X-Google-Smtp-Source: ABdhPJwDN5wtGtCN3P4WD8+NZSNySaC38fQiBrQXnw2ubEtNTrcgJ8YyT5qEIZc9o+TG1TONyE5Wvg==
X-Received: by 2002:a63:2bcf:: with SMTP id r198mr7687025pgr.373.1627300571013;
        Mon, 26 Jul 2021 04:56:11 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.171])
        by smtp.gmail.com with ESMTPSA id b22sm13720541pjq.37.2021.07.26.04.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:56:10 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: move the deallocation of regulatory domain to wiphy_free
Date:   Mon, 26 Jul 2021 19:55:53 +0800
Message-Id: <20210726115554.2258657-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If wiphy_register fails or does not get called, which leads to
that, ieee80211_register_hw returns with an error. Then the error
handling code of mac80211_hwsim_new_radio does not free wiphy->regd.
Note that, the free stack trace of wiphy->regd is as follows:

ieee80211_unregister_hw()
  -> wiphy_unregister()
    -> wiphy_regulatory_deregister()
      -> rcu_free_regdom()

Fix this by moving the free operation of regd from wiphy_unregister to
wiphy_free.

Reported-by: syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com
Fixes: 3e0c3ff36c4c ("cfg80211: allow multiple driver regulatory_hints()")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 net/wireless/core.c | 3 +++
 net/wireless/reg.c  | 9 +++++----
 net/wireless/reg.h  | 1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 03323121ca50..2cc2bdddc9e8 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1085,6 +1085,9 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 
 void wiphy_free(struct wiphy *wiphy)
 {
+	rcu_free_regdom(get_wiphy_regdom(wiphy));
+	RCU_INIT_POINTER(wiphy->regd, NULL);
+
 	put_device(&wiphy->dev);
 }
 EXPORT_SYMBOL(wiphy_free);
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c2d0ff7f089f..246f882e0021 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -196,12 +196,16 @@ enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy)
 	return regd->dfs_region;
 }
 
-static void rcu_free_regdom(const struct ieee80211_regdomain *r)
+/*
+ * Free the regulatory domain associated with the wiphy
+ */
+void rcu_free_regdom(const struct ieee80211_regdomain *r)
 {
 	if (!r)
 		return;
 	kfree_rcu((struct ieee80211_regdomain *)r, rcu_head);
 }
+EXPORT_SYMBOL(rcu_free_regdom);
 
 static struct regulatory_request *get_last_request(void)
 {
@@ -4064,9 +4068,6 @@ void wiphy_regulatory_deregister(struct wiphy *wiphy)
 	if (!reg_dev_ignore_cell_hint(wiphy))
 		reg_num_devs_support_basehint--;
 
-	rcu_free_regdom(get_wiphy_regdom(wiphy));
-	RCU_INIT_POINTER(wiphy->regd, NULL);
-
 	if (lr)
 		request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index f3707f729024..03de4e5ece85 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -32,6 +32,7 @@ bool reg_is_valid_request(const char *alpha2);
 bool is_world_regdom(const char *alpha2);
 bool reg_supported_dfs_region(enum nl80211_dfs_regions dfs_region);
 enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy);
+void rcu_free_regdom(const struct ieee80211_regdomain *r);
 
 int regulatory_hint_user(const char *alpha2,
 			 enum nl80211_user_reg_hint_type user_reg_hint_type);
-- 
2.25.1

