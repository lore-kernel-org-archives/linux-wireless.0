Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35978 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179AbbAITSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:36 -0500
Received: by mail-oi0-f41.google.com with SMTP id i138so13302115oig.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 11:18:36 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/8] wcn36xx: initialize device defaults on start
Date: Fri,  9 Jan 2015 14:15:45 -0500
Message-Id: <1420830952-9624-2-git-send-email-me@bobcopeland.com> (sfid-20150109_201848_988794_116AC5EC)
In-Reply-To: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
References: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set up default configuration for the device when we call start.
The defaults come from dumps from the prima driver for the same
hardware.

This fixes transmit A-MPDU; previously only one MPDU would be
sent per A-MPDU due to missing MAX_MPDUS_IN_AMPDU setting.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c |   73 +++++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 6398693..69ed397 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -21,6 +21,61 @@
 #include <linux/bitops.h>
 #include "smd.h"
 
+struct wcn36xx_cfg_val {
+	u32 cfg_id;
+	u32 value;
+};
+
+#define WCN36XX_CFG_VAL(id, val) \
+{ \
+	.cfg_id = WCN36XX_HAL_CFG_ ## id, \
+	.value = val \
+}
+
+static struct wcn36xx_cfg_val wcn36xx_cfg_vals[] = {
+	WCN36XX_CFG_VAL(CURRENT_TX_ANTENNA, 1),
+	WCN36XX_CFG_VAL(CURRENT_RX_ANTENNA, 1),
+	WCN36XX_CFG_VAL(LOW_GAIN_OVERRIDE, 0),
+	WCN36XX_CFG_VAL(POWER_STATE_PER_CHAIN, 785),
+	WCN36XX_CFG_VAL(CAL_PERIOD, 5),
+	WCN36XX_CFG_VAL(CAL_CONTROL, 1),
+	WCN36XX_CFG_VAL(PROXIMITY, 0),
+	WCN36XX_CFG_VAL(NETWORK_DENSITY, 3),
+	WCN36XX_CFG_VAL(MAX_MEDIUM_TIME, 6000),
+	WCN36XX_CFG_VAL(MAX_MPDUS_IN_AMPDU, 64),
+	WCN36XX_CFG_VAL(RTS_THRESHOLD, 2347),
+	WCN36XX_CFG_VAL(SHORT_RETRY_LIMIT, 6),
+	WCN36XX_CFG_VAL(LONG_RETRY_LIMIT, 6),
+	WCN36XX_CFG_VAL(FRAGMENTATION_THRESHOLD, 8000),
+	WCN36XX_CFG_VAL(DYNAMIC_THRESHOLD_ZERO, 5),
+	WCN36XX_CFG_VAL(DYNAMIC_THRESHOLD_ONE, 10),
+	WCN36XX_CFG_VAL(DYNAMIC_THRESHOLD_TWO, 15),
+	WCN36XX_CFG_VAL(FIXED_RATE, 0),
+	WCN36XX_CFG_VAL(RETRYRATE_POLICY, 4),
+	WCN36XX_CFG_VAL(RETRYRATE_SECONDARY, 0),
+	WCN36XX_CFG_VAL(RETRYRATE_TERTIARY, 0),
+	WCN36XX_CFG_VAL(FORCE_POLICY_PROTECTION, 5),
+	WCN36XX_CFG_VAL(FIXED_RATE_MULTICAST_24GHZ, 1),
+	WCN36XX_CFG_VAL(FIXED_RATE_MULTICAST_5GHZ, 5),
+	WCN36XX_CFG_VAL(DEFAULT_RATE_INDEX_5GHZ, 5),
+	WCN36XX_CFG_VAL(MAX_BA_SESSIONS, 40),
+	WCN36XX_CFG_VAL(PS_DATA_INACTIVITY_TIMEOUT, 200),
+	WCN36XX_CFG_VAL(PS_ENABLE_BCN_FILTER, 1),
+	WCN36XX_CFG_VAL(PS_ENABLE_RSSI_MONITOR, 1),
+	WCN36XX_CFG_VAL(NUM_BEACON_PER_RSSI_AVERAGE, 20),
+	WCN36XX_CFG_VAL(STATS_PERIOD, 10),
+	WCN36XX_CFG_VAL(CFP_MAX_DURATION, 30000),
+	WCN36XX_CFG_VAL(FRAME_TRANS_ENABLED, 0),
+	WCN36XX_CFG_VAL(BA_THRESHOLD_HIGH, 128),
+	WCN36XX_CFG_VAL(MAX_BA_BUFFERS, 2560),
+	WCN36XX_CFG_VAL(DYNAMIC_PS_POLL_VALUE, 0),
+	WCN36XX_CFG_VAL(TX_PWR_CTRL_ENABLE, 1),
+	WCN36XX_CFG_VAL(ENABLE_CLOSE_LOOP, 1),
+	WCN36XX_CFG_VAL(ENABLE_LPWR_IMG_TRANSITION, 0),
+	WCN36XX_CFG_VAL(MAX_ASSOC_LIMIT, 10),
+	WCN36XX_CFG_VAL(ENABLE_MCC_ADAPTIVE_SCHEDULER, 0),
+};
+
 static int put_cfg_tlv_u32(struct wcn36xx *wcn, size_t *len, u32 id, u32 value)
 {
 	struct wcn36xx_hal_cfg *entry;
@@ -357,8 +412,10 @@ static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
 
 int wcn36xx_smd_start(struct wcn36xx *wcn)
 {
-	struct wcn36xx_hal_mac_start_req_msg msg_body;
+	struct wcn36xx_hal_mac_start_req_msg msg_body, *body;
 	int ret = 0;
+	int i;
+	size_t len;
 
 	mutex_lock(&wcn->hal_mutex);
 	INIT_HAL_MSG(msg_body, WCN36XX_HAL_START_REQ);
@@ -368,10 +425,22 @@ int wcn36xx_smd_start(struct wcn36xx *wcn)
 
 	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
 
+	body = (struct wcn36xx_hal_mac_start_req_msg *)wcn->hal_buf;
+	len = body->header.len;
+
+	for (i = 0; i < ARRAY_SIZE(wcn36xx_cfg_vals); i++) {
+		ret = put_cfg_tlv_u32(wcn, &len, wcn36xx_cfg_vals[i].cfg_id,
+				      wcn36xx_cfg_vals[i].value);
+		if (ret)
+			goto out;
+	}
+	body->header.len = len;
+	body->params.len = len - sizeof(*body);
+
 	wcn36xx_dbg(WCN36XX_DBG_HAL, "hal start type %d\n",
 		    msg_body.params.type);
 
-	ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
+	ret = wcn36xx_smd_send_and_wait(wcn, body->header.len);
 	if (ret) {
 		wcn36xx_err("Sending hal_start failed\n");
 		goto out;
-- 
1.7.10.4

