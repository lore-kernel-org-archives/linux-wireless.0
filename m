Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34245 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbZAWVm4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 16:42:56 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, "Zhu, Yi" <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/15] iwlwifi: fix kernel oops when ucode DMA memory allocation failure
Date: Fri, 23 Jan 2009 13:45:22 -0800
Message-Id: <1232747123-7261-15-git-send-email-reinette.chatre@intel.com> (sfid-20090123_230906_179195_73552654)
In-Reply-To: <1232747123-7261-14-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232747123-7261-1-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-2-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-3-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-4-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-5-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-6-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-7-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-8-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-9-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-10-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-11-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-12-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-13-git-send-email-reinette.chatre@intel.com>
 <1232747123-7261-14-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu, Yi <yi.zhu@intel.com>

The patch fixes memcpy to NULL address when the ucode DMA allocation failure.

This is a fix to bug
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1861

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 757a9bd..6b7120a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1866,6 +1866,10 @@ static int iwl_read_ucode(struct iwl_priv *priv)
 	priv->ucode_data_backup.len = data_size;
 	iwl_alloc_fw_desc(priv->pci_dev, &priv->ucode_data_backup);
 
+	if (!priv->ucode_code.v_addr || !priv->ucode_data.v_addr ||
+	    !priv->ucode_data_backup.v_addr)
+		goto err_pci_alloc;
+
 	/* Initialization instructions and data */
 	if (init_size && init_data_size) {
 		priv->ucode_init.len = init_size;
-- 
1.5.4.3

