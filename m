Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12239 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756305AbZDTVbD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:03 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/11] iwlwifi: rename PROBE_OPTION_MAX_API1 to PROBE_OPTION_MAX_3945
Date: Mon, 20 Apr 2009 14:36:55 -0700
Message-Id: <1240263424-8495-3-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233111_921363_AF39903D)
In-Reply-To: <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This limit applies to current (APIv1 and APIv2) 3945 firmware only, not
supported firmware of any of the other cards.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 29d4074..411a5d2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2469,8 +2469,8 @@ struct iwl_ssid_ie {
 	u8 ssid[32];
 } __attribute__ ((packed));
 
-#define PROBE_OPTION_MAX_API1		0x4
-#define PROBE_OPTION_MAX        	0x14
+#define PROBE_OPTION_MAX_3945		4
+#define PROBE_OPTION_MAX		20
 #define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
 #define IWL_GOOD_CRC_TH			cpu_to_le16(1)
 #define IWL_MAX_SCAN_SIZE 1024
@@ -2552,7 +2552,7 @@ struct iwl3945_scan_cmd {
 	struct iwl3945_tx_cmd tx_cmd;
 
 	/* For directed active scans (set to all-0s otherwise) */
-	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX_API1];
+	struct iwl_ssid_ie direct_scan[PROBE_OPTION_MAX_3945];
 
 	/*
 	 * Probe request frame, followed by channel list.
-- 
1.5.6.3

