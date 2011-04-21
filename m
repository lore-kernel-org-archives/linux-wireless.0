Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59418 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1DUVGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 17:06:07 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] cfg80211: module_param to disable HT40 in 2.4GHz band
Date: Thu, 21 Apr 2011 14:10:27 -0700
Message-Id: <1303420227-6189-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently mac80211 uses ieee80211_disable_40mhz_24ghz module
parameter to allow disabling 40MHz operation in the 2.4GHz band.
Move this handling from mac80211 to cfg80211 so that the feature
will be more generic.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: the check for disabling HT40 was wrong in v1. v2 fixes that.
    No need to export the symbol as sband->ht_cap already has it.
v1: move disable_40mhz_24ghz module parameter from mac80211 to cfg80211

 net/mac80211/main.c |   18 ------------------
 net/wireless/core.c |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0ab2a8d..6187766 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -33,12 +33,6 @@
 #include "cfg.h"
 #include "debugfs.h"
 
-
-static bool ieee80211_disable_40mhz_24ghz;
-module_param(ieee80211_disable_40mhz_24ghz, bool, 0644);
-MODULE_PARM_DESC(ieee80211_disable_40mhz_24ghz,
-		 "Disable 40MHz support in the 2.4GHz band");
-
 static struct lock_class_key ieee80211_rx_skb_queue_class;
 
 void ieee80211_configure_filter(struct ieee80211_local *local)
@@ -728,18 +722,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		}
 		channels += sband->n_channels;
 
-		/*
-		 * Since ieee80211_disable_40mhz_24ghz is global, we can
-		 * modify the sband's ht data even if the driver uses a
-		 * global structure for that.
-		 */
-		if (ieee80211_disable_40mhz_24ghz &&
-		    band == IEEE80211_BAND_2GHZ &&
-		    sband->ht_cap.ht_supported) {
-			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
-		}
-
 		if (max_bitrates < sband->n_bitrates)
 			max_bitrates = sband->n_bitrates;
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index fe01de2..bbf1fa1 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -46,6 +46,11 @@ static struct dentry *ieee80211_debugfs_dir;
 /* for the cleanup, scan and event works */
 struct workqueue_struct *cfg80211_wq;
 
+static bool cfg80211_disable_40mhz_24ghz;
+module_param(cfg80211_disable_40mhz_24ghz, bool, 0644);
+MODULE_PARM_DESC(cfg80211_disable_40mhz_24ghz,
+		 "Disable 40MHz support in the 2.4GHz band");
+
 /* requires cfg80211_mutex to be held! */
 struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx)
 {
@@ -451,6 +456,18 @@ int wiphy_register(struct wiphy *wiphy)
 			return -EINVAL;
 
 		/*
+		 * Since cfg80211_disable_40mhz_24ghz is global, we can
+		 * modify the sband's ht data even if the driver uses a
+		 * global structure for that.
+		 */
+		if (cfg80211_disable_40mhz_24ghz &&
+		    band == IEEE80211_BAND_2GHZ &&
+		    sband->ht_cap.ht_supported) {
+			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
+		}
+
+		/*
 		 * Since we use a u32 for rate bitmaps in
 		 * ieee80211_get_response_rate, we cannot
 		 * have more than 32 legacy rates.
-- 
1.7.0.2

