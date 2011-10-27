Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1J0Tcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 15:32:55 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RJVh8-0005p2-Kt
	for linux-wireless@vger.kernel.org; Thu, 27 Oct 2011 21:32:54 +0200
Subject: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not wait
 for ACK
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <20111021142322.229128720@sipsolutions.net> (sfid-20111021_162510_209354_8FBBB6EB)
References: <20111021142322.229128720@sipsolutions.net>
	 (sfid-20111021_162510_209354_8FBBB6EB)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 21:32:53 +0200
Message-ID: <1319743973.32221.4.camel@jlt3.sipsolutions.net> (sfid-20111027_213258_839064_E81CD577)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For probe responses it can be useful to not wait for ACK
to save airtime, so allow userspace to request not waiting
with a new nl80211 flag.

Since mac80211 needs to be updated for the new function
prototype anyway implement it right away -- it's just a
few lines of code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 +-
 include/linux/nl80211.h                    |    7 ++++
 include/net/cfg80211.h                     |    2 -
 net/mac80211/cfg.c                         |   11 +++++--
 net/wireless/core.h                        |    2 -
 net/wireless/mlme.c                        |    5 ++-
 net/wireless/nl80211.c                     |   43 +++++++++++++++++------------
 7 files changed, 48 insertions(+), 25 deletions(-)

--- a/include/linux/nl80211.h	2011-10-27 21:08:01.000000000 +0200
+++ b/include/linux/nl80211.h	2011-10-27 21:13:13.000000000 +0200
@@ -1147,6 +1147,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_FEATURE_FLAGS: This u32 attribute contains flags from
  *	&enum nl80211_feature_flags and is advertised in wiphy information.
  *
+ * @NL80211_ATTR_DONT_WAIT_FOR_ACK: Used with %NL80211_CMD_FRAME, this tells
+ *	the driver to not wait for an acknowledgement. Note that due to this,
+ *	it will also not give a status callback nor return a cookie. This is
+ *	mostly useful for probe responses to save airtime.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1379,6 +1384,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_FEATURE_FLAGS,
 
+	NL80211_ATTR_DONT_WAIT_FOR_ACK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- a/net/wireless/core.h	2011-10-27 21:08:01.000000000 +0200
+++ b/net/wireless/core.h	2011-10-27 21:12:23.000000000 +0200
@@ -378,7 +378,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg8021
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, bool no_cck,
-			  u64 *cookie);
+			  bool dont_wait_for_ack, u64 *cookie);
 
 /* SME */
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
--- a/net/wireless/mlme.c	2011-10-27 21:08:01.000000000 +0200
+++ b/net/wireless/mlme.c	2011-10-27 21:13:52.000000000 +0200
@@ -904,7 +904,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg8021
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, bool no_cck,
-			  u64 *cookie)
+			  bool dont_wait_for_ack, u64 *cookie)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	const struct ieee80211_mgmt *mgmt;
@@ -995,7 +995,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg8021
 	/* Transmit the Action frame as requested by user space */
 	return rdev->ops->mgmt_tx(&rdev->wiphy, dev, chan, offchan,
 				  channel_type, channel_type_valid,
-				  wait, buf, len, no_cck, cookie);
+				  wait, buf, len, no_cck, dont_wait_for_ack,
+				  cookie);
 }
 
 bool cfg80211_rx_mgmt(struct net_device *dev, int freq, const u8 *buf,
--- a/net/wireless/nl80211.c	2011-10-27 21:08:01.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-10-27 21:14:45.000000000 +0200
@@ -197,6 +197,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_TDLS_OPERATION] = { .type = NLA_U8 },
 	[NL80211_ATTR_TDLS_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_TDLS_EXTERNAL_SETUP] = { .type = NLA_FLAG },
+	[NL80211_ATTR_DONT_WAIT_FOR_ACK] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -5279,10 +5280,11 @@ static int nl80211_tx_mgmt(struct sk_buf
 	int err;
 	void *hdr;
 	u64 cookie;
-	struct sk_buff *msg;
+	struct sk_buff *msg = NULL;
 	unsigned int wait = 0;
-	bool offchan;
-	bool no_cck;
+	bool offchan, no_cck, dont_wait_for_ack;
+
+	dont_wait_for_ack = info->attrs[NL80211_ATTR_DONT_WAIT_FOR_ACK];
 
 	if (!info->attrs[NL80211_ATTR_FRAME] ||
 	    !info->attrs[NL80211_ATTR_WIPHY_FREQ])
@@ -5326,29 +5328,36 @@ static int nl80211_tx_mgmt(struct sk_buf
 	if (chan == NULL)
 		return -EINVAL;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return -ENOMEM;
-
-	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
-			     NL80211_CMD_FRAME);
-
-	if (IS_ERR(hdr)) {
-		err = PTR_ERR(hdr);
-		goto free_msg;
+	if (!dont_wait_for_ack) {
+		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+		if (!msg)
+			return -ENOMEM;
+
+		hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+				     NL80211_CMD_FRAME);
+
+		if (IS_ERR(hdr)) {
+			err = PTR_ERR(hdr);
+			goto free_msg;
+		}
 	}
+
 	err = cfg80211_mlme_mgmt_tx(rdev, dev, chan, offchan, channel_type,
 				    channel_type_valid, wait,
 				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
 				    nla_len(info->attrs[NL80211_ATTR_FRAME]),
-				    no_cck, &cookie);
+				    no_cck, dont_wait_for_ack, &cookie);
 	if (err)
 		goto free_msg;
 
-	NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, cookie);
+	if (msg) {
+		NLA_PUT_U64(msg, NL80211_ATTR_COOKIE, cookie);
 
-	genlmsg_end(msg, hdr);
-	return genlmsg_reply(msg, info);
+		genlmsg_end(msg, hdr);
+		return genlmsg_reply(msg, info);
+	}
+
+	return 0;
 
  nla_put_failure:
 	err = -ENOBUFS;
--- a/include/net/cfg80211.h	2011-10-27 21:08:01.000000000 +0200
+++ b/include/net/cfg80211.h	2011-10-27 21:15:55.000000000 +0200
@@ -1584,7 +1584,7 @@ struct cfg80211_ops {
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, bool no_cck,
-			  u64 *cookie);
+			  bool dont_wait_for_ack, u64 *cookie);
 	int	(*mgmt_tx_cancel_wait)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       u64 cookie);
--- a/net/mac80211/cfg.c	2011-10-27 21:08:01.000000000 +0200
+++ b/net/mac80211/cfg.c	2011-10-27 21:23:44.000000000 +0200
@@ -1936,7 +1936,7 @@ static int ieee80211_mgmt_tx(struct wiph
 			     enum nl80211_channel_type channel_type,
 			     bool channel_type_valid, unsigned int wait,
 			     const u8 *buf, size_t len, bool no_cck,
-			     u64 *cookie)
+			     bool dont_wait_for_ack, u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -1944,10 +1944,15 @@ static int ieee80211_mgmt_tx(struct wiph
 	struct sta_info *sta;
 	struct ieee80211_work *wk;
 	const struct ieee80211_mgmt *mgmt = (void *)buf;
-	u32 flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
-		    IEEE80211_TX_CTL_REQ_TX_STATUS;
+	u32 flags;
 	bool is_offchan = false;
 
+	if (!dont_wait_for_ack)
+		flags = IEEE80211_TX_CTL_NO_ACK;
+	else
+		flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
+			IEEE80211_TX_CTL_REQ_TX_STATUS;
+
 	/* Check that we are on the requested channel for transmission */
 	if (chan != local->tmp_channel &&
 	    chan != local->oper_channel)
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c	2011-10-12 19:22:47.000000000 +0200
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c	2011-10-27 21:21:11.000000000 +0200
@@ -1732,7 +1732,8 @@ static int ath6kl_mgmt_tx(struct wiphy *
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, bool no_cck, u64 *cookie)
+			  const u8 *buf, size_t len, bool no_cck,
+			  bool dont_wait_for_ack, u64 *cookie)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
 	u32 id;


