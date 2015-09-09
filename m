Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:41021 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbbIIU5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Sep 2015 16:57:13 -0400
From: Sergei Trofimovich <slyich@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Sergei Trofimovich <siarheit@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net/mac80211/rate.c: fix wrong sizeof()
Date: Wed,  9 Sep 2015 21:56:54 +0100
Message-Id: <1441832214-6939-1-git-send-email-slyich@gmail.com> (sfid-20150909_225731_557833_8C07F16B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sergei Trofimovich <siarheit@google.com>

Noticed by gcc-5.2.0:

    net/mac80211/rate.c: In function 'rate_control_cap_mask':
    net/mac80211/rate.c:719:25: warning: 'sizeof' on array function parameter 'mcs_mask' will return size of 'u8 * {aka unsigned char *}' [-Wsizeof-array-argument]
       for (i = 0; i < sizeof(mcs_mask); i++)
                             ^

CC: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Signed-off-by: Sergei Trofimovich <siarheit@google.com>
---
 net/mac80211/rate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 9857693..9ce8883 100644
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
2.5.0

