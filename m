Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2856 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971AbZJVNfB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:35:01 -0400
Message-Id: <20091022133410.709615858@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:30:50 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 07/19] libertas: get current channel out of priv->curbssparams
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... as priv->curbssparams won't exist once libertas+cfg80211 lands.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -376,7 +376,7 @@
 				   (u16)(pos - (u8 *) &cmd.iebuf));
 
 	/* update curbssparams */
-	priv->curbssparams.channel = bss->phy.ds.channel;
+	priv->channel = bss->phy.ds.channel;
 
 	ret = lbs_cmd_with_response(priv, command, &cmd);
 	if (ret == 0) {
@@ -489,7 +489,7 @@
 	lbs_deb_join("ADHOC_RESP: Joined/started '%s', BSSID %pM, channel %d\n",
 		     print_ssid(ssid, bss->ssid, bss->ssid_len),
 		     priv->curbssparams.bssid,
-		     priv->curbssparams.channel);
+		     priv->channel);
 
 done:
 	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
@@ -562,7 +562,7 @@
 	lbs_deb_join("AdhocJoin: band = %c\n", assoc_req->band);
 
 	priv->adhoccreate = 0;
-	priv->curbssparams.channel = bss->channel;
+	priv->channel = bss->channel;
 
 	/* Build the join command */
 	memset(&cmd, 0, sizeof(cmd));
@@ -1196,7 +1196,7 @@
 		goto done;
 	}
 
-	if (assoc_req->channel == priv->curbssparams.channel)
+	if (assoc_req->channel == priv->channel)
 		goto done;
 
 	if (priv->mesh_dev) {
@@ -1208,7 +1208,7 @@
 	}
 
 	lbs_deb_assoc("ASSOC: channel: %d -> %d\n",
-		      priv->curbssparams.channel, assoc_req->channel);
+		      priv->channel, assoc_req->channel);
 
 	ret = lbs_set_channel(priv, assoc_req->channel);
 	if (ret < 0)
@@ -1223,7 +1223,7 @@
 		goto done;
 	}
 
-	if (assoc_req->channel != priv->curbssparams.channel) {
+	if (assoc_req->channel != priv->channel) {
 		lbs_deb_assoc("ASSOC: channel: failed to update channel to %d\n",
 		              assoc_req->channel);
 		goto restore_mesh;
@@ -1244,7 +1244,7 @@
  restore_mesh:
 	if (priv->mesh_dev)
 		lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				priv->curbssparams.channel);
+				priv->channel);
 
  done:
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
@@ -1466,7 +1466,7 @@
 	}
 
 	if (test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags)) {
-		if (assoc_req->channel != priv->curbssparams.channel)
+		if (assoc_req->channel != priv->channel)
 			return 1;
 	}
 
@@ -1771,7 +1771,7 @@
 	}
 
 	if (!test_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags))
-		assoc_req->channel = priv->curbssparams.channel;
+		assoc_req->channel = priv->channel;
 
 	if (!test_bit(ASSOC_FLAG_BAND, &assoc_req->flags))
 		assoc_req->band = priv->curbssparams.band;
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.h
+++ linux-wl/drivers/net/wireless/libertas/assoc.h
@@ -36,8 +36,7 @@
 
 	/** band */
 	u8 band;
-	/** channel */
-	u8 channel;
+	/** channel is directly in priv->channel */
 	/** zero-terminated array of supported data rates */
 	u8 rates[MAX_RATES + 1];
 };
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -881,7 +881,7 @@
 
 	ret = lbs_get_channel(priv);
 	if (ret > 0) {
-		priv->curbssparams.channel = ret;
+		priv->channel = ret;
 		ret = 0;
 	}
 	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
@@ -900,7 +900,7 @@
 {
 	struct cmd_ds_802_11_rf_channel cmd;
 #ifdef DEBUG
-	u8 old_channel = priv->curbssparams.channel;
+	u8 old_channel = priv->channel;
 #endif
 	int ret = 0;
 
@@ -915,9 +915,9 @@
 	if (ret)
 		goto out;
 
-	priv->curbssparams.channel = (uint8_t) le16_to_cpu(cmd.channel);
+	priv->channel = (uint8_t) le16_to_cpu(cmd.channel);
 	lbs_deb_cmd("channel switch from %d to %d\n", old_channel,
-		priv->curbssparams.channel);
+		priv->channel);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -165,6 +165,7 @@
 	/* NIC/link operation characteristics */
 	u16 mac_control;
 	u8 radio_on;
+	u8 channel;
 	s16 txpower_cur;
 	s16 txpower_min;
 	s16 txpower_max;
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -285,7 +285,7 @@
 		return count;
 	if (enable)
 		action = CMD_ACT_MESH_CONFIG_START;
-	ret = lbs_mesh_config(priv, action, priv->curbssparams.channel);
+	ret = lbs_mesh_config(priv, action, priv->channel);
 	if (ret)
 		return ret;
 
@@ -1046,7 +1046,7 @@
 	priv->mesh_connect_status = LBS_DISCONNECTED;
 	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 	priv->mode = IW_MODE_INFRA;
-	priv->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
+	priv->channel = DEFAULT_AD_HOC_CHANNEL;
 	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 	priv->radio_on = 1;
 	priv->enablehwauto = 1;
@@ -1314,10 +1314,10 @@
 
 		priv->mesh_tlv = TLV_TYPE_OLD_MESH_ID;
 		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->curbssparams.channel)) {
+				    priv->channel)) {
 			priv->mesh_tlv = TLV_TYPE_MESH_ID;
 			if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-					    priv->curbssparams.channel))
+					    priv->channel))
 				priv->mesh_tlv = 0;
 		}
 	} else if (priv->mesh_fw_ver == MESH_FW_NEW) {
@@ -1326,7 +1326,7 @@
 		 */
 		priv->mesh_tlv = TLV_TYPE_MESH_ID;
 		if (lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-				    priv->curbssparams.channel))
+				    priv->channel))
 			priv->mesh_tlv = 0;
 	}
 	if (priv->mesh_tlv) {
--- linux-wl.orig/drivers/net/wireless/libertas/wext.c
+++ linux-wl/drivers/net/wireless/libertas/wext.c
@@ -164,12 +164,12 @@
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	cfp = lbs_find_cfp_by_band_and_channel(priv, 0,
-					   priv->curbssparams.channel);
+					   priv->channel);
 
 	if (!cfp) {
-		if (priv->curbssparams.channel)
+		if (priv->channel)
 			lbs_deb_wext("invalid channel %d\n",
-			       priv->curbssparams.channel);
+			       priv->channel);
 		return -EINVAL;
 	}
 
@@ -986,7 +986,7 @@
 		goto out;
 	}
 
-	if (fwrq->m != priv->curbssparams.channel) {
+	if (fwrq->m != priv->channel) {
 		lbs_deb_wext("mesh channel change forces eth disconnect\n");
 		if (priv->mode == IW_MODE_INFRA)
 			lbs_cmd_80211_deauthenticate(priv,
@@ -2100,7 +2100,7 @@
 	}
 
 	lbs_mesh_config(priv, CMD_ACT_MESH_CONFIG_START,
-			priv->curbssparams.channel);
+			priv->channel);
  out:
 	lbs_deb_leave_args(LBS_DEB_WEXT, "ret %d", ret);
 	return ret;

-- 
