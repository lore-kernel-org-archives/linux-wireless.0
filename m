Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:31438 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbeEGIoi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 04:44:38 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 17/30] staging: wilc1000: fix line over 80 chars in wilc_wfi_cfg_tx_vendor_spec()
Date: Mon, 7 May 2018 14:13:21 +0530
Message-ID: <1525682614-3824-18-git-send-email-ajay.kathat@microchip.com> (sfid-20180507_104446_864418_C5BD37A5)
In-Reply-To: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix line over 80 characters issues reported by checkpatch.pl script in
wilc_wfi_cfg_tx_vendor_spec() by using temporary variable. Simplified
'if else' condition with 'if'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 4f35178..8dea414 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1573,14 +1573,14 @@ static void wilc_wfi_cfg_tx_vendor_spec(struct p2p_mgmt_data *mgmt_tx,
 	for (i = P2P_PUB_ACTION_SUBTYPE + 2; i < len; i++) {
 		if (buf[i] == P2PELEM_ATTR_ID &&
 		    !memcmp(p2p_oui, &buf[i + 2], 4)) {
+			bool oper_ch = false;
+			u8 *tx_buff = &mgmt_tx->buff[i + 6];
+
 			if (subtype == P2P_INV_REQ || subtype == P2P_INV_RSP)
-				wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6],
-							     len - (i + 6),
-							     true, iftype);
-			else
-				wilc_wfi_cfg_parse_tx_action(&mgmt_tx->buff[i + 6],
-							     len - (i + 6),
-							     false, iftype);
+				oper_ch = true;
+
+			wilc_wfi_cfg_parse_tx_action(tx_buff, len - (i + 6),
+						     oper_ch, iftype);
 
 			break;
 		}
-- 
2.7.4
