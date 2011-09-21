Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35071 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1IUMgi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 08:36:38 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC 3/4] mac80211: add support to tx rate of mgmt frames from userspace
Date: Wed, 21 Sep 2011 18:06:59 +0530
Message-ID: <1316608620-16483-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110921_143641_866548_F7814C11)
In-Reply-To: <1316608620-16483-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316608620-16483-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to set the tx rate for management
frames when the rate was requested by user space apps and
the requested ratemask is stored in the skb's tx info.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/net/mac80211.h |    3 +--
 net/mac80211/cfg.c     |    4 +++-
 net/mac80211/tx.c      |    2 ++
 net/wireless/core.h    |    3 ++-
 net/wireless/mlme.c    |    5 +++--
 net/wireless/nl80211.c |   11 +++++++++--
 6 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9edba09..4f50614 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -518,8 +518,7 @@ struct ieee80211_tx_info {
 
 	u8 antenna_sel_tx;
 
-	/* 2 byte hole */
-	u8 pad[2];
+	u16 ratemask;
 
 	union {
 		struct {
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b57ddf9..e00678d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1869,7 +1869,8 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
 			     bool channel_type_valid, unsigned int wait,
-			     const u8 *buf, size_t len, u64 *cookie)
+			     const u8 *buf, size_t len, u32 ratemask,
+			     u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
@@ -1929,6 +1930,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	memcpy(skb_put(skb, len), buf, len);
 
 	IEEE80211_SKB_CB(skb)->flags = flags;
+	IEEE80211_SKB_CB(skb)->ratemask = ratemask;
 
 	skb->dev = sdata->dev;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 217735d..c6c718f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -630,6 +630,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	    tx->sdata->local->scan_req &&
 	    tx->sdata->local->scan_req->tx_ratemask)
 		txrc.rate_idx_mask = tx->sdata->local->scan_req->tx_ratemask;
+	else if (info->ratemask)
+		txrc.rate_idx_mask = info->ratemask;
 	else
 		txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask
 						[tx->channel->band];
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 796a4bd..eff7c1c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -375,7 +375,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, u64 *cookie);
+			  const u8 *buf, size_t len, u32 ratemask,
+			  u64 *cookie);
 
 /* SME */
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 61adea5..2074270 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -900,7 +900,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, u64 *cookie)
+			  const u8 *buf, size_t len, u32 ratemask,
+			  u64 *cookie)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	const struct ieee80211_mgmt *mgmt;
@@ -991,7 +992,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 	/* Transmit the Action frame as requested by user space */
 	return rdev->ops->mgmt_tx(&rdev->wiphy, dev, chan, offchan,
 				  channel_type, channel_type_valid,
-				  wait, buf, len, cookie);
+				  wait, buf, len, ratemask, cookie);
 }
 
 bool cfg80211_rx_mgmt(struct net_device *dev, int freq, const u8 *buf,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ce42efb..ce4e3af 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5190,7 +5190,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	struct ieee80211_channel *chan;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 	bool channel_type_valid = false;
-	u32 freq;
+	u32 freq, ratemask = 0;
 	int err;
 	void *hdr;
 	u64 cookie;
@@ -5233,6 +5233,13 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	offchan = info->attrs[NL80211_ATTR_OFFCHANNEL_TX_OK];
 
+	if (info->attrs[NL80211_ATTR_TX_MGMT_RATE]) {
+		u8 rate = nla_get_u8(info->attrs[NL80211_ATTR_TX_MGMT_RATE]);
+		ratemask = rateset_to_mask(
+					rdev->wiphy.bands[IEEE80211_BAND_2GHZ],
+					&rate, 1);
+	}
+
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
 	chan = rdev_freq_to_chan(rdev, freq, channel_type);
 	if (chan == NULL)
@@ -5253,7 +5260,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 				    channel_type_valid, wait,
 				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
 				    nla_len(info->attrs[NL80211_ATTR_FRAME]),
-				    &cookie);
+				    ratemask, &cookie);
 	if (err)
 		goto free_msg;
 
-- 
1.7.6.3

