Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36497 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbbG3Kyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:43 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 05/19] wil6210: wait for del_station to complete
Date: Thu, 30 Jul 2015 13:51:53 +0300
Message-Id: <1438253527-3372-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_130715_713198_FAB384BF)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multiple del_station requests may be sent to the driver by the
supplicant when turning down AP. This may overflow mailbox
between the FW and ucode

Wait till disconnect of one STA completed before sending next command.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index c759759..362ce7a 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1129,15 +1129,42 @@ int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_bb, u32 *t_rf)
 
 int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason)
 {
+	int rc;
+	u16 reason_code;
 	struct wmi_disconnect_sta_cmd cmd = {
 		.disconnect_reason = cpu_to_le16(reason),
 	};
+	struct {
+		struct wil6210_mbox_hdr_wmi wmi;
+		struct wmi_disconnect_event evt;
+	} __packed reply;
 
 	ether_addr_copy(cmd.dst_mac, mac);
 
 	wil_dbg_wmi(wil, "%s(%pM, reason %d)\n", __func__, mac, reason);
 
-	return wmi_send(wil, WMI_DISCONNECT_STA_CMDID, &cmd, sizeof(cmd));
+	rc = wmi_call(wil, WMI_DISCONNECT_STA_CMDID, &cmd, sizeof(cmd),
+		      WMI_DISCONNECT_EVENTID, &reply, sizeof(reply), 1000);
+	/* failure to disconnect in reasonable time treated as FW error */
+	if (rc) {
+		wil_fw_error_recovery(wil);
+		return rc;
+	}
+
+	/* call event handler manually after processing wmi_call,
+	 * to avoid deadlock - disconnect event handler acquires wil->mutex
+	 * while it is already held here
+	 */
+	reason_code = le16_to_cpu(reply.evt.protocol_reason_status);
+
+	wil_dbg_wmi(wil, "Disconnect %pM reason [proto %d wmi %d]\n",
+		    reply.evt.bssid, reason_code,
+		    reply.evt.disconnect_reason);
+
+	wil->sinfo_gen++;
+	wil6210_disconnect(wil, reply.evt.bssid, reason_code, true);
+
+	return 0;
 }
 
 int wmi_addba(struct wil6210_priv *wil, u8 ringid, u8 size, u16 timeout)
-- 
2.1.4

