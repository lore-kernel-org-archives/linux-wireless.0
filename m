Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:36177 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756234AbdETUeB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 May 2017 16:34:01 -0400
Received: by mail-lf0-f67.google.com with SMTP id h4so2393475lfj.3
        for <linux-wireless@vger.kernel.org>; Sat, 20 May 2017 13:33:59 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 1/3] ath10k: various usb related definitions
Date: Sat, 20 May 2017 22:33:28 +0200
Message-Id: <1495312410-9937-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20170520_223412_431530_C4031B79)
In-Reply-To: <1495312410-9937-1-git-send-email-erik.stromdahl@gmail.com>
References: <1495312410-9937-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Definitions for USB based chipsets

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.h  | 3 +++
 drivers/net/wireless/ath/ath10k/debug.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 8fc08a5..1efe0a1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -92,6 +92,7 @@ enum ath10k_bus {
 	ATH10K_BUS_PCI,
 	ATH10K_BUS_AHB,
 	ATH10K_BUS_SDIO,
+	ATH10K_BUS_USB,
 };
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -103,6 +104,8 @@ static inline const char *ath10k_bus_str(enum ath10k_bus bus)
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
