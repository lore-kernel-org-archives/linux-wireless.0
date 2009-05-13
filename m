Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51815 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760912AbZEMVEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:04:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/4] cfg80211: fix in nl80211_set_reg()
Date: Wed, 13 May 2009 17:04:41 -0400
Message-Id: <1242248682-22051-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a race on access to last_request and its alpha2
through reg_is_valid_request() and us possibly processing
first another regulatory request on another CPU. We avoid
this improbably race by locking with the cfg80211_mutex as
we should have done in the first place. While at it add
the assert on locking on reg_is_valid_request().

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |    5 ++++-
 net/wireless/reg.c     |    2 ++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bb2c37a..d67f891 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2545,6 +2545,8 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
+	mutex_lock(&cfg80211_mutex);
+
 	if (!reg_is_valid_request(alpha2)) {
 		r = -EINVAL;
 		goto bad_reg;
@@ -2582,13 +2584,14 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	BUG_ON(rule_idx != num_rules);
 
-	mutex_lock(&cfg80211_mutex);
 	r = set_regdom(rd);
+
 	mutex_unlock(&cfg80211_mutex);
 
 	return r;
 
  bad_reg:
+	mutex_unlock(&cfg80211_mutex);
 	kfree(rd);
 	return r;
 }
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 537af62..041300e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -388,6 +388,8 @@ static int call_crda(const char *alpha2)
 /* Used by nl80211 before kmalloc'ing our regulatory domain */
 bool reg_is_valid_request(const char *alpha2)
 {
+	assert_cfg80211_lock();
+
 	if (!last_request)
 		return false;
 
-- 
1.6.0.6

