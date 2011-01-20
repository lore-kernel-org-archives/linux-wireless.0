Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16872 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab1ATPgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 10:36:21 -0500
Subject: Re: iwl4965: 11n broken
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <201101201242.24680.helmut.schaa@googlemail.com>
References: <201101201242.24680.helmut.schaa@googlemail.com>
Content-Type: multipart/mixed; boundary="=-LiMZ9XNGbDEYB2sg3rfB"
Date: Thu, 20 Jan 2011 07:35:07 -0800
Message-Id: <1295537707.21281.1.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LiMZ9XNGbDEYB2sg3rfB
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Helmut,

On Thu, 2011-01-20 at 03:42 -0800, Helmut Schaa wrote:
> Hi,
> 
> I've just updated my workstation to wireless-testing from last
> week (2.6.37-wl-default+). When associating to a 11n router the
> card only associates as 11g, the assoc request doesn't contain
> any HT IEs.
> 
> The causing commit is:
> 
> commit 21a5b3c6b19a8b8972ccdd55389be28a8b7c9180
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Wed Nov 10 13:32:59 2010 -0800
> 
>     iwlagn: use SKU information in the EEPROM
>     
>     EEPROM contain the SKU information for the device, use it.
>     
>     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> 
> Seems as if the device eeprom hasn't set EEPROM_SKU_CAP_11N_ENABLE and thus
> iwlagn thinks the device is not 11n capable.
> 
> Ideas? Should we just revert the 4965 part of the patch and modify 
> iwl_eeprom_check_sku to allow overwriting the sku field? Do 4965 devices
> exists that are not 11n capable?
> 
Sorry for the mistake, here I attach the patch to address this issue.
Please give a try to see if it fix it, I will also push this patch
upstream if works for you.

Thanks
Wey

--=-LiMZ9XNGbDEYB2sg3rfB
Content-Disposition: attachment; filename="0001-iwlwifi-don-t-read-sku-information-from-EEPROM-for.patch"
Content-Type: text/x-patch; name="0001-iwlwifi-don-t-read-sku-information-from-EEPROM-for.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 98af51fc1635b2b2138e66def03acc1fe8eb8329 Mon Sep 17 00:00:00 2001
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date: Thu, 20 Jan 2011 07:32:06 -0800
Subject: [PATCH 1/1] iwlwifi: don't read sku information from EEPROM for 4965

For all the new devices, the sku information should read from EEPROM
but for legacy devices such as 4965, appearly the EEPROM does not
contain the necessary information. so skip the read from EEPROM
and go back to use software configuration.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c       |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index dada0c3..6eae0b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2621,6 +2621,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.fw_name_pre = IWL4965_FW_PRE,
 	.ucode_api_max = IWL4965_UCODE_API_MAX,
 	.ucode_api_min = IWL4965_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 14ceb4d..27b5a3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -152,11 +152,14 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 
 	eeprom_sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
 
-	priv->cfg->sku = ((eeprom_sku & EEPROM_SKU_CAP_BAND_SELECTION) >>
+	if (!priv->cfg->sku) {
+		/* not using sku overwrite */
+		priv->cfg->sku =
+			((eeprom_sku & EEPROM_SKU_CAP_BAND_SELECTION) >>
 			EEPROM_SKU_CAP_BAND_POS);
-	if (eeprom_sku & EEPROM_SKU_CAP_11N_ENABLE)
-		priv->cfg->sku |= IWL_SKU_N;
-
+		if (eeprom_sku & EEPROM_SKU_CAP_11N_ENABLE)
+			priv->cfg->sku |= IWL_SKU_N;
+	}
 	if (!priv->cfg->sku) {
 		IWL_ERR(priv, "Invalid device sku\n");
 		return -EINVAL;
-- 
1.6.0.4


--=-LiMZ9XNGbDEYB2sg3rfB--

