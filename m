Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:54391 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbbJ2IxQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 04:53:16 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH] ath10k: Add thermal throttling support for 10.4 firmware.
Date: Thu, 29 Oct 2015 14:23:44 +0530
Message-ID: <1446108824-4675-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20151029_095324_189208_E6DBBBCC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch enables thermal throttling support for 10.4 firmware.

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c     |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index 60fe562..444b52c 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -187,7 +187,7 @@ int ath10k_thermal_register(struct ath10k *ar)
 	/* Do not register hwmon device when temperature reading is not
 	 * supported by firmware
 	 */
-	if (ar->wmi.op_version != ATH10K_FW_WMI_OP_VERSION_10_2_4)
+	if (!(ar->wmi.ops->gen_pdev_get_temperature))
 		return 0;
 
 	/* Avoid linking error on devm_hwmon_device_register_with_groups, I
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2b32f02..3e45770 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4935,6 +4935,9 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "received event id %d not implemented\n", id);
 		break;
+	case WMI_10_4_PDEV_TEMPERATURE_EVENTID:
+		ath10k_wmi_event_temperature(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -7344,6 +7347,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 
 	/* shared with 10.2 */
 	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
+	.gen_pdev_get_temperature = ath10k_wmi_10_2_op_gen_pdev_get_temperature,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
1.7.9.5

