Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32903 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbYCTPRf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 11:17:35 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] mac80211: prevent tuning during scanning
Date: Thu, 20 Mar 2008 08:14:29 -0700
Message-Id: <1206026069-6841-1-git-send-email-reinette.chatre@intel.com> (sfid-20080320_151739_517656_DDACF229)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohamed Abbas <mohamed.abbas@intel.com>

Postpone calling ieee80211_hw_config if hardware scanning is active.
This is similar to solution for software scanning where channel setting
is delayed until scan complete.

Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Resend of patch "iwlwifi: prevent tuning during scanning" with
corrected title.

 net/mac80211/ieee80211_ioctl.c |    2 +-
 net/mac80211/ieee80211_sta.c   |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 1d91575..83b79c9 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -308,7 +308,7 @@ int ieee80211_set_freq(struct ieee80211_local *local, int freqMHz)
 	}
 
 	if (set) {
-		if (local->sta_sw_scanning)
+		if (local->sta_sw_scanning || local->sta_hw_scanning)
 			ret = 0;
 		else
 			ret = ieee80211_hw_config(local);
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 4255ec4..1e9650e 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -3609,6 +3609,9 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 
 	if (local->sta_hw_scanning) {
 		local->sta_hw_scanning = 0;
+		if (ieee80211_hw_config(local))
+			printk(KERN_DEBUG "%s: failed to restore operational "
+			       "channel after scan\n", dev->name);
 		/* Restart STA timer for HW scan case */
 		rcu_read_lock();
 		list_for_each_entry_rcu(sdata, &local->interfaces, list)
-- 
1.5.3.4

