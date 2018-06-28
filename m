Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-blr-02.qualcomm.com ([103.229.18.198]:42510 "EHLO
        alexa-out-blr.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935097AbeF1JZZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:25:25 -0400
From: Rakesh Pillai <pillair@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Disable bundle mgmt tx completion event support
Date: Thu, 28 Jun 2018 14:48:56 +0530
Message-Id: <1530177537-18487-2-git-send-email-pillair@codeaurora.org> (sfid-20180628_112529_977343_FF257A97)
In-Reply-To: <1530177537-18487-1-git-send-email-pillair@codeaurora.org>
References: <1530177537-18487-1-git-send-email-pillair@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Surabhi Vishnoi <svishnoi@codeaurora.org>

The tx completion of multiple mgmt frames can be bundled
in a single event and sent by the firmware to host, if this
capability is not disabled explicitly by the host. If the host
cannot handle the bundled mgmt tx completion, this capability
support needs to be disabled in the wmi init cmd, sent to the firmware.

Add the host capability indication flag in the wmi ready command,
to let firmware know the features supported by the host driver.
This field is ignored if it is not supported by firmware.

Set the host capability indication flag(i.e. host_capab) to zero,
for disabling the support of bundle mgmt tx completion. This will
indicate the firmware to send completion event for every mgmt tx
completion, instead of bundling them together and sending in a single
event.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 5 +++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 8c49a26..21eb3a5 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1584,6 +1584,11 @@ static struct sk_buff *ath10k_wmi_tlv_op_gen_init(struct ath10k *ar)
 	cfg->keep_alive_pattern_size = __cpu_to_le32(0);
 	cfg->max_tdls_concurrent_sleep_sta = __cpu_to_le32(1);
 	cfg->max_tdls_concurrent_buffer_sta = __cpu_to_le32(1);
+	cfg->wmi_send_separate = __cpu_to_le32(0);
+	cfg->num_ocb_vdevs = __cpu_to_le32(0);
+	cfg->num_ocb_channels = __cpu_to_le32(0);
+	cfg->num_ocb_schedules = __cpu_to_le32(0);
+	cfg->host_capab = __cpu_to_le32(0);
 
 	ath10k_wmi_put_host_mem_chunks(ar, chunks);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 3e1e340..1cb93d0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1670,6 +1670,11 @@ struct wmi_tlv_resource_config {
 	__le32 keep_alive_pattern_size;
 	__le32 max_tdls_concurrent_sleep_sta;
 	__le32 max_tdls_concurrent_buffer_sta;
+	__le32 wmi_send_separate;
+	__le32 num_ocb_vdevs;
+	__le32 num_ocb_channels;
+	__le32 num_ocb_schedules;
+	__le32 host_capab;
 } __packed;
 
 struct wmi_tlv_init_cmd {
-- 
2.7.4
