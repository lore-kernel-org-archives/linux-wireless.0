Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61993 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3KERRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 12:17:19 -0500
Received: by mail-bk0-f47.google.com with SMTP id d7so2873646bkh.34
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 09:17:18 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 03/19] cfg80211: check regulatory request alpha2 early
Date: Tue,  5 Nov 2013 09:18:01 -0800
Message-Id: <1383671897-7746-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131105_181722_193680_316D3C5A)
In-Reply-To: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383671897-7746-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently nl80211 allows userspace to send the kernel
a bogus regulatory domain with at most 32 rules set
and it won't reject it until after its allocated
memory. Let's be smart about it and take advantage
that the last_request is now available under RCU
and check if the alpha2 matches an expected request
and reject any bogus userspace requests prior to
hitting the memory allocator.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 net/wireless/nl80211.c | 3 +++
 net/wireless/reg.c     | 2 +-
 net/wireless/reg.h     | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cc5d106..476d32c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5053,6 +5053,9 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	if (!reg_is_valid_request(alpha2))
+		return -EINVAL;
+
 	size_of_regd = sizeof(struct ieee80211_regdomain) +
 		       num_rules * sizeof(struct ieee80211_reg_rule);
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6183c90..ff595d1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -450,7 +450,7 @@ static int call_crda(const char *alpha2)
 	return kobject_uevent(&reg_pdev->dev.kobj, KOBJ_CHANGE);
 }
 
-static bool reg_is_valid_request(const char *alpha2)
+bool reg_is_valid_request(const char *alpha2)
 {
 	struct regulatory_request *lr = get_last_request();
 
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index 9677e3c..b4076ba 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -18,6 +18,7 @@
 
 extern const struct ieee80211_regdomain __rcu *cfg80211_regdomain;
 
+bool reg_is_valid_request(const char *alpha2);
 bool is_world_regdom(const char *alpha2);
 bool reg_supported_dfs_region(u8 dfs_region);
 
-- 
1.8.4.rc3

