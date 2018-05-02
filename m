Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:28631 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751178AbeEBHPG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:06 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 04/21] staging: wilc1000: remove unnecessary bracket used in switch in wilc_mgmt_frame_register()
Date: Wed, 2 May 2018 12:43:30 +0530
Message-ID: <1525245227-3924-5-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092059_300346_C9868A70)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cleanup patch to remove the curly braces used in 'case' statement to follow as
per linux standard.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index d82a7b0..470a103 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1741,24 +1741,18 @@ void wilc_mgmt_frame_register(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	switch (frame_type) {
 	case PROBE_REQ:
-	{
 		vif->frame_reg[0].type = frame_type;
 		vif->frame_reg[0].reg = reg;
-	}
-	break;
+		break;
 
 	case ACTION:
-	{
 		vif->frame_reg[1].type = frame_type;
 		vif->frame_reg[1].reg = reg;
-	}
-	break;
+		break;
 
 	default:
-	{
 		break;
 	}
-	}
 
 	if (!wl->initialized)
 		return;
-- 
2.7.4
