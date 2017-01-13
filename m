Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33544 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdAMVfZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:35:25 -0500
Received: by mail-lf0-f68.google.com with SMTP id x1so1724451lff.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 13:35:24 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 01/10] ath10k: various usb related definitions
Date: Fri, 13 Jan 2017 22:35:00 +0100
Message-Id: <1484343309-6327-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20170113_223544_625719_4E394082)
In-Reply-To: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
References: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Definitions for USB based chipsets

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.h  | 3 +++
 drivers/net/wireless/ath/ath10k/debug.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 1ffef90..3f865c0 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -75,6 +75,7 @@ enum ath10k_bus {
 	ATH10K_BUS_PCI,
 	ATH10K_BUS_AHB,
 	ATH10K_BUS_SDIO,
+	ATH10K_BUS_USB,
 };
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -86,6 +87,8 @@ static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 		return "ahb";
 	case ATH10K_BUS_SDIO:
 		return "sdio";
+	case ATH10K_BUS_USB:
+		return "usb";
 	}
 
 	return "unknown";
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 257d109..548ad54 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -40,6 +40,8 @@ enum ath10k_debug_mask {
 	ATH10K_DBG_AHB		= 0x00008000,
 	ATH10K_DBG_SDIO		= 0x00010000,
 	ATH10K_DBG_SDIO_DUMP	= 0x00020000,
+	ATH10K_DBG_USB		= 0x00040000,
+	ATH10K_DBG_USB_BULK	= 0x00080000,
 	ATH10K_DBG_ANY		= 0xffffffff,
 };
 
-- 
2.7.4
