Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49124 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779AbbKKWP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Nov 2015 17:15:28 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v3 8/8] mac80211: use Kconfig counters to determine feature optimisation
Date: Wed, 11 Nov 2015 23:15:20 +0100
Message-Id: <1447280120-16010-9-git-send-email-johannes@sipsolutions.net> (sfid-20151111_231541_477912_F39652D2)
In-Reply-To: <1447280120-16010-1-git-send-email-johannes@sipsolutions.net>
References: <1447280120-16010-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Drivers that would like to have feature flag optimisations are
currently required to select _ON and _OFF symbols for each one,
indicating whether they'd like to be optimised for being on or
off respectively. This handles badly, if a new feature flag is
added then all such drivers need to be updated.

Instead, use the new Kconfig counters to determine
 (a) the number of times each feature flag was selected ON
 (b) the number of mac80211 drivers built

if (a) > 0 then it was requested on by at least one driver
if (a) < (b) then it was not requested by at least one driver

This allows determining whether or not optimisations should be
made more easily, and importantly, adding new flags no longer
requires editing the Kconfig for all drivers since they won't
want the new flag - only the driver it's added for does.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/Kconfig |  21 ++-
 net/mac80211/Kconfig         |   4 +
 net/mac80211/Kconfig.hwflags | 297 +++++++++++++++----------------------------
 net/mac80211/hwflags.h       |   6 +-
 4 files changed, 122 insertions(+), 206 deletions(-)

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index f2a8fdca5ede..26ffa28a5677 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -246,17 +246,16 @@ source "drivers/net/wireless/realtek/rtl818x/Kconfig"
 config MAC80211_HWSIM
 	tristate "Simulated radio testing tool for mac80211"
 	depends on MAC80211
-	select MAC80211_HW_SUPPORT_FAST_XMIT_ON
-	select MAC80211_HW_CHANCTX_STA_CSA_ON
-	select MAC80211_HW_SUPPORTS_HT_CCK_RATES_ON
-	select MAC80211_HW_QUEUE_CONTROL_ON
-	select MAC80211_HW_WANT_MONITOR_VIF_ON
-	select MAC80211_HW_AMPDU_AGGREGATION_ON
-	select MAC80211_HW_MFP_CAPABLE_ON
-	select MAC80211_HW_SIGNAL_DBM_ON
-	select MAC80211_HW_TDLS_WIDER_BW_ON
-	select MAC80211_HW_HAS_RATE_CONTROL_OFF
-	select MAC80211_HW_RX_INCLUDES_FCS_OFF
+	count MAC80211_NUM_DRIVERS
+	count MAC80211_HW_SUPPORT_FAST_XMIT
+	count MAC80211_HW_CHANCTX_STA_CSA
+	count MAC80211_HW_SUPPORTS_HT_CCK_RATES
+	count MAC80211_HW_QUEUE_CONTROL
+	count MAC80211_HW_WANT_MONITOR_VIF
+	count MAC80211_HW_AMPDU_AGGREGATION
+	count MAC80211_HW_MFP_CAPABLE
+	count MAC80211_HW_SIGNAL_DBM
+	count MAC80211_HW_TDLS_WIDER_BW
 	---help---
 	  This driver is a developer testing tool that can be used to test
 	  IEEE 802.11 networking stack (mac80211) functionality. This is not
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 206b11598dd1..9eba9c5cea18 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -11,6 +11,10 @@ config MAC80211
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.
 
+config MAC80211_NUM_DRIVERS
+	int
+	depends on MAC80211
+
 comment "CFG80211 needs to be enabled for MAC80211"
 	depends on CFG80211=n
 
diff --git a/net/mac80211/Kconfig.hwflags b/net/mac80211/Kconfig.hwflags
index 06f6ba12c86e..c384eef7e987 100644
--- a/net/mac80211/Kconfig.hwflags
+++ b/net/mac80211/Kconfig.hwflags
@@ -1,192 +1,105 @@
-config MAC80211_HW_HAS_RATE_CONTROL_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_HAS_RATE_CONTROL_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_RX_INCLUDES_FCS_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_RX_INCLUDES_FCS_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_HOST_BROADCAST_PS_BUFFERING_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_HOST_BROADCAST_PS_BUFFERING_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SIGNAL_UNSPEC_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SIGNAL_UNSPEC_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SIGNAL_DBM_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SIGNAL_DBM_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_NEED_DTIM_BEFORE_ASSOC_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_NEED_DTIM_BEFORE_ASSOC_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SPECTRUM_MGMT_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SPECTRUM_MGMT_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_AMPDU_AGGREGATION_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_AMPDU_AGGREGATION_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_PS_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_PS_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_PS_NULLFUNC_STACK_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_PS_NULLFUNC_STACK_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_DYNAMIC_PS_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_DYNAMIC_PS_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_MFP_CAPABLE_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_MFP_CAPABLE_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_WANT_MONITOR_VIF_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_WANT_MONITOR_VIF_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_NO_AUTO_VIF_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_NO_AUTO_VIF_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SW_CRYPTO_CONTROL_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SW_CRYPTO_CONTROL_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORT_FAST_XMIT_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORT_FAST_XMIT_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_REPORTS_TX_ACK_STATUS_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_REPORTS_TX_ACK_STATUS_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_CONNECTION_MONITOR_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_CONNECTION_MONITOR_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_QUEUE_CONTROL_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_QUEUE_CONTROL_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_PER_STA_GTK_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_PER_STA_GTK_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_AP_LINK_PS_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_AP_LINK_PS_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_TX_AMPDU_SETUP_IN_HW_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_TX_AMPDU_SETUP_IN_HW_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_RC_TABLE_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_RC_TABLE_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_P2P_DEV_ADDR_FOR_INTF_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_P2P_DEV_ADDR_FOR_INTF_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_TIMING_BEACON_ONLY_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_TIMING_BEACON_ONLY_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_HT_CCK_RATES_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_HT_CCK_RATES_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_CHANCTX_STA_CSA_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_CHANCTX_STA_CSA_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_CLONED_SKBS_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_CLONED_SKBS_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_TDLS_WIDER_BW_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_TDLS_WIDER_BW_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_AMSDU_IN_AMPDU_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_SUPPORTS_AMSDU_IN_AMPDU_OFF
-	bool
-	depends on MAC80211
-config MAC80211_HW_BEACON_TX_STATUS_ON
-	bool
-	depends on MAC80211
-config MAC80211_HW_BEACON_TX_STATUS_OFF
-	bool
-	depends on MAC80211
+config MAC80211_COUNT_DRIVERS
+	int
+	default 0
+config MAC80211_HW_HAS_RATE_CONTROL
+	int
+	default 0
+config MAC80211_HW_RX_INCLUDES_FCS
+	int
+	default 0
+config MAC80211_HW_HOST_BROADCAST_PS_BUFFERING
+	int
+	default 0
+config MAC80211_HW_SIGNAL_UNSPEC
+	int
+	default 0
+config MAC80211_HW_SIGNAL_DBM
+	int
+	default 0
+config MAC80211_HW_NEED_DTIM_BEFORE_ASSOC
+	int
+	default 0
+config MAC80211_HW_SPECTRUM_MGMT
+	int
+	default 0
+config MAC80211_HW_AMPDU_AGGREGATION
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_PS
+	int
+	default 0
+config MAC80211_HW_PS_NULLFUNC_STACK
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_DYNAMIC_PS
+	int
+	default 0
+config MAC80211_HW_MFP_CAPABLE
+	int
+	default 0
+config MAC80211_HW_WANT_MONITOR_VIF
+	int
+	default 0
+config MAC80211_HW_NO_AUTO_VIF
+	int
+	default 0
+config MAC80211_HW_SW_CRYPTO_CONTROL
+	int
+	default 0
+config MAC80211_HW_SUPPORT_FAST_XMIT
+	int
+	default 0
+config MAC80211_HW_REPORTS_TX_ACK_STATUS
+	int
+	default 0
+config MAC80211_HW_CONNECTION_MONITOR
+	int
+	default 0
+config MAC80211_HW_QUEUE_CONTROL
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_PER_STA_GTK
+	int
+	default 0
+config MAC80211_HW_AP_LINK_PS
+	int
+	default 0
+config MAC80211_HW_TX_AMPDU_SETUP_IN_HW
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_RC_TABLE
+	int
+	default 0
+config MAC80211_HW_P2P_DEV_ADDR_FOR_INTF
+	int
+	default 0
+config MAC80211_HW_TIMING_BEACON_ONLY
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_HT_CCK_RATES
+	int
+	default 0
+config MAC80211_HW_CHANCTX_STA_CSA
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_CLONED_SKBS
+	int
+	default 0
+config MAC80211_HW_SINGLE_SCAN_ALL_BANDS
+	int
+	default 0
+config MAC80211_HW_SINGLE_SCAN_ALL_BANDS_OFF
+	int
+	default 0
+config MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS
+	int
+	default 0
+config MAC80211_HW_TDLS_WIDER_BW
+	int
+	default 0
+config MAC80211_HW_SUPPORTS_AMSDU_IN_AMPDU
+	int
+	default 0
+config MAC80211_HW_BEACON_TX_STATUS
+	int
+	default 0
diff --git a/net/mac80211/hwflags.h b/net/mac80211/hwflags.h
index 82bf89658cb7..4919d82539c4 100644
--- a/net/mac80211/hwflags.h
+++ b/net/mac80211/hwflags.h
@@ -15,11 +15,11 @@ extern struct static_key_false hwflags_keys[NUM_IEEE80211_HW_FLAGS];
 #ifdef CONFIG_JUMP_LABEL
 enum hwflags_defstates {
 #define __DEFINE_HWFLAG(_flg, _on, _off)				\
-	HWFLAGS_DEFSTATE_##_flg = -1 + ((_on) ^ (_off)) * (1 + _on),
+	HWFLAGS_DEFSTATE_##_flg = -1 + ((_on) ^ (_off)) * (1 + (_on)),
 #define DEFINE_HWFLAG(_flg)						\
 	__DEFINE_HWFLAG(_flg,						\
-			IS_ENABLED(CONFIG_MAC80211_HW_##_flg##_ON),	\
-			IS_ENABLED(CONFIG_MAC80211_HW_##_flg##_OFF))
+			CONFIG_MAC80211_HW_##_flg > 0,			\
+			CONFIG_MAC80211_HW_##_flg < CONFIG_MAC80211_NUM_DRIVERS)
 #include <net/mac80211-hwflags.h>
 #undef DEFINE_HWFLAG
 };
-- 
2.6.2

