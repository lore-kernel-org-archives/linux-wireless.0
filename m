Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62179 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab0LGJqw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 04:46:52 -0500
Received: by fxm20 with SMTP id 20so5139428fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 01:46:51 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] cfg80211: Make NL80211_CMD_SET_REG synchronous
Date: Tue,  7 Dec 2010 10:45:26 +0100
Message-Id: <1291715126-7652-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A user space caller of NL80211_CMD_SET_REG previously had no chance to
verify if the regulatory domain change it requested already happened.
Listening to NL80211_CMD_REG_CHANGE is not enough since it won't be
triggered when the regulatory domain didn't change (for example because
it was already the same before).

Fix this by making NL80211_CMD_SET_REG synchronous by adding a
completion struct to the regulatory_hint_user function and wait for the
completion of the regulatory request before returning.

This fixes a problem with hostapd setting the regulatory domain but
reading the channel list directly after NL80211_CMD_SET_REG returned
which resulted in an incorrect channel list and thus prohibited the use
of channels allowed within the new regulatory domain. This applies at
least to drivers not enforcing their own regulatory domain (for example
rt2x00).

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com> 
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Based on a user report in the rt2x00 forums.

Any better ideas? Any objections?

Thanks,
Helmut

 include/net/regulatory.h |    1 +
 net/wireless/nl80211.c   |    5 ++++-
 net/wireless/reg.c       |   15 +++++++++++----
 net/wireless/reg.h       |    2 +-
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 356d6e3..e58a744 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -62,6 +62,7 @@ struct regulatory_request {
 	bool intersect;
 	bool processed;
 	enum environment_cap country_ie_env;
+	struct completion *completion;
 	struct list_head list;
 };
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 56508d4..8e76a63 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2535,6 +2535,7 @@ static int parse_reg_rule(struct nlattr *tb[],
 
 static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
+	DECLARE_COMPLETION_ONSTACK(completion);
 	int r;
 	char *data = NULL;
 
@@ -2556,7 +2557,9 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
 
-	r = regulatory_hint_user(data);
+	r = regulatory_hint_user(data, &completion);
+
+	wait_for_completion_interruptible(&completion);
 
 	return r;
 }
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5ed615f..84787e3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1428,6 +1428,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	int r = 0;
 	struct wiphy *wiphy = NULL;
 	enum nl80211_reg_initiator initiator = reg_request->initiator;
+	struct completion *completion = reg_request->completion;
 
 	BUG_ON(!reg_request->alpha2);
 
@@ -1437,7 +1438,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	if (reg_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    !wiphy) {
 		kfree(reg_request);
-		return;
+		goto out;
 	}
 
 	r = __regulatory_hint(wiphy, reg_request);
@@ -1445,6 +1446,11 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	if (r == -EALREADY && wiphy &&
 	    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
 		wiphy_update_regulatory(wiphy, initiator);
+
+out:
+	/* Mark this reg request done */
+	if (completion)
+		complete_all(completion);
 }
 
 /*
@@ -1571,7 +1577,7 @@ static int regulatory_hint_core(const char *alpha2)
 }
 
 /* User hints */
-int regulatory_hint_user(const char *alpha2)
+int regulatory_hint_user(const char *alpha2, struct completion *completion)
 {
 	struct regulatory_request *request;
 
@@ -1585,6 +1591,7 @@ int regulatory_hint_user(const char *alpha2)
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
 	request->initiator = NL80211_REGDOM_SET_BY_USER;
+	request->completion = completion;
 
 	queue_regulatory_request(request);
 
@@ -1787,7 +1794,7 @@ static void restore_regulatory_settings(bool reset_user)
 	 * settings, user regulatory settings takes precedence.
 	 */
 	if (is_an_alpha2(alpha2))
-		regulatory_hint_user(user_alpha2);
+		regulatory_hint_user(user_alpha2, NULL);
 }
 
 
@@ -2149,7 +2156,7 @@ int __init regulatory_init(void)
 	 * as a user hint.
 	 */
 	if (!is_world_regdom(ieee80211_regdom))
-		regulatory_hint_user(ieee80211_regdom);
+		regulatory_hint_user(ieee80211_regdom, NULL);
 
 	return 0;
 }
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index c4695d0..8be4d42 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -6,7 +6,7 @@ extern const struct ieee80211_regdomain *cfg80211_regdomain;
 bool is_world_regdom(const char *alpha2);
 bool reg_is_valid_request(const char *alpha2);
 
-int regulatory_hint_user(const char *alpha2);
+int regulatory_hint_user(const char *alpha2, struct completion *completion);
 
 void reg_device_remove(struct wiphy *wiphy);
 
-- 
1.7.1

