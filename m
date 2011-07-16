Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23684 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab1GPPcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, "Hsu, Kenny" <kenny.hsu@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/18] iwlagn: set default of uCode ownership to driver
Date: Sat, 16 Jul 2011 07:56:32 -0700
Message-Id: <1310828199-18000-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173221_697767_0CD51423)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hsu, Kenny <kenny.hsu@intel.com>

The driver should take the ownership of the uCode as default setting
for later operations after interface up.

Signed-off-by: Kenny Hsu <kenny.hsu@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index d4a6010..d2ba200 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2346,6 +2346,8 @@ int iwlagn_start_device(struct iwl_priv *priv)
 {
 	int ret;
 
+	priv->ucode_owner = IWL_OWNERSHIP_DRIVER;
+
 	if ((priv->cfg->sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
 	     iwl_prepare_card_hw(priv)) {
 		IWL_WARN(priv, "Exit HW not ready\n");
-- 
1.7.0.4

