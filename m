Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10087 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbXK1NEN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 08:04:13 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: tweak association debug output
Date: Wed, 28 Nov 2007 14:05:02 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711281405.03005.hs4233@mail.mn-solutions.de> (sfid-20071128_130416_799981_6D468958)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change debug output codes from LBS_DEB_JOIN to LBS_DEB_ASSOC

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de

---
The lines I removed (e.g. BSSID) were emitted several times

While passing, make lines touched by the patch checkpatch.pl clean

Index: wireless-2.6/drivers/net/wireless/libertas/join.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/join.c	2007-11-28 09:35:57.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/join.c	2007-11-28 09:41:59.000000000 +0100
@@ -57,7 +57,7 @@ static int get_common_rates(struct lbs_a
 	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
 	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates, num_card_rates);
 	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
-	lbs_deb_join("Tx datarate is currently 0x%X\n", adapter->cur_rate);
+	lbs_deb_join("TX data rate 0x%02x\n", adapter->cur_rate);
 
 	if (!adapter->auto_rate) {
 		for (i = 0; i < tmp_size; i++) {
@@ -128,7 +128,7 @@ int lbs_associate(struct lbs_private *pr
 	struct lbs_adapter *adapter = priv->adapter;
 	int ret;
 
-	lbs_deb_enter(LBS_DEB_JOIN);
+	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	ret = lbs_prepare_and_send_command(priv, CMD_802_11_AUTHENTICATE,
 				    0, CMD_OPTION_WAITFORRSP,
@@ -150,7 +150,7 @@ int lbs_associate(struct lbs_private *pr
 				    0, CMD_OPTION_WAITFORRSP, 0, assoc_req);
 
 done:
-	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
 
@@ -324,7 +324,7 @@ int lbs_cmd_80211_authenticate(struct lb
 
 	memcpy(pauthenticate->macaddr, bssid, ETH_ALEN);
 
-	lbs_deb_join("AUTH_CMD: BSSID is : %s auth=0x%X\n",
+	lbs_deb_join("AUTH_CMD: BSSID %s, auth 0x%x\n",
 	             print_mac(mac, bssid), pauthenticate->authtype);
 	ret = 0;
 
@@ -372,7 +372,7 @@ int lbs_cmd_80211_associate(struct lbs_p
 	struct mrvlietypes_ratesparamset *rates;
 	struct mrvlietypes_rsnparamset *rsn;
 
-	lbs_deb_enter(LBS_DEB_JOIN);
+	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	pos = (u8 *) passo;
 
@@ -426,7 +426,7 @@ int lbs_cmd_80211_associate(struct lbs_p
 	}
 	pos += sizeof(rates->header) + tmplen;
 	rates->header.len = cpu_to_le16(tmplen);
-	lbs_deb_join("ASSOC_CMD: num rates = %u\n", tmplen);
+	lbs_deb_assoc("ASSOC_CMD: num rates %u\n", tmplen);
 
 	/* Copy the infra. association rates into Current BSS state structure */
 	memset(&adapter->curbssparams.rates, 0, sizeof(adapter->curbssparams.rates));
@@ -464,11 +464,10 @@ int lbs_cmd_80211_associate(struct lbs_p
 	if (bss->mode == IW_MODE_INFRA)
 		tmpcap |= WLAN_CAPABILITY_ESS;
 	passo->capability = cpu_to_le16(tmpcap);
-	lbs_deb_join("ASSOC_CMD: capability=%4X CAPINFO_MASK=%4X\n",
-		     tmpcap, CAPINFO_MASK);
+	lbs_deb_assoc("ASSOC_CMD: capability 0x%04x\n", tmpcap);
 
 done:
-	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
 
@@ -706,10 +705,10 @@ int lbs_ret_80211_associate(struct lbs_p
 	struct bss_descriptor * bss;
 	u16 status_code;
 
-	lbs_deb_enter(LBS_DEB_JOIN);
+	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	if (!adapter->in_progress_assoc_req) {
-		lbs_deb_join("ASSOC_RESP: no in-progress association request\n");
+		lbs_deb_assoc("ASSOC_RESP: no in-progress assoc request\n");
 		ret = -1;
 		goto done;
 	}
@@ -738,30 +737,25 @@ int lbs_ret_80211_associate(struct lbs_p
 	status_code = le16_to_cpu(passocrsp->statuscode);
 	switch (status_code) {
 	case 0x00:
-		lbs_deb_join("ASSOC_RESP: Association succeeded\n");
 		break;
 	case 0x01:
-		lbs_deb_join("ASSOC_RESP: Association failed; invalid "
-		             "parameters (status code %d)\n", status_code);
+		lbs_deb_assoc("ASSOC_RESP: invalid parameters\n");
 		break;
 	case 0x02:
-		lbs_deb_join("ASSOC_RESP: Association failed; internal timer "
-		             "expired while waiting for the AP (status code %d)"
-		             "\n", status_code);
+		lbs_deb_assoc("ASSOC_RESP: internal timer "
+			"expired while waiting for the AP\n");
 		break;
 	case 0x03:
-		lbs_deb_join("ASSOC_RESP: Association failed; association "
-		             "was refused by the AP (status code %d)\n",
-		             status_code);
+		lbs_deb_assoc("ASSOC_RESP: association "
+			"refused by AP\n");
 		break;
 	case 0x04:
-		lbs_deb_join("ASSOC_RESP: Association failed; authentication "
-		             "was refused by the AP (status code %d)\n",
-		             status_code);
+		lbs_deb_assoc("ASSOC_RESP: authentication "
+			"refused by AP\n");
 		break;
 	default:
-		lbs_deb_join("ASSOC_RESP: Association failed; reason unknown "
-		             "(status code %d)\n", status_code);
+		lbs_deb_assoc("ASSOC_RESP: failure reason 0x%02x "
+			" unknown\n", status_code);
 		break;
 	}
 
@@ -771,22 +765,19 @@ int lbs_ret_80211_associate(struct lbs_p
 		goto done;
 	}
 
-	lbs_deb_hex(LBS_DEB_JOIN, "ASSOC_RESP", (void *)&resp->params,
+	lbs_deb_hex(LBS_DEB_ASSOC, "ASSOC_RESP", (void *)&resp->params,
 		le16_to_cpu(resp->size) - S_DS_GEN);
 
 	/* Send a Media Connected event, according to the Spec */
 	adapter->connect_status = LBS_CONNECTED;
 
-	lbs_deb_join("ASSOC_RESP: assocated to '%s'\n",
-	             escape_essid(bss->ssid, bss->ssid_len));
-
 	/* Update current SSID and BSSID */
 	memcpy(&adapter->curbssparams.ssid, &bss->ssid, IW_ESSID_MAX_SIZE);
 	adapter->curbssparams.ssid_len = bss->ssid_len;
 	memcpy(adapter->curbssparams.bssid, bss->bssid, ETH_ALEN);
 
-	lbs_deb_join("ASSOC_RESP: currentpacketfilter is %x\n",
-	       adapter->currentpacketfilter);
+	lbs_deb_assoc("ASSOC_RESP: currentpacketfilter is 0x%x\n",
+		adapter->currentpacketfilter);
 
 	adapter->SNR[TYPE_RXPD][TYPE_AVG] = 0;
 	adapter->NF[TYPE_RXPD][TYPE_AVG] = 0;
@@ -809,7 +800,7 @@ int lbs_ret_80211_associate(struct lbs_p
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 
 done:
-	lbs_deb_leave_args(LBS_DEB_JOIN, "ret %d", ret);
+	lbs_deb_leave_args(LBS_DEB_ASSOC, "ret %d", ret);
 	return ret;
 }
 
Index: wireless-2.6/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.c	2007-11-28 09:35:57.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/assoc.c	2007-11-28 09:42:07.000000000 +0100
@@ -638,20 +638,19 @@ void lbs_association_worker(struct work_
 
 		ret = assoc_helper_associate(priv, assoc_req);
 		if (ret) {
-			lbs_deb_assoc("ASSOC: association attempt unsuccessful: %d\n",
+			lbs_deb_assoc("ASSOC: association unsuccessful: %d\n",
 				ret);
 			success = 0;
 		}
 
 		if (adapter->connect_status != LBS_CONNECTED) {
-			lbs_deb_assoc("ASSOC: association attempt unsuccessful, "
-				"not connected.\n");
+			lbs_deb_assoc("ASSOC: association unsuccessful, "
+				"not connected\n");
 			success = 0;
 		}
 
 		if (success) {
-			lbs_deb_assoc("ASSOC: association attempt successful. "
-				"Associated to '%s' (%s)\n",
+			lbs_deb_assoc("ASSOC: associated to '%s', %s\n",
 				escape_essid(adapter->curbssparams.ssid,
 				             adapter->curbssparams.ssid_len),
 				print_mac(mac, adapter->curbssparams.bssid));
Index: wireless-2.6/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	2007-11-28 09:35:45.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/cmdresp.c	2007-11-28 09:42:07.000000000 +0100
@@ -31,7 +31,7 @@ void lbs_mac_event_disconnected(struct l
 	if (adapter->connect_status != LBS_CONNECTED)
 		return;
 
-	lbs_deb_enter(LBS_DEB_CMD);
+	lbs_deb_enter(LBS_DEB_ASSOC);
 
 	memset(wrqu.ap_addr.sa_data, 0x00, ETH_ALEN);
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
@@ -60,11 +60,6 @@ void lbs_mac_event_disconnected(struct l
 	memset(adapter->rawNF, 0x00, sizeof(adapter->rawNF));
 	adapter->nextSNRNF = 0;
 	adapter->numSNRNF = 0;
-	lbs_deb_cmd("current SSID '%s', length %u\n",
-	            escape_essid(adapter->curbssparams.ssid,
-	                         adapter->curbssparams.ssid_len),
-	            adapter->curbssparams.ssid_len);
-
 	adapter->connect_status = LBS_DISCONNECTED;
 
 	/* Clear out associated SSID and BSSID since connection is
