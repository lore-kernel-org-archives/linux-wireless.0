Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43608 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753836AbdBNNWO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:22:14 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com,
        Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 5/7] mac80211: introduce capability flags for VHT EXT NSS support
Date: Tue, 14 Feb 2017 14:22:06 +0100
Message-Id: <20170214132208.8715-6-johannes@sipsolutions.net> (sfid-20170214_142239_372422_DBAD4523)
In-Reply-To: <20170214132208.8715-1-johannes@sipsolutions.net>
References: <20170214132208.8715-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Depending on whether or not rate control supports selecting
rates depending on the bandwidth, we can use VHT extended
NSS support. In essence, this is dot11VHTExtendedNSSBWCapable
from the spec, since depending on that we'll need to parse
the bandwidth.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 18 ++++++++++++++++++
 net/mac80211/debugfs.c |  1 +
 net/mac80211/main.c    |  6 ++++++
 3 files changed, 25 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b9a08cd1d97d..68f90180a470 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2043,6 +2043,11 @@ struct ieee80211_txq {
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
@@ -2085,6 +2090,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_TX_FRAG_LIST,
 	IEEE80211_HW_REPORTS_LOW_ACK,
 	IEEE80211_HW_SUPPORTS_TX_FRAG,
+	IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -5458,7 +5464,19 @@ struct ieee80211_tx_rate_control {
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
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 56fb47953b72..91e2faf174dd 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1095,6 +1095,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_rate;
 	}
 
+	if (local->rate_ctrl) {
+		clear_bit(IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW, hw->flags);
+		if (local->rate_ctrl->ops->capa & RATE_CTRL_CAPA_VHT_EXT_NSS_BW)
+			ieee80211_hw_set(hw, SUPPORTS_VHT_EXT_NSS_BW);
+	}
+
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
 	    !ieee80211_hw_check(hw, NO_AUTO_VIF)) {
-- 
2.9.3
