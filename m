Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbYIJWJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:09:56 -0400
Message-Id: <20080910220417.428823000@sipsolutions.net> (sfid-20080911_000959_300434_27F66ADF)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/18] mac80211: move ieee80211_set_freq to utils
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It really doesn't belong into the wireless extensions code.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/util.c        |   28 ++++++++++++++++++++++++++++
 net/mac80211/wext.c        |   28 ----------------------------
 3 files changed, 29 insertions(+), 29 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-10 23:57:59.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-10 23:58:00.000000000 +0200
@@ -893,7 +893,6 @@ void ieee80211_bss_info_change_notify(st
 
 /* wireless extensions */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
-int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 
 /* STA/IBSS code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
@@ -1008,6 +1007,7 @@ void ieee80211_tx_skb(struct ieee80211_s
 		      int encrypt);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
+int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freq);
 
 #ifdef CONFIG_MAC80211_NOINLINE
 #define debug_noinline noinline
--- everything.orig/net/mac80211/util.c	2008-09-10 23:50:26.000000000 +0200
+++ everything/net/mac80211/util.c	2008-09-10 23:58:00.000000000 +0200
@@ -612,3 +612,31 @@ void ieee80211_tx_skb(struct ieee80211_s
 
 	dev_queue_xmit(skb);
 }
+
+int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
+{
+	int ret = -EINVAL;
+	struct ieee80211_channel *chan;
+	struct ieee80211_local *local = sdata->local;
+
+	chan = ieee80211_get_channel(local->hw.wiphy, freqMHz);
+
+	if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
+		if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
+		    chan->flags & IEEE80211_CHAN_NO_IBSS) {
+			printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
+				"%d MHz\n", sdata->dev->name, chan->center_freq);
+			return ret;
+		}
+		local->oper_channel = chan;
+
+		if (local->sta_sw_scanning || local->sta_hw_scanning)
+			ret = 0;
+		else
+			ret = ieee80211_hw_config(local);
+
+		rate_control_clear(local);
+	}
+
+	return ret;
+}
--- everything.orig/net/mac80211/wext.c	2008-09-10 23:50:27.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-09-10 23:58:00.000000000 +0200
@@ -330,34 +330,6 @@ static int ieee80211_ioctl_giwmode(struc
 	return 0;
 }
 
-int ieee80211_set_freq(struct ieee80211_sub_if_data *sdata, int freqMHz)
-{
-	int ret = -EINVAL;
-	struct ieee80211_channel *chan;
-	struct ieee80211_local *local = sdata->local;
-
-	chan = ieee80211_get_channel(local->hw.wiphy, freqMHz);
-
-	if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
-		if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
-		    chan->flags & IEEE80211_CHAN_NO_IBSS) {
-			printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
-				"%d MHz\n", sdata->dev->name, chan->center_freq);
-			return ret;
-		}
-		local->oper_channel = chan;
-
-		if (local->sta_sw_scanning || local->sta_hw_scanning)
-			ret = 0;
-		else
-			ret = ieee80211_hw_config(local);
-
-		rate_control_clear(local);
-	}
-
-	return ret;
-}
-
 static int ieee80211_ioctl_siwfreq(struct net_device *dev,
 				   struct iw_request_info *info,
 				   struct iw_freq *freq, char *extra)

-- 

