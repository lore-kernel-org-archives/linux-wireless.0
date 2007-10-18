Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58571 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbXJRAF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 20:05:29 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, hschaa@suse.de, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] iwlwifi: Fix rate setting in probe request for HW sacn
Date: Thu, 18 Oct 2007 02:04:15 +0200
Message-Id: <11926658551263-git-send-email-tomas.winkler@intel.com> (sfid-20071018_010532_498451_CA953D7C)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes setting of rates in probe request used in
HW scan. The bug was reported by Helmut Schaa <hschaa@suse.de>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   42 ++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   42 ++++++++++++++++----------
 2 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2581675..618c7c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1745,21 +1745,22 @@ static void iwl_unset_hw_setting(struct iwl_priv *priv)
  * return : set the bit for each supported rate insert in ie
  */
 static u16 iwl_supported_rate_to_ie(u8 *ie, u16 supported_rate,
-				    u16 basic_rate, int max_count)
+				    u16 basic_rate, int *left)
 {
 	u16 ret_rates = 0, bit;
 	int i;
-	u8 *rates;
-
-	rates = &(ie[1]);
+	u8 *cnt = ie;
+	u8 *rates = ie + 1;
 
 	for (bit = 1, i = 0; i < IWL_RATE_COUNT; i++, bit <<= 1) {
 		if (bit & supported_rate) {
 			ret_rates |= bit;
-			rates[*ie] = iwl_rates[i].ieee |
-			    ((bit & basic_rate) ? 0x80 : 0x00);
-			*ie = *ie + 1;
-			if (*ie >= max_count)
+			rates[*cnt] = iwl_rates[i].ieee |
+				((bit & basic_rate) ? 0x80 : 0x00);
+			(*cnt)++;
+			(*left)--;
+			if ((*left <= 0) ||
+			    (*cnt >= IWL_SUPPORTED_RATES_IE_LEN))
 				break;
 		}
 	}
@@ -1776,7 +1777,7 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 {
 	int len = 0;
 	u8 *pos = NULL;
-	u16 ret_rates;
+	u16 active_rates, ret_rates, cck_rates;
 
 	/* Make sure there is enough space for the probe request,
 	 * two mandatory IEs and the data */
@@ -1821,19 +1822,27 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	left -= 2;
 	if (left < 0)
 		return 0;
+
 	/* ... fill it in... */
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos = 0;
-	ret_rates = priv->active_rate = priv->rates_mask;
+
+	priv->active_rate = priv->rates_mask;
+	active_rates = priv->active_rate;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
-	iwl_supported_rate_to_ie(pos, priv->active_rate,
-				 priv->active_rate_basic, left);
+	cck_rates = IWL_CCK_RATES_MASK & active_rates;
+	ret_rates = iwl_supported_rate_to_ie(pos, cck_rates,
+			priv->active_rate_basic, &left);
+	active_rates &= ~ret_rates;
+
+	ret_rates = iwl_supported_rate_to_ie(pos, active_rates,
+				 priv->active_rate_basic, &left);
+	active_rates &= ~ret_rates;
+
 	len += 2 + *pos;
 	pos += (*pos) + 1;
-	ret_rates = ~ret_rates & priv->active_rate;
-
-	if (ret_rates == 0)
+	if (active_rates == 0)
 		goto fill_end;
 
 	/* fill in supported extended rate */
@@ -1844,7 +1853,8 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	/* ... fill it in... */
 	*pos++ = WLAN_EID_EXT_SUPP_RATES;
 	*pos = 0;
-	iwl_supported_rate_to_ie(pos, ret_rates, priv->active_rate_basic, left);
+	iwl_supported_rate_to_ie(pos, active_rates,
+				 priv->active_rate_basic, &left);
 	if (*pos > 0)
 		len += 2 + *pos;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 32a99a1..2c84001 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1796,21 +1796,22 @@ static void iwl_unset_hw_setting(struct iwl_priv *priv)
  * return : set the bit for each supported rate insert in ie
  */
 static u16 iwl_supported_rate_to_ie(u8 *ie, u16 supported_rate,
-				    u16 basic_rate, int max_count)
+				    u16 basic_rate, int *left)
 {
 	u16 ret_rates = 0, bit;
 	int i;
-	u8 *rates;
-
-	rates = &(ie[1]);
+	u8 *cnt = ie;
+	u8 *rates = ie + 1;
 
 	for (bit = 1, i = 0; i < IWL_RATE_COUNT; i++, bit <<= 1) {
 		if (bit & supported_rate) {
 			ret_rates |= bit;
-			rates[*ie] = iwl_rates[i].ieee |
-			    ((bit & basic_rate) ? 0x80 : 0x00);
-			*ie = *ie + 1;
-			if (*ie >= max_count)
+			rates[*cnt] = iwl_rates[i].ieee |
+				((bit & basic_rate) ? 0x80 : 0x00);
+			(*cnt)++;
+			(*left)--;
+			if ((*left <= 0) ||
+			    (*cnt >= IWL_SUPPORTED_RATES_IE_LEN))
 				break;
 		}
 	}
@@ -1833,7 +1834,7 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 {
 	int len = 0;
 	u8 *pos = NULL;
-	u16 ret_rates;
+	u16 active_rates, ret_rates, cck_rates;
 
 	/* Make sure there is enough space for the probe request,
 	 * two mandatory IEs and the data */
@@ -1878,19 +1879,27 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	left -= 2;
 	if (left < 0)
 		return 0;
+
 	/* ... fill it in... */
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos = 0;
-	ret_rates = priv->active_rate = priv->rates_mask;
+
+	priv->active_rate = priv->rates_mask;
+	active_rates = priv->active_rate;
 	priv->active_rate_basic = priv->rates_mask & IWL_BASIC_RATES_MASK;
 
-	iwl_supported_rate_to_ie(pos, priv->active_rate,
-				 priv->active_rate_basic, left);
+	cck_rates = IWL_CCK_RATES_MASK & active_rates;
+	ret_rates = iwl_supported_rate_to_ie(pos, cck_rates,
+			priv->active_rate_basic, &left);
+	active_rates &= ~ret_rates;
+
+	ret_rates = iwl_supported_rate_to_ie(pos, active_rates,
+				 priv->active_rate_basic, &left);
+	active_rates &= ~ret_rates;
+
 	len += 2 + *pos;
 	pos += (*pos) + 1;
-	ret_rates = ~ret_rates & priv->active_rate;
-
-	if (ret_rates == 0)
+	if (active_rates == 0)
 		goto fill_end;
 
 	/* fill in supported extended rate */
@@ -1901,7 +1910,8 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	/* ... fill it in... */
 	*pos++ = WLAN_EID_EXT_SUPP_RATES;
 	*pos = 0;
-	iwl_supported_rate_to_ie(pos, ret_rates, priv->active_rate_basic, left);
+	iwl_supported_rate_to_ie(pos, active_rates,
+				 priv->active_rate_basic, &left);
 	if (*pos > 0)
 		len += 2 + *pos;
 
-- 
1.5.2.2
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
