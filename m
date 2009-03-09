Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:20195 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZCIFSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 01:18:39 -0400
Received: by wa-out-1112.google.com with SMTP id v33so864295wah.21
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2009 22:18:36 -0700 (PDT)
Message-ID: <49B4A6AB.9070808@gmail.com> (sfid-20090309_061845_165096_D7DF8866)
Date: Sun, 08 Mar 2009 22:18:35 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: simon@thekelleys.org.uk
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: [PATCH] atmel: checkpatch.pl cleanups
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Before: 881 errors, 265 warnings, 4507 lines checked
After:  114 errors, 273 warnings, 4548 lines checked

This was mostly "space required after that ',' (ctx:VxV)".
Also a fair number of whitespace, code indent, and C99 comment cleanups.

New warnings introduced are all "line over 80 character"

md5sums are identical, as I skipped any fixes which may have altered the resulting binary.

Signed-off-by: John Daiker <daikerjohn@gmail.com>
---
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 91930a2..b06835a 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -2,8 +2,8 @@
 
      Driver for Atmel at76c502 at76c504 and at76c506 wireless cards.
 
-        Copyright 2000-2001 ATMEL Corporation.
-        Copyright 2003-2004 Simon Kelley.
+	Copyright 2000-2001 ATMEL Corporation.
+	Copyright 2003-2004 Simon Kelley.
 
     This code was developed from version 2.1.1 of the Atmel drivers,
     released by Atmel corp. under the GPL in December 2002. It also
@@ -89,15 +89,15 @@ static struct {
 	const char *fw_file;
 	const char *fw_file_ext;
 } fw_table[] = {
-	{ ATMEL_FW_TYPE_502,      "atmel_at76c502",      "bin" },
-	{ ATMEL_FW_TYPE_502D,     "atmel_at76c502d",     "bin" },
-	{ ATMEL_FW_TYPE_502E,     "atmel_at76c502e",     "bin" },
-	{ ATMEL_FW_TYPE_502_3COM, "atmel_at76c502_3com", "bin" },
-	{ ATMEL_FW_TYPE_504,      "atmel_at76c504",      "bin" },
-	{ ATMEL_FW_TYPE_504_2958, "atmel_at76c504_2958", "bin" },
-	{ ATMEL_FW_TYPE_504A_2958,"atmel_at76c504a_2958","bin" },
-	{ ATMEL_FW_TYPE_506,      "atmel_at76c506",      "bin" },
-	{ ATMEL_FW_TYPE_NONE,      NULL,                  NULL }
+	{ ATMEL_FW_TYPE_502,		"atmel_at76c502",	"bin" },
+	{ ATMEL_FW_TYPE_502D,		"atmel_at76c502d",	"bin" },
+	{ ATMEL_FW_TYPE_502E,		"atmel_at76c502e",	"bin" },
+	{ ATMEL_FW_TYPE_502_3COM,	"atmel_at76c502_3com",	"bin" },
+	{ ATMEL_FW_TYPE_504,		"atmel_at76c504",	"bin" },
+	{ ATMEL_FW_TYPE_504_2958,	"atmel_at76c504_2958",	"bin" },
+	{ ATMEL_FW_TYPE_504A_2958,	"atmel_at76c504a_2958",	"bin" },
+	{ ATMEL_FW_TYPE_506,		"atmel_at76c506",	"bin" },
+	{ ATMEL_FW_TYPE_NONE,		NULL,			NULL }
 };
 
 #define MAX_SSID_LENGTH 32
@@ -106,60 +106,60 @@ static struct {
 #define MAX_BSS_ENTRIES	64
 
 /* registers */
-#define GCR  0x00    //      (SIR0)  General Configuration Register
-#define BSR  0x02    //      (SIR1)  Bank Switching Select Register
+#define GCR  0x00    /* (SIR0)  General Configuration Register */
+#define BSR  0x02    /* (SIR1)  Bank Switching Select Register */
 #define AR   0x04
 #define DR   0x08
-#define MR1  0x12    //      Mirror Register 1
-#define MR2  0x14    //      Mirror Register 2
-#define MR3  0x16    //      Mirror Register 3
-#define MR4  0x18    //      Mirror Register 4
+#define MR1  0x12    /* Mirror Register 1 */
+#define MR2  0x14    /* Mirror Register 2 */
+#define MR3  0x16    /* Mirror Register 3 */
+#define MR4  0x18    /* Mirror Register 4 */
 
 #define GPR1                            0x0c
 #define GPR2                            0x0e
 #define GPR3                            0x10
-//
-// Constants for the GCR register.
-//
-#define GCR_REMAP     0x0400          // Remap internal SRAM to 0
-#define GCR_SWRES     0x0080          // BIU reset (ARM and PAI are NOT reset)
-#define GCR_CORES     0x0060          // Core Reset (ARM and PAI are reset)
-#define GCR_ENINT     0x0002          // Enable Interrupts
-#define GCR_ACKINT    0x0008          // Acknowledge Interrupts
-
-#define BSS_SRAM      0x0200          // AMBA module selection --> SRAM
-#define BSS_IRAM      0x0100          // AMBA module selection --> IRAM
-//
-// Constants for the MR registers.
-//
-#define MAC_INIT_COMPLETE       0x0001        // MAC init has been completed
-#define MAC_BOOT_COMPLETE       0x0010        // MAC boot has been completed
-#define MAC_INIT_OK             0x0002        // MAC boot has been completed
+/*
+ * Constants for the GCR register.
+ */
+#define GCR_REMAP     0x0400          /* Remap internal SRAM to 0 */
+#define GCR_SWRES     0x0080          /* BIU reset (ARM and PAI are NOT reset) */
+#define GCR_CORES     0x0060          /* Core Reset (ARM and PAI are reset) */
+#define GCR_ENINT     0x0002          /* Enable Interrupts */
+#define GCR_ACKINT    0x0008          /* Acknowledge Interrupts */
+
+#define BSS_SRAM      0x0200          /* AMBA module selection --> SRAM */
+#define BSS_IRAM      0x0100          /* AMBA module selection --> IRAM */
+/*
+ *Constants for the MR registers.
+ */
+#define MAC_INIT_COMPLETE       0x0001        /* MAC init has been completed */
+#define MAC_BOOT_COMPLETE       0x0010        /* MAC boot has been completed */
+#define MAC_INIT_OK             0x0002        /* MAC boot has been completed */
 
 #define MIB_MAX_DATA_BYTES    212
 #define MIB_HEADER_SIZE       4    /* first four fields */
 
 struct get_set_mib {
-        u8 type;
-        u8 size;
-        u8 index;
-        u8 reserved;
-        u8 data[MIB_MAX_DATA_BYTES];
+	u8 type;
+	u8 size;
+	u8 index;
+	u8 reserved;
+	u8 data[MIB_MAX_DATA_BYTES];
 };
 
 struct rx_desc {
-        u32          Next;
-        u16          MsduPos;
-        u16          MsduSize;
-
-        u8           State;
-        u8           Status;
-        u8           Rate;
-        u8           Rssi;
-        u8           LinkQuality;
-        u8           PreambleType;
-        u16          Duration;
-        u32          RxTime;
+	u32          Next;
+	u16          MsduPos;
+	u16          MsduSize;
+
+	u8           State;
+	u8           Status;
+	u8           Rate;
+	u8           Rssi;
+	u8           LinkQuality;
+	u8           PreambleType;
+	u16          Duration;
+	u32          RxTime;
 };
 
 #define RX_DESC_FLAG_VALID       0x80
@@ -192,7 +192,7 @@ struct tx_desc {
 	u8        KeyIndex;
 	u8        ChiperType;
 	u8        ChipreLength;
-        u8        Reserved1;
+	u8        Reserved1;
 
 	u8        Reserved;
 	u8        PacketType;
@@ -212,9 +212,9 @@ struct tx_desc {
 #define TX_DESC_PACKET_TYPE_OFFSET   17
 #define TX_DESC_HOST_LENGTH_OFFSET   18
 
-///////////////////////////////////////////////////////
-// Host-MAC interface
-///////////////////////////////////////////////////////
+/*
+ * Host-MAC interface
+ */
 
 #define TX_STATUS_SUCCESS       0x00
 
@@ -226,14 +226,14 @@ struct tx_desc {
 #define TX_PACKET_TYPE_DATA     0x01
 #define TX_PACKET_TYPE_MGMT     0x02
 
-#define ISR_EMPTY               0x00        // no bits set in ISR
-#define ISR_TxCOMPLETE          0x01        // packet transmitted
-#define ISR_RxCOMPLETE          0x02        // packet received
-#define ISR_RxFRAMELOST         0x04        // Rx Frame lost
-#define ISR_FATAL_ERROR         0x08        // Fatal error
-#define ISR_COMMAND_COMPLETE    0x10        // command completed
-#define ISR_OUT_OF_RANGE        0x20        // command completed
-#define ISR_IBSS_MERGE          0x40        // (4.1.2.30): IBSS merge
+#define ISR_EMPTY               0x00        /* no bits set in ISR */
+#define ISR_TxCOMPLETE          0x01        /* packet transmitted */
+#define ISR_RxCOMPLETE          0x02        /* packet received */
+#define ISR_RxFRAMELOST         0x04        /* Rx Frame lost */
+#define ISR_FATAL_ERROR         0x08        /* Fatal error */
+#define ISR_COMMAND_COMPLETE    0x10        /* command completed */
+#define ISR_OUT_OF_RANGE        0x20        /* command completed */
+#define ISR_IBSS_MERGE          0x40        /* (4.1.2.30): IBSS merge */
 #define ISR_GENERIC_IRQ         0x80
 
 #define Local_Mib_Type          0x01
@@ -311,22 +311,22 @@ struct tx_desc {
 #define MAX_ENCRYPTION_KEYS 4
 #define MAX_ENCRYPTION_KEY_SIZE 40
 
-///////////////////////////////////////////////////////////////////////////
-// 802.11 related definitions
-///////////////////////////////////////////////////////////////////////////
+/*
+ * 802.11 related definitions
+ */
 
-//
-// Regulatory Domains
-//
+/*
+ * Regulatory Domains
+ */
 
-#define REG_DOMAIN_FCC		0x10	//Channels	1-11	USA
-#define REG_DOMAIN_DOC		0x20	//Channel	1-11	Canada
-#define REG_DOMAIN_ETSI		0x30	//Channel	1-13	Europe (ex Spain/France)
-#define REG_DOMAIN_SPAIN	0x31	//Channel	10-11	Spain
-#define REG_DOMAIN_FRANCE	0x32	//Channel	10-13	France
-#define REG_DOMAIN_MKK		0x40	//Channel	14	Japan
-#define REG_DOMAIN_MKK1		0x41	//Channel	1-14	Japan(MKK1)
-#define REG_DOMAIN_ISRAEL	0x50	//Channel	3-9	ISRAEL
+#define REG_DOMAIN_FCC		0x10	/* Channels	1-11	USA				*/
+#define REG_DOMAIN_DOC		0x20	/* Channel	1-11	Canada				*/
+#define REG_DOMAIN_ETSI		0x30	/* Channel	1-13	Europe (ex Spain/France)	*/
+#define REG_DOMAIN_SPAIN	0x31	/* Channel	10-11	Spain				*/
+#define REG_DOMAIN_FRANCE	0x32	/* Channel	10-13	France				*/
+#define REG_DOMAIN_MKK		0x40	/* Channel	14	Japan				*/
+#define REG_DOMAIN_MKK1		0x41	/* Channel	1-14	Japan(MKK1)			*/
+#define REG_DOMAIN_ISRAEL	0x50	/* Channel	3-9	ISRAEL				*/
 
 #define BSS_TYPE_AD_HOC		1
 #define BSS_TYPE_INFRASTRUCTURE 2
@@ -364,13 +364,13 @@ struct tx_desc {
 #define CIPHER_SUITE_CCX      4
 #define CIPHER_SUITE_WEP_128  5
 
-//
-// IFACE MACROS & definitions
-//
-//
+/*
+ * IFACE MACROS & definitions
+ */
 
-// FuncCtrl field:
-//
+/*
+ * FuncCtrl field:
+ */
 #define FUNC_CTRL_TxENABLE		0x10
 #define FUNC_CTRL_RxENABLE		0x20
 #define FUNC_CTRL_INIT_COMPLETE		0x01
@@ -378,48 +378,48 @@ struct tx_desc {
 /* A stub firmware image which reads the MAC address from NVRAM on the card.
    For copyright information and source see the end of this file. */
 static u8 mac_reader[] = {
-	0x06,0x00,0x00,0xea,0x04,0x00,0x00,0xea,0x03,0x00,0x00,0xea,0x02,0x00,0x00,0xea,
-	0x01,0x00,0x00,0xea,0x00,0x00,0x00,0xea,0xff,0xff,0xff,0xea,0xfe,0xff,0xff,0xea,
-	0xd3,0x00,0xa0,0xe3,0x00,0xf0,0x21,0xe1,0x0e,0x04,0xa0,0xe3,0x00,0x10,0xa0,0xe3,
-	0x81,0x11,0xa0,0xe1,0x00,0x10,0x81,0xe3,0x00,0x10,0x80,0xe5,0x1c,0x10,0x90,0xe5,
-	0x10,0x10,0xc1,0xe3,0x1c,0x10,0x80,0xe5,0x01,0x10,0xa0,0xe3,0x08,0x10,0x80,0xe5,
-	0x02,0x03,0xa0,0xe3,0x00,0x10,0xa0,0xe3,0xb0,0x10,0xc0,0xe1,0xb4,0x10,0xc0,0xe1,
-	0xb8,0x10,0xc0,0xe1,0xbc,0x10,0xc0,0xe1,0x56,0xdc,0xa0,0xe3,0x21,0x00,0x00,0xeb,
-	0x0a,0x00,0xa0,0xe3,0x1a,0x00,0x00,0xeb,0x10,0x00,0x00,0xeb,0x07,0x00,0x00,0xeb,
-	0x02,0x03,0xa0,0xe3,0x02,0x14,0xa0,0xe3,0xb4,0x10,0xc0,0xe1,0x4c,0x10,0x9f,0xe5,
-	0xbc,0x10,0xc0,0xe1,0x10,0x10,0xa0,0xe3,0xb8,0x10,0xc0,0xe1,0xfe,0xff,0xff,0xea,
-	0x00,0x40,0x2d,0xe9,0x00,0x20,0xa0,0xe3,0x02,0x3c,0xa0,0xe3,0x00,0x10,0xa0,0xe3,
-	0x28,0x00,0x9f,0xe5,0x37,0x00,0x00,0xeb,0x00,0x40,0xbd,0xe8,0x1e,0xff,0x2f,0xe1,
-	0x00,0x40,0x2d,0xe9,0x12,0x2e,0xa0,0xe3,0x06,0x30,0xa0,0xe3,0x00,0x10,0xa0,0xe3,
-	0x02,0x04,0xa0,0xe3,0x2f,0x00,0x00,0xeb,0x00,0x40,0xbd,0xe8,0x1e,0xff,0x2f,0xe1,
-	0x00,0x02,0x00,0x02,0x80,0x01,0x90,0xe0,0x01,0x00,0x00,0x0a,0x01,0x00,0x50,0xe2,
-	0xfc,0xff,0xff,0xea,0x1e,0xff,0x2f,0xe1,0x80,0x10,0xa0,0xe3,0xf3,0x06,0xa0,0xe3,
-	0x00,0x10,0x80,0xe5,0x00,0x10,0xa0,0xe3,0x00,0x10,0x80,0xe5,0x01,0x10,0xa0,0xe3,
-	0x04,0x10,0x80,0xe5,0x00,0x10,0x80,0xe5,0x0e,0x34,0xa0,0xe3,0x1c,0x10,0x93,0xe5,
-	0x02,0x1a,0x81,0xe3,0x1c,0x10,0x83,0xe5,0x58,0x11,0x9f,0xe5,0x30,0x10,0x80,0xe5,
-	0x54,0x11,0x9f,0xe5,0x34,0x10,0x80,0xe5,0x38,0x10,0x80,0xe5,0x3c,0x10,0x80,0xe5,
-	0x10,0x10,0x90,0xe5,0x08,0x00,0x90,0xe5,0x1e,0xff,0x2f,0xe1,0xf3,0x16,0xa0,0xe3,
-	0x08,0x00,0x91,0xe5,0x05,0x00,0xa0,0xe3,0x0c,0x00,0x81,0xe5,0x10,0x00,0x91,0xe5,
-	0x02,0x00,0x10,0xe3,0xfc,0xff,0xff,0x0a,0xff,0x00,0xa0,0xe3,0x0c,0x00,0x81,0xe5,
-	0x10,0x00,0x91,0xe5,0x02,0x00,0x10,0xe3,0xfc,0xff,0xff,0x0a,0x08,0x00,0x91,0xe5,
-	0x10,0x00,0x91,0xe5,0x01,0x00,0x10,0xe3,0xfc,0xff,0xff,0x0a,0x08,0x00,0x91,0xe5,
-	0xff,0x00,0x00,0xe2,0x1e,0xff,0x2f,0xe1,0x30,0x40,0x2d,0xe9,0x00,0x50,0xa0,0xe1,
-	0x03,0x40,0xa0,0xe1,0xa2,0x02,0xa0,0xe1,0x08,0x00,0x00,0xe2,0x03,0x00,0x80,0xe2,
-	0xd8,0x10,0x9f,0xe5,0x00,0x00,0xc1,0xe5,0x01,0x20,0xc1,0xe5,0xe2,0xff,0xff,0xeb,
-	0x01,0x00,0x10,0xe3,0xfc,0xff,0xff,0x1a,0x14,0x00,0xa0,0xe3,0xc4,0xff,0xff,0xeb,
-	0x04,0x20,0xa0,0xe1,0x05,0x10,0xa0,0xe1,0x02,0x00,0xa0,0xe3,0x01,0x00,0x00,0xeb,
-	0x30,0x40,0xbd,0xe8,0x1e,0xff,0x2f,0xe1,0x70,0x40,0x2d,0xe9,0xf3,0x46,0xa0,0xe3,
-	0x00,0x30,0xa0,0xe3,0x00,0x00,0x50,0xe3,0x08,0x00,0x00,0x9a,0x8c,0x50,0x9f,0xe5,
-	0x03,0x60,0xd5,0xe7,0x0c,0x60,0x84,0xe5,0x10,0x60,0x94,0xe5,0x02,0x00,0x16,0xe3,
-	0xfc,0xff,0xff,0x0a,0x01,0x30,0x83,0xe2,0x00,0x00,0x53,0xe1,0xf7,0xff,0xff,0x3a,
-	0xff,0x30,0xa0,0xe3,0x0c,0x30,0x84,0xe5,0x08,0x00,0x94,0xe5,0x10,0x00,0x94,0xe5,
-	0x01,0x00,0x10,0xe3,0xfc,0xff,0xff,0x0a,0x08,0x00,0x94,0xe5,0x00,0x00,0xa0,0xe3,
-	0x00,0x00,0x52,0xe3,0x0b,0x00,0x00,0x9a,0x10,0x50,0x94,0xe5,0x02,0x00,0x15,0xe3,
-	0xfc,0xff,0xff,0x0a,0x0c,0x30,0x84,0xe5,0x10,0x50,0x94,0xe5,0x01,0x00,0x15,0xe3,
-	0xfc,0xff,0xff,0x0a,0x08,0x50,0x94,0xe5,0x01,0x50,0xc1,0xe4,0x01,0x00,0x80,0xe2,
-	0x02,0x00,0x50,0xe1,0xf3,0xff,0xff,0x3a,0xc8,0x00,0xa0,0xe3,0x98,0xff,0xff,0xeb,
-	0x70,0x40,0xbd,0xe8,0x1e,0xff,0x2f,0xe1,0x01,0x0c,0x00,0x02,0x01,0x02,0x00,0x02,
-	0x00,0x01,0x00,0x02
+	0x06, 0x00, 0x00, 0xea, 0x04, 0x00, 0x00, 0xea, 0x03, 0x00, 0x00, 0xea, 0x02, 0x00, 0x00, 0xea,
+	0x01, 0x00, 0x00, 0xea, 0x00, 0x00, 0x00, 0xea, 0xff, 0xff, 0xff, 0xea, 0xfe, 0xff, 0xff, 0xea,
+	0xd3, 0x00, 0xa0, 0xe3, 0x00, 0xf0, 0x21, 0xe1, 0x0e, 0x04, 0xa0, 0xe3, 0x00, 0x10, 0xa0, 0xe3,
+	0x81, 0x11, 0xa0, 0xe1, 0x00, 0x10, 0x81, 0xe3, 0x00, 0x10, 0x80, 0xe5, 0x1c, 0x10, 0x90, 0xe5,
+	0x10, 0x10, 0xc1, 0xe3, 0x1c, 0x10, 0x80, 0xe5, 0x01, 0x10, 0xa0, 0xe3, 0x08, 0x10, 0x80, 0xe5,
+	0x02, 0x03, 0xa0, 0xe3, 0x00, 0x10, 0xa0, 0xe3, 0xb0, 0x10, 0xc0, 0xe1, 0xb4, 0x10, 0xc0, 0xe1,
+	0xb8, 0x10, 0xc0, 0xe1, 0xbc, 0x10, 0xc0, 0xe1, 0x56, 0xdc, 0xa0, 0xe3, 0x21, 0x00, 0x00, 0xeb,
+	0x0a, 0x00, 0xa0, 0xe3, 0x1a, 0x00, 0x00, 0xeb, 0x10, 0x00, 0x00, 0xeb, 0x07, 0x00, 0x00, 0xeb,
+	0x02, 0x03, 0xa0, 0xe3, 0x02, 0x14, 0xa0, 0xe3, 0xb4, 0x10, 0xc0, 0xe1, 0x4c, 0x10, 0x9f, 0xe5,
+	0xbc, 0x10, 0xc0, 0xe1, 0x10, 0x10, 0xa0, 0xe3, 0xb8, 0x10, 0xc0, 0xe1, 0xfe, 0xff, 0xff, 0xea,
+	0x00, 0x40, 0x2d, 0xe9, 0x00, 0x20, 0xa0, 0xe3, 0x02, 0x3c, 0xa0, 0xe3, 0x00, 0x10, 0xa0, 0xe3,
+	0x28, 0x00, 0x9f, 0xe5, 0x37, 0x00, 0x00, 0xeb, 0x00, 0x40, 0xbd, 0xe8, 0x1e, 0xff, 0x2f, 0xe1,
+	0x00, 0x40, 0x2d, 0xe9, 0x12, 0x2e, 0xa0, 0xe3, 0x06, 0x30, 0xa0, 0xe3, 0x00, 0x10, 0xa0, 0xe3,
+	0x02, 0x04, 0xa0, 0xe3, 0x2f, 0x00, 0x00, 0xeb, 0x00, 0x40, 0xbd, 0xe8, 0x1e, 0xff, 0x2f, 0xe1,
+	0x00, 0x02, 0x00, 0x02, 0x80, 0x01, 0x90, 0xe0, 0x01, 0x00, 0x00, 0x0a, 0x01, 0x00, 0x50, 0xe2,
+	0xfc, 0xff, 0xff, 0xea, 0x1e, 0xff, 0x2f, 0xe1, 0x80, 0x10, 0xa0, 0xe3, 0xf3, 0x06, 0xa0, 0xe3,
+	0x00, 0x10, 0x80, 0xe5, 0x00, 0x10, 0xa0, 0xe3, 0x00, 0x10, 0x80, 0xe5, 0x01, 0x10, 0xa0, 0xe3,
+	0x04, 0x10, 0x80, 0xe5, 0x00, 0x10, 0x80, 0xe5, 0x0e, 0x34, 0xa0, 0xe3, 0x1c, 0x10, 0x93, 0xe5,
+	0x02, 0x1a, 0x81, 0xe3, 0x1c, 0x10, 0x83, 0xe5, 0x58, 0x11, 0x9f, 0xe5, 0x30, 0x10, 0x80, 0xe5,
+	0x54, 0x11, 0x9f, 0xe5, 0x34, 0x10, 0x80, 0xe5, 0x38, 0x10, 0x80, 0xe5, 0x3c, 0x10, 0x80, 0xe5,
+	0x10, 0x10, 0x90, 0xe5, 0x08, 0x00, 0x90, 0xe5, 0x1e, 0xff, 0x2f, 0xe1, 0xf3, 0x16, 0xa0, 0xe3,
+	0x08, 0x00, 0x91, 0xe5, 0x05, 0x00, 0xa0, 0xe3, 0x0c, 0x00, 0x81, 0xe5, 0x10, 0x00, 0x91, 0xe5,
+	0x02, 0x00, 0x10, 0xe3, 0xfc, 0xff, 0xff, 0x0a, 0xff, 0x00, 0xa0, 0xe3, 0x0c, 0x00, 0x81, 0xe5,
+	0x10, 0x00, 0x91, 0xe5, 0x02, 0x00, 0x10, 0xe3, 0xfc, 0xff, 0xff, 0x0a, 0x08, 0x00, 0x91, 0xe5,
+	0x10, 0x00, 0x91, 0xe5, 0x01, 0x00, 0x10, 0xe3, 0xfc, 0xff, 0xff, 0x0a, 0x08, 0x00, 0x91, 0xe5,
+	0xff, 0x00, 0x00, 0xe2, 0x1e, 0xff, 0x2f, 0xe1, 0x30, 0x40, 0x2d, 0xe9, 0x00, 0x50, 0xa0, 0xe1,
+	0x03, 0x40, 0xa0, 0xe1, 0xa2, 0x02, 0xa0, 0xe1, 0x08, 0x00, 0x00, 0xe2, 0x03, 0x00, 0x80, 0xe2,
+	0xd8, 0x10, 0x9f, 0xe5, 0x00, 0x00, 0xc1, 0xe5, 0x01, 0x20, 0xc1, 0xe5, 0xe2, 0xff, 0xff, 0xeb,
+	0x01, 0x00, 0x10, 0xe3, 0xfc, 0xff, 0xff, 0x1a, 0x14, 0x00, 0xa0, 0xe3, 0xc4, 0xff, 0xff, 0xeb,
+	0x04, 0x20, 0xa0, 0xe1, 0x05, 0x10, 0xa0, 0xe1, 0x02, 0x00, 0xa0, 0xe3, 0x01, 0x00, 0x00, 0xeb,
+	0x30, 0x40, 0xbd, 0xe8, 0x1e, 0xff, 0x2f, 0xe1, 0x70, 0x40, 0x2d, 0xe9, 0xf3, 0x46, 0xa0, 0xe3,
+	0x00, 0x30, 0xa0, 0xe3, 0x00, 0x00, 0x50, 0xe3, 0x08, 0x00, 0x00, 0x9a, 0x8c, 0x50, 0x9f, 0xe5,
+	0x03, 0x60, 0xd5, 0xe7, 0x0c, 0x60, 0x84, 0xe5, 0x10, 0x60, 0x94, 0xe5, 0x02, 0x00, 0x16, 0xe3,
+	0xfc, 0xff, 0xff, 0x0a, 0x01, 0x30, 0x83, 0xe2, 0x00, 0x00, 0x53, 0xe1, 0xf7, 0xff, 0xff, 0x3a,
+	0xff, 0x30, 0xa0, 0xe3, 0x0c, 0x30, 0x84, 0xe5, 0x08, 0x00, 0x94, 0xe5, 0x10, 0x00, 0x94, 0xe5,
+	0x01, 0x00, 0x10, 0xe3, 0xfc, 0xff, 0xff, 0x0a, 0x08, 0x00, 0x94, 0xe5, 0x00, 0x00, 0xa0, 0xe3,
+	0x00, 0x00, 0x52, 0xe3, 0x0b, 0x00, 0x00, 0x9a, 0x10, 0x50, 0x94, 0xe5, 0x02, 0x00, 0x15, 0xe3,
+	0xfc, 0xff, 0xff, 0x0a, 0x0c, 0x30, 0x84, 0xe5, 0x10, 0x50, 0x94, 0xe5, 0x01, 0x00, 0x15, 0xe3,
+	0xfc, 0xff, 0xff, 0x0a, 0x08, 0x50, 0x94, 0xe5, 0x01, 0x50, 0xc1, 0xe4, 0x01, 0x00, 0x80, 0xe2,
+	0x02, 0x00, 0x50, 0xe1, 0xf3, 0xff, 0xff, 0x3a, 0xc8, 0x00, 0xa0, 0xe3, 0x98, 0xff, 0xff, 0xeb,
+	0x70, 0x40, 0xbd, 0xe8, 0x1e, 0xff, 0x2f, 0xe1, 0x01, 0x0c, 0x00, 0x02, 0x01, 0x02, 0x00, 0x02,
+	0x00, 0x01, 0x00, 0x02
 };
 
 struct atmel_private {
@@ -433,7 +433,7 @@ struct atmel_private {
 	struct net_device *dev;
 	struct device *sys_dev;
 	struct iw_statistics wstats;
-	spinlock_t irqlock, timerlock;	// spinlocks
+	spinlock_t irqlock, timerlock;	/* spinlocks */
 	enum { BUS_TYPE_PCCARD, BUS_TYPE_PCI } bus_type;
 	enum {
 		CARD_TYPE_PARALLEL_FLASH,
@@ -541,7 +541,7 @@ struct atmel_private {
 	u8 rx_buf[MAX_WIRELESS_BODY];
 };
 
-static u8 atmel_basic_rates[4] = {0x82,0x84,0x0b,0x16};
+static u8 atmel_basic_rates[4] = {0x82, 0x84, 0x0b, 0x16};
 
 static const struct {
 	int reg_domain;
@@ -1283,17 +1283,17 @@ static struct iw_statistics *atmel_get_wireless_stats(struct net_device *dev)
 
 static int atmel_change_mtu(struct net_device *dev, int new_mtu)
 {
-        if ((new_mtu < 68) || (new_mtu > 2312))
-                return -EINVAL;
-        dev->mtu = new_mtu;
-        return 0;
+	if ((new_mtu < 68) || (new_mtu > 2312))
+		return -EINVAL;
+	dev->mtu = new_mtu;
+	return 0;
 }
 
 static int atmel_set_mac_address(struct net_device *dev, void *p)
 {
 	struct sockaddr *addr = p;
 
-        memcpy (dev->dev_addr, addr->sa_data, dev->addr_len);
+	memcpy (dev->dev_addr, addr->sa_data, dev->addr_len);
 	return atmel_open(dev);
 }
 
@@ -1420,10 +1420,17 @@ static int atmel_proc_output (char *buf, struct atmel_private *priv)
 				     priv->firmware_id);
 
 		switch (priv->card_type) {
-		case CARD_TYPE_PARALLEL_FLASH: c = "Parallel flash"; break;
-		case CARD_TYPE_SPI_FLASH: c = "SPI flash\n"; break;
-		case CARD_TYPE_EEPROM: c = "EEPROM"; break;
-		default: c = "<unknown>";
+		case CARD_TYPE_PARALLEL_FLASH:
+			c = "Parallel flash";
+			break;
+		case CARD_TYPE_SPI_FLASH:
+			c = "SPI flash\n";
+			break;
+		case CARD_TYPE_EEPROM:
+			c = "EEPROM";
+			break;
+		default:
+			c = "<unknown>";
 		}
 
 		r = "<unknown>";
@@ -1439,16 +1446,33 @@ static int atmel_proc_output (char *buf, struct atmel_private *priv)
 			     priv->use_wpa ? "Yes" : "No");
 	}
 
-	switch(priv->station_state) {
-	case STATION_STATE_SCANNING: s = "Scanning"; break;
-	case STATION_STATE_JOINNING: s = "Joining"; break;
-	case STATION_STATE_AUTHENTICATING: s = "Authenticating"; break;
-	case STATION_STATE_ASSOCIATING: s = "Associating"; break;
-	case STATION_STATE_READY: s = "Ready"; break;
-	case STATION_STATE_REASSOCIATING: s = "Reassociating"; break;
-	case STATION_STATE_MGMT_ERROR: s = "Management error"; break;
-	case STATION_STATE_DOWN: s = "Down"; break;
-	default: s = "<unknown>";
+	switch (priv->station_state) {
+	case STATION_STATE_SCANNING:
+		s = "Scanning";
+		break;
+	case STATION_STATE_JOINNING:
+		s = "Joining";
+		break;
+	case STATION_STATE_AUTHENTICATING:
+		s = "Authenticating";
+		break;
+	case STATION_STATE_ASSOCIATING:
+		s = "Associating";
+		break;
+	case STATION_STATE_READY:
+		s = "Ready";
+		break;
+	case STATION_STATE_REASSOCIATING:
+		s = "Reassociating";
+		break;
+	case STATION_STATE_MGMT_ERROR:
+		s = "Management error";
+		break;
+	case STATION_STATE_DOWN:
+		s = "Down";
+		break;
+	default:
+		s = "<unknown>";
 	}
 
 	p += sprintf(p, "Current state:\t\t%s\n", s);
@@ -1458,14 +1482,17 @@ static int atmel_proc_output (char *buf, struct atmel_private *priv)
 static int atmel_read_proc(char *page, char **start, off_t off,
 			   int count, int *eof, void *data)
 {
-        struct atmel_private *priv = data;
+	struct atmel_private *priv = data;
 	int len = atmel_proc_output (page, priv);
-        if (len <= off+count) *eof = 1;
-        *start = page + off;
-        len -= off;
-        if (len>count) len = count;
-        if (len<0) len = 0;
-        return len;
+	if (len <= off+count)
+		*eof = 1;
+	*start = page + off;
+	len -= off;
+	if (len > count)
+		len = count;
+	if (len < 0)
+		len = 0;
+	return len;
 }
 
 struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
@@ -1479,11 +1506,11 @@ struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
 	int rc;
 
 	/* Create the network device object. */
-        dev = alloc_etherdev(sizeof(*priv));
-        if (!dev) {
+	dev = alloc_etherdev(sizeof(*priv));
+	if (!dev) {
 		printk(KERN_ERR "atmel: Couldn't alloc_etherdev\n");
 		return NULL;
-        }
+	}
 	if (dev_alloc_name(dev, dev->name) < 0) {
 		printk(KERN_ERR "atmel: Couldn't get name!\n");
 		goto err_out_free;
@@ -1577,7 +1604,7 @@ struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
 	if (register_netdev(dev))
 		goto err_out_res;
 
-	if (!probe_atmel_card(dev)){
+	if (!probe_atmel_card(dev)) {
 		unregister_netdev(dev);
 		goto err_out_res;
 	}
@@ -1594,7 +1621,7 @@ struct net_device *init_atmel_card(unsigned short irq, unsigned long port,
 	return dev;
 
 err_out_res:
-	release_region( dev->base_addr, 32);
+	release_region(dev->base_addr, 32);
 err_out_irq:
 	free_irq(dev->irq, dev);
 err_out_free:
@@ -1632,7 +1659,7 @@ static int atmel_set_essid(struct net_device *dev,
 	struct atmel_private *priv = netdev_priv(dev);
 
 	/* Check if we asked for `any' */
-	if(dwrq->flags == 0) {
+	if (dwrq->flags == 0) {
 		priv->connect_to_any_BSS = 1;
 	} else {
 		int index = (dwrq->flags & IW_ENCODE_INDEX) - 1;
@@ -1768,7 +1795,7 @@ static int atmel_set_encode(struct net_device *dev,
 	}
 	if (dwrq->flags & IW_ENCODE_RESTRICTED)
 		priv->exclude_unencrypted = 1;
-	if(dwrq->flags & IW_ENCODE_OPEN)
+	if (dwrq->flags & IW_ENCODE_OPEN)
 		priv->exclude_unencrypted = 0;
 
 	return -EINPROGRESS;		/* Call commit handler */
@@ -1797,7 +1824,7 @@ static int atmel_get_encode(struct net_device *dev,
 	/* Copy the key to the user buffer */
 	dwrq->length = priv->wep_key_len[index];
 	if (dwrq->length > 16) {
-		dwrq->length=0;
+		dwrq->length = 0;
 	} else {
 		memset(extra, 0, 16);
 		memcpy(extra, priv->wep_keys[index], dwrq->length);
@@ -2013,11 +2040,20 @@ static int atmel_set_rate(struct net_device *dev,
 		} else {
 		/* Setting by frequency value */
 			switch (vwrq->value) {
-			case  1000000: priv->tx_rate = 0; break;
-			case  2000000: priv->tx_rate = 1; break;
-			case  5500000: priv->tx_rate = 2; break;
-			case 11000000: priv->tx_rate = 3; break;
-			default: return -EINVAL;
+			case  1000000:
+				priv->tx_rate = 0;
+				break;
+			case  2000000:
+				priv->tx_rate = 1;
+				break;
+			case  5500000:
+				priv->tx_rate = 2;
+				break;
+			case 11000000:
+				priv->tx_rate = 3;
+				break;
+			default:
+				return -EINVAL;
 			}
 		}
 	}
@@ -2062,11 +2098,19 @@ static int atmel_get_rate(struct net_device *dev,
 		vwrq->value = 11000000;
 	} else {
 		vwrq->fixed = 1;
-		switch(priv->tx_rate) {
-		case 0: vwrq->value =  1000000; break;
-		case 1: vwrq->value =  2000000; break;
-		case 2: vwrq->value =  5500000; break;
-		case 3: vwrq->value = 11000000; break;
+		switch (priv->tx_rate) {
+		case 0:
+			vwrq->value =  1000000;
+			break;
+		case 1:
+			vwrq->value =  2000000;
+			break;
+		case 2:
+			vwrq->value =  5500000;
+			break;
+		case 3:
+			vwrq->value = 11000000;
+			break;
 		}
 	}
 	return 0;
@@ -2576,8 +2620,7 @@ static const struct iw_priv_args atmel_private_args[] = {
 	},
 };
 
-static const struct iw_handler_def atmel_handler_def =
-{
+static const struct iw_handler_def atmel_handler_def = {
 	.num_standard	= ARRAY_SIZE(atmel_handler),
 	.num_private	= ARRAY_SIZE(atmel_private_handler),
 	.num_private_args = ARRAY_SIZE(atmel_private_args),
@@ -2834,7 +2877,7 @@ static void send_authentication_request(struct atmel_private *priv, u16 system,
 
 	if (priv->wep_is_on && priv->CurrentAuthentTransactionSeqNum != 1)
 		/* no WEP for authentication frames with TrSeqNo 1 */
-                header.frame_control |=  cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+		header.frame_control |=  cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 
 	auth.alg = cpu_to_le16(system);
 
@@ -2969,7 +3012,7 @@ static void store_bss_info(struct atmel_private *priv,
 		if (memcmp(bss, priv->BSSinfo[i].BSSID, 6) == 0)
 			index = i;
 
-        /* If we process a probe and an entry from this BSS exists
+	/* If we process a probe and an entry from this BSS exists
 	   we will update the BSS entry with the info from this BSS.
 	   If we process a beacon we will only update RSSI */
 
@@ -2995,7 +3038,7 @@ static void store_bss_info(struct atmel_private *priv,
 	if (capability & WLAN_CAPABILITY_IBSS)
 		priv->BSSinfo[index].BSStype = IW_MODE_ADHOC;
 	else if (capability & WLAN_CAPABILITY_ESS)
-		priv->BSSinfo[index].BSStype =IW_MODE_INFRA;
+		priv->BSSinfo[index].BSStype = IW_MODE_INFRA;
 
 	priv->BSSinfo[index].preamble = capability & WLAN_CAPABILITY_SHORT_PREAMBLE ?
 		SHORT_PREAMBLE : LONG_PREAMBLE;
@@ -3042,7 +3085,7 @@ static void authenticate(struct atmel_private *priv, u16 frame_len)
 		}
 
 		if (should_associate) {
-			if(priv->station_was_associated) {
+			if (priv->station_was_associated) {
 				atmel_enter_state(priv, STATION_STATE_REASSOCIATING);
 				send_association_request(priv, 1);
 				return;
@@ -3063,8 +3106,8 @@ static void authenticate(struct atmel_private *priv, u16 frame_len)
 			priv->exclude_unencrypted = 1;
 			send_authentication_request(priv, WLAN_AUTH_SHARED_KEY, NULL, 0);
 			return;
-		} else if (   system == WLAN_AUTH_SHARED_KEY
-		           && priv->wep_is_on) {
+		} else if (system == WLAN_AUTH_SHARED_KEY
+			   && priv->wep_is_on) {
 			priv->CurrentAuthentTransactionSeqNum = 0x001;
 			priv->exclude_unencrypted = 0;
 			send_authentication_request(priv, WLAN_AUTH_OPEN, NULL, 0);
@@ -3252,11 +3295,11 @@ static void smooth_rssi(struct atmel_private *priv, u8 rssi)
 	u8 max_rssi = 42; /* 502-rmfd-revd max by experiment, default for now */
 
 	switch (priv->firmware_type) {
-		case ATMEL_FW_TYPE_502E:
-			max_rssi = 63; /* 502-rmfd-reve max by experiment */
-			break;
-		default:
-			break;
+	case ATMEL_FW_TYPE_502E:
+		max_rssi = 63; /* 502-rmfd-reve max by experiment */
+		break;
+	default:
+		break;
 	}
 
 	rssi = rssi * 100 / max_rssi;
@@ -3473,8 +3516,7 @@ static void atmel_command_irq(struct atmel_private *priv)
 	    status == CMD_STATUS_IN_PROGRESS)
 		return;
 
-	switch (command){
-
+	switch (command) {
 	case CMD_Start:
 		if (status == CMD_STATUS_COMPLETE) {
 			priv->station_was_associated = priv->station_is_associated;
@@ -3709,7 +3751,7 @@ static int probe_atmel_card(struct net_device *dev)
 
 	if (rc) {
 		if (dev->dev_addr[0] == 0xFF) {
-			u8 default_mac[] = {0x00,0x04, 0x25, 0x00, 0x00, 0x00};
+			u8 default_mac[] = {0x00, 0x04, 0x25, 0x00, 0x00, 0x00};
 			printk(KERN_ALERT "%s: *** Invalid MAC address. UPGRADE Firmware ****\n", dev->name);
 			memcpy(dev->dev_addr, default_mac, 6);
 		}
@@ -3803,7 +3845,7 @@ static void build_wpa_mib(struct atmel_private *priv)
 				} else {
 					mib.group_key = i;
 					priv->group_cipher_suite = priv->pairwise_cipher_suite;
-				        mib.cipher_default_key_value[i][MAX_ENCRYPTION_KEY_SIZE-1] = 1;
+					mib.cipher_default_key_value[i][MAX_ENCRYPTION_KEY_SIZE-1] = 1;
 					mib.cipher_default_key_value[i][MAX_ENCRYPTION_KEY_SIZE-2] = priv->group_cipher_suite;
 				}
 			}
@@ -3913,7 +3955,7 @@ static int reset_atmel_card(struct net_device *dev)
 			len = fw_entry->size;
 		}
 
-	        if (len <= 0x6000) {
+		if (len <= 0x6000) {
 			atmel_write16(priv->dev, BSR, BSS_IRAM);
 			atmel_copy_to_card(priv->dev, 0, fw, len);
 			atmel_set_gcr(priv->dev, GCR_REMAP);
@@ -3942,7 +3984,7 @@ static int reset_atmel_card(struct net_device *dev)
 	priv->use_wpa = (priv->host_info.major_version == 4);
 	priv->radio_on_broken = (priv->host_info.major_version == 5);
 
-        /* unmask all irq sources */
+	/* unmask all irq sources */
 	atmel_wmem8(priv, atmel_hi(priv, IFACE_INT_MASK_OFFSET), 0xff);
 
 	/* int Tx system and enable Tx */
@@ -3975,7 +4017,7 @@ static int reset_atmel_card(struct net_device *dev)
 		    CMD_STATUS_REJECTED_RADIO_OFF) {
 			printk(KERN_INFO "%s: cannot turn the radio on.\n",
 			       dev->name);
-                        return -EIO;
+			return -EIO;
 		}
 	}
 
@@ -3999,8 +4041,7 @@ static int reset_atmel_card(struct net_device *dev)
 	else
 		build_wep_mib(priv);
 
-	if (old_state == STATION_STATE_READY)
-	{
+	if (old_state == STATION_STATE_READY) {
 		union iwreq_data wrqu;
 
 		wrqu.data.length = 0;
@@ -4277,24 +4318,24 @@ static void atmel_wmem32(struct atmel_private *priv, u16 pos, u32 data)
 	.set NVRAM_LENGTH, 0x0200
 	.set MAC_ADDRESS_MIB, SRAM_BASE
 	.set MAC_ADDRESS_LENGTH, 6
-        .set MAC_BOOT_FLAG, 0x10
+	.set MAC_BOOT_FLAG, 0x10
 	.set MR1, 0
 	.set MR2, 4
 	.set MR3, 8
 	.set MR4, 0xC
 RESET_VECTOR:
-        b RESET_HANDLER
+	b RESET_HANDLER
 UNDEF_VECTOR:
-        b HALT1
+	b HALT1
 SWI_VECTOR:
-        b HALT1
+	b HALT1
 IABORT_VECTOR:
-        b HALT1
+	b HALT1
 DABORT_VECTOR:
 RESERVED_VECTOR:
-        b HALT1
+	b HALT1
 IRQ_VECTOR:
-        b HALT1
+	b HALT1
 FIQ_VECTOR:
 	b HALT1
 HALT1:	b HALT1
@@ -4306,7 +4347,7 @@ RESET_HANDLER:
 	ldr	r0, =SPI_CGEN_BASE
 	mov	r1, #0
 	mov	r1, r1, lsl #3
-	orr	r1,r1, #0
+	orr	r1, r1, #0
 	str	r1, [r0]
 	ldr	r1, [r0, #28]
 	bic	r1, r1, #16


