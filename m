Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13247 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422Ab0LBQ5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:57:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/5] iwlagn: Enable PCI L1 ACTIVE state after uCode has been loaded
Date: Thu,  2 Dec 2010 08:51:21 -0800
Message-Id: <1291308684-3279-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1291308684-3279-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Grumbach, Emmanuel <emmanuel.grumbach@intel.com>

PCI L1 Active needs to be disabled while loading the uCode so that the bus
doesn't go to sleep. The enablement of L1 Active should be done after
the uCode has sent the ALIVE response. The enablement of L1 Active was
missing.
Enabling L1 Active allows to save power if the BIOS / bus driver allows
it.

I measured the power consumption while not associated and
idle/associated:
L1 Active disabled: 39 mA = 130mW
L1 Active enabled:   6 mA = 20 mW

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 0bdd2bb..24dabcd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -531,6 +531,10 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	/* Enable L1-Active */
+	iwl_clear_bits_prph(priv, APMG_PCIDEV_STT_REG,
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+
 	iwlagn_send_wimax_coex(priv);
 
 	iwlagn_set_Xtal_calib(priv);
-- 
1.7.0.4

