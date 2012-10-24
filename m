Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162Ab2JXKMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 06:12:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] mac80211_hwsim: print per interface TX power
Date: Wed, 24 Oct 2012 12:13:23 +0200
Message-Id: <1351073603-11616-5-git-send-email-johannes@sipsolutions.net> (sfid-20121024_121300_969987_D35AB641)
In-Reply-To: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>
References: <1351073603-11616-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Just for debugging, print the interface TX
power whenever it changes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 429ca32..da57fa2 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -972,6 +972,9 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
 		wiphy_debug(hw->wiphy, "  BASIC_RATES: 0x%llx\n",
 			    (unsigned long long) info->basic_rates);
 	}
+
+	if (changed & BSS_CHANGED_TXPOWER)
+		wiphy_debug(hw->wiphy, "  TX Power: %d dBm\n", info->txpower);
 }
 
 static int mac80211_hwsim_sta_add(struct ieee80211_hw *hw,
-- 
1.7.10.4

