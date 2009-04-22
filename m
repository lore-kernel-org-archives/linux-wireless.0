Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49260 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbZDVPqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 11:46:12 -0400
Subject: [PATCH] nl80211: allow configuring IBSS beacon interval
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 17:45:38 +0200
Message-Id: <1240415138.11910.0.camel@johannes.local> (sfid-20090422_174615_790158_BA429593)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the JOIN_IBSS command look at the beacon interval
attribute to see if the user requested a specific beacon
interval, if not default to 100 TU (wext too).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h |    4 +++-
 include/net/cfg80211.h  |    2 ++
 net/wireless/ibss.c     |    3 +++
 net/wireless/nl80211.c  |   12 +++++++++++-
 4 files changed, 19 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-04-22 14:33:51.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-04-22 14:34:37.000000000 +0200
@@ -230,7 +230,9 @@
  *	and optionally a MAC (as BSSID) and FREQ_FIXED attribute if those
  *	should be fixed rather than automatically determined. Can only be
  *	executed on a network interface that is UP, and fixed BSSID/FREQ
- *	may be rejected.
+ *	may be rejected. Another optional parameter is the beacon interval,
+ *	given in the %NL80211_ATTR_BEACON_INTERVAL attribute, which if not
+ *	given defaults to 100 TU (102.4ms).
  * @NL80211_CMD_LEAVE_IBSS: Leave the IBSS -- no special arguments, the IBSS is
  *	determined by the network interface.
  *
--- wireless-testing.orig/include/net/cfg80211.h	2009-04-22 14:34:50.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-04-22 14:35:15.000000000 +0200
@@ -733,6 +733,7 @@ struct cfg80211_disassoc_request {
  *	IBSSs to join on other channels.
  * @ie: information element(s) to include in the beacon
  * @ie_len: length of that
+ * @beacon_interval: beacon interval to use
  */
 struct cfg80211_ibss_params {
 	u8 *ssid;
@@ -740,6 +741,7 @@ struct cfg80211_ibss_params {
 	struct ieee80211_channel *channel;
 	u8 *ie;
 	u8 ssid_len, ie_len;
+	u16 beacon_interval;
 	bool channel_fixed;
 };
 
--- wireless-testing.orig/net/wireless/nl80211.c	2009-04-22 14:34:43.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-04-22 14:37:33.000000000 +0200
@@ -3159,6 +3159,8 @@ static int nl80211_join_ibss(struct sk_b
 	struct wiphy *wiphy;
 	int err;
 
+	memset(&ibss, 0, sizeof(ibss));
+
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
 
@@ -3167,6 +3169,15 @@ static int nl80211_join_ibss(struct sk_b
 	    !nla_len(info->attrs[NL80211_ATTR_SSID]))
 		return -EINVAL;
 
+	ibss.beacon_interval = 100;
+
+	if (info->attrs[NL80211_ATTR_BEACON_INTERVAL]) {
+		ibss.beacon_interval =
+			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
+		if (ibss.beacon_interval < 1 || ibss.beacon_interval > 10000)
+			return -EINVAL;
+	}
+
 	rtnl_lock();
 
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
@@ -3189,7 +3200,6 @@ static int nl80211_join_ibss(struct sk_b
 	}
 
 	wiphy = &drv->wiphy;
-	memset(&ibss, 0, sizeof(ibss));
 
 	if (info->attrs[NL80211_ATTR_MAC])
 		ibss.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
--- wireless-testing.orig/net/wireless/ibss.c	2009-04-22 14:37:47.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-04-22 14:38:08.000000000 +0200
@@ -116,6 +116,9 @@ static int cfg80211_ibss_wext_join(struc
 	enum ieee80211_band band;
 	int i;
 
+	if (!wdev->wext.beacon_interval)
+		wdev->wext.beacon_interval = 100;
+
 	/* try to find an IBSS channel if none requested ... */
 	if (!wdev->wext.channel) {
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {


