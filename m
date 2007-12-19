Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40764 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbXLSQKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:05 -0500
Subject: [PATCH 130/48] libertas: convert SET_WEP to a direct command
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50vE-00021k-Jg@pmac.infradead.org> (sfid-20071219_162100_279560_E23E2A2D)
Date: Wed, 19 Dec 2007 15:33:24 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 18 Dec 2007 00:18:05 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/assoc.c   |   26 ++++----------
 drivers/net/wireless/libertas/cmd.c     |   57 +++++++++++--------------------
 drivers/net/wireless/libertas/cmd.h     |    2 +
 drivers/net/wireless/libertas/cmdresp.c |    1 -
 drivers/net/wireless/libertas/hostcmd.h |    7 ++--
 5 files changed, 34 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index 882e51c..e91cd67 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -258,7 +258,7 @@ static int assoc_helper_channel(struct lbs_private *priv,
 
 
 static int assoc_helper_wep_keys(struct lbs_private *priv,
-                                 struct assoc_request * assoc_req)
+				 struct assoc_request *assoc_req)
 {
 	int i;
 	int ret = 0;
@@ -266,22 +266,11 @@ static int assoc_helper_wep_keys(struct lbs_private *priv,
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	/* Set or remove WEP keys */
-	if (   assoc_req->wep_keys[0].len
-	    || assoc_req->wep_keys[1].len
-	    || assoc_req->wep_keys[2].len
-	    || assoc_req->wep_keys[3].len) {
-		ret = lbs_prepare_and_send_command(priv,
-					    CMD_802_11_SET_WEP,
-					    CMD_ACT_ADD,
-					    CMD_OPTION_WAITFORRSP,
-					    0, assoc_req);
-	} else {
-		ret = lbs_prepare_and_send_command(priv,
-					    CMD_802_11_SET_WEP,
-					    CMD_ACT_REMOVE,
-					    CMD_OPTION_WAITFORRSP,
-					    0, NULL);
-	}
+	if (assoc_req->wep_keys[0].len || assoc_req->wep_keys[1].len ||
+	    assoc_req->wep_keys[2].len || assoc_req->wep_keys[3].len)
+		ret = lbs_cmd_802_11_set_wep(priv, CMD_ACT_ADD, assoc_req);
+	else
+		ret = lbs_cmd_802_11_set_wep(priv, CMD_ACT_REMOVE, assoc_req);
 
 	if (ret)
 		goto out;
@@ -291,6 +280,7 @@ static int assoc_helper_wep_keys(struct lbs_private *priv,
 		priv->currentpacketfilter |= CMD_ACT_MAC_WEP_ENABLE;
 	else
 		priv->currentpacketfilter &= ~CMD_ACT_MAC_WEP_ENABLE;
+
 	ret = lbs_set_mac_packet_filter(priv);
 	if (ret)
 		goto out;
@@ -300,7 +290,7 @@ static int assoc_helper_wep_keys(struct lbs_private *priv,
 	/* Copy WEP keys into priv wep key fields */
 	for (i = 0; i < 4; i++) {
 		memcpy(&priv->wep_keys[i], &assoc_req->wep_keys[i],
-			sizeof(struct enc_key));
+		       sizeof(struct enc_key));
 	}
 	priv->wep_tx_keyidx = assoc_req->wep_tx_keyidx;
 
diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 3d9ad0e..05e25ce 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -240,74 +240,61 @@ int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
 	return 0;
 }
 
-static int lbs_cmd_802_11_set_wep(struct lbs_private *priv,
-                                   struct cmd_ds_command *cmd,
-                                   u32 cmd_act,
-                                   void * pdata_buf)
+int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
+			   struct assoc_request *assoc)
 {
-	struct cmd_ds_802_11_set_wep *wep = &cmd->params.wep;
+	struct cmd_ds_802_11_set_wep cmd;
 	int ret = 0;
-	struct assoc_request * assoc_req = pdata_buf;
 
 	lbs_deb_enter(LBS_DEB_CMD);
 
-	cmd->command = cpu_to_le16(CMD_802_11_SET_WEP);
-	cmd->size = cpu_to_le16(sizeof(*wep) + S_DS_GEN);
-
-	if (cmd_act == CMD_ACT_ADD) {
-		int i;
+	cmd.hdr.command = cpu_to_le16(CMD_802_11_SET_WEP);
+	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 
-		if (!assoc_req) {
-			lbs_deb_cmd("Invalid association request!\n");
-			ret = -1;
-			goto done;
-		}
+	cmd.action = cpu_to_le16(cmd_action);
 
-		wep->action = cpu_to_le16(CMD_ACT_ADD);
+	if (cmd_action == CMD_ACT_ADD) {
+		int i;
 
 		/* default tx key index */
-		wep->keyindex = cpu_to_le16((u16)(assoc_req->wep_tx_keyidx &
-						  (u32)CMD_WEP_KEY_INDEX_MASK));
+		cmd.keyindex = cpu_to_le16(assoc->wep_tx_keyidx &
+					   CMD_WEP_KEY_INDEX_MASK);
 
 		/* Copy key types and material to host command structure */
 		for (i = 0; i < 4; i++) {
-			struct enc_key * pkey = &assoc_req->wep_keys[i];
+			struct enc_key *pkey = &assoc->wep_keys[i];
 
 			switch (pkey->len) {
 			case KEY_LEN_WEP_40:
-				wep->keytype[i] = CMD_TYPE_WEP_40_BIT;
-				memmove(&wep->keymaterial[i], pkey->key,
-				        pkey->len);
+				cmd.keytype[i] = CMD_TYPE_WEP_40_BIT;
+				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
 				lbs_deb_cmd("SET_WEP: add key %d (40 bit)\n", i);
 				break;
 			case KEY_LEN_WEP_104:
-				wep->keytype[i] = CMD_TYPE_WEP_104_BIT;
-				memmove(&wep->keymaterial[i], pkey->key,
-				        pkey->len);
+				cmd.keytype[i] = CMD_TYPE_WEP_104_BIT;
+				memmove(cmd.keymaterial[i], pkey->key, pkey->len);
 				lbs_deb_cmd("SET_WEP: add key %d (104 bit)\n", i);
 				break;
 			case 0:
 				break;
 			default:
 				lbs_deb_cmd("SET_WEP: invalid key %d, length %d\n",
-				       i, pkey->len);
+					    i, pkey->len);
 				ret = -1;
 				goto done;
 				break;
 			}
 		}
-	} else if (cmd_act == CMD_ACT_REMOVE) {
+	} else if (cmd_action == CMD_ACT_REMOVE) {
 		/* ACT_REMOVE clears _all_ WEP keys */
-		wep->action = cpu_to_le16(CMD_ACT_REMOVE);
 
 		/* default tx key index */
-		wep->keyindex = cpu_to_le16((u16)(priv->wep_tx_keyidx &
-						  (u32)CMD_WEP_KEY_INDEX_MASK));
+		cmd.keyindex = cpu_to_le16(priv->wep_tx_keyidx &
+					   CMD_WEP_KEY_INDEX_MASK);
 		lbs_deb_cmd("SET_WEP: remove key %d\n", priv->wep_tx_keyidx);
 	}
 
-	ret = 0;
-
+	ret = lbs_cmd_with_response(priv, CMD_802_11_SET_WEP, &cmd);
 done:
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;
@@ -1422,10 +1409,6 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
 		ret = lbs_cmd_80211_deauthenticate(priv, cmdptr);
 		break;
 
-	case CMD_802_11_SET_WEP:
-		ret = lbs_cmd_802_11_set_wep(priv, cmdptr, cmd_action, pdata_buf);
-		break;
-
 	case CMD_802_11_AD_HOC_START:
 		ret = lbs_cmd_80211_ad_hoc_start(priv, cmdptr, pdata_buf);
 		break;
diff --git a/drivers/net/wireless/libertas/cmd.h b/drivers/net/wireless/libertas/cmd.h
index ca09b18..d9947c3 100644
--- a/drivers/net/wireless/libertas/cmd.h
+++ b/drivers/net/wireless/libertas/cmd.h
@@ -51,5 +51,7 @@ int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
 				      uint16_t cmd_action, uint16_t *timeout);
 int lbs_cmd_802_11_sleep_params(struct lbs_private *priv, uint16_t cmd_action,
 				struct sleep_params *sp);
+int lbs_cmd_802_11_set_wep(struct lbs_private *priv, uint16_t cmd_action,
+			   struct assoc_request *assoc);
 
 #endif /* _LBS_CMD_H */
diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
index 40615a8..d670a81 100644
--- a/drivers/net/wireless/libertas/cmdresp.c
+++ b/drivers/net/wireless/libertas/cmdresp.c
@@ -490,7 +490,6 @@ static inline int handle_cmd_response(struct lbs_private *priv,
 
 	case CMD_RET(CMD_MAC_MULTICAST_ADR):
 	case CMD_RET(CMD_MAC_CONTROL):
-	case CMD_RET(CMD_802_11_SET_WEP):
 	case CMD_RET(CMD_802_11_RESET):
 	case CMD_RET(CMD_802_11_AUTHENTICATE):
 	case CMD_RET(CMD_802_11_BEACON_STOP):
diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
index 855c2d0..6d76634 100644
--- a/drivers/net/wireless/libertas/hostcmd.h
+++ b/drivers/net/wireless/libertas/hostcmd.h
@@ -256,6 +256,8 @@ struct cmd_ds_802_11_ad_hoc_result {
 };
 
 struct cmd_ds_802_11_set_wep {
+	struct cmd_header hdr;
+
 	/* ACT_ADD, ACT_REMOVE or ACT_ENABLE */
 	__le16 action;
 
@@ -263,8 +265,8 @@ struct cmd_ds_802_11_set_wep {
 	__le16 keyindex;
 
 	/* 40, 128bit or TXWEP */
-	u8 keytype[4];
-	u8 keymaterial[4][16];
+	uint8_t keytype[4];
+	uint8_t keymaterial[4][16];
 };
 
 struct cmd_ds_802_3_get_stat {
@@ -688,7 +690,6 @@ struct cmd_ds_command {
 		struct cmd_ds_mac_control macctrl;
 		struct cmd_ds_802_11_associate associate;
 		struct cmd_ds_802_11_deauthenticate deauth;
-		struct cmd_ds_802_11_set_wep wep;
 		struct cmd_ds_802_11_ad_hoc_start ads;
 		struct cmd_ds_802_11_reset reset;
 		struct cmd_ds_802_11_ad_hoc_result result;
-- 
1.5.3.4

