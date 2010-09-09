Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0IINx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 09:53:27 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 13/14] iwlwifi: cleanup scan initiate check
Date: Thu,  9 Sep 2010 15:52:31 +0200
Message-Id: <1284040354-31703-14-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove redundand checks and use iwl_is_ready_rf().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |   17 +----------------
 1 files changed, 1 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 10b0ccc..9cc4901 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -361,7 +361,7 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 
 	cancel_delayed_work(&priv->scan_check);
 
-	if (!iwl_is_ready(priv)) {
+	if (!iwl_is_ready_rf(priv)) {
 		IWL_WARN(priv, "request scan called when driver not ready.\n");
 		return -EIO;
 	}
@@ -372,26 +372,11 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 		return -EBUSY;
 	}
 
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
-		return -EIO;
-	}
-
 	if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
 		IWL_DEBUG_HC(priv, "Scan request while abort pending.\n");
 		return -EBUSY;
 	}
 
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
-		return -EIO;
-	}
-
-	if (!test_bit(STATUS_READY, &priv->status)) {
-		IWL_DEBUG_HC(priv, "Scan request while uninitialized.\n");
-		return -EBUSY;
-	}
-
 	IWL_DEBUG_INFO(priv, "Starting %sscan...\n",
 			internal ? "internal short " : "");
 
-- 
1.7.1

