Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50108 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753281AbdBTNYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Feb 2017 08:24:44 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Matt Chen <matt.chen@intel.com>
Subject: [PATCH 4/6] mac80211: flush delayed work when enter suspend
Date: Mon, 20 Feb 2017 14:24:37 +0100
Message-Id: <20170220132439.16064-4-johannes@sipsolutions.net> (sfid-20170220_142501_243979_1ADE575C)
In-Reply-To: <20170220132439.16064-1-johannes@sipsolutions.net>
References: <20170220132439.16064-1-johannes@sipsolutions.net>
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

type=bugfix
fixes=unknown
bug=chrome-os-partner:62283

Change-Id: Iad6b1c86c8792aae81934e7c205f44add10f062b
Signed-off-by: Matt Chen <matt.chen@intel.com>
Reviewed-on: https://git-amr-3.devtools.intel.com/gerrit/88500
Tested-by: ec ger unix iil jenkins <EC.GER.UNIX.IIL.JENKINS@INTEL.COM>
Reviewed-by: Coelho, Luciano <luciano.coelho@intel.com>
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
