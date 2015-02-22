Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:46520 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbbBVT3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 14:29:36 -0500
Received: by wevm14 with SMTP id m14so14312916wev.13
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 11:29:35 -0800 (PST)
From: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
Subject: [PATCH] staging: rtl8723au: rtl8723a_hal_init.c: remove unnecessary braces
Date: Sun, 22 Feb 2015 20:28:44 +0100
Message-Id: <1424633324-9790-1-git-send-email-daniele.alessandrelli@gmail.com> (sfid-20150222_202940_126355_B6F35B31)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix all checkpatch "braces {} are not necessary" warnings for
rtl8723au/hal/rtl8723a_hal_init.c

Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 40 ++++++++---------------
 1 file changed, 14 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
index a5eadd4..e88d851 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
@@ -424,9 +424,8 @@ hal_ReadEFuse_WiFi(struct rtw_adapter *padapter,
 			offset = GET_HDR_OFFSET_2_0(efuseHeader);
 
 			ReadEFuseByte23a(padapter, eFuse_Addr++, &efuseExtHdr);
-			if (ALL_WORDS_DISABLED(efuseExtHdr)) {
+			if (ALL_WORDS_DISABLED(efuseExtHdr))
 				continue;
-			}
 
 			offset |= ((efuseExtHdr & 0xF0) >> 1);
 			wden = (efuseExtHdr & 0x0F);
@@ -524,9 +523,8 @@ hal_ReadEFuse_BT(struct rtw_adapter *padapter,
 
 				ReadEFuseByte23a(padapter, eFuse_Addr++,
 					      &efuseExtHdr);
-				if (ALL_WORDS_DISABLED(efuseExtHdr)) {
+				if (ALL_WORDS_DISABLED(efuseExtHdr))
 					continue;
-				}
 
 				offset |= ((efuseExtHdr & 0xF0) >> 1);
 				wden = (efuseExtHdr & 0x0F);
@@ -630,9 +628,8 @@ u16 rtl8723a_EfuseGetCurrentSize_WiFi(struct rtw_adapter *padapter)
 			hoffset = GET_HDR_OFFSET_2_0(efuse_data);
 			efuse_addr++;
 			efuse_OneByteRead23a(padapter, efuse_addr, &efuse_data);
-			if (ALL_WORDS_DISABLED(efuse_data)) {
+			if (ALL_WORDS_DISABLED(efuse_data))
 				continue;
-			}
 
 			hoffset |= ((efuse_data & 0xF0) >> 1);
 			hworden = efuse_data & 0x0F;
@@ -721,9 +718,8 @@ u16 rtl8723a_EfuseGetCurrentSize_BT(struct rtw_adapter *padapter)
 		}
 
 		/*  Check if we need to check next bank efuse */
-		if (efuse_addr < retU2) {
+		if (efuse_addr < retU2)
 			break;	/*  don't need to check next bank. */
-		}
 	}
 
 	retU2 = ((bank - 1) * EFUSE_BT_REAL_BANK_CONTENT_LEN) + efuse_addr;
@@ -1149,9 +1145,8 @@ static int _LLTWrite(struct rtw_adapter *padapter, u32 address, u32 data)
 	/* polling */
 	do {
 		value = rtl8723au_read32(padapter, LLTReg);
-		if (_LLT_NO_ACTIVE == _LLT_OP_VALUE(value)) {
+		if (_LLT_NO_ACTIVE == _LLT_OP_VALUE(value))
 			break;
-		}
 
 		if (count > POLLING_LLT_THRESHOLD) {
 			RT_TRACE(_module_hal_init_c_, _drv_err_,
@@ -1174,16 +1169,14 @@ int InitLLTTable23a(struct rtw_adapter *padapter, u32 boundary)
 
 	for (i = 0; i < (txpktbuf_bndy - 1); i++) {
 		status = _LLTWrite(padapter, i, i + 1);
-		if (status != _SUCCESS) {
+		if (status != _SUCCESS)
 			return status;
-		}
 	}
 
 	/*  end of list */
 	status = _LLTWrite(padapter, (txpktbuf_bndy - 1), 0xFF);
-	if (status != _SUCCESS) {
+	if (status != _SUCCESS)
 		return status;
-	}
 
 	/*  Make the other pages as ring buffer */
 	/*  This ring buffer is used as beacon buffer if we config this
@@ -1191,16 +1184,14 @@ int InitLLTTable23a(struct rtw_adapter *padapter, u32 boundary)
 	/*  Otherwise used as local loopback buffer. */
 	for (i = txpktbuf_bndy; i < Last_Entry_Of_TxPktBuf; i++) {
 		status = _LLTWrite(padapter, i, (i + 1));
-		if (_SUCCESS != status) {
+		if (_SUCCESS != status)
 			return status;
-		}
 	}
 
 	/*  Let last entry point to the start entry of ring buffer */
 	status = _LLTWrite(padapter, Last_Entry_Of_TxPktBuf, txpktbuf_bndy);
-	if (status != _SUCCESS) {
+	if (status != _SUCCESS)
 		return status;
-	}
 
 	return status;
 }
@@ -1435,9 +1426,9 @@ static void _DisableAnalog(struct rtw_adapter *padapter, bool bWithoutHWSM)
 /*  HW Auto state machine */
 int CardDisableHWSM(struct rtw_adapter *padapter, u8 resetMCU)
 {
-	if (padapter->bSurpriseRemoved) {
+	if (padapter->bSurpriseRemoved)
 		return _SUCCESS;
-	}
+
 	/*  RF Off Sequence ==== */
 	_DisableRFAFEAndResetBB8192C(padapter);
 
@@ -1459,9 +1450,8 @@ int CardDisableHWSM(struct rtw_adapter *padapter, u8 resetMCU)
 /*  without HW Auto state machine */
 int CardDisableWithoutHWSM(struct rtw_adapter *padapter)
 {
-	if (padapter->bSurpriseRemoved) {
+	if (padapter->bSurpriseRemoved)
 		return _SUCCESS;
-	}
 
 	/*  RF Off Sequence ==== */
 	_DisableRFAFEAndResetBB8192C(padapter);
@@ -1875,9 +1865,8 @@ static void rtl8723a_cal_txdesc_chksum(struct tx_desc *ptxdesc)
 	/*  Clear first */
 	ptxdesc->txdw7 &= cpu_to_le32(0xffff0000);
 
-	for (index = 0; index < count; index++) {
+	for (index = 0; index < count; index++)
 		checksum ^= le16_to_cpu(*(usPtr + index));
-	}
 
 	ptxdesc->txdw7 |= cpu_to_le32(checksum & 0x0000ffff);
 }
@@ -1925,9 +1914,8 @@ void rtl8723a_fill_fake_txdesc(struct rtw_adapter *padapter, u8 *pDesc,
 		ptxdesc->txdw3 |= cpu_to_le32((8 << 28));
 	}
 
-	if (true == IsBTQosNull) {
+	if (true == IsBTQosNull)
 		ptxdesc->txdw2 |= cpu_to_le32(BIT(23));	/*  BT NULL */
-	}
 
 	/* offset 16 */
 	ptxdesc->txdw4 |= cpu_to_le32(BIT(8));	/* driver uses rate */
-- 
1.8.3.2

