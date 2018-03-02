Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:57423 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428567AbeCBOR6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 09:17:58 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 3/3] staging: wilc1000: fix line over 80 char in wilc_wlan_handle_rxq()
Date: Fri, 2 Mar 2018 19:47:20 +0530
Message-ID: <1520000240-27519-4-git-send-email-ajay.kathat@microchip.com> (sfid-20180302_151803_159528_59062885)
In-Reply-To: <1520000240-27519-1-git-send-email-ajay.kathat@microchip.com>
References: <1520000240-27519-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor wilc_wlan_handle_rxq() to fix line over 80 character issue
found by checkpatch.pl script. Added a new function to split
'wilc_wlan_handle_rxq' function code.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 114 +++++++++++++++++++----------------
 1 file changed, 63 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 8490407..bcbb923 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -773,9 +773,70 @@ int wilc_wlan_handle_txq(struct net_device *dev, u32 *txq_count)
 	return ret;
 }
 
+static void wilc_wlan_handle_rx_buff(struct wilc *wilc, u8 *buffer, int size)
+{
+	int offset = 0;
+	u32 header;
+	u32 pkt_len, pkt_offset, tp_len;
+	int is_cfg_packet;
+	u8 *buff_ptr;
+
+	do {
+		buff_ptr = buffer + offset;
+		memcpy(&header, buff_ptr, 4);
+		header = cpu_to_le32(header);
+
+		is_cfg_packet = (header >> 31) & 0x1;
+		pkt_offset = (header >> 22) & 0x1ff;
+		tp_len = (header >> 11) & 0x7ff;
+		pkt_len = header & 0x7ff;
+
+		if (pkt_len == 0 || tp_len == 0)
+			break;
+
+		if (pkt_offset & IS_MANAGMEMENT) {
+			pkt_offset &= ~(IS_MANAGMEMENT |
+					IS_MANAGMEMENT_CALLBACK |
+					IS_MGMT_STATUS_SUCCES);
+			buff_ptr += HOST_HDR_OFFSET;
+			wilc_wfi_mgmt_rx(wilc, buff_ptr, pkt_len);
+		} else {
+			if (!is_cfg_packet) {
+				if (pkt_len > 0) {
+					wilc_frmw_to_linux(wilc, buff_ptr,
+							   pkt_len,
+							   pkt_offset);
+				}
+			} else {
+				struct wilc_cfg_rsp rsp;
+
+				buff_ptr += pkt_offset;
+
+				wilc_wlan_cfg_indicate_rx(wilc, buff_ptr,
+							  pkt_len,
+							  &rsp);
+				if (rsp.type == WILC_CFG_RSP) {
+					if (wilc->cfg_seq_no == rsp.seq_no)
+						complete(&wilc->cfg_event);
+				} else if (rsp.type == WILC_CFG_RSP_STATUS) {
+					wilc_mac_indicate(wilc,
+							  WILC_MAC_INDICATE_STATUS);
+
+				} else if (rsp.type == WILC_CFG_RSP_SCAN) {
+					wilc_mac_indicate(wilc,
+							  WILC_MAC_INDICATE_SCAN);
+				}
+			}
+		}
+		offset += tp_len;
+		if (offset >= size)
+			break;
+	} while (1);
+}
+
 static void wilc_wlan_handle_rxq(struct wilc *wilc)
 {
-	int offset = 0, size;
+	int size;
 	u8 *buffer;
 	struct rxq_entry_t *rqe;
 
@@ -792,57 +853,8 @@ static void wilc_wlan_handle_rxq(struct wilc *wilc)
 
 		buffer = rqe->buffer;
 		size = rqe->buffer_size;
-		offset = 0;
-
-		do {
-			u32 header;
-			u32 pkt_len, pkt_offset, tp_len;
-			int is_cfg_packet;
-
-			memcpy(&header, &buffer[offset], 4);
-			header = cpu_to_le32(header);
-
-			is_cfg_packet = (header >> 31) & 0x1;
-			pkt_offset = (header >> 22) & 0x1ff;
-			tp_len = (header >> 11) & 0x7ff;
-			pkt_len = header & 0x7ff;
-
-			if (pkt_len == 0 || tp_len == 0)
-				break;
+		wilc_wlan_handle_rx_buff(wilc, buffer, size);
 
-			if (pkt_offset & IS_MANAGMEMENT) {
-				pkt_offset &= ~(IS_MANAGMEMENT |
-						IS_MANAGMEMENT_CALLBACK |
-						IS_MGMT_STATUS_SUCCES);
-
-				wilc_wfi_mgmt_rx(wilc, &buffer[offset + HOST_HDR_OFFSET], pkt_len);
-			} else {
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
-				}
-			}
-			offset += tp_len;
-			if (offset >= size)
-				break;
-		} while (1);
 		kfree(rqe);
 	} while (1);
 
-- 
2.7.4
