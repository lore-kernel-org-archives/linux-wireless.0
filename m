Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6134 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbbGEIqN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 04:46:13 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 07/13] wil6210: wait for del_station to complete
Date: Sun,  5 Jul 2015 10:24:34 +0300
Message-Id: <1436081080-27305-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150705_104642_874071_A5A9CB6C)
In-Reply-To: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
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
index 12b5770..0678fff 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -1151,15 +1151,42 @@ int wmi_get_temperature(struct wil6210_priv *wil, u32 *t_bb, u32 *t_rf)
 
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

