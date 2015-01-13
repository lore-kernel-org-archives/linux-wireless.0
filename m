Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36421 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbbAMGJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2015 01:09:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t0D64lUt022552
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:33 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rv520k6c9-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 22:09:33 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 7/8] mwifiex: handle PS events on AP interface as well
Date: Tue, 13 Jan 2015 17:08:49 +0530
Message-ID: <1421149130-5889-8-git-send-email-patila@marvell.com> (sfid-20150113_070939_126039_66B8711D)
In-Reply-To: <1421149130-5889-1-git-send-email-patila@marvell.com>
References: <1421149130-5889-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to handle PS events on AP interface as well.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c    | 36 ++++++++++++-----------------
 drivers/net/wireless/mwifiex/uap_event.c | 39 ++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index ea04a5c..dcc8589 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -315,22 +315,19 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		adapter->dbg.num_cmd_sleep_cfm_host_to_card_failure++;
 		return -1;
 	}
-	if (GET_BSS_ROLE(mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY))
-	    == MWIFIEX_BSS_ROLE_STA) {
-		if (!le16_to_cpu(sleep_cfm_buf->resp_ctrl))
-			/* Response is not needed for sleep
-			   confirm command */
-			adapter->ps_state = PS_STATE_SLEEP;
-		else
-			adapter->ps_state = PS_STATE_SLEEP_CFM;
-
-		if (!le16_to_cpu(sleep_cfm_buf->resp_ctrl) &&
-		    (adapter->is_hs_configured &&
-		     !adapter->sleep_period.period)) {
-			adapter->pm_wakeup_card_req = true;
-			mwifiex_hs_activated_event(mwifiex_get_priv
-					(adapter, MWIFIEX_BSS_ROLE_STA), true);
-		}
+
+	if (!le16_to_cpu(sleep_cfm_buf->resp_ctrl))
+		/* Response is not needed for sleep confirm command */
+		adapter->ps_state = PS_STATE_SLEEP;
+	else
+		adapter->ps_state = PS_STATE_SLEEP_CFM;
+
+	if (!le16_to_cpu(sleep_cfm_buf->resp_ctrl) &&
+	    (adapter->is_hs_configured &&
+	     !adapter->sleep_period.period)) {
+		adapter->pm_wakeup_card_req = true;
+		mwifiex_hs_activated_event(mwifiex_get_priv
+				(adapter, MWIFIEX_BSS_ROLE_ANY), true);
 	}
 
 	return ret;
@@ -450,6 +447,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 				      EVENT_GET_BSS_TYPE(eventcause));
 	if (!priv)
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
+
 	/* Clear BSS_NO_BITS from event */
 	eventcause &= EVENT_ID_MASK;
 	adapter->event_cause = eventcause;
@@ -462,12 +460,6 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 	}
 
 	dev_dbg(adapter->dev, "EVENT: cause: %#x\n", eventcause);
-	if (eventcause == EVENT_PS_SLEEP || eventcause == EVENT_PS_AWAKE) {
-		/* Handle PS_SLEEP/AWAKE events on STA */
-		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
-		if (!priv)
-			priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
-	}
 
 	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
 		ret = mwifiex_process_uap_event(priv);
diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index f31086c..ec40be8 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -179,6 +179,45 @@ int mwifiex_process_uap_event(struct mwifiex_private *priv)
 		dev_dbg(adapter->dev, "event: TX_STATUS Report\n");
 		mwifiex_parse_tx_status_event(priv, adapter->event_body);
 		break;
+	case EVENT_PS_SLEEP:
+		dev_dbg(adapter->dev, "info: EVENT: SLEEP\n");
+
+		adapter->ps_state = PS_STATE_PRE_SLEEP;
+
+		mwifiex_check_ps_cond(adapter);
+		break;
+
+	case EVENT_PS_AWAKE:
+		dev_dbg(adapter->dev, "info: EVENT: AWAKE\n");
+		if (!adapter->pps_uapsd_mode &&
+		    priv->media_connected && adapter->sleep_period.period) {
+				adapter->pps_uapsd_mode = true;
+				dev_dbg(adapter->dev,
+					"event: PPS/UAPSD mode activated\n");
+		}
+		adapter->tx_lock_flag = false;
+		if (adapter->pps_uapsd_mode && adapter->gen_null_pkt) {
+			if (mwifiex_check_last_packet_indication(priv)) {
+				if (adapter->data_sent) {
+					adapter->ps_state = PS_STATE_AWAKE;
+					adapter->pm_wakeup_card_req = false;
+					adapter->pm_wakeup_fw_try = false;
+					break;
+				}
+				if (!mwifiex_send_null_packet
+					(priv,
+					 MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET |
+					 MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET))
+						adapter->ps_state =
+							PS_STATE_SLEEP;
+					return 0;
+			}
+		}
+		adapter->ps_state = PS_STATE_AWAKE;
+		adapter->pm_wakeup_card_req = false;
+		adapter->pm_wakeup_fw_try = false;
+
+		break;
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
-- 
1.8.1.4

