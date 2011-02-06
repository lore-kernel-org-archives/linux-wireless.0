Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:8371 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1BFRnC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 12:43:02 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Don Fry <donald.h.fry@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-2.6.38] iwlagn: Re-enable RF_KILL interrupt when down
Date: Sun,  6 Feb 2011 09:29:45 -0800
Message-Id: <1297013385-9918-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Don Fry <donald.h.fry@intel.com>

With commit 554d1d027b19265c4aa3f718b3126d2b86e09a08 only one RF_KILL
interrupt will be seen by the driver when the interface is down.

Re-enable the interrupt when it occurs to see all transitions.

Signed-off-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f13a83a..a236b8b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1157,6 +1157,9 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & (IWL_DL_ISR)) {
@@ -1371,6 +1374,9 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 	/* only Re-enable if diabled by irq */
 	if (test_bit(STATUS_INT_ENABLED, &priv->status))
 		iwl_enable_interrupts(priv);
+	/* Re-enable RF_KILL if it occurred */
+	else if (handled & CSR_INT_BIT_RF_KILL)
+		iwl_enable_rfkill_int(priv);
 }
 
 /* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
-- 
1.7.0.4

