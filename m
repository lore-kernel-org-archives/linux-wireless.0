Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:11869 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbeA3Qv2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jan 2018 11:51:28 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 7/7] staging: wilc1000: rename Handle_Key() and Handle_ConnectTimeout()
Date: Tue, 30 Jan 2018 22:20:33 +0530
Message-ID: <1517331033-5718-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180130_175131_543547_1E2D51E4)
In-Reply-To: <1517331033-5718-1-git-send-email-ajay.kathat@microchip.com>
References: <1517331033-5718-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index f5fdca7..5e01f6e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1165,7 +1165,7 @@ static s32 Handle_Connect(struct wilc_vif *vif,
 	return result;
 }
 
-static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
+static s32 handle_connect_timeout(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct connect_info strConnectInfo;
@@ -1525,7 +1525,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	return result;
 }
 
-static int Handle_Key(struct wilc_vif *vif,
+static int handle_key(struct wilc_vif *vif,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
 	s32 result = 0;
@@ -2511,7 +2511,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_KEY:
-		Handle_Key(msg->vif, &msg->body.key_info);
+		handle_key(msg->vif, &msg->body.key_info);
 		break;
 
 	case HOST_IF_MSG_CFG_PARAMS:
@@ -2578,7 +2578,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-		Handle_ConnectTimeout(msg->vif);
+		handle_connect_timeout(msg->vif);
 		break;
 
 	case HOST_IF_MSG_POWER_MGMT:
-- 
2.7.4
