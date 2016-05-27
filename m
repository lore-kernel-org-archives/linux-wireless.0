Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:32828 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbcE0M1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 08:27:47 -0400
Received: by mail-pf0-f179.google.com with SMTP id b124so41565547pfb.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2016 05:27:47 -0700 (PDT)
From: Wei-Ning Huang <wnhuang@chromium.org>
To: Linux-Wireless <linux-wireless@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akarwar@marvell.com,
	djkurtz@chromium.org, Wei-Ning Huang <wnhuang@chromium.org>
Subject: [PATCH v2] mwifiex: fix race condition when downloading firmware
Date: Fri, 27 May 2016 20:27:38 +0800
Message-Id: <1464352059-13923-1-git-send-email-wnhuang@chromium.org> (sfid-20160527_142807_806895_D88750B6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The action 'check for winner' and 'download firmware' should be an
atomic action. This is true for btmrvl driver but not mwmfiex, which
cause firmware download to fail when the following scenario happens:

1) mwifiex check winner status: true
2) btmrvl check winner status: true, and start downloading firmware
3) mwifiex tries to download firmware, but failed because btmrvl is
already downloading.

This won't happen if 1) and 3) is an atomic action. This patch adds
sdio_claim/release_host call around those two actions to make sure it's
atomic.

Signed-off-by: Wei-Ning Huang <wnhuang@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/init.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/init.c b/drivers/net/wireless/marvell/mwifiex/init.c
index 78c532f..7703438 100644
--- a/drivers/net/wireless/marvell/mwifiex/init.c
+++ b/drivers/net/wireless/marvell/mwifiex/init.c
@@ -24,6 +24,7 @@
 #include "main.h"
 #include "wmm.h"
 #include "11n.h"
+#include "sdio.h"
 
 /*
  * This function adds a BSS priority table to the table list.
@@ -737,16 +738,20 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		    struct mwifiex_fw_image *pmfw)
 {
+	struct sdio_mmc_card *card = adapter->card;
 	int ret;
 	u32 poll_num = 1;
 
+	if (adapter->iface_type == MWIFIEX_SDIO)
+		sdio_claim_host(card->func);
+
 	if (adapter->if_ops.check_fw_status) {
 		/* check if firmware is already running */
 		ret = adapter->if_ops.check_fw_status(adapter, poll_num);
 		if (!ret) {
 			mwifiex_dbg(adapter, MSG,
 				    "WLAN FW already running! Skip FW dnld\n");
-			return 0;
+			goto release_host;
 		}
 	}
 
@@ -759,7 +764,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		if (ret) {
 			mwifiex_dbg(adapter, MSG,
 				    "WLAN read winner status failed!\n");
-			return ret;
+			goto release_host;
 		}
 
 		if (!adapter->winner) {
@@ -775,7 +780,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
 		if (ret) {
 			mwifiex_dbg(adapter, ERROR,
 				    "prog_fw failed ret=%#x\n", ret);
-			return ret;
+			goto release_host;
 		}
 	}
 
@@ -785,6 +790,9 @@ poll_fw:
 	if (ret)
 		mwifiex_dbg(adapter, ERROR,
 			    "FW failed to be active in time\n");
+release_host:
+	if (adapter->iface_type == MWIFIEX_SDIO)
+		sdio_release_host(card->func);
 
 	return ret;
 }
-- 
2.1.2

