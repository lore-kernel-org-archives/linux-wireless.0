Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:41838 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752137AbaFZOqa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 10:46:30 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com
Date: Thu, 26 Jun 2014 17:46:16 +0300
Message-Id: <1403793976-9542-1-git-send-email-luca@coelho.fi> (sfid-20140626_164633_413374_66A74B8B)
Subject: [PATCH] mac80211: avoid warning when CONFIG_LOCKDEP is not enabled
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

After commit 5bcae31d9 (mac80211: implement multi-vif in-place
reservations) we get a warning when CONFIG_LOCKDEP is not enabled:

net/mac80211/chan.c: In function 'ieee80211_vif_get_chanctx':
net/mac80211/chan.c:69:26: warning: unused variable 'local' [-Wunused-variable]
  struct ieee80211_local *local = sdata->local;
                          ^
Fix this by removing the separate declaration for local and accessing
it directly in the lockdep_is_held() call.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/chan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c3fd4d2..0cdac4b 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -66,11 +66,10 @@ static bool ieee80211_can_create_new_chanctx(struct ieee80211_local *local)
 static struct ieee80211_chanctx *
 ieee80211_vif_get_chanctx(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *conf;
 
 	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
-					 lockdep_is_held(&local->chanctx_mtx));
+				 lockdep_is_held(&sdata->local->chanctx_mtx));
 	if (!conf)
 		return NULL;
 
-- 
2.0.0

