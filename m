Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29273 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbbHOTkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 15:40:13 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/9] mac80211: debugfs: add file to disallow TDLS wider-bw
Date: Sat, 15 Aug 2015 22:39:46 +0300
Message-Id: <1439667594-13632-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150815_214025_793256_B5AC0261)
In-Reply-To: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439667594-13632-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Sometimes we are interested in testing TDLS performance in a specific
width setting. Add the ability to disable the wider-band feature, thereby
allowing the TDLS channel width to be controlled by the BSS width.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c            |  1 +
 net/mac80211/debugfs_netdev.c | 29 +++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h    |  1 +
 net/mac80211/tdls.c           |  4 +++-
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 685ec13..1ca972e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1156,6 +1156,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		set_sta_flag(sta, WLAN_STA_TDLS_CHAN_SWITCH);
 
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
+	    !sdata->u.mgd.tdls_wider_bw_prohibited &&
 	    ieee80211_hw_check(&local->hw, TDLS_WIDER_BW) &&
 	    params->ext_capab_len >= 8 &&
 	    params->ext_capab[7] & WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED)
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 1021e87..f1580e9 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -455,6 +455,34 @@ static ssize_t ieee80211_if_parse_uapsd_max_sp_len(
 }
 IEEE80211_IF_FILE_RW(uapsd_max_sp_len);
 
+static ssize_t ieee80211_if_fmt_tdls_wider_bw(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	const struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	bool tdls_wider_bw;
+
+	tdls_wider_bw = ieee80211_hw_check(&sdata->local->hw, TDLS_WIDER_BW) &&
+			!ifmgd->tdls_wider_bw_prohibited;
+
+	return snprintf(buf, buflen, "%d\n", tdls_wider_bw);
+}
+
+static ssize_t ieee80211_if_parse_tdls_wider_bw(
+	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	ifmgd->tdls_wider_bw_prohibited = !val;
+	return buflen;
+}
+IEEE80211_IF_FILE_RW(tdls_wider_bw);
+
 /* AP attributes */
 IEEE80211_IF_FILE(num_mcast_sta, u.ap.num_mcast_sta, ATOMIC);
 IEEE80211_IF_FILE(num_sta_ps, u.ap.ps.num_sta_ps, ATOMIC);
@@ -614,6 +642,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD_MODE(beacon_loss, 0200);
 	DEBUGFS_ADD_MODE(uapsd_queues, 0600);
 	DEBUGFS_ADD_MODE(uapsd_max_sp_len, 0600);
+	DEBUGFS_ADD_MODE(tdls_wider_bw, 0600);
 }
 
 static void add_ap_files(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6e52659..65f4faa 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -535,6 +535,7 @@ struct ieee80211_if_managed {
 	struct sk_buff *teardown_skb; /* A copy to send through the AP */
 	spinlock_t teardown_lock; /* To lock changing teardown_skb */
 	bool tdls_chan_switch_prohibited;
+	bool tdls_wider_bw_prohibited;
 
 	/* WMM-AC TSPEC support */
 	struct ieee80211_sta_tx_tspec tx_tspec[IEEE80211_NUM_ACS];
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index aee701a..1bacea7 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -41,9 +41,11 @@ static void ieee80211_tdls_add_ext_capab(struct ieee80211_sub_if_data *sdata,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool chan_switch = local->hw.wiphy->features &
 			   NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
-	bool wider_band = ieee80211_hw_check(&local->hw, TDLS_WIDER_BW);
+	bool wider_band = ieee80211_hw_check(&local->hw, TDLS_WIDER_BW) &&
+			  !ifmgd->tdls_wider_bw_prohibited;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
 	bool vht = sband && sband->vht_cap.vht_supported;
-- 
2.1.4

