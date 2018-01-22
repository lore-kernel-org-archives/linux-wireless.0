Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40294 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751216AbeAVKXh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 05:23:37 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 14/14] staging: wilc1000: rename Handle_ConnectTimeout() and Handle_Key()
Date: Mon, 22 Jan 2018 15:52:27 +0530
Message-ID: <1516616547-24654-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180122_113155_721409_02AB8B1C)
In-Reply-To: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
References: <1516616547-24654-1-git-send-email-ajay.kathat@microchip.com>
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
index 6e462db..38b2f2e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1158,7 +1158,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 	return result;
 }
 
-static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
+static s32 handle_connect_timeout(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct connect_info conn_info;
@@ -1518,7 +1518,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	return result;
 }
 
-static int Handle_Key(struct wilc_vif *vif,
+static int handle_key(struct wilc_vif *vif,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
 	s32 result = 0;
@@ -2504,7 +2504,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_KEY:
-		Handle_Key(msg->vif, &msg->body.key_info);
+		handle_key(msg->vif, &msg->body.key_info);
 		break;
 
 	case HOST_IF_MSG_CFG_PARAMS:
@@ -2571,7 +2571,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-		Handle_ConnectTimeout(msg->vif);
+		handle_connect_timeout(msg->vif);
 		break;
 
 	case HOST_IF_MSG_POWER_MGMT:
-- 
2.7.4
