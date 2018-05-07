Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12228 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752545AbeEGIoV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:44:21 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 12/30] staging: wilc1000: use kmalloc(sizeof(*mgmt_tx)...) in mgmt_tx()
Date: Mon, 7 May 2018 14:13:16 +0530
Message-ID: <1525682614-3824-13-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104428_238602_9B4F65DE)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix below checkpatch issue found in mgmt_tx()

Prefer kmalloc(sizeof(*mgmt_tx)...) over kmalloc(sizeof(struct
p2p_mgmt_data)...)

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 102facd..d0fb31a 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1628,7 +1628,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	if (!ieee80211_is_mgmt(mgmt->frame_control))
 		goto out;
 
-	mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
+	mgmt_tx = kmalloc(sizeof(*mgmt_tx), GFP_KERNEL);
 	if (!mgmt_tx) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.7.4
