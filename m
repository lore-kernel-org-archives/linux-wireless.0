Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662Ab2JZNSw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 09:18:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 4/4] mac80211_hwsim: print per interface TX power
Date: Fri, 26 Oct 2012 15:19:22 +0200
Message-Id: <1351257562-30729-5-git-send-email-johannes@sipsolutions.net> (sfid-20121026_151857_108865_D0623BEA)
In-Reply-To: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net>
References: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net>
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
index 96e91dd..9b4f767 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1083,6 +1083,9 @@ static void mac80211_hwsim_bss_info_changed(struct ieee80211_hw *hw,
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

