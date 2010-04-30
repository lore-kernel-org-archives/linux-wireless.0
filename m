Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37185 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab0D3XAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 19:00:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH wireless-2.6] iwlwifi: work around passive scan issue
Date: Fri, 30 Apr 2010 16:00:02 -0700
Message-Id: <1272668402-3722-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some firmware versions don't behave properly when
passive scanning is requested on radar channels
without enabling active scanning on receiving a
good frame. Work around that issue by asking the
firmware to only enable the active scanning after
receiving a huge number of good frames, a number
that can never be reached during our dwell time.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---

This patch is also available from wireless-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 +++-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |   23 ++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6383d9f..f4e59ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2621,7 +2621,9 @@ struct iwl_ssid_ie {
 #define PROBE_OPTION_MAX_3945		4
 #define PROBE_OPTION_MAX		20
 #define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
-#define IWL_GOOD_CRC_TH			cpu_to_le16(1)
+#define IWL_GOOD_CRC_TH_DISABLED	0
+#define IWL_GOOD_CRC_TH_DEFAULT		cpu_to_le16(1)
+#define IWL_GOOD_CRC_TH_NEVER		cpu_to_le16(0xffff)
 #define IWL_MAX_SCAN_SIZE 1024
 #define IWL_MAX_CMD_SIZE 4096
 #define IWL_MAX_PROBE_REQUEST		200
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 5062f4e..2367286 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -812,16 +812,29 @@ static void iwl_bg_request_scan(struct work_struct *data)
 			rate = IWL_RATE_1M_PLCP;
 			rate_flags = RATE_MCS_CCK_MSK;
 		}
-		scan->good_CRC_th = 0;
+		scan->good_CRC_th = IWL_GOOD_CRC_TH_DISABLED;
 	} else if (priv->scan_bands & BIT(IEEE80211_BAND_5GHZ)) {
 		band = IEEE80211_BAND_5GHZ;
 		rate = IWL_RATE_6M_PLCP;
 		/*
-		 * If active scaning is requested but a certain channel
-		 * is marked passive, we can do active scanning if we
-		 * detect transmissions.
+		 * If active scanning is requested but a certain channel is
+		 * marked passive, we can do active scanning if we detect
+		 * transmissions.
+		 *
+		 * There is an issue with some firmware versions that triggers
+		 * a sysassert on a "good CRC threshold" of zero (== disabled),
+		 * on a radar channel even though this means that we should NOT
+		 * send probes.
+		 *
+		 * The "good CRC threshold" is the number of frames that we
+		 * need to receive during our dwell time on a channel before
+		 * sending out probes -- setting this to a huge value will
+		 * mean we never reach it, but at the same time work around
+		 * the aforementioned issue. Thus use IWL_GOOD_CRC_TH_NEVER
+		 * here instead of IWL_GOOD_CRC_TH_DISABLED.
 		 */
-		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH : 0;
+		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
+						IWL_GOOD_CRC_TH_NEVER;
 
 		/* Force use of chains B and C (0x6) for scan Rx for 4965
 		 * Avoid A (0x1) because of its off-channel reception on A-band.
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e276f2a..2f47d93 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2966,7 +2966,8 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 		 * is marked passive, we can do active scanning if we
 		 * detect transmissions.
 		 */
-		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH : 0;
+		scan->good_CRC_th = is_active ? IWL_GOOD_CRC_TH_DEFAULT :
+						IWL_GOOD_CRC_TH_DISABLED;
 		band = IEEE80211_BAND_5GHZ;
 	} else {
 		IWL_WARN(priv, "Invalid scan band count\n");
-- 
1.6.3.3

