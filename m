Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54986 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab2KMR2y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 12:28:54 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so4133183eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 09:28:54 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 03/17] staging: rtl8187se: Removed empty functions and one-iteration loop
Date: Tue, 13 Nov 2012 19:28:09 +0200
Message-Id: <1352827703-4659-4-git-send-email-maxtram95@gmail.com> (sfid-20121113_182900_712711_8747486E)
In-Reply-To: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
References: <1352827703-4659-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removed empty functions, their calls and 'do {} while (0)' loop
condition

Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |  210 +++++++++++++------------------
 1 file changed, 89 insertions(+), 121 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index bf34319..8fa42de 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -217,118 +217,115 @@ static int HwHSSIThreeWire(struct net_device *dev,
 	u8	TryCnt;
 	u8	u1bTmp;
 
-	do {
-		/* Check if WE and RE are cleared. */
-		for (TryCnt = 0; TryCnt < TC_3W_POLL_MAX_TRY_CNT; TryCnt++) {
-			u1bTmp = read_nic_byte(dev, SW_3W_CMD1);
-			if ((u1bTmp & (SW_3W_CMD1_RE|SW_3W_CMD1_WE)) == 0)
-				break;
+	/* Check if WE and RE are cleared. */
+	for (TryCnt = 0; TryCnt < TC_3W_POLL_MAX_TRY_CNT; TryCnt++) {
+		u1bTmp = read_nic_byte(dev, SW_3W_CMD1);
+		if ((u1bTmp & (SW_3W_CMD1_RE|SW_3W_CMD1_WE)) == 0)
+			break;
 
-			udelay(10);
-		}
-		if (TryCnt == TC_3W_POLL_MAX_TRY_CNT) {
-			printk(KERN_ERR "rtl8187se: HwThreeWire(): CmdReg:"
-			       " %#X RE|WE bits are not clear!!\n", u1bTmp);
-			dump_stack();
-			return 0;
-		}
+		udelay(10);
+	}
+	if (TryCnt == TC_3W_POLL_MAX_TRY_CNT) {
+		printk(KERN_ERR "rtl8187se: HwThreeWire(): CmdReg:"
+		       " %#X RE|WE bits are not clear!!\n", u1bTmp);
+		dump_stack();
+		return 0;
+	}
 
-		/* RTL8187S HSSI Read/Write Function */
-		u1bTmp = read_nic_byte(dev, RF_SW_CONFIG);
+	/* RTL8187S HSSI Read/Write Function */
+	u1bTmp = read_nic_byte(dev, RF_SW_CONFIG);
 
-		if (bSI)
-			u1bTmp |=   RF_SW_CFG_SI; /* reg08[1]=1 Serial Interface(SI) */
+	if (bSI)
+		u1bTmp |=   RF_SW_CFG_SI; /* reg08[1]=1 Serial Interface(SI) */
 
-		else
-			u1bTmp &= ~RF_SW_CFG_SI; /* reg08[1]=0 Parallel Interface(PI) */
+	else
+		u1bTmp &= ~RF_SW_CFG_SI; /* reg08[1]=0 Parallel Interface(PI) */
 
 
-		write_nic_byte(dev, RF_SW_CONFIG, u1bTmp);
+	write_nic_byte(dev, RF_SW_CONFIG, u1bTmp);
 
-		if (bSI) {
-			/* jong: HW SI read must set reg84[3]=0. */
-			u1bTmp = read_nic_byte(dev, RFPinsSelect);
-			u1bTmp &= ~BIT3;
-			write_nic_byte(dev, RFPinsSelect, u1bTmp);
-		}
-		/*  Fill up data buffer for write operation. */
-
-		if (bWrite) {
-			if (nDataBufBitCnt == 16) {
-				write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
-			} else if (nDataBufBitCnt == 64) {
-			/* RTL8187S shouldn't enter this case */
-				write_nic_dword(dev, SW_3W_DB0, *((u32 *)pDataBuf));
-				write_nic_dword(dev, SW_3W_DB1, *((u32 *)(pDataBuf + 4)));
-			} else {
-				int idx;
-				int ByteCnt = nDataBufBitCnt / 8;
-								/* printk("%d\n",nDataBufBitCnt); */
-				if ((nDataBufBitCnt % 8) != 0) {
-					printk(KERN_ERR "rtl8187se: "
-					       "HwThreeWire(): nDataBufBitCnt(%d)"
-					       " should be multiple of 8!!!\n",
-					       nDataBufBitCnt);
-					dump_stack();
-					nDataBufBitCnt += 8;
-					nDataBufBitCnt &= ~7;
-				}
+	if (bSI) {
+		/* jong: HW SI read must set reg84[3]=0. */
+		u1bTmp = read_nic_byte(dev, RFPinsSelect);
+		u1bTmp &= ~BIT3;
+		write_nic_byte(dev, RFPinsSelect, u1bTmp);
+	}
+	/*  Fill up data buffer for write operation. */
+
+	if (bWrite) {
+		if (nDataBufBitCnt == 16) {
+			write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
+		} else if (nDataBufBitCnt == 64) {
+		/* RTL8187S shouldn't enter this case */
+			write_nic_dword(dev, SW_3W_DB0, *((u32 *)pDataBuf));
+			write_nic_dword(dev, SW_3W_DB1, *((u32 *)(pDataBuf + 4)));
+		} else {
+			int idx;
+			int ByteCnt = nDataBufBitCnt / 8;
+							/* printk("%d\n",nDataBufBitCnt); */
+			if ((nDataBufBitCnt % 8) != 0) {
+				printk(KERN_ERR "rtl8187se: "
+				       "HwThreeWire(): nDataBufBitCnt(%d)"
+				       " should be multiple of 8!!!\n",
+				       nDataBufBitCnt);
+				dump_stack();
+				nDataBufBitCnt += 8;
+				nDataBufBitCnt &= ~7;
+			}
 
-			       if (nDataBufBitCnt > 64) {
-					printk(KERN_ERR "rtl8187se: HwThreeWire():"
-					       " nDataBufBitCnt(%d) should <= 64!!!\n",
-					       nDataBufBitCnt);
-					dump_stack();
-					nDataBufBitCnt = 64;
-				}
+		       if (nDataBufBitCnt > 64) {
+				printk(KERN_ERR "rtl8187se: HwThreeWire():"
+				       " nDataBufBitCnt(%d) should <= 64!!!\n",
+				       nDataBufBitCnt);
+				dump_stack();
+				nDataBufBitCnt = 64;
+			}
 
-				for (idx = 0; idx < ByteCnt; idx++)
-					write_nic_byte(dev, (SW_3W_DB0+idx), *(pDataBuf+idx));
+			for (idx = 0; idx < ByteCnt; idx++)
+				write_nic_byte(dev, (SW_3W_DB0+idx), *(pDataBuf+idx));
 
-			}
-		} else {	/* read */
-			if (bSI) {
-				/* SI - reg274[3:0] : RF register's Address */
-				write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
-			} else {
-				/*  PI - reg274[15:12] : RF register's Address */
-				write_nic_word(dev, SW_3W_DB0, (*((u16 *)pDataBuf)) << 12);
-			}
 		}
+	} else {	/* read */
+		if (bSI) {
+			/* SI - reg274[3:0] : RF register's Address */
+			write_nic_word(dev, SW_3W_DB0, *((u16 *)pDataBuf));
+		} else {
+			/*  PI - reg274[15:12] : RF register's Address */
+			write_nic_word(dev, SW_3W_DB0, (*((u16 *)pDataBuf)) << 12);
+		}
+	}
 
-		/* Set up command: WE or RE. */
-		if (bWrite)
-			write_nic_byte(dev, SW_3W_CMD1, SW_3W_CMD1_WE);
+	/* Set up command: WE or RE. */
+	if (bWrite)
+		write_nic_byte(dev, SW_3W_CMD1, SW_3W_CMD1_WE);
 
-		else
-			write_nic_byte(dev, SW_3W_CMD1, SW_3W_CMD1_RE);
+	else
+		write_nic_byte(dev, SW_3W_CMD1, SW_3W_CMD1_RE);
 
 
-		/* Check if DONE is set. */
-		for (TryCnt = 0; TryCnt < TC_3W_POLL_MAX_TRY_CNT; TryCnt++) {
-			u1bTmp = read_nic_byte(dev, SW_3W_CMD1);
-			if ((u1bTmp & SW_3W_CMD1_DONE) != 0)
-				break;
-
-			udelay(10);
-		}
+	/* Check if DONE is set. */
+	for (TryCnt = 0; TryCnt < TC_3W_POLL_MAX_TRY_CNT; TryCnt++) {
+		u1bTmp = read_nic_byte(dev, SW_3W_CMD1);
+		if ((u1bTmp & SW_3W_CMD1_DONE) != 0)
+			break;
 
-		write_nic_byte(dev, SW_3W_CMD1, 0);
+		udelay(10);
+	}
 
-		/* Read back data for read operation. */
-		if (bWrite == 0) {
-			if (bSI) {
-				/* Serial Interface : reg363_362[11:0] */
-				*((u16 *)pDataBuf) = read_nic_word(dev, SI_DATA_READ) ;
-			} else {
-				/* Parallel Interface : reg361_360[11:0] */
-				*((u16 *)pDataBuf) = read_nic_word(dev, PI_DATA_READ);
-			}
+	write_nic_byte(dev, SW_3W_CMD1, 0);
 
-			*((u16 *)pDataBuf) &= 0x0FFF;
+	/* Read back data for read operation. */
+	if (bWrite == 0) {
+		if (bSI) {
+			/* Serial Interface : reg363_362[11:0] */
+			*((u16 *)pDataBuf) = read_nic_word(dev, SI_DATA_READ) ;
+		} else {
+			/* Parallel Interface : reg361_360[11:0] */
+			*((u16 *)pDataBuf) = read_nic_word(dev, PI_DATA_READ);
 		}
 
-	} while (0);
+		*((u16 *)pDataBuf) &= 0x0FFF;
+	}
 
 	return bResult;
 }
@@ -1148,18 +1145,11 @@ void rtl8185b_irq_enable(struct net_device *dev)
 	write_nic_dword(dev, IMR, priv->IntrMask);
 }
 
-void DrvIFIndicateDisassociation(struct net_device *dev, u16 reason)
-{
-		/* nothing is needed after disassociation request. */
-}
-
 void MgntDisconnectIBSS(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 	u8 i;
 
-	DrvIFIndicateDisassociation(dev, unspec_reason);
-
 	for (i = 0; i < 6 ; i++)
 		priv->ieee80211->current_network.bssid[i] = 0x55;
 
@@ -1190,8 +1180,6 @@ void MlmeDisassociateRequest(struct net_device *dev, u8 *asSta, u8 asRsn)
 
 	if (memcmp(priv->ieee80211->current_network.bssid, asSta, 6) == 0) {
 		/* ShuChen TODO: change media status. */
-		/* ShuChen TODO: What to do when disassociate. */
-		DrvIFIndicateDisassociation(dev, unspec_reason);
 
 		for (i = 0; i < 6; i++)
 			priv->ieee80211->current_network.bssid[i] = 0x22;
@@ -1267,14 +1255,6 @@ bool SetRFPowerState(struct net_device *dev, RT_RF_POWER_STATE eRFPowerState)
 	return bResult;
 }
 
-void HalEnableRx8185Dummy(struct net_device *dev)
-{
-}
-
-void HalDisableRx8185Dummy(struct net_device *dev)
-{
-}
-
 bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u32 ChangeSource)
 {
 	struct	r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -1359,18 +1339,6 @@ bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u
 	if (bActionAllowed) {
 		/* Config HW to the specified mode. */
 		SetRFPowerState(dev, StateToSet);
-
-		/* Turn on RF.	*/
-		if (StateToSet == eRfOn) {
-			HalEnableRx8185Dummy(dev);
-			if (bConnectBySSID) {
-				/* by amy not supported	*/
-			}
-		}
-		/* Turn off RF.	*/
-		else if (StateToSet == eRfOff)
-			HalDisableRx8185Dummy(dev);
-
 	}
 
 	/* Release RF spinlock	*/
-- 
1.7.10.4

