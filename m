Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab2EJUdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 16:33:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SSa3S-0005kT-Nb
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 22:33:42 +0200
Message-Id: <20120510203304.679354639@sipsolutions.net> (sfid-20120510_223347_817251_14F37FD0)
Date: Thu, 10 May 2012 22:30:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 1/2] mac80211: move ieee80211_set_channel function
References: <20120510203021.240931880@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Move the set_channel function up so it can be used
by other code in this file in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c |   70 ++++++++++++++++++++++++++---------------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

--- a/net/mac80211/cfg.c	2012-05-10 21:46:39.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-05-10 21:47:10.000000000 +0200
@@ -674,6 +674,41 @@ static int ieee80211_get_station(struct
 	return ret;
 }
 
+static int ieee80211_set_channel(struct wiphy *wiphy,
+				 struct net_device *netdev,
+				 struct ieee80211_channel *chan,
+				 enum nl80211_channel_type channel_type)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = NULL;
+
+	if (netdev)
+		sdata = IEEE80211_DEV_TO_SUB_IF(netdev);
+
+	switch (ieee80211_get_channel_mode(local, NULL)) {
+	case CHAN_MODE_HOPPING:
+		return -EBUSY;
+	case CHAN_MODE_FIXED:
+		if (local->oper_channel != chan)
+			return -EBUSY;
+		if (!sdata && local->_oper_channel_type == channel_type)
+			return 0;
+		break;
+	case CHAN_MODE_UNDEFINED:
+		break;
+	}
+
+	if (!ieee80211_set_channel_type(local, sdata, channel_type))
+		return -EBUSY;
+
+	local->oper_channel = chan;
+
+	/* auto-detects changes */
+	ieee80211_hw_config(local, 0);
+
+	return 0;
+}
+
 static int ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 				    const u8 *resp, size_t resp_len)
 {
@@ -1676,41 +1711,6 @@ static int ieee80211_set_txq_params(stru
 
 	return 0;
 }
-
-static int ieee80211_set_channel(struct wiphy *wiphy,
-				 struct net_device *netdev,
-				 struct ieee80211_channel *chan,
-				 enum nl80211_channel_type channel_type)
-{
-	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_sub_if_data *sdata = NULL;
-
-	if (netdev)
-		sdata = IEEE80211_DEV_TO_SUB_IF(netdev);
-
-	switch (ieee80211_get_channel_mode(local, NULL)) {
-	case CHAN_MODE_HOPPING:
-		return -EBUSY;
-	case CHAN_MODE_FIXED:
-		if (local->oper_channel != chan)
-			return -EBUSY;
-		if (!sdata && local->_oper_channel_type == channel_type)
-			return 0;
-		break;
-	case CHAN_MODE_UNDEFINED:
-		break;
-	}
-
-	if (!ieee80211_set_channel_type(local, sdata, channel_type))
-		return -EBUSY;
-
-	local->oper_channel = chan;
-
-	/* auto-detects changes */
-	ieee80211_hw_config(local, 0);
-
-	return 0;
-}
 
 #ifdef CONFIG_PM
 static int ieee80211_suspend(struct wiphy *wiphy,


