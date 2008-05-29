Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52678 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbYE2IhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 04/43] iwlwifi: increase max payload of iwl_cmd
Date: Thu, 29 May 2008 16:34:49 +0800
Message-Id: <1212050128-17132-5-git-send-email-yi.zhu@intel.com> (sfid-20080529_103718_520011_36B5B88F)
In-Reply-To: <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch increases iwl_cmd payload maximum size from 360 to 640
to fit some of iwl5000 commands as well.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f7fd8ea..1ee8121 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -307,6 +307,8 @@ struct iwl_cmd_meta {
 
 } __attribute__ ((packed));
 
+#define IWL_CMD_MAX_PAYLOAD 640
+
 /**
  * struct iwl_cmd
  *
@@ -332,7 +334,7 @@ struct iwl_cmd {
 		struct iwl4965_tx_beacon_cmd tx_beacon;
 		struct iwl4965_rxon_assoc_cmd rxon_assoc;
 		u8 *indirect;
-		u8 payload[360];
+		u8 payload[IWL_CMD_MAX_PAYLOAD];
 	} __attribute__ ((packed)) cmd;
 } __attribute__ ((packed));
 
-- 
1.5.3.6

