Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51813 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760269AbZEMVEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 17:04:44 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/4] cfg80211: cleanup return calls on nl80211_set_reg()
Date: Wed, 13 May 2009 17:04:40 -0400
Message-Id: <1242248682-22051-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has no functional change, but it will make the race
fix easier to spot in my next patch.

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/nl80211.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 88cb4ab..bb2c37a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2545,15 +2545,19 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 			return -EINVAL;
 	}
 
-	if (!reg_is_valid_request(alpha2))
-		return -EINVAL;
+	if (!reg_is_valid_request(alpha2)) {
+		r = -EINVAL;
+		goto bad_reg;
+	}
 
 	size_of_regd = sizeof(struct ieee80211_regdomain) +
 		(num_rules * sizeof(struct ieee80211_reg_rule));
 
 	rd = kzalloc(size_of_regd, GFP_KERNEL);
-	if (!rd)
-		return -ENOMEM;
+	if (!rd) {
+		r = -ENOMEM;
+		goto bad_reg;
+	}
 
 	rd->n_reg_rules = num_rules;
 	rd->alpha2[0] = alpha2[0];
@@ -2570,8 +2574,10 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 		rule_idx++;
 
-		if (rule_idx > NL80211_MAX_SUPP_REG_RULES)
+		if (rule_idx > NL80211_MAX_SUPP_REG_RULES) {
+			r = -EINVAL;
 			goto bad_reg;
+		}
 	}
 
 	BUG_ON(rule_idx != num_rules);
@@ -2579,11 +2585,12 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	mutex_lock(&cfg80211_mutex);
 	r = set_regdom(rd);
 	mutex_unlock(&cfg80211_mutex);
+
 	return r;
 
  bad_reg:
 	kfree(rd);
-	return -EINVAL;
+	return r;
 }
 
 static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
-- 
1.6.0.6

