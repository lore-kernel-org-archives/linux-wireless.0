Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:37278 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab0EHQVS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 12:21:18 -0400
Received: by qyk13 with SMTP id 13so3444207qyk.1
        for <linux-wireless@vger.kernel.org>; Sat, 08 May 2010 09:21:17 -0700 (PDT)
Date: Sat, 8 May 2010 18:21:01 +0200
From: Dan Carpenter <error27@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org
Subject: [patch 1/9] iwlwifi: remove stray mutex_unlock()
Message-ID: <20100508162101.GM27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This mutex_unlock() has been here from the initial commit, but as nearly
as I can tell, there isn't a reason for it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 9dad867..3faa78c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2482,7 +2482,6 @@ int iwl3945_hw_set_hw_params(struct iwl_priv *priv)
 				   &priv->_3945.shared_phys, GFP_KERNEL);
 	if (!priv->_3945.shared_virt) {
 		IWL_ERR(priv, "failed to allocate pci memory\n");
-		mutex_unlock(&priv->mutex);
 		return -ENOMEM;
 	}
 
