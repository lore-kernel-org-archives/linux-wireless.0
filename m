Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:20746 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeG2Hgr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 03:36:47 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 8/8] staging: wilc1000: added parentheses in macro to avoid checkpatch issue
Date: Sun, 29 Jul 2018 11:36:57 +0530
Message-ID: <1532844417-3192-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180729_080734_946905_555F89C0)
In-Reply-To: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
References: <1532844417-3192-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to fix below checkpatch reported issue:

Macro argument 'id' may be better as '(id)' to avoid precedence issues

Also updated the TODO file to remove the below item
 'rework comments and function headers(also coding style)'

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/TODO        | 1 -
 drivers/staging/wilc1000/wilc_wlan.h | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/TODO b/drivers/staging/wilc1000/TODO
index 6fd3a4c..862e9ea 100644
--- a/drivers/staging/wilc1000/TODO
+++ b/drivers/staging/wilc1000/TODO
@@ -1,4 +1,3 @@
 TODO:
-- rework comments and function headers(also coding style)
 - support soft-ap and p2p mode
 - support resume/suspend function
diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
index 696cf1f..cd1ff85 100644
--- a/drivers/staging/wilc1000/wilc_wlan.h
+++ b/drivers/staging/wilc1000/wilc_wlan.h
@@ -4,7 +4,7 @@
 
 #include <linux/types.h>
 
-#define ISWILC1000(id)			((id & 0xfffff000) == 0x100000 ? 1 : 0)
+#define ISWILC1000(id)		(((id) & 0xfffff000) == 0x100000 ? 1 : 0)
 
 /********************************************
  *
-- 
2.7.4
