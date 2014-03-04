Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:37878 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375AbaCDIH7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2014 03:07:59 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH v8 1/5] cfg80211: refactor cfg80211_can_use_iftype_chan()
Date: Tue,  4 Mar 2014 10:07:50 +0200
Message-Id: <1393920474-4935-2-git-send-email-luca@coelho.fi> (sfid-20140304_090808_556213_E06C2431)
In-Reply-To: <1393920474-4935-1-git-send-email-luca@coelho.fi>
References: <1393920474-4935-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Separate the code that counts the interface types and channels from
the code that check the interface combinations.  The new function that
checks for combinations is exported so it can be called by the
drivers.

This is done in preparation for moving the interface combinations
checks out of cfg80211.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
In v4:

   * rebased on top of slightly modified applied patches
   * removed the parenthesis from the comment (not needed for docbook)
   * use num[NUM_NL80211_IFTYPES] in cfg80211_check_combinations()

In v7:

   * removed redundant arguments (num_interfaces and used_iftypes)
     from cfg80211_check_combinations();
---
 Documentation/DocBook/80211.tmpl |   1 +
 include/net/cfg80211.h           |  22 +++++++
 net/wireless/util.c              | 128 ++++++++++++++++++++++-----------------
 3 files changed, 95 insertions(+), 56 deletions(-)

diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
index 044b764..d9b9416 100644
--- a/Documentation/DocBook/80211.tmpl
+++ b/Documentation/DocBook/80211.tmpl
@@ -100,6 +100,7 @@
 !Finclude/net/cfg80211.h wdev_priv
 !Finclude/net/cfg80211.h ieee80211_iface_limit
 !Finclude/net/cfg80211.h ieee80211_iface_combination
+!Finclude/net/cfg80211.h cfg80211_check_combinations
       </chapter>
       <chapter>
       <title>Actions and configuration</title>
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ff3af16..768fcc0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4682,6 +4682,28 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
  */
 unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
 
+/**
+ * cfg80211_check_combinations - check interface combinations
+ *
+ * @wiphy: the wiphy
+ * @num_different_channels: the number of different channels we want
+ *	to use for verification
+ * @radar_detect: a bitmap where each bit corresponds to a channel
+ *	width where radar detection is needed, as in the definition of
+ *	&struct ieee80211_iface_combination.@radar_detect_widths
+ * @iftype_num: array with the numbers of interfaces of each interface
+ *	type.  The index is the interface type as specified in &enum
+ *	nl80211_iftype.
+ *
+ * This function can be called by the driver to check whether a
+ * combination of interfaces and their types are allowed according to
+ * the interface combinations.
+ */
+int cfg80211_check_combinations(struct wiphy *wiphy,
+				const int num_different_channels,
+				const u8 radar_detect,
+				const int iftype_num[NUM_NL80211_IFTYPES]);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index dadc934..7ecc0ef 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1253,6 +1253,75 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	return res;
 }
 
+int cfg80211_check_combinations(struct wiphy *wiphy,
+				const int num_different_channels,
+				const u8 radar_detect,
+				const int iftype_num[NUM_NL80211_IFTYPES])
+{
+	int i, j, iftype;
+	int num_interfaces = 0;
+	u32 used_iftypes = 0;
+
+	for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
+		num_interfaces += iftype_num[iftype];
+		if (iftype_num[iftype] > 0)
+			used_iftypes |= BIT(iftype);
+	}
+
+	for (i = 0; i < wiphy->n_iface_combinations; i++) {
+		const struct ieee80211_iface_combination *c;
+		struct ieee80211_iface_limit *limits;
+		u32 all_iftypes = 0;
+
+		c = &wiphy->iface_combinations[i];
+
+		if (num_interfaces > c->max_interfaces)
+			continue;
+		if (num_different_channels > c->num_different_channels)
+			continue;
+
+		limits = kmemdup(c->limits, sizeof(limits[0]) * c->n_limits,
+				 GFP_KERNEL);
+		if (!limits)
+			return -ENOMEM;
+
+		for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
+			if (wiphy->software_iftypes & BIT(iftype))
+				continue;
+			for (j = 0; j < c->n_limits; j++) {
+				all_iftypes |= limits[j].types;
+				if (!(limits[j].types & BIT(iftype)))
+					continue;
+				if (limits[j].max < iftype_num[iftype])
+					goto cont;
+				limits[j].max -= iftype_num[iftype];
+			}
+		}
+
+		if (radar_detect && !(c->radar_detect_widths & radar_detect))
+			goto cont;
+
+		/* Finally check that all iftypes that we're currently
+		 * using are actually part of this combination. If they
+		 * aren't then we can't use this combination and have
+		 * to continue to the next.
+		 */
+		if ((all_iftypes & used_iftypes) != used_iftypes)
+			goto cont;
+
+		/* This combination covered all interface types and
+		 * supported the requested numbers, so we're good.
+		 */
+		kfree(limits);
+		return 0;
+ cont:
+		kfree(limits);
+	}
+
+	return -EBUSY;
+}
+EXPORT_SYMBOL(cfg80211_check_combinations);
+
 int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 struct wireless_dev *wdev,
 				 enum nl80211_iftype iftype,
@@ -1261,7 +1330,6 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 u8 radar_detect)
 {
 	struct wireless_dev *wdev_iter;
-	u32 used_iftypes = BIT(iftype);
 	int num[NUM_NL80211_IFTYPES];
 	struct ieee80211_channel
 			*used_channels[CFG80211_MAX_NUM_DIFFERENT_CHANNELS];
@@ -1269,7 +1337,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	enum cfg80211_chan_mode chmode;
 	int num_different_channels = 0;
 	int total = 1;
-	int i, j;
+	int i;
 
 	ASSERT_RTNL();
 
@@ -1354,65 +1422,13 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 
 		num[wdev_iter->iftype]++;
 		total++;
-		used_iftypes |= BIT(wdev_iter->iftype);
 	}
 
 	if (total == 1 && !radar_detect)
 		return 0;
 
-	for (i = 0; i < rdev->wiphy.n_iface_combinations; i++) {
-		const struct ieee80211_iface_combination *c;
-		struct ieee80211_iface_limit *limits;
-		u32 all_iftypes = 0;
-
-		c = &rdev->wiphy.iface_combinations[i];
-
-		if (total > c->max_interfaces)
-			continue;
-		if (num_different_channels > c->num_different_channels)
-			continue;
-
-		limits = kmemdup(c->limits, sizeof(limits[0]) * c->n_limits,
-				 GFP_KERNEL);
-		if (!limits)
-			return -ENOMEM;
-
-		for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
-			if (rdev->wiphy.software_iftypes & BIT(iftype))
-				continue;
-			for (j = 0; j < c->n_limits; j++) {
-				all_iftypes |= limits[j].types;
-				if (!(limits[j].types & BIT(iftype)))
-					continue;
-				if (limits[j].max < num[iftype])
-					goto cont;
-				limits[j].max -= num[iftype];
-			}
-		}
-
-		if (radar_detect && !(c->radar_detect_widths & radar_detect))
-			goto cont;
-
-		/*
-		 * Finally check that all iftypes that we're currently
-		 * using are actually part of this combination. If they
-		 * aren't then we can't use this combination and have
-		 * to continue to the next.
-		 */
-		if ((all_iftypes & used_iftypes) != used_iftypes)
-			goto cont;
-
-		/*
-		 * This combination covered all interface types and
-		 * supported the requested numbers, so we're good.
-		 */
-		kfree(limits);
-		return 0;
- cont:
-		kfree(limits);
-	}
-
-	return -EBUSY;
+	return cfg80211_check_combinations(&rdev->wiphy, num_different_channels,
+					   radar_detect, num);
 }
 
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
-- 
1.8.5.3

