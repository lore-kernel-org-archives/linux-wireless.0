Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753034Ab0IQVXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 17:23:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/10] iwlagn: minor coex API changes
Date: Fri, 17 Sep 2010 14:24:33 -0700
Message-Id: <1284758674-25297-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284758674-25297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding two new parameters in config bt API. these two parameters
use the 3 reserved bytes, so there is no structure size changes.

Make sure set both parameters to "zero" in order to preserve
previous behavior.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 294a1d5..27e250c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2486,7 +2486,12 @@ struct iwlagn_bt_cmd {
 	__le16 bt4_decision_time; /* unused */
 	__le16 valid;
 	u8 prio_boost;
-	u8 reserved[3];
+	/*
+	 * set IWLAGN_BT_VALID_BOOST to "1" in "valid" bitmask
+	 * if configure the following patterns
+	 */
+	u8 tx_prio_boost;	/* SW boost of WiFi tx priority */
+	__le16 rx_prio_boost;	/* SW boost of WiFi rx priority */
 };
 
 #define IWLAGN_BT_SCO_ACTIVE	cpu_to_le32(BIT(0))
-- 
1.7.0.4

