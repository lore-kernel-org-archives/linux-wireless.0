Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:49024 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753025AbeGEF0T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 01:26:19 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: fix static checker warning to unlock mutex in wilc_deinit()
Date: Thu, 5 Jul 2018 09:18:53 +0530
Message-ID: <1530762533-30510-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180705_072622_645407_0A558186)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix for static checker warning inconsistent returns of
'hif_deinit_lock'(more details [1]).

"drivers/staging/wilc1000/host_interface.c:3390 wilc_deinit()
              warn: inconsistent returns 'hif_deinit_lock'."

Introduced in "ff52a57a7a42: staging: wilc1000: move the allocation of
cmd out of wilc_enqueue_cmd()".

[1]. https://www.spinics.net/lists/linux-driver-devel/msg114216.html

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 52c0c10..918d06e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3370,15 +3370,15 @@ int wilc_deinit(struct wilc_vif *vif)
 		struct host_if_msg *msg;
 
 		msg = wilc_alloc_work(vif, handle_hif_exit_work, true);
-		if (IS_ERR(msg))
-			return PTR_ERR(msg);
-
-		result = wilc_enqueue_work(msg);
-		if (result)
-			netdev_err(vif->ndev, "deinit : Error(%d)\n", result);
-		else
-			wait_for_completion(&msg->work_comp);
-		kfree(msg);
+		if (!IS_ERR(msg)) {
+			result = wilc_enqueue_work(msg);
+			if (result)
+				netdev_err(vif->ndev, "deinit : Error(%d)\n",
+					   result);
+			else
+				wait_for_completion(&msg->work_comp);
+			kfree(msg);
+		}
 		destroy_workqueue(hif_workqueue);
 	}
 
-- 
2.7.4
