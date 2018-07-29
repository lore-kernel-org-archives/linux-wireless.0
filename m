Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:11708 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbeG2Hgf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 03:36:35 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 5/8] staging: wilc1000: added comments for 'hif_cs' mutex lock
Date: Sun, 29 Jul 2018 11:36:54 +0530
Message-ID: <1532844417-3192-6-git-send-email-ajay.kathat@microchip.com> (sfid-20180729_080723_356506_615BC0A2)
In-Reply-To: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added comments for 'hif_cs' mutex to avoid checkpatch.pl reported
issues.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_netdevice.h b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
index 371a87f..a0e2e11 100644
--- a/drivers/staging/wilc1000/wilc_wfi_netdevice.h
+++ b/drivers/staging/wilc1000/wilc_wfi_netdevice.h
@@ -130,6 +130,7 @@ struct wilc {
 	spinlock_t txq_spinlock;
 	/*protect rxq_entry_t receiver queue*/
 	struct mutex rxq_cs;
+	/* lock to protect hif access */
 	struct mutex hif_cs;
 
 	struct completion cfg_event;
-- 
2.7.4
