Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:38691 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752513AbeEGIoR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:44:17 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 11/30] staging: wilc1000: use sizeof(*wdev) to allocate memory in wilc_wfi_cfg_alloc()
Date: Mon, 7 May 2018 14:13:15 +0530
Message-ID: <1525682614-3824-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104421_676075_3D9D3DF8)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix below reported checkpatch issues in wilc_wfi_cfg_alloc().
kzalloc(sizeof(*wdev)...) over kzalloc(sizeof(struct wireless_dev)

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 8be3c4c..102facd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -2194,7 +2194,7 @@ static struct wireless_dev *wilc_wfi_cfg_alloc(void)
 {
 	struct wireless_dev *wdev;
 
-	wdev = kzalloc(sizeof(struct wireless_dev), GFP_KERNEL);
+	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
 	if (!wdev)
 		goto _fail_;
 
-- 
2.7.4
