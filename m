Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:20319 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751795AbeBZQgO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:36:14 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 8/8] staging: wilc1000: fix open parenthesis mismatch issue in wilc_wlan_cfg_set()
Date: Mon, 26 Feb 2018 22:02:02 +0530
Message-ID: <1519662722-15761-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180226_173622_457812_D9E5EDCB)
In-Reply-To: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'Alignment should match open parenthesis' issue found by
checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index acf7591..971e61d2 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1273,13 +1273,14 @@ int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 	wilc->cfg_frame_offset = offset;
 
 	if (commit) {
+		unsigned long tmp = msecs_to_jiffies(CFG_PKTS_TIMEOUT);
+
 		wilc->cfg_frame_in_use = 1;
 
 		if (wilc_wlan_cfg_commit(vif, WILC_CFG_QUERY, drv_handler))
 			ret_size = 0;
 
-		if (!wait_for_completion_timeout(&wilc->cfg_event,
-					msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
+		if (!wait_for_completion_timeout(&wilc->cfg_event, tmp)) {
 			netdev_dbg(vif->ndev, "Get Timed Out\n");
 			ret_size = 0;
 		}
-- 
2.7.4
