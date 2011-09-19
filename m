Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32982 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab1ISRz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 13:55:29 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: make use of supported rates for probe requests
Date: Mon, 19 Sep 2011 23:26:06 +0530
Message-ID: <1316454966-1746-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110919_195533_318847_938BC197)
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
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/rate.c        |   10 ++++++++++
 net/mac80211/scan.c        |    9 ++++++++-
 3 files changed, 19 insertions(+), 1 deletions(-)

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
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3d5a2cb..f4380f6 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -328,6 +328,16 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	 * the common case.
 	 */
 	mask = sdata->rc_rateidx_mask[info->band];
+	/*
+	 * Filter out rates that are not supported for mlme frames.
+	 * These rates are set defined from supported rates attribute
+	 * during scan start.
+	 */
+	if (local->scanning &&
+	    local->mlme_supp_rates[info->band] &&
+	    rc_no_data_or_no_ack(txrc))
+		mask &= local->mlme_supp_rates[info->band];
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

