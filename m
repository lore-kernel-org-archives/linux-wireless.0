Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47613 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbbDQPP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 11:15:57 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/11] mac80211_hwsim: enable IEEE80211_HW_SUPPORT_FAST_XMIT
Date: Fri, 17 Apr 2015 17:15:42 +0200
Message-Id: <1429283751-5104-2-git-send-email-johannes@sipsolutions.net> (sfid-20150417_171600_860567_35C4362E)
In-Reply-To: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For hwsim, the duration field in frames is already not valid for
the common case of HT/VHT MCSes, so there's little point in trying
to keep it accurate for the legacy rates. Enable the fast-xmit code
to allow testing that, although given the dependency on hardware
crypto it will only be enabled in open network configurations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d5c0a1af08b9..07626cc21d6e 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2399,7 +2399,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		    IEEE80211_HW_WANT_MONITOR_VIF |
 		    IEEE80211_HW_QUEUE_CONTROL |
 		    IEEE80211_HW_SUPPORTS_HT_CCK_RATES |
-		    IEEE80211_HW_CHANCTX_STA_CSA;
+		    IEEE80211_HW_CHANCTX_STA_CSA |
+		    IEEE80211_HW_SUPPORT_FAST_XMIT;
 	if (rctbl)
 		hw->flags |= IEEE80211_HW_SUPPORTS_RC_TABLE;
 
-- 
2.1.4

