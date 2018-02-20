Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3080 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751763AbeBTO60 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:58:26 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 05/12] staging: wilc1000: rename Handle_SetMulticastFilter to avoid camelCase
Date: Tue, 20 Feb 2018 20:27:54 +0530
Message-ID: <1519138681-1982-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180220_155830_223284_29F32177)
In-Reply-To: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
References: <1519138681-1982-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index fd21765..57f0201 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2404,8 +2404,8 @@ static void handle_power_management(struct wilc_vif *vif,
 		netdev_err(vif->ndev, "Failed to send power management\n");
 }
 
-static void Handle_SetMulticastFilter(struct wilc_vif *vif,
-				      struct set_multicast *hif_set_mc)
+static void handle_set_mcast_filter(struct wilc_vif *vif,
+				    struct set_multicast *hif_set_mc)
 {
 	s32 result = 0;
 	struct wid wid;
@@ -2621,7 +2621,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_SET_MULTICAST_FILTER:
-		Handle_SetMulticastFilter(msg->vif, &msg->body.multicast_info);
+		handle_set_mcast_filter(msg->vif, &msg->body.multicast_info);
 		break;
 
 	case HOST_IF_MSG_DEL_ALL_STA:
-- 
2.7.4
