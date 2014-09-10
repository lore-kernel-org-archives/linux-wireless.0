Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33056 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaIJKng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 06:43:36 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/4] mac80211: clear key material when freeing keys
Date: Wed, 10 Sep 2014 13:39:55 +0300
Message-Id: <1410345597-28565-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_124340_862870_8AD8855B)
In-Reply-To: <1410345597-28565-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410345597-28565-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When freeing the key, clear the memory to avoid having the
key material stick around in memory "forever".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f320a04..4712150 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -422,7 +422,7 @@ static void ieee80211_key_free_common(struct ieee80211_key *key)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	if (key->conf.cipher == WLAN_CIPHER_SUITE_AES_CMAC)
 		ieee80211_aes_cmac_key_free(key->u.aes_cmac.tfm);
-	kfree(key);
+	kzfree(key);
 }
 
 static void __ieee80211_key_destroy(struct ieee80211_key *key,
-- 
1.9.1

