Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47246 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbbC3OgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:36:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] mac80211_hwsim: enable fast-xmit
Date: Mon, 30 Mar 2015 16:36:07 +0200
Message-Id: <1427726167-17802-2-git-send-email-johannes@sipsolutions.net> (sfid-20150330_163617_175842_B05DD4BD)
In-Reply-To: <1427726167-17802-1-git-send-email-johannes@sipsolutions.net>
References: <1427726167-17802-1-git-send-email-johannes@sipsolutions.net>
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
index 941925991476..957abbed809f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2396,7 +2396,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
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

