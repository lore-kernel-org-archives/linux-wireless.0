Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45572 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727207AbeHaNEc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 09:04:32 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Fri, 31 Aug 2018 11:31:17 +0300
Message-Id: <20180831083130.15525-16-luca@coelho.fi> (sfid-20180831_105820_586080_DC66B8DF)
In-Reply-To: <20180831083130.15525-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
Subject: [PATCH 15/28] mac80211: introduce capability flags for VHT EXT NSS support
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
 include/net/mac80211.h     | 22 ++++++++++++++++
 net/mac80211/debugfs.c     |  1 +
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/main.c        | 53 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 06e596215abc..02d251ea0126 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2143,6 +2143,12 @@ struct ieee80211_txq {
  * @IEEE80211_HW_BUFF_MMPDU_TXQ: use the TXQ for bufferable MMPDUs, this of
  *	course requires the driver to use TXQs to start with.
  *
+ * @IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW: (Hardware) rate control supports VHT
+ *	extended NSS BW (dot11VHTExtendedNSSBWCapable). This flag will be set if
+ *	the selected rate control algorithm sets %RATE_CTRL_CAPA_VHT_EXT_NSS_BW
+ *	but if the rate control is built-in then it must be set by the driver.
+ *	See also the documentation for that flag.
+ *
  * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing arrays
  */
 enum ieee80211_hw_flags {
@@ -2189,6 +2195,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_DEAUTH_NEED_MGD_TX_PREP,
 	IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP,
 	IEEE80211_HW_BUFF_MMPDU_TXQ,
+	IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW,
 
 	/* keep last, obviously */
 	NUM_IEEE80211_HW_FLAGS
@@ -5661,7 +5668,22 @@ struct ieee80211_tx_rate_control {
 	bool bss;
 };
 
+/**
+ * enum rate_control_capabilities - rate control capabilities
+ */
+enum rate_control_capabilities {
+	/**
+	 * @RATE_CTRL_CAPA_VHT_EXT_NSS_BW:
+	 * Support for extended NSS BW support (dot11VHTExtendedNSSCapable)
+	 * Note that this is only looked at if the minimum number of chains
+	 * that the AP uses is < the number of TX chains the hardware has,
+	 * otherwise the NSS difference doesn't bother us.
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
index 964663f49e58..fb45eb5d1dc4 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -216,6 +216,7 @@ static const char *hw_flag_names[] = {
 	FLAG(DEAUTH_NEED_MGD_TX_PREP),
 	FLAG(DOESNT_SUPPORT_QOS_NDP),
 	FLAG(BUFF_MMPDU_TXQ),
+	FLAG(SUPPORTS_VHT_EXT_NSS_BW),
 #undef FLAG
 };
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 348a52cefb43..08da90adeaea 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1199,6 +1199,9 @@ struct ieee80211_local {
 	/* number of RX chains the hardware has */
 	u8 rx_chains;
 
+	/* bitmap of which sbands were copied */
+	u8 sband_allocated;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d4bcd4da2ba8..7b20f8632242 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2017     Intel Deutschland GmbH
+ * Copyright (C) 2018 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1161,6 +1162,51 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
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
@@ -1279,6 +1325,7 @@ static int ieee80211_free_ack_frame(int id, void *p, void *data)
 void ieee80211_free_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	enum nl80211_band band;
 
 	mutex_destroy(&local->iflist_mtx);
 	mutex_destroy(&local->mtx);
@@ -1294,6 +1341,12 @@ void ieee80211_free_hw(struct ieee80211_hw *hw)
 
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
2.18.0
