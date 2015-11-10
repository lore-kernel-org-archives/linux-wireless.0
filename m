Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39230 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbbKJIwg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 03:52:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 3/4] mac80211: use static keys for hw flags
Date: Tue, 10 Nov 2015 09:52:28 +0100
Message-Id: <1447145549-27376-4-git-send-email-johannes@sipsolutions.net> (sfid-20151110_095256_078536_1A6F6D39)
In-Reply-To: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are many drivers with different behaviour, but in a lot of
systems only a single driver will ever be built. In that case we
could practically get rid of the code for the paths that this
driver/device doesn't need. Doing that, however, would be rather
dangerous.

As a decent alternative, use static keys to simply get into the
required code path for the single built driver.

To achieve this associate with each flag an _ON and _OFF Kconfig
symbol. Selecting this symbol in a driver will cause the system
to take this as the default state (if both are selected, there's
no optimisation at all.)

If, for example, the Kconfig selection said that a given flag is
expected to always be turned off, then the code depending on it
would be placed out-of-line and the jump to it NOPed out. If a
different driver that actually requires the code contrary to the
Kconfig selection is loaded, the jump will be patched in and the
first thing in the out-of-line section will be to check the real
hardware flag (since multiple drivers can be loaded.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h       |  28 ++++---
 net/mac80211/Kconfig         |   2 +
 net/mac80211/Kconfig.hwflags | 192 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/Makefile        |   1 +
 net/mac80211/hwflags.c       | 129 +++++++++++++++++++++++++++++
 net/mac80211/hwflags.h       | 149 +++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h   |  12 +--
 net/mac80211/main.c          |   6 ++
 8 files changed, 498 insertions(+), 21 deletions(-)
 create mode 100644 net/mac80211/Kconfig.hwflags
 create mode 100644 net/mac80211/hwflags.c
 create mode 100644 net/mac80211/hwflags.h

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 47274d829115..db98eb5673c2 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2078,19 +2078,23 @@ static inline bool _ieee80211_hw_check(struct ieee80211_hw *hw,
 }
 #define ieee80211_hw_check(hw, flg)	_ieee80211_hw_check(hw, IEEE80211_HW_##flg)
 
-static inline void _ieee80211_hw_set(struct ieee80211_hw *hw,
-				     enum ieee80211_hw_flags flg)
-{
-	__set_bit(flg, hw->flags);
-}
-#define ieee80211_hw_set(hw, flg)	_ieee80211_hw_set(hw, IEEE80211_HW_##flg)
-
-static inline void _ieee80211_hw_clear(struct ieee80211_hw *hw,
-				       enum ieee80211_hw_flags flg)
+#ifdef CONFIG_JUMP_LABEL
+void ieee80211_hw_mod_flag(struct ieee80211_hw *hw,
+			   enum ieee80211_hw_flags flg, bool set);
+#else
+static inline void ieee80211_hw_mod_flag(struct ieee80211_hw *hw,
+					 enum ieee80211_hw_flags flg, bool set)
 {
-	__clear_bit(flg, hw->flags);
-}
-#define ieee80211_hw_clear(hw, flg)	_ieee80211_hw_clear(hw, IEEE80211_HW_##flg)
+	if (set)
+		__set_bit(flg, hw->flags);
+	else
+		__clear_bit(flg, hw->flags);
+#endif /* CONFIG_JUMP_LABEL */
+
+#define ieee80211_hw_set(hw, flg)	\
+	ieee80211_hw_mod_flag(hw, IEEE80211_HW_##flg, true)
+#define ieee80211_hw_clear(hw, flg)	\
+	ieee80211_hw_mod_flag(hw, IEEE80211_HW_##flg, false)
 
 /**
  * struct ieee80211_scan_request - hw scan request
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 3891cbd2adea..206b11598dd1 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -318,3 +318,5 @@ config MAC80211_STA_HASH_MAX_SIZE
 	  connect more stations than the number selected here.)
 
 	  If unsure, leave the default of 0.
+
+source "net/mac80211/Kconfig.hwflags"
diff --git a/net/mac80211/Kconfig.hwflags b/net/mac80211/Kconfig.hwflags
new file mode 100644
index 000000000000..06f6ba12c86e
--- /dev/null
+++ b/net/mac80211/Kconfig.hwflags
@@ -0,0 +1,192 @@
+config MAC80211_HW_HAS_RATE_CONTROL_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_HAS_RATE_CONTROL_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_RX_INCLUDES_FCS_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_RX_INCLUDES_FCS_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_HOST_BROADCAST_PS_BUFFERING_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_HOST_BROADCAST_PS_BUFFERING_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SIGNAL_UNSPEC_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SIGNAL_UNSPEC_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SIGNAL_DBM_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SIGNAL_DBM_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_NEED_DTIM_BEFORE_ASSOC_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_NEED_DTIM_BEFORE_ASSOC_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SPECTRUM_MGMT_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SPECTRUM_MGMT_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_AMPDU_AGGREGATION_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_AMPDU_AGGREGATION_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_PS_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_PS_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_PS_NULLFUNC_STACK_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_PS_NULLFUNC_STACK_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_DYNAMIC_PS_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_DYNAMIC_PS_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_MFP_CAPABLE_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_MFP_CAPABLE_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_WANT_MONITOR_VIF_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_WANT_MONITOR_VIF_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_NO_AUTO_VIF_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_NO_AUTO_VIF_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SW_CRYPTO_CONTROL_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SW_CRYPTO_CONTROL_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORT_FAST_XMIT_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORT_FAST_XMIT_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_REPORTS_TX_ACK_STATUS_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_REPORTS_TX_ACK_STATUS_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_CONNECTION_MONITOR_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_CONNECTION_MONITOR_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_QUEUE_CONTROL_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_QUEUE_CONTROL_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_PER_STA_GTK_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_PER_STA_GTK_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_AP_LINK_PS_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_AP_LINK_PS_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_TX_AMPDU_SETUP_IN_HW_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_TX_AMPDU_SETUP_IN_HW_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_RC_TABLE_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_RC_TABLE_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_P2P_DEV_ADDR_FOR_INTF_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_P2P_DEV_ADDR_FOR_INTF_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_TIMING_BEACON_ONLY_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_TIMING_BEACON_ONLY_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_HT_CCK_RATES_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_HT_CCK_RATES_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_CHANCTX_STA_CSA_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_CHANCTX_STA_CSA_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_CLONED_SKBS_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_CLONED_SKBS_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_TDLS_WIDER_BW_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_TDLS_WIDER_BW_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_AMSDU_IN_AMPDU_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_SUPPORTS_AMSDU_IN_AMPDU_OFF
+	bool
+	depends on MAC80211
+config MAC80211_HW_BEACON_TX_STATUS_ON
+	bool
+	depends on MAC80211
+config MAC80211_HW_BEACON_TX_STATUS_OFF
+	bool
+	depends on MAC80211
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index f9137a8341f4..ba1e407ccfc5 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -48,6 +48,7 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh_ps.o
 
 mac80211-$(CONFIG_PM) += pm.o
+mac80211-$(CONFIG_JUMP_LABEL) += hwflags.o
 
 CFLAGS_trace.o := -I$(src)
 
diff --git a/net/mac80211/hwflags.c b/net/mac80211/hwflags.c
new file mode 100644
index 000000000000..3beeee512f91
--- /dev/null
+++ b/net/mac80211/hwflags.c
@@ -0,0 +1,129 @@
+/*
+ * Copyright 2015	Intel Deutschland GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/jump_label.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+
+struct static_key_false hwflags_keys[NUM_IEEE80211_HW_FLAGS] = {
+	[0 ... NUM_IEEE80211_HW_FLAGS - 1] = STATIC_KEY_FALSE_INIT,
+};
+
+static s8 hwflags_defstate[] = {
+	[IEEE80211_HW_HAS_RATE_CONTROL] =
+		HWFLAGS_DEFSTATE_HAS_RATE_CONTROL,
+	[IEEE80211_HW_RX_INCLUDES_FCS] =
+		HWFLAGS_DEFSTATE_RX_INCLUDES_FCS,
+	[IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING] =
+		HWFLAGS_DEFSTATE_HOST_BROADCAST_PS_BUFFERING,
+	[IEEE80211_HW_SIGNAL_UNSPEC] =
+		HWFLAGS_DEFSTATE_SIGNAL_UNSPEC,
+	[IEEE80211_HW_SIGNAL_DBM] =
+		HWFLAGS_DEFSTATE_SIGNAL_DBM,
+	[IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC] =
+		HWFLAGS_DEFSTATE_NEED_DTIM_BEFORE_ASSOC,
+	[IEEE80211_HW_SPECTRUM_MGMT] =
+		HWFLAGS_DEFSTATE_SPECTRUM_MGMT,
+	[IEEE80211_HW_AMPDU_AGGREGATION] =
+		HWFLAGS_DEFSTATE_AMPDU_AGGREGATION,
+	[IEEE80211_HW_SUPPORTS_PS] =
+		HWFLAGS_DEFSTATE_SUPPORTS_PS,
+	[IEEE80211_HW_PS_NULLFUNC_STACK] =
+		HWFLAGS_DEFSTATE_PS_NULLFUNC_STACK,
+	[IEEE80211_HW_SUPPORTS_DYNAMIC_PS] =
+		HWFLAGS_DEFSTATE_SUPPORTS_DYNAMIC_PS,
+	[IEEE80211_HW_MFP_CAPABLE] =
+		HWFLAGS_DEFSTATE_MFP_CAPABLE,
+	[IEEE80211_HW_WANT_MONITOR_VIF] =
+		HWFLAGS_DEFSTATE_WANT_MONITOR_VIF,
+	[IEEE80211_HW_NO_AUTO_VIF] =
+		HWFLAGS_DEFSTATE_NO_AUTO_VIF,
+	[IEEE80211_HW_SW_CRYPTO_CONTROL] =
+		HWFLAGS_DEFSTATE_SW_CRYPTO_CONTROL,
+	[IEEE80211_HW_SUPPORT_FAST_XMIT] =
+		HWFLAGS_DEFSTATE_SUPPORT_FAST_XMIT,
+	[IEEE80211_HW_REPORTS_TX_ACK_STATUS] =
+		HWFLAGS_DEFSTATE_REPORTS_TX_ACK_STATUS,
+	[IEEE80211_HW_CONNECTION_MONITOR] =
+		HWFLAGS_DEFSTATE_CONNECTION_MONITOR,
+	[IEEE80211_HW_QUEUE_CONTROL] =
+		HWFLAGS_DEFSTATE_QUEUE_CONTROL,
+	[IEEE80211_HW_SUPPORTS_PER_STA_GTK] =
+		HWFLAGS_DEFSTATE_SUPPORTS_PER_STA_GTK,
+	[IEEE80211_HW_AP_LINK_PS] =
+		HWFLAGS_DEFSTATE_AP_LINK_PS,
+	[IEEE80211_HW_TX_AMPDU_SETUP_IN_HW] =
+		HWFLAGS_DEFSTATE_TX_AMPDU_SETUP_IN_HW,
+	[IEEE80211_HW_SUPPORTS_RC_TABLE] =
+		HWFLAGS_DEFSTATE_SUPPORTS_RC_TABLE,
+	[IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF] =
+		HWFLAGS_DEFSTATE_P2P_DEV_ADDR_FOR_INTF,
+	[IEEE80211_HW_TIMING_BEACON_ONLY] =
+		HWFLAGS_DEFSTATE_TIMING_BEACON_ONLY,
+	[IEEE80211_HW_SUPPORTS_HT_CCK_RATES] =
+		HWFLAGS_DEFSTATE_SUPPORTS_HT_CCK_RATES,
+	[IEEE80211_HW_CHANCTX_STA_CSA] =
+		HWFLAGS_DEFSTATE_CHANCTX_STA_CSA,
+	[IEEE80211_HW_SUPPORTS_CLONED_SKBS] =
+		HWFLAGS_DEFSTATE_SUPPORTS_CLONED_SKBS,
+	[IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS] =
+		HWFLAGS_DEFSTATE_SINGLE_SCAN_ON_ALL_BANDS,
+	[IEEE80211_HW_TDLS_WIDER_BW] =
+		HWFLAGS_DEFSTATE_TDLS_WIDER_BW,
+	[IEEE80211_HW_SUPPORTS_AMSDU_IN_AMPDU] =
+		HWFLAGS_DEFSTATE_SUPPORTS_AMSDU_IN_AMPDU,
+	[IEEE80211_HW_BEACON_TX_STATUS] =
+		HWFLAGS_DEFSTATE_BEACON_TX_STATUS,
+};
+
+void ieee80211_hw_mod_flag(struct ieee80211_hw *hw,
+			   enum ieee80211_hw_flags flg, bool set)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	if (set) {
+		if (test_bit(flg, hw->flags))
+			return;
+		__set_bit(flg, hw->flags);
+	} else {
+		if (!test_bit(flg, hw->flags))
+			return;
+		__clear_bit(flg, hw->flags);
+	}
+
+	if (!local->registered)
+		return;
+
+	if (hwflags_defstate[flg] < 0)
+		return;
+
+	if (hwflags_defstate[flg] == !!test_bit(flg, hw->flags))
+		static_branch_dec(&hwflags_keys[flg]);
+	else
+		static_branch_inc(&hwflags_keys[flg]);
+}
+EXPORT_SYMBOL_GPL(ieee80211_hw_mod_flag);
+
+void ieee80211_hwflags_sync_add(unsigned long *flags)
+{
+	unsigned int flg;
+
+	for (flg = 0; flg < NUM_IEEE80211_HW_FLAGS; flg++) {
+		if (hwflags_defstate[flg] != !!test_bit(flg, flags))
+			static_branch_inc(&hwflags_keys[flg]);
+	}
+}
+
+void ieee80211_hwflags_sync_del(unsigned long *flags)
+{
+	unsigned int flg;
+
+	for (flg = 0; flg < NUM_IEEE80211_HW_FLAGS; flg++) {
+		if (hwflags_defstate[flg] != !!test_bit(flg, flags))
+			static_branch_dec(&hwflags_keys[flg]);
+	}
+}
diff --git a/net/mac80211/hwflags.h b/net/mac80211/hwflags.h
new file mode 100644
index 000000000000..49b38050c446
--- /dev/null
+++ b/net/mac80211/hwflags.h
@@ -0,0 +1,149 @@
+/*
+ * Copyright 2015	Intel Deutschland GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __mac80211_hwflags_h
+#define __mac80211_hwflags_h
+#include <linux/jump_label.h>
+#include <net/mac80211.h>
+
+extern struct static_key_false hwflags_keys[NUM_IEEE80211_HW_FLAGS];
+
+#ifdef CONFIG_JUMP_LABEL
+#define HWFLAGS_DEFSTATE(_name, _on, _off)	\
+	HWFLAGS_DEFSTATE_##_name = -1 + ((_on) ^ (_off)) * (1 + _on)
+
+enum hwflags_defstates {
+HWFLAGS_DEFSTATE(HAS_RATE_CONTROL,
+		 IS_ENABLED(CONFIG_MAC80211_HW_HAS_RATE_CONTROL_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_HAS_RATE_CONTROL_OFF)),
+HWFLAGS_DEFSTATE(RX_INCLUDES_FCS,
+		 IS_ENABLED(CONFIG_MAC80211_HW_RX_INCLUDES_FCS_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_RX_INCLUDES_FCS_OFF)),
+HWFLAGS_DEFSTATE(HOST_BROADCAST_PS_BUFFERING,
+		 IS_ENABLED(CONFIG_MAC80211_HW_HOST_BROADCAST_PS_BUFFERING_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_HOST_BROADCAST_PS_BUFFERING_OFF)),
+HWFLAGS_DEFSTATE(SIGNAL_UNSPEC,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SIGNAL_UNSPEC_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SIGNAL_UNSPEC_OFF)),
+HWFLAGS_DEFSTATE(SIGNAL_DBM,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SIGNAL_DBM_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SIGNAL_DBM_OFF)),
+HWFLAGS_DEFSTATE(NEED_DTIM_BEFORE_ASSOC,
+		 IS_ENABLED(CONFIG_MAC80211_HW_NEED_DTIM_BEFORE_ASSOC_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_NEED_DTIM_BEFORE_ASSOC_OFF)),
+HWFLAGS_DEFSTATE(SPECTRUM_MGMT,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SPECTRUM_MGMT_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SPECTRUM_MGMT_OFF)),
+HWFLAGS_DEFSTATE(AMPDU_AGGREGATION,
+		 IS_ENABLED(CONFIG_MAC80211_HW_AMPDU_AGGREGATION_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_AMPDU_AGGREGATION_OFF)),
+HWFLAGS_DEFSTATE(SUPPORTS_PS,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_PS_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_PS_OFF)),
+HWFLAGS_DEFSTATE(PS_NULLFUNC_STACK,
+		 IS_ENABLED(CONFIG_MAC80211_HW_PS_NULLFUNC_STACK_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_PS_NULLFUNC_STACK_OFF)),
+HWFLAGS_DEFSTATE(SUPPORTS_DYNAMIC_PS,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_DYNAMIC_PS_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_DYNAMIC_PS_OFF)),
+HWFLAGS_DEFSTATE(MFP_CAPABLE,
+		 IS_ENABLED(CONFIG_MAC80211_HW_MFP_CAPABLE_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_MFP_CAPABLE_OFF)),
+HWFLAGS_DEFSTATE(WANT_MONITOR_VIF,
+		 IS_ENABLED(CONFIG_MAC80211_HW_WANT_MONITOR_VIF_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_WANT_MONITOR_VIF_OFF)),
+HWFLAGS_DEFSTATE(NO_AUTO_VIF,
+		 IS_ENABLED(CONFIG_MAC80211_HW_NO_AUTO_VIF_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_NO_AUTO_VIF_OFF)),
+HWFLAGS_DEFSTATE(SW_CRYPTO_CONTROL,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SW_CRYPTO_CONTROL_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SW_CRYPTO_CONTROL_OFF)),
+HWFLAGS_DEFSTATE(SUPPORT_FAST_XMIT,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORT_FAST_XMIT_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORT_FAST_XMIT_OFF)),
+HWFLAGS_DEFSTATE(REPORTS_TX_ACK_STATUS,
+		 IS_ENABLED(CONFIG_MAC80211_HW_REPORTS_TX_ACK_STATUS_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_REPORTS_TX_ACK_STATUS_OFF)),
+HWFLAGS_DEFSTATE(CONNECTION_MONITOR,
+		 IS_ENABLED(CONFIG_MAC80211_HW_CONNECTION_MONITOR_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_CONNECTION_MONITOR_OFF)),
+HWFLAGS_DEFSTATE(QUEUE_CONTROL,
+		 IS_ENABLED(CONFIG_MAC80211_HW_QUEUE_CONTROL_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_QUEUE_CONTROL_OFF)),
+HWFLAGS_DEFSTATE(SUPPORTS_PER_STA_GTK,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_PER_STA_GTK_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_PER_STA_GTK_OFF)),
+HWFLAGS_DEFSTATE(AP_LINK_PS,
+		 IS_ENABLED(CONFIG_MAC80211_HW_AP_LINK_PS_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_AP_LINK_PS_OFF)),
+HWFLAGS_DEFSTATE(TX_AMPDU_SETUP_IN_HW,
+		 IS_ENABLED(CONFIG_MAC80211_HW_TX_AMPDU_SETUP_IN_HW_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_TX_AMPDU_SETUP_IN_HW_OFF)),
+HWFLAGS_DEFSTATE(SUPPORTS_RC_TABLE,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_RC_TABLE_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_RC_TABLE_OFF)),
+HWFLAGS_DEFSTATE(P2P_DEV_ADDR_FOR_INTF,
+		 IS_ENABLED(CONFIG_MAC80211_HW_P2P_DEV_ADDR_FOR_INTF_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_P2P_DEV_ADDR_FOR_INTF_OFF)),
+HWFLAGS_DEFSTATE(TIMING_BEACON_ONLY,
+		 IS_ENABLED(CONFIG_MAC80211_HW_TIMING_BEACON_ONLY_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_TIMING_BEACON_ONLY_OFF)),
+HWFLAGS_DEFSTATE(SUPPORTS_HT_CCK_RATES,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_HT_CCK_RATES_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_HT_CCK_RATES_OFF)),
+HWFLAGS_DEFSTATE(CHANCTX_STA_CSA,
+		 IS_ENABLED(CONFIG_MAC80211_HW_CHANCTX_STA_CSA_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_CHANCTX_STA_CSA_OFF)),
+HWFLAGS_DEFSTATE(SUPPORTS_CLONED_SKBS,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_CLONED_SKBS_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_CLONED_SKBS_OFF)),
+HWFLAGS_DEFSTATE(SINGLE_SCAN_ON_ALL_BANDS,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS_OFF)),
+HWFLAGS_DEFSTATE(TDLS_WIDER_BW,
+		 IS_ENABLED(CONFIG_MAC80211_HW_TDLS_WIDER_BW_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_TDLS_WIDER_BW_OFF)),
+HWFLAGS_DEFSTATE(SUPPORTS_AMSDU_IN_AMPDU,
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_AMSDU_IN_AMPDU_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_SUPPORTS_AMSDU_IN_AMPDU_OFF)),
+HWFLAGS_DEFSTATE(BEACON_TX_STATUS,
+		 IS_ENABLED(CONFIG_MAC80211_HW_BEACON_TX_STATUS_ON),
+		 IS_ENABLED(CONFIG_MAC80211_HW_BEACON_TX_STATUS_OFF)),
+};
+
+bool _____optimisation_missing(void);
+
+#define ieee80211_local_check(local, flg)				\
+({									\
+	enum ieee80211_hw_flags flag = IEEE80211_HW_##flg;		\
+	bool result;							\
+									\
+	if (HWFLAGS_DEFSTATE_##flg == -1)				\
+		result = test_bit(flag, (local)->hw.flags);		\
+	else if (HWFLAGS_DEFSTATE_##flg == 1)				\
+		result = (!static_branch_unlikely(&hwflags_keys[flag]) ||\
+			  test_bit(flag, (local)->hw.flags));		\
+	else if (HWFLAGS_DEFSTATE_##flg == 0)				\
+		result = (static_branch_unlikely(&hwflags_keys[flag]) &&\
+			  test_bit(flag, (local)->hw.flags));		\
+	else								\
+		result = _____optimisation_missing();			\
+									\
+	result;								\
+})
+
+void ieee80211_hwflags_sync_add(unsigned long *flags);
+void ieee80211_hwflags_sync_del(unsigned long *flags);
+#else /* CONFIG_JUMP_LABEL */
+#define ieee80211_local_check(local, flg)	\
+	test_bit(IEEE80211_HW_##flg, local->hw.flags)
+
+static inline void ieee80211_hwflags_sync_add(unsigned long *flags) {}
+static inline void ieee80211_hwflags_sync_del(unsigned long *flags) {}
+#endif /* CONFIG_JUMP_LABEL */
+
+#endif /* __mac80211_hwflags_h */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 46bd8965d164..0663eda5b478 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -33,6 +33,7 @@
 #include "key.h"
 #include "sta_info.h"
 #include "debug.h"
+#include "hwflags.h"
 
 extern const struct cfg80211_ops mac80211_config_ops;
 
@@ -1121,6 +1122,8 @@ struct ieee80211_local {
 
 	bool wiphy_ciphers_allocated;
 
+	bool registered;
+
 	bool use_chanctx;
 
 	/* protects the aggregated multicast list and filter calls */
@@ -1357,15 +1360,6 @@ struct ieee80211_local {
 	struct sk_buff_head skb_queue_tdls_chsw;
 };
 
-static inline bool _ieee80211_local_check(struct ieee80211_local *local,
-					  enum ieee80211_hw_flags flg)
-{
-	return test_bit(flg, local->hw.flags);
-}
-
-#define ieee80211_local_check(local, flg)	\
-	_ieee80211_local_check(local, IEEE80211_HW_##flg)
-
 static inline struct ieee80211_sub_if_data *
 IEEE80211_DEV_TO_SUB_IF(struct net_device *dev)
 {
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 84d7480fe7c8..03ad36ba4945 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1095,6 +1095,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_ifa6;
 #endif
 
+	ieee80211_hwflags_sync_add(local->hw.flags);
+	local->registered = true;
+
 	return 0;
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1169,6 +1172,9 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
 	kfree(local->int_scan_req);
+
+	local->registered = false;
+	ieee80211_hwflags_sync_del(local->hw.flags);
 }
 EXPORT_SYMBOL(ieee80211_unregister_hw);
 
-- 
2.6.2

