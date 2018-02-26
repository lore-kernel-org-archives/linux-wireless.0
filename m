Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:49891 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751499AbeBZQgL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:36:11 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 7/8] staging: wilc1000: fix line over 80 char in wilc_wlan_cfg_set()
Date: Mon, 26 Feb 2018 22:02:01 +0530
Message-ID: <1519662722-15761-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180226_173629_142958_9A0D5F48)
In-Reply-To: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 character' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 223bf8b..acf7591 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1230,6 +1230,8 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 	wilc->cfg_frame_offset = offset;
 
 	if (commit) {
+		unsigned long tmp = msecs_to_jiffies(CFG_PKTS_TIMEOUT);
+
 		netdev_dbg(vif->ndev,
 			   "[WILC]PACKET Commit with sequence number %d\n",
 			   wilc->cfg_seq_no);
@@ -1239,8 +1241,7 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
 			ret_size = 0;
 
-		if (!wait_for_completion_timeout(&wilc->cfg_event,
-						 msecs_to_jiffies(CFG_PKTS_TIMEOUT))) {
+		if (!wait_for_completion_timeout(&wilc->cfg_event, tmp)) {
 			netdev_dbg(vif->ndev, "Set Timed Out\n");
 			ret_size = 0;
 		}
-- 
2.7.4
