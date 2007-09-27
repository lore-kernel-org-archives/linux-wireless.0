Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbXI0Des (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:34:48 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: Correction for sending beacon in config_ap
Date: Thu, 27 Sep 2007 11:27:32 +0800
Message-Id: <11908636692415-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11908636683204-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch takes out sending beacon from conditional in
config_ap function.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 8ae7c30..af261e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7495,9 +7495,8 @@ static void iwl_config_ap(struct iwl_priv *priv)
 		iwl_activate_qos(priv, 1);
 #endif
 		iwl_rxon_add_station(priv, BROADCAST_ADDR, 0);
-		iwl_send_beacon_cmd(priv);
-	} else
-		iwl_send_beacon_cmd(priv);
+	}
+	iwl_send_beacon_cmd(priv);
 
 	/* FIXME - we need to add code here to detect a totally new
 	 * configuration, reset the AP, unassoc, rxon timing, assoc,
-- 
1.5.1
