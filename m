Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13420 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759945AbXG3C7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2007 22:59:42 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 5/8] iwlwifi: Fix compilation conditional
Date: Mon, 30 Jul 2007 10:57:03 +0800
Message-Id: <11857642421391-git-send-email-yi.zhu@intel.com>
In-Reply-To: <11857642401149-git-send-email-yi.zhu@intel.com>
References: <11857642261522-git-send-email-yi.zhu@intel.com>
 <11857642343783-git-send-email-yi.zhu@intel.com>
 <11857642362891-git-send-email-yi.zhu@intel.com>
 <1185764238442-git-send-email-yi.zhu@intel.com>
 <11857642401149-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Fixing compilation conditional:
CONFIG_IWLWIFI_HT -> CONFIG_IWLWIFI_HT_AGG

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwl-4965.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwl-4965.c b/drivers/net/wireless/iwl-4965.c
index c791132..cc2dd49 100644
--- a/drivers/net/wireless/iwl-4965.c
+++ b/drivers/net/wireless/iwl-4965.c
@@ -3826,9 +3826,9 @@ static void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 		.antenna = 0,
 		.rate = iwl4965_get_rate(rx_start->rate_n_flags),
 		.flag = le16_to_cpu(rx_start->phy_flags),
-#ifdef CONFIG_IWLWIFI_HT
+#ifdef CONFIG_IWLWIFI_HT_AGG
 		.ordered = 0
-#endif
+#endif /* CONFIG_IWLWIFI_HT_AGG */
 	};
 	u8 network_packet;
 
-- 
1.5.2
