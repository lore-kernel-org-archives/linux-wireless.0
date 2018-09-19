Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:2337 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730911AbeISLm3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 07:42:29 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/29] staging: wilc1000: refactor wilc_wlan_parse_info_frame() function
Date: Wed, 19 Sep 2018 11:35:01 +0530
Message-ID: <1537337119-14952-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180919_080611_675189_C9284D6F)
In-Reply-To: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
References: <1537337119-14952-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return 'void' from wilc_wlan_parse_info_frame() as same constant value
is returned always. Also removed the 'size' from input parameter as its
not used in the function.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 42c64ed..2b5471b 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -350,22 +350,17 @@ static void wilc_wlan_parse_response_frame(u8 *info, int size)
 	}
 }
 
-static int wilc_wlan_parse_info_frame(u8 *info, int size)
+static void wilc_wlan_parse_info_frame(u8 *info)
 {
 	struct wilc_mac_cfg *pd = &g_mac;
 	u32 wid, len;
-	int type = WILC_CFG_RSP_STATUS;
 
 	wid = info[0] | (info[1] << 8);
 
 	len = info[2];
 
-	if (len == 1 && wid == WID_STATUS) {
+	if (len == 1 && wid == WID_STATUS)
 		pd->mac_status = info[3];
-		type = WILC_CFG_RSP_STATUS;
-	}
-
-	return type;
 }
 
 /********************************************
@@ -528,7 +523,8 @@ void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 		break;
 
 	case 'I':
-		rsp->type = wilc_wlan_parse_info_frame(frame, size);
+		wilc_wlan_parse_info_frame(frame);
+		rsp->type = WILC_CFG_RSP_STATUS;
 		rsp->seq_no = msg_id;
 		/*call host interface info parse as well*/
 		wilc_gnrl_async_info_received(wilc, frame - 4, size + 4);
-- 
2.7.4
