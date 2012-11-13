Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54986 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393Ab2KMR3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:29:05 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4133183eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:29:05 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 09/17] staging: rtl8187se: Removed unused parameters of HwHSSIThreeWire()
Date: Tue, 13 Nov 2012 19:28:15 +0200
Message-Id: <1352827703-4659-10-git-send-email-maxtram95@gmail.com> (sfid-20121113_182913_128739_466FC223)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed two parameters of HwHSSIThreeWire() that are equal in all
function calls, fixed return type, fixed register width and simplified
code

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8180_rtl8225.h |    4 +-
 drivers/staging/rtl8187se/r8185b_init.c   |  127 +++++++----------------------
 2 files changed, 31 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_rtl8225.h b/drivers/staging/rtl8187se/r8180_rtl8225.h
index 494ea86..c6f2128 100644
--- a/drivers/staging/rtl8187se/r8180_rtl8225.h
+++ b/drivers/staging/rtl8187se/r8180_rtl8225.h
@@ -23,8 +23,8 @@ void rtl8225z2_rf_init(struct net_device *dev);
 void rtl8225z2_rf_set_chan(struct net_device *dev, short ch);
 void rtl8225z2_rf_close(struct net_device *dev);
 
-void RF_WriteReg(struct net_device *dev, u8 offset, u32	data);
-u32 RF_ReadReg(struct net_device *dev, u8 offset);
+void RF_WriteReg(struct net_device *dev, u8 offset, u16 data);
+u16 RF_ReadReg(struct net_device *dev, u8 offset);
 
 void rtl8180_set_mode(struct net_device *dev, int mode);
 void rtl8180_set_mode(struct net_device *dev, int mode);
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index cf9bcd5..06a1c0b 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -207,13 +207,10 @@ void SetOutputEnableOfRfPins(struct net_device *dev)
 	write_nic_word(dev, RFPinsEnable, 0x1bff);
 }
 
-static int HwHSSIThreeWire(struct net_device *dev,
-			   u8 *pDataBuf,
-			   u8 nDataBufBitCnt,
-			   int bSI,
-			   int bWrite)
+static bool HwHSSIThreeWire(struct net_device *dev,
+			    u8 *pDataBuf,
+			    bool write)
 {
-	int	bResult = 1;
 	u8	TryCnt;
 	u8	u1bTmp;
 
@@ -228,77 +225,29 @@ static int HwHSSIThreeWire(struct net_device *dev,
 	if (TryCnt == TC_3W_POLL_MAX_TRY_CNT) {
 		printk(KERN_ERR "rtl8187se: HwThreeWire(): CmdReg:"
 		       " %#X RE|WE bits are not clear!!\n", u1bTmp);
-		dump_stack();
-		return 0;
+		return false;
 	}
 
 	/* RTL8187S HSSI Read/Write Function */
 	u1bTmp = read_nic_byte(dev, RF_SW_CONFIG);
-
-	if (bSI)
-		u1bTmp |=   RF_SW_CFG_SI; /* reg08[1]=1 Serial Interface(SI) */
-
-	else
-		u1bTmp &= ~RF_SW_CFG_SI; /* reg08[1]=0 Parallel Interface(PI) */
-
-
+	u1bTmp |= RF_SW_CFG_SI; /* reg08[1]=1 Serial Interface(SI) */
 	write_nic_byte(dev, RF_SW_CONFIG, u1bTmp);
 
-	if (bSI) {
-		/* jong: HW SI read must set reg84[3]=0. */
-		u1bTmp = read_nic_byte(dev, RFPinsSelect);
-		u1bTmp &= ~BIT3;
-		write_nic_byte(dev, RFPinsSelect, u1bTmp);
-	}
+	/* jong: HW SI read must set reg84[3]=0. */
+	u1bTmp = read_nic_byte(dev, RFPinsSelect);
+	u1bTmp &= ~BIT3;
+	write_nic_byte(dev, RFPinsSelect, u1bTmp);
 	/*  Fill up data buffer for write operation. */
 
-	if (bWrite) {
-		if (nDataBufBitCnt == 16) {
-			write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
-		} else if (nDataBufBitCnt == 64) {
-		/* RTL8187S shouldn't enter this case */
-			write_nic_dword(dev, SW_3W_DB0, *((u32 *)pDataBuf));
-			write_nic_dword(dev, SW_3W_DB1, *((u32 *)(pDataBuf + 4)));
-		} else {
-			int idx;
-			int ByteCnt = nDataBufBitCnt / 8;
-							/* printk("%d\n",nDataBufBitCnt); */
-			if ((nDataBufBitCnt % 8) != 0) {
-				printk(KERN_ERR "rtl8187se: "
-				       "HwThreeWire(): nDataBufBitCnt(%d)"
-				       " should be multiple of 8!!!\n",
-				       nDataBufBitCnt);
-				dump_stack();
-				nDataBufBitCnt += 8;
-				nDataBufBitCnt &= ~7;
-			}
-
-		       if (nDataBufBitCnt > 64) {
-				printk(KERN_ERR "rtl8187se: HwThreeWire():"
-				       " nDataBufBitCnt(%d) should <= 64!!!\n",
-				       nDataBufBitCnt);
-				dump_stack();
-				nDataBufBitCnt = 64;
-			}
-
-			for (idx = 0; idx < ByteCnt; idx++)
-				write_nic_byte(dev, (SW_3W_DB0+idx), *(pDataBuf+idx));
-
-		}
-	} else {	/* read */
-		if (bSI) {
-			/* SI - reg274[3:0] : RF register's Address */
-			write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
-		} else {
-			/*  PI - reg274[15:12] : RF register's Address */
-			write_nic_word(dev, SW_3W_DB0, (*((u16 *)pDataBuf)) << 12);
-		}
-	}
+	/* SI - reg274[3:0] : RF register's Address */
+	if (write)
+		write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
+	else
+		write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
 
 	/* Set up command: WE or RE. */
-	if (bWrite)
+	if (write)
 		write_nic_byte(dev, SW_3W_CMD1, SW_3W_CMD1_WE);
-
 	else
 		write_nic_byte(dev, SW_3W_CMD1, SW_3W_CMD1_RE);
 
@@ -306,7 +255,7 @@ static int HwHSSIThreeWire(struct net_device *dev,
 	/* Check if DONE is set. */
 	for (TryCnt = 0; TryCnt < TC_3W_POLL_MAX_TRY_CNT; TryCnt++) {
 		u1bTmp = read_nic_byte(dev, SW_3W_CMD1);
-		if ((u1bTmp & SW_3W_CMD1_DONE) != 0)
+		if (u1bTmp & SW_3W_CMD1_DONE)
 			break;
 
 		udelay(10);
@@ -315,45 +264,26 @@ static int HwHSSIThreeWire(struct net_device *dev,
 	write_nic_byte(dev, SW_3W_CMD1, 0);
 
 	/* Read back data for read operation. */
-	if (bWrite == 0) {
-		if (bSI) {
-			/* Serial Interface : reg363_362[11:0] */
-			*((u16 *)pDataBuf) = read_nic_word(dev, SI_DATA_READ) ;
-		} else {
-			/* Parallel Interface : reg361_360[11:0] */
-			*((u16 *)pDataBuf) = read_nic_word(dev, PI_DATA_READ);
-		}
-
+	if (!write) {
+		/* Serial Interface : reg363_362[11:0] */
+		*((u16 *)pDataBuf) = read_nic_word(dev, SI_DATA_READ);
 		*((u16 *)pDataBuf) &= 0x0FFF;
 	}
 
-	return bResult;
+	return true;
 }
 
-void RF_WriteReg(struct net_device *dev, u8 offset, u32 data)
+void RF_WriteReg(struct net_device *dev, u8 offset, u16 data)
 {
-	u32 data2Write;
-	u8 len;
-
-	/* Pure HW 3-wire. */
-	data2Write = (data << 4) | (u32)(offset & 0x0f);
-	len = 16;
-
-	HwHSSIThreeWire(dev, (u8 *)(&data2Write), len, 1, 1);
+	u16 reg = (data << 4) | (offset & 0x0f);
+	HwHSSIThreeWire(dev, (u8 *)&reg, true);
 }
 
-u32 RF_ReadReg(struct net_device *dev, u8 offset)
+u16 RF_ReadReg(struct net_device *dev, u8 offset)
 {
-	u32 data2Write;
-	u8 wlen;
-	u32 dataRead;
-
-	data2Write = ((u32)(offset & 0x0f));
-	wlen = 16;
-	HwHSSIThreeWire(dev, (u8 *)(&data2Write), wlen, 1, 0);
-	dataRead = data2Write;
-
-	return dataRead;
+	u16 reg = offset & 0x0f;
+	HwHSSIThreeWire(dev, (u8 *)&reg, false);
+	return reg;
 }
 
 
@@ -469,7 +399,8 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	u32			i;
 	u32	addr, data;
-	u32	u4bRegOffset, u4bRegValue, u4bRF23, u4bRF24;
+	u32 u4bRegOffset, u4bRegValue;
+	u16 u4bRF23, u4bRF24;
 	u8			u1b24E;
 	int d_cut = 0;
 
-- 
1.7.10.4

