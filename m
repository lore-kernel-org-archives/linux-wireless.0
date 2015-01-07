Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38321 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbAGPEQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 10:04:16 -0500
Subject: [PATCH v2] ath10k: fix build error when hwmon is off
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 7 Jan 2015 17:04:10 +0200
Message-ID: <20150107150410.17433.49263.stgit@potku.adurom.net> (sfid-20150107_160419_222779_7D5C5BC9)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild reported a linking error:

ERROR: "devm_hwmon_device_register_with_groups"
[drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!

Fix it by returning early and letting the compiler to optimise out the function
call.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/thermal.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.c b/drivers/net/wireless/ath/ath10k/thermal.c
index d93913538d18..b14ae8d135f6 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.c
+++ b/drivers/net/wireless/ath/ath10k/thermal.c
@@ -213,6 +213,11 @@ int ath10k_thermal_register(struct ath10k *ar)
 	if (ar->wmi.op_version != ATH10K_FW_WMI_OP_VERSION_10_2_4)
 		return 0;
 
+	/* Avoid linking error on devm_hwmon_device_register_with_groups, I
+	 * guess linux/hwmon.h is missing proper stubs. */
+	if (!config_enabled(HWMON))
+		return 0;
+
 	hwmon_dev = devm_hwmon_device_register_with_groups(ar->dev,
 							   "ath10k_hwmon", ar,
 							   ath10k_hwmon_groups);

