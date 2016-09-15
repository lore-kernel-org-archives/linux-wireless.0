Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54512 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751111AbcIONaS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 09:30:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 16:30:02 +0300
Message-Id: <20160915133003.24214-1-luca@coelho.fi> (sfid-20160915_153038_625391_BE75357D)
Subject: [PATCH 1/2] mac80211: allow to support AP_LINK_PS when the set_tim is still needed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

In 46fa38e84b656f80edf83d21144221b0cad18d61, Johannes
allowed to use mac80211's code for handling stations
that go to PS or send PS-Poll / uAPSD trigger frames
for devices that enable RSS.
This means that mac80211 doesn't look at frames anymore
but rather relies on a notification that will come from
the device when a PS transition occurs or when a
PS-Poll / trigger frame is detected by the firmware.

iwlwifi will need this capability but still needs mac80211
to take care of the TIM IE. Today, if a driver sets
AP_LINK_PS, mac80211 will not update the TIM IE.
Change mac80211 to look at the set_tim driver callback
rather than AP_LINK_PS to decide if the driver handles
the TIM IE internally or not.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 5e70fa5..1b1b28f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -690,7 +690,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 	}
 
 	/* No need to do anything if the driver does all */
-	if (ieee80211_hw_check(&local->hw, AP_LINK_PS))
+	if (!local->ops->set_tim)
 		return;
 
 	if (sta->dead)
-- 
2.9.3
