Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:58885 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631AbaA1PJQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jan 2014 10:09:16 -0500
From: Luciano Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: ibss: remove unnecessary call to release channel
Date: Tue, 28 Jan 2014 17:09:08 +0200
Message-Id: <1390921748-7566-1-git-send-email-luca@coelho.fi> (sfid-20140128_160919_890168_94138AB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The ieee80211_vif_use_channel() function calls
ieee80211_vif_release_channel(), so there's no need to call it
explicitly in __ieee80211_sta_join_ibss().

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/ibss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ed7eec3..8221337 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -294,7 +294,6 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	}
 
 	mutex_lock(&local->mtx);
-	ieee80211_vif_release_channel(sdata);
 	if (ieee80211_vif_use_channel(sdata, &chandef,
 				      ifibss->fixed_channel ?
 					IEEE80211_CHANCTX_SHARED :
-- 
1.8.5.3

