Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:57944 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbeHNJha (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:37:30 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 24/24] staging: wilc1000: remove unnecessary static variable 'p2p_listen_state'
Date: Tue, 14 Aug 2018 12:20:16 +0530
Message-ID: <1534229416-13254-25-git-send-email-ajay.kathat@microchip.com> (sfid-20180814_085144_100235_6727E740)
In-Reply-To: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
References: <1534229416-13254-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the use of unnecessary static variable 'p2p_listen_state'.
Already 'p2p_listen_state' is present in 'wilc_priv' struct. So making
use of that variable as its getting set in channel ready and
remain on channel expired callback.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d8cc08b..cf7ead5 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -185,8 +185,6 @@ struct join_bss_param {
 	u8 start_time[4];
 };
 
-static u8 p2p_listen_state;
-
 /* 'msg' should be free by the caller for syc */
 static struct host_if_msg*
 wilc_alloc_work(struct wilc_vif *vif, void (*work_fun)(struct work_struct *),
@@ -2351,7 +2349,6 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to set remain on channel\n");
 
 error:
-	p2p_listen_state = 1;
 	hif_drv->remain_on_ch_timer_vif = vif;
 	mod_timer(&hif_drv->remain_on_ch_timer,
 		  jiffies + msecs_to_jiffies(hif_remain_ch->duration));
@@ -2407,8 +2404,9 @@ static void handle_listen_state_expired(struct work_struct *work)
 	struct wid wid;
 	int result;
 	struct host_if_drv *hif_drv = vif->hif_drv;
+	struct wilc_priv *priv = wdev_priv(vif->ndev->ieee80211_ptr);
 
-	if (p2p_listen_state) {
+	if (priv->p2p_listen_state) {
 		remain_on_chan_flag = false;
 		wid.id = WID_REMAIN_ON_CHAN;
 		wid.type = WID_STR;
@@ -2433,7 +2431,6 @@ static void handle_listen_state_expired(struct work_struct *work)
 			hif_drv->remain_on_ch.expired(hif_drv->remain_on_ch.arg,
 						      hif_remain_ch->id);
 		}
-		p2p_listen_state = 0;
 	} else {
 		netdev_dbg(vif->ndev, "Not in listen state\n");
 	}
-- 
2.7.4
