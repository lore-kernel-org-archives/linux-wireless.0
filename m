Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55224 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaLBJuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 04:50:44 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Joe Perches <joe@perches.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH v2 05/10] wil6210: remove wil_to_pcie_dev()
Date: Tue, 2 Dec 2014 11:50:25 +0200
Message-ID: <1417513825-18468-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141202_105049_131039_1F0937DA)
In-Reply-To: <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1417513598-18304-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no need to obtain physical device through
wil->pdev->dev path, as it is done by this macro.
The same device already stored as wiphy's device, thus
wil_to_dev() returns the same device as wil_to_pcie_dev()

Remove unnecessary macros, this allows to drop dependency
by pci.h in the firmware download code.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/fw.c      | 1 -
 drivers/net/wireless/ath/wil6210/fw_inc.c  | 2 +-
 drivers/net/wireless/ath/wil6210/wil6210.h | 1 -
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw.c b/drivers/net/wireless/ath/wil6210/fw.c
index 8c6f3b0..93c5cc1 100644
--- a/drivers/net/wireless/ath/wil6210/fw.c
+++ b/drivers/net/wireless/ath/wil6210/fw.c
@@ -15,7 +15,6 @@
  */
 #include <linux/firmware.h>
 #include <linux/module.h>
-#include <linux/pci.h>
 #include <linux/crc32.h>
 #include "wil6210.h"
 #include "fw.h"
diff --git a/drivers/net/wireless/ath/wil6210/fw_inc.c b/drivers/net/wireless/ath/wil6210/fw_inc.c
index 44cb71f..2658455 100644
--- a/drivers/net/wireless/ath/wil6210/fw_inc.c
+++ b/drivers/net/wireless/ath/wil6210/fw_inc.c
@@ -471,7 +471,7 @@ int wil_request_firmware(struct wil6210_priv *wil, const char *name)
 	size_t sz;
 	const void *d;
 
-	rc = request_firmware(&fw, name, wil_to_pcie_dev(wil));
+	rc = request_firmware(&fw, name, wil_to_dev(wil));
 	if (rc) {
 		wil_err_fw(wil, "Failed to load firmware %s\n", name);
 		return rc;
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index f2f89e0..8c09700 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -469,7 +469,6 @@ struct wil6210_priv {
 #define wdev_to_wil(w) (struct wil6210_priv *)(wdev_priv(w))
 #define wil_to_ndev(i) (wil_to_wdev(i)->netdev)
 #define ndev_to_wil(n) (wdev_to_wil(n->ieee80211_ptr))
-#define wil_to_pcie_dev(i) (&i->pdev->dev)
 
 __printf(2, 3)
 void wil_dbg_trace(struct wil6210_priv *wil, const char *fmt, ...);
-- 
2.1.0

