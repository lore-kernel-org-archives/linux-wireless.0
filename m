Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35526 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751999AbYIZOTZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 10:19:25 -0400
Date: Fri, 26 Sep 2008 16:19:23 +0200
From: Jiri Benc <jbenc@suse.cz>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [compat-old PATCH 1/2] Fix wrong cast to ieee80211_local
Message-ID: <20080926161923.54cb0f66@griffin.suse.cz> (sfid-20080926_161929_156743_51B93676)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a kernel crash that was caused by using a wrong pointer for
ieee80211_local dereference in mq compat implementation.

Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

(The bug is described at http://wireless.kernel.org/en/users/Download/compat-wireless-old-2.6.22-bug)

 net/mac80211/mq_compat.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- cw.orig/net/mac80211/mq_compat.h
+++ cw/net/mac80211/mq_compat.h
@@ -22,7 +22,7 @@
  */
 
 #define IEEE80211_DEV_TO_LOCAL(dev) \
-	((struct ieee80211_local *)(IEEE80211_DEV_TO_SUB_IF(dev))->local)
+	((struct ieee80211_local *)(wdev_priv(dev->ieee80211_ptr)))
 
 /* This was stripped out after MQ patch for mac80211, let bring it
  * back to life */


-- 
Jiri Benc
SUSE Labs
