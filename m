Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:43606 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750876AbeAPODC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 09:03:02 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/13] staging: wilc1000: rename wilc_wfi_p2pListenParams struct and its member variable
Date: Tue, 16 Jan 2018 19:32:20 +0530
Message-ID: <1516111351-5353-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180116_150349_455885_9F018554)
In-Reply-To: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
References: <1516111351-5353-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a cleanup patch to avoid the use of camelCase for variable names.
In this patch, "Avoid camelCase" issue found by checkpatch.pl is fixed.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 28 +++++++++++------------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     | 12 +++++-----
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 175c64f..d6ff989 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1525,9 +1525,9 @@ static void WILC_WFI_RemainOnChannelReady(void *pUserVoid)
 	priv->p2p_listen_state = true;
 
 	cfg80211_ready_on_channel(priv->wdev,
-				  priv->remain_on_ch_params.u64ListenCookie,
-				  priv->remain_on_ch_params.pstrListenChan,
-				  priv->remain_on_ch_params.u32ListenDuration,
+				  priv->remain_on_ch_params.listen_cookie,
+				  priv->remain_on_ch_params.listen_ch,
+				  priv->remain_on_ch_params.listen_duration,
 				  GFP_KERNEL);
 }
 
@@ -1537,12 +1537,12 @@ static void WILC_WFI_RemainOnChannelExpired(void *pUserVoid, u32 u32SessionID)
 
 	priv = pUserVoid;
 
-	if (u32SessionID == priv->remain_on_ch_params.u32ListenSessionID) {
+	if (u32SessionID == priv->remain_on_ch_params.listen_session_id) {
 		priv->p2p_listen_state = false;
 
 		cfg80211_remain_on_channel_expired(priv->wdev,
-						   priv->remain_on_ch_params.u64ListenCookie,
-						   priv->remain_on_ch_params.pstrListenChan,
+						   priv->remain_on_ch_params.listen_cookie,
+						   priv->remain_on_ch_params.listen_ch,
 						   GFP_KERNEL);
 	}
 }
@@ -1566,13 +1566,13 @@ static int remain_on_channel(struct wiphy *wiphy,
 
 	curr_channel = chan->hw_value;
 
-	priv->remain_on_ch_params.pstrListenChan = chan;
-	priv->remain_on_ch_params.u64ListenCookie = *cookie;
-	priv->remain_on_ch_params.u32ListenDuration = duration;
-	priv->remain_on_ch_params.u32ListenSessionID++;
+	priv->remain_on_ch_params.listen_ch = chan;
+	priv->remain_on_ch_params.listen_cookie = *cookie;
+	priv->remain_on_ch_params.listen_duration = duration;
+	priv->remain_on_ch_params.listen_session_id++;
 
 	return wilc_remain_on_channel(vif,
-				priv->remain_on_ch_params.u32ListenSessionID,
+				priv->remain_on_ch_params.listen_session_id,
 				duration, chan->hw_value,
 				WILC_WFI_RemainOnChannelExpired,
 				WILC_WFI_RemainOnChannelReady, (void *)priv);
@@ -1589,7 +1589,7 @@ static int cancel_remain_on_channel(struct wiphy *wiphy,
 	vif = netdev_priv(priv->dev);
 
 	return wilc_listen_state_expired(vif,
-			priv->remain_on_ch_params.u32ListenSessionID);
+			priv->remain_on_ch_params.listen_session_id);
 }
 
 static int mgmt_tx(struct wiphy *wiphy,
@@ -1718,8 +1718,8 @@ static int mgmt_tx_cancel_wait(struct wiphy *wiphy,
 
 	if (!priv->p2p_listen_state) {
 		cfg80211_remain_on_channel_expired(priv->wdev,
-						   priv->remain_on_ch_params.u64ListenCookie,
-						   priv->remain_on_ch_params.pstrListenChan,
+						   priv->remain_on_ch_params.listen_cookie,
+						   priv->remain_on_ch_params.listen_ch,
 						   GFP_KERNEL);
 	}
 
diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 2046bb9..0a936a4 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -90,19 +90,19 @@ struct sta_info {
 };
 
 /*Parameters needed for host interface for  remaining on channel*/
-struct wilc_wfi_p2pListenParams {
-	struct ieee80211_channel *pstrListenChan;
+struct wilc_wfi_p2p_listen_params {
+	struct ieee80211_channel *listen_ch;
 	enum nl80211_channel_type tenuChannelType;
-	u32 u32ListenDuration;
-	u64 u64ListenCookie;
-	u32 u32ListenSessionID;
+	u32 listen_duration;
+	u64 listen_cookie;
+	u32 listen_session_id;
 };
 
 struct wilc_priv {
 	struct wireless_dev *wdev;
 	struct cfg80211_scan_request *scan_req;
 
-	struct wilc_wfi_p2pListenParams remain_on_ch_params;
+	struct wilc_wfi_p2p_listen_params remain_on_ch_params;
 	u64 tx_cookie;
 
 	bool cfg_scanning;
-- 
2.7.4
