Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20196 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZFYK2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2009 06:28:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 4/4] iwmc3200wifi: fix NULL pointer dereference in iwm_if_free
Date: Thu, 25 Jun 2009 18:28:33 +0800
Message-Id: <1245925713-14908-5-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1245925713-14908-4-git-send-email-yi.zhu@intel.com>
References: <1245925713-14908-1-git-send-email-yi.zhu@intel.com>
 <1245925713-14908-2-git-send-email-yi.zhu@intel.com>
 <1245925713-14908-3-git-send-email-yi.zhu@intel.com>
 <1245925713-14908-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver private data is now based on wiphy. So we should not
touch the private data after wiphy_free() is called. The patch
fixes the potential NULL pointer dereference by making the
iwm_wdev_free() the last one on the interface removal path.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/netdev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index e94e969..bb71f8a 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -155,11 +155,11 @@ void iwm_if_free(struct iwm_priv *iwm)
 	if (!iwm_to_ndev(iwm))
 		return;
 
-	free_netdev(iwm_to_ndev(iwm));
-	iwm_wdev_free(iwm);
-	iwm_priv_deinit(iwm);
 	kfree(iwm->umac_profile);
 	iwm->umac_profile = NULL;
+	free_netdev(iwm_to_ndev(iwm));
+	iwm_priv_deinit(iwm);
+	iwm_wdev_free(iwm);
 }
 
 int iwm_if_add(struct iwm_priv *iwm)
-- 
1.6.0.4

