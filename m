Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24341 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbZJWUmg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:36 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/18] iwlwifi: increase max tfd payload size
Date: Fri, 23 Oct 2009 13:42:26 -0700
Message-Id: <1256330556-20997-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Increase the size of TFD_MAX_PAYLOAD_SIZE (the size of iwl_device_cmd)
to accommodate iwl6000_channel_switch_cmd data structure.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Acked-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1378654..b520e55 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -364,7 +364,7 @@ enum {
 	CMD_WANT_SKB = (1 << 2),
 };
 
-#define IWL_CMD_MAX_PAYLOAD 320
+#define DEF_CMD_PAYLOAD_SIZE 320
 
 /*
  * IWL_LINK_HDR_MAX should include ieee80211_hdr, radiotap header,
@@ -388,7 +388,8 @@ struct iwl_device_cmd {
 		u16 val16;
 		u32 val32;
 		struct iwl_tx_cmd tx;
-		u8 payload[IWL_CMD_MAX_PAYLOAD];
+		struct iwl6000_channel_switch_cmd chswitch;
+		u8 payload[DEF_CMD_PAYLOAD_SIZE];
 	} __attribute__ ((packed)) cmd;
 } __attribute__ ((packed));
 
@@ -741,7 +742,11 @@ static inline int iwl_queue_used(const struct iwl_queue *q, int i)
 
 static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
 {
-	/* This is for scan command, the big buffer at end of command array */
+	/*
+	 * This is for init calibration result and scan command which
+	 * required buffer > TFD_MAX_PAYLOAD_SIZE,
+	 * the big buffer at end of command array
+	 */
 	if (is_huge)
 		return q->n_window;	/* must be power of 2 */
 
-- 
1.5.6.3

