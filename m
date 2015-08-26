Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35784 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbbHZKXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2015 06:23:33 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: Do not use sizeof() on pointer type
Date: Wed, 26 Aug 2015 12:22:14 +0200
Message-Id: <1440584534-27251-1-git-send-email-thierry.reding@gmail.com> (sfid-20150826_122411_189354_4F0083F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

The rate_control_cap_mask() function takes a parameter mcs_mask, which
GCC will take to be u8 * even though it was declared with a fixed size.
This causes the following warning:

	net/mac80211/rate.c: In function 'rate_control_cap_mask':
	net/mac80211/rate.c:719:25: warning: 'sizeof' on array function parameter 'mcs_mask' will return size of 'u8 * {aka unsigned char *}' [-Wsizeof-array-argument]
	   for (i = 0; i < sizeof(mcs_mask); i++)
	                         ^
	net/mac80211/rate.c:684:10: note: declared here
	       u8 mcs_mask[IEEE80211_HT_MCS_MASK_LEN],
	          ^

This can be easily fixed by using the IEEE80211_HT_MCS_MASK_LEN directly
within the loop condition.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 net/mac80211/rate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 9857693b91ec..9ce8883d5f44 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -716,7 +716,7 @@ static bool rate_control_cap_mask(struct ieee80211_sub_if_data *sdata,
 
 		/* Filter out rates that the STA does not support */
 		*mask &= sta->supp_rates[sband->band];
-		for (i = 0; i < sizeof(mcs_mask); i++)
+		for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++)
 			mcs_mask[i] &= sta->ht_cap.mcs.rx_mask[i];
 
 		sta_vht_cap = sta->vht_cap.vht_mcs.rx_mcs_map;
-- 
2.4.5

