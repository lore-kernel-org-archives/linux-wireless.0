Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:54517 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab2JFDWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 23:22:33 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.7 4/4] mwifiex: update cfg80211 with correct reason code when connection is lost
Date: Fri,  5 Oct 2012 20:21:43 -0700
Message-Id: <1349493703-1169-5-git-send-email-bzhao@marvell.com> (sfid-20121006_052236_773176_A3E7CD13)
In-Reply-To: <1349493703-1169-1-git-send-email-bzhao@marvell.com>
References: <1349493703-1169-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Driver gets LINK_LOST, DEAUTHENTICATED and DISASSOCIATED events
from firmware when connection is lost in different scenarios.
Currently we are using common code WLAN_REASON_DEAUTH_LEAVING
for these cases.

This patch adds support to parse an actual reason code from
firmware event body and send it to cfg80211.
WLAN_REASON_DEAUTH_LEAVING code is used if deauth is initiated
by our device.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c        |    6 +++-
 drivers/net/wireless/mwifiex/main.h        |    2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    4 +-
 drivers/net/wireless/mwifiex/sta_event.c   |   31 ++++++++++++++++++----------
 4 files changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 82e63ce..7b0858a 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1180,16 +1180,18 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ad_hoc_result *adhoc_result;
 	struct mwifiex_bssdescriptor *bss_desc;
+	u16 reason_code;
 
 	adhoc_result = &resp->params.adhoc_result;
 
 	bss_desc = priv->attempted_bss_desc;
 
 	/* Join result code 0 --> SUCCESS */
-	if (le16_to_cpu(resp->result)) {
+	reason_code = le16_to_cpu(resp->result);
+	if (reason_code) {
 		dev_err(priv->adapter->dev, "ADHOC_RESP: failed\n");
 		if (priv->media_connected)
-			mwifiex_reset_connect_state(priv);
+			mwifiex_reset_connect_state(priv, reason_code);
 
 		memset(&priv->curr_bss_params.bss_descriptor,
 		       0x00, sizeof(struct mwifiex_bssdescriptor));
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index bfb3fa6..c2d0ab1 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -847,7 +847,7 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 				 struct mwifiex_bssdescriptor *bss_desc);
 int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 				 struct host_cmd_ds_command *resp);
-void mwifiex_reset_connect_state(struct mwifiex_private *priv);
+void mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason);
 u8 mwifiex_band_to_radio_type(u8 band);
 int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac);
 int mwifiex_adhoc_start(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index e380171..09e6a26 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -545,7 +545,7 @@ static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
 	if (!memcmp(resp->params.deauth.mac_addr,
 		    &priv->curr_bss_params.bss_descriptor.mac_address,
 		    sizeof(resp->params.deauth.mac_addr)))
-		mwifiex_reset_connect_state(priv);
+		mwifiex_reset_connect_state(priv, WLAN_REASON_DEAUTH_LEAVING);
 
 	return 0;
 }
@@ -558,7 +558,7 @@ static int mwifiex_ret_802_11_deauthenticate(struct mwifiex_private *priv,
 static int mwifiex_ret_802_11_ad_hoc_stop(struct mwifiex_private *priv,
 					  struct host_cmd_ds_command *resp)
 {
-	mwifiex_reset_connect_state(priv);
+	mwifiex_reset_connect_state(priv, WLAN_REASON_DEAUTH_LEAVING);
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index aafde30..8132119 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -41,7 +41,7 @@
  *      - Sends a disconnect event to upper layers/applications.
  */
 void
-mwifiex_reset_connect_state(struct mwifiex_private *priv)
+mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 
@@ -117,10 +117,10 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv)
 	priv->media_connected = false;
 	dev_dbg(adapter->dev,
 		"info: successfully disconnected from %pM: reason code %d\n",
-		priv->cfg_bssid, WLAN_REASON_DEAUTH_LEAVING);
+		priv->cfg_bssid, reason_code);
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
-		cfg80211_disconnected(priv->netdev, WLAN_REASON_DEAUTH_LEAVING,
-				      NULL, 0, GFP_KERNEL);
+		cfg80211_disconnected(priv->netdev, reason_code, NULL, 0,
+				      GFP_KERNEL);
 	}
 	memset(priv->cfg_bssid, 0, ETH_ALEN);
 
@@ -186,7 +186,7 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	struct mwifiex_adapter *adapter = priv->adapter;
 	int ret = 0;
 	u32 eventcause = adapter->event_cause;
-	u16 ctrl;
+	u16 ctrl, reason_code;
 
 	switch (eventcause) {
 	case EVENT_DUMMY_HOST_WAKEUP_SIGNAL:
@@ -204,22 +204,31 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 	case EVENT_DEAUTHENTICATED:
 		dev_dbg(adapter->dev, "event: Deauthenticated\n");
 		adapter->dbg.num_event_deauth++;
-		if (priv->media_connected)
-			mwifiex_reset_connect_state(priv);
+		if (priv->media_connected) {
+			reason_code =
+				le16_to_cpu(*(__le16 *)adapter->event_body);
+			mwifiex_reset_connect_state(priv, reason_code);
+		}
 		break;
 
 	case EVENT_DISASSOCIATED:
 		dev_dbg(adapter->dev, "event: Disassociated\n");
 		adapter->dbg.num_event_disassoc++;
-		if (priv->media_connected)
-			mwifiex_reset_connect_state(priv);
+		if (priv->media_connected) {
+			reason_code =
+				le16_to_cpu(*(__le16 *)adapter->event_body);
+			mwifiex_reset_connect_state(priv, reason_code);
+		}
 		break;
 
 	case EVENT_LINK_LOST:
 		dev_dbg(adapter->dev, "event: Link lost\n");
 		adapter->dbg.num_event_link_lost++;
-		if (priv->media_connected)
-			mwifiex_reset_connect_state(priv);
+		if (priv->media_connected) {
+			reason_code =
+				le16_to_cpu(*(__le16 *)adapter->event_body);
+			mwifiex_reset_connect_state(priv, reason_code);
+		}
 		break;
 
 	case EVENT_PS_SLEEP:
-- 
1.7.0.2

