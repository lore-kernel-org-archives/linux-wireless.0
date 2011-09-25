Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37946 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1IYJWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Sep 2011 05:22:55 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 1/2] nl80211/cfg80211: Add support to disable CCK rate for management frame
Date: Sun, 25 Sep 2011 14:53:30 +0530
Message-ID: <1316942611-2053-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110925_112258_878506_0ED2D211)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a new nl80211 attribute to specify whether to send the management
frames in CCK rate or not. As of now the wpa_supplicant is disabling
CCK rate at P2P init itself. So this patch helps to send P2P probe
request/probe response/action frames being sent at non CCK rate in 2GHz
without disabling 11b rates.

This attribute is used with NL80211_CMD_TRIGGER_SCAN and
NL80211_CMD_FRAME commands to disable CCK rate for management frame
transmission.

Cc: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/linux/nl80211.h |   13 +++++++++++++
 include/net/cfg80211.h  |    5 ++++-
 net/mac80211/cfg.c      |    3 ++-
 net/wireless/core.h     |    3 ++-
 net/wireless/mlme.c     |    5 +++--
 net/wireless/nl80211.c  |    9 ++++++++-
 6 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 460b12a..c73582f 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -238,6 +238,8 @@
  *
  * @NL80211_CMD_GET_SCAN: get scan results
  * @NL80211_CMD_TRIGGER_SCAN: trigger a new scan with the given parameters
+ *	%NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether to send the
+ *	probe requests at CCK rate or not.
  * @NL80211_CMD_NEW_SCAN_RESULTS: scan notification (as a reply to
  *	NL80211_CMD_GET_SCAN and on the "scan" multicast group)
  * @NL80211_CMD_SCAN_ABORTED: scan was aborted, for unspecified reasons,
@@ -432,6 +434,8 @@
  *	specified using %NL80211_ATTR_DURATION. When called, this operation
  *	returns a cookie (%NL80211_ATTR_COOKIE) that will be included with the
  *	TX status event pertaining to the TX request.
+ *	%NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether to send the
+ *	management frames at CCK rate or not in 2GHz band.
  * @NL80211_CMD_FRAME_WAIT_CANCEL: When an off-channel TX was requested, this
  *	command may be used with the corresponding cookie to cancel the wait
  *	time if it is known that it is no longer necessary.
@@ -1078,6 +1082,13 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMKSA_CANDIDATE: Nested attribute containing the PMKSA caching
  *	candidate information, see &enum nl80211_pmksa_candidate_attr.
  *
+ * @NL80211_ATTR_TX_NO_CCK_RATE: Indicates whether to use CCK rate or not
+ *	for management frames transmission. In order to avoid p2p probe/action
+ *	frames are being transmitted at CCK rate in 2GHz band, the user space
+ *	applications use this attribute.
+ *	This attribute is used with %NL80211_CMD_TRIGGER_SCAN and
+ *	%NL80211_CMD_FRAME commands.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1298,6 +1309,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PMKSA_CANDIDATE,
 
+	NL80211_ATTR_TX_NO_CCK_RATE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ccfdf3f..c1dd56b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -860,6 +860,7 @@ struct cfg80211_ssid {
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @aborted: (internal) scan request was notified as aborted
+ * @no_cck: used to send probe requests at non CCK rate in 2GHz band
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -874,6 +875,7 @@ struct cfg80211_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	bool aborted;
+	bool no_cck;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
@@ -1560,7 +1562,8 @@ struct cfg80211_ops {
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, u64 *cookie);
+			  const u8 *buf, size_t len, bool no_cck,
+			  u64 *cookie);
 	int	(*mgmt_tx_cancel_wait)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       u64 cookie);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b57ddf9..9cba010 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1869,7 +1869,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
 			     bool channel_type_valid, unsigned int wait,
-			     const u8 *buf, size_t len, u64 *cookie)
+			     const u8 *buf, size_t len, bool no_cck,
+			     u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 796a4bd..a472d60 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -375,7 +375,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, u64 *cookie);
+			  const u8 *buf, size_t len, bool no_cck,
+			  u64 *cookie);
 
 /* SME */
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 61adea5..21fc970 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -900,7 +900,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, u64 *cookie)
+			  const u8 *buf, size_t len, bool no_cck,
+			  u64 *cookie)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	const struct ieee80211_mgmt *mgmt;
@@ -991,7 +992,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 	/* Transmit the Action frame as requested by user space */
 	return rdev->ops->mgmt_tx(&rdev->wiphy, dev, chan, offchan,
 				  channel_type, channel_type_valid,
-				  wait, buf, len, cookie);
+				  wait, buf, len, no_cck, cookie);
 }
 
 bool cfg80211_rx_mgmt(struct net_device *dev, int freq, const u8 *buf,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c26a1da..eba88c7e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -191,6 +191,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_ROAM_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_SCHED_SCAN_MATCH] = { .type = NLA_NESTED },
+	[NL80211_ATTR_TX_NO_CCK_RATE] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -3620,6 +3621,9 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	request->no_cck =
+		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
+
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 
@@ -5192,6 +5196,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	struct sk_buff *msg;
 	unsigned int wait = 0;
 	bool offchan;
+	bool no_cck;
 
 	if (!info->attrs[NL80211_ATTR_FRAME] ||
 	    !info->attrs[NL80211_ATTR_WIPHY_FREQ])
@@ -5228,6 +5233,8 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	offchan = info->attrs[NL80211_ATTR_OFFCHANNEL_TX_OK];
 
+	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
+
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 	chan = rdev_freq_to_chan(rdev, freq, channel_type);
 	if (chan == NULL)
@@ -5248,7 +5255,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 				    channel_type_valid, wait,
 				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
 				    nla_len(info->attrs[NL80211_ATTR_FRAME]),
-				    &cookie);
+				    no_cck, &cookie);
 	if (err)
 		goto free_msg;
 
-- 
1.7.6.3

