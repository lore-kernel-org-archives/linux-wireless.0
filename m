Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:30127 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425508AbeCBOXs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:23:48 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 08/13] staging: wilc1000: fix line over 80 char in wilc_add_ptk()
Date: Fri, 2 Mar 2018 19:52:44 +0530
Message-ID: <1520000569-27738-9-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_152351_472071_C15F737B)
In-Reply-To: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000569-27738-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 characters' issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 5ebb0aa..57f90e4 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2858,10 +2858,12 @@ int wilc_add_ptk(struct wilc_vif *vif, const u8 *ptk, u8 ptk_key_len,
 		return -ENOMEM;
 
 	if (rx_mic)
-		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic, RX_MIC_KEY_LEN);
+		memcpy(msg.body.key_info.attr.wpa.key + 16, rx_mic,
+		       RX_MIC_KEY_LEN);
 
 	if (tx_mic)
-		memcpy(msg.body.key_info.attr.wpa.key + 24, tx_mic, TX_MIC_KEY_LEN);
+		memcpy(msg.body.key_info.attr.wpa.key + 24, tx_mic,
+		       TX_MIC_KEY_LEN);
 
 	msg.body.key_info.attr.wpa.key_len = key_len;
 	msg.body.key_info.attr.wpa.mac_addr = mac_addr;
-- 
2.7.4
