Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:33404 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbcESDyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2016 23:54:01 -0400
Received: by mail-pf0-f169.google.com with SMTP id 206so25577105pfu.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2016 20:54:01 -0700 (PDT)
From: Wei-Ning Huang <wnhuang@chromium.org>
To: Linux-Wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akarwar@marvell.com,
	djkurtz@chromium.org, Wei-Ning Huang <wnhuang@chromium.org>
Subject: [PATCH] mwifiex: fix racing condition when downloading firmware
Date: Thu, 19 May 2016 11:53:43 +0800
Message-Id: <1463630023-5258-1-git-send-email-wnhuang@chromium.org> (sfid-20160519_055425_677909_925BA5B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The action 'check for winner' and 'download firmware' should be an
atomic action. This is true for btmrvl driver but not mwmfiex, which
cause firmware download to fail when the following senerio happens:

1) mwifiex check winner status: true
2) btmrvl check winner status: true, and start downloading firmware
3) mwfieix tries to download firmware, but failed because btmrvl is
already downloading.

This won't happen if 1) and 3) is an atomic action. This patch adds
sdio_claim/release_host call around those two actions to make sure it's
atomic.

Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 8b67a55..2b65334 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -21,6 +21,7 @@
 #include "wmm.h"
 #include "cfg80211.h"
 #include "11n.h"
+#include "sdio.h"
 
 #define VERSION	"1.0"
 
@@ -514,6 +515,7 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	struct semaphore *sem = adapter->card_sem;
 	bool init_failed = false;
 	struct wireless_dev *wdev;
+	struct sdio_mmc_card *card = adapter->card;
 
 	if (!firmware) {
 		mwifiex_dbg(adapter, ERROR,
@@ -526,10 +528,16 @@ static void mwifiex_fw_dpc(const struct firmware *firmware, void *context)
 	fw.fw_buf = (u8 *) adapter->firmware->data;
 	fw.fw_len = adapter->firmware->size;
 
-	if (adapter->if_ops.dnld_fw)
+	if (adapter->if_ops.dnld_fw) {
 		ret = adapter->if_ops.dnld_fw(adapter, &fw);
-	else
+	} else {
+		if (adapter->iface_type == MWIFIEX_SDIO)
+			sdio_claim_host(card->func);
 		ret = mwifiex_dnld_fw(adapter, &fw);
+		if (adapter->iface_type == MWIFIEX_SDIO)
+			sdio_release_host(card->func);
+	}
+
 	if (ret == -1)
 		goto err_dnld_fw;
 
-- 
2.1.2

