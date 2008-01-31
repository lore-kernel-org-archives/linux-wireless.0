Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:6441 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbYAaGKc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 01:10:32 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/5] iwlwifi: fix merge error
Date: Wed, 30 Jan 2008 22:05:16 -0800
Message-Id: <1201759516-28963-6-git-send-email-reinette.chatre@intel.com> (sfid-20080131_061037_777580_6FC94DDD)
In-Reply-To: <1201759516-28963-5-git-send-email-reinette.chatre@intel.com>
References: <1201759516-28963-1-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-2-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-3-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-4-git-send-email-reinette.chatre@intel.com>
 <1201759516-28963-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This merge error crept into wireless-2.6. It is similar to an error we fixed
before (see "wireless: cleanup some merge errors"). The original patch to
refer to is "iwlwifi: fix possible priv->mutex deadlock during suspend".

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 15594fd..789a9cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -8512,8 +8512,8 @@ static void iwl3945_pci_remove(struct pci_dev *pdev)
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
-	__iwl3945_down(priv);
-	mutex_unlock(&priv->mutex);
+
+	iwl3945_down(priv);
 
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 788e176..5a13f0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -9060,8 +9060,8 @@ static void iwl4965_pci_remove(struct pci_dev *pdev)
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
-	__iwl4965_down(priv);
-	mutex_unlock(&priv->mutex);
+
+	iwl4965_down(priv);
 
 	/* Free MAC hash list for ADHOC */
 	for (i = 0; i < IWL_IBSS_MAC_HASH_SIZE; i++) {
-- 
1.5.3.4

