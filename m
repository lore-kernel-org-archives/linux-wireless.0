Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbZGPJdO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:33:14 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/10] iwmc3200wifi: make iwm_send_wifi_if_cmd return 0 on success
Date: Thu, 16 Jul 2009 17:34:12 +0800
Message-Id: <1247736854-6760-8-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1247736854-6760-7-git-send-email-yi.zhu@intel.com>
References: <1247736854-6760-1-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-2-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-3-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-4-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-5-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-6-git-send-email-yi.zhu@intel.com>
 <1247736854-6760-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We used to return the result of wait_event_interruptible_timeout()
which is the remaining timeout on success. But this information is
not used by any of its callers. So we just return 0 on success.
This fixed a erroneous return value bug for iwm_set_key().

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |   27 ++++++++++++-------------
 1 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 0d35afe..e6be297 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -87,8 +87,7 @@ int iwm_send_wifi_if_cmd(struct iwm_priv *iwm, void *payload, u16 payload_size,
 				   test_and_clear_bit(oid, &iwm->wifi_ntfy[0]),
 				   3 * HZ);
 
-		if (!ret)
-			ret = -EBUSY;
+		return ret ? 0 : -EBUSY;
 	}
 
 	return ret;
@@ -480,8 +479,10 @@ static int iwm_target_read(struct iwm_priv *iwm, __le32 address,
 	target_cmd.eop = 1;
 
 	ret = iwm_hal_send_target_cmd(iwm, &target_cmd, NULL);
-	if (ret < 0)
+	if (ret < 0) {
 		IWM_ERR(iwm, "Couldn't send READ command\n");
+		return ret;
+	}
 
 	/* When succeding, the send_target routine returns the seq number */
 	seq_num = ret;
@@ -501,7 +502,7 @@ static int iwm_target_read(struct iwm_priv *iwm, __le32 address,
 
 	kfree(cmd);
 
-	return ret;
+	return 0;
 }
 
 int iwm_read_mac(struct iwm_priv *iwm, u8 *mac)
@@ -511,7 +512,7 @@ int iwm_read_mac(struct iwm_priv *iwm, u8 *mac)
 
 	ret = iwm_target_read(iwm, cpu_to_le32(WICO_MAC_ADDRESS_ADDR),
 			      mac_align, sizeof(mac_align));
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	if (is_valid_ether_addr(mac_align))
@@ -714,7 +715,7 @@ int iwm_set_key(struct iwm_priv *iwm, bool remove, struct iwm_key *key)
 		ret =  iwm_send_wifi_if_cmd(iwm, &key_remove,
 					    sizeof(struct iwm_umac_key_remove),
 					    1);
-		if (ret < 0)
+		if (ret)
 			return ret;
 
 		iwm->keys[key_idx].key_len = 0;
@@ -736,7 +737,7 @@ int iwm_send_mlme_profile(struct iwm_priv *iwm)
 					   sizeof(struct iwm_umac_wifi_if));
 
 	ret = iwm_send_wifi_if_cmd(iwm, &profile, sizeof(profile), 1);
-	if (ret < 0) {
+	if (ret) {
 		IWM_ERR(iwm, "Send profile command failed\n");
 		return ret;
 	}
@@ -752,12 +753,12 @@ int iwm_send_mlme_profile(struct iwm_priv *iwm)
 							 3 * HZ);
 
 			ret = iwm_set_key(iwm, 0, key);
-			if (ret < 0)
+			if (ret)
 				return ret;
 
 			if (iwm->default_key == i) {
 				ret = iwm_set_tx_key(iwm, i);
-				if (ret < 0)
+				if (ret)
 					return ret;
 			}
 		}
@@ -778,15 +779,13 @@ int iwm_invalidate_mlme_profile(struct iwm_priv *iwm)
 	invalid.reason = WLAN_REASON_UNSPECIFIED;
 
 	ret = iwm_send_wifi_if_cmd(iwm, &invalid, sizeof(invalid), 1);
-	if (ret < 0)
+	if (ret)
 		return ret;
 
 	ret = wait_event_interruptible_timeout(iwm->mlme_queue,
 				(iwm->umac_profile_active == 0), 2 * HZ);
-	if (!ret)
-		return -EBUSY;
 
-	return 0;
+	return ret ? 0 : -EBUSY;
 }
 
 int iwm_send_umac_stats_req(struct iwm_priv *iwm, u32 flags)
@@ -869,7 +868,7 @@ int iwm_scan_ssids(struct iwm_priv *iwm, struct cfg80211_ssid *ssids,
 	}
 
 	ret = iwm_send_wifi_if_cmd(iwm, &req, sizeof(req), 0);
-	if (ret < 0) {
+	if (ret) {
 		IWM_ERR(iwm, "Couldn't send scan request\n");
 		return ret;
 	}
-- 
1.6.0.4

