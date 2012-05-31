Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58469 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350Ab2EaKfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 06:35:06 -0400
Received: by lahd3 with SMTP id d3so586756lah.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 03:35:04 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Clear wowlan flag when drv_suspend returns failure
Date: Thu, 31 May 2012 12:34:47 +0200
Message-Id: <1338460487-3277-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20120531_123511_303774_F6E94407)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drv_resume can get called without a prior call to drv_suspend.
Consider the following steps:

1. Suspend is started but driver's drv_suspend returns error.
2. Suspend is aborted. local->wowlan flag is left set.
3. Interface is removed.
4. Suspend again. This time open_count is 0 so drv_suspend is
   not called and local->wowlan not cleared.
5. On resume ieee80211_reconfig will call drv_resume since
   local->wowlan is set.

Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
---
 net/mac80211/pm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index af1c4e2..98c128b 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -77,6 +77,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		int err = drv_suspend(local, wowlan);
 		if (err < 0) {
 			local->quiescing = false;
+			local->wowlan = false;
 			return err;
 		} else if (err > 0) {
 			WARN_ON(err != 1);
-- 
1.7.9.5

