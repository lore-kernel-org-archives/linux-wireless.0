Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:48881 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbZGIJYR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 05:24:17 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2.6.31] iwmc3200wifi: fix NULL pointer dereference in iwm_if_free
Date: Thu,  9 Jul 2009 17:24:15 +0800
Message-Id: <1247131455-26316-1-git-send-email-yi.zhu@intel.com>
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
@@ -151,8 +151,8 @@ void iwm_if_free(struct iwm_priv *iwm)
 		return;
 
 	free_netdev(iwm_to_ndev(iwm));
-	iwm_wdev_free(iwm);
 	iwm_priv_deinit(iwm);
+	iwm_wdev_free(iwm);
 }
 
 int iwm_if_add(struct iwm_priv *iwm)
-- 
1.6.0.4

