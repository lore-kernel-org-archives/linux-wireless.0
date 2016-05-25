Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60763 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbcEYPiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2016 11:38:10 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u4PFaUVe021074
	for <linux-wireless@vger.kernel.org>; Wed, 25 May 2016 08:38:09 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 232q6eht6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 25 May 2016 08:38:09 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: inform disconnection initiator correctly.
Date: Wed, 25 May 2016 08:37:35 -0700
Message-ID: <1464190655-21667-1-git-send-email-akarwar@marvell.com> (sfid-20160525_173814_343832_FEF8B00E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ensures that 'locally_generated' parameter is correctly
passed to cfg80211_disconnected() API.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/join.c        |  2 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |  3 ++-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  5 +++--
 drivers/net/wireless/marvell/mwifiex/sta_event.c   | 12 ++++++------
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index 62211fc..a4b773d 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -1281,7 +1281,7 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	if (result) {
 		mwifiex_dbg(priv->adapter, ERROR, "ADHOC_RESP: failed\n");
 		if (priv->media_connected)
-			mwifiex_reset_connect_state(priv, result);
+			mwifiex_reset_connect_state(priv, result, true);
 
 		memset(&priv->curr_bss_params.bss_descriptor,
 		       0x00, sizeof(struct mwifiex_bssdescriptor));
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 0207af0..f0cd055 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1128,7 +1128,8 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 				 struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 				 struct host_cmd_ds_command *resp);
-void mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason);
+void mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason,
+				 bool from_ap);
 u8 mwifiex_band_to_radio_type(u8 band);
 int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac);
 void mwifiex_deauthenticate_all(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index d18c797..bcfd4b7 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -553,7 +553,8 @@ static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
 	if (!memcmp(resp->params.deauth.mac_addr,
 		    &priv->curr_bss_params.bss_descriptor.mac_address,
 		    sizeof(resp->params.deauth.mac_addr)))
-		mwifiex_reset_connect_state(priv, WLAN_REASON_DEAUTH_LEAVING);
+		mwifiex_reset_connect_state(priv, WLAN_REASON_DEAUTH_LEAVING,
+					    false);
 
 	return 0;
 }
@@ -566,7 +567,7 @@ static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
 static int mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
 					  struct host_cmd_ds_command *resp)
 {
-	mwifiex_reset_connect_state(priv, WLAN_REASON_DEAUTH_LEAVING);
+	mwifiex_reset_connect_state(priv, WLAN_REASON_DEAUTH_LEAVING, false);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 0104108..0cefd40 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -40,8 +40,8 @@
  *      - Erases current SSID and BSSID information
  *      - Sends a disconnect event to upper layers/applications.
  */
-void
-mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
+void mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code,
+				 bool from_ap)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 
@@ -140,7 +140,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	if (priv->bss_mode == NL80211_IFTYPE_STATION ||
 	    priv->bss_mode == NL80211_IFTYPE_P2P_CLIENT) {
 		cfg80211_disconnected(priv->netdev, reason_code, NULL, 0,
-				      false, GFP_KERNEL);
+				      !from_ap, GFP_KERNEL);
 	}
 	eth_zero_addr(priv->cfg_bssid);
 
@@ -574,7 +574,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		if (priv->media_connected) {
 			reason_code =
 				le16_to_cpu(*(__le16 *)adapter->event_body);
-			mwifiex_reset_connect_state(priv, reason_code);
+			mwifiex_reset_connect_state(priv, reason_code, true);
 		}
 		break;
 
@@ -589,7 +589,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		if (priv->media_connected) {
 			reason_code =
 				le16_to_cpu(*(__le16 *)adapter->event_body);
-			mwifiex_reset_connect_state(priv, reason_code);
+			mwifiex_reset_connect_state(priv, reason_code, true);
 		}
 		break;
 
@@ -599,7 +599,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		if (priv->media_connected) {
 			reason_code =
 				le16_to_cpu(*(__le16 *)adapter->event_body);
-			mwifiex_reset_connect_state(priv, reason_code);
+			mwifiex_reset_connect_state(priv, reason_code, true);
 		}
 		break;
 
-- 
1.9.1

