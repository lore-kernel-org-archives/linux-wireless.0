Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:22560 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbdLMRv6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 12:51:58 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Sunil Dutt <usdutt@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH] cfg80211: Scan results to also report the per chain signal strength
Date: Wed, 13 Dec 2017 19:51:36 +0200
Message-ID: <1513187496-24017-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20171213_185202_973899_F135CB75)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sunil Dutt <usdutt@qti.qualcomm.com>

This commit enhances the scan results to report the per chain signal
strength based on the latest BSS update. This provides similar
information to what is already available through STA information.

Signed-off-by: Sunil Dutt <usdutt@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 8 ++++++++
 include/uapi/linux/nl80211.h | 3 +++
 net/wireless/nl80211.c       | 5 +++++
 net/wireless/scan.c          | 5 +++++
 4 files changed, 21 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fa1f575..c2b26a5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1773,6 +1773,8 @@ enum cfg80211_signal_type {
  *	by %parent_bssid.
  * @parent_bssid: the BSS according to which %parent_tsf is set. This is set to
  *	the BSS that requested the scan in which the beacon/probe was received.
+ * @chains: bitmask for filled values in @chain_signal.
+ * @chain_signal: per-chain signal strength of last received BSS in dBm.
  */
 struct cfg80211_inform_bss {
 	struct ieee80211_channel *chan;
@@ -1781,6 +1783,8 @@ struct cfg80211_inform_bss {
 	u64 boottime_ns;
 	u64 parent_tsf;
 	u8 parent_bssid[ETH_ALEN] __aligned(2);
+	u8 chains;
+	s8 chain_signal[IEEE80211_MAX_CHAINS];
 };
 
 /**
@@ -1824,6 +1828,8 @@ struct cfg80211_bss_ies {
  *	that holds the beacon data. @beacon_ies is still valid, of course, and
  *	points to the same data as hidden_beacon_bss->beacon_ies in that case.
  * @signal: signal strength value (type depends on the wiphy's signal_type)
+ * @chains: bitmask for filled values in @chain_signal.
+ * @chain_signal: per-chain signal strength of last received BSS in dBm.
  * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
  */
 struct cfg80211_bss {
@@ -1842,6 +1848,8 @@ struct cfg80211_bss {
 	u16 capability;
 
 	u8 bssid[ETH_ALEN];
+	u8 chains;
+	s8 chain_signal[IEEE80211_MAX_CHAINS];
 
 	u8 priv[0] __aligned(sizeof(void *));
 };
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e86edf0..6dd6939 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3888,6 +3888,8 @@ enum nl80211_bss_scan_width {
  *	@NL80211_BSS_PARENT_BSSID. (u64).
  * @NL80211_BSS_PARENT_BSSID: the BSS according to which @NL80211_BSS_PARENT_TSF
  *	is set.
+ * @NL80211_BSS_CHAIN_SIGNAL: per-chain signal strength of last BSS update.
+ *	Contains a nested array of signal strength attributes (u8, dBm).
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -3911,6 +3913,7 @@ enum nl80211_bss {
 	NL80211_BSS_PAD,
 	NL80211_BSS_PARENT_TSF,
 	NL80211_BSS_PARENT_BSSID,
+	NL80211_BSS_CHAIN_SIGNAL,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e920c3a..d9953bd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7840,6 +7840,11 @@ static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
 			      intbss->ts_boottime, NL80211_BSS_PAD))
 		goto nla_put_failure;
 
+	if (!nl80211_put_signal(msg, intbss->pub.chains,
+				intbss->pub.chain_signal,
+				NL80211_BSS_CHAIN_SIGNAL))
+		goto nla_put_failure;
+
 	switch (rdev->wiphy.signal_type) {
 	case CFG80211_SIGNAL_TYPE_MBM:
 		if (nla_put_u32(msg, NL80211_BSS_SIGNAL_MBM, res->signal))
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index f6c5fe48..d36c3eb 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -981,6 +981,9 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		found->ts = tmp->ts;
 		found->ts_boottime = tmp->ts_boottime;
 		found->parent_tsf = tmp->parent_tsf;
+		found->pub.chains = tmp->pub.chains;
+		memcpy(found->pub.chain_signal, tmp->pub.chain_signal,
+		       IEEE80211_MAX_CHAINS);
 		ether_addr_copy(found->parent_bssid, tmp->parent_bssid);
 	} else {
 		struct cfg80211_internal_bss *new;
@@ -1233,6 +1236,8 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	tmp.pub.capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 	tmp.ts_boottime = data->boottime_ns;
 	tmp.parent_tsf = data->parent_tsf;
+	tmp.pub.chains = data->chains;
+	memcpy(tmp.pub.chain_signal, data->chain_signal, IEEE80211_MAX_CHAINS);
 	ether_addr_copy(tmp.parent_bssid, data->parent_bssid);
 
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
-- 
2.7.4
