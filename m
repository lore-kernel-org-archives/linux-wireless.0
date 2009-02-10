Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756230AbZBJUcA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:32:00 -0500
Message-Id: <20090210202553.253322188@sipsolutions.net> (sfid-20090210_213221_449264_C71244F9)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/27] mac80211: properly validate/translate IW_AUTH_MFP
	values
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make sure nobody passes in bogus values, and translate the values
(although it isn't necessary).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/wext.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-02-10 20:59:27.000000000 +0100
+++ wireless-testing/net/mac80211/wext.c	2009-02-10 20:59:30.000000000 +0100
@@ -982,9 +982,21 @@ static int ieee80211_ioctl_siwauth(struc
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

-- 

