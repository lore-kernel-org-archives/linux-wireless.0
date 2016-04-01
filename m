Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:15616 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcDAIrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 04:47:42 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 5/7] staging: wilc1000: add set to null after release firmware
Date: Fri, 1 Apr 2016 17:44:17 +0900
Message-ID: <1459500259-27873-5-git-send-email-leo.kim@atmel.com> (sfid-20160401_104747_221495_F0F45D76)
In-Reply-To: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
References: <1459500259-27873-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch add set to null after release firmware.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 47c0132..48bbfa2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1234,8 +1234,10 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 			vif[i] = netdev_priv(wilc->vif[i]->ndev);
 	}
 
-	if (wilc && wilc->firmware)
+	if (wilc && wilc->firmware) {
 		release_firmware(wilc->firmware);
+		wilc->firmware = NULL;
+	}
 
 	if (wilc && (wilc->vif[0]->ndev || wilc->vif[1]->ndev)) {
 		wilc_lock_timeout(wilc, &close_exit_sync, 5 * 1000);
-- 
1.9.1

