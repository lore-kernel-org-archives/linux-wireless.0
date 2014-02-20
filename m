Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:55924 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaBTFKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 00:10:20 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, michal.kazior@tieto.com,
	sw@simonwunderlich.de, bzhao@marvell.com, arend@broadcom.com
Subject: [PATCH v2 3/7] cfg80211: refactor cfg80211_can_use_iftype_chan()
Date: Thu, 20 Feb 2014 07:10:09 +0200
Message-Id: <1392873013-21772-4-git-send-email-luca@coelho.fi> (sfid-20140220_061053_882942_88270D2A)
In-Reply-To: <1392873013-21772-1-git-send-email-luca@coelho.fi>
References: <1392873013-21772-1-git-send-email-luca@coelho.fi>
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
 Documentation/DocBook/80211.tmpl |   1 +
 include/net/cfg80211.h           |  29 ++++++++++
 net/wireless/util.c              | 121 ++++++++++++++++++++++-----------------
 3 files changed, 97 insertions(+), 54 deletions(-)

diff --git a/Documentation/DocBook/80211.tmpl b/Documentation/DocBook/80211.tmpl
index 46ad6fa..9135476 100644
--- a/Documentation/DocBook/80211.tmpl
+++ b/Documentation/DocBook/80211.tmpl
@@ -98,6 +98,7 @@
 !Finclude/net/cfg80211.h priv_to_wiphy
 !Finclude/net/cfg80211.h set_wiphy_dev
 !Finclude/net/cfg80211.h wdev_priv
+!Finclude/net/cfg80211.h cfg80211_check_combinations
       </chapter>
       <chapter>
       <title>Actions and configuration</title>
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9f90554..e44d62b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4667,6 +4667,35 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
  */
 unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
 
+/**
+ * cfg80211_check_combinations() - check interface combinations
+ *
+ * @wiphy: the wiphy
+ * @num_different_channels: the number of different channels we want
+ *	to use for verification
+ * @num_interfaces: the number of different interfaces we want to use
+ *	for verification
+ * @used_iftypes: a bitmap where each bit corresponds to an interface
+ *	type, as in the definition of &struct
+ *	ieee80211_iface_limit.@types.
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
+				const int num_interfaces,
+				const u32 used_iftypes,
+				const u8 radar_detect,
+				const int *iftype_num);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 57b3ce7..fbc2f8a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1253,6 +1253,69 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	return res;
 }
 
+int cfg80211_check_combinations(struct wiphy *wiphy,
+				const int num_different_channels,
+				const int num_interfaces,
+				const u32 used_iftypes,
+				const u8 radar_detect,
+				const int *iftype_num)
+{
+	int i, j, iftype;
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
@@ -1269,7 +1332,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 	enum cfg80211_chan_mode chmode;
 	int num_different_channels = 0;
 	int total = 1;
-	int i, j;
+	int i;
 
 	ASSERT_RTNL();
 
@@ -1360,59 +1423,9 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
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
+					   total, used_iftypes,
+					   radar_detect, num);
 }
 
 int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
-- 
1.8.5.3

