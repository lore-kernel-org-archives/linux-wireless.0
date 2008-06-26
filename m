Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12186 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbYFZJNw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 05:13:52 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/1] mac80211: fix an oops in several failure paths in key allocation
Date: Thu, 26 Jun 2008 12:13:46 +0300
Message-Id: <1214471626-4231-1-git-send-email-tomas.winkler@intel.com> (sfid-20080626_111357_102949_0F17E4DA)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch fixes an oops in several failure paths in key allocation. This
Oops occurs when freeing a key that has not been linked yet, so the
key->sdata is not set.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/key.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index d4893bd..6597c77 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -387,6 +387,15 @@ void ieee80211_key_free(struct ieee80211_key *key)
 	if (!key)
 		return;
 
+	if (!key->sdata) {
+		/* The key has not been linked yet, simply free it
+		 * and don't Oops */
+		if (key->conf.alg == ALG_CCMP)
+			ieee80211_aes_key_free(key->u.ccmp.tfm);
+		kfree(key);
+		return;
+	}
+
 	spin_lock_irqsave(&key->sdata->local->key_lock, flags);
 	__ieee80211_key_free(key);
 	spin_unlock_irqrestore(&key->sdata->local->key_lock, flags);
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

