Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31244 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYKGR6P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Halperin, Daniel C" <daniel.c.halperin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/13] iwlwifi: update iwl-commands.h for 3 stream support
Date: Fri,  7 Nov 2008 09:58:38 -0800
Message-Id: <1226080726-24860-6-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185822_897055_062C5907)
In-Reply-To: <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Halperin, Daniel C <daniel.c.halperin@intel.com>

This patch updates comments and constants to support 1, 2, or 3 spatial streams
in rate_n_flags .

Signed-off-by: Daniel Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 8aade00..1fe83d4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -213,10 +213,11 @@ struct iwl_cmd_header {
 } __attribute__ ((packed));
 
 /**
- * 4965 rate_n_flags bit fields
+ * iwlagn rate_n_flags bit fields
  *
- * rate_n_flags format is used in following 4965 commands:
+ * rate_n_flags format is used in following iwlagn commands:
  *  REPLY_RX (response only)
+ *  REPLY_RX_MPDU (response only)
  *  REPLY_TX (both command and response)
  *  REPLY_TX_LINK_QUALITY_CMD
  *
@@ -230,8 +231,9 @@ struct iwl_cmd_header {
  *        6)  54 Mbps
  *        7)  60 Mbps
  *
- *    3:  0)  Single stream (SISO)
+ *  4-3:  0)  Single stream (SISO)
  *        1)  Dual stream (MIMO)
+ *        2)  Triple stream (MIMO)
  *
  *    5:  Value of 0x20 in bits 7:0 indicates 6 Mbps FAT duplicate data
  *
@@ -252,8 +254,8 @@ struct iwl_cmd_header {
  *        110)  11 Mbps
  */
 #define RATE_MCS_CODE_MSK 0x7
-#define RATE_MCS_MIMO_POS 3
-#define RATE_MCS_MIMO_MSK 0x8
+#define RATE_MCS_SPATIAL_POS 3
+#define RATE_MCS_SPATIAL_MSK 0x18
 #define RATE_MCS_HT_DUP_POS 5
 #define RATE_MCS_HT_DUP_MSK 0x20
 
-- 
1.5.4.3

