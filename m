Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbZBHNdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2009 08:33:23 -0500
Subject: [PATCH] mac80211: properly validate/translate IW_AUTH_MFP values
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 08 Feb 2009 14:33:19 +0100
Message-Id: <1234099999.4175.123.camel@johannes.local> (sfid-20090208_143326_201830_3FC09587)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure nobody passes in bogus values, and translate the values
(although it isn't necessary).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/wext.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-02-08 14:24:32.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-02-08 14:29:45.000000000 +0100
@@ -946,9 +946,21 @@ static int ieee80211_ioctl_siwauth(struc
 			break;
 		}
 		if (sdata->vif.type == NL80211_IFTYPE_STATION ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC)
-			sdata->u.sta.mfp = data->value;
-		else
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC) {
+		    	switch (data->value) {
+		    	case IW_AUTH_MFP_DISABLED:
+		    		sdata->u.sta.mfp = IEEE80211_MFP_DISABLED;
+		    		break;
+		    	case IW_AUTH_MFP_OPTIONAL:
+		    		sdata->u.sta.mfp = IEEE80211_MFP_OPTIONAL;
+		    		break;
+		    	case IW_AUTH_MFP_REQUIRED:
+		    		sdata->u.sta.mfp = IEEE80211_MFP_REQUIRED;
+		    		break;
+		    	default:
+		    		ret = -EINVAL;
+		    	}
+		} else
 			ret = -EOPNOTSUPP;
 		break;
 	default:


