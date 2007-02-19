Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54731 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965115AbXBSWjW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:22 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 6/12] d80211: Make common function for frequency/channel selection
Message-Id: <20070219223951.E29EB484AC@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:51 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

This patch creates ieee80211_set_channel and moves the channel selection
and setting code in ieee80211_ioctl_siwfreq to this function. This allows
IBSS code in ieee80211_sta.c to set the channel without using the wireless
extensions interface.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 net/d80211/ieee80211_i.h     |    1 +
 net/d80211/ieee80211_ioctl.c |   47 ++++++++++++++++++++++--------------------
 net/d80211/ieee80211_sta.c   |   10 +--------
 3 files changed, 27 insertions(+), 31 deletions(-)

fe65044387a1a15d7304d1f19d104f4c54c8289d
diff --git a/net/d80211/ieee80211_i.h b/net/d80211/ieee80211_i.h
index 8bccd25..0ab20b3 100644
--- a/net/d80211/ieee80211_i.h
+++ b/net/d80211/ieee80211_i.h
@@ -660,6 +660,7 @@ #define CHAN_UTIL_HDR_SHORT (40 * CHAN_U
 int ieee80211_set_compression(struct ieee80211_local *local,
 			      struct net_device *dev, struct sta_info *sta);
 int ieee80211_init_client(struct net_device *dev);
+int ieee80211_set_channel(struct ieee80211_local *local, int channel, int freq);
 /* ieee80211_sta.c */
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
diff --git a/net/d80211/ieee80211_ioctl.c b/net/d80211/ieee80211_ioctl.c
index c7300cb..0a1a5eb 100644
--- a/net/d80211/ieee80211_ioctl.c
+++ b/net/d80211/ieee80211_ioctl.c
@@ -1794,35 +1794,18 @@ static int ieee80211_ioctl_giwmode(struc
 	return 0;
 }
 
-
-int ieee80211_ioctl_siwfreq(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_freq *freq, char *extra)
+int ieee80211_set_channel(struct ieee80211_local *local, int channel, int freq)
 {
-	struct ieee80211_local *local = dev->ieee80211_ptr;
 	struct ieee80211_hw_mode *mode;
-	int c, nfreq, set = 0;
-
-	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
-	if (freq->e == 0)
-		nfreq = -1;
-	else {
-		int i, div = 1000000;
-		for (i = 0; i < freq->e; i++)
-			div /= 10;
-		if (div > 0)
-			nfreq = freq->m / div;
-		else
-			return -EINVAL;
-	}
+	int c, set = 0;
 
 	list_for_each_entry(mode, &local->modes_list, list) {
+		if (!(local->enabled_modes & (1 << mode->mode)))
+			continue;
 		for (c = 0; c < mode->num_channels; c++) {
 			struct ieee80211_channel *chan = &mode->channels[c];
 			if (chan->flag & IEEE80211_CHAN_W_SCAN &&
-			    ((freq->e == 0 && chan->chan == freq->m) ||
-			     (freq->e > 0 && nfreq == chan->freq)) &&
-			    (local->enabled_modes & (1 << mode->mode))) {
+			    ((chan->chan == channel) || (chan->freq == freq))) {
 				/* Use next_mode as the mode preference to
 				 * resolve non-unique channel numbers. */
 				if (set && mode->mode != local->next_mode)
@@ -1845,6 +1828,26 @@ int ieee80211_ioctl_siwfreq(struct net_d
 	return -EINVAL;
 }
 
+static int ieee80211_ioctl_siwfreq(struct net_device *dev,
+				   struct iw_request_info *info,
+				   struct iw_freq *freq, char *extra)
+{
+	struct ieee80211_local *local = dev->ieee80211_ptr;
+
+	/* freq->e == 0: freq->m = channel; otherwise freq = m * 10^e */
+	if (freq->e == 0)
+		return ieee80211_set_channel(local, freq->m, -1);
+	else {
+		int i, div = 1000000;
+		for (i = 0; i < freq->e; i++)
+			div /= 10;
+		if (div > 0)
+			return ieee80211_set_channel(local, -1, freq->m / div);
+		else
+			return -EINVAL;
+	}
+}
+
 
 static int ieee80211_ioctl_giwfreq(struct net_device *dev,
 				   struct iw_request_info *info,
diff --git a/net/d80211/ieee80211_sta.c b/net/d80211/ieee80211_sta.c
index 439206d..07aa8b0 100644
--- a/net/d80211/ieee80211_sta.c
+++ b/net/d80211/ieee80211_sta.c
@@ -2004,16 +2004,11 @@ static void ieee80211_sta_new_auth(struc
 }
 
 
-extern int ieee80211_ioctl_siwfreq(struct net_device *dev,
-				   struct iw_request_info *info,
-				   struct iw_freq *freq, char *extra);
-
 static int ieee80211_sta_join_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_sta_bss *bss)
 {
 	struct ieee80211_local *local = dev->ieee80211_ptr;
-	struct iw_freq rq;
 	int res, rates, i, j;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -2041,10 +2036,7 @@ static int ieee80211_sta_join_ibss(struc
 	sdata->drop_unencrypted = bss->capability &
 		WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	memset(&rq, 0, sizeof(rq));
-	rq.m = bss->freq * 100000;
-	rq.e = 1;
-	res = ieee80211_ioctl_siwfreq(dev, NULL, &rq, NULL);
+	res = ieee80211_set_channel(local, -1, bss->freq);
 
 	if (!(local->oper_channel->flag & IEEE80211_CHAN_W_IBSS)) {
 		printk(KERN_DEBUG "%s: IBSS not allowed on channel %d "
-- 
1.3.0

