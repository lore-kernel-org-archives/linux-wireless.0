Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55576 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbZDTVbG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:06 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/11] iwl3945: use cancel_delayed_work_sync to cancel rfkill_poll
Date: Mon, 20 Apr 2009 14:37:01 -0700
Message-Id: <1240263424-8495-9-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233119_605451_859854EB)
In-Reply-To: <1240263424-8495-8-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-5-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-6-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-7-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Users reported lockup with work still trying to run
after module has been unloaded.

http://thread.gmane.org/gmane.linux.kernel.wireless.general/30594/focus=30601

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reported-by: TJ <ubuntu@tjworld.net>
Reported-by: Huaxu Wan <huaxu.wan@linux.intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index e22282e..a776326 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4436,7 +4436,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	sysfs_remove_group(&pdev->dev.kobj, &iwl3945_attribute_group);
 
 	iwl_rfkill_unregister(priv);
-	cancel_delayed_work(&priv->rfkill_poll);
+	cancel_delayed_work_sync(&priv->rfkill_poll);
 
 	iwl3945_dealloc_ucode_pci(priv);
 
-- 
1.5.6.3

