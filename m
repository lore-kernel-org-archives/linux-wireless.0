Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12884 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964891AbZGQQad (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:33 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/14] iwlwifi: clarify hardware error message
Date: Fri, 17 Jul 2009 09:30:25 -0700
Message-Id: <1247848227-24031-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-12-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-8-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-9-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-10-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-11-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-12-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

When a hardware error is detected we need to be clear about that
and not create impression that the microcode is able to deal
with it.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ff4a546..b7ac4ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -923,7 +923,7 @@ static void iwl_irq_tasklet_legacy(struct iwl_priv *priv)
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
-		IWL_ERR(priv, "Microcode HW error detected.  Restarting.\n");
+		IWL_ERR(priv, "Hardware error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
 		iwl_disable_interrupts(priv);
@@ -1096,7 +1096,7 @@ static void iwl_irq_tasklet(struct iwl_priv *priv)
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
-		IWL_ERR(priv, "Microcode HW error detected.  Restarting.\n");
+		IWL_ERR(priv, "Hardware error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
 		iwl_disable_interrupts(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 221a875..8891d6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1663,7 +1663,7 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 
 	/* Now service all interrupt bits discovered above. */
 	if (inta & CSR_INT_BIT_HW_ERR) {
-		IWL_ERR(priv, "Microcode HW error detected.  Restarting.\n");
+		IWL_ERR(priv, "Hardware error detected.  Restarting.\n");
 
 		/* Tell the device to stop sending interrupts */
 		iwl_disable_interrupts(priv);
-- 
1.5.6.3

