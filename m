Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44594 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbbGaHlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:41:42 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <austin.shin@atmel.com>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 25/28] staging: wilc1000: change cast type from pointer to uintptr_t
Date: Fri, 31 Jul 2015 16:38:33 +0900
Message-ID: <1438328316-30197-26-git-send-email-tony.cho@atmel.com> (sfid-20150731_100715_753306_62E5C05A)
In-Reply-To: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
References: <1438328316-30197-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: glen lee <glen.lee@atmel.com>

To use drvHandler as integer operation, cast type to uintptr_t.

Here is the build warning.
drivers/staging/wilc1000/wilc_wlan.c:1871:23: warning: cast from pointer to
integer of different size [-Wpointer-to-int-cast]
  int driver_handler = (u32)drvHandler;

Signed-off-by: glen lee <glen.lee@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 drivers/staging/wilc1000/wilc_wlan.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index ec80849..14c2071 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1056,7 +1056,7 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 		goto _fail_;
 	}
 
-	*(int *)c_val = (u32)pstrWFIDrv;
+	*(int *)c_val = (uintptr_t)pstrWFIDrv;
 
 	if (!g_linux_wlan->oup.wlan_cfg_set(1, WID_SET_DRV_HANDLER, c_val, 4, 0, 0))
 		goto _fail_;
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f5075b26..2cc23d5 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1868,7 +1868,7 @@ static int wilc_wlan_cfg_commit(int type, WILC_WFIDrvHandle drvHandler)
 	wilc_cfg_frame_t *cfg = &p->cfg_frame;
 	int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
 	int seq_no = p->cfg_seq_no % 256;
-	int driver_handler = (u32)drvHandler;
+	int driver_handler = (uintptr_t)drvHandler;
 
 
 	/**
-- 
1.9.1

