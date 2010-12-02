Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757605Ab0LBQ5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:57:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/5] iwlagn: fix race condition when reprogram sta
Date: Thu,  2 Dec 2010 08:51:20 -0800
Message-Id: <1291308684-3279-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

During reprogram stations, do not send link quality command.
uCode will crash if receive link quality command for invalid station

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-sta.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 0a67b2f..4776323 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -647,6 +647,7 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	memcpy(&lq, priv->stations[sta_id].lq, sizeof(lq));
 
 	active = priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE;
+	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
 	spin_unlock_irqrestore(&priv->sta_lock, flags);
 
 	if (active) {
@@ -657,6 +658,10 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 			IWL_ERR(priv, "failed to remove STA %pM (%d)\n",
 				priv->stations[sta_id].sta.sta.addr, ret);
 	}
+	spin_lock_irqsave(&priv->sta_lock, flags);
+	priv->stations[sta_id].used |= IWL_STA_DRIVER_ACTIVE;
+	spin_unlock_irqrestore(&priv->sta_lock, flags);
+
 	ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
 	if (ret)
 		IWL_ERR(priv, "failed to re-add STA %pM (%d)\n",
@@ -777,6 +782,14 @@ int iwl_send_lq_cmd(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	if (WARN_ON(lq->sta_id == IWL_INVALID_STATION))
 		return -EINVAL;
 
+
+	spin_lock_irqsave(&priv->sta_lock, flags_spin);
+	if (!(priv->stations[lq->sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
+		spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+		return -EINVAL;
+	}
+	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
+
 	iwl_dump_lq_cmd(priv, lq);
 	BUG_ON(init && (cmd.flags & CMD_ASYNC));
 
-- 
1.7.0.4

