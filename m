Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54786 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbbKWS14 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:27:56 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	=?UTF-8?q?Jan=20Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>,
	Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH v2 5/8] cfg80211: Add support for OCB-only channels
Date: Mon, 23 Nov 2015 19:27:18 +0100
Message-Id: <1448303241-27747-6-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192810_015203_959DA591)
In-Reply-To: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't want channels designated for Intelligent Transportation Systems
to be used in other modes than OCB. We therefore introduce regulatory
and channel flags that prevent scanning (for performance reasons) and
beaconing on these channels.

Although regulatory documents do not talk about which modes to use, we
limit the mode to OCB in order to prevent accidental use of the band by
other applications.

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/chan.c          |  6 ++++--
 net/wireless/ibss.c          | 12 ++++++++----
 net/wireless/mesh.c          |  3 ++-
 net/wireless/nl80211.c       | 12 ++++++------
 net/wireless/reg.c           |  2 ++
 net/wireless/scan.c          |  4 ++--
 net/wireless/sme.c           |  3 ++-
 net/wireless/wext-sme.c      |  3 ++-
 10 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2c7bdb8..b47ac3e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -117,6 +117,7 @@ enum ieee80211_band {
  *	on this channel.
  * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
  *	on this channel.
+ * @IEEE80211_CHAN_OCB_ONLY: only OCB mode is allowed on this channel.
  *
  */
 enum ieee80211_channel_flags {
@@ -133,6 +134,7 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_IR_CONCURRENT	= 1<<10,
 	IEEE80211_CHAN_NO_20MHZ		= 1<<11,
 	IEEE80211_CHAN_NO_10MHZ		= 1<<12,
+	IEEE80211_CHAN_OCB_ONLY		= 1<<13,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1f0b4cf..07e6105 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2865,6 +2865,7 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_NO_HT40PLUS: channels can't be used in HT40+ operation
  * @NL80211_RRF_NO_80MHZ: 80MHz operation not allowed
  * @NL80211_RRF_NO_160MHZ: 160MHz operation not allowed
+ * @NL80211_RRF_OCB_ONLY: only OCB mode can be used here
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2882,6 +2883,7 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_HT40PLUS		= 1<<14,
 	NL80211_RRF_NO_80MHZ		= 1<<15,
 	NL80211_RRF_NO_160MHZ		= 1<<16,
+	NL80211_RRF_OCB_ONLY		= 1<<17,
 };
 
 #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 59cabc9..b1ab77a 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -804,7 +804,8 @@ static bool _cfg80211_reg_can_beacon(struct wiphy *wiphy,
 {
 	bool res;
 	u32 prohibited_flags = IEEE80211_CHAN_DISABLED |
-			       IEEE80211_CHAN_RADAR;
+			       IEEE80211_CHAN_RADAR |
+			       IEEE80211_CHAN_OCB_ONLY;
 
 	trace_cfg80211_reg_can_beacon(wiphy, chandef, iftype, check_no_ir);
 
@@ -814,7 +815,8 @@ static bool _cfg80211_reg_can_beacon(struct wiphy *wiphy,
 	if (cfg80211_chandef_dfs_required(wiphy, chandef, iftype) > 0 &&
 	    cfg80211_chandef_dfs_available(wiphy, chandef)) {
 		/* We can skip IEEE80211_CHAN_NO_IR if chandef dfs available */
-		prohibited_flags = IEEE80211_CHAN_DISABLED;
+		prohibited_flags = IEEE80211_CHAN_DISABLED |
+				   IEEE80211_CHAN_OCB_ONLY;
 	}
 
 	res = cfg80211_chandef_usable(wiphy, chandef, prohibited_flags);
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 4c55fab..d9df7f0 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -258,9 +258,9 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 
 			for (i = 0; i < sband->n_channels; i++) {
 				chan = &sband->channels[i];
-				if (chan->flags & IEEE80211_CHAN_NO_IR)
-					continue;
-				if (chan->flags & IEEE80211_CHAN_DISABLED)
+				if (chan->flags & IEEE80211_CHAN_NO_IR ||
+				    chan->flags & IEEE80211_CHAN_DISABLED ||
+				    chan->flags & IEEE80211_CHAN_OCB_ONLY)
 					continue;
 				new_chan = chan;
 				break;
@@ -277,6 +277,9 @@ int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 					NL80211_CHAN_NO_HT);
 	}
 
+	if (wdev->wext.ibss.chandef.chan->flags & IEEE80211_CHAN_OCB_ONLY)
+		return -EINVAL;
+
 	/* don't join -- SSID is not there */
 	if (!wdev->wext.ibss.ssid_len)
 		return 0;
@@ -331,7 +334,8 @@ int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 		if (!chan)
 			return -EINVAL;
 		if (chan->flags & IEEE80211_CHAN_NO_IR ||
-		    chan->flags & IEEE80211_CHAN_DISABLED)
+		    chan->flags & IEEE80211_CHAN_DISABLED ||
+		    chan->flags & IEEE80211_CHAN_OCB_ONLY)
 			return -EINVAL;
 	}
 
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 092300b..99866ff 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -143,7 +143,8 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 				chan = &sband->channels[i];
 				if (chan->flags & (IEEE80211_CHAN_NO_IR |
 						   IEEE80211_CHAN_DISABLED |
-						   IEEE80211_CHAN_RADAR))
+						   IEEE80211_CHAN_RADAR |
+						   IEEE80211_CHAN_OCB_ONLY))
 					continue;
 				setup->chandef.chan = chan;
 				break;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c71e274..85b1df6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5860,8 +5860,8 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 				goto out_free;
 			}
 
-			/* ignore disabled channels */
-			if (chan->flags & IEEE80211_CHAN_DISABLED)
+			/* ignore disabled and OCB-only channels */
+			if (chan->flags & (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_OCB_ONLY))
 				continue;
 
 			request->channels[i] = chan;
@@ -5880,7 +5880,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 				chan = &wiphy->bands[band]->channels[j];
 
-				if (chan->flags & IEEE80211_CHAN_DISABLED)
+				if (chan->flags & (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_OCB_ONLY))
 					continue;
 
 				request->channels[i] = chan;
@@ -6247,8 +6247,8 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 				goto out_free;
 			}
 
-			/* ignore disabled channels */
-			if (chan->flags & IEEE80211_CHAN_DISABLED)
+			/* ignore disabled and OCB-only channels */
+			if (chan->flags & (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_OCB_ONLY))
 				continue;
 
 			request->channels[i] = chan;
@@ -6265,7 +6265,7 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 				chan = &wiphy->bands[band]->channels[j];
 
-				if (chan->flags & IEEE80211_CHAN_DISABLED)
+				if (chan->flags & (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_OCB_ONLY))
 					continue;
 
 				request->channels[i] = chan;
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 35eaeeb..8b7110d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1048,6 +1048,8 @@ static u32 map_regdom_flags(u32 rd_flags)
 		channel_flags |= IEEE80211_CHAN_NO_80MHZ;
 	if (rd_flags & NL80211_RRF_NO_160MHZ)
 		channel_flags |= IEEE80211_CHAN_NO_160MHZ;
+	if (rd_flags & NL80211_RRF_OCB_ONLY)
+		channel_flags |= IEEE80211_CHAN_OCB_ONLY;
 	return channel_flags;
 }
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 14d5369..67e4515 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1236,9 +1236,9 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 			continue;
 
 		for (j = 0; j < wiphy->bands[band]->n_channels; j++) {
-			/* ignore disabled channels */
+			/* ignore disabled and OCB-only channels */
 			if (wiphy->bands[band]->channels[j].flags &
-						IEEE80211_CHAN_DISABLED)
+			    (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_OCB_ONLY))
 				continue;
 
 			/* If we have a wireless request structure and the
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 8020b5b..817c879 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -103,7 +103,8 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 				continue;
 			for (j = 0; j < bands->n_channels; j++) {
 				channel = &bands->channels[j];
-				if (channel->flags & IEEE80211_CHAN_DISABLED)
+				if (channel->flags & IEEE80211_CHAN_DISABLED ||
+				    channel->flags & IEEE80211_CHAN_OCB_ONLY)
 					continue;
 				request->channels[i++] = channel;
 			}
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index a4e8af3..34a50c1 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -83,7 +83,8 @@ int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
 		chan = ieee80211_get_channel(wdev->wiphy, freq);
 		if (!chan)
 			return -EINVAL;
-		if (chan->flags & IEEE80211_CHAN_DISABLED)
+		if (chan->flags & IEEE80211_CHAN_DISABLED ||
+		    chan->flags & IEEE80211_CHAN_OCB_ONLY)
 			return -EINVAL;
 	}
 
-- 
2.5.3

