Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:18466 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbeEBHPA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:15:00 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 02/21] staging: wilc1000: remove unnecessary 'out of memory' message in handle_key()
Date: Wed, 2 May 2018 12:43:28 +0530
Message-ID: <1525245227-3924-3-git-send-email-ajay.kathat@microchip.com> (sfid-20180502_092058_102859_01BD3DAF)
In-Reply-To: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
References: <1525245227-3924-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "Possible unnecessary 'out of memory' message" issue reported by
checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2f3e20d..d5b824b 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1707,7 +1707,6 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
 		} else if (hif_key->action & ADDKEY) {
 			key_buf = kmalloc(PTK_KEY_MSG_LEN, GFP_KERNEL);
 			if (!key_buf) {
-				netdev_err(vif->ndev, "No buffer send PTK\n");
 				ret = -ENOMEM;
 				goto out_wpa_ptk;
 			}
-- 
2.7.4
