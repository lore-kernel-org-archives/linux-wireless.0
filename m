Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24242 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbYFEQz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 12:55:27 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 1/1] mac80211: Checking IBSS support while changing channel in ad-hoc mode
Date: Thu,  5 Jun 2008 19:55:21 +0300
Message-Id: <1212684921-14266-1-git-send-email-tomas.winkler@intel.com> (sfid-20080605_185531_281124_91D409B5)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Assaf Krauss <assaf.krauss@intel.com>

This patch adds a check to the set_channel flow. When attempting to change
the channel while in IBSS mode, and the new channel does not support IBSS
mode, the flow return with an error value with no consequences on the
mac80211 and driver state.

Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |   11 ++++-------
 net/mac80211/wext.c        |   15 +++++++++++----
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 432011c..751d479 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -853,7 +853,7 @@ u32 ieee80211_handle_ht(struct ieee80211_local *local, int enable_ht,
 
 /* ieee80211_ioctl.c */
 extern const struct iw_handler_def ieee80211_iw_handler_def;
-int ieee80211_set_freq(struct ieee80211_local *local, int freq);
+int ieee80211_set_freq(struct net_device *dev, int freq);
 /* ieee80211_sta.c */
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c220bed..bbf4b59 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2370,13 +2370,10 @@ static int ieee80211_sta_join_ibss(struct net_device *dev,
 	sdata->drop_unencrypted = bss->capability &
 		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	res = ieee80211_set_freq(local, bss->freq);
+	res = ieee80211_set_freq(dev, bss->freq);
 
-	if (local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS) {
-		printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
-		       "%d MHz\n", dev->name, local->oper_channel->center_freq);
-		return -1;
-	}
+	if (res)
+		return res;
 
 	/* Set beacon template */
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
@@ -3516,7 +3513,7 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 	spin_unlock_bh(&local->sta_bss_lock);
 
 	if (selected) {
-		ieee80211_set_freq(local, selected->freq);
+		ieee80211_set_freq(dev, selected->freq);
 		if (!(ifsta->flags & IEEE80211_STA_SSID_SET))
 			ieee80211_sta_set_ssid(dev, selected->ssid,
 					       selected->ssid_len);
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 1a35562..4806d96 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -302,14 +302,22 @@ static int ieee80211_ioctl_giwmode(struct net_device *dev,
 	return 0;
 }
 
-int ieee80211_set_freq(struct ieee80211_local *local, int freqMHz)
+int ieee80211_set_freq(struct net_device *dev, int freqMHz)
 {
 	int ret = -EINVAL;
 	struct ieee80211_channel *chan;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	chan = ieee80211_get_channel(local->hw.wiphy, freqMHz);
 
 	if (chan && !(chan->flags & IEEE80211_CHAN_DISABLED)) {
+		if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS &&
+		    chan->flags & IEEE80211_CHAN_NO_IBSS) {
+			printk(KERN_DEBUG "%s: IBSS not allowed on frequency "
+				"%d MHz\n", dev->name, chan->center_freq);
+			return ret;
+		}
 		local->oper_channel = chan;
 
 		if (local->sta_sw_scanning || local->sta_hw_scanning)
@@ -327,7 +335,6 @@ static int ieee80211_ioctl_siwfreq(struct net_device *dev,
 				   struct iw_request_info *info,
 				   struct iw_freq *freq, char *extra)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
@@ -341,14 +348,14 @@ static int ieee80211_ioctl_siwfreq(struct net_device *dev,
 					IEEE80211_STA_AUTO_CHANNEL_SEL;
 			return 0;
 		} else
-			return ieee80211_set_freq(local,
+			return ieee80211_set_freq(dev,
 				ieee80211_channel_to_frequency(freq->m));
 	} else {
 		int i, div = 1000000;
 		for (i = 0; i < freq->e; i++)
 			div /= 10;
 		if (div > 0)
-			return ieee80211_set_freq(local, freq->m / div);
+			return ieee80211_set_freq(dev, freq->m / div);
 		else
 			return -EINVAL;
 	}
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

