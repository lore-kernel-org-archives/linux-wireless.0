Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:4423 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428552AbeCBORg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:17:36 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 2/3] staging: wilc1000: fix line over 80 char in wilc_wlan_cfg_set()
Date: Fri, 2 Mar 2018 19:47:19 +0530
Message-ID: <1520000240-27519-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_151758_545246_00B01B58)
In-Reply-To: <1520000240-27519-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000240-27519-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 37 ++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7c0d212..8490407 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1225,27 +1225,28 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 	offset += ret_size;
 	wilc->cfg_frame_offset = offset;
 
-	if (commit) {
-		netdev_dbg(vif->ndev,
-			   "[WILC]PACKET Commit with sequence number %d\n",
-			   wilc->cfg_seq_no);
-		netdev_dbg(vif->ndev, "Processing cfg_set()\n");
-		wilc->cfg_frame_in_use = 1;
-
-		if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
-			ret_size = 0;
-
-		if (!wait_for_completion_timeout(&wilc->cfg_event,
-						 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
-			netdev_dbg(vif->ndev, "Set Timed Out\n");
-			ret_size = 0;
-		}
+	if (!commit)
+		return ret_size;
 
-		wilc->cfg_frame_in_use = 0;
-		wilc->cfg_frame_offset = 0;
-		wilc->cfg_seq_no += 1;
+	netdev_dbg(vif->ndev,
+		   "[WILC]PACKET Commit with sequence number %d\n",
+		   wilc->cfg_seq_no);
+	netdev_dbg(vif->ndev, "Processing cfg_set()\n");
+	wilc->cfg_frame_in_use = 1;
+
+	if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
+		ret_size = 0;
+
+	if (!wait_for_completion_timeout(&wilc->cfg_event,
+					 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
+		netdev_dbg(vif->ndev, "Set Timed Out\n");
+		ret_size = 0;
 	}
 
+	wilc->cfg_frame_in_use = 0;
+	wilc->cfg_frame_offset = 0;
+	wilc->cfg_seq_no += 1;
+
 	return ret_size;
 }
 
-- 
2.7.4
