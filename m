Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47943 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbZKIMlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:41:36 -0500
Received: by bwz27 with SMTP id 27so3397119bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:41:40 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 16/21] mac80211: fix BSSID setup for beacon frames
Date: Mon,  9 Nov 2009 12:39:36 +0000
Message-Id: <1257770381-7680-17-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
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

