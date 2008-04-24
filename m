Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51299 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674AbYDXSzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:49 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 16/21] iwlwifi-5000: add iwl 5000 shared memory handlers
Date: Thu, 24 Apr 2008 11:55:33 -0700
Message-Id: <1209063338-6572-17-git-send-email-reinette.chatre@intel.com> (sfid-20080424_210549_014109_5359F0B3)
In-Reply-To: <1209063338-6572-16-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-10-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-11-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-12-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-13-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-14-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-15-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-16-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fills the needed handlers for shared memory for
iwl 5000 family

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8bccd90..8e2a6a5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -291,6 +291,29 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 	return 0;
 }
+
+static int iwl5000_alloc_shared_mem(struct iwl_priv *priv)
+{
+	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
+					sizeof(struct iwl5000_shared),
+					&priv->shared_phys);
+	if (!priv->shared_virt)
+		return -ENOMEM;
+
+	memset(priv->shared_virt, 0, sizeof(struct iwl5000_shared));
+
+	return 0;
+}
+
+static void iwl5000_free_shared_mem(struct iwl_priv *priv)
+{
+	if (priv->shared_virt)
+		pci_free_consistent(priv->pci_dev,
+				    sizeof(struct iwl5000_shared),
+				    priv->shared_virt,
+				    priv->shared_phys);
+}
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
@@ -303,6 +326,8 @@ static struct iwl_hcmd_utils_ops iwl5000_hcmd_utils = {
 
 static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
+	.alloc_shared_mem = iwl5000_alloc_shared_mem,
+	.free_shared_mem = iwl5000_free_shared_mem,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.set_pwr_src = iwl4965_set_pwr_src,
-- 
1.5.3.4

