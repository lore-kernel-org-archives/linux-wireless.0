Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2IGRZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:25:59 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: add key flag for management keys
Date: Fri,  7 Sep 2012 19:26:34 +0200
Message-Id: <1347038794-29039-1-git-send-email-johannes@sipsolutions.net> (sfid-20120907_192610_156310_D18221CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Mark keys that might be used to receive management
frames so drivers can fall back on software crypto
for them if they don't support hardware offload.
As the new flag is only set correctly for RX keys
and the existing IEEE80211_KEY_FLAG_SW_MGMT flag
can only affect TX, also rename the latter to
IEEE80211_KEY_FLAG_SW_MGMT_TX.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    2 +-
 drivers/net/wireless/ath/ath9k/main.c         |    2 +-
 include/net/mac80211.h                        |   12 ++++++++--
 net/mac80211/cfg.c                            |   32 +++++++++++++++++++++++++
 net/mac80211/tx.c                             |    2 +-
 6 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index c89fa6e..155c70e 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -524,7 +524,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
 			if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
-				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
+				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 			ret = 0;
 		}
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index c32f6e3..a6bb6e3 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1449,7 +1449,7 @@ static int ath9k_htc_set_key(struct ieee80211_hw *hw,
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
 			if (priv->ah->sw_mgmt_crypto &&
 			    key->cipher == WLAN_CIPHER_SUITE_CCMP)
-				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
+				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 			ret = 0;
 		}
 		break;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4d8dc9f..06c628e 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1441,7 +1441,7 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 				key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
 			if (sc->sc_ah->sw_mgmt_crypto &&
 			    key->cipher == WLAN_CIPHER_SUITE_CCMP)
-				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT;
+				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 			ret = 0;
 		}
 		break;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 71f8262..82558c8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -973,21 +973,29 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
  *	generation in software.
  * @IEEE80211_KEY_FLAG_PAIRWISE: Set by mac80211, this flag indicates
  *	that the key is pairwise rather then a shared key.
- * @IEEE80211_KEY_FLAG_SW_MGMT: This flag should be set by the driver for a
+ * @IEEE80211_KEY_FLAG_SW_MGMT_TX: This flag should be set by the driver for a
  *	CCMP key if it requires CCMP encryption of management frames (MFP) to
  *	be done in software.
  * @IEEE80211_KEY_FLAG_PUT_IV_SPACE: This flag should be set by the driver
  *	if space should be prepared for the IV, but the IV
  *	itself should not be generated. Do not set together with
  *	@IEEE80211_KEY_FLAG_GENERATE_IV on the same key.
+ * @IEEE80211_KEY_FLAG_RX_MGMT: This key will be used to decrypt received
+ *	management frames. The flag can help drivers that have a hardware
+ *	crypto implementation that doesn't deal with management frames
+ *	properly by allowing them to not upload the keys to hardware and
+ *	fall back to software crypto. Note that this flag deals only with
+ *	RX, if your crypto engine can't deal with TX you can also set the
+ *	%IEEE80211_KEY_FLAG_SW_MGMT_TX flag to encrypt such frames in SW.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
 	IEEE80211_KEY_FLAG_GENERATE_IV	= 1<<1,
 	IEEE80211_KEY_FLAG_GENERATE_MMIC= 1<<2,
 	IEEE80211_KEY_FLAG_PAIRWISE	= 1<<3,
-	IEEE80211_KEY_FLAG_SW_MGMT	= 1<<4,
+	IEEE80211_KEY_FLAG_SW_MGMT_TX	= 1<<4,
 	IEEE80211_KEY_FLAG_PUT_IV_SPACE = 1<<5,
+	IEEE80211_KEY_FLAG_RX_MGMT	= 1<<6,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 03fe6d1..b45f410 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -170,6 +170,38 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 		}
 	}
 
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		if (sdata->u.mgd.mfp != IEEE80211_MFP_DISABLED)
+			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
+		break;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+		/* Keys without a station are used for TX only */
+		if (key->sta && test_sta_flag(key->sta, WLAN_STA_MFP))
+			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		/* no MFP (yet) */
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+#ifdef CONFIG_MAC80211_MESH
+		if (sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
+			key->conf.flags |= IEEE80211_KEY_FLAG_RX_MGMT;
+		break;
+#endif
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_P2P_DEVICE:
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NUM_NL80211_IFTYPES:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		/* shouldn't happen */
+		WARN_ON(1);
+		break;
+	}
+
 	err = ieee80211_key_link(key, sdata, sta);
 	if (err)
 		ieee80211_key_free(sdata->local, key);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 29eb4e6..e0e0d1d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -580,7 +580,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 				tx->key = NULL;
 			else
 				skip_hw = (tx->key->conf.flags &
-					   IEEE80211_KEY_FLAG_SW_MGMT) &&
+					   IEEE80211_KEY_FLAG_SW_MGMT_TX) &&
 					ieee80211_is_mgmt(hdr->frame_control);
 			break;
 		case WLAN_CIPHER_SUITE_AES_CMAC:
-- 
1.7.10.4

