Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:53637 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752472AbeEKIOa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 04:14:30 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 11/30] staging: wilc1000: use kmalloc(sizeof(*mgmt_tx)...) in mgmt_tx()
Date: Fri, 11 May 2018 13:43:12 +0530
Message-ID: <1526026411-11058-12-git-send-email-ajay.kathat@microchip.com> (sfid-20180511_101433_868260_3FC1E0F9)
In-Reply-To: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
References: <1526026411-11058-1-git-send-email-ajay.kathat@microchip.com>
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
index 65ba6ed..1408ebd 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1622,7 +1622,7 @@ static int mgmt_tx(struct wiphy *wiphy,
 	if (!ieee80211_is_mgmt(mgmt->frame_control))
 		goto out;
 
-	mgmt_tx = kmalloc(sizeof(struct p2p_mgmt_data), GFP_KERNEL);
+	mgmt_tx = kmalloc(sizeof(*mgmt_tx), GFP_KERNEL);
 	if (!mgmt_tx) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.7.4
