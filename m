Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:33103 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358Ab1ALANa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 19:13:30 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: remove some crypto definitions
Date: Tue, 11 Jan 2011 16:14:25 -0800
Message-Id: <1294791265-24020-2-git-send-email-bzhao@marvell.com>
In-Reply-To: <1294791265-24020-1-git-send-email-bzhao@marvell.com>
References: <1294791265-24020-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Use corresponding macros defined in include/linux/ieee80211.h

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c           |    6 +++---
 drivers/net/wireless/mwifiex/11n_rxreorder.c |   16 ++++++++--------
 drivers/net/wireless/mwifiex/11n_rxreorder.h |    7 -------
 drivers/net/wireless/mwifiex/fw.h            |    5 +----
 drivers/net/wireless/mwifiex/ioctl.h         |    6 ++----
 drivers/net/wireless/mwifiex/main.h          |   14 --------------
 drivers/net/wireless/mwifiex/sta_cmd.c       |   19 ++++++-------------
 drivers/net/wireless/mwifiex/sta_ioctl.c     |    2 +-
 8 files changed, 21 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index e4a0314..b1fd5a9 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -624,7 +624,7 @@ mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 			& SSN_MASK);
 
 	tid = (le16_to_cpu(add_ba_rsp->block_ack_param_set)
-		& BLOCKACKPARAM_TID_MASK)
+		& IEEE80211_ADDBA_PARAM_TID_MASK)
 		>> BLOCKACKPARAM_TID_POS;
 	if (le16_to_cpu(add_ba_rsp->status_code) == BA_RESULT_SUCCESS) {
 		tx_ba_tbl = mwifiex_11n_get_tx_ba_stream_tbl(priv,
@@ -1329,9 +1329,9 @@ mwifiex_send_delba(struct mwifiex_private *priv, int tid, u8 *peer_mac,
 
 	del_ba_param_set = le16_to_cpu(delba.del_ba_param_set);
 	if (initiator)
-		DELBA_INITIATOR(del_ba_param_set);
+		del_ba_param_set |= IEEE80211_DELBA_PARAM_INITIATOR_MASK;
 	else
-		DELBA_RECIPIENT(del_ba_param_set);
+		del_ba_param_set &= ~IEEE80211_DELBA_PARAM_INITIATOR_MASK;
 
 	memcpy(&delba.peer_mac_addr, peer_mac, MWIFIEX_MAC_ADDR_LENGTH);
 
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.c b/drivers/net/wireless/mwifiex/11n_rxreorder.c
index dcfcb99..e783a2e 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.c
@@ -415,21 +415,21 @@ mwifiex_cmd_11n_addba_rsp_gen(struct mwifiex_private *priv,
 	add_ba_rsp->ssn = cmd_addba_req->ssn;
 
 	block_ack_param_set = le16_to_cpu(cmd_addba_req->block_ack_param_set);
-	tid = (block_ack_param_set & BLOCKACKPARAM_TID_MASK)
+	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
 		>> BLOCKACKPARAM_TID_POS;
 	if (priv->addba_reject[tid])
 		add_ba_rsp->status_code =
-			cpu_to_le16(ADDBA_RSP_STATUS_DECLINED);
+			cpu_to_le16(WLAN_STATUS_REQUEST_DECLINED);
 	else
 		add_ba_rsp->status_code = cpu_to_le16(ADDBA_RSP_STATUS_ACCEPT);
-	block_ack_param_set &= ~BLOCKACKPARAM_WINSIZE_MASK;
+	block_ack_param_set &= ~IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK;
 	/* We donot support AMSDU inside AMPDU, hence reset the bit */
 	block_ack_param_set &= ~BLOCKACKPARAM_AMSDU_SUPP_MASK;
 	block_ack_param_set |= (priv->add_ba_param.rx_win_size <<
 					     BLOCKACKPARAM_WINSIZE_POS);
 	add_ba_rsp->block_ack_param_set = cpu_to_le16(block_ack_param_set);
 	win_size = (le16_to_cpu(add_ba_rsp->block_ack_param_set)
-					& BLOCKACKPARAM_WINSIZE_MASK)
+					& IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
 					>> BLOCKACKPARAM_WINSIZE_POS;
 	cmd_addba_req->block_ack_param_set = cpu_to_le16(block_ack_param_set);
 
@@ -668,15 +668,15 @@ mwifiex_ret_11n_addba_resp(struct mwifiex_private *priv,
 
 	block_ack_param_set = le16_to_cpu(add_ba_rsp->block_ack_param_set);
 
-	tid = (block_ack_param_set & BLOCKACKPARAM_TID_MASK)
+	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
 		>> BLOCKACKPARAM_TID_POS;
 	/*
 	 * Check if we had rejected the ADDBA, if yes then do not create
 	 * the stream
 	 */
 	if (le16_to_cpu(add_ba_rsp->status_code) == BA_RESULT_SUCCESS) {
-		win_size =
-			(block_ack_param_set & BLOCKACKPARAM_WINSIZE_MASK)
+		win_size = (block_ack_param_set &
+			IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK)
 			>> BLOCKACKPARAM_WINSIZE_POS;
 
 		PRINTM(MCMND,
@@ -733,7 +733,7 @@ mwifiex_11n_ba_stream_timeout(struct mwifiex_private *priv,
 		cpu_to_le16((u16) event->tid << DELBA_TID_POS);
 	delba.del_ba_param_set |= cpu_to_le16(
 		(u16) event->origninator << DELBA_INITIATOR_POS);
-	delba.reason_code = cpu_to_le16(REASON_CODE_STA_TIMEOUT);
+	delba.reason_code = cpu_to_le16(WLAN_REASON_QSTA_TIMEOUT);
 	mwifiex_prepare_cmd(priv, HostCmd_CMD_11N_DELBA, 0, 0, NULL, &delba);
 
 	LEAVE();
diff --git a/drivers/net/wireless/mwifiex/11n_rxreorder.h b/drivers/net/wireless/mwifiex/11n_rxreorder.h
index e9b82cd..fb5c695 100644
--- a/drivers/net/wireless/mwifiex/11n_rxreorder.h
+++ b/drivers/net/wireless/mwifiex/11n_rxreorder.h
@@ -26,22 +26,15 @@
 #define MAX_TID_VALUE			(2 << 11)
 #define TWOPOW11			(2 << 10)
 
-#define BLOCKACKPARAM_TID_MASK		0x3C
 #define BLOCKACKPARAM_TID_POS		2
-#define BLOCKACKPARAM_WINSIZE_MASK	0xffc0
 #define BLOCKACKPARAM_AMSDU_SUPP_MASK	0x1
 #define BLOCKACKPARAM_WINSIZE_POS	6
 #define DELBA_TID_POS			12
 #define DELBA_INITIATOR_POS		11
-#define REASON_CODE_STA_DONT_WANT	37
-#define REASON_CODE_STA_TIMEOUT		39
 #define TYPE_DELBA_SENT			1
 #define TYPE_DELBA_RECEIVE		2
-#define DELBA_INITIATOR(paramset)	(paramset = (paramset | (1 << 11)))
-#define DELBA_RECIPIENT(paramset)	(paramset = (paramset & ~(1 << 11)))
 #define IMMEDIATE_BLOCK_ACK		0x2
 
-#define ADDBA_RSP_STATUS_DECLINED  37
 #define ADDBA_RSP_STATUS_REJECT 1
 #define ADDBA_RSP_STATUS_ACCEPT 0
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index d2c39c7..32652a2 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -93,9 +93,6 @@ enum KEY_INFO_AES {
 	KEY_INFO_AES_ENABLED = 0x04
 };
 
-#define WPA_AES_KEY_LEN                 16
-#define WPA_TKIP_KEY_LEN                32
-
 #define WAPI_KEY_LEN			50
 
 enum KEY_INFO_WAPI {
@@ -468,7 +465,7 @@ struct mwifiex_event_wep_icv_err {
 	u8 src_mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
 	u8 wep_key_index;
 	u8 wep_key_length;
-	u8 key[MAX_WEP_KEY_SIZE];
+	u8 key[WLAN_KEY_LEN_WEP104];
 };
 
 struct mwifiex_802_11_fixed_ies {
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 5ed613d..f71a09c 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -448,9 +448,7 @@ enum {
 
 #define MWIFIEX_KEY_INDEX_UNICAST	0x40000000
 #define MWIFIEX_MAX_KEY_LENGTH		32
-#define PN_SIZE				16
-#define MAX_WEP_KEY_SIZE		13
-#define MIN_WEP_KEY_SIZE		5
+#define WAPI_RXPN_LEN			16
 #define MWIFIEX_MIN_PASSPHRASE_LENGTH	8
 #define MWIFIEX_MAX_PASSPHRASE_LENGTH	63
 #define MWIFIEX_MAX_PMK_LENGTH		32
@@ -463,7 +461,7 @@ struct mwifiex_ds_encrypt_key {
 	u8 key_material[MWIFIEX_MAX_KEY_LENGTH];
 	u8 mac_addr[MWIFIEX_MAC_ADDR_LENGTH];
 	u32 is_wapi_key;
-	u8 pn[PN_SIZE];
+	u8 wapi_rxpn[WAPI_RXPN_LEN];
 };
 
 struct mwifiex_passphrase {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5b1d557..eb17ced 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -137,20 +137,6 @@ struct mwifiex_drv_mode {
 
 #define MWIFIEX_MIN_SSID_LENGTH					1
 
-#define MWIFIEX_KEY_INDEX_UNICAST        0x40000000
-
-#define MWIFIEX_MAX_KEY_LENGTH           32
-
-#define MWIFIEX_MIN_PASSPHRASE_LENGTH    8
-
-#define MWIFIEX_MAX_PASSPHRASE_LENGTH    63
-
-#define MWIFIEX_MAX_PMK_LENGTH           32
-
-#define MAX_WEP_KEY_SIZE        13
-
-#define MIN_WEP_KEY_SIZE        5
-
 #define MAX_CHANNEL_BAND_BG     14
 
 #define MAX_FREQUENCY_BAND_BG   2484
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 9a87a2a..4d9abb9 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -539,9 +539,7 @@ mwifiex_cmd_802_11_deauthenticate(struct mwifiex_private *priv,
 	       deauth->mac_addr[3], deauth->mac_addr[4],
 	       deauth->mac_addr[5]);
 
-/** Reason code 3 = Station is leaving */
-#define REASON_CODE_STA_LEAVING 3
-	deauth->reason_code = cpu_to_le16(REASON_CODE_STA_LEAVING);
+	deauth->reason_code = cpu_to_le16(WLAN_REASON_DEAUTH_LEAVING);
 
 	LEAVE();
 	return MWIFIEX_STATUS_SUCCESS;
@@ -567,11 +565,6 @@ mwifiex_cmd_802_11_ad_hoc_stop(struct mwifiex_private *priv,
 	return MWIFIEX_STATUS_SUCCESS;
 }
 
-/** Length of WEP 40 bit key */
-#define WEP_40_BIT_LEN  5
-/** Length of WEP 104 bit key */
-#define WEP_104_BIT_LEN 13
-
 /*
  * This function sets WEP key(s) to key parameter TLV(s).
  *
@@ -591,8 +584,8 @@ mwifiex_set_keyparamset_wep(struct mwifiex_private *priv,
 
 	/* Multi-key_param_set TLV is supported */
 	for (i = 0; i < NUM_WEP_KEYS; i++) {
-		if ((priv->wep_key[i].key_length == WEP_40_BIT_LEN) ||
-		    (priv->wep_key[i].key_length == WEP_104_BIT_LEN)) {
+		if ((priv->wep_key[i].key_length == WLAN_KEY_LEN_WEP40) ||
+		    (priv->wep_key[i].key_length == WLAN_KEY_LEN_WEP104)) {
 			key_param_set->type =
 				cpu_to_le16(TLV_TYPE_KEY_MATERIAL);
 /** Key_param_set WEP fixed length */
@@ -735,7 +728,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		       enc_key->key_material,
 		       enc_key->key_len);
 		memcpy(&key_material->key_param_set.key[2 + enc_key->key_len],
-		       enc_key->pn, PN_SIZE);
+		       enc_key->wapi_rxpn, WAPI_RXPN_LEN);
 		key_material->key_param_set.length =
 			cpu_to_le16(WAPI_KEY_LEN + KEYPARAMSET_FIXED_LEN);
 
@@ -747,7 +740,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 				    sizeof(key_material->action) + S_DS_GEN);
 		goto done;
 	}
-	if (enc_key->key_len == WPA_AES_KEY_LEN) {
+	if (enc_key->key_len == WLAN_KEY_LEN_CCMP) {
 		PRINTM(MCMND, "WPA_AES\n");
 		key_material->key_param_set.key_type_id =
 			cpu_to_le16(KEY_TYPE_ID_AES);
@@ -765,7 +758,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
 		else		/* AES group key: multicast */
 			key_material->key_param_set.key_info |=
 				cpu_to_le16(KEY_INFO_AES_MCAST);
-	} else if (enc_key->key_len == WPA_TKIP_KEY_LEN) {
+	} else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
 		PRINTM(MCMND, "WPA_TKIP\n");
 		key_material->key_param_set.key_type_id =
 			cpu_to_le16(KEY_TYPE_ID_TKIP);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 35df4c9..04a6154 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -3611,7 +3611,7 @@ mwifiex_sec_ioctl_encrypt_key(struct mwifiex_adapter *adapter,
 		if (sec->param.encrypt_key.is_wapi_key)
 			status = mwifiex_sec_ioctl_set_wapi_key(adapter,
 								ioctl_req);
-		else if (sec->param.encrypt_key.key_len > MAX_WEP_KEY_SIZE)
+		else if (sec->param.encrypt_key.key_len > WLAN_KEY_LEN_WEP104)
 			status = mwifiex_sec_ioctl_set_wpa_key(adapter,
 							       ioctl_req);
 		else
-- 
1.7.0.2

