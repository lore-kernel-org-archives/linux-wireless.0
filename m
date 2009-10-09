Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28629 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761362AbZJIUWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 16:22:40 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/17] iwl3945: move iwl_power_initialize()
Date: Fri,  9 Oct 2009 13:20:27 -0700
Message-Id: <1255119634-3060-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

iwl_power_initialize() initializes driver data (not device hardware), and does
not need to execute more than once (when the driver initializes).  Therefore, it
does not belong in iwl3945_apm_init(), which initializes hardware, and may run
more than once.

Move it to iwl3945_pci_probe(), where it will run only once.  This agrees
with similar placement in iwl-agn.c's iwl_pci_probe(), although placement
under "services" seemed more appropriate than under "mac80211".

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index f8ce96c..4e15a8e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -991,8 +991,6 @@ static int iwl3945_apm_init(struct iwl_priv *priv)
 {
 	int ret;
 
-	iwl_power_initialize(priv);
-
 	/* Configure chip clock phase-lock-loop */
 	iwl_set_bit(priv, CSR_ANA_PLL_CFG, CSR39_ANA_PLL_CFG_VAL);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2406b73..e0e566c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4064,6 +4064,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 			     &priv->bands[IEEE80211_BAND_2GHZ].channels[5]);
 	iwl3945_setup_deferred_work(priv);
 	iwl3945_setup_rx_handlers(priv);
+	iwl_power_initialize(priv);
 
 	/*********************************
 	 * 8. Setup and Register mac80211
-- 
1.5.6.3

