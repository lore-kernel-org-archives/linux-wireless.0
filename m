Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30165 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756126AbYC1XZe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 19:25:34 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6/8] iwlwifi: unregister to upper stack before releasing resources
Date: Fri, 28 Mar 2008 16:21:10 -0700
Message-Id: <1206746472-10443-7-git-send-email-reinette.chatre@intel.com> (sfid-20080328_232541_187982_F37C8718)
In-Reply-To: <1206746472-10443-6-git-send-email-reinette.chatre@intel.com>
References: <1206746472-10443-1-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-2-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-3-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-4-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-5-git-send-email-reinette.chatre@intel.com>
 <1206746472-10443-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch fixes an early release of driver's resources before upper stack
was notified that low-level driver shuts down.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 3ea8c7e..6b69429 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -8208,6 +8208,11 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 
 	IWL_DEBUG_INFO("*** UNLOAD DRIVER ***\n");
 
+	if (priv->mac80211_registered) {
+		ieee80211_unregister_hw(priv->hw);
+		priv->mac80211_registered = 0;
+	}
+
 	set_bit(STATUS_EXIT_PENDING, &priv->status);
 
 	iwl4965_down(priv);
@@ -8242,9 +8247,6 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 	iwl4965_unset_hw_setting(priv);
 	iwlcore_clear_stations_table(priv);
 
-	if (priv->mac80211_registered) {
-		ieee80211_unregister_hw(priv->hw);
-	}
 
 	/*netif_stop_queue(dev); */
 	flush_workqueue(priv->workqueue);
-- 
1.5.3.4

