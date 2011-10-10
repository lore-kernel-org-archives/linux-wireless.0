Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61902 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1JJPQ2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/34] iwlagn: stop interrupts when suspending
Date: Mon, 10 Oct 2011 07:26:57 -0700
Message-Id: <1318256839-31837-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171729_228867_B786930C)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Occasionally, the device will send interrupts
while it is resuming, at a point where we are
not set up again to handle them. This causes
the core IRQ handling to completely disable
the IRQ, and then the driver won't work again
until it is reloaded/rebound.

To fix this issue disable the IRQ on suspend,
this will cause us to only get interrupts
again after we've setup everything on resume.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 60a8ecc..60067c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1377,8 +1377,13 @@ static int iwl_trans_pcie_suspend(struct iwl_trans *trans)
 	 * But of course ... if we have configured WoWLAN then we did other
 	 * things already :-)
 	 */
-	if (!trans->shrd->wowlan)
+	if (!trans->shrd->wowlan) {
 		iwl_apm_stop(priv(trans));
+	} else {
+		iwl_disable_interrupts(trans);
+		iwl_clear_bit(bus(trans), CSR_GP_CNTRL,
+			      CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+	}
 
 	return 0;
 }
-- 
1.7.0.4

