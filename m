Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35965 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759135Ab3EWUYZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 16:24:25 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Arend van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.6-3.9] mac80211_hwsim: remove P2P_DEVICE support
Date: Thu, 23 May 2013 22:24:11 +0200
Message-Id: <1369340651-14475-1-git-send-email-johannes@sipsolutions.net> (sfid-20130523_222429_258038_0A031299)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Unfortunately, advertising P2P_DEVICE support was a little
premature, a number of issues came up in testing and have
been fixed for 3.10. Rather than try to backport all the
different fixes, disable P2P_DEVICE support in the drivers
using it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index cb34c78..69bbf6f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2169,7 +2169,6 @@ static const struct ieee80211_iface_limit hwsim_if_limits[] = {
 #endif
 				 BIT(NL80211_IFTYPE_AP) |
 				 BIT(NL80211_IFTYPE_P2P_GO) },
-	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) },
 };
 
 static struct ieee80211_iface_combination hwsim_if_comb = {
@@ -2295,8 +2294,7 @@ static int __init init_mac80211_hwsim(void)
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			BIT(NL80211_IFTYPE_P2P_GO) |
 			BIT(NL80211_IFTYPE_ADHOC) |
-			BIT(NL80211_IFTYPE_MESH_POINT) |
-			BIT(NL80211_IFTYPE_P2P_DEVICE);
+			BIT(NL80211_IFTYPE_MESH_POINT);
 
 		hw->flags = IEEE80211_HW_MFP_CAPABLE |
 			    IEEE80211_HW_SIGNAL_DBM |
-- 
1.8.0

