Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46170 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbYGJOyn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 10:54:43 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/1] mac80211: dont add a STA which is not in the same IBSS
Date: Thu, 10 Jul 2008 17:54:14 +0300
Message-Id: <1215701654-27769-1-git-send-email-tomas.winkler@intel.com> (sfid-20080710_165512_058298_7668A06A)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch avoids adding STAs that don't belong to our IBSS
ieee80211_bssid_match matches also bcast address so also APs
were added

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/mlme.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index dbc8cf4..00b7186 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4398,7 +4398,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct net_device *dev,
 		return NULL;
 	}
 
-	if (!ieee80211_bssid_match(bssid, sdata->u.sta.bssid))
+	if (compare_ether_addr(bssid, sdata->u.sta.bssid))
 		return NULL;
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

