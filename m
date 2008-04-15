Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17848 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbYDOEQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 00:16:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/12] iwl4965: make iwl4956_send_rxon_assoc asynchronous
Date: Mon, 14 Apr 2008 21:16:11 -0700
Message-Id: <1208232974-3828-10-git-send-email-reinette.chatre@intel.com> (sfid-20080415_052249_199602_D502431D)
In-Reply-To: <1208232974-3828-9-git-send-email-reinette.chatre@intel.com>
References: <1208232974-3828-1-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-2-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-3-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-4-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-5-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-6-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-7-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-8-git-send-email-reinette.chatre@intel.com>
 <1208232974-3828-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   27 ++++++---------------------
 1 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 60c0b83..9fb9857 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -758,15 +758,8 @@ static int iwl4965_full_rxon_required(struct iwl_priv *priv)
 
 static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 {
-	int rc = 0;
-	struct iwl4965_rx_packet *res = NULL;
+	int ret = 0;
 	struct iwl4965_rxon_assoc_cmd rxon_assoc;
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_RXON_ASSOC,
-		.len = sizeof(rxon_assoc),
-		.meta.flags = CMD_WANT_SKB,
-		.data = &rxon_assoc,
-	};
 	const struct iwl4965_rxon_cmd *rxon1 = &priv->staging_rxon;
 	const struct iwl4965_rxon_cmd *rxon2 = &priv->active_rxon;
 
@@ -794,20 +787,12 @@ static int iwl4965_send_rxon_assoc(struct iwl_priv *priv)
 	    priv->staging_rxon.ofdm_ht_dual_stream_basic_rates;
 	rxon_assoc.rx_chain_select_flags = priv->staging_rxon.rx_chain;
 
-	rc = iwl_send_cmd_sync(priv, &cmd);
-	if (rc)
-		return rc;
-
-	res = (struct iwl4965_rx_packet *)cmd.meta.u.skb->data;
-	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERROR("Bad return from REPLY_RXON_ASSOC command\n");
-		rc = -EIO;
-	}
-
-	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.meta.u.skb);
+	ret = iwl_send_cmd_pdu_async(priv, REPLY_RXON_ASSOC,
+				     sizeof(rxon_assoc), &rxon_assoc, NULL);
+	if (ret)
+		return ret;
 
-	return rc;
+	return ret;
 }
 
 /**
-- 
1.5.3.4

