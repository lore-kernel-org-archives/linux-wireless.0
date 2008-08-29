Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39175 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289AbYH2RSH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 13:18:07 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] cfg80211.h: add support for letting the user set the regulatory domain
Date: Fri, 29 Aug 2008 10:17:58 -0700
Message-ID: <1220030278-6088-5-git-send-email-lrodriguez@atheros.com> (sfid-20080829_191813_104237_2FBB739C)
In-Reply-To: <1220030278-6088-4-git-send-email-lrodriguez@atheros.com>
References: <1220030278-6088-1-git-send-email-lrodriguez@atheros.com>
 <1220030278-6088-2-git-send-email-lrodriguez@atheros.com>
 <1220030278-6088-3-git-send-email-lrodriguez@atheros.com>
 <1220030278-6088-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support to let the user set the current regulatory domain.
This allows users to help the wireless core be more compliant in case
their wireless cards are shipped with incorrect EEPROM regulatory
settings. Driver's supported bands and frequencies are always respected,
this just allows more channels to be disabled.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/nl80211.h |   10 ++++++++--
 include/net/cfg80211.h  |    3 +++
 net/wireless/nl80211.c  |   18 ++++++++++++++++++
 net/wireless/reg.c      |   27 ++++++++++++++-------------
 4 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 825fcc6..ff568fa 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -100,6 +100,9 @@
  * 	%NL80211_ATTR_FREQ_RANGE_MAX_BW with an attached power rule given by
  * 	%NL80211_ATTR_REG_RULE_POWER_MAX_ANT_GAIN and
  * 	%NL80211_ATTR_REG_RULE_POWER_MAX_EIRP.
+ * @NL80211_CMD_ASK_SET_REG: ask the wireless core to set the regulatory domain
+ * 	to the the specified ISO/IEC 3166-1 alpha2 country code. The core will
+ * 	store this as a valid request and then query userspace for it.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -138,9 +141,10 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_MPATH,
 	NL80211_CMD_DEL_MPATH,
 
-	/* add commands here */
-
 	NL80211_CMD_SET_REG,
+	NL80211_CMD_ASK_SET_REG,
+
+	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
 	__NL80211_CMD_AFTER_LAST,
@@ -211,6 +215,8 @@ enum nl80211_commands {
  * 	also be used by userspace to query the kernel for the currently set
  * 	regulatory domain. We chose an alpha2 as that is also used by the
  * 	IEEE-802.11d country information element to identify a country.
+ * 	Users can also simply ask the wireless core to set regulatory domain
+ * 	to a specific alpha2.
  * @NL80211_ATTR_REG_RULES: a nested array of regulatory domain regulatory
  *	rules.
  *
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8f6e3be..bceb88f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -273,6 +273,8 @@ struct mpath_info {
  * @REGDOM_SET_BY_INIT: regulatory domain was set by initialization. We will be
  * 	using a static world regulatory domain by default.
  * @REGDOM_SET_BY_CORE: Core queried CRDA for a dynamic world regulatory domain.
+ * @REGDOM_SET_BY_USER: User asked the wireless core to set the
+ * 	regulatory domain.
  * @REGDOM_SET_BY_DRIVER: a wireless drivers has hinted to the wireless core
  *	it thinks its knows the regulatory domain we should be in.
  * @REGDOM_SET_BY_80211D: the wireless core has received an 802.11 country
@@ -282,6 +284,7 @@ struct mpath_info {
 enum reg_set_by {
 	REGDOM_SET_BY_INIT,
 	REGDOM_SET_BY_CORE,
+	REGDOM_SET_BY_USER,
 	REGDOM_SET_BY_DRIVER,
 	REGDOM_SET_BY_80211D,
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0d29364..b6f81f2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1575,6 +1575,18 @@ static int parse_reg_rule(struct nlattr *tb[],
 	return 0;
 }
 
+static int nl80211_ask_set_reg(struct sk_buff *skb, struct genl_info *info)
+{
+	char *data = NULL;
+
+	if (!info->attrs[NL80211_ATTR_REG_ALPHA2])
+		return -EINVAL;
+
+	data = nla_data(info->attrs[NL80211_ATTR_REG_ALPHA2]);
+
+	return __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, NULL);
+}
+
 static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[NL80211_REG_RULE_ATTR_MAX + 1];
@@ -1778,6 +1790,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_ASK_SET_REG,
+		.doit = nl80211_ask_set_reg,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 17d0e8f..5ed7290 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -212,6 +212,18 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		if (last_request->initiator == REGDOM_SET_BY_80211D)
 			return 0;
 		return 0;
+	case REGDOM_SET_BY_USER:
+		if (last_request->initiator == set_by ||
+				last_request->initiator == REGDOM_SET_BY_CORE)
+			return 0;
+		/* Drivers can use their wiphy's reg_notifier()
+		 * to override any information */
+		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
+			return 0;
+		/* XXX: Handle intersection */
+		if (last_request->initiator == REGDOM_SET_BY_80211D)
+			return -EOPNOTSUPP;
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -242,6 +254,7 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 	case REGDOM_SET_BY_CORE:
 	case REGDOM_SET_BY_80211D:
 	case REGDOM_SET_BY_DRIVER:
+	case REGDOM_SET_BY_USER:
 		request = kzalloc(sizeof(struct regulatory_request),
 			GFP_KERNEL);
 		if (!request)
@@ -299,11 +312,6 @@ static int __reg_is_valid_request(char *alpha2,
 			*request = req;
 			return 1;
 		}
-		/* XXX: remove this else clause once we support handling
-		 * multiple requests, this is currenlty only respecting the
-		 * first request */
-		else
-			return 0;
 	}
 	return 0;
 }
@@ -546,14 +554,6 @@ int set_regdom(struct ieee80211_regdomain *rd)
 		goto unlock_and_exit;
 	}
 
-	/* _For_now_ we only respect the first request */
-	if (!list_is_singular(&regulatory_requests)) {
-		printk(KERN_ERR "cfg80211: multiple requests to "
-			"change regulatory domain are in our queue, "
-			"for now we'll only respect the first request");
-		goto unlock_and_exit;
-	}
-
 	/* Now lets set the regulatory domain, update all driver channels
 	 * and finally inform them of what we have done, in case they want
 	 * to review or adjust their own settings based on their own
@@ -570,6 +570,7 @@ int set_regdom(struct ieee80211_regdomain *rd)
 	switch (request->initiator) {
 	case REGDOM_SET_BY_CORE:
 	case REGDOM_SET_BY_DRIVER:
+	case REGDOM_SET_BY_USER:
 		break;
 	case REGDOM_SET_BY_80211D:
 	default:
-- 
1.5.6.4

