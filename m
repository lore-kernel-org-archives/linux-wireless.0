Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43882 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab3LGLkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Dec 2013 06:40:35 -0500
Received: by mail-wg0-f44.google.com with SMTP id a1so1691003wgh.35
        for <linux-wireless@vger.kernel.org>; Sat, 07 Dec 2013 03:40:33 -0800 (PST)
Message-ID: <1386416428.11345.1.camel@canaries32-MCP7A> (sfid-20131207_124053_684947_3BE29EDD)
Subject: [PATCH v2 rebased] staging: vt6656: baseband.c clean up
 BBbVT3184Init
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 07 Dec 2013 11:40:28 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space clean up and remove camel case from variables.

pDevice-> priv
ntStatus -> status
wLength ->length
pbyAddr -> addr
pbyAgc -> agc
wLengthAgc ->length_agc
abyArray -> array

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 324 ++++++++++++++++++--------------------
 1 file changed, 155 insertions(+), 169 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 468f455..d3dd1a2 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -931,191 +931,177 @@ void BBvSetAntennaMode(struct vnt_private *pDevice, u8 byAntennaMode)
  *
  */
 
-int BBbVT3184Init(struct vnt_private *pDevice)
+int BBbVT3184Init(struct vnt_private *priv)
 {
-	int ntStatus;
-    u16                    wLength;
-    u8 *                   pbyAddr;
-    u8 *                   pbyAgc;
-    u16                    wLengthAgc;
-    u8                    abyArray[256];
+	int status;
+	u16 lenght;
+	u8 *addr;
+	u8 *agc;
+	u16 lenght_agc;
+	u8 array[256];
 	u8 data;
 
-    ntStatus = CONTROLnsRequestIn(pDevice,
-                                  MESSAGE_TYPE_READ,
-                                  0,
-                                  MESSAGE_REQUEST_EEPROM,
-                                  EEP_MAX_CONTEXT_SIZE,
-                                  pDevice->abyEEPROM);
-    if (ntStatus != STATUS_SUCCESS) {
-        return false;
-    }
+	status = CONTROLnsRequestIn(priv, MESSAGE_TYPE_READ, 0,
+		MESSAGE_REQUEST_EEPROM, EEP_MAX_CONTEXT_SIZE,
+						priv->abyEEPROM);
+	if (status != STATUS_SUCCESS)
+		return false;
+
+	/* zonetype initial */
+	priv->byOriginalZonetype = priv->abyEEPROM[EEP_OFS_ZONETYPE];
+
+	if (priv->config_file.ZoneType >= 0) {
+		if ((priv->config_file.ZoneType == 0) &&
+			(priv->abyEEPROM[EEP_OFS_ZONETYPE] != 0x00)) {
+			priv->abyEEPROM[EEP_OFS_ZONETYPE] = 0;
+			priv->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0B;
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+						"Init Zone Type :USA\n");
+		} else if ((priv->config_file.ZoneType == 1) &&
+			(priv->abyEEPROM[EEP_OFS_ZONETYPE] != 0x01)) {
+			priv->abyEEPROM[EEP_OFS_ZONETYPE] = 0x01;
+			priv->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+						"Init Zone Type :Japan\n");
+		} else if ((priv->config_file.ZoneType == 2) &&
+			(priv->abyEEPROM[EEP_OFS_ZONETYPE] != 0x02)) {
+			priv->abyEEPROM[EEP_OFS_ZONETYPE] = 0x02;
+			priv->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+						"Init Zone Type :Europe\n");
+		} else {
+			if (priv->config_file.ZoneType !=
+					priv->abyEEPROM[EEP_OFS_ZONETYPE])
+				printk("zonetype in file[%02x]\
+					 mismatch with in EEPROM[%02x]\n",
+					priv->config_file.ZoneType,
+					priv->abyEEPROM[EEP_OFS_ZONETYPE]);
+			else
+				printk("Read Zonetype file success,\
+					use default zonetype setting[%02x]\n",
+					priv->config_file.ZoneType);
+		}
+	}
 
-//    if ((pDevice->abyEEPROM[EEP_OFS_RADIOCTL]&0x06)==0x04)
-//        return false;
-
-//zonetype initial
- pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
- if(pDevice->config_file.ZoneType >= 0) {         //read zonetype file ok!
-  if ((pDevice->config_file.ZoneType == 0)&&
-        (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] !=0x00)){          //for USA
-    pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0;
-    pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0B;
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Init Zone Type :USA\n");
-  }
- else if((pDevice->config_file.ZoneType == 1)&&
- 	     (pDevice->abyEEPROM[EEP_OFS_ZONETYPE]!=0x01)){   //for Japan
-    pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0x01;
-    pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Init Zone Type :Japan\n");
-  }
- else if((pDevice->config_file.ZoneType == 2)&&
- 	     (pDevice->abyEEPROM[EEP_OFS_ZONETYPE]!=0x02)){   //for Europe
-    pDevice->abyEEPROM[EEP_OFS_ZONETYPE] = 0x02;
-    pDevice->abyEEPROM[EEP_OFS_MAXCHANNEL] = 0x0D;
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Init Zone Type :Europe\n");
-  }
-else {
-   if(pDevice->config_file.ZoneType !=pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
-      printk("zonetype in file[%02x] mismatch with in EEPROM[%02x]\n",pDevice->config_file.ZoneType,pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
-   else
-      printk("Read Zonetype file success,use default zonetype setting[%02x]\n",pDevice->config_file.ZoneType);
- }
-}
+	if (!priv->bZoneRegExist)
+		priv->byZoneType = priv->abyEEPROM[EEP_OFS_ZONETYPE];
+
+	priv->byRFType = priv->abyEEPROM[EEP_OFS_RFTYPE];
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Zone Type %x\n",
+							priv->byZoneType);
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RF Type %d\n", priv->byRFType);
+
+	if ((priv->byRFType == RF_AL2230) ||
+				(priv->byRFType == RF_AL2230S)) {
+		priv->byBBRxConf = abyVT3184_AL2230[10];
+		lenght = sizeof(abyVT3184_AL2230);
+		addr = abyVT3184_AL2230;
+		agc = abyVT3184_AGC;
+		lenght_agc = sizeof(abyVT3184_AGC);
+
+		priv->abyBBVGA[0] = 0x1C;
+		priv->abyBBVGA[1] = 0x10;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -70;
+		priv->ldBmThreshold[1] = -48;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
+	} else if (priv->byRFType == RF_AIROHA7230) {
+		priv->byBBRxConf = abyVT3184_AL2230[10];
+		lenght = sizeof(abyVT3184_AL2230);
+		addr = abyVT3184_AL2230;
+		agc = abyVT3184_AGC;
+		lenght_agc = sizeof(abyVT3184_AGC);
+
+		addr[0xd7] = 0x06;
+
+		priv->abyBBVGA[0] = 0x1c;
+		priv->abyBBVGA[1] = 0x10;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -70;
+		priv->ldBmThreshold[1] = -48;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
+	} else if ((priv->byRFType == RF_VT3226) ||
+			(priv->byRFType == RF_VT3226D0)) {
+		priv->byBBRxConf = abyVT3184_VT3226D0[10];
+		lenght = sizeof(abyVT3184_VT3226D0);
+		addr = abyVT3184_VT3226D0;
+		agc = abyVT3184_AGC;
+		lenght_agc = sizeof(abyVT3184_AGC);
+
+		priv->abyBBVGA[0] = 0x20;
+		priv->abyBBVGA[1] = 0x10;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -70;
+		priv->ldBmThreshold[1] = -48;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
+		/* Fix VT3226 DFC system timing issue */
+		MACvRegBitsOn(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
+	} else if ((priv->byRFType == RF_VT3342A0)) {
+		priv->byBBRxConf = abyVT3184_VT3226D0[10];
+		lenght = sizeof(abyVT3184_VT3226D0);
+		addr = abyVT3184_VT3226D0;
+		agc = abyVT3184_AGC;
+		lenght_agc = sizeof(abyVT3184_AGC);
+
+		priv->abyBBVGA[0] = 0x20;
+		priv->abyBBVGA[1] = 0x10;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -70;
+		priv->ldBmThreshold[1] = -48;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
+		/* Fix VT3226 DFC system timing issue */
+		MACvRegBitsOn(priv, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
+	} else {
+		return true;
+	}
 
-    if ( !pDevice->bZoneRegExist ) {
-        pDevice->byZoneType = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
-    }
-    pDevice->byRFType = pDevice->abyEEPROM[EEP_OFS_RFTYPE];
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Zone Type %x\n", pDevice->byZoneType);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"RF Type %d\n", pDevice->byRFType);
-
-    if ((pDevice->byRFType == RF_AL2230) || (pDevice->byRFType == RF_AL2230S)) {
-        pDevice->byBBRxConf = abyVT3184_AL2230[10];
-        wLength = sizeof(abyVT3184_AL2230);
-        pbyAddr = abyVT3184_AL2230;
-        pbyAgc = abyVT3184_AGC;
-        wLengthAgc = sizeof(abyVT3184_AGC);
-
-        pDevice->abyBBVGA[0] = 0x1C;
-        pDevice->abyBBVGA[1] = 0x10;
-        pDevice->abyBBVGA[2] = 0x0;
-        pDevice->abyBBVGA[3] = 0x0;
-        pDevice->ldBmThreshold[0] = -70;
-        pDevice->ldBmThreshold[1] = -48;
-        pDevice->ldBmThreshold[2] = 0;
-        pDevice->ldBmThreshold[3] = 0;
-    }
-    else if (pDevice->byRFType == RF_AIROHA7230) {
-        pDevice->byBBRxConf = abyVT3184_AL2230[10];
-        wLength = sizeof(abyVT3184_AL2230);
-        pbyAddr = abyVT3184_AL2230;
-        pbyAgc = abyVT3184_AGC;
-        wLengthAgc = sizeof(abyVT3184_AGC);
-
-        // Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-        //pbyAddr[0x09] = 0x41;
-        // Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted)
-        //pbyAddr[0x0a] = 0x28;
-        // Select VC1/VC2, CR215 = 0x02->0x06
-        pbyAddr[0xd7] = 0x06;
-
-        pDevice->abyBBVGA[0] = 0x1C;
-        pDevice->abyBBVGA[1] = 0x10;
-        pDevice->abyBBVGA[2] = 0x0;
-        pDevice->abyBBVGA[3] = 0x0;
-        pDevice->ldBmThreshold[0] = -70;
-        pDevice->ldBmThreshold[1] = -48;
-        pDevice->ldBmThreshold[2] = 0;
-        pDevice->ldBmThreshold[3] = 0;
-    }
-    else if ( (pDevice->byRFType == RF_VT3226) || (pDevice->byRFType == RF_VT3226D0) ) {
-        pDevice->byBBRxConf = abyVT3184_VT3226D0[10];   //RobertYu:20060515
-        wLength = sizeof(abyVT3184_VT3226D0);           //RobertYu:20060515
-        pbyAddr = abyVT3184_VT3226D0;                   //RobertYu:20060515
-        pbyAgc = abyVT3184_AGC;
-        wLengthAgc = sizeof(abyVT3184_AGC);
-
-        pDevice->abyBBVGA[0] = 0x20; //RobertYu:20060104, reguest by Jack
-        pDevice->abyBBVGA[1] = 0x10;
-        pDevice->abyBBVGA[2] = 0x0;
-        pDevice->abyBBVGA[3] = 0x0;
-        pDevice->ldBmThreshold[0] = -70;
-        pDevice->ldBmThreshold[1] = -48;
-        pDevice->ldBmThreshold[2] = 0;
-        pDevice->ldBmThreshold[3] = 0;
-        // Fix VT3226 DFC system timing issue
-        MACvRegBitsOn(pDevice, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
-    //}}
-    //{{RobertYu:20060609
-    } else if ( (pDevice->byRFType == RF_VT3342A0) ) {
-        pDevice->byBBRxConf = abyVT3184_VT3226D0[10];
-        wLength = sizeof(abyVT3184_VT3226D0);
-        pbyAddr = abyVT3184_VT3226D0;
-        pbyAgc = abyVT3184_AGC;
-        wLengthAgc = sizeof(abyVT3184_AGC);
-
-        pDevice->abyBBVGA[0] = 0x20;
-        pDevice->abyBBVGA[1] = 0x10;
-        pDevice->abyBBVGA[2] = 0x0;
-        pDevice->abyBBVGA[3] = 0x0;
-        pDevice->ldBmThreshold[0] = -70;
-        pDevice->ldBmThreshold[1] = -48;
-        pDevice->ldBmThreshold[2] = 0;
-        pDevice->ldBmThreshold[3] = 0;
-        // Fix VT3226 DFC system timing issue
-        MACvRegBitsOn(pDevice, MAC_REG_SOFTPWRCTL2, SOFTPWRCTL_RFLEOPT);
-    //}}
-    } else {
-        return true;
-    }
+	memcpy(array, addr, lenght);
 
-   memcpy(abyArray, pbyAddr, wLength);
-   CONTROLnsRequestOut(pDevice,
-                    MESSAGE_TYPE_WRITE,
-                    0,
-                    MESSAGE_REQUEST_BBREG,
-                    wLength,
-                    abyArray
-                    );
-
-   memcpy(abyArray, pbyAgc, wLengthAgc);
-   CONTROLnsRequestOut(pDevice,
-                    MESSAGE_TYPE_WRITE,
-                    0,
-                    MESSAGE_REQUEST_BBAGC,
-                    wLengthAgc,
-                    abyArray
-                    );
-
-    if ((pDevice->byRFType == RF_VT3226) || //RobertYu:20051116, 20060111 remove VT3226D0
-         (pDevice->byRFType == RF_VT3342A0)  //RobertYu:20060609
-         ) {
-        ControlvWriteByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_ITRTMSET,0x23);
-        MACvRegBitsOn(pDevice,MAC_REG_PAPEDELAY,0x01);
-    }
-    else if (pDevice->byRFType == RF_VT3226D0)
-    {
-        ControlvWriteByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_ITRTMSET,0x11);
-        MACvRegBitsOn(pDevice,MAC_REG_PAPEDELAY,0x01);
-    }
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, 0,
+		MESSAGE_REQUEST_BBREG, lenght, array);
+
+	memcpy(array, agc, lenght_agc);
+
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, 0,
+		MESSAGE_REQUEST_BBAGC, lenght_agc, array);
+
+	if ((priv->byRFType == RF_VT3226) ||
+		(priv->byRFType == RF_VT3342A0)) {
+		ControlvWriteByte(priv, MESSAGE_REQUEST_MACREG,
+						MAC_REG_ITRTMSET, 0x23);
+		MACvRegBitsOn(priv, MAC_REG_PAPEDELAY, 0x01);
+	} else if (priv->byRFType == RF_VT3226D0) {
+		ControlvWriteByte(priv, MESSAGE_REQUEST_MACREG,
+						MAC_REG_ITRTMSET, 0x11);
+		MACvRegBitsOn(priv, MAC_REG_PAPEDELAY, 0x01);
+	}
+
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x04, 0x7f);
+	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);
 
-    ControlvWriteByte(pDevice,MESSAGE_REQUEST_BBREG,0x04,0x7F);
-    ControlvWriteByte(pDevice,MESSAGE_REQUEST_BBREG,0x0D,0x01);
+	RFbRFTableDownload(priv);
 
-    RFbRFTableDownload(pDevice);
 
 	/* Fix for TX USB resets from vendors driver */
-	CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ, USB_REG4,
+	CONTROLnsRequestIn(priv, MESSAGE_TYPE_READ, USB_REG4,
 		MESSAGE_REQUEST_MEM, sizeof(data), &data);
 
 	data |= 0x2;
 
-	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE, USB_REG4,
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, USB_REG4,
 		MESSAGE_REQUEST_MEM, sizeof(data), &data);
 
-    return true;//ntStatus;
+	return true;
 }
 
 /*
-- 
1.8.5.1

