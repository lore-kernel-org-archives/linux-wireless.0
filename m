Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51059 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbaIJTbs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 15:31:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211: don't put kek/kck/replay counter on the stack
Date: Wed, 10 Sep 2014 22:28:06 +0300
Message-Id: <1410377286-20914-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_213154_747933_DF62A538)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to put the values on the stack, just pass a
pointer to the data in the nl80211 message. This reduces stack
usage and avoids potential issues with putting sensitive data
on the stack.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/cfg80211.h | 10 ++++------
 net/wireless/nl80211.c | 10 +++-------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 825ffd0..fd24cac 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1980,14 +1980,12 @@ struct cfg80211_wowlan_wakeup {
 
 /**
  * struct cfg80211_gtk_rekey_data - rekey data
- * @kek: key encryption key
- * @kck: key confirmation key
- * @replay_ctr: replay counter
+ * @kek: key encryption key (NL80211_KEK_LEN bytes)
+ * @kck: key confirmation key (NL80211_KCK_LEN bytes)
+ * @replay_ctr: replay counter (NL80211_REPLAY_CTR_LEN bytes)
  */
 struct cfg80211_gtk_rekey_data {
-	u8 kek[NL80211_KEK_LEN];
-	u8 kck[NL80211_KCK_LEN];
-	u8 replay_ctr[NL80211_REPLAY_CTR_LEN];
+	const u8 *kek, *kck, *replay_ctr;
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 75e81be..5c6e54b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8959,13 +8959,9 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 	if (nla_len(tb[NL80211_REKEY_DATA_KCK]) != NL80211_KCK_LEN)
 		return -ERANGE;
 
-	memcpy(rekey_data.kek, nla_data(tb[NL80211_REKEY_DATA_KEK]),
-	       NL80211_KEK_LEN);
-	memcpy(rekey_data.kck, nla_data(tb[NL80211_REKEY_DATA_KCK]),
-	       NL80211_KCK_LEN);
-	memcpy(rekey_data.replay_ctr,
-	       nla_data(tb[NL80211_REKEY_DATA_REPLAY_CTR]),
-	       NL80211_REPLAY_CTR_LEN);
+	rekey_data.kek = nla_data(tb[NL80211_REKEY_DATA_KEK]);
+	rekey_data.kck = nla_data(tb[NL80211_REKEY_DATA_KCK]);
+	rekey_data.replay_ctr = nla_data(tb[NL80211_REKEY_DATA_REPLAY_CTR]);
 
 	wdev_lock(wdev);
 	if (!wdev->current_bss) {
-- 
1.9.1

