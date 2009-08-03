Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55498 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZHCGf3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2009 02:35:29 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 2/3] iwmc3200wifi: set WEP key static flag correctly
Date: Mon,  3 Aug 2009 14:37:02 +0800
Message-Id: <1249281423-26435-3-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1249281423-26435-2-git-send-email-yi.zhu@intel.com>
References: <1249281423-26435-1-git-send-email-yi.zhu@intel.com>
 <1249281423-26435-2-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should only set the static_key flag for open and legacy
authentication types. It should not be set for 802.1X and TKIP.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 0d66370..6b36260 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -596,6 +596,8 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key)
 	key_idx = key->hdr.key_idx;
 
 	if (!remove) {
+		u8 auth_type = iwm->umac_profile->sec.auth_type;
+
 		IWM_DBG_WEXT(iwm, DBG, "key_idx:%d\n", key_idx);
 		IWM_DBG_WEXT(iwm, DBG, "key_len:%d\n", key_len);
 		IWM_DBG_WEXT(iwm, DBG, "MAC:%pM, idx:%d, multicast:%d\n",
@@ -618,7 +620,9 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key)
 			memcpy(&wep40->key_hdr, key_hdr,
 			       sizeof(struct iwm_umac_key_hdr));
 			memcpy(wep40->key, key_data, key_len);
-			wep40->static_key = 1;
+			wep40->static_key =
+				!!((auth_type != UMAC_AUTH_TYPE_8021X) &&
+				   (auth_type != UMAC_AUTH_TYPE_RSNA_PSK));
 
 			cmd_size = sizeof(struct iwm_umac_key_wep40);
 			break;
@@ -632,7 +636,9 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key)
 			memcpy(&wep104->key_hdr, key_hdr,
 			       sizeof(struct iwm_umac_key_hdr));
 			memcpy(wep104->key, key_data, key_len);
-			wep104->static_key = 1;
+			wep104->static_key =
+				!!((auth_type != UMAC_AUTH_TYPE_8021X) &&
+				   (auth_type != UMAC_AUTH_TYPE_RSNA_PSK));
 
 			cmd_size = sizeof(struct iwm_umac_key_wep104);
 			break;
-- 
1.6.0.4

