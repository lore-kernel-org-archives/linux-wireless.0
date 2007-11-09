Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37704 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbXKIICU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 03:02:20 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 03/14] mac80211: adding 802.11n HT framework definitions
Date: Fri,  9 Nov 2007 10:01:55 +0200
Message-Id: <11945953312367-git-send-email-ron.rindjunsky@intel.com> (sfid-20071109_081156_176145_DECB4D18)
In-Reply-To: <11945953312850-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New structures:
 - ieee80211_ht_info: describing STA's HT capabilities
 - ieee80211_ht_bss_info: describing BSS's HT characteristics
Changed structures:
 - ieee80211_hw_mode: now also holds PHY HT capabilities for each HW mode
 - ieee80211_conf: ht_conf holds current self HT configuration
		   ht_bss_conf holds current BSS HT configuration
 - flag IEEE80211_CONF_SUPPORT_HT_MODE added to indicate if HT use is
   desired
 - sta_info: now also holds Peer's HT capabilities

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 include/net/mac80211.h  |   61 +++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/sta_info.h |    5 ++++
 2 files changed, 62 insertions(+), 4 deletions(-)

Index: wl2_6_24_HT/include/net/mac80211.h
===================================================================
--- wl2_6_24_HT.orig/include/net/mac80211.h
+++ wl2_6_24_HT/include/net/mac80211.h
@@ -138,18 +138,59 @@ enum ieee80211_phymode {
 	NUM_IEEE80211_MODES
 };
 
+#ifdef CONFIG_MAC80211_HT
+
+/**
+ * struct ieee80211_ht_info - describing STA's HT capabilities
+ *
+ * This structure describes most essential parameters needed
+ * to describe 802.11n HT capabilities for an STA.
+ *
+ * @ht_supported: is HT supported by STA, 0: no, 1: yes
+ * @cap: HT capabilities map as described in 802.11n spec
+ * @ampdu_factor: Maximum A-MPDU length factor
+ * @ampdu_density: Minimum A-MPDU spacing
+ * @supp_mcs_set: Supported MCS set as described in 802.11n spec
+ */
+struct ieee80211_ht_info {
+	u8 ht_supported;
+	u16 cap; /* use IEEE80211_HT_CAP_ */
+	u8 ampdu_factor;
+	u8 ampdu_density;
+	u8 supp_mcs_set[16];
+};
+
+/**
+ * struct ieee80211_ht_bss_info - describing BSS's HT characteristics
+ *
+ * This structure describes most essential parameters needed
+ * to describe 802.11n HT characteristics in a BSS
+ *
+ * @primary_channel: channel number of primery channel
+ * @bss_cap: 802.11n's general BSS capabilities (e.g. channel width)
+ * @bss_op_mode: 802.11n's BSS operation modes (e.g. HT protection)
+ */
+struct ieee80211_ht_bss_info {
+	u8 primary_channel;
+	u8 bss_cap;  /* use IEEE80211_HT_IE_CHA_ */
+	u8 bss_op_mode; /* use IEEE80211_HT_IE_ */
+};
+
+#endif	/* CONFIG_MAC80211_HT */
+
 /**
  * struct ieee80211_hw_mode - PHY mode definition
  *
  * This structure describes the capabilities supported by the device
  * in a single PHY mode.
  *
+ * @list: internal
+ * @channels: pointer to array of supported channels
+ * @rates: pointer to array of supported bitrates
  * @mode: the PHY mode for this definition
  * @num_channels: number of supported channels
- * @channels: pointer to array of supported channels
  * @num_rates: number of supported bitrates
- * @rates: pointer to array of supported bitrates
- * @list: internal
+ * @ht_info: PHY's 802.11n HT abilities for this mode
  */
 struct ieee80211_hw_mode {
 	struct list_head list;
@@ -158,6 +199,9 @@ struct ieee80211_hw_mode {
 	enum ieee80211_phymode mode;
 	int num_channels;
 	int num_rates;
+#ifdef CONFIG_MAC80211_HT
+	struct ieee80211_ht_info ht_info;
+#endif /* CONFIG_MAC80211_HT */
 };
 
 /**
@@ -406,11 +450,14 @@ struct ieee80211_tx_status {
  *
  * @IEEE80211_CONF_SHORT_SLOT_TIME: use 802.11g short slot time
  * @IEEE80211_CONF_RADIOTAP: add radiotap header at receive time (if supported)
- *
+ * @IEEE80211_CONF_SUPPORT_HT_MODE: use 802.11n HT capabilities (if supported)
  */
 enum ieee80211_conf_flags {
 	IEEE80211_CONF_SHORT_SLOT_TIME	= 1<<0,
 	IEEE80211_CONF_RADIOTAP		= 1<<1,
+#ifdef CONFIG_MAC80211_HT
+	IEEE80211_CONF_SUPPORT_HT_MODE	= 1<<2,
+#endif /* CONFIG_MAC80211_HT */
 };
 
 /**
@@ -434,6 +481,8 @@ enum ieee80211_conf_flags {
  * @antenna_sel_tx: transmit antenna selection, 0: default/diversity,
  *	1/2: antenna 0/1
  * @antenna_sel_rx: receive antenna selection, like @antenna_sel_tx
+ * @ht_conf: describes current self configuration of 802.11n HT capabilies
+ * @ht_bss_conf: describes current BSS configuration of 802.11n HT parameters
  */
 struct ieee80211_conf {
 	int channel;			/* IEEE 802.11 channel number */
@@ -452,6 +501,10 @@ struct ieee80211_conf {
 	u8 antenna_max;
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
+#ifdef CONFIG_MAC80211_HT
+	struct ieee80211_ht_info ht_conf;
+	struct ieee80211_ht_bss_info ht_bss_conf;
+#endif /* CONFIG_MAC80211_HT */
 };
 
 /**
Index: wl2_6_24_HT/net/mac80211/sta_info.h
===================================================================
--- wl2_6_24_HT.orig/net/mac80211/sta_info.h
+++ wl2_6_24_HT/net/mac80211/sta_info.h
@@ -99,6 +99,11 @@ struct sta_info {
 
 	u16 listen_interval;
 
+#ifdef CONFIG_MAC80211_HT
+	struct ieee80211_ht_info ht_info; /* 802.11n HT capabilities
+					     of this STA */
+#endif /* CONFIG_MAC80211_HT */
+
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct sta_info_debugfsdentries {
 		struct dentry *dir;
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
