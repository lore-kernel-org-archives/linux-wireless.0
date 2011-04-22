Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23017 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab1DVRzN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/10] iwlagn: make iwlagn_wait_notification return error code
Date: Fri, 22 Apr 2011 10:33:14 -0700
Message-Id: <1303493598-10979-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We're unlikely to care about the actual time spent
waiting, so make the function return an error code
which is less error prone in coding new uses.

Also, while at it, mark __must_check.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   11 +++++++----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 486a8d3..8284168 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2272,9 +2272,9 @@ void iwlagn_init_notification_wait(struct iwl_priv *priv,
 	spin_unlock_bh(&priv->_agn.notif_wait_lock);
 }
 
-signed long iwlagn_wait_notification(struct iwl_priv *priv,
-				     struct iwl_notification_wait *wait_entry,
-				     unsigned long timeout)
+int iwlagn_wait_notification(struct iwl_priv *priv,
+			     struct iwl_notification_wait *wait_entry,
+			     unsigned long timeout)
 {
 	int ret;
 
@@ -2286,7 +2286,10 @@ signed long iwlagn_wait_notification(struct iwl_priv *priv,
 	list_del(&wait_entry->list);
 	spin_unlock_bh(&priv->_agn.notif_wait_lock);
 
-	return ret;
+	/* return value is always >= 0 */
+	if (ret <= 0)
+		return -ETIMEDOUT;
+	return 0;
 }
 
 void iwlagn_remove_notification(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index ee7c5ba..435dd2d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -73,13 +73,9 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 		IWL_ERR(priv, "Error disabling PAN (%d)\n", ret);
 		iwlagn_remove_notification(priv, &disable_wait);
 	} else {
-		signed long wait_res;
-
-		wait_res = iwlagn_wait_notification(priv, &disable_wait, HZ);
-		if (wait_res == 0) {
+		ret = iwlagn_wait_notification(priv, &disable_wait, HZ);
+		if (ret)
 			IWL_ERR(priv, "Timed out waiting for PAN disable\n");
-			ret = -EIO;
-		}
 	}
 
 	return ret;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index b9871c4..ba90aa4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -343,7 +343,7 @@ iwlagn_init_notification_wait(struct iwl_priv *priv,
 					 struct iwl_rx_packet *pkt,
 					 void *data),
 			      void *fn_data);
-signed long __releases(wait_entry)
+int __must_check __releases(wait_entry)
 iwlagn_wait_notification(struct iwl_priv *priv,
 			 struct iwl_notification_wait *wait_entry,
 			 unsigned long timeout);
-- 
1.7.0.4

