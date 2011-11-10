Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935349Ab1KJPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:38 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 05/27] iwlagn: fix NULL ptr deref when reprogramming sta w/o LQ
Date: Thu, 10 Nov 2011 06:55:05 -0800
Message-Id: <1320936927-9078-6-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_165046_636235_CF03FB4C)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Reinette reports a crash in iwl_reprogram_ap_sta(). The
debugging shows:

  b1 16    mov    $0x16,%cl
 *f3 a5    rep movsl %ds     <-- trapping instruction:(%rsi),%es:(%rdi)

which is a memcpy of 22 (0x16) words (movsl). this points
to "priv->stations[sta_id].lq" being NULL since that is
the memcpy() of that size here.

The only way I see for this to happen is if we try to
do some RXON reprogramming while connecting to an AP,
after tx_sync() but before full setup, but that seems
like something that might very well happen.

Fix this by checking if the LQ is present and only then
reprogramming it.

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 9306768..1b112df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -647,7 +647,7 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	int ret;
 	struct iwl_addsta_cmd sta_cmd;
 	struct iwl_link_quality_cmd lq;
-	bool active;
+	bool active, have_lq = false;
 
 	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
 	if (!(priv->stations[sta_id].used & IWL_STA_DRIVER_ACTIVE)) {
@@ -657,7 +657,10 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 
 	memcpy(&sta_cmd, &priv->stations[sta_id].sta, sizeof(sta_cmd));
 	sta_cmd.mode = 0;
-	memcpy(&lq, priv->stations[sta_id].lq, sizeof(lq));
+	if (priv->stations[sta_id].lq) {
+		memcpy(&lq, priv->stations[sta_id].lq, sizeof(lq));
+		have_lq = true;
+	}
 
 	active = priv->stations[sta_id].used & IWL_STA_UCODE_ACTIVE;
 	priv->stations[sta_id].used &= ~IWL_STA_DRIVER_ACTIVE;
@@ -679,7 +682,8 @@ void iwl_reprogram_ap_sta(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 	if (ret)
 		IWL_ERR(priv, "failed to re-add STA %pM (%d)\n",
 			priv->stations[sta_id].sta.sta.addr, ret);
-	iwl_send_lq_cmd(priv, ctx, &lq, CMD_SYNC, true);
+	if (have_lq)
+		iwl_send_lq_cmd(priv, ctx, &lq, CMD_SYNC, true);
 }
 
 int iwl_get_free_ucode_key_offset(struct iwl_priv *priv)
-- 
1.7.0.4

