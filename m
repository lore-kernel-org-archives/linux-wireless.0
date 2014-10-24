Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49895 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbaJXSMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2014 14:12:13 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211-hwsim: support SGI-20
Date: Fri, 24 Oct 2014 11:12:08 -0700
Message-Id: <1414174328-21714-1-git-send-email-greearb@candelatech.com> (sfid-20141024_201216_808639_3655C251)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This lets hostapd start if you have SGI-20 configured
as one of your HT capabilities.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 19ecf29..8ad82b0 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2168,6 +2168,7 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		sband->ht_cap.ht_supported = true;
 		sband->ht_cap.cap = IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
 				    IEEE80211_HT_CAP_GRN_FLD |
+				    IEEE80211_HT_CAP_SGI_20 |
 				    IEEE80211_HT_CAP_SGI_40 |
 				    IEEE80211_HT_CAP_DSSSCCK40;
 		sband->ht_cap.ampdu_factor = 0x3;
-- 
1.7.11.7

