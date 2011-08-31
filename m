Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53093 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab1HaGkE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:40:04 -0400
Date: Wed, 31 Aug 2011 09:37:42 +0300
From: Dan Carpenter <error27@gmail.com>
To: emmanuel.grumbach@intel.com
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:INTEL WIRELESS WI..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch -next 1/2] iwlwifi: fix double assign in
 iwl_start_tx_ba_trans_ready()
Message-ID: <20110831063742.GC3705@shale.localdomain> (sfid-20110831_084010_132544_82772E48)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"vif" is assigned twice.  We can remove the first one.

This silences a Smatch warning that "ctx" could be one step past the
end of the priv->contexts[] array.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 20dd1a5..72b9203 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1842,7 +1842,7 @@ void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv,
 				 enum iwl_rxon_context_id ctx,
 				 u8 sta_id, u8 tid)
 {
-	struct ieee80211_vif *vif = priv->contexts[ctx].vif;
+	struct ieee80211_vif *vif;
 	u8 *addr = priv->stations[sta_id].sta.sta.addr;
 
 	if (ctx == NUM_IWL_RXON_CTX)
