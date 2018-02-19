Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:36608 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbeBSPa4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 10:30:56 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <Adham.Abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 14/14] staging: wilc1000: remove Unnecessary parentheses around 'hif_set_mc->cnt'
Date: Mon, 19 Feb 2018 20:59:44 +0530
Message-ID: <1519054184-14301-15-git-send-email-ajay.kathat@microchip.com> (sfid-20180219_163101_316764_46DCCC5E)
In-Reply-To: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
References: <1519054184-14301-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Unnecessary parentheses around 'hif_set_mc->cnt'" issue found by
checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 7ddd20d..6f93966 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2430,7 +2430,7 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 	*cur_byte++ = ((hif_set_mc->cnt >> 16) & 0xFF);
 	*cur_byte++ = ((hif_set_mc->cnt >> 24) & 0xFF);
 
-	if ((hif_set_mc->cnt) > 0)
+	if (hif_set_mc->cnt > 0)
 		memcpy(cur_byte, wilc_multicast_mac_addr_list,
 		       ((hif_set_mc->cnt) * ETH_ALEN));
 
-- 
2.7.4
