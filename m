Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:4423 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424338AbeCBORd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:17:33 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 1/3] staging: wilc1000: fix open parenthesis mismatch in wilc_wlan_cfg_get()
Date: Fri, 2 Mar 2018 19:47:18 +0530
Message-ID: <1520000240-27519-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_151740_831836_2A5B72EF)
In-Reply-To: <1520000240-27519-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000240-27519-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Alignment should match open parenthesis' issue found by
checkpatch.pl script. Reduce the leading tab, to make space for open
parenthesis match.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 74b80ad..7c0d212 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1267,21 +1267,22 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 	offset += ret_size;
 	wilc->cfg_frame_offset = offset;
 
-	if (commit) {
-		wilc->cfg_frame_in_use = 1;
+	if (!commit)
+		return ret_size;
 
-		if (wilc_wlan_cfg_commit(vif, WILC_CFG_QUERY, drv_handler))
-			ret_size = 0;
+	wilc->cfg_frame_in_use = 1;
 
-		if (!wait_for_completion_timeout(&wilc->cfg_event,
-					msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
-			netdev_dbg(vif->ndev, "Get Timed Out\n");
-			ret_size = 0;
-		}
-		wilc->cfg_frame_in_use = 0;
-		wilc->cfg_frame_offset = 0;
-		wilc->cfg_seq_no += 1;
+	if (wilc_wlan_cfg_commit(vif, WILC_CFG_QUERY, drv_handler))
+		ret_size = 0;
+
+	if (!wait_for_completion_timeout(&wilc->cfg_event,
+					 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
+		netdev_dbg(vif->ndev, "Get Timed Out\n");
+		ret_size = 0;
 	}
+	wilc->cfg_frame_in_use = 0;
+	wilc->cfg_frame_offset = 0;
+	wilc->cfg_seq_no += 1;
 
 	return ret_size;
 }
-- 
2.7.4
