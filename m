Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:37507 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932221AbdJYJUk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 05:20:40 -0400
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        vkanchan@qti.qualcomm.com, amarnath@qti.qualcomm.com,
        usdutt@qti.qualcomm.com, vamsin@qti.qualcomm.com,
        Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
From: Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
To: johannes@sipsolutions.net
Subject: [PATCH] cfg80211: Include length of kek in rekey data
Date: Wed, 25 Oct 2017 14:49:40 +0530
Message-Id: <1508923180-14558-1-git-send-email-vidyullatha@codeaurora.org> (sfid-20171025_112044_436873_08F3C3C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With support for new AKM suites (example FILS-SHA256), the KEK length
can now be more than NL80211_KEK_LEN and the KCK length can be zero.
Add changes in cfg80211 to specify the length of KEK, and make KCK
optional. Make NL80211_REKEY_DATA_KEK as NLA_BINARY to enforce a maximum
length check.

Signed-off-by: Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
---
 include/net/cfg80211.h |  6 ++++--
 net/wireless/nl80211.c | 19 ++++++++++++++-----
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8b8118a..b903ef7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2380,12 +2380,14 @@ struct cfg80211_wowlan_wakeup {
 
 /**
  * struct cfg80211_gtk_rekey_data - rekey data
- * @kek: key encryption key (NL80211_KEK_LEN bytes)
- * @kck: key confirmation key (NL80211_KCK_LEN bytes)
+ * @kek: key encryption key
+ * @kck: key confirmation key (NL80211_KCK_LEN bytes or %NULL if not specified)
  * @replay_ctr: replay counter (NL80211_REPLAY_CTR_LEN bytes)
+ * @kek_len: Length of @kek in octets
  */
 struct cfg80211_gtk_rekey_data {
 	const u8 *kek, *kck, *replay_ctr;
+	size_t kek_len;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d23eb57..c5d95c3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -488,7 +488,8 @@ enum nl80211_multicast_groups {
 /* policy for GTK rekey offload attributes */
 static const struct nla_policy
 nl80211_rekey_policy[NUM_NL80211_REKEY_DATA] = {
-	[NL80211_REKEY_DATA_KEK] = { .len = NL80211_KEK_LEN },
+	[NL80211_REKEY_DATA_KEK] = { .type = NLA_BINARY,
+				     .len = FILS_MAX_KEK_LEN },
 	[NL80211_REKEY_DATA_KCK] = { .len = NL80211_KCK_LEN },
 	[NL80211_REKEY_DATA_REPLAY_CTR] = { .len = NL80211_REPLAY_CTR_LEN },
 };
@@ -10978,17 +10979,25 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 		return err;
 
 	if (!tb[NL80211_REKEY_DATA_REPLAY_CTR] || !tb[NL80211_REKEY_DATA_KEK] ||
-	    !tb[NL80211_REKEY_DATA_KCK])
+	    (!wiphy_ext_feature_isset(&rdev->wiphy,
+				      NL80211_EXT_FEATURE_FILS_SK_OFFLOAD) &&
+	     !wiphy_ext_feature_isset(&rdev->wiphy,
+				      NL80211_EXT_FEATURE_FILS_STA) &&
+	     !tb[NL80211_REKEY_DATA_KCK]))
 		return -EINVAL;
 	if (nla_len(tb[NL80211_REKEY_DATA_REPLAY_CTR]) != NL80211_REPLAY_CTR_LEN)
 		return -ERANGE;
-	if (nla_len(tb[NL80211_REKEY_DATA_KEK]) != NL80211_KEK_LEN)
+	if (nla_len(tb[NL80211_REKEY_DATA_KEK]) < NL80211_KEK_LEN)
 		return -ERANGE;
-	if (nla_len(tb[NL80211_REKEY_DATA_KCK]) != NL80211_KCK_LEN)
+	if (tb[NL80211_REKEY_DATA_KCK] &&
+	    nla_len(tb[NL80211_REKEY_DATA_KCK]) != NL80211_KCK_LEN)
 		return -ERANGE;
 
+	memset(&rekey_data, 0, sizeof(rekey_data));
 	rekey_data.kek = nla_data(tb[NL80211_REKEY_DATA_KEK]);
-	rekey_data.kck = nla_data(tb[NL80211_REKEY_DATA_KCK]);
+	rekey_data.kek_len = nla_len(tb[NL80211_REKEY_DATA_KEK]);
+	if (tb[NL80211_REKEY_DATA_KCK])
+		rekey_data.kck = nla_data(tb[NL80211_REKEY_DATA_KCK]);
 	rekey_data.replay_ctr = nla_data(tb[NL80211_REKEY_DATA_REPLAY_CTR]);
 
 	wdev_lock(wdev);
-- 
1.9.1
