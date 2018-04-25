Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:28418 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755823AbeDYRUK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:20:10 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 18/21] staging: wilc1000: rename P2P_LISTEN_STATE variable to use lowercase
Date: Wed, 25 Apr 2018 22:48:23 +0530
Message-ID: <1524676706-13179-19-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_192014_117454_EB2CFD31)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename P2P_LISTEN_STATE variable to avoid using uppercase for variable
name to follow linux coding style.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 758dc44..6eafb98 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -229,7 +229,7 @@ struct join_bss_param {
 
 static struct host_if_drv *terminated_handle;
 bool wilc_optaining_ip;
-static u8 P2P_LISTEN_STATE;
+static u8 p2p_listen_state;
 static struct workqueue_struct *hif_workqueue;
 static struct completion hif_thread_comp;
 static struct completion hif_driver_comp;
@@ -2245,7 +2245,7 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 
 error:
 	{
-		P2P_LISTEN_STATE = 1;
+		p2p_listen_state = 1;
 		hif_drv->remain_on_ch_timer_vif = vif;
 		mod_timer(&hif_drv->remain_on_ch_timer,
 			  jiffies +
@@ -2301,7 +2301,7 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 	s32 result = 0;
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
-	if (P2P_LISTEN_STATE) {
+	if (p2p_listen_state) {
 		remain_on_chan_flag = false;
 		wid.id = (u16)WID_REMAIN_ON_CHAN;
 		wid.type = WID_STR;
@@ -2326,7 +2326,7 @@ static u32 handle_listen_state_expired(struct wilc_vif *vif,
 			hif_drv->remain_on_ch.expired(hif_drv->remain_on_ch.arg,
 						      hif_remain_ch->id);
 		}
-		P2P_LISTEN_STATE = 0;
+		p2p_listen_state = 0;
 	} else {
 		netdev_dbg(vif->ndev, "Not in listen state\n");
 		result = -EFAULT;
-- 
2.7.4
