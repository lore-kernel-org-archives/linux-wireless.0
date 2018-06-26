Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:1395 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751105AbeFZGHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:40 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/12] staging: wilc1000: handle freeing of key data in wilc_add_ptk()
Date: Tue, 26 Jun 2018 11:37:10 +0530
Message-ID: <1529993234-27294-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080745_310063_95EBD897)
In-Reply-To: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
References: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Handle freeing of memory allocated to store the 'key' in wilc_add_ptk()
function. Once work completion notification is received, free the
memory allocated to avoid missing of free in work function sepecially
for error scenario.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2cc9689..2062f4e 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1724,7 +1724,6 @@ static void handle_key(struct work_struct *work)
 
 out_wpa_ptk:
 		complete(&msg->work_comp);
-		kfree(hif_key->attr.wpa.key);
 		break;
 
 	case PMKSA:
@@ -2735,8 +2734,6 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 	}
 
 	wait_for_completion(&msg->work_comp);
-	kfree(msg);
-	return 0;
 
 free_key:
 	kfree(msg->body.key_info.attr.wpa.key);
-- 
2.7.4
