Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55498 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbZHCGf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 02:35:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/3] iwmc3200wifi: avoid setting default key for 802.1X and RSNA
Date: Mon,  3 Aug 2009 14:37:03 +0800
Message-Id: <1249281423-26435-4-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1249281423-26435-3-git-send-email-yi.zhu@intel.com>
References: <1249281423-26435-1-git-send-email-yi.zhu@intel.com>
 <1249281423-26435-2-git-send-email-yi.zhu@intel.com>
 <1249281423-26435-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

UMAC only allows us to set default key for WEP and auth type is
not 802.1X or RSNA. This patch fixes iwmc3200wifi for 802.1X with
WEP104.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |   39 +++++++++++++++++--------
 1 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 6b36260..aef9971 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -526,19 +526,6 @@ int iwm_read_mac(struct iwm_priv *iwm, u8 *mac)
 	return 0;
 }
 
-int iwm_set_tx_key(struct iwm_priv *iwm, u8 key_idx)
-{
-	struct iwm_umac_tx_key_id tx_key_id;
-
-	tx_key_id.hdr.oid = UMAC_WIFI_IF_CMD_GLOBAL_TX_KEY_ID;
-	tx_key_id.hdr.buf_size = cpu_to_le16(sizeof(struct iwm_umac_tx_key_id) -
-					     sizeof(struct iwm_umac_wifi_if));
-
-	tx_key_id.key_idx = key_idx;
-
-	return iwm_send_wifi_if_cmd(iwm, &tx_key_id, sizeof(tx_key_id), 1);
-}
-
 static int iwm_check_profile(struct iwm_priv *iwm)
 {
 	if (!iwm->umac_profile_active)
@@ -572,6 +559,32 @@ static int iwm_check_profile(struct iwm_priv *iwm)
 	return 0;
 }
 
+int iwm_set_tx_key(struct iwm_priv *iwm, u8 key_idx)
+{
+	struct iwm_umac_tx_key_id tx_key_id;
+	int ret;
+
+	ret = iwm_check_profile(iwm);
+	if (ret < 0)
+		return ret;
+
+	/* UMAC only allows to set default key for WEP and auth type is
+	 * NOT 802.1X or RSNA. */ 
+	if ((iwm->umac_profile->sec.ucast_cipher != UMAC_CIPHER_TYPE_WEP_40 &&
+	     iwm->umac_profile->sec.ucast_cipher != UMAC_CIPHER_TYPE_WEP_104) ||
+	    iwm->umac_profile->sec.auth_type == UMAC_AUTH_TYPE_8021X ||
+	    iwm->umac_profile->sec.auth_type == UMAC_AUTH_TYPE_RSNA_PSK)
+		return 0;
+
+	tx_key_id.hdr.oid = UMAC_WIFI_IF_CMD_GLOBAL_TX_KEY_ID;
+	tx_key_id.hdr.buf_size = cpu_to_le16(sizeof(struct iwm_umac_tx_key_id) -
+					     sizeof(struct iwm_umac_wifi_if));
+
+	tx_key_id.key_idx = key_idx;
+
+	return iwm_send_wifi_if_cmd(iwm, &tx_key_id, sizeof(tx_key_id), 1);
+}
+
 int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key)
 {
 	int ret = 0;
-- 
1.6.0.4

