Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38931 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab1IUMga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 08:36:30 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC 2/4] mac80211: add tx_ratemask support to scan request
Date: Wed, 21 Sep 2011 18:06:58 +0530
Message-ID: <1316608620-16483-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110921_143633_917280_0E51A217)
In-Reply-To: <1316608620-16483-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316608620-16483-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the requested rate for probe request sent during the scan.
In this way, we can restrict the 11b rates not to be used
for the p2p probes before the p2p group is formed.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/net/cfg80211.h |    4 ++-
 net/mac80211/tx.c      |    8 ++++++-
 net/wireless/nl80211.c |   55 +++++++++++++++++++++++++++---------------------
 3 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ccfdf3f..425a8d2 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -860,6 +860,7 @@ struct cfg80211_ssid {
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @aborted: (internal) scan request was notified as aborted
+ * @tx_ratemask: (internal) used to send probe request at the given rate
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -874,6 +875,7 @@ struct cfg80211_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	bool aborted;
+	u32 tx_ratemask;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
@@ -1560,7 +1562,7 @@ struct cfg80211_ops {
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, u64 *cookie);
+			  const u8 *buf, size_t len, u32 ratemask, u64 *cookie);
 	int	(*mgmt_tx_cancel_wait)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       u64 cookie);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 7cd6c28..217735d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -626,7 +626,13 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	txrc.bss_conf = &tx->sdata->vif.bss_conf;
 	txrc.skb = tx->skb;
 	txrc.reported_rate.idx = -1;
-	txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[tx->channel->band];
+	if (ieee80211_is_probe_req(hdr->frame_control) &&
+	    tx->sdata->local->scan_req &&
+	    tx->sdata->local->scan_req->tx_ratemask)
+		txrc.rate_idx_mask = tx->sdata->local->scan_req->tx_ratemask;
+	else
+		txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask
+						[tx->channel->band];
 	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
 		txrc.max_rate_idx = -1;
 	else
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a4ab044..ce42efb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3461,6 +3461,30 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	return n_channels;
 }
 
+static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
+			   u8 *rates, u8 rates_len)
+{
+	u8 i;
+	u32 mask = 0;
+
+	for (i = 0; i < rates_len; i++) {
+		int rate = (rates[i] & 0x7f) * 5;
+		int ridx;
+		for (ridx = 0; ridx < sband->n_bitrates; ridx++) {
+			struct ieee80211_rate *srate =
+				&sband->bitrates[ridx];
+			if (rate == srate->bitrate) {
+				mask |= 1 << ridx;
+				break;
+			}
+		}
+		if (ridx == sband->n_bitrates)
+			return 0; /* rate not found */
+	}
+
+	return mask;
+}
+
 static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -3621,6 +3645,13 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_TX_MGMT_RATE]) {
+		u8 rate = nla_get_u8(info->attrs[NL80211_ATTR_TX_MGMT_RATE]);
+		request->tx_ratemask = rateset_to_mask(
+					rdev->wiphy.bands[IEEE80211_BAND_2GHZ],
+					&rate, 1);
+	}
+
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 
@@ -5064,30 +5095,6 @@ static int nl80211_cancel_remain_on_channel(struct sk_buff *skb,
 	return rdev->ops->cancel_remain_on_channel(&rdev->wiphy, dev, cookie);
 }
 
-static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
-			   u8 *rates, u8 rates_len)
-{
-	u8 i;
-	u32 mask = 0;
-
-	for (i = 0; i < rates_len; i++) {
-		int rate = (rates[i] & 0x7f) * 5;
-		int ridx;
-		for (ridx = 0; ridx < sband->n_bitrates; ridx++) {
-			struct ieee80211_rate *srate =
-				&sband->bitrates[ridx];
-			if (rate == srate->bitrate) {
-				mask |= 1 << ridx;
-				break;
-			}
-		}
-		if (ridx == sband->n_bitrates)
-			return 0; /* rate not found */
-	}
-
-	return mask;
-}
-
 static const struct nla_policy nl80211_txattr_policy[NL80211_TXRATE_MAX + 1] = {
 	[NL80211_TXRATE_LEGACY] = { .type = NLA_BINARY,
 				    .len = NL80211_MAX_SUPP_RATES },
-- 
1.7.6.3

