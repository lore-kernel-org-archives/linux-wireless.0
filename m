Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14906 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbYFLTin (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 15:38:43 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: fix beacon interval value
Date: Thu, 12 Jun 2008 22:38:37 +0300
Message-Id: <1213299517-24042-1-git-send-email-tomas.winkler@intel.com> (sfid-20080612_213847_355572_07FFAC4B)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes setting beacon interval

1. in register_hw it honors value requested by the driver
2. It uses default 100 instead of 1000 or 10000. Scanning for beacon
interval ~1sec and above is not sane

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/main.c |    3 ++-
 net/mac80211/mlme.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b182f01..5c5396e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1707,7 +1707,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	debugfs_hw_add(local);
 
-	local->hw.conf.beacon_int = 1000;
+	if (local->hw.conf.beacon_int < 10)
+		local->hw.conf.beacon_int = 100;
 
 	local->wstats_flags |= local->hw.flags & (IEEE80211_HW_SIGNAL_UNSPEC |
 						  IEEE80211_HW_SIGNAL_DB |
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7f05820..46f2037 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3583,7 +3583,7 @@ static int ieee80211_sta_create_ibss(struct net_device *dev,
 	sband = local->hw.wiphy->bands[bss->band];
 
 	if (local->hw.conf.beacon_int == 0)
-		local->hw.conf.beacon_int = 10000;
+		local->hw.conf.beacon_int = 100;
 	bss->beacon_int = local->hw.conf.beacon_int;
 	bss->last_update = jiffies;
 	bss->capability = WLAN_CAPABILITY_IBSS;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

