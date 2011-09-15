Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46943 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IOMKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 08:10:21 -0400
Date: Thu, 15 Sep 2011 15:10:16 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl: Fix static WEP configuration in AP mode
Message-ID: <20110915121016.GA9230@jouni.qca.qualcomm.com> (sfid-20110915_141025_306396_6E8C169B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configuration of the WEP keys needs to be delayed until the AP mode has
been properly started at the target. Partial support for delaying the
WEP key configuration was already in place in the driver, but the actual
part of deciding when to do this was missing.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   16 +++++++++++++++-
 drivers/net/wireless/ath/ath6kl/main.c     |    4 +++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index a889bf4..249d336 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -952,6 +952,20 @@ static int ath6kl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 		}
 	}
 
+	if (ar->next_mode == AP_NETWORK && key_type == WEP_CRYPT &&
+	    !test_bit(CONNECTED, &ar->flag)) {
+		/*
+		 * Store the key locally so that it can be re-configured after
+		 * the AP mode has properly started
+		 * (ath6kl_install_statioc_wep_keys).
+		 */
+		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "Delay WEP key configuration "
+			   "until AP mode has been started\n");
+		ar->wep_key_list[key_index].key_len = key->key_len;
+		memcpy(ar->wep_key_list[key_index].key, key->key, key->key_len);
+		return 0;
+	}
+
 	status = ath6kl_wmi_addkey_cmd(ar->wmi, ar->def_txkey_index,
 				       key_type, key_usage, key->key_len,
 				       key->seq, key->key, KEY_OP_INIT_VAL,
@@ -1066,7 +1080,7 @@ static int ath6kl_cfg80211_set_default_key(struct wiphy *wiphy,
 	if (multicast)
 		key_type = ar->grp_crypto;
 
-	if (ar->nw_type == AP_NETWORK && !test_bit(CONNECTED, &ar->flag))
+	if (ar->next_mode == AP_NETWORK && !test_bit(CONNECTED, &ar->flag))
 		return 0; /* Delay until AP mode has been started */
 
 	status = ath6kl_wmi_addkey_cmd(ar->wmi, ar->def_txkey_index,
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d510046..acbd35d 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1364,8 +1364,10 @@ void ath6kl_disconnect_event(struct ath6kl *ar, u8 reason, u8 *bssid,
 			cfg80211_del_sta(ar->net_dev, bssid, GFP_KERNEL);
 		}
 
-		if (memcmp(ar->net_dev->dev_addr, bssid, ETH_ALEN) == 0)
+		if (memcmp(ar->net_dev->dev_addr, bssid, ETH_ALEN) == 0) {
+			memset(ar->wep_key_list, 0, sizeof(ar->wep_key_list));
 			clear_bit(CONNECTED, &ar->flag);
+		}
 		return;
 	}
 
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
