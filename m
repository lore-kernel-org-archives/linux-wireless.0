Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:55513 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751243AbeAVKXe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 05:23:34 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 13/14] staging: wilc1000: rename Handle_Connect() to avoid camelCase
Date: Mon, 22 Jan 2018 15:52:26 +0530
Message-ID: <1516616547-24654-14-git-send-email-ajay.kathat@microchip.com> (sfid-20180122_112353_632546_89074CCE)
In-Reply-To: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelcase" issue found by checkpatch.pl
script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index b34243c..6e462db 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -902,7 +902,7 @@ static s32 handle_scan_done(struct wilc_vif *vif,
 }
 
 u8 wilc_connected_ssid[6] = {0};
-static s32 Handle_Connect(struct wilc_vif *vif,
+static s32 handle_connect(struct wilc_vif *vif,
 			  struct connect_attr *attr)
 {
 	s32 result = 0;
@@ -2491,7 +2491,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_CONNECT:
-		Handle_Connect(msg->vif, &msg->body.con_info);
+		handle_connect(msg->vif, &msg->body.con_info);
 		break;
 
 	case HOST_IF_MSG_RCVD_NTWRK_INFO:
-- 
2.7.4
