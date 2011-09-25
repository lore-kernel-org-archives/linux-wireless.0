Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14988 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1IYJY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Sep 2011 05:24:29 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 2/2] mac80211: Send the management frame at requested rate
Date: Sun, 25 Sep 2011 14:53:31 +0530
Message-ID: <1316942611-2053-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110925_112433_931026_C8CC5169)
In-Reply-To: <1316942611-2053-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316942611-2053-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever the scan request or tx_mgmt is requesting not to
use CCK rate for managemet frames through
NL80211_ATTR_TX_NO_CCK_RATE attribute, then mac80211 should
select appropriate least non-CCK rate. This could help to
send P2P probes and P2P action frames at non 11b rates
without diabling 11b rates globally.

Cc: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 include/net/mac80211.h     |    4 ++++
 net/mac80211/cfg.c         |    3 +++
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/mlme.c        |    2 +-
 net/mac80211/rate.c        |   29 ++++++++++++++++++++++++++++-
 net/mac80211/scan.c        |    3 ++-
 net/mac80211/util.c        |    8 ++++++--
 net/mac80211/work.c        |    2 +-
 8 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c0f63fd..b8a0df6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -363,6 +363,9 @@ struct ieee80211_bss_conf {
  * @IEEE80211_TX_INTFL_TKIP_MIC_FAILURE: Marks this packet to be used for TKIP
  *	testing. It will be sent out with incorrect Michael MIC key to allow
  *	TKIP countermeasures to be tested.
+ * @IEEE80211_TX_CTL_NO_CCK_RATE: This frame will be sent at non CCK rate.
+ *	This flag is actually used for management frame especially for P2P
+ *	frames not being sent at CCK rate in 2GHz band.
  *
  * Note: If you have to add new flags to the enumeration, then don't
  *	 forget to update %IEEE80211_TX_TEMPORARY_FLAGS when necessary.
@@ -393,6 +396,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTL_STBC			= BIT(23) | BIT(24),
 	IEEE80211_TX_CTL_TX_OFFCHAN		= BIT(25),
 	IEEE80211_TX_INTFL_TKIP_MIC_FAILURE	= BIT(26),
+	IEEE80211_TX_CTL_NO_CCK_RATE		= BIT(27),
 };
 
 #define IEEE80211_TX_CTL_STBC_SHIFT		23
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 9cba010..56c3504 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1897,6 +1897,9 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 		flags |= IEEE80211_TX_CTL_TX_OFFCHAN;
 	}
 
+	if (no_cck)
+		flags |= IEEE80211_TX_CTL_NO_CCK_RATE;
+
 	if (is_offchan && !offchan)
 		return -EBUSY;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 21186e2..4822d69 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1324,7 +1324,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
-			      u32 ratemask, bool directed);
+			      u32 ratemask, bool directed, bool no_cck);
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1a59fb6..cc80d32 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1239,7 +1239,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	} else {
 		ssid = ieee80211_bss_get_ie(ifmgd->associated, WLAN_EID_SSID);
 		ieee80211_send_probe_req(sdata, dst, ssid + 2, ssid[1], NULL, 0,
-					 (u32) -1, true);
+					 (u32) -1, true, false);
 	}
 
 	ifmgd->probe_send_count++;
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 3d5a2cb..f61244c 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -233,6 +233,27 @@ static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
 	/* could not find a basic rate; use original selection */
 }
 
+static inline s8
+rate_lowest_non_cck_index(struct ieee80211_supported_band *sband,
+			  struct ieee80211_sta *sta)
+{
+	int i;
+
+	for (i = 0; i < sband->n_bitrates; i++) {
+		struct ieee80211_rate *srate = &sband->bitrates[i];
+		if ((srate->bitrate == 10) || (srate->bitrate == 20) ||
+		    (srate->bitrate == 55) || (srate->bitrate == 110))
+			continue;
+
+		if (rate_supported(sta, sband->band, i))
+			return i;
+	}
+
+	/* No matching rate found */
+	return 0;
+}
+
+
 bool rate_control_send_low(struct ieee80211_sta *sta,
 			   void *priv_sta,
 			   struct ieee80211_tx_rate_control *txrc)
@@ -242,7 +263,13 @@ bool rate_control_send_low(struct ieee80211_sta *sta,
 	int mcast_rate;
 
 	if (!sta || !priv_sta || rc_no_data_or_no_ack(txrc)) {
-		info->control.rates[0].idx = rate_lowest_index(txrc->sband, sta);
+		if ((sband->band != IEEE80211_BAND_2GHZ) ||
+		    !(info->flags & IEEE80211_TX_CTL_NO_CCK_RATE))
+			info->control.rates[0].idx =
+				rate_lowest_index(txrc->sband, sta);
+		else
+			info->control.rates[0].idx =
+				rate_lowest_non_cck_index(txrc->sband, sta);
 		info->control.rates[0].count =
 			(info->flags & IEEE80211_TX_CTL_NO_ACK) ?
 			1 : txrc->hw->max_rate_tries;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 6f09eca..830e60f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -660,7 +660,8 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 			local->scan_req->ssids[i].ssid,
 			local->scan_req->ssids[i].ssid_len,
 			local->scan_req->ie, local->scan_req->ie_len,
-			local->scan_req->rates[band], false);
+			local->scan_req->rates[band], false,
+			local->scan_req->no_cck);
 
 	/*
 	 * After sending probe requests, wait for probe responses
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4b1466d..ead345d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -899,14 +899,18 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len,
-			      u32 ratemask, bool directed)
+			      u32 ratemask, bool directed, bool no_cck)
 {
 	struct sk_buff *skb;
 
 	skb = ieee80211_build_probe_req(sdata, dst, ratemask, ssid, ssid_len,
 					ie, ie_len, directed);
-	if (skb)
+	if (skb) {
+		if (no_cck)
+			IEEE80211_SKB_CB(skb)->flags |=
+				IEEE80211_TX_CTL_NO_CCK_RATE;
 		ieee80211_tx_skb(sdata, skb);
+	}
 }
 
 u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index bac3439..af374fa 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -458,7 +458,7 @@ ieee80211_direct_probe(struct ieee80211_work *wk)
 	 */
 	ieee80211_send_probe_req(sdata, NULL, wk->probe_auth.ssid,
 				 wk->probe_auth.ssid_len, NULL, 0,
-				 (u32) -1, true);
+				 (u32) -1, true, false);
 
 	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
 	run_again(local, wk->timeout);
-- 
1.7.6.3

