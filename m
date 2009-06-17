Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbZFQPmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 11:42:19 -0400
Subject: [PATCH] cfg80211: prohibit scanning the same channel more than once
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 17:41:49 +0200
Message-Id: <1245253309.31588.25.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It isn't very useful to scan the same channel more than once
during a given scan, and some hardware (notably iwlwifi) can
only scan a limited number of channels at a time. To prevent
any overflows, simply disallow scanning any channel multiple
times in a given scan command. This is a small change in the
userspace ABI, but the only user, wpa_supplicant, never asks
for a scan with the same frequency listed twice.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/nl80211.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-06-17 02:46:22.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-06-17 02:55:01.000000000 +0200
@@ -2629,6 +2629,31 @@ static int nl80211_set_reg(struct sk_buf
 	return r;
 }
 
+static int validate_scan_freqs(struct nlattr *freqs)
+{
+	struct nlattr *attr1, *attr2;
+	int n_channels = 0, tmp1, tmp2;
+
+	nla_for_each_nested(attr1, freqs, tmp1) {
+		n_channels++;
+		/*
+		 * Some hardware has a limited channel list for
+		 * scanning, and it is pretty much nonsensical
+		 * to scan for a channel twice, so disallow that
+		 * and don't require drivers to check that the
+		 * channel list they get isn't longer than what
+		 * they can scan, as long as they can scan all
+		 * the channels they registered at once.
+		 */
+		nla_for_each_nested(attr2, freqs, tmp2)
+			if (attr1 != attr2 &&
+			    nla_get_u32(attr1) == nla_get_u32(attr2))
+				return 0;
+	}
+
+	return n_channels;
+}
+
 static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
@@ -2638,7 +2663,7 @@ static int nl80211_trigger_scan(struct s
 	struct ieee80211_channel *channel;
 	struct nlattr *attr;
 	struct wiphy *wiphy;
-	int err, tmp, n_ssids = 0, n_channels = 0, i;
+	int err, tmp, n_ssids = 0, n_channels, i;
 	enum ieee80211_band band;
 	size_t ie_len;
 
@@ -2669,13 +2694,15 @@ static int nl80211_trigger_scan(struct s
 	}
 
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
-		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_FREQUENCIES], tmp)
-			n_channels++;
+		n_channels = validate_scan_freqs(
+				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
 		if (!n_channels) {
 			err = -EINVAL;
 			goto out;
 		}
 	} else {
+		n_channels = 0;
+
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
 			if (wiphy->bands[band])
 				n_channels += wiphy->bands[band]->n_channels;


