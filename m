Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:52213 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbeBZQgH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 11:36:07 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 6/8] staging: wilc1000: fix line over 80 char in wilc_wlan_handle_rxq()
Date: Mon, 26 Feb 2018 22:02:00 +0530
Message-ID: <1519662722-15761-7-git-send-email-ajay.kathat@microchip.com> (sfid-20180226_173610_779969_A1848F81)
In-Reply-To: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
References: <1519662722-15761-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix 'line over 80 character' issue found by checkpatch.pl script.
Refactor wilc_wlan_handle_rxq() code to remove the checkpatch.pl
warnings.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 46 ++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 74b80ad..223bf8b 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -798,6 +798,7 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 			u32 header;
 			u32 pkt_len, pkt_offset, tp_len;
 			int is_cfg_packet;
+			int tmp;
 
 			memcpy(&header, &buffer[offset], 4);
 			header = cpu_to_le32(header);
@@ -815,28 +816,31 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 						IS_MANAGMEMENT_CALLBACK |
 						IS_MGMT_STATUS_SUCCES);
 
-				wilc_wfi_mgmt_rx(wilc, &buffer[offset + HOST_HDR_OFFSET], pkt_len);
+				tmp = offset + HOST_HDR_OFFSET;
+				wilc_wfi_mgmt_rx(wilc, &buffer[tmp], pkt_len);
+			} else if (!is_cfg_packet) {
+				if (pkt_len > 0) {
+					wilc_frmw_to_linux(wilc,
+							   &buffer[offset],
+							   pkt_len,
+							   pkt_offset);
+				}
 			} else {
-				if (!is_cfg_packet) {
-					if (pkt_len > 0) {
-						wilc_frmw_to_linux(wilc,
-								   &buffer[offset],
-								   pkt_len,
-								   pkt_offset);
-					}
-				} else {
-					struct wilc_cfg_rsp rsp;
-
-					wilc_wlan_cfg_indicate_rx(wilc, &buffer[pkt_offset + offset], pkt_len, &rsp);
-					if (rsp.type == WILC_CFG_RSP) {
-						if (wilc->cfg_seq_no == rsp.seq_no)
-							complete(&wilc->cfg_event);
-					} else if (rsp.type == WILC_CFG_RSP_STATUS) {
-						wilc_mac_indicate(wilc, WILC_MAC_INDICATE_STATUS);
-
-					} else if (rsp.type == WILC_CFG_RSP_SCAN) {
-						wilc_mac_indicate(wilc, WILC_MAC_INDICATE_SCAN);
-					}
+				struct wilc_cfg_rsp rsp;
+
+				tmp = pkt_offset + offset;
+				wilc_wlan_cfg_indicate_rx(wilc, &buffer[tmp],
+							  pkt_len, &rsp);
+				if (rsp.type == WILC_CFG_RSP) {
+					if (wilc->cfg_seq_no == rsp.seq_no)
+						complete(&wilc->cfg_event);
+				} else if (rsp.type == WILC_CFG_RSP_STATUS) {
+					tmp = WILC_MAC_INDICATE_STATUS;
+					wilc_mac_indicate(wilc, tmp);
+
+				} else if (rsp.type == WILC_CFG_RSP_SCAN) {
+					tmp = WILC_MAC_INDICATE_SCAN;
+					wilc_mac_indicate(wilc, tmp);
 				}
 			}
 			offset += tp_len;
-- 
2.7.4
