Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:47729 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036AbaEQIxG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 04:53:06 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so2007590wiw.8
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 01:53:05 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/22] staging: vt6656: rndis.h remove dead code.
Date: Sat, 17 May 2014 09:50:29 +0100
Message-Id: <1400316639-4430-12-git-send-email-tvboxspy@gmail.com> (sfid-20140517_105314_268105_4F92CC9F)
In-Reply-To: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
References: <1400316639-4430-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove dead structures and macros.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rndis.h | 64 ------------------------------------------
 1 file changed, 64 deletions(-)

diff --git a/drivers/staging/vt6656/rndis.h b/drivers/staging/vt6656/rndis.h
index 3661f82..cf4e0e0 100644
--- a/drivers/staging/vt6656/rndis.h
+++ b/drivers/staging/vt6656/rndis.h
@@ -64,21 +64,8 @@
 #define MESSAGE_REQUEST_RF_CH1          0x0C
 #define MESSAGE_REQUEST_RF_CH2          0x0D
 
-#define VIAUSB20_PACKET_HEADER          0x04
-
 #define USB_REG4	0x604
 
-typedef struct _CMD_MESSAGE
-{
-    u8        byData[256];
-} CMD_MESSAGE, *PCMD_MESSAGE;
-
-typedef struct _CMD_WRITE_MASK
-{
-    u8        byData;
-    u8        byMask;
-} CMD_WRITE_MASK, *PCMD_WRITE_MASK;
-
 struct vnt_cmd_card_init
 {
 	u8 init_class;
@@ -97,55 +84,4 @@ struct vnt_rsp_card_init
 	u8 max_channel;
 };
 
-typedef struct _CMD_SET_KEY
-{
-    u16        wKCTL;
-    u8        abyMacAddr[6];
-    u8        abyKey[16];
-} CMD_SET_KEY, *PCMD_SET_KEY;
-
-typedef struct _CMD_CLRKEY_ENTRY
-{
-    u8        abyKeyEntry[11];
-} CMD_CLRKEY_ENTRY, *PCMD_CLRKEY_ENTRY;
-
-typedef struct _CMD_WRITE_MISCFF
-{
-    u32       adwMiscFFData[22][4];  //a key entry has only 22 dwords
-} CMD_WRITE_MISCFF, *PCMD_WRITE_MISCFF;
-
-typedef struct _CMD_SET_TSFTBTT
-{
-    u8        abyTSF_TBTT[8];
-} CMD_SET_TSFTBTT, *PCMD_SET_TSFTBTT;
-
-typedef struct _CMD_SET_SSTIFS
-{
-    u8        bySIFS;
-    u8        byDIFS;
-    u8        byEIFS;
-    u8        bySlotTime;
-    u8        byCwMax_Min;
-    u8        byBBCR10;
-} CMD_SET_SSTIFS, *PCMD_SET_SSTIFS;
-
-typedef struct _CMD_CHANGE_BBTYPE
-{
-    u8        bySIFS;
-    u8        byDIFS;
-    u8        byEIFS;
-    u8        bySlotTime;
-    u8        byCwMax_Min;
-    u8        byBBCR10;
-    u8        byBB_BBType;    //CR88
-    u8        byMAC_BBType;
-    u32       dwRSPINF_b_1;
-    u32       dwRSPINF_b_2;
-    u32       dwRSPINF_b_55;
-    u32       dwRSPINF_b_11;
-    u16        wRSPINF_a[9];
-} CMD_CHANGE_BBTYPE, *PCMD_CHANGE_BBTYPE;
-
-#define EXCH_WORD(w) ((u16)((u16)(w)<<8) | (u16)((u16)(w)>>8))
-
 #endif /* _RNDIS_H_ */
-- 
1.9.1

