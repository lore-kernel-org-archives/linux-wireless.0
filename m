Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16916 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932408AbeARNSr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 08:18:47 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 14/14] staging: wilc1000: rename Handle_ConnectTimeout() and Handle_Key()
Date: Thu, 18 Jan 2018 18:47:12 +0530
Message-ID: <1516281432-7724-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180118_141921_441081_FA4D422A)
In-Reply-To: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
References: <1516281432-7724-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

fix "Avoid camelCase" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 15fca67..49f35f7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1159,7 +1159,7 @@ static s32 handle_connect(struct wilc_vif *vif,
 	return result;
 }
 
-static s32 Handle_ConnectTimeout(struct wilc_vif *vif)
+static s32 handle_connect_timeout(struct wilc_vif *vif)
 {
 	s32 result = 0;
 	struct connect_info conn_info;
@@ -1519,7 +1519,7 @@ static s32 Handle_RcvdGnrlAsyncInfo(struct wilc_vif *vif,
 	return result;
 }
 
-static int Handle_Key(struct wilc_vif *vif,
+static int handle_key(struct wilc_vif *vif,
 		      struct key_attr *pstrHostIFkeyAttr)
 {
 	s32 result = 0;
@@ -2505,7 +2505,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_KEY:
-		Handle_Key(msg->vif, &msg->body.key_info);
+		handle_key(msg->vif, &msg->body.key_info);
 		break;
 
 	case HOST_IF_MSG_CFG_PARAMS:
@@ -2572,7 +2572,7 @@ static void host_if_work(struct work_struct *work)
 		break;
 
 	case HOST_IF_MSG_CONNECT_TIMER_FIRED:
-		Handle_ConnectTimeout(msg->vif);
+		handle_connect_timeout(msg->vif);
 		break;
 
 	case HOST_IF_MSG_POWER_MGMT:
-- 
2.7.4
