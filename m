Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58573 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751956AbdFOSZ0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:26 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 23/23] nfc_copy: Update nfc_copy.h to match Linux kernel's version
Date: Thu, 15 Jun 2017 11:25:16 -0700
Message-Id: <20170615182516.4508-24-mgreer@animalcreek.com> (sfid-20170615_202537_819860_9C82B19A)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

neard's version of Linux's include/uapi/linux/nfc.h file has become
stale so update it to match the most current.  The update changes
a few macro names which are used by neard so update those names in
the neard code as well.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 include/nfc_copy.h          | 51 +++++++++++++++++++++++++++++++++------------
 tools/nfctool/llcp-decode.c | 14 ++++++-------
 tools/nfctool/snep-decode.c | 12 +++++------
 3 files changed, 51 insertions(+), 26 deletions(-)

diff --git a/include/nfc_copy.h b/include/nfc_copy.h
index 0b25f5c..399f39f 100644
--- a/include/nfc_copy.h
+++ b/include/nfc_copy.h
@@ -86,6 +86,9 @@
  *	for this event is the application ID (AID).
  * @NFC_CMD_GET_SE: Dump all discovered secure elements from an NFC controller.
  * @NFC_CMD_SE_IO: Send/Receive APDUs to/from the selected secure element.
+ * @NFC_CMD_ACTIVATE_TARGET: Request NFC controller to reactivate target.
+ * @NFC_CMD_VENDOR: Vendor specific command, to be implemented directly
+ *	from the driver in order to support hardware specific operations.
  */
 enum nfc_commands {
 	NFC_CMD_UNSPEC,
@@ -117,6 +120,7 @@ enum nfc_commands {
 	NFC_CMD_GET_SE,
 	NFC_CMD_SE_IO,
 	NFC_CMD_ACTIVATE_TARGET,
+	NFC_CMD_VENDOR,
 /* private: internal use only */
 	__NFC_CMD_AFTER_LAST
 };
@@ -153,6 +157,11 @@ enum nfc_commands {
  * @NFC_ATTR_APDU: Secure element APDU
  * @NFC_ATTR_TARGET_ISO15693_DSFID: ISO 15693 Data Storage Format Identifier
  * @NFC_ATTR_TARGET_ISO15693_UID: ISO 15693 Unique Identifier
+ * @NFC_ATTR_SE_PARAMS: Parameters data from an evt_transaction
+ * @NFC_ATTR_VENDOR_ID: NFC manufacturer unique ID, typically an OUI
+ * @NFC_ATTR_VENDOR_SUBCMD: Vendor specific sub command
+ * @NFC_ATTR_VENDOR_DATA: Vendor specific data, to be optionally passed
+ *	to a vendor specific command implementation
  */
 enum nfc_attrs {
 	NFC_ATTR_UNSPEC,
@@ -183,6 +192,10 @@ enum nfc_attrs {
 	NFC_ATTR_SE_APDU,
 	NFC_ATTR_TARGET_ISO15693_DSFID,
 	NFC_ATTR_TARGET_ISO15693_UID,
+	NFC_ATTR_SE_PARAMS,
+	NFC_ATTR_VENDOR_ID,
+	NFC_ATTR_VENDOR_SUBCMD,
+	NFC_ATTR_VENDOR_DATA,
 /* private: internal use only */
 	__NFC_ATTR_AFTER_LAST
 };
@@ -197,15 +210,19 @@ enum nfc_sdp_attr {
 };
 #define NFC_SDP_ATTR_MAX (__NFC_SDP_ATTR_AFTER_LAST - 1)
 
-#define NFC_DEVICE_NAME_MAXSIZE 8
-#define NFC_NFCID1_MAXSIZE 10
-#define NFC_NFCID2_MAXSIZE 8
-#define NFC_NFCID3_MAXSIZE 10
-#define NFC_SENSB_RES_MAXSIZE 12
-#define NFC_SENSF_RES_MAXSIZE 18
-#define NFC_GB_MAXSIZE        48
-#define NFC_FIRMWARE_NAME_MAXSIZE 32
-#define NFC_ISO15693_UID_MAXSIZE 8
+#define NFC_DEVICE_NAME_MAXSIZE		8
+#define NFC_NFCID1_MAXSIZE		10
+#define NFC_NFCID2_MAXSIZE		8
+#define NFC_NFCID3_MAXSIZE		10
+#define NFC_SENSB_RES_MAXSIZE		12
+#define NFC_SENSF_RES_MAXSIZE		18
+#define NFC_ATR_REQ_MAXSIZE		64
+#define NFC_ATR_RES_MAXSIZE		64
+#define NFC_ATR_REQ_GB_MAXSIZE		48
+#define NFC_ATR_RES_GB_MAXSIZE		47
+#define NFC_GB_MAXSIZE			48
+#define NFC_FIRMWARE_NAME_MAXSIZE	32
+#define NFC_ISO15693_UID_MAXSIZE	8
 
 /* NFC protocols */
 #define NFC_PROTO_JEWEL		1
@@ -274,11 +291,19 @@ struct sockaddr_nfc_llcp {
  * First byte is the adapter index
  * Second byte contains flags
  *  - 0x01 - Direction (0=RX, 1=TX)
- *  - 0x02-0x80 - Reserved
+ *  - 0x02-0x04 - Payload type (000=LLCP, 001=NCI, 010=HCI, 011=Digital,
+ *                              100=Proprietary)
+ *  - 0x05-0x80 - Reserved
  **/
-#define NFC_LLCP_RAW_HEADER_SIZE	2
-#define NFC_LLCP_DIRECTION_RX		0x00
-#define NFC_LLCP_DIRECTION_TX		0x01
+#define NFC_RAW_HEADER_SIZE	2
+#define NFC_DIRECTION_RX		0x00
+#define NFC_DIRECTION_TX		0x01
+
+#define RAW_PAYLOAD_LLCP 0
+#define RAW_PAYLOAD_NCI	1
+#define RAW_PAYLOAD_HCI	2
+#define RAW_PAYLOAD_DIGITAL	3
+#define RAW_PAYLOAD_PROPRIETARY	4
 
 /* socket option names */
 #define NFC_LLCP_RW		0
diff --git a/tools/nfctool/llcp-decode.c b/tools/nfctool/llcp-decode.c
index 7f95640..13e7ba7 100644
--- a/tools/nfctool/llcp-decode.c
+++ b/tools/nfctool/llcp-decode.c
@@ -189,7 +189,7 @@ static void llcp_check_cc(struct sniffer_packet *packet)
 		return;
 
 	/* Find the real destination SAP for this CC */
-	if (packet->direction == NFC_LLCP_DIRECTION_RX)
+	if (packet->direction == NFC_DIRECTION_RX)
 		dsap = packet->llcp.local_sap;
 	else
 		dsap = packet->llcp.remote_sap;
@@ -308,7 +308,7 @@ static int llcp_decode_packet(guint8 *data, guint32 data_len,
 	packet->direction = data[1] & 0x01;
 
 	/* LLCP header */
-	if (packet->direction == NFC_LLCP_DIRECTION_TX) {
+	if (packet->direction == NFC_DIRECTION_TX) {
 		packet->llcp.remote_sap = (data[2] & 0xFC) >> 2;
 		packet->llcp.local_sap = data[3] & 0x3F;
 	} else {
@@ -379,20 +379,20 @@ static int llcp_print_agf(struct sniffer_packet *packet,
 			goto exit;
 		}
 
-		if (size + NFC_LLCP_RAW_HEADER_SIZE > pdu_size) {
-			pdu_size = size + NFC_LLCP_RAW_HEADER_SIZE;
+		if (size + NFC_RAW_HEADER_SIZE > pdu_size) {
+			pdu_size = size + NFC_RAW_HEADER_SIZE;
 			pdu = g_realloc(pdu, pdu_size);
 
 			pdu[0] = packet->adapter_idx;
 			pdu[1] = packet->direction;
 		}
 
-		memcpy(pdu + NFC_LLCP_RAW_HEADER_SIZE,
+		memcpy(pdu + NFC_RAW_HEADER_SIZE,
 			packet->llcp.data + offset, size);
 
 		llcp_printf_msg("-- AGF LLC PDU %02u:", count++);
 
-		llcp_print_pdu(pdu, size + NFC_LLCP_RAW_HEADER_SIZE, timestamp);
+		llcp_print_pdu(pdu, size + NFC_RAW_HEADER_SIZE, timestamp);
 
 		offset += size;
 	}
@@ -530,7 +530,7 @@ int llcp_print_pdu(guint8 *data, guint32 data_len, struct timeval *timestamp)
 	if (!opts.dump_symm && packet.llcp.ptype == LLCP_PTYPE_SYMM)
 		return 0;
 
-	if (packet.direction == NFC_LLCP_DIRECTION_RX) {
+	if (packet.direction == NFC_DIRECTION_RX) {
 		direction_str = ">>";
 		direction_color = COLOR_RED;
 	} else {
diff --git a/tools/nfctool/snep-decode.c b/tools/nfctool/snep-decode.c
index bee06e5..6168c15 100644
--- a/tools/nfctool/snep-decode.c
+++ b/tools/nfctool/snep-decode.c
@@ -96,10 +96,10 @@ static void snep_frag_rejected(struct sniffer_packet *packet)
 	guint8 direction;
 
 	/* reverse direction to delete the corresponding fragment */
-	if (packet->direction == NFC_LLCP_DIRECTION_RX)
-		direction = NFC_LLCP_DIRECTION_TX;
+	if (packet->direction == NFC_DIRECTION_RX)
+		direction = NFC_DIRECTION_TX;
 	else
-		direction = NFC_LLCP_DIRECTION_RX;
+		direction = NFC_DIRECTION_RX;
 
 	index = snep_make_frag_index(packet->adapter_idx,
 				     direction,
@@ -129,7 +129,7 @@ static int snep_frag_append(struct snep_frag *frag,
 	frag->count++;
 
 	snep_printf_msg("%s fragment #%hu of %u bytes (total %u/%u)",
-			packet->direction == NFC_LLCP_DIRECTION_RX ? "Received" : "Sent",
+			packet->direction == NFC_DIRECTION_RX ? "Received" : "Sent",
 		    frag->count, packet->llcp.data_len,
 		    frag->received, frag->buffer_size);
 
@@ -177,11 +177,11 @@ static int snep_decode_info(struct sniffer_packet *packet)
 	frag->index = snep_get_frag_index(packet);
 
 	snep_printf_msg("Start %s fragmented message of %u bytes",
-			packet->direction == NFC_LLCP_DIRECTION_RX ? "Receiving" : "Sending",
+			packet->direction == NFC_DIRECTION_RX ? "Receiving" : "Sending",
 			frag->buffer_size);
 
 	snep_printf_msg("%s fragment #%hu of %u bytes",
-			packet->direction == NFC_LLCP_DIRECTION_RX ? "Received" : "Sent",
+			packet->direction == NFC_DIRECTION_RX ? "Received" : "Sent",
 			frag->count, frag->received);
 
 	DBG("Adding frag with index 0x%x", frag->index);
-- 
2.13.0
