Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12405 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbeITMGV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:06:21 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 12/29] staging: wilc1000: set default value of cfg response type in wilc_wlan_cfg_indicate_rx()
Date: Thu, 20 Sep 2018 11:53:23 +0530
Message-ID: <1537424620-6982-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082501_028977_82EF2212)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle the setting of default value for 'wilc_cfg_rsp' type for all
cases in wilc_wlan_cfg_indicate_rx() as the caller make use of this
value to know the type of the received message.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 2b5471b..2c463a3 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -507,6 +507,7 @@ void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 	msg_id = frame[1];      /* seq no */
 	frame += 4;
 	size -= 4;
+	rsp->type = 0;
 
 	/*
 	 * The valid types of response messages are
@@ -532,7 +533,6 @@ void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 
 	case 'N':
 		wilc_network_info_received(wilc, frame - 4, size + 4);
-		rsp->type = 0;
 		break;
 
 	case 'S':
@@ -540,7 +540,6 @@ void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 		break;
 
 	default:
-		rsp->type = 0;
 		rsp->seq_no = msg_id;
 		break;
 	}
-- 
2.7.4
