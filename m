Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n7a.bullet.ukl.yahoo.com ([217.146.183.155]:20481 "HELO
	n7a.bullet.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751337AbYGHGdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 02:33:11 -0400
Message-ID: <48730C05.7060008@yahoo.co.uk> (sfid-20080708_083314_139846_28A50375)
Date: Tue, 08 Jul 2008 07:41:09 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@redhat.com>, flamingice@sourmilk.net,
	Andrea Merello <andreamrl@tiscali.it>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH 2/6] rtl8187: updating rtl818x.h to support RTL8187B
References: <4873088C.2090603@yahoo.co.uk>
In-Reply-To: <4873088C.2090603@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rtl8187: updating rtl818x.h to support RTL8187B

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
Signed-off-by: Pavel Roskin <proski@gnu.org>
---
diff --git a/drivers/net/wireless/rtl818x.h b/drivers/net/wireless/rtl818x.h
index 4f7d38f..85a6394 100644
--- a/drivers/net/wireless/rtl818x.h
+++ b/drivers/net/wireless/rtl818x.h
@@ -66,7 +66,10 @@ struct rtl818x_csr {
  #define RTL818X_TX_CONF_R8180_F		(3 << 25)
  #define RTL818X_TX_CONF_R8185_ABC	(4 << 25)
  #define RTL818X_TX_CONF_R8185_D		(5 << 25)
+#define RTL818X_TX_CONF_R8187vD_1	(5 << 25)
+#define RTL818X_TX_CONF_R8187vD_2	(6 << 25)
  #define RTL818X_TX_CONF_HWVER_MASK	(7 << 25)
+#define RTL818X_TX_CONF_DISREQQSIZE	(1 << 28)
  #define RTL818X_TX_CONF_PROBE_DTS	(1 << 29)
  #define RTL818X_TX_CONF_HW_SEQNUM	(1 << 30)
  #define RTL818X_TX_CONF_CW_MIN		(1 << 31)
@@ -106,8 +109,11 @@ struct rtl818x_csr {
  #define RTL818X_MSR_NO_LINK		(0 << 2)
  #define RTL818X_MSR_ADHOC		(1 << 2)
  #define RTL818X_MSR_INFRA		(2 << 2)
+#define RTL818X_MSR_MASTER		(3 << 2)
+#define RTL818X_MSR_ENEDCA		(4 << 2)
  	u8	CONFIG3;
  #define RTL818X_CONFIG3_ANAPARAM_WRITE	(1 << 6)
+#define RTL818X_CONFIG3_GNT_SELECT	(1 << 7)
  	u8	CONFIG4;
  #define RTL818X_CONFIG4_POWEROFF	(1 << 6)
  #define RTL818X_CONFIG4_VCOOFF		(1 << 7)
@@ -133,7 +139,9 @@ struct rtl818x_csr {
  	__le32	RF_TIMING;
  	u8	GP_ENABLE;
  	u8	GPIO;
-	u8	reserved_12[10];
+	u8	reserved_12[2];
+	__le32	HSSI_PARA;
+	u8	reserved_13[4];
  	u8	TX_AGC_CTL;
  #define RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT		(1 << 0)
  #define RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT	(1 << 1)
@@ -141,29 +149,39 @@ struct rtl818x_csr {
  	u8	TX_GAIN_CCK;
  	u8	TX_GAIN_OFDM;
  	u8	TX_ANTENNA;
-	u8	reserved_13[16];
+	u8	reserved_14[16];
  	u8	WPA_CONF;
-	u8	reserved_14[3];
+	u8	reserved_15[3];
  	u8	SIFS;
  	u8	DIFS;
  	u8	SLOT;
-	u8	reserved_15[5];
+	u8	reserved_16[5];
  	u8	CW_CONF;
  #define RTL818X_CW_CONF_PERPACKET_CW_SHIFT	(1 << 0)
  #define RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT	(1 << 1)
  	u8	CW_VAL;
  	u8	RATE_FALLBACK;
-	u8	reserved_16[25];
+#define RTL818X_RATE_FALLBACK_ENABLE	(1 << 7)
+	u8	ACM_CONTROL;
+	u8	reserved_17[24];
  	u8	CONFIG5;
  	u8	TX_DMA_POLLING;
-	u8	reserved_17[2];
+	u8	reserved_18[2];
  	__le16	CWR;
  	u8	RETRY_CTR;
-	u8	reserved_18[5];
+	u8	reserved_19[3];
+	__le16	INT_MIG;
+/* RTL818X_R8187B_*: magic numbers from ioregisters */
+#define RTL818X_R8187B_B	0
+#define RTL818X_R8187B_D	1
+#define RTL818X_R8187B_E	2
  	__le32	RDSAR;
-	u8	reserved_19[12];
-	__le16	FEMR;
+	__le16	TID_AC_MAP;
  	u8	reserved_20[4];
+	u8	ANAPARAM3;
+	u8	reserved_21[5];
+	__le16	FEMR;
+	u8	reserved_22[4];
  	__le16	TALLY_CNT;
  	u8	TALLY_SEL;
  } __attribute__((packed));

