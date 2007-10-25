Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639AbXJYJW5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 05:22:57 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mabbas <mabbas@linux.intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 21/30] iwl4965: exclude 60M rate from probe request
Date: Thu, 25 Oct 2007 17:15:42 +0800
Message-Id: <11933037822284-git-send-email-yi.zhu@intel.com> (sfid-20071025_104057_755620_724DC021)
In-Reply-To: <11933037812209-git-send-email-yi.zhu@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com>
 <11933037541699-git-send-email-yi.zhu@intel.com>
 <11933037553170-git-send-email-yi.zhu@intel.com>
 <119330375796-git-send-email-yi.zhu@intel.com>
 <11933037584069-git-send-email-yi.zhu@intel.com>
 <11933037601236-git-send-email-yi.zhu@intel.com>
 <11933037613709-git-send-email-yi.zhu@intel.com>
 <1193303762680-git-send-email-yi.zhu@intel.com>
 <11933037641168-git-send-email-yi.zhu@intel.com>
 <11933037663659-git-send-email-yi.zhu@intel.com>
 <11933037674045-git-send-email-yi.zhu@intel.com>
 <11933037692766-git-send-email-yi.zhu@intel.com>
 <1193303770550-git-send-email-yi.zhu@intel.com>
 <11933037721573-git-send-email-yi.zhu@intel.com>
 <1193303773185-git-send-email-yi.zhu@intel.com>
 <11933037743841-git-send-email-yi.zhu@intel.com>
 <11933037762104-git-send-email-yi.zhu@intel.com>
 <11933037784073-git-send-email-yi.zhu@intel.com>
 <11933037794199-git-send-email-yi.zhu@intel.com>
 <11933037812209-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: mabbas <mabbas@linux.intel.com>

This patch do the following 2 things:
1. Make sure we don't add rate 60M part of supported rate in proble request,
   some AP does not like that.
2. It is wrong to set priv->active_rate in this function, this will set
   it to all avialable rates which might overwrite the mode supported rate.
   priv->active_rate should be set by only from iwl_set_rate.

Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index dad184a..dc2d25c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1831,7 +1831,7 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 {
 	int len = 0;
 	u8 *pos = NULL;
-	u16 active_rates, ret_rates, cck_rates;
+	u16 active_rates, ret_rates, cck_rates, active_rate_basic;
 
 	/* Make sure there is enough space for the probe request,
 	 * two mandatory IEs and the data */
@@ -1881,17 +1881,19 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos = 0;
 
-	priv->active_rate = priv->rates_mask;
-	active_rates = priv->active_rate;
-	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
+	/* exclude 60M rate */
+	active_rates = priv->rates_mask;
+	active_rates &= ~IWL_RATE_60M_MASK;
+
+	active_rate_basic = active_rates & IWL_BASIC_RATES_MASK;
 
 	cck_rates = IWL_CCK_RATES_MASK & active_rates;
 	ret_rates = iwl_supported_rate_to_ie(pos, cck_rates,
-			priv->active_rate_basic, &left);
+			active_rate_basic, &left);
 	active_rates &= ~ret_rates;
 
 	ret_rates = iwl_supported_rate_to_ie(pos, active_rates,
-				 priv->active_rate_basic, &left);
+				 active_rate_basic, &left);
 	active_rates &= ~ret_rates;
 
 	len += 2 + *pos;
@@ -1908,7 +1910,7 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	*pos++ = WLAN_EID_EXT_SUPP_RATES;
 	*pos = 0;
 	iwl_supported_rate_to_ie(pos, active_rates,
-				 priv->active_rate_basic, &left);
+				 active_rate_basic, &left);
 	if (*pos > 0)
 		len += 2 + *pos;
 
-- 
1.5.2
