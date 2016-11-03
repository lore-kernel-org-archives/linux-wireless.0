Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50187 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757237AbcKCLMu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Nov 2016 07:12:50 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, emmanuel.grumbach@intel.com
Subject: [PATCH] Revert "mac80211: allow using AP_LINK_PS with mac80211-generated TIM IE"
Date: Thu,  3 Nov 2016 12:12:47 +0100
Message-Id: <20161103111247.18086-1-nbd@nbd.name> (sfid-20161103_121300_805741_0A656BBC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit c68df2e7be0c1238ea3c281fd744a204ef3b15a0.

__sta_info_recalc_tim turns into a no-op if local->ops->set_tim is not
set. This prevents the beacon TIM bit from being set for all drivers
that do not implement this op (almost all of them), thus thoroughly
essential AP mode powersave functionality.

Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Fixes: c68df2e7be0c ("mac80211: allow using AP_LINK_PS with mac80211-generated TIM IE")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 236d47e..1711bae 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -688,7 +688,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 	}
 
 	/* No need to do anything if the driver does all */
-	if (!local->ops->set_tim)
+	if (ieee80211_hw_check(&local->hw, AP_LINK_PS))
 		return;
 
 	if (sta->dead)
-- 
2.10.1
