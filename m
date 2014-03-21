Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:54086 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760937AbaCUNxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 09:53:32 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so1829180eek.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Mar 2014 06:53:31 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 01/13] cfg80211: allow drivers to iterate over matching combinations
Date: Fri, 21 Mar 2014 14:47:19 +0100
Message-Id: <1395409651-26120-2-git-send-email-michal.kazior@tieto.com> (sfid-20140321_145338_055556_11DD5582)
In-Reply-To: <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
References: <1395150804-24090-1-git-send-email-michal.kazior@tieto.com>
 <1395409651-26120-1-git-send-email-michal.kazior@tieto.com>
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
index 7f0cbfb..21766b9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4720,6 +4720,33 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
  */
 void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev);
 
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
index 241f0ad..7fa3503 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1252,10 +1252,13 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
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
@@ -1312,13 +1315,40 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
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

