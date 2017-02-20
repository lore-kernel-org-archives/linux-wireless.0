Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50120 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753292AbdBTNYv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 08:24:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Matt Chen <matt.chen@intel.com>
Subject: [PATCH 1/2] mac80211: flush delayed work when entering suspend
Date: Mon, 20 Feb 2017 14:24:47 +0100
Message-Id: <20170220132448.16140-1-johannes@sipsolutions.net> (sfid-20170220_142501_576592_BEB74E55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matt Chen <matt.chen@intel.com>

The issue was found when entering suspend and resume.
It triggers a warning in:
mac80211/key.c: ieee80211_enable_keys()
...
WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt ||
             sdata->crypto_tx_tailroom_pending_dec);
...

It points out sdata->crypto_tx_tailroom_pending_dec isn't cleaned up successfully
in a delayed_work during suspend. Add a flush_delayed_work to fix it.

Cc: stable@vger.kernel.org
Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 28a3a0957c9e..76a8bcd8ef11 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -168,6 +168,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			break;
 		}
 
+		flush_delayed_work(&sdata->dec_tailroom_needed_wk);
 		drv_remove_interface(local, sdata);
 	}
 
-- 
2.9.3
