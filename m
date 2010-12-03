Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33654 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0LCVaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 16:30:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] mwifiex: remove questionable wireless_send_event stuff...
Date: Fri,  3 Dec 2010 16:17:30 -0500
Message-Id: <1291411051-12916-4-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20101203191130.GD2348@tuxdriver.com>
References: <20101203191130.GD2348@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/mwifiex/main.c |   11 +--
 drivers/net/wireless/mwifiex/main.h |    2 -
 drivers/net/wireless/mwifiex/scan.c |    5 -
 drivers/net/wireless/mwifiex/util.c |  246 ++++-------------------------------
 4 files changed, 26 insertions(+), 238 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 0c0053d..7e8973f 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -883,22 +883,15 @@ mwifiex_remove_interface(struct mwifiex_adapter *adapter, u8 bss_index)
 {
 	struct net_device *dev = NULL;
 	struct mwifiex_private *priv = adapter->priv[bss_index];
-	union iwreq_data wrqu;
 
 	ENTER();
 	if (!priv)
 		goto error;
 	dev = priv->netdev;
 
-	if (priv->media_connected) {
+	if (priv->media_connected)
 		priv->media_connected = false;
-		if (GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) {
-			memset(wrqu.ap_addr.sa_data, 0xaa, ETH_ALEN);
-			wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-			wireless_send_event(priv->netdev, SIOCGIWAP,
-					    &wrqu, NULL);
-		}
-	}
+
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_dev_debugfs_remove(priv);
 #endif
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 8ae2048..285cbc0 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -1035,8 +1035,6 @@ enum mwifiex_status mwifiex_cancel_hs(struct mwifiex_private *priv,
 int mwifiex_enable_hs(struct mwifiex_adapter *adapter);
 int mwifiex_set_deep_sleep(struct mwifiex_private *priv, u8 wait_option,
 			   bool bdeep_sleep, u16 idletime);
-void mwifiex_send_iwevcustom_event(struct mwifiex_private *priv, s8 *str);
-void mwifiex_send_mic_error_event(struct mwifiex_private *priv, u32 event);
 void mwifiex_process_ioctl_resp(struct mwifiex_private *priv,
 				struct mwifiex_ioctl_req *req);
 void mwifiex_request_get_fw_info(struct mwifiex_private *priv);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 21738bb..ddde627 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -251,7 +251,6 @@ mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 {
 	struct mwifiex_ioctl_req *req = NULL;
 	struct mwifiex_ds_scan *scan = NULL;
-	union iwreq_data wrqu;
 	enum mwifiex_status status = MWIFIEX_STATUS_SUCCESS;
 
 	ENTER();
@@ -274,10 +273,6 @@ mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 			scan_req, sizeof(struct mwifiex_user_scan_cfg));
 
 	status = mwifiex_request_ioctl(priv, req, MWIFIEX_IOCTL_WAIT);
-	if (status == MWIFIEX_STATUS_SUCCESS) {
-		memset(&wrqu, 0, sizeof(union iwreq_data));
-		wireless_send_event(priv->netdev, SIOCGIWSCAN, &wrqu, NULL);
-	}
 
 done:
 	if (req && (status != MWIFIEX_STATUS_PENDING))
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index cc43313..d28f5a9 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -827,110 +827,6 @@ mwifiex_print(u32 level, s8 *pformat, ...)
 EXPORT_SYMBOL_GPL(mwifiex_print);
 
 /*
- * This function sends a customized wireless event to application.
- */
-void
-mwifiex_send_iwevcustom_event(struct mwifiex_private *priv, s8 *str)
-{
-	union iwreq_data iwrq;
-	char buf[50];
-
-	ENTER();
-
-	memset(&iwrq, 0, sizeof(union iwreq_data));
-	memset(buf, 0, sizeof(buf));
-
-	snprintf(buf, sizeof(buf) - 1, "%s", str);
-
-	iwrq.data.pointer = (void __force __user *)buf;
-	iwrq.data.length = strlen(buf) + 1 + IW_EV_LCP_LEN;
-
-	/* Send Event to upper layer */
-	wireless_send_event(priv->netdev, IWEVCUSTOM, &iwrq, buf);
-	PRINTM(MINFO, "Wireless event %s is sent to application\n", str);
-
-	LEAVE();
-	return;
-}
-
-/*
- * This function sends a mic error event to application.
- */
-void
-mwifiex_send_mic_error_event(struct mwifiex_private *priv, u32 event)
-{
-	union iwreq_data iwrq;
-	struct iw_michaelmicfailure mic;
-
-	ENTER();
-
-	memset(&iwrq, 0, sizeof(iwrq));
-	memset(&mic, 0, sizeof(mic));
-	if (event == MWIFIEX_EVENT_ID_FW_MIC_ERR_UNI)
-		mic.flags = IW_MICFAILURE_PAIRWISE;
-	else
-		mic.flags = IW_MICFAILURE_GROUP;
-	iwrq.data.pointer = (void __force __user *)&mic;
-	iwrq.data.length = sizeof(mic);
-
-	wireless_send_event(priv->netdev, IWEVMICHAELMICFAILURE, &iwrq,
-			    (char *) &mic);
-
-	LEAVE();
-	return;
-}
-
-/** Custom event : AdHoc link sensed */
-#define CUS_EVT_ADHOC_LINK_SENSED	"EVENT=ADHOC_LINK_SENSED"
-/** Custom event : AdHoc link lost */
-#define CUS_EVT_ADHOC_LINK_LOST		"EVENT=ADHOC_LINK_LOST"
-/** Custom event : Beacon RSSI low */
-#define CUS_EVT_BEACON_RSSI_LOW		"EVENT=BEACON_RSSI_LOW"
-/** Custom event : Beacon SNR low */
-#define CUS_EVT_BEACON_SNR_LOW		"EVENT=BEACON_SNR_LOW"
-/** Custom event : Beacon RSSI high */
-#define CUS_EVT_BEACON_RSSI_HIGH	"EVENT=BEACON_RSSI_HIGH"
-/** Custom event : Beacon SNR high */
-#define CUS_EVT_BEACON_SNR_HIGH		"EVENT=BEACON_SNR_HIGH"
-/** Custom event : Max fail */
-#define CUS_EVT_MAX_FAIL		"EVENT=MAX_FAIL"
-/** Custom event : Data RSSI low */
-#define CUS_EVT_DATA_RSSI_LOW		"EVENT=DATA_RSSI_LOW"
-/** Custom event : Data SNR low */
-#define CUS_EVT_DATA_SNR_LOW		"EVENT=DATA_SNR_LOW"
-/** Custom event : Data RSSI high */
-#define CUS_EVT_DATA_RSSI_HIGH		"EVENT=DATA_RSSI_HIGH"
-/** Custom event : Data SNR high */
-#define CUS_EVT_DATA_SNR_HIGH		"EVENT=DATA_SNR_HIGH"
-/** Custom event : Link Quality */
-#define CUS_EVT_LINK_QUALITY		"EVENT=LINK_QUALITY"
-/** Custom event : Port Release */
-#define CUS_EVT_PORT_RELEASE		"EVENT=PORT_RELEASE"
-/** Custom event : Pre-Beacon Lost */
-#define CUS_EVT_PRE_BEACON_LOST		"EVENT=PRE_BEACON_LOST"
-
-/** Custom event : Deep Sleep awake */
-#define CUS_EVT_DEEP_SLEEP_AWAKE	"EVENT=DS_AWAKE"
-
-/** Custom event : Host Sleep activated */
-#define CUS_EVT_HS_ACTIVATED		"HS_ACTIVATED "
-/** Custom event : Host Sleep deactivated */
-#define CUS_EVT_HS_DEACTIVATED		"HS_DEACTIVATED "
-/** Custom event : Host Sleep wakeup */
-#define CUS_EVT_HS_WAKEUP		"HS_WAKEUP"
-
-/** Custom indiciation message sent to the application layer for WMM changes */
-#define WMM_CONFIG_CHANGE_INDICATION  "WMM_CONFIG_CHANGE.indication"
-
-/** Custom event : WEP ICV error */
-#define CUS_EVT_WEP_ICV_ERR		"EVENT=WEP_ICV_ERR"
-
-/** Custom event : BW changed */
-#define CUS_EVT_BW_CHANGED		"EVENT=BW_CHANGED"
-/** Custom event : OBSS scan parameter */
-#define CUS_EVT_OBSS_SCAN_PARAM		"EVENT=OBSS_SCAN_PARAM"
-
-/*
  * This function handles received events.
  *
  * Handling may include updating the traffic queue status, setting
@@ -943,7 +839,6 @@ mwifiex_process_recv_event(struct mwifiex_adapter *adapter,
 				struct mwifiex_event *event)
 {
 	struct mwifiex_private *priv = NULL;
-	union iwreq_data wrqu;
 
 	ENTER();
 
@@ -960,7 +855,6 @@ mwifiex_process_recv_event(struct mwifiex_adapter *adapter,
 			netif_carrier_on(priv->netdev);
 		if (netif_queue_stopped(priv->netdev))
 			netif_wake_queue(priv->netdev);
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_ADHOC_LINK_SENSED);
 		break;
 	case MWIFIEX_EVENT_ID_FW_ADHOC_LINK_LOST:
 		if (!netif_queue_stopped(priv->netdev))
@@ -968,17 +862,8 @@ mwifiex_process_recv_event(struct mwifiex_adapter *adapter,
 		if (netif_carrier_ok(priv->netdev))
 			netif_carrier_off(priv->netdev);
 		priv->is_adhoc_link_sensed = false;
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_ADHOC_LINK_LOST);
 		break;
 	case MWIFIEX_EVENT_ID_DRV_CONNECTED:
-		if (event->event_len == ETH_ALEN) {
-			memset(wrqu.ap_addr.sa_data, 0x00, ETH_ALEN);
-			memcpy(wrqu.ap_addr.sa_data, event->event_buf,
-			       ETH_ALEN);
-			wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-			wireless_send_event(priv->netdev, SIOCGIWAP, &wrqu,
-					    NULL);
-		}
 		priv->media_connected = true;
 		if (!netif_carrier_ok(priv->netdev))
 			netif_carrier_on(priv->netdev);
@@ -987,54 +872,13 @@ mwifiex_process_recv_event(struct mwifiex_adapter *adapter,
 		break;
 	case MWIFIEX_EVENT_ID_DRV_SCAN_REPORT:
 		PRINTM(MCMND, "Scan report\n");
-		if (priv->report_scan_result) {
-			memset(&wrqu, 0, sizeof(union iwreq_data));
-			wireless_send_event(priv->netdev, SIOCGIWSCAN, &wrqu,
-					    NULL);
+		if (priv->report_scan_result)
 			priv->report_scan_result = false;
-		}
 		if (priv->scan_pending_on_block) {
 			priv->scan_pending_on_block = false;
 			up(&priv->async_sem);
 		}
 		break;
-	case MWIFIEX_EVENT_ID_DRV_OBSS_SCAN_PARAM:
-		memset(&wrqu, 0, sizeof(union iwreq_data));
-		memmove((event->event_buf + strlen(CUS_EVT_OBSS_SCAN_PARAM) +
-			 1), event->event_buf, event->event_len);
-		memcpy(event->event_buf, (u8 *) CUS_EVT_OBSS_SCAN_PARAM,
-		       strlen(CUS_EVT_OBSS_SCAN_PARAM));
-		event->event_buf[strlen(CUS_EVT_OBSS_SCAN_PARAM)] = 0;
-
-		wrqu.data.pointer = (void __force __user *)event->event_buf;
-		wrqu.data.length =
-			event->event_len + strlen(CUS_EVT_OBSS_SCAN_PARAM) +
-			IW_EV_LCP_LEN + 1;
-		wireless_send_event(priv->netdev, IWEVCUSTOM, &wrqu,
-				    event->event_buf);
-		break;
-	case MWIFIEX_EVENT_ID_FW_BW_CHANGED:
-		memset(&wrqu, 0, sizeof(union iwreq_data));
-		memmove((event->event_buf + strlen(CUS_EVT_BW_CHANGED) + 1),
-			event->event_buf, event->event_len);
-		memcpy(event->event_buf, (u8 *) CUS_EVT_BW_CHANGED,
-		       strlen(CUS_EVT_BW_CHANGED));
-		event->event_buf[strlen(CUS_EVT_BW_CHANGED)] = 0;
-
-		wrqu.data.pointer = (void __force __user *)event->event_buf;
-		wrqu.data.length =
-			event->event_len + strlen(CUS_EVT_BW_CHANGED) +
-			IW_EV_LCP_LEN + 1;
-		wireless_send_event(priv->netdev, IWEVCUSTOM, &wrqu,
-				    event->event_buf);
-		break;
-	case MWIFIEX_EVENT_ID_HOSTWAKE_STAIE:
-		wrqu.data.pointer = (void __force __user *)event->event_buf;
-		wrqu.data.length = event->event_len + IW_EV_LCP_LEN + 1;
-		wireless_send_event(priv->netdev, IWEVCUSTOM, &wrqu,
-				    event->event_buf);
-
-		break;
 	case MWIFIEX_EVENT_ID_FW_DISCONNECTED:
 		priv->media_connected = false;
 		if (!priv->disconnect) {
@@ -1051,76 +895,19 @@ mwifiex_process_recv_event(struct mwifiex_adapter *adapter,
 			netif_stop_queue(priv->netdev);
 		if (netif_carrier_ok(priv->netdev))
 			netif_carrier_off(priv->netdev);
-		memset(wrqu.ap_addr.sa_data, 0x00, ETH_ALEN);
-		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-		wireless_send_event(priv->netdev, SIOCGIWAP, &wrqu, NULL);
 		/* Reset wireless stats signal info */
 		priv->w_stats.qual.level = 0;
 		priv->w_stats.qual.noise = 0;
 		break;
-	case MWIFIEX_EVENT_ID_FW_MIC_ERR_UNI:
-		mwifiex_send_mic_error_event(priv,
-					     MWIFIEX_EVENT_ID_FW_MIC_ERR_UNI);
-		break;
-	case MWIFIEX_EVENT_ID_FW_MIC_ERR_MUL:
-		mwifiex_send_mic_error_event(priv,
-					     MWIFIEX_EVENT_ID_FW_MIC_ERR_MUL);
-		break;
-	case MWIFIEX_EVENT_ID_FW_BCN_RSSI_LOW:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_BEACON_RSSI_LOW);
-		break;
-	case MWIFIEX_EVENT_ID_FW_BCN_RSSI_HIGH:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_BEACON_RSSI_HIGH);
-		break;
-	case MWIFIEX_EVENT_ID_FW_BCN_SNR_LOW:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_BEACON_SNR_LOW);
-		break;
-	case MWIFIEX_EVENT_ID_FW_BCN_SNR_HIGH:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_BEACON_SNR_HIGH);
-		break;
-	case MWIFIEX_EVENT_ID_FW_MAX_FAIL:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_MAX_FAIL);
-		break;
-	case MWIFIEX_EVENT_ID_FW_DATA_RSSI_LOW:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_DATA_RSSI_LOW);
-		break;
-	case MWIFIEX_EVENT_ID_FW_DATA_SNR_LOW:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_DATA_SNR_LOW);
-		break;
-	case MWIFIEX_EVENT_ID_FW_DATA_RSSI_HIGH:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_DATA_RSSI_HIGH);
-		break;
-	case MWIFIEX_EVENT_ID_FW_DATA_SNR_HIGH:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_DATA_SNR_HIGH);
-		break;
-	case MWIFIEX_EVENT_ID_FW_LINK_QUALITY:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_LINK_QUALITY);
-		break;
-	case MWIFIEX_EVENT_ID_FW_PORT_RELEASE:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_PORT_RELEASE);
-		break;
-	case MWIFIEX_EVENT_ID_FW_PRE_BCN_LOST:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_PRE_BEACON_LOST);
-		break;
-	case MWIFIEX_EVENT_ID_FW_DS_AWAKE:
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_DEEP_SLEEP_AWAKE);
-		break;
-	case MWIFIEX_EVENT_ID_FW_WMM_CONFIG_CHANGE:
-		mwifiex_send_iwevcustom_event(priv,
-					      WMM_CONFIG_CHANGE_INDICATION);
-		break;
 	case MWIFIEX_EVENT_ID_FW_WEP_ICV_ERR:
 		DBG_HEXDUMP(MCMD_D, "WEP ICV error", event->event_buf,
 			    event->event_len);
-		mwifiex_send_iwevcustom_event(priv, CUS_EVT_WEP_ICV_ERR);
 		break;
 
 	case MWIFIEX_EVENT_ID_DRV_DEFER_HANDLING:
 		queue_work(adapter->workqueue, &adapter->main_work);
 		break;
 	case MWIFIEX_EVENT_ID_FW_BG_SCAN:
-		memset(&wrqu, 0, sizeof(union iwreq_data));
-		wireless_send_event(priv->netdev, SIOCGIWSCAN, &wrqu, NULL);
 		break;
 	case MWIFIEX_EVENT_ID_FW_STOP_TX:
 		netif_carrier_off(priv->netdev);
@@ -1132,14 +919,10 @@ mwifiex_process_recv_event(struct mwifiex_adapter *adapter,
 		/* simulate HSCFG_CANCEL command */
 		mwifiex_cancel_hs(priv, MWIFIEX_NO_WAIT);
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
-		if (priv)
-			mwifiex_send_iwevcustom_event(priv, CUS_EVT_HS_WAKEUP);
 		break;
 	case MWIFIEX_EVENT_ID_DRV_HS_ACTIVATED:
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
 		if (priv) {
-			mwifiex_send_iwevcustom_event(priv,
-						      CUS_EVT_HS_ACTIVATED);
 			adapter->hs_activated = true;
 			adapter->hs_activate_wait_q_woken = true;
 			wake_up_interruptible(&adapter->hs_activate_wait_q);
@@ -1147,11 +930,30 @@ mwifiex_process_recv_event(struct mwifiex_adapter *adapter,
 		break;
 	case MWIFIEX_EVENT_ID_DRV_HS_DEACTIVATED:
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
-		if (priv) {
+		if (priv)
 			adapter->hs_activated = false;
-			mwifiex_send_iwevcustom_event(priv,
-						      CUS_EVT_HS_DEACTIVATED);
-		}
+		break;
+
+	/* These events might be interesting to some userland? */
+	case MWIFIEX_EVENT_ID_DRV_OBSS_SCAN_PARAM:
+	case MWIFIEX_EVENT_ID_FW_BW_CHANGED:
+	case MWIFIEX_EVENT_ID_HOSTWAKE_STAIE:
+	case MWIFIEX_EVENT_ID_FW_MIC_ERR_UNI:
+	case MWIFIEX_EVENT_ID_FW_MIC_ERR_MUL:
+	case MWIFIEX_EVENT_ID_FW_BCN_RSSI_LOW:
+	case MWIFIEX_EVENT_ID_FW_BCN_RSSI_HIGH:
+	case MWIFIEX_EVENT_ID_FW_BCN_SNR_LOW:
+	case MWIFIEX_EVENT_ID_FW_BCN_SNR_HIGH:
+	case MWIFIEX_EVENT_ID_FW_MAX_FAIL:
+	case MWIFIEX_EVENT_ID_FW_DATA_RSSI_LOW:
+	case MWIFIEX_EVENT_ID_FW_DATA_SNR_LOW:
+	case MWIFIEX_EVENT_ID_FW_DATA_RSSI_HIGH:
+	case MWIFIEX_EVENT_ID_FW_DATA_SNR_HIGH:
+	case MWIFIEX_EVENT_ID_FW_LINK_QUALITY:
+	case MWIFIEX_EVENT_ID_FW_PORT_RELEASE:
+	case MWIFIEX_EVENT_ID_FW_PRE_BCN_LOST:
+	case MWIFIEX_EVENT_ID_FW_DS_AWAKE:
+	case MWIFIEX_EVENT_ID_FW_WMM_CONFIG_CHANGE:
 		break;
 
 	default:
-- 
1.7.3.2

