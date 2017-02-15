Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59832 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751218AbdBOODA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 09:03:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 2/5] mac80211: introduce capability flags for VHT EXT NSS support
Date: Wed, 15 Feb 2017 15:02:53 +0100
Message-Id: <20170215140256.19455-2-johannes@sipsolutions.net> (sfid-20170215_150315_257692_E3A42F71)
In-Reply-To: <20170215140256.19455-1-johannes@sipsolutions.net>
References: <20170215140256.19455-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Depending on whether or not rate control supports selecting
rates depending on the bandwidth, we can use VHT extended
NSS support. In essence, this is dot11VHTExtendedNSSBWCapable
from the spec, since depending on that we'll need to parse
the bandwidth.

If needed, also set/clear the VHT Capability Element bit for
this capability so that we don't advertise it erroneously or
don't advertise it when we actually use it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     | 18 ++++++++++++++++
 net/mac80211/debugfs.c     |  1 +
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/main.c        | 52 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3edb469a6de1..9017feff1784 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2049,6 +2049,11 @@ struct ieee80211_txq {
  *	The stack will not do fragmentation.
  *	The callback for @set_frag_threshold should be set as well.
  *
+ * @IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW: (Hardware) rate control supports VHT
+ *	extended NSS BW (dot11VHTExtendedNSSBWCapable). This flag will be set if
+ *	the selected rate control algorithm sets %RATE_CTRL_CAPA_VHT_EXT_NSS_BW
+ *	but if the rate control is built-in then it must be set by the driver.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2091,6 +2096,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_FRAG_LIST,
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
+	IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -5464,7 +5470,19 @@ struct ieee80211_tx_rate_control {
 	bool bss;
 };
 
+/**
+ * enum rate_control_capabilities - rate control capabilities
+ */
+enum rate_control_capabilities {
+	/**
+	 * @RATE_CTRL_CAPA_VHT_EXT_NSS_BW:
+	 *	support for extended NSS BW support (dot11VHTExtendedNSSCapable)
+	 */
+	RATE_CTRL_CAPA_VHT_EXT_NSS_BW = BIT(0),
+};
+
 struct rate_control_ops {
+	unsigned long capa;
 	const char *name;
 	void *(*alloc)(struct ieee80211_hw *hw, struct dentry *debugfsdir);
 	void (*free)(void *priv);
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 5fae001f286c..a431514ea01c 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -211,6 +211,7 @@ static const char *hw_flag_names[] = {
 	FLAG(TX_FRAG_LIST),
 	FLAG(REPORTS_LOW_ACK),
 	FLAG(SUPPORTS_TX_FRAG),
+	FLAG(SUPPORTS_VHT_EXT_NSS_BW),
 #undef FLAG
 };
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 159a1a733725..4047fc528977 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1217,6 +1217,9 @@ struct ieee80211_local {
 	/* number of RX chains the hardware has */
 	u8 rx_chains;
 
+	/* bitmap of which sbands were copied */
+	u8 sband_allocated;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 56fb47953b72..b83a1e2ba002 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1095,6 +1095,51 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_rate;
 	}
 
+	if (local->rate_ctrl) {
+		clear_bit(IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW, hw->flags);
+		if (local->rate_ctrl->ops->capa & RATE_CTRL_CAPA_VHT_EXT_NSS_BW)
+			ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
+	}
+
+	/*
+	 * If the VHT capabilities don't have IEEE80211_VHT_EXT_NSS_BW_CAPABLE,
+	 * or have it when we don't, copy the sband structure and set/clear it.
+	 * This is necessary because rate scaling algorithms could be switched
+	 * and have different support values.
+	 * Print a message so that in the common case the reallocation can be
+	 * avoided.
+	 */
+	BUILD_BUG_ON(NUM_NL80211_BANDS > 8 * sizeof(local->sband_allocated));
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
+		struct ieee80211_supported_band *sband;
+		bool local_cap, ie_cap;
+
+		local_cap = ieee80211_hw_check(hw, SUPPORTS_VHT_EXT_NSS_BW);
+
+		sband = local->hw.wiphy->bands[band];
+		if (!sband || !sband->vht_cap.vht_supported)
+			continue;
+
+		ie_cap = !!(sband->vht_cap.vht_mcs.tx_highest &
+			    cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE));
+
+		if (local_cap == ie_cap)
+			continue;
+
+		sband = kmemdup(sband, sizeof(*sband), GFP_KERNEL);
+		if (!sband)
+			goto fail_rate;
+
+		wiphy_dbg(hw->wiphy, "copying sband (band %d) due to VHT EXT NSS BW flag\n",
+			  band);
+
+		sband->vht_cap.vht_mcs.tx_highest ^=
+			cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE);
+
+		local->hw.wiphy->bands[band] = sband;
+		local->sband_allocated |= BIT(band);
+	}
+
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
 	    !ieee80211_hw_check(hw, NO_AUTO_VIF)) {
@@ -1216,6 +1261,7 @@ static int ieee80211_free_ack_frame(int id, void *p, void *data)
 void ieee80211_free_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	enum nl80211_band band;
 
 	mutex_destroy(&local->iflist_mtx);
 	mutex_destroy(&local->mtx);
@@ -1231,6 +1277,12 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 
 	ieee80211_free_led_names(local);
 
+	for (band = 0; band < NUM_NL80211_BANDS; band++) {
+		if (!(local->sband_allocated & BIT(band)))
+			continue;
+		kfree(local->hw.wiphy->bands[band]);
+	}
+
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);
-- 
2.9.3
