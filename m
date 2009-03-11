Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbZCKSND (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:03 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/8] iwlwifi: correct log level when error occurs
Date: Wed, 11 Mar 2009 11:18:01 -0700
Message-Id: <1236795481-12757-9-git-send-email-reinette.chatre@intel.com> (sfid-20090311_191315_109565_EB5C32B8)
In-Reply-To: <1236795481-12757-8-git-send-email-reinette.chatre@intel.com>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-2-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-3-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-4-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-5-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-6-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-7-git-send-email-reinette.chatre@intel.com>
 <1236795481-12757-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

user needs to see this message even if debugging disabled

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index da98886..0db3bc0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3359,7 +3359,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* amp init */
 	err = priv->cfg->ops->lib->apm_ops.init(priv);
 	if (err < 0) {
-		IWL_DEBUG_INFO(priv, "Failed to init APMG\n");
+		IWL_ERR(priv, "Failed to init APMG\n");
 		goto out_iounmap;
 	}
 	/*****************
-- 
1.5.6.3

