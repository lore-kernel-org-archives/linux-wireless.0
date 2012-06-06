Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2FFNXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 27/29] iwlwifi: configure PHY version for 1000 series
Date: Wed,  6 Jun 2012 15:22:08 +0200
Message-Id: <1338988930-11561-27-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152324_145840_5E0CDF3D)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We should also configure the PHY version in the
CSR_HW_IF_CONFIG_REG register for 1000 series
devices, not just for the other devices.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Wey-Yi W Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/devices.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/devices.c b/drivers/net/wireless/iwlwifi/dvm/devices.c
index 747e576..d12f063 100644
--- a/drivers/net/wireless/iwlwifi/dvm/devices.c
+++ b/drivers/net/wireless/iwlwifi/dvm/devices.c
@@ -96,10 +96,7 @@ static void iwl1000_set_ct_threshold(struct iwl_priv *priv)
 /* NIC configuration for 1000 series */
 static void iwl1000_nic_config(struct iwl_priv *priv)
 {
-	/* set CSR_HW_CONFIG_REG for uCode use */
-	iwl_set_bit(priv->trans, CSR_HW_IF_CONFIG_REG,
-		    CSR_HW_IF_CONFIG_REG_BIT_RADIO_SI |
-		    CSR_HW_IF_CONFIG_REG_BIT_MAC_SI);
+	iwl_rf_config(priv);
 
 	/* Setting digital SVR for 1000 card to 1.32V */
 	/* locking is acquired in iwl_set_bits_mask_prph() function */
-- 
1.7.10

