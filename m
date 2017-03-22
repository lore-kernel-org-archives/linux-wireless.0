Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:58167 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934716AbdCVT0G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Mar 2017 15:26:06 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] NFC: Add nfc_dbg() macro
Date: Wed, 22 Mar 2017 21:22:51 +0200
Message-Id: <20170322192251.30261-1-andriy.shevchenko@linux.intel.com> (sfid-20170322_202918_080129_FCF78419)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases nfc_dbg() is useful. Add such macro to a header.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/net/nfc/nfc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 1a3de8b34ad2..bbdc73a3239d 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -27,6 +27,7 @@
 #include <linux/device.h>
 #include <linux/skbuff.h>
 
+#define nfc_dbg(dev, fmt, ...) dev_dbg((dev), "NFC: " fmt, ##__VA_ARGS__)
 #define nfc_info(dev, fmt, ...) dev_info((dev), "NFC: " fmt, ##__VA_ARGS__)
 #define nfc_err(dev, fmt, ...) dev_err((dev), "NFC: " fmt, ##__VA_ARGS__)
 
-- 
2.11.0
