Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab0ESKRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 06:17:18 -0400
Subject: [PATCH] cfg80211: make action channel type optional
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 12:17:12 +0200
Message-ID: <1274264232.3874.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending action frames, we want to verify
that we do that on the correct channel. However,
checking the channel type in addition can get in
the way, since the channel type could change on
the fly during an association, and it's not
useful to have the channel type anyway since it
has no effect on the transmission. Therefore,
make it optional to specify so that if wanted,
it can still be checked, but is not required.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |    1 +
 net/mac80211/cfg.c         |    4 +++-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    9 ++++++---
 net/wireless/core.h        |    1 +
 net/wireless/mlme.c        |    3 ++-
 net/wireless/nl80211.c     |    3 +++
 7 files changed, 17 insertions(+), 5 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-05-19 11:49:06.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-05-19 11:56:14.000000000 +0200
@@ -1168,6 +1168,7 @@ struct cfg80211_ops {
 	int	(*action)(struct wiphy *wiphy, struct net_device *dev,
 			  struct ieee80211_channel *chan,
 			  enum nl80211_channel_type channel_type,
+			  bool channel_type_valid,
 			  const u8 *buf, size_t len, u64 *cookie);
 
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
--- wireless-testing.orig/net/mac80211/cfg.c	2010-05-19 11:50:05.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-05-19 11:57:48.000000000 +0200
@@ -1554,10 +1554,12 @@ static int ieee80211_cancel_remain_on_ch
 static int ieee80211_action(struct wiphy *wiphy, struct net_device *dev,
 			    struct ieee80211_channel *chan,
 			    enum nl80211_channel_type channel_type,
+			    bool channel_type_valid,
 			    const u8 *buf, size_t len, u64 *cookie)
 {
 	return ieee80211_mgd_action(IEEE80211_DEV_TO_SUB_IF(dev), chan,
-				    channel_type, buf, len, cookie);
+				    channel_type, channel_type_valid,
+				    buf, len, cookie);
 }
 
 struct cfg80211_ops mac80211_config_ops = {
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-05-19 11:50:19.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-05-19 11:57:53.000000000 +0200
@@ -989,6 +989,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 int ieee80211_mgd_action(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_channel *chan,
 			 enum nl80211_channel_type channel_type,
+			 bool channel_type_valid,
 			 const u8 *buf, size_t len, u64 *cookie);
 ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 					  struct sk_buff *skb);
--- wireless-testing.orig/net/mac80211/mlme.c	2010-05-19 11:50:25.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-05-19 11:58:43.000000000 +0200
@@ -2308,6 +2308,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 int ieee80211_mgd_action(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_channel *chan,
 			 enum nl80211_channel_type channel_type,
+			 bool channel_type_valid,
 			 const u8 *buf, size_t len, u64 *cookie)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -2315,9 +2316,11 @@ int ieee80211_mgd_action(struct ieee8021
 	struct sk_buff *skb;
 
 	/* Check that we are on the requested channel for transmission */
-	if ((chan != local->tmp_channel ||
-	     channel_type != local->tmp_channel_type) &&
-	    (chan != local->oper_channel ||
+	if (chan != local->tmp_channel &&
+	    chan != local->oper_channel)
+		return -EBUSY;
+	if (channel_type_valid &&
+	    (channel_type != local->tmp_channel_type &&
 	     channel_type != local->_oper_channel_type))
 		return -EBUSY;
 
--- wireless-testing.orig/net/wireless/core.h	2010-05-19 11:49:43.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2010-05-19 11:57:23.000000000 +0200
@@ -339,6 +339,7 @@ int cfg80211_mlme_action(struct cfg80211
 			 struct net_device *dev,
 			 struct ieee80211_channel *chan,
 			 enum nl80211_channel_type channel_type,
+			 bool channel_type_valid,
 			 const u8 *buf, size_t len, u64 *cookie);
 
 /* SME */
--- wireless-testing.orig/net/wireless/mlme.c	2010-05-19 11:49:51.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2010-05-19 11:57:07.000000000 +0200
@@ -827,6 +827,7 @@ int cfg80211_mlme_action(struct cfg80211
 			 struct net_device *dev,
 			 struct ieee80211_channel *chan,
 			 enum nl80211_channel_type channel_type,
+			 bool channel_type_valid,
 			 const u8 *buf, size_t len, u64 *cookie)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -855,7 +856,7 @@ int cfg80211_mlme_action(struct cfg80211
 
 	/* Transmit the Action frame as requested by user space */
 	return rdev->ops->action(&rdev->wiphy, dev, chan, channel_type,
-				 buf, len, cookie);
+				 channel_type_valid, buf, len, cookie);
 }
 
 bool cfg80211_rx_action(struct net_device *dev, int freq, const u8 *buf,
--- wireless-testing.orig/net/wireless/nl80211.c	2010-05-19 11:49:11.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2010-05-19 11:56:47.000000000 +0200
@@ -4681,6 +4681,7 @@ static int nl80211_action(struct sk_buff
 	struct net_device *dev;
 	struct ieee80211_channel *chan;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
+	bool channel_type_valid = false;
 	u32 freq;
 	int err;
 	void *hdr;
@@ -4722,6 +4723,7 @@ static int nl80211_action(struct sk_buff
 			err = -EINVAL;
 			goto out;
 		}
+		channel_type_valid = true;
 	}
 
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
@@ -4745,6 +4747,7 @@ static int nl80211_action(struct sk_buff
 		goto free_msg;
 	}
 	err = cfg80211_mlme_action(rdev, dev, chan, channel_type,
+				   channel_type_valid,
 				   nla_data(info->attrs[NL80211_ATTR_FRAME]),
 				   nla_len(info->attrs[NL80211_ATTR_FRAME]),
 				   &cookie);


