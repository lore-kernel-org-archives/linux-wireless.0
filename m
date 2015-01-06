Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42822 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821AbbAFTpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 14:45:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: uninitialized return val in __ieee80211_sta_handle_tspec_ac_params
Date: Tue,  6 Jan 2015 14:39:33 -0500
Message-Id: <1420573173-741-1-git-send-email-linville@tuxdriver.com> (sfid-20150106_204527_394658_5FFC7A5D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Coverity: CID 1260096

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/mlme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2c36c4765f47..837a406a9dd6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1643,7 +1643,7 @@ __ieee80211_sta_handle_tspec_ac_params(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	bool ret;
+	bool ret = false;
 	int ac;
 
 	if (local->hw.queues < IEEE80211_NUM_ACS)
-- 
2.1.0

