Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23017 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab1DVRzQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 13:55:16 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/10] iwlagn: extend notification wait function
Date: Fri, 22 Apr 2011 10:33:13 -0700
Message-Id: <1303493598-10979-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1303493598-10979-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A notification wait function is called with the
command, but currently has no way of passing
data back to the caller -- fix that by adding a
void pointer to the function that can be used
between the caller and the function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    7 +++++--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h      |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +++-
 5 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 5e62a08..486a8d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -2256,11 +2256,14 @@ int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display)
 /* notification wait support */
 void iwlagn_init_notification_wait(struct iwl_priv *priv,
 				   struct iwl_notification_wait *wait_entry,
+				   u8 cmd,
 				   void (*fn)(struct iwl_priv *priv,
-					      struct iwl_rx_packet *pkt),
-				   u8 cmd)
+					      struct iwl_rx_packet *pkt,
+					      void *data),
+				   void *fn_data)
 {
 	wait_entry->fn = fn;
+	wait_entry->fn_data = fn_data;
 	wait_entry->cmd = cmd;
 	wait_entry->triggered = false;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 56f46ee..ee7c5ba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -58,8 +58,9 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 	u8 old_dev_type = send->dev_type;
 	int ret;
 
-	iwlagn_init_notification_wait(priv, &disable_wait, NULL,
-				      REPLY_WIPAN_DEACTIVATION_COMPLETE);
+	iwlagn_init_notification_wait(priv, &disable_wait,
+				      REPLY_WIPAN_DEACTIVATION_COMPLETE,
+				      NULL, NULL);
 
 	send->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	send->dev_type = RXON_DEV_TYPE_P2P;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index e99cd94..a9204db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -769,7 +769,7 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 				if (w->cmd == pkt->hdr.cmd) {
 					w->triggered = true;
 					if (w->fn)
-						w->fn(priv, pkt);
+						w->fn(priv, pkt, w->fn_data);
 				}
 			}
 			spin_unlock(&priv->_agn.notif_wait_lock);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ef1bbd4..b9871c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -338,9 +338,11 @@ void iwlcore_eeprom_release_semaphore(struct iwl_priv *priv);
 void __acquires(wait_entry)
 iwlagn_init_notification_wait(struct iwl_priv *priv,
 			      struct iwl_notification_wait *wait_entry,
+			      u8 cmd,
 			      void (*fn)(struct iwl_priv *priv,
-					 struct iwl_rx_packet *pkt),
-			      u8 cmd);
+					 struct iwl_rx_packet *pkt,
+					 void *data),
+			      void *fn_data);
 signed long __releases(wait_entry)
 iwlagn_wait_notification(struct iwl_priv *priv,
 			 struct iwl_notification_wait *wait_entry,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e84534c..d8bf117 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1105,7 +1105,9 @@ struct iwl_force_reset {
 struct iwl_notification_wait {
 	struct list_head list;
 
-	void (*fn)(struct iwl_priv *priv, struct iwl_rx_packet *pkt);
+	void (*fn)(struct iwl_priv *priv, struct iwl_rx_packet *pkt,
+		   void *data);
+	void *fn_data;
 
 	u8 cmd;
 	bool triggered;
-- 
1.7.0.4

