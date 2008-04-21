Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692AbYDUWmO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 18:42:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 05/11] iwlwifi: remove uneeded callback
Date: Mon, 21 Apr 2008 15:41:55 -0700
Message-Id: <1208817721-11333-6-git-send-email-reinette.chatre@intel.com> (sfid-20080422_004339_766013_A0CC3C3F)
In-Reply-To: <1208817721-11333-5-git-send-email-reinette.chatre@intel.com>
References: <1208817721-11333-1-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-2-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-3-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-4-git-send-email-reinette.chatre@intel.com>
 <1208817721-11333-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch removes callbacks that can be replaced by the generic one.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   42 +--------------------------
 1 files changed, 1 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 2e706be..d6c5658 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -941,13 +941,6 @@ static int iwl4965_send_scan_abort(struct iwl_priv *priv)
 	return rc;
 }
 
-static int iwl4965_card_state_sync_callback(struct iwl_priv *priv,
-					struct iwl_cmd *cmd,
-					struct sk_buff *skb)
-{
-	return 1;
-}
-
 /*
  * CARD_STATE_CMD
  *
@@ -967,40 +960,9 @@ static int iwl4965_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_fla
 		.meta.flags = meta_flag,
 	};
 
-	if (meta_flag & CMD_ASYNC)
-		cmd.meta.u.callback = iwl4965_card_state_sync_callback;
-
 	return iwl_send_cmd(priv, &cmd);
 }
 
-static int iwl4965_add_sta_sync_callback(struct iwl_priv *priv,
-				     struct iwl_cmd *cmd, struct sk_buff *skb)
-{
-	struct iwl4965_rx_packet *res = NULL;
-
-	if (!skb) {
-		IWL_ERROR("Error: Response NULL in REPLY_ADD_STA.\n");
-		return 1;
-	}
-
-	res = (struct iwl4965_rx_packet *)skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_ADD_STA (0x%08X)\n",
-			  res->hdr.flags);
-		return 1;
-	}
-
-	switch (res->u.add_sta.status) {
-	case ADD_STA_SUCCESS_MSK:
-		break;
-	default:
-		break;
-	}
-
-	/* We didn't cache the SKB; let the caller free it */
-	return 1;
-}
-
 int iwl4965_send_add_station(struct iwl_priv *priv,
 			 struct iwl4965_addsta_cmd *sta, u8 flags)
 {
@@ -1013,9 +975,7 @@ int iwl4965_send_add_station(struct iwl_priv *priv,
 		.data = sta,
 	};
 
-	if (flags & CMD_ASYNC)
-		cmd.meta.u.callback = iwl4965_add_sta_sync_callback;
-	else
+	if (!(flags & CMD_ASYNC))
 		cmd.meta.flags |= CMD_WANT_SKB;
 
 	rc = iwl_send_cmd(priv, &cmd);
-- 
1.5.3.4

