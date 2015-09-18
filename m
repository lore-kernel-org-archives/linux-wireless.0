Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:3674 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbbIRH6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 03:58:43 -0400
Subject: [PATCH 1/2] ath10k: add a_sle32_to_cpu()
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 18 Sep 2015 10:58:35 +0300
Message-ID: <20150918075835.6983.66350.stgit@potku.adurom.net> (sfid-20150918_095846_352005_6BD39088)
In-Reply-To: <20150918075706.6983.11216.stgit@potku.adurom.net>
References: <20150918075706.6983.11216.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Copy a_sle32_to_cpu() from ath6kl so that we can easily handle signed __le32
values. This is needed in struct wmi_pdev_tpc_config_event.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.h |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 3e5a1591f772..95fdc723a996 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -73,6 +73,25 @@ struct wmi_cmd_hdr {
 #define HTC_PROTOCOL_VERSION    0x0002
 #define WMI_PROTOCOL_VERSION    0x0002
 
+/*
+ * There is no signed version of __le32, so for a temporary solution come
+ * up with our own version. The idea is from fs/ntfs/types.h.
+ *
+ * Use a_ prefix so that it doesn't conflict if we get proper support to
+ * linux/types.h.
+ */
+typedef __s32 __bitwise a_sle32;
+
+static inline a_sle32 a_cpu_to_sle32(s32 val)
+{
+	return (__force a_sle32) cpu_to_le32(val);
+}
+
+static inline s32 a_sle32_to_cpu(a_sle32 val)
+{
+	return le32_to_cpu((__force __le32) val);
+}
+
 enum wmi_service {
 	WMI_SERVICE_BEACON_OFFLOAD = 0,
 	WMI_SERVICE_SCAN_OFFLOAD,
@@ -3657,7 +3676,7 @@ struct wmi_pdev_tpc_config_event {
 	__le32 phy_mode;
 	__le32 twice_antenna_reduction;
 	__le32 twice_max_rd_power;
-	s32 twice_antenna_gain;
+	a_sle32 twice_antenna_gain;
 	__le32 power_limit;
 	__le32 rate_max;
 	__le32 num_tx_chain;

