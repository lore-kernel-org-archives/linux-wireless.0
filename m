Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:38035 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726747AbeHKCLz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 22:11:55 -0400
Received: by mail-pl0-f66.google.com with SMTP id u11-v6so4636406plq.5
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2018 16:39:53 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH] ath10k: retrieve MAC address from firmware if provided
Date: Fri, 10 Aug 2018 16:39:48 -0700
Message-Id: <20180810233948.144792-1-briannorris@chromium.org> (sfid-20180811_014032_284879_AA3E48D7)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices may provide their own MAC address via system firmware (e.g.,
device tree), especially in the case where the device doesn't have a
useful EEPROM on which to store its MAC address (e.g., for integrated
Wifi).

Use the generic device helper to retrieve the MAC address, and (if
present) honor it above the MAC address advertised by the card.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 3 +++
 drivers/net/wireless/ath/ath10k/wmi.c  | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c40cd129afe7..840c1f039098 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/firmware.h>
 #include <linux/of.h>
+#include <linux/property.h>
 #include <linux/dmi.h>
 #include <linux/ctype.h>
 #include <asm/byteorder.h>
@@ -2602,6 +2603,8 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		ath10k_debug_print_board_info(ar);
 	}
 
+	device_get_mac_address(ar->dev, ar->mac_addr, sizeof(ar->mac_addr));
+
 	ret = ath10k_core_init_firmware_features(ar);
 	if (ret) {
 		ath10k_err(ar, "fatal problem with firmware features: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index fd612d2905b0..3cfd98de8ad2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5449,7 +5449,8 @@ int ath10k_wmi_event_ready(struct ath10k *ar, struct sk_buff *skb)
 		   arg.mac_addr,
 		   __le32_to_cpu(arg.status));
 
-	ether_addr_copy(ar->mac_addr, arg.mac_addr);
+	if (is_zero_ether_addr(ar->mac_addr))
+		ether_addr_copy(ar->mac_addr, arg.mac_addr);
 	complete(&ar->wmi.unified_ready);
 	return 0;
 }
-- 
2.18.0.597.ga71716f1ad-goog
