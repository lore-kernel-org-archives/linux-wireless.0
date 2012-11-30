Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:51322 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161022Ab2K3SRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 13:17:41 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 1/2] mac80211: return if CSA is not handle
Date: Fri, 30 Nov 2012 19:17:27 +0100
Message-Id: <1354299448-19928-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20121130_191745_173662_B2BFFABC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If channel contexts are enabled, the CSA should not be processed
further. A return is missing here.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 net/mac80211/mlme.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d2a4f78..1099e07 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -775,6 +775,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 			   "not handling channel switch with channel contexts\n");
 		ieee80211_queue_work(&sdata->local->hw,
 				     &ifmgd->csa_connection_drop_work);
+		return;
 	}
 
 	mutex_lock(&sdata->local->chanctx_mtx);
-- 
1.7.10.4

