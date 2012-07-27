Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51344 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab2G0LC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:02:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211_hwsim: add support for P2P Device
Date: Fri, 27 Jul 2012 13:02:52 +0200
Message-Id: <1343386972-5044-5-git-send-email-johannes@sipsolutions.net> (sfid-20120727_130307_682403_5C3278D6)
In-Reply-To: <1343386972-5044-1-git-send-email-johannes@sipsolutions.net>
References: <1343386972-5044-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Advertise support for P2P Device in hwsim
to be able to test it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 826ac7b..d03ee5b 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1732,6 +1732,7 @@ static const struct ieee80211_iface_limit hwsim_if_limits[] = {
 #endif
 				 BIT(NL80211_IFTYPE_AP) |
 				 BIT(NL80211_IFTYPE_P2P_GO) },
+	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) },
 };
 
 static const struct ieee80211_iface_combination hwsim_if_comb = {
@@ -1818,7 +1819,8 @@ static int __init init_mac80211_hwsim(void)
 			BIT(NL80211_IFTYPE_P2P_CLIENT) |
 			BIT(NL80211_IFTYPE_P2P_GO) |
 			BIT(NL80211_IFTYPE_ADHOC) |
-			BIT(NL80211_IFTYPE_MESH_POINT);
+			BIT(NL80211_IFTYPE_MESH_POINT) |
+			BIT(NL80211_IFTYPE_P2P_DEVICE);
 
 		hw->flags = IEEE80211_HW_MFP_CAPABLE |
 			    IEEE80211_HW_SIGNAL_DBM |
-- 
1.7.10.4

