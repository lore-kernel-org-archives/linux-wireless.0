Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64829 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaEZNAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:08 -0400
Received: by mail-wi0-f171.google.com with SMTP id cc10so4232636wib.16
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 04/11] staging: vt6656: rename PIPEnsControlOut/CONTROLnsRequestOut to vnt_control_out
Date: Mon, 26 May 2014 13:59:01 +0100
Message-Id: <1401109148-3593-4-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150020_422962_C7F14261)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename all CONTROLnsRequestOut and remove macro from control.h

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c |  8 ++++----
 drivers/staging/vt6656/card.c     | 14 +++++++-------
 drivers/staging/vt6656/control.c  |  6 +++---
 drivers/staging/vt6656/control.h  |  3 ---
 drivers/staging/vt6656/firmware.c |  4 ++--
 drivers/staging/vt6656/key.c      | 23 +++++++----------------
 drivers/staging/vt6656/mac.c      | 28 ++++++++++++++--------------
 drivers/staging/vt6656/main_usb.c |  2 +-
 drivers/staging/vt6656/power.c    |  2 +-
 drivers/staging/vt6656/rf.c       | 12 ++++++------
 drivers/staging/vt6656/usbpipe.c  |  4 ++--
 drivers/staging/vt6656/usbpipe.h  |  3 +--
 drivers/staging/vt6656/wcmd.c     |  2 +-
 13 files changed, 49 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 309a3cb..8a509d8 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -865,7 +865,7 @@ void BBvSetAntennaMode(struct vnt_private *priv, u8 antenna_mode)
 		break;
 	}
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SET_ANTMD,
+	vnt_control_out(priv, MESSAGE_TYPE_SET_ANTMD,
 		(u16)antenna_mode, 0, 0, NULL);
 }
 
@@ -1018,12 +1018,12 @@ int BBbVT3184Init(struct vnt_private *priv)
 
 	memcpy(array, addr, length);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, 0,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE, 0,
 		MESSAGE_REQUEST_BBREG, length, array);
 
 	memcpy(array, agc, length_agc);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, 0,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE, 0,
 		MESSAGE_REQUEST_BBAGC, length_agc, array);
 
 	if ((priv->byRFType == RF_VT3226) ||
@@ -1049,7 +1049,7 @@ int BBbVT3184Init(struct vnt_private *priv)
 
 	data |= 0x2;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, USB_REG4,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE, USB_REG4,
 		MESSAGE_REQUEST_MEM, sizeof(data), &data);
 
 	return true;
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 6da912b..1f20e9a 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -94,7 +94,7 @@ void CARDbSetMediaChannel(struct vnt_private *priv, u32 connection_channel)
 	/* Set Channel[7] = 0 to tell H/W channel is changing now. */
 	MACvRegBitsOff(priv, MAC_REG_CHANNEL, 0xb0);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SELECT_CHANNLE,
+	vnt_control_out(priv, MESSAGE_TYPE_SELECT_CHANNLE,
 					connection_channel, 0, 0, NULL);
 
 	if (priv->byBBType == BB_TYPE_11A) {
@@ -373,7 +373,7 @@ void CARDvSetRSPINF(struct vnt_private *priv, u8 bb_type)
 		data[16 + i * 2 + 1] = rsv_time[i];
 	}
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE,
 		MAC_REG_RSPINF_B_1, MESSAGE_REQUEST_MACREG, 34, &data[0]);
 }
 
@@ -461,12 +461,12 @@ void vUpdateIFS(struct vnt_private *priv)
 	data[2] = (u8)priv->uEIFS;
 	data[3] = (u8)priv->uSlot;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_SIFS,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE, MAC_REG_SIFS,
 		MESSAGE_REQUEST_MACREG, 4, &data[0]);
 
 	max_min |= 0xa0;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_CWMAXMIN0,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE, MAC_REG_CWMAXMIN0,
 		MESSAGE_REQUEST_MACREG, 1, &max_min);
 }
 
@@ -603,7 +603,7 @@ void CARDvAdjustTSF(struct vnt_private *priv, u8 rx_rate,
 	data[6] = (u8)(tsf_offset >> 48);
 	data[7] = (u8)(tsf_offset >> 56);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SET_TSFTBTT,
+	vnt_control_out(priv, MESSAGE_TYPE_SET_TSFTBTT,
 		MESSAGE_REQUEST_TSF, 0, 8, data);
 }
 /*
@@ -712,7 +712,7 @@ void CARDvSetFirstNextTBTT(struct vnt_private *priv, u16 beacon_interval)
 	data[6] = (u8)(next_tbtt >> 48);
 	data[7] = (u8)(next_tbtt >> 56);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SET_TSFTBTT,
+	vnt_control_out(priv, MESSAGE_TYPE_SET_TSFTBTT,
 		MESSAGE_REQUEST_TBTT, 0, 8, data);
 
 	return;
@@ -749,7 +749,7 @@ void CARDvUpdateNextTBTT(struct vnt_private *priv, u64 tsf,
 	data[6] = (u8)(tsf >> 48);
 	data[7] = (u8)(tsf >> 56);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SET_TSFTBTT,
+	vnt_control_out(priv, MESSAGE_TYPE_SET_TSFTBTT,
 		MESSAGE_REQUEST_TBTT, 0, 8, data);
 
 	dev_dbg(&priv->usb->dev, "%s TBTT: %8llx\n", __func__, tsf);
diff --git a/drivers/staging/vt6656/control.c b/drivers/staging/vt6656/control.c
index fc19166..0740521 100644
--- a/drivers/staging/vt6656/control.c
+++ b/drivers/staging/vt6656/control.c
@@ -26,7 +26,7 @@
  * Date: Apr. 5, 2004
  *
  * Functions:
- *      CONTROLnsRequestOut - Write variable length bytes to MEM/BB/MAC/EEPROM
+ *      vnt_control_out - Write variable length bytes to MEM/BB/MAC/EEPROM
  *      CONTROLnsRequestIn - Read variable length bytes from MEM/BB/MAC/EEPROM
  *      ControlvWriteByte - Write one byte to MEM/BB/MAC/EEPROM
  *      ControlvReadByte - Read one byte from MEM/BB/MAC/EEPROM
@@ -49,7 +49,7 @@ void ControlvWriteByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
 			u8 data)
 {
 
-	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE, reg_off, reg,
+	vnt_control_out(pDevice, MESSAGE_TYPE_WRITE, reg_off, reg,
 		sizeof(u8), &data);
 
 	return;
@@ -71,7 +71,7 @@ void ControlvMaskByte(struct vnt_private *pDevice, u8 reg_type, u8 reg_off,
 	reg_data[0] = data;
 	reg_data[1] = reg_mask;
 
-	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_WRITE_MASK, reg_off,
+	vnt_control_out(pDevice, MESSAGE_TYPE_WRITE_MASK, reg_off,
 			reg_type, ARRAY_SIZE(reg_data), reg_data);
 
 	return;
diff --git a/drivers/staging/vt6656/control.h b/drivers/staging/vt6656/control.h
index 4658910..17a23d5 100644
--- a/drivers/staging/vt6656/control.h
+++ b/drivers/staging/vt6656/control.h
@@ -33,9 +33,6 @@
 #include "device.h"
 #include "usbpipe.h"
 
-#define CONTROLnsRequestOut(Device, Request, Value, Index, Length, Buffer) \
-	PIPEnsControlOut(Device, Request, Value, Index, Length, Buffer)
-
 #define CONTROLnsRequestIn(Device, Request, Value, Index, Length, Buffer) \
 	PIPEnsControlIn(Device, Request, Value, Index, Length, Buffer)
 
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 1d3d268..13b68d5 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -70,7 +70,7 @@ int FIRMWAREbDownload(struct vnt_private *pDevice)
 		wLength = min_t(int, fw->size - ii, FIRMWARE_CHUNK_SIZE);
 		memcpy(pBuffer, fw->data + ii, wLength);
 
-		NdisStatus = CONTROLnsRequestOut(pDevice,
+		NdisStatus = vnt_control_out(pDevice,
 						0,
 						0x1200+ii,
 						0x0000,
@@ -100,7 +100,7 @@ int FIRMWAREbBrach2Sram(struct vnt_private *pDevice)
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"---->Branch to Sram\n");
 
-	NdisStatus = CONTROLnsRequestOut(pDevice,
+	NdisStatus = vnt_control_out(pDevice,
 					1,
 					0x1200,
 					0x0000,
diff --git a/drivers/staging/vt6656/key.c b/drivers/staging/vt6656/key.c
index 9283612..11aa82a 100644
--- a/drivers/staging/vt6656/key.c
+++ b/drivers/staging/vt6656/key.c
@@ -67,15 +67,10 @@ static void s_vCheckKeyTableValid(struct vnt_private *pDevice,
             //MACvDisableKeyEntry(pDevice, i);
         }
     }
-    if ( wLength != 0 ) {
-        CONTROLnsRequestOut(pDevice,
-                            MESSAGE_TYPE_CLRKEYENTRY,
-                            0,
-                            0,
-                            wLength,
-                            pbyData
-                            );
-    }
+
+	if (wLength != 0)
+		vnt_control_out(pDevice, MESSAGE_TYPE_CLRKEYENTRY,
+			0, 0, wLength, pbyData);
 
 }
 
@@ -112,13 +107,9 @@ void KeyvInitTable(struct vnt_private *pDevice, PSKeyManagement pTable)
         pbyData[i] = (u8) i;
     }
     pbyData[i] = (u8) i;
-    CONTROLnsRequestOut(pDevice,
-                        MESSAGE_TYPE_CLRKEYENTRY,
-                        0,
-                        0,
-                        11,
-                        pbyData
-                        );
+
+	vnt_control_out(pDevice, MESSAGE_TYPE_CLRKEYENTRY,
+			0, 0, 11, pbyData);
 
     return;
 }
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 9211ec1..51e4a355 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -54,7 +54,7 @@ void MACvWriteMultiAddr(struct vnt_private *priv, u64 mc_filter)
 {
 	__le64 le_mc = cpu_to_le64(mc_filter);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_MAR0,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE, MAC_REG_MAR0,
 		MESSAGE_REQUEST_MACREG, sizeof(le_mc), (u8 *)&le_mc);
 }
 
@@ -71,7 +71,7 @@ void MACvWriteMultiAddr(struct vnt_private *priv, u64 mc_filter)
  */
 void MACbShutdown(struct vnt_private *priv)
 {
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_MACSHUTDOWN, 0, 0, 0, NULL);
+	vnt_control_out(priv, MESSAGE_TYPE_MACSHUTDOWN, 0, 0, 0, NULL);
 }
 
 void MACvSetBBType(struct vnt_private *priv, u8 type)
@@ -81,7 +81,7 @@ void MACvSetBBType(struct vnt_private *priv, u8 type)
 	data[0] = type;
 	data[1] = EnCFG_BBType_MASK;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK, MAC_REG_ENCFG0,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE_MASK, MAC_REG_ENCFG0,
 		MESSAGE_REQUEST_MACREG,	ARRAY_SIZE(data), data);
 }
 
@@ -101,7 +101,7 @@ void MACvSetBBType(struct vnt_private *priv, u8 type)
  */
 void MACvDisableKeyEntry(struct vnt_private *priv, u8 entry_idx)
 {
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_CLRKEYENTRY, 0, 0,
+	vnt_control_out(priv, MESSAGE_TYPE_CLRKEYENTRY, 0, 0,
 		sizeof(entry_idx), &entry_idx);
 }
 
@@ -143,7 +143,7 @@ void MACvSetKeyEntry(struct vnt_private *priv, u16 key_ctl, u32 entry_idx,
 	dev_dbg(&priv->usb->dev, "offset %d key ctl %d set key %24ph\n",
 				offset, key_ctl, (u8 *)&set_key);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SETKEY, offset,
+	vnt_control_out(priv, MESSAGE_TYPE_SETKEY, offset,
 		(u16)key_idx, sizeof(struct vnt_mac_set_key), (u8 *)&set_key);
 }
 
@@ -154,7 +154,7 @@ void MACvRegBitsOff(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 	data[0] = 0;
 	data[1] = bits;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE_MASK,
 		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
@@ -165,7 +165,7 @@ void MACvRegBitsOn(struct vnt_private *priv, u8 reg_ofs, u8 bits)
 	data[0] = bits;
 	data[1] = bits;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE_MASK,
 		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
@@ -176,13 +176,13 @@ void MACvWriteWord(struct vnt_private *priv, u8 reg_ofs, u16 word)
 	data[0] = (u8)(word & 0xff);
 	data[1] = (u8)(word >> 8);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE,
 		reg_ofs, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
 void MACvWriteBSSIDAddress(struct vnt_private *priv, u8 *addr)
 {
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, MAC_REG_BSSID0,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE, MAC_REG_BSSID0,
 		MESSAGE_REQUEST_MACREG, ETH_ALEN, addr);
 }
 
@@ -193,7 +193,7 @@ void MACvEnableProtectMD(struct vnt_private *priv)
 	data[0] = EnCFG_ProtectMd;
 	data[1] = EnCFG_ProtectMd;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE_MASK,
 		MAC_REG_ENCFG0, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
@@ -204,7 +204,7 @@ void MACvDisableProtectMD(struct vnt_private *priv)
 	data[0] = 0;
 	data[1] = EnCFG_ProtectMd;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE_MASK,
 		MAC_REG_ENCFG0, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
@@ -215,7 +215,7 @@ void MACvEnableBarkerPreambleMd(struct vnt_private *priv)
 	data[0] = EnCFG_BarkerPream;
 	data[1] = EnCFG_BarkerPream;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE_MASK,
 		MAC_REG_ENCFG2, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
@@ -226,7 +226,7 @@ void MACvDisableBarkerPreambleMd(struct vnt_private *priv)
 	data[0] = 0;
 	data[1] = EnCFG_BarkerPream;
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE_MASK,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE_MASK,
 		MAC_REG_ENCFG2, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
 
@@ -237,6 +237,6 @@ void MACvWriteBeaconInterval(struct vnt_private *priv, u16 interval)
 	data[0] = (u8)(interval & 0xff);
 	data[1] = (u8)(interval >> 8);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE,
 		MAC_REG_BI, MESSAGE_REQUEST_MACREG, ARRAY_SIZE(data), data);
 }
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ed04804..9e70aa5 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -314,7 +314,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 	init_cmd->long_retry_limit = pDevice->byLongRetryLimit;
 
 	/* issue card_init command to device */
-	ntStatus = CONTROLnsRequestOut(pDevice,
+	ntStatus = vnt_control_out(pDevice,
 		MESSAGE_TYPE_CARDINIT, 0, 0,
 		sizeof(struct vnt_cmd_card_init), (u8 *)init_cmd);
 	if (ntStatus != STATUS_SUCCESS) {
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index c4bea74..a5cea43 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -129,7 +129,7 @@ void PSvDisablePowerSaving(struct vnt_private *pDevice)
 {
 
 	/* disable power saving hw function */
-	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_DISABLE_PS, 0,
+	vnt_control_out(pDevice, MESSAGE_TYPE_DISABLE_PS, 0,
 						0, 0, NULL);
 
 	/* clear AutoSleep */
diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 7217f2c..58ea16c 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -715,7 +715,7 @@ int IFRFbWriteEmbedded(struct vnt_private *pDevice, u32 dwData)
 	pbyData[2] = (u8)(dwData >> 16);
 	pbyData[3] = (u8)(dwData >> 24);
 
-	CONTROLnsRequestOut(pDevice,
+	vnt_control_out(pDevice,
 		MESSAGE_TYPE_WRITE_IFRF, 0, 0, 4, pbyData);
 
 	return true;
@@ -1046,7 +1046,7 @@ void RFbRFTableDownload(struct vnt_private *priv)
 	/* Init Table */
 	memcpy(array, addr1, length1);
 
-	CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE, 0,
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE, 0,
 		MESSAGE_REQUEST_RF_INIT, length1, array);
 
 	/* Channel Table 0 */
@@ -1059,7 +1059,7 @@ void RFbRFTableDownload(struct vnt_private *priv)
 
 		memcpy(array, addr2, length);
 
-		CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+		vnt_control_out(priv, MESSAGE_TYPE_WRITE,
 			value, MESSAGE_REQUEST_RF_CH0, length, array);
 
 		length2 -= length;
@@ -1077,7 +1077,7 @@ void RFbRFTableDownload(struct vnt_private *priv)
 
 		memcpy(array, addr3, length);
 
-		CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+		vnt_control_out(priv, MESSAGE_TYPE_WRITE,
 			value, MESSAGE_REQUEST_RF_CH1, length, array);
 
 		length3 -= length;
@@ -1094,7 +1094,7 @@ void RFbRFTableDownload(struct vnt_private *priv)
 		memcpy(array, addr1, length1);
 
 		/* Init Table 2 */
-		CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+		vnt_control_out(priv, MESSAGE_TYPE_WRITE,
 			0, MESSAGE_REQUEST_RF_INIT2, length1, array);
 
 		/* Channel Table 0 */
@@ -1107,7 +1107,7 @@ void RFbRFTableDownload(struct vnt_private *priv)
 
 			memcpy(array, addr2, length);
 
-			CONTROLnsRequestOut(priv, MESSAGE_TYPE_WRITE,
+			vnt_control_out(priv, MESSAGE_TYPE_WRITE,
 				value, MESSAGE_REQUEST_RF_CH2, length, array);
 
 			length2 -= length;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 2dfa16e..443338e 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -26,7 +26,7 @@
  * Date: Mar. 29, 2005
  *
  * Functions:
- *      CONTROLnsRequestOut - Write variable length bytes to MEM/BB/MAC/EEPROM
+ *	vnt_control_out - Write variable length bytes to MEM/BB/MAC/EEPROM
  *      CONTROLnsRequestIn - Read variable length bytes from MEM/BB/MAC/EEPROM
  *      ControlvWriteByte - Write one byte to MEM/BB/MAC/EEPROM
  *      ControlvReadByte - Read one byte from MEM/BB/MAC/EEPROM
@@ -61,7 +61,7 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb);
 
-int PIPEnsControlOut(struct vnt_private *priv, u8 request, u16 value,
+int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 		u16 index, u16 length, u8 *buffer)
 {
 	int status = 0;
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index 42ad4f7..6ca250f 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -32,8 +32,7 @@
 
 #include "device.h"
 
-int PIPEnsControlOut(struct vnt_private *, u8 byRequest, u16 wValue,
-		u16 wIndex, u16 wLength, u8 *pbyBuffer);
+int vnt_control_out(struct vnt_private *, u8, u16, u16, u16, u8 *);
 int PIPEnsControlIn(struct vnt_private *, u8 byRequest, u16 wValue,
 	u16 wIndex, u16 wLength,  u8 *pbyBuffer);
 
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index ff4e4ae..9947794 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -852,7 +852,7 @@ void vRunCommand(struct work_struct *work)
 		ControlvReadByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PSCTL, &byData);
 		if ((byData & PSCTL_PS) != 0) {
 			// disable power saving hw function
-			CONTROLnsRequestOut(pDevice,
+			vnt_control_out(pDevice,
 					MESSAGE_TYPE_DISABLE_PS,
 					0,
 					0,
-- 
1.9.1

