Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932597Ab0DPVwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 18/21] iwlwifi: rename TX_CMD_FLG_BT_DIS_MSK
Date: Fri, 16 Apr 2010 14:52:35 -0700
Message-Id: <1271454758-14351-19-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The flag name is a little misleading, this
flag instructs the device to ignore bluetooth
messages for purposes of frame transmissions,
so rename the flag to TX_CMD_FLG_IGNORE_BT.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index d830086..67c723c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1443,7 +1443,7 @@ struct iwl4965_rx_mpdu_res_start {
 
 /* 1: Ignore Bluetooth priority for this frame.
  * 0: Delay Tx until Bluetooth device is done (normal usage). */
-#define TX_CMD_FLG_BT_DIS_MSK cpu_to_le32(1 << 12)
+#define TX_CMD_FLG_IGNORE_BT cpu_to_le32(1 << 12)
 
 /* 1: uCode overrides sequence control field in MAC header.
  * 0: Driver provides sequence control field in MAC header.
-- 
1.6.3.3

