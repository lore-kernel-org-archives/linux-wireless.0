Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7361 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbYGNSoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 14:44:20 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/2 V2] mac80211: pass dtim_period to low level driver
Date: Mon, 14 Jul 2008 21:44:00 +0300
Message-Id: <1216061040-954-1-git-send-email-tomas.winkler@intel.com> (sfid-20080714_204424_873369_9312569E)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds the dtim_period in ieee80211_bss_conf, this allows the low
level driver to know the dtim_period, and to plan power save accordingly.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/ieee80211.h  |   13 +++++++++++++
 include/net/mac80211.h     |    4 +++-
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   11 +++++++++++
 4 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a1630ba..7f4df7c 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -506,6 +506,19 @@ struct ieee80211_channel_sw_ie {
 	u8 count;
 } __attribute__ ((packed));
 
+/**
+ * struct ieee80211_tim
+ *
+ * This structure refers to "Traffic Indication Map information element"
+ */
+struct ieee80211_tim_ie {
+	u8 dtim_count;
+	u8 dtim_period;
+	u8 bitmap_ctrl;
+	/* variable size: 1 - 251 bytes */
+	u8 virtual_map[0];
+} __attribute__ ((packed));
+
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 656442c..ae8199e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -177,9 +177,10 @@ enum ieee80211_bss_change {
  * @aid: association ID number, valid only when @assoc is true
  * @use_cts_prot: use CTS protection
  * @use_short_preamble: use 802.11b short preamble
+ * @dtim_period: num of beacons before the next DTIM, for PSM
  * @timestamp: beacon timestamp
  * @beacon_int: beacon interval
- * @assoc_capability: capabbilities taken from assoc resp
+ * @assoc_capability: capabilities taken from assoc resp
  * @assoc_ht: association in HT mode
  * @ht_conf: ht capabilities
  * @ht_bss_conf: ht extended capabilities
@@ -191,6 +192,7 @@ struct ieee80211_bss_conf {
 	/* erp related data */
 	bool use_cts_prot;
 	bool use_short_preamble;
+	u8 dtim_period;
 	u16 beacon_int;
 	u16 assoc_capability;
 	u64 timestamp;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c916c2f..c36e1e3 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -81,6 +81,7 @@ struct ieee80211_sta_bss {
 
 	u8 bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 dtim_period;
 	u16 capability; /* host byte order */
 	enum ieee80211_band band;
 	int freq;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 00b7186..116facb 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -551,6 +551,7 @@ static void ieee80211_set_associated(struct net_device *dev,
 			/* set timing information */
 			sdata->bss_conf.beacon_int = bss->beacon_int;
 			sdata->bss_conf.timestamp = bss->timestamp;
+			sdata->bss_conf.dtim_period = bss->dtim_period;
 
 			changed |= ieee80211_handle_bss_capability(sdata, bss);
 
@@ -2741,6 +2742,16 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 	bss->beacon_int = le16_to_cpu(mgmt->u.beacon.beacon_int);
 	bss->capability = le16_to_cpu(mgmt->u.beacon.capab_info);
 
+	if (elems->tim) {
+		struct ieee80211_tim_ie *tim_ie =
+			(struct ieee80211_tim_ie *)elems->tim;
+		bss->dtim_period = tim_ie->dtim_period;
+	}
+
+	/* set default value for bugy APs */
+	if (!elems->tim || bss->dtim_period == 0)
+		bss->dtim_period = 1;
+
 	bss->supp_rates_len = 0;
 	if (elems->supp_rates) {
 		clen = IEEE80211_MAX_SUPP_RATES - bss->supp_rates_len;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

