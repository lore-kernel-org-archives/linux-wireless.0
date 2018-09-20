Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40738 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731675AbeITMGN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 08:06:13 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 10/29] staging: wilc1000: change return type to 'void' for wilc_wlan_cfg_indicate_rx()
Date: Thu, 20 Sep 2018 11:53:21 +0530
Message-ID: <1537424620-6982-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180920_082459_026382_4BBE1DD6)
In-Reply-To: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
References: <1537424620-6982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to use 'void' return type for wilc_wlan_cfg_indicate_rx(),
as its return value is not used in caller. The value set in
'rsp' argument is used to get the success status.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan_cfg.c | 8 ++------
 drivers/staging/wilc1000/wilc_wlan_cfg.h | 4 ++--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.c b/drivers/staging/wilc1000/wilc_wlan_cfg.c
index 4215763..42c64ed 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.c
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.c
@@ -502,10 +502,9 @@ int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size)
 	return ret;
 }
 
-int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
-			      struct wilc_cfg_rsp *rsp)
+void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
+			       struct wilc_cfg_rsp *rsp)
 {
-	int ret = 1;
 	u8 msg_type;
 	u8 msg_id;
 
@@ -547,11 +546,8 @@ int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
 	default:
 		rsp->type = 0;
 		rsp->seq_no = msg_id;
-		ret = 0;
 		break;
 	}
-
-	return ret;
 }
 
 int wilc_wlan_cfg_init(void)
diff --git a/drivers/staging/wilc1000/wilc_wlan_cfg.h b/drivers/staging/wilc1000/wilc_wlan_cfg.h
index 0c649d1..189e617 100644
--- a/drivers/staging/wilc1000/wilc_wlan_cfg.h
+++ b/drivers/staging/wilc1000/wilc_wlan_cfg.h
@@ -31,8 +31,8 @@ struct wilc;
 int wilc_wlan_cfg_set_wid(u8 *frame, u32 offset, u16 id, u8 *buf, int size);
 int wilc_wlan_cfg_get_wid(u8 *frame, u32 offset, u16 id);
 int wilc_wlan_cfg_get_wid_value(u16 wid, u8 *buffer, u32 buffer_size);
-int wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
-			      struct wilc_cfg_rsp *rsp);
+void wilc_wlan_cfg_indicate_rx(struct wilc *wilc, u8 *frame, int size,
+			       struct wilc_cfg_rsp *rsp);
 int wilc_wlan_cfg_init(void);
 
 #endif
-- 
2.7.4
