Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20396 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1ITGWi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 02:22:38 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC v2] mac80211: make use of supported rates for probe requests
Date: Tue, 20 Sep 2011 11:53:14 +0530
Message-ID: <1316499794-5979-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110920_082242_033391_ECCD6EA0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The supported rates on scan trigger helps to send the probe
request frames on non-11b rates for p2p. For the drivers that
have rate control on hw like ath9k_htc, this approch does not
work. So for those drivers wpa_supplicant should set tx rate
mask to disable 11b rates.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/cfg.c         |   13 +++++++++++++
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/offchannel.c  |    1 +
 net/mac80211/rate.c        |    9 +++++++++
 net/mac80211/scan.c        |    9 ++++++++-
 5 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b57ddf9..2d9384e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1880,6 +1880,9 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	u32 flags = IEEE80211_TX_INTFL_NL80211_FRAME_TX |
 		    IEEE80211_TX_CTL_REQ_TX_STATUS;
 	bool is_offchan = false;
+	struct ieee802_11_elems elems;
+	struct ieee80211_mgmt *hdr;
+	size_t baselen;
 
 	/* Check that we are on the requested channel for transmission */
 	if (chan != local->tmp_channel &&
@@ -1934,6 +1937,15 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 
 	*cookie = (unsigned long) skb;
 
+	hdr = (struct ieee80211_mgmt *) skb->data;
+	baselen = (u8 *) hdr->u.probe_resp.variable - (u8 *) hdr;
+	if (baselen < len) {
+		ieee802_11_parse_elems(hdr->u.probe_resp.variable,
+				       len - baselen, &elems);
+		local->mlme_supp_rates[chan->band] =
+			ieee80211_sta_get_rates(local, &elems, chan->band);
+	}
+
 	if (is_offchan && local->ops->remain_on_channel) {
 		unsigned int duration;
 		int ret;
@@ -1986,6 +1998,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 	 */
 	if (!is_offchan && !wait && !sdata->vif.bss_conf.idle) {
 		ieee80211_tx_skb(sdata, skb);
+		local->mlme_supp_rates[chan->band] = 0;
 		return 0;
 	}
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 21186e2..de63284 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -879,6 +879,7 @@ struct ieee80211_local {
 	enum ieee80211_band hw_scan_band;
 	int scan_channel_idx;
 	int scan_ies_len;
+	u32 mlme_supp_rates[IEEE80211_NUM_BANDS];
 
 	bool sched_scanning;
 	struct ieee80211_sched_scan_ies sched_scan_ies;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 13427b1..b15cc3d 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -216,6 +216,7 @@ static void ieee80211_hw_roc_start(struct work_struct *work)
 	if (local->hw_roc_skb) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(local->hw_roc_dev);
 		ieee80211_tx_skb(sdata, local->hw_roc_skb);
+		local->mlme_supp_rates[local->hw_roc_channel->band] = 0;
 		local->hw_roc_skb = NULL;
 	} else {
 		cfg80211_ready_on_channel(local->hw_roc_dev,
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3d5a2cb..98f4216 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -328,6 +328,15 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	 * the common case.
 	 */
 	mask = sdata->rc_rateidx_mask[info->band];
+	/*
+	 * Filter out rates that are not supported for mlme frames.
+	 * These rates are set defined from supported rates attribute
+	 * during scan start.
+	 */
+	if (sdata->local->mlme_supp_rates[info->band] &&
+	    rc_no_data_or_no_ack(txrc))
+		mask &= sdata->local->mlme_supp_rates[info->band];
+
 	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
 		if (sta) {
 			/* Filter out rates that the STA does not support */
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 6f09eca..1d0048d 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -264,6 +264,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 	struct ieee80211_local *local = hw_to_local(hw);
 	bool on_oper_chan;
 	bool enable_beacons = false;
+	int i;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -295,6 +296,8 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 
 	local->scanning = 0;
 	local->scan_channel = NULL;
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		local->mlme_supp_rates[i] = 0;
 
 	on_oper_chan = ieee80211_cfg_on_oper_channel(local);
 
@@ -382,7 +385,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_scan_request *req)
 {
 	struct ieee80211_local *local = sdata->local;
-	int rc;
+	int rc, i;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -427,6 +430,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 	local->scan_req = req;
 	local->scan_sdata = sdata;
+	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+		local->mlme_supp_rates[i] = req->rates[i];
 
 	if (local->ops->hw_scan)
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
@@ -450,6 +455,8 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		local->scan_req = NULL;
 		local->scan_sdata = NULL;
+		for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+			local->mlme_supp_rates[i] = 0;
 	}
 
 	return rc;
-- 
1.7.6.1

