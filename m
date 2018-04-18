Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:64459 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753813AbeDRLkj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 07:40:39 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 07/22] staging: wilc1000: use sizeof(variable) for memory allocated to store key info
Date: Wed, 18 Apr 2018 17:09:09 +0530
Message-ID: <1524051564-15497-8-git-send-email-ajay.kathat@microchip.com> (sfid-20180418_134048_139644_1C5B3B82)
In-Reply-To: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
References: <1524051564-15497-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes to fix below checkpatch reported issues.

CHECK: Prefer kmalloc(sizeof(*priv->wilc_gtk[idx])...) over
kmalloc(sizeof(struct wilc_wfi_key)...)

CHECK: Prefer kmalloc(sizeof(*priv->wilc_ptk[idx])...) over
kmalloc(sizeof(struct wilc_wfi_key)...)

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 821d4f1..0d3f85d 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -871,15 +871,15 @@ static inline void wilc_wfi_cfg_copy_wep_info(struct wilc_priv *priv,
 static int wilc_wfi_cfg_allocate_wpa_entry(struct wilc_priv *priv, u8 idx)
 {
 	if (!priv->wilc_gtk[idx]) {
-		priv->wilc_gtk[idx] = kzalloc(sizeof(struct wilc_wfi_key),
-					       GFP_KERNEL);
+		priv->wilc_gtk[idx] = kzalloc(sizeof(*priv->wilc_gtk[idx]),
+					      GFP_KERNEL);
 		if (!priv->wilc_gtk[idx])
 			return -ENOMEM;
 	}
 
 	if (!priv->wilc_ptk[idx]) {
-		priv->wilc_ptk[idx] = kzalloc(sizeof(struct wilc_wfi_key),
-					       GFP_KERNEL);
+		priv->wilc_ptk[idx] = kzalloc(sizeof(*priv->wilc_ptk[idx]),
+					      GFP_KERNEL);
 		if (!priv->wilc_ptk[idx])
 			return -ENOMEM;
 	}
-- 
2.7.4
