Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53441 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab0DIUJk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:40 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/12] iwlwifi: fix compiler warning
Date: Fri,  9 Apr 2010 13:09:28 -0700
Message-Id: <1270843769-30017-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Check return code on iwl_send_cmd_pdu() to get rid of compiler warning.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 9b4d527..d86ecd2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -425,6 +425,7 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 		.reserved1 = 0,
 	};
 	u32 rate_flags;
+	int ret = 0;
 
 	/* Set up the rate scaling to start at selected rate, fall back
 	 * all the way down to 1M in IEEE order, and then spin on 1M */
@@ -458,8 +459,10 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
 	/* Update the rate scaling for control frame Tx to AP */
 	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
 
-	iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
+	ret = iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
 			       sizeof(link_cmd), &link_cmd);
+	if (ret)
+		IWL_ERR(priv, "REPLY_TX_LINK_QUALITY_CMD failed (%d)\n", ret);
 }
 
 /*
-- 
1.6.3.3

