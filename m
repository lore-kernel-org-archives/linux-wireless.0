Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62180 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaB1PMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 10:12:00 -0500
Received: by mail-ea0-f174.google.com with SMTP id h14so2667586eaj.5
        for <linux-wireless@vger.kernel.org>; Fri, 28 Feb 2014 07:11:59 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 1/3] cfg80211: allow drivers to iterate over matching combinations
Date: Fri, 28 Feb 2014 16:06:45 +0100
Message-Id: <1393600007-28766-2-git-send-email-michal.kazior@tieto.com> (sfid-20140228_161213_228134_1FB31B54)
In-Reply-To: <1393600007-28766-1-git-send-email-michal.kazior@tieto.com>
References: <1393600007-28766-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch splits cfg80211_check_combinations()
into an iterator function and a simple iteration
user.

This makes it possible for drivers to asses how
many channels can use given iftype setup. This in
turn can be used for future
multi-interface/multi-channel channel switching.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h | 27 +++++++++++++++++++++++++++
 net/wireless/util.c    | 44 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 23a72e2..f3411c9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4705,6 +4705,33 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
 				const u8 radar_detect,
 				const int iftype_num[NUM_NL80211_IFTYPES]);
 
+/**
+ * cfg80211_iter_combinations - iterate over matching combinations
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
+ * @iter: function to call for each matching combination
+ * @data: pointer to pass to iter function
+ *
+ * This function can be called by the driver to check what possible
+ * combinations it fits in at a given moment, e.g. for channel switching
+ * purposes.
+ */
+int cfg80211_iter_combinations(struct wiphy *wiphy,
+			       const int num_different_channels,
+			       const u8 radar_detect,
+			       const int iftype_num[NUM_NL80211_IFTYPES],
+			       void (*iter)(const struct ieee80211_iface_combination *c,
+					    void *data),
+			       void *data);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 378038d30..486b604 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1248,10 +1248,13 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	return res;
 }
 
-int cfg80211_check_combinations(struct wiphy *wiphy,
-				const int num_different_channels,
-				const u8 radar_detect,
-				const int iftype_num[NUM_NL80211_IFTYPES])
+int cfg80211_iter_combinations(struct wiphy *wiphy,
+			       const int num_different_channels,
+			       const u8 radar_detect,
+			       const int iftype_num[NUM_NL80211_IFTYPES],
+			       void (*iter)(const struct ieee80211_iface_combination *c,
+					    void *data),
+			       void *data)
 {
 	int i, j, iftype;
 	int num_interfaces = 0;
@@ -1307,13 +1310,40 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
 		/* This combination covered all interface types and
 		 * supported the requested numbers, so we're good.
 		 */
-		kfree(limits);
-		return 0;
+
+		(*iter)(c, data);
  cont:
 		kfree(limits);
 	}
 
-	return -EBUSY;
+	return 0;
+}
+EXPORT_SYMBOL(cfg80211_iter_combinations);
+
+static void
+cfg80211_iter_sum_ifcombs(const struct ieee80211_iface_combination *c,
+			  void *data)
+{
+	int *num = data;
+	(*num)++;
+}
+
+int cfg80211_check_combinations(struct wiphy *wiphy,
+				const int num_different_channels,
+				const u8 radar_detect,
+				const int iftype_num[NUM_NL80211_IFTYPES])
+{
+	int err, num = 0;
+
+	err = cfg80211_iter_combinations(wiphy, num_different_channels,
+					 radar_detect, iftype_num,
+					 cfg80211_iter_sum_ifcombs, &num);
+	if (err)
+		return err;
+	if (num == 0)
+		return -EBUSY;
+
+	return 0;
 }
 EXPORT_SYMBOL(cfg80211_check_combinations);
 
-- 
1.8.5.3

