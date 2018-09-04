Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:12606 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbeIDLE7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 07:04:59 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 26/26] staging: wilc1000: remove handle_hif_exit_work() function
Date: Tue, 4 Sep 2018 12:09:42 +0530
Message-ID: <1536043182-19735-27-git-send-email-ajay.kathat@microchip.com> (sfid-20180904_084125_036272_86E94784)
In-Reply-To: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
References: <1536043182-19735-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup to remove handle_hif_exit_work(), as after code refactoring its
not required anymore.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 85113fb..5388be9 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2593,14 +2593,6 @@ static void handle_remain_on_chan_work(struct work_struct *work)
 	kfree(msg);
 }
 
-static void handle_hif_exit_work(struct work_struct *work)
-{
-	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
-
-	/* free 'msg' data in caller */
-	complete(&msg->work_comp);
-}
-
 static void handle_scan_complete(struct work_struct *work)
 {
 	struct host_if_msg *msg = container_of(work, struct host_if_msg, work);
-- 
2.7.4
