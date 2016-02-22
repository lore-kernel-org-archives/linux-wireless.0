Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:31635 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbcBVEoS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:44:18 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 05/10] staging: wilc1000: removes unnecessary variable of wilc_mac_cfg_t structure
Date: Mon, 22 Feb 2016 13:41:14 +0900
Message-ID: <1456116079-7161-5-git-send-email-leo.kim@atmel.com> (sfid-20160222_054420_966276_0B6422E8)
In-Reply-To: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
References: <1456116079-7161-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unnecessary variable of wilc_mac_cfg_t structure.
The variable is debug print function pointer.
Removes all what used this variable.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 56455f4..deff886 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -20,8 +20,6 @@
  ********************************************/
 
 struct wilc_mac_cfg {
-	wilc_debug_func dPrint;
-
 	int mac_status;
 	u8 mac_address[7];
 	u8 ip_address[5];
@@ -389,8 +387,6 @@ int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size)
 		ret = wilc_wlan_cfg_set_str(frame, offset, id, buf, size);
 	} else if (type == 4) {                 /* binary command */
 		ret = wilc_wlan_cfg_set_bin(frame, offset, id, buf, size);
-	} else {
-		g_mac.dPrint(N_ERR, "illegal id\n");
 	}
 
 	return ret;
@@ -481,8 +477,6 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 			}
 			i++;
 		} while (1);
-	} else {
-		g_mac.dPrint(N_ERR, "[CFG]: illegal type (%08x)\n", wid);
 	}
 
 	return ret;
@@ -540,6 +534,5 @@ int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 int wilc_wlan_cfg_init(wilc_debug_func func)
 {
 	memset((void *)&g_mac, 0, sizeof(struct wilc_mac_cfg));
-	g_mac.dPrint = func;
 	return 1;
 }
-- 
1.9.1

