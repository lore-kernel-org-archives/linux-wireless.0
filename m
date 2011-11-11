Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50237 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab1KKPDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 10:03:08 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath6kl: Fix bug in setting default key index for tx in AP mode
Date: Fri, 11 Nov 2011 20:33:00 +0530
Message-ID: <1321023781-387-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111111_160312_652458_D878F5CC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vif->def_txkey_index is set to key_index in ath6kl_cfg80211_add_key().
If the interface is configured with multiple static wep keys,
vif->def_txkey_index would be holding the index of the last key configured,
not the default tx key index. Remove this unnecessary default key index setting
in ath6kl_cfg80211_add_key() to configure the right key index in WEP thereby
make it work when multiple wep keys are configured.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 603dbda..89414b1 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -974,8 +974,6 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		   __func__, key_index, key->key_len, key_type,
 		   key_usage, key->seq_len);
 
-	vif->def_txkey_index = key_index;
-
 	if (vif->nw_type == AP_NETWORK && !pairwise &&
 	    (key_type == TKIP_CRYPT || key_type == AES_CRYPT) && params) {
 		ar->ap_mode_bkey.valid = true;
@@ -1010,8 +1008,7 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		return 0;
 	}
 
-	return ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx,
-				     vif->def_txkey_index,
+	return ath6kl_wmi_addkey_cmd(ar->wmi, vif->fw_vif_idx, key_index,
 				     key_type, key_usage, key->key_len,
 				     key->seq, key->seq_len, key->key,
 				     KEY_OP_INIT_VAL,
-- 
1.7.0.4

