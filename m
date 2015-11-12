Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54970 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbbKLWA5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 17:00:57 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Michal Marek <mmarek@suse.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v5 5/5] iwlwifi: mvm: add Kconfig settings for hw flags
Date: Thu, 12 Nov 2015 23:00:52 +0100
Message-Id: <1447365652-23716-6-git-send-email-johannes@sipsolutions.net> (sfid-20151112_230110_783130_8B335A38)
In-Reply-To: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Copy the hardware flags settings into Kconfig for iwlwifi/mvm.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 3fbee1ec1d33..74416361b154 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -65,7 +65,23 @@ config IWLMVM
 	tristate "Intel Wireless WiFi MVM Firmware support"
 	select WANT_DEV_COREDUMP
 	count MAC80211_NUM_DRIVERS
-	select MAC80211_DRIVER_NO_HWFLAGS
+	count MAC80211_HW_SIGNAL_DBM
+	count MAC80211_HW_SPECTRUM_MGMT
+	count MAC80211_HW_REPORTS_TX_ACK_STATUS
+	count MAC80211_HW_QUEUE_CONTROL
+	count MAC80211_HW_WANT_MONITOR_VIF
+	count MAC80211_HW_SUPPORTS_PS
+	count MAC80211_HW_SUPPORTS_DYNAMIC_PS
+	count MAC80211_HW_AMPDU_AGGREGATION
+	count MAC80211_HW_TIMING_BEACON_ONLY
+	count MAC80211_HW_CONNECTION_MONITOR
+	count MAC80211_HW_CHANCTX_STA_CSA
+	count MAC80211_HW_SUPPORT_FAST_XMIT
+	count MAC80211_HW_SUPPORTS_CLONED_SKBS
+	count MAC80211_HW_SINGLE_SCAN_ON_ALL_BANDS
+	select MAC80211_HW_MFP_CAPABLE_DYN
+	select MAC80211_HW_RX_INCLUDES_FCS_DYN
+	select MAC80211_HW_TDLS_WIDER_BW_DYN
 	help
 	  This is the driver that supports the MVM firmware. The list
 	  of the devices that use this firmware is available here:
-- 
2.6.2

