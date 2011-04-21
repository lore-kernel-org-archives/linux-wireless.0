Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:49875 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab1DTXzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 19:55:45 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] cfg80211: module_param to disable HT40 in 2.4GHz band
Date: Wed, 20 Apr 2011 17:00:02 -0700
Message-Id: <1303344002-4542-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

remove ieee80211_disable_40mhz_24ghz from mac80211;
add cfg80211_disable_40mhz_24ghz in cfg80211.

The symbol cfg80211_disable_40mhz_24ghz is exported so that
other modules can make use of it.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/net/cfg80211.h |    1 +
 net/mac80211/main.c    |   18 ------------------
 net/wireless/nl80211.c |   43 ++++++++++++++++++++++++++++++++-----------
 3 files changed, 33 insertions(+), 29 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d30eada..1cdc43e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1974,6 +1974,7 @@ extern int ieee80211_radiotap_iterator_next(
 
 extern const unsigned char rfc1042_header[6];
 extern const unsigned char bridge_tunnel_header[6];
+extern bool cfg80211_disable_40mhz_24ghz;
 
 /**
  * ieee80211_get_hdrlen_from_skb - get header length from data
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0ab2a8d..6187766 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -33,12 +33,6 @@
 #include "cfg.h"
 #include "debugfs.h"
 
-
-static bool ieee80211_disable_40mhz_24ghz;
-module_param(ieee80211_disable_40mhz_24ghz, bool, 0644);
-MODULE_PARM_DESC(ieee80211_disable_40mhz_24ghz,
-		 "Disable 40MHz support in the 2.4GHz band");
-
 static struct lock_class_key ieee80211_rx_skb_queue_class;
 
 void ieee80211_configure_filter(struct ieee80211_local *local)
@@ -728,18 +722,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		}
 		channels += sband->n_channels;
 
-		/*
-		 * Since ieee80211_disable_40mhz_24ghz is global, we can
-		 * modify the sband's ht data even if the driver uses a
-		 * global structure for that.
-		 */
-		if (ieee80211_disable_40mhz_24ghz &&
-		    band == IEEE80211_BAND_2GHZ &&
-		    sband->ht_cap.ht_supported) {
-			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-			sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
-		}
-
 		if (max_bitrates < sband->n_bitrates)
 			max_bitrates = sband->n_bitrates;
 		supp_ht = supp_ht || sband->ht_cap.ht_supported;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0efa7fd..f824d9f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -23,6 +23,12 @@
 #include "nl80211.h"
 #include "reg.h"
 
+bool cfg80211_disable_40mhz_24ghz;
+EXPORT_SYMBOL_GPL(cfg80211_disable_40mhz_24ghz);
+module_param(cfg80211_disable_40mhz_24ghz, bool, 0644);
+MODULE_PARM_DESC(cfg80211_disable_40mhz_24ghz,
+		 "Disable 40MHz support in the 2.4GHz band");
+
 static int nl80211_pre_doit(struct genl_ops *ops, struct sk_buff *skb,
 			    struct genl_info *info);
 static void nl80211_post_doit(struct genl_ops *ops, struct sk_buff *skb,
@@ -643,7 +649,10 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		goto nla_put_failure;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		if (!dev->wiphy.bands[band])
+		struct ieee80211_supported_band *sband;
+
+		sband = dev->wiphy.bands[band];
+		if (!sband)
 			continue;
 
 		nl_band = nla_nest_start(msg, band);
@@ -651,16 +660,28 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			goto nla_put_failure;
 
 		/* add HT info */
-		if (dev->wiphy.bands[band]->ht_cap.ht_supported) {
+		if (sband->ht_cap.ht_supported) {
 			NLA_PUT(msg, NL80211_BAND_ATTR_HT_MCS_SET,
-				sizeof(dev->wiphy.bands[band]->ht_cap.mcs),
-				&dev->wiphy.bands[band]->ht_cap.mcs);
+				sizeof(sband->ht_cap.mcs), &sband->ht_cap.mcs);
+
+			/*
+			 * Since cfg80211_disable_40mhz_24ghz is global, we can
+			 * modify the sband's ht data even if the driver uses a
+			 * global structure for that.
+			 */
+			if (cfg80211_disable_40mhz_24ghz &&
+					band == IEEE80211_BAND_2GHZ) {
+				sband->ht_cap.cap &=
+					~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+				sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
+			}
+
 			NLA_PUT_U16(msg, NL80211_BAND_ATTR_HT_CAPA,
-				dev->wiphy.bands[band]->ht_cap.cap);
+				sband->ht_cap.cap);
 			NLA_PUT_U8(msg, NL80211_BAND_ATTR_HT_AMPDU_FACTOR,
-				dev->wiphy.bands[band]->ht_cap.ampdu_factor);
+				sband->ht_cap.ampdu_factor);
 			NLA_PUT_U8(msg, NL80211_BAND_ATTR_HT_AMPDU_DENSITY,
-				dev->wiphy.bands[band]->ht_cap.ampdu_density);
+				sband->ht_cap.ampdu_density);
 		}
 
 		/* add frequencies */
@@ -668,12 +689,12 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		if (!nl_freqs)
 			goto nla_put_failure;
 
-		for (i = 0; i < dev->wiphy.bands[band]->n_channels; i++) {
+		for (i = 0; i < sband->n_channels; i++) {
 			nl_freq = nla_nest_start(msg, i);
 			if (!nl_freq)
 				goto nla_put_failure;
 
-			chan = &dev->wiphy.bands[band]->channels[i];
+			chan = &sband->channels[i];
 
 			if (nl80211_msg_put_channel(msg, chan))
 				goto nla_put_failure;
@@ -688,12 +709,12 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		if (!nl_rates)
 			goto nla_put_failure;
 
-		for (i = 0; i < dev->wiphy.bands[band]->n_bitrates; i++) {
+		for (i = 0; i < sband->n_bitrates; i++) {
 			nl_rate = nla_nest_start(msg, i);
 			if (!nl_rate)
 				goto nla_put_failure;
 
-			rate = &dev->wiphy.bands[band]->bitrates[i];
+			rate = &sband->bitrates[i];
 			NLA_PUT_U32(msg, NL80211_BITRATE_ATTR_RATE,
 				    rate->bitrate);
 			if (rate->flags & IEEE80211_RATE_SHORT_PREAMBLE)
-- 
1.7.0.2

