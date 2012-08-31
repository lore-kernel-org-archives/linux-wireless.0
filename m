Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:44566 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab2HaBgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 21:36:03 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jeff Disher <disher@chromium.org>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: store mwifiex_ds_misc_subsc_evt in mwifiex_private
Date: Thu, 30 Aug 2012 18:20:55 -0700
Message-Id: <1346376056-25708-1-git-send-email-bzhao@marvell.com> (sfid-20120831_033646_673859_D450BCF9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jeff Disher <disher@chromium.org>

Since mwifiex_ds_misc_subsc_evt is used in an asynchronous case,
store the structure in the long-lived mwifiex_private instead of
on the calling stack.

This fixes a problem where the response of the asynchronous
operation would corrupt a stack frame potentially in use by
a different thread.

Signed-off-by: Jeff Disher <disher@chromium.org>
Reviewed-by: Sam Leffler <sleffler@chromium.org>
Tested-by: Jeff Disher <disher@chromium.org>
Acked-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/main.h        |    1 +
 drivers/net/wireless/mwifiex/sta_cmdresp.c |   24 +++++++++++++-----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ede0c65..bb75390 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -484,6 +484,7 @@ struct mwifiex_private {
 	s32 cqm_rssi_thold;
 	u32 cqm_rssi_hyst;
 	u8 subsc_evt_rssi_state;
+	struct mwifiex_ds_misc_subsc_evt async_subsc_evt_storage;
 	struct mwifiex_ie mgmt_ie[MAX_MGMT_IE_INDEX];
 	u16 beacon_idx;
 	u16 proberesp_idx;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 0b09004..6536356 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -123,7 +123,8 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_802_11_rssi_info_rsp *rssi_info_rsp =
 						&resp->params.rssi_info_rsp;
-	struct mwifiex_ds_misc_subsc_evt subsc_evt;
+	struct mwifiex_ds_misc_subsc_evt *subsc_evt =
+						&priv->async_subsc_evt_storage;
 
 	priv->data_rssi_last = le16_to_cpu(rssi_info_rsp->data_rssi_last);
 	priv->data_nf_last = le16_to_cpu(rssi_info_rsp->data_nf_last);
@@ -140,26 +141,27 @@ static int mwifiex_ret_802_11_rssi_info(struct mwifiex_private *priv,
 	if (priv->subsc_evt_rssi_state == EVENT_HANDLED)
 		return 0;
 
+	memset(subsc_evt, 0x00, sizeof(struct mwifiex_ds_misc_subsc_evt));
+
 	/* Resubscribe low and high rssi events with new thresholds */
-	memset(&subsc_evt, 0x00, sizeof(struct mwifiex_ds_misc_subsc_evt));
-	subsc_evt.events = BITMASK_BCN_RSSI_LOW | BITMASK_BCN_RSSI_HIGH;
-	subsc_evt.action = HostCmd_ACT_BITWISE_SET;
+	subsc_evt->events = BITMASK_BCN_RSSI_LOW | BITMASK_BCN_RSSI_HIGH;
+	subsc_evt->action = HostCmd_ACT_BITWISE_SET;
 	if (priv->subsc_evt_rssi_state == RSSI_LOW_RECVD) {
-		subsc_evt.bcn_l_rssi_cfg.abs_value = abs(priv->bcn_rssi_avg -
+		subsc_evt->bcn_l_rssi_cfg.abs_value = abs(priv->bcn_rssi_avg -
 				priv->cqm_rssi_hyst);
-		subsc_evt.bcn_h_rssi_cfg.abs_value = abs(priv->cqm_rssi_thold);
+		subsc_evt->bcn_h_rssi_cfg.abs_value = abs(priv->cqm_rssi_thold);
 	} else if (priv->subsc_evt_rssi_state == RSSI_HIGH_RECVD) {
-		subsc_evt.bcn_l_rssi_cfg.abs_value = abs(priv->cqm_rssi_thold);
-		subsc_evt.bcn_h_rssi_cfg.abs_value = abs(priv->bcn_rssi_avg +
+		subsc_evt->bcn_l_rssi_cfg.abs_value = abs(priv->cqm_rssi_thold);
+		subsc_evt->bcn_h_rssi_cfg.abs_value = abs(priv->bcn_rssi_avg +
 				priv->cqm_rssi_hyst);
 	}
-	subsc_evt.bcn_l_rssi_cfg.evt_freq = 1;
-	subsc_evt.bcn_h_rssi_cfg.evt_freq = 1;
+	subsc_evt->bcn_l_rssi_cfg.evt_freq = 1;
+	subsc_evt->bcn_h_rssi_cfg.evt_freq = 1;
 
 	priv->subsc_evt_rssi_state = EVENT_HANDLED;
 
 	mwifiex_send_cmd_async(priv, HostCmd_CMD_802_11_SUBSCRIBE_EVENT,
-			       0, 0, &subsc_evt);
+			       0, 0, subsc_evt);
 
 	return 0;
 }
-- 
1.7.0.2

