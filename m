Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:45938 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752903AbdLMMvk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 07:51:40 -0500
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: [v5 3/8] rsi: add header file rsi_header
Date: Wed, 13 Dec 2017 18:12:52 +0530
Message-Id: <1513168977-2121-4-git-send-email-amitkarwar@gmail.com> (sfid-20171213_135145_571313_0F1D1796)
In-Reply-To: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

The common parameters used by wlan and bt modules are added
to a new header file "rsi_header.h" defined in '/include/linux'

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_main.h | 12 ++----------
 include/linux/rsi_header.h          | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 10 deletions(-)
 create mode 100644 include/linux/rsi_header.h

diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index ee469dc..ca02a4b 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/skbuff.h>
 #include <net/mac80211.h>
+#include <linux/rsi_header.h>
 
 struct rsi_sta {
 	struct ieee80211_sta *sta;
@@ -85,10 +86,6 @@ extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
 #define MGMT_HW_Q			10
 #define BEACON_HW_Q			11
 
-/* Queue information */
-#define RSI_COEX_Q			0x0
-#define RSI_WIFI_MGMT_Q                 0x4
-#define RSI_WIFI_DATA_Q                 0x5
 #define IEEE80211_MGMT_FRAME            0x00
 #define IEEE80211_CTL_FRAME             0x04
 
@@ -293,11 +290,6 @@ struct rsi_common {
 	struct ieee80211_vif *roc_vif;
 };
 
-enum host_intf {
-	RSI_HOST_INTF_SDIO = 0,
-	RSI_HOST_INTF_USB
-};
-
 struct eepromrw_info {
 	u32 offset;
 	u32 length;
@@ -322,7 +314,7 @@ struct rsi_hw {
 	struct device *device;
 	u8 sc_nvifs;
 
-	enum host_intf rsi_host_intf;
+	enum rsi_host_intf rsi_host_intf;
 	u16 block_size;
 	enum ps_state ps_state;
 	struct rsi_ps_info ps_info;
diff --git a/include/linux/rsi_header.h b/include/linux/rsi_header.h
new file mode 100644
index 0000000..16a447b
--- /dev/null
+++ b/include/linux/rsi_header.h
@@ -0,0 +1,34 @@
+/**
+ * Copyright (c) 2017 Redpine Signals Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __RSI_HEADER_H__
+#define __RSI_HEADER_H__
+
+/* HAL queue information */
+#define RSI_COEX_Q			0x0
+#define RSI_BT_Q			0x2
+#define RSI_WLAN_Q                      0x3
+#define RSI_WIFI_MGMT_Q                 0x4
+#define RSI_WIFI_DATA_Q                 0x5
+#define RSI_BT_MGMT_Q			0x6
+#define RSI_BT_DATA_Q			0x7
+
+enum rsi_host_intf {
+	RSI_HOST_INTF_SDIO = 0,
+	RSI_HOST_INTF_USB
+};
+
+#endif
-- 
2.7.4
