Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753114AbeBSPaV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:21 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/14] staging: wilc1000: rename pstrHostIfRemainOnChan to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:34 +0530
Message-ID: <1519054184-14301-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163028_775906_D832A0FB)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index ec98ccd..11e4737 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2221,7 +2221,7 @@ static void Handle_EditStation(struct wilc_vif *vif,
 }
 
 static int Handle_RemainOnChan(struct wilc_vif *vif,
-			       struct remain_ch *pstrHostIfRemainOnChan)
+			       struct remain_ch *hif_remain_ch)
 {
 	s32 result = 0;
 	u8 u8remain_on_chan_flag;
@@ -2229,13 +2229,13 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 	struct host_if_drv *hif_drv = vif->hif_drv;
 
 	if (!hif_drv->remain_on_ch_pending) {
-		hif_drv->remain_on_ch.arg = pstrHostIfRemainOnChan->arg;
-		hif_drv->remain_on_ch.expired = pstrHostIfRemainOnChan->expired;
-		hif_drv->remain_on_ch.ready = pstrHostIfRemainOnChan->ready;
-		hif_drv->remain_on_ch.ch = pstrHostIfRemainOnChan->ch;
-		hif_drv->remain_on_ch.id = pstrHostIfRemainOnChan->id;
+		hif_drv->remain_on_ch.arg = hif_remain_ch->arg;
+		hif_drv->remain_on_ch.expired = hif_remain_ch->expired;
+		hif_drv->remain_on_ch.ready = hif_remain_ch->ready;
+		hif_drv->remain_on_ch.ch = hif_remain_ch->ch;
+		hif_drv->remain_on_ch.id = hif_remain_ch->id;
 	} else {
-		pstrHostIfRemainOnChan->ch = hif_drv->remain_on_ch.ch;
+		hif_remain_ch->ch = hif_drv->remain_on_ch.ch;
 	}
 
 	if (hif_drv->usr_scan_req.scan_result) {
@@ -2264,7 +2264,7 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 	}
 
 	wid.val[0] = u8remain_on_chan_flag;
-	wid.val[1] = (s8)pstrHostIfRemainOnChan->ch;
+	wid.val[1] = (s8)hif_remain_ch->ch;
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
 				      wilc_get_vif_idx(vif));
@@ -2277,7 +2277,7 @@ static int Handle_RemainOnChan(struct wilc_vif *vif,
 		hif_drv->remain_on_ch_timer_vif = vif;
 		mod_timer(&hif_drv->remain_on_ch_timer,
 			  jiffies +
-			  msecs_to_jiffies(pstrHostIfRemainOnChan->duration));
+			  msecs_to_jiffies(hif_remain_ch->duration));
 
 		if (hif_drv->remain_on_ch.ready)
 			hif_drv->remain_on_ch.ready(hif_drv->remain_on_ch.arg);
@@ -2321,7 +2321,7 @@ static int Handle_RegisterFrame(struct wilc_vif *vif,
 }
 
 static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
-				     struct remain_ch *pstrHostIfRemainOnChan)
+				     struct remain_ch *hif_remain_ch)
 {
 	u8 u8remain_on_chan_flag;
 	struct wid wid;
@@ -2350,7 +2350,7 @@ static u32 Handle_ListenStateExpired(struct wilc_vif *vif,
 
 		if (hif_drv->remain_on_ch.expired) {
 			hif_drv->remain_on_ch.expired(hif_drv->remain_on_ch.arg,
-						      pstrHostIfRemainOnChan->id);
+						      hif_remain_ch->id);
 		}
 		P2P_LISTEN_STATE = 0;
 	} else {
-- 
2.7.4
