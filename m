Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53028 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727162AbeH1QLW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 12:11:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        Peng Xu <pxu@qti.qualcomm.com>,
        Sara Sharon <sara.sharon@intel.com>
Subject: [RFC 6/6] mac80211: declare support for multi-BSSID if driver supports it
Date: Tue, 28 Aug 2018 14:13:53 +0200
Message-Id: <20180828121353.11193-7-johannes@sipsolutions.net> (sfid-20180828_142001_702090_B75C2715)
In-Reply-To: <20180828121353.11193-1-johannes@sipsolutions.net>
References: <20180828121353.11193-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Turn on the multi-BSSID bit for supporting drivers.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 5 +++++
 include/net/mac80211.h    | 3 +++
 net/mac80211/debugfs.c    | 1 +
 net/mac80211/main.c       | 4 ++++
 4 files changed, 13 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 91378340bf4e..1267a8f0040a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2564,6 +2564,11 @@ enum ieee80211_tdls_actioncode {
  */
 #define WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING	BIT(2)
 
+/* Multiple BSSID capability is set in the 6th bit of 3rd byte of the
+ * @WLAN_EID_EXT_CAPABILITY information element
+ */
+#define WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT	BIT(6)
+
 /* TDLS capabilities in the the 4th byte of @WLAN_EID_EXT_CAPABILITY */
 #define WLAN_EXT_CAPA4_TDLS_BUFFER_STA		BIT(4)
 #define WLAN_EXT_CAPA4_TDLS_PEER_PSM		BIT(5)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 80ae58a35e73..75f4f3f67c3c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2173,6 +2173,8 @@ struct ieee80211_txq {
  *	The stack will not do fragmentation.
  *	The callback for @set_frag_threshold should be set as well.
  *
+ * @IEEE80211_HW_SUPPORTS_MULTI_BSSID: Hardware supports multi BSSID
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2215,6 +2217,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_FRAG_LIST,
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
+	IEEE80211_HW_SUPPORTS_MULTI_BSSID,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index d40ec17829a9..669fa78d1901 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -791,6 +791,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TX_FRAG_LIST),
 	FLAG(REPORTS_LOW_ACK),
 	FLAG(SUPPORTS_TX_FRAG),
+	FLAG(SUPPORTS_MULTI_BSSID),
 #undef FLAG
 };
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 7d7c1e7d1b5e..60e73dc74b63 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1070,6 +1070,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (ieee80211_hw_check(&local->hw, CHANCTX_STA_CSA))
 		local->ext_capa[0] |= WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING;
 
+	/* mac80211 supports multi BSSID, if the driver supports it */
+	if (ieee80211_hw_check(&local->hw, SUPPORTS_MULTI_BSSID))
+		local->ext_capa[2] |= WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT;
+
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
 
 	result = wiphy_register(local->hw.wiphy);
-- 
2.14.4
