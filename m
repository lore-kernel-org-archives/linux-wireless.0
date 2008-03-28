Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbYC1Xdy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:33:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>
Subject: [PATCH 3/4] mac80211: add association capabilty and timing info into bss_conf
Date: Fri, 28 Mar 2008 16:33:34 -0700
Message-Id: <1206747215-10640-4-git-send-email-reinette.chatre@intel.com> (sfid-20080328_233357_338034_CC7B7E1C)
In-Reply-To: <1206747215-10640-3-git-send-email-reinette.chatre@intel.com>
References: <1206747215-10640-1-git-send-email-reinette.chatre@intel.com>
 <1206747215-10640-2-git-send-email-reinette.chatre@intel.com>
 <1206747215-10640-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds assocation capability, timestamp (tsf) and beacon interval
to bss_conf. This is required for successful assocation of iwlwifi drivers

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
---
 include/net/mac80211.h       |    6 ++++++
 net/mac80211/ieee80211_sta.c |    9 ++++++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dddc69b..cd1865f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -211,6 +211,9 @@ enum ieee80211_bss_change {
  * @aid: association ID number, valid only when @assoc is true
  * @use_cts_prot: use CTS protection
  * @use_short_preamble: use 802.11b short preamble
+ * @timestamp: beacon timestamp
+ * @beacon_int: beacon interval
+ * @assoc_capability: capabbilities taken from assoc resp
  * @assoc_ht: association in HT mode
  * @ht_conf: ht capabilities
  * @ht_bss_conf: ht extended capabilities
@@ -222,6 +225,9 @@ struct ieee80211_bss_conf {
 	/* erp related data */
 	bool use_cts_prot;
 	bool use_short_preamble;
+	u16 beacon_int;
+	u16 assoc_capability;
+	u64 timestamp;
 	/* ht related data */
 	bool assoc_ht;
 	struct ieee80211_ht_info *ht_conf;
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 59d1060..fbae79f 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -511,9 +511,14 @@ static void ieee80211_set_associated(struct net_device *dev,
 					   conf->channel->center_freq,
 					   ifsta->ssid, ifsta->ssid_len);
 		if (bss) {
+			/* set timing information */
+			sdata->bss_conf.beacon_int = bss->beacon_int;
+			sdata->bss_conf.timestamp = bss->timestamp;
+
 			if (bss->has_erp_value)
 				changed |= ieee80211_handle_erp_ie(
 						sdata, bss->erp_value);
+
 			ieee80211_rx_bss_put(dev, bss);
 		}
 
@@ -2037,8 +2042,10 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	} else
 		rcu_read_unlock();
 
-	/* set AID, ieee80211_set_associated() will tell the driver */
+	/* set AID and assoc capability,
+	 * ieee80211_set_associated() will tell the driver */
 	bss_conf->aid = aid;
+	bss_conf->assoc_capability = capab_info;
 	ieee80211_set_associated(dev, ifsta, 1);
 
 	ieee80211_associated(dev, ifsta);
-- 
1.5.3.4

