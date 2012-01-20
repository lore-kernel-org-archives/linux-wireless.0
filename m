Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17765 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2ATNh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 08:37:29 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 7/8] ath6kl: Add a support to handle the host sleep mode cmd processed event
Date: Fri, 20 Jan 2012 19:05:43 +0530
Message-ID: <1327066544-23779-8-git-send-email-rmani@qca.qualcomm.com> (sfid-20120120_143732_912719_98B52707)
In-Reply-To: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com>
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

For every WMI_SET_HOST_SLEEP_MODE_CMDID command (send from the host),
the firmware sends WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID as
an acknowledgement to the host.

In order to being sync with the firmware, the host has to wait for
this event before going to the suspend state.

This patch adds,
 * New command WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID in
   WMI event table.
 * New WMI function ath6kl_wmi_host_sleep_mode_cmd_prcd_evt_rx()
   to process the event.
 * New flag HOST_SLEEP_MODE_CMD_PROCESSED in VIF flags to record
   the arrival of the event.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/wmi.c  |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h  |    2 ++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 1ddff66..b62cff9 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -445,6 +445,7 @@ enum ath6kl_vif_state {
 	DTIM_PERIOD_AVAIL,
 	WLAN_ENABLED,
 	STATS_UPDATE_PEND,
+	HOST_SLEEP_MODE_CMD_PROCESSED,
 };
 
 struct ath6kl_vif {
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 9c8e4df..18fa9aa 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -2590,6 +2590,18 @@ int ath6kl_wmi_set_host_sleep_mode_cmd(struct wmi *wmi, u8 if_idx,
 	return ret;
 }
 
+/* This command has zero length payload */
+static int ath6kl_wmi_host_sleep_mode_cmd_prcd_evt_rx(struct wmi *wmi,
+						      struct ath6kl_vif *vif)
+{
+	struct ath6kl *ar = wmi->parent_dev;
+
+	set_bit(HOST_SLEEP_MODE_CMD_PROCESSED, &vif->flags);
+	wake_up(&ar->event_wq);
+
+	return 0;
+}
+
 int ath6kl_wmi_set_wow_mode_cmd(struct wmi *wmi, u8 if_idx,
 				enum ath6kl_wow_mode wow_mode,
 				u32 filter, u16 host_req_delay)
@@ -3556,6 +3568,11 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TX_COMPLETE_EVENTID\n");
 		ret = ath6kl_wmi_tx_complete_event_rx(datap, len);
 		break;
+	case WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID");
+		ret = ath6kl_wmi_host_sleep_mode_cmd_prcd_evt_rx(wmi, vif);
+		break;
 	case WMI_REMAIN_ON_CHNL_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REMAIN_ON_CHNL_EVENTID\n");
 		ret = ath6kl_wmi_remain_on_chnl_event_rx(wmi, datap, len, vif);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 85698ef..e791986 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1357,6 +1357,8 @@ enum wmi_event_id {
 	WMI_P2P_START_SDPD_EVENTID,
 	WMI_P2P_SDPD_RX_EVENTID,
 
+	WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID = 0x1047,
+
 	WMI_THIN_RESERVED_START_EVENTID = 0x8000,
 	/* Events in this range are reserved for thinmode */
 	WMI_THIN_RESERVED_END_EVENTID = 0x8fff,
-- 
1.7.1

