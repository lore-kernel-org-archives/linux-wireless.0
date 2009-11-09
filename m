Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:10530 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746AbZKIXrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:33 -0500
Received: by ey-out-2122.google.com with SMTP id 4so87857eyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:39 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 15/20] mac80211: fix BSSID setup for beacon frames
Date: Mon,  9 Nov 2009 23:46:53 +0000
Message-Id: <1257810418-30075-16-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BSSID is now set to the TA.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c7dc8cc..e7d56a5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2114,7 +2114,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		    cpu_to_le16(IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_BEACON);
 		memset(mgmt->da, 0xff, ETH_ALEN);
 		memcpy(mgmt->sa, sdata->dev->dev_addr, ETH_ALEN);
-		/* BSSID is left zeroed, wildcard value */
+		memcpy(mgmt->bssid, sdata->dev->dev_addr, ETH_ALEN);
 		mgmt->u.beacon.beacon_int =
 			cpu_to_le16(sdata->vif.bss_conf.beacon_int);
 		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
-- 
1.5.6.5

