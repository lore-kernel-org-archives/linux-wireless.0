Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45823 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaKXPkC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 10:40:02 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] Revert "mac80211_hwsim: VHT add 160MHz width support"
Date: Mon, 24 Nov 2014 16:39:52 +0100
Message-Id: <1416843592-30818-1-git-send-email-johannes@sipsolutions.net> (sfid-20141124_164007_356692_BC4AEA3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit c17aa52c5bf571533cc8561292f7316b9216eddc.

It was wrong, IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ
already implies that 160 MHz is supported, as it isn't a bitmap
but rather a value in a 2-bit field.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index d399a7367ce9..756eea588711 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2388,7 +2388,6 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		sband->vht_cap.cap =
 			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
 			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ |
-			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ |
 			IEEE80211_VHT_CAP_RXLDPC |
 			IEEE80211_VHT_CAP_SHORT_GI_80 |
 			IEEE80211_VHT_CAP_SHORT_GI_160 |
-- 
2.1.1

