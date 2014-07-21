Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47228 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071AbaGUMWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 08:22:07 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Eytan Lifshitz <eytan.lifshitz@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: remove useless NULL check
Date: Mon, 21 Jul 2014 15:18:41 +0300
Message-Id: <1405945121-5360-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140721_142220_061016_08882B9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

sdata can't be NULL, don't add a superfluous check.
This check made a static analyze (klocwork) unhappy because
we would get pointer to local (sdata->local) and only then
check if sdata is non-NULL.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/key.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 16d97f0..a16d9a2 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -482,7 +482,7 @@ int ieee80211_key_link(struct ieee80211_key *key,
 	int idx, ret;
 	bool pairwise;
 
-	if (WARN_ON(!sdata || !key))
+	if (WARN_ON(!key))
 		return -EINVAL;
 
 	pairwise = key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE;
-- 
1.9.1

