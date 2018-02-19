Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753070AbeBSPaK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:10 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 01/14] staging: wilc1000: rename s8PowerMode & strPowerMgmtParam to avoid camelCase
Date: Mon, 19 Feb 2018 20:59:31 +0530
Message-ID: <1519054184-14301-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163016_451361_413A3CCF)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Avoid camelCase" issues found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5e01f6e..3dc3d2e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2383,20 +2383,20 @@ static void ListenTimerCB(struct timer_list *t)
 }
 
 static void Handle_PowerManagement(struct wilc_vif *vif,
-				   struct power_mgmt_param *strPowerMgmtParam)
+				   struct power_mgmt_param *pm_param)
 {
 	s32 result = 0;
 	struct wid wid;
-	s8 s8PowerMode;
+	s8 power_mode;
 
 	wid.id = (u16)WID_POWER_MANAGEMENT;
 
-	if (strPowerMgmtParam->enabled)
-		s8PowerMode = MIN_FAST_PS;
+	if (pm_param->enabled)
+		power_mode = MIN_FAST_PS;
 	else
-		s8PowerMode = NO_POWERSAVE;
+		power_mode = NO_POWERSAVE;
 
-	wid.val = &s8PowerMode;
+	wid.val = &power_mode;
 	wid.size = sizeof(char);
 
 	result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
-- 
2.7.4
