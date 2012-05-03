Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:62071 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758Ab2ECV2n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 17:28:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/6] iwlwifi: make sure reduced tx power bit is valid
Date: Thu,  3 May 2012 14:22:03 -0700
Message-Id: <1336080126-22606-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120503_232853_837085_E02B2FB6)
In-Reply-To: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1336080126-22606-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once driver decide to change reduced tx power behavior,
make sure the reduce tx power valid bit is set

Change-Id: I3afae96319292d8cb347a812a948085c5db7ad91
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Reviewed-on: http://git-mwg.jer.intel.com/gerrit/1948
Tested-by: Jenkins
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index cb4b31f..e55ec6c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -643,7 +643,7 @@ static bool iwlagn_fill_txpower_mode(struct iwl_priv *priv,
 		   BT_UART_MSG_FRAME3OBEX_MSK)))) {
 		/* disable reduced tx power */
 		priv->reduced_txpower = false;
-		priv->bt_valid &= ~IWLAGN_BT_VALID_REDUCED_TX_PWR;
+		priv->bt_valid |= IWLAGN_BT_VALID_REDUCED_TX_PWR;
 		need_update = true;
 	}
 
-- 
1.7.0.4

