Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53888 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab2KLV7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:59:04 -0500
Received: by mail-ea0-f174.google.com with SMTP id o11so438703eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:59:04 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 09/17] Removed unused parameters of HwHSSIThreeWire()
Date: Mon, 12 Nov 2012 23:58:23 +0200
Message-Id: <1352757511-26957-10-git-send-email-maxtram95@gmail.com> (sfid-20121112_225911_278179_F7936EDF)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180_rtl8225.h |    2 +-
 r8185b_init.c   |  122 ++++++++++++-------------------------------------------
 2 files changed, 27 insertions(+), 97 deletions(-)

diff --git a/r8180_rtl8225.h b/r8180_rtl8225.h
index 494ea86..89a9c07 100644
--- a/r8180_rtl8225.h
+++ b/r8180_rtl8225.h
@@ -23,7 +23,7 @@ void rtl8225z2_rf_init(struct net_device *dev);
 void rtl8225z2_rf_set_chan(struct net_device *dev, short ch);
 void rtl8225z2_rf_close(struct net_device *dev);
 
-void RF_WriteReg(struct net_device *dev, u8 offset, u32	data);
+void RF_WriteReg(struct net_device *dev, u8 offset, u16 data);
 u32 RF_ReadReg(struct net_device *dev, u8 offset);
 
 void rtl8180_set_mode(struct net_device *dev, int mode);
diff --git a/r8185b_init.c b/r8185b_init.c
index 0b5c34b..52e6802 100644
--- a/r8185b_init.c
+++ b/r8185b_init.c
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
 
 u32 RF_ReadReg(struct net_device *dev, u8 offset)
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
 
 
-- 
1.7.10.4

