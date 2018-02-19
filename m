Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753167AbeBSPaw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:52 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 13/14] staging: wilc1000: rename wilc_remove_key() parameters to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:43 +0530
Message-ID: <1519054184-14301-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163057_139801_E523D4B7)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 drivers/staging/wilc1000/host_interface.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 4cbfe3b..7ddd20d 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2674,13 +2674,13 @@ static void timer_connect_cb(struct timer_list *t)
 	wilc_enqueue_cmd(&msg);
 }
 
-s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *pu8StaAddress)
+s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *sta_addr)
 {
 	struct wid wid;
 
 	wid.id = (u16)WID_REMOVE_KEY;
 	wid.type = WID_STR;
-	wid.val = (s8 *)pu8StaAddress;
+	wid.val = (s8 *)sta_addr;
 	wid.size = 6;
 
 	return 0;
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index aa914d6..4b60b18 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -304,7 +304,7 @@ struct add_sta_param {
 };
 
 struct wilc_vif;
-s32 wilc_remove_key(struct host_if_drv *hWFIDrv, const u8 *pu8StaAddress);
+s32 wilc_remove_key(struct host_if_drv *hif_drv, const u8 *sta_addr);
 int wilc_remove_wep_key(struct wilc_vif *vif, u8 index);
 int wilc_set_wep_default_keyid(struct wilc_vif *vif, u8 index);
 int wilc_add_wep_key_bss_sta(struct wilc_vif *vif, const u8 *key, u8 len,
-- 
2.7.4
