Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab0BPR44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 12:56:56 -0500
Date: Tue, 16 Feb 2010 11:56:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: [PATCH 1/5] rtl8187se: Modify rtl818x.h
Message-ID: <4b7adc62.Yb1F30xIrbHVDbsL%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new driver for the RTL8187SE has some registers in different
locations from previous models.

The register space between 0x000 and 0x0FF is densly packed, a fact
that is used by previous drivers; however, the RTL8187SE uses many
registers in parsely packed higher-number pages. As a result, an new
indexing method using the pseudo-locations offsetN, where N is the
number of bytes, has been adopted.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 rtl818x.h |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 7 deletions(-)

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl818x.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl818x.h
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl818x.h
@@ -16,7 +16,12 @@
 #define RTL818X_H
 
 struct rtl818x_csr {
-	u8	MAC[6];
+	union {
+		u8	MAC[6];
+		u8	offset1[6];	/* upper page indexing helpers */
+		__le16	offset2[1];
+		__le32	offset4[1];
+	} __attribute__((__packed__));
 	u8	reserved_0[2];
 	__le32	MAR[2];
 	u8	RX_FIFO_COUNT;
@@ -30,16 +35,28 @@ struct rtl818x_csr {
 	__le32	THPDA;
 	__le16	BRSR;
 	u8	BSSID[6];
-	u8	RESP_RATE;
-	u8	EIFS;
+	union {
+		struct {
+			u8 RESP_RATE;
+			u8 EIFS;
+		} __attribute__((__packed__));
+		__le16 BRSR_8187SE;
+	} __attribute__((__packed__));
 	u8	reserved_3[1];
 	u8	CMD;
 #define RTL818X_CMD_TX_ENABLE		(1 << 2)
 #define RTL818X_CMD_RX_ENABLE		(1 << 3)
 #define RTL818X_CMD_RESET		(1 << 4)
 	u8	reserved_4[4];
-	__le16	INT_MASK;
-	__le16	INT_STATUS;
+	union {
+		struct {
+			__le16	INT_MASK;
+			__le16	INT_STATUS;
+		} __attribute__ ((__packed__));
+
+		__le32	INT_STATUS_SE;
+	} __attribute__ ((__packed__));
+/* status bits for rtl8187 and rtl8180/8185 */
 #define RTL818X_INT_RX_OK		(1 <<  0)
 #define RTL818X_INT_RX_ERR		(1 <<  1)
 #define RTL818X_INT_TXL_OK		(1 <<  2)
@@ -56,6 +73,33 @@ struct rtl818x_csr {
 #define RTL818X_INT_BEACON		(1 << 13)
 #define RTL818X_INT_TIME_OUT		(1 << 14)
 #define RTL818X_INT_TX_FO		(1 << 15)
+/* status bits for rtl8187se */
+#define RTL818X_INT_SE_TIMER3		(1 <<  0)
+#define RTL818X_INT_SE_TIMER2		(1 <<  1)
+#define RTL818X_INT_SE_RQ0SOR		(1 <<  2)
+#define RTL818X_INT_SE_TXBED_OK		(1 <<  3)
+#define RTL818X_INT_SE_TXBED_ERR	(1 <<  4)
+#define RTL818X_INT_SE_TXBE_OK		(1 <<  5)
+#define RTL818X_INT_SE_TXBE_ERR		(1 <<  6)
+#define RTL818X_INT_SE_RX_OK		(1 <<  7)
+#define RTL818X_INT_SE_RX_ERR		(1 <<  8)
+#define RTL818X_INT_SE_TXL_OK		(1 <<  9)
+#define RTL818X_INT_SE_TXL_ERR		(1 << 10)
+#define RTL818X_INT_SE_RX_DU		(1 << 11)
+#define RTL818X_INT_SE_RX_FIFO		(1 << 12)
+#define RTL818X_INT_SE_TXN_OK		(1 << 13)
+#define RTL818X_INT_SE_TXN_ERR		(1 << 14)
+#define RTL818X_INT_SE_TXH_OK		(1 << 15)
+#define RTL818X_INT_SE_TXH_ERR		(1 << 16)
+#define RTL818X_INT_SE_TXB_OK		(1 << 17)
+#define RTL818X_INT_SE_TXB_ERR		(1 << 18)
+#define RTL818X_INT_SE_ATIM_TO		(1 << 19)
+#define RTL818X_INT_SE_BK_TO		(1 << 20)
+#define RTL818X_INT_SE_TIMER1		(1 << 21)
+#define RTL818X_INT_SE_TX_FIFO		(1 << 22)
+#define RTL818X_INT_SE_WAKEUP		(1 << 23)
+#define RTL818X_INT_SE_BK_DMA		(1 << 24)
+#define RTL818X_INT_SE_TMGD_OK		(1 << 30)
 	__le32	TX_CONF;
 #define RTL818X_TX_CONF_LOOPBACK_MAC	(1 << 17)
 #define RTL818X_TX_CONF_LOOPBACK_CONT	(3 << 17)
@@ -79,6 +123,9 @@ struct rtl818x_csr {
 #define RTL818X_RX_CONF_MULTICAST	(1 <<  2)
 #define RTL818X_RX_CONF_BROADCAST	(1 <<  3)
 #define RTL818X_RX_CONF_FCS		(1 <<  5)
+#define RTL818X_RX_CONF_9356SEL		(1 <<  6)
+#define RTL818X_RX_CONF_MAXDMA		(7 <<  8)
+#define RTL818X_RX_CONF_FIFO		(7 << 13)
 #define RTL818X_RX_CONF_DATA		(1 << 18)
 #define RTL818X_RX_CONF_CTRL		(1 << 19)
 #define RTL818X_RX_CONF_MGMT		(1 << 20)
@@ -122,7 +169,8 @@ struct rtl818x_csr {
 	u8	PGSELECT;
 	u8	SECURITY;
 	__le32	ANAPARAM2;
-	u8	reserved_10[12];
+	u8	reserved_10[8];
+	__le32  IMR;			/* Interrupt mask reg for 8187se */
 	__le16	BEACON_INTERVAL;
 	__le16	ATIM_WND;
 	__le16	BEACON_INTERVAL_TIME;
@@ -167,7 +215,8 @@ struct rtl818x_csr {
 	u8	reserved_17[24];
 	u8	CONFIG5;
 	u8	TX_DMA_POLLING;
-	u8	reserved_18[2];
+	u8	PHY_PR;
+	u8	reserved_18;
 	__le16	CWR;
 	u8	RETRY_CTR;
 	u8	reserved_19[3];
