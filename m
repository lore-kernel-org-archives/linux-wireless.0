Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12602 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727718AbeIDLEt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:49 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 23/26] staging: wilc1000: remove unnecessary static variable 'p2p_listen_state'
Date: Tue, 4 Sep 2018 12:09:39 +0530
Message-ID: <1536043182-19735-24-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084114_353377_A6DBC765)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
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
 drivers/staging/wilc1000/host_interface.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7805ec1..9d90994 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -187,7 +187,6 @@ struct join_bss_param {
 };
 
 static struct host_if_drv *terminated_handle;
-static u8 p2p_listen_state;
 static struct completion hif_driver_comp;
 static struct mutex hif_deinit_lock;
 
@@ -2355,7 +2354,6 @@ static int handle_remain_on_chan(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to set remain on channel\n");
 
 error:
-	p2p_listen_state = 1;
 	hif_drv->remain_on_ch_timer_vif = vif;
 	mod_timer(&hif_drv->remain_on_ch_timer,
 		  jiffies + msecs_to_jiffies(hif_remain_ch->duration));
@@ -2411,8 +2409,9 @@ static void handle_listen_state_expired(struct work_struct *work)
 	struct wid wid;
 	int result;
 	struct host_if_drv *hif_drv = vif->hif_drv;
+	struct wilc_priv *priv = wdev_priv(vif->ndev->ieee80211_ptr);
 
-	if (p2p_listen_state) {
+	if (priv->p2p_listen_state) {
 		remain_on_chan_flag = false;
 		wid.id = WID_REMAIN_ON_CHAN;
 		wid.type = WID_STR;
@@ -2437,7 +2436,6 @@ static void handle_listen_state_expired(struct work_struct *work)
 			hif_drv->remain_on_ch.expired(hif_drv->remain_on_ch.arg,
 						      hif_remain_ch->id);
 		}
-		p2p_listen_state = 0;
 	} else {
 		netdev_dbg(vif->ndev, "Not in listen state\n");
 	}
-- 
2.7.4
