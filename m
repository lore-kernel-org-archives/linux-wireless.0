Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50799 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbYLDVYI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2008 16:24:08 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [RFC] mac80211: remove WARN_ON() from ieee80211_hw_config
Date: Thu,  4 Dec 2008 13:25:05 -0800
Message-Id: <1228425905-15666-1-git-send-email-reinette.chatre@intel.com> (sfid-20081204_222414_090451_35DA339F)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_hw_config can return an error when the hardware
has rfkill enabled. A WARN_ON() is too harsh for this
failure as it is a valid scenario. Only comment this warning
as we would like to have it back when rfkill is integrated into
mac80211.

Also reintroduce number of printks that will happen in this case.

This patch essentially reverts patch:
5f0387fc3337ca26f0745f945f550f0c3734960f
"mac80211: clean up ieee80211_hw_config errors"

Things not reverted is the reintroduction of a comment
and debug statement.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
There are several places where ieee80211_hw_config's return code is not
checked. I did not change those as it appears to be intended considering
that the patch being reverted had nothing to do with them not using the
return code.

It may also be that in this patch only the second hunk be necessary. Please
provide feedback in this regard.

When a user has rfkill enabled (and using this patch) iwlwifi's log does
indicate to user what problem can be without needing the WARN:

ADDRCONF(NETDEV_UP): wlan0: link is not ready
iwlagn: Radio Frequency Kill Switch is On:
Kill switch must be turned off for wireless networking to work.

 net/mac80211/cfg.c  |    5 +++--
 net/mac80211/main.c |   12 +++++++++++-
 net/mac80211/scan.c |   14 +++++++++++---
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7a7a6c1..1c0bb98 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -396,8 +396,9 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (params->interval) {
 		sdata->local->hw.conf.beacon_int = params->interval;
-		ieee80211_hw_config(sdata->local,
-				    IEEE80211_CONF_CHANGE_BEACON_INTERVAL);
+		if (ieee80211_hw_config(sdata->local,
+					IEEE80211_CONF_CHANGE_BEACON_INTERVAL))
+			return -EINVAL;
 		/*
 		 * We updated some parameter so if below bails out
 		 * it's not an error.
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 29c3ecf..df7e9a8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -243,10 +243,20 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	if (changed && local->open_count) {
 		ret = local->ops->config(local_to_hw(local), changed);
 		/*
+		 * Goal:
 		 * HW reconfiguration should never fail, the driver has told
 		 * us what it can support so it should live up to that promise.
+		 *
+		 * Current status:
+		 * rfkill is not integrated with mac80211 and a
+		 * configuration command can thus fail if hardware rfkill
+		 * is enabled
+		 *
+		 * FIXME: integrate rfkill with mac80211 and then add this
+		 * WARN_ON() back
+		 *
 		 */
-		WARN_ON(ret);
+		/* WARN_ON(ret); */
 	}
 
 	return ret;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f5c7c33..2b897f6 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -453,12 +453,16 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 		 * that we won't have acted upon, try now. ieee80211_hw_config
 		 * will set the flag based on actual changes.
 		 */
-		ieee80211_hw_config(local, 0);
+		if (ieee80211_hw_config(local, 0))
+			printk(KERN_DEBUG "%s: failed to restore operational "
+			       "channel after scan\n", wiphy_name(local->hw.wiphy));
 		goto done;
 	}
 
 	local->sw_scanning = false;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
+		printk(KERN_DEBUG "%s: failed to restore operational "
+		       "channel after scan\n", wiphy_name(local->hw.wiphy));
 
 	netif_tx_lock_bh(local->mdev);
 	netif_addr_lock(local->mdev);
@@ -546,8 +550,12 @@ void ieee80211_scan_work(struct work_struct *work)
 		if (!skip) {
 			local->scan_channel = chan;
 			if (ieee80211_hw_config(local,
-						IEEE80211_CONF_CHANGE_CHANNEL))
+						IEEE80211_CONF_CHANGE_CHANNEL)) {
+				printk(KERN_DEBUG "%s: failed to set freq to "
+				       "%d MHz for scan\n", wiphy_name(local->hw.wiphy),
+				       chan->center_freq);
 				skip = 1;
+			}
 		}
 
 		/* advance state machine to next channel/band */
-- 
1.5.4.3

