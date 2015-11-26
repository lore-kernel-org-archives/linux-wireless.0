Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:38063 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbbKZSvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 13:51:08 -0500
Date: Thu, 26 Nov 2015 20:51:04 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Advertise support for VHT IBSS
Message-ID: <20151126185104.GA27594@w1.fi> (sfid-20151126_195118_221582_F37C81B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VHT can be used with IBSS without needing any additional changes in
mac80211_hwsim, so start claiming support for this to increase test
coverage.

Signed-off-by: Jouni Malinen <j@w1.fi>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 551dfff..1c598a5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2449,6 +2449,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 			       NL80211_FEATURE_STATIC_SMPS |
 			       NL80211_FEATURE_DYNAMIC_SMPS |
 			       NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR;
+	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
 	/* ask mac80211 to reserve space for magic */
 	hw->vif_data_size = sizeof(struct hwsim_vif_priv);
-- 
1.9.1


-- 
Jouni Malinen                                            PGP id EFC895FA
