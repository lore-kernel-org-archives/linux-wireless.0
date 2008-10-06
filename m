Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbYJFILv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 04:11:51 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 3/7] iwlwifi: scan correct setting of valid rx_chains
Date: Mon,  6 Oct 2008 16:05:29 +0800
Message-Id: <1223280333-4383-4-git-send-email-yi.zhu@intel.com> (sfid-20081006_101202_662428_D0174451)
In-Reply-To: <1223280333-4383-3-git-send-email-yi.zhu@intel.com>
References: <1223280333-4383-1-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-2-git-send-email-yi.zhu@intel.com>
 <1223280333-4383-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch sets rx_chain bitmap correctly according hw configuration.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index bf855c3..debdbd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -703,7 +703,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	u16 cmd_len;
 	enum ieee80211_band band;
 	u8 n_probes = 2;
-	u8 rx_chain = 0x7; /* bitmap: ABC chains */
+	u8 rx_chain = priv->hw_params.valid_rx_ant;
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
-- 
1.5.3.6

