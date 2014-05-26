Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45935 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaEZNAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:05 -0400
Received: by mail-wi0-f178.google.com with SMTP id cc10so4298160wib.11
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:01 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/11] staging: vt6656: MACvSetKeyEntry remove camel case.
Date: Mon, 26 May 2014 13:58:59 +0100
Message-Id: <1401109148-3593-2-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150011_219824_757378B9)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
wKeyCtl -> key_ctl
uEntryIdx -> entry_idx
uKeyIdx -> key_idx
pbyAddr -> addr
wOffset -> offset

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/mac.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index a030c59..573ea4f 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -122,21 +122,21 @@ void MACvDisableKeyEntry(struct vnt_private *priv, u8 entry_idx)
  * Return Value: none
  *
  */
-void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
-	u32 uKeyIdx, u8 *pbyAddr, u8 *key)
+void MACvSetKeyEntry(struct vnt_private *priv, u16 key_ctl, u32 entry_idx,
+	u32 key_idx, u8 *addr, u8 *key)
 {
 	struct vnt_mac_set_key set_key;
-	u16 wOffset;
+	u16 offset;
 
-	if (pDevice->byLocalID <= MAC_REVISION_A1)
-		if (pDevice->vnt_mgmt.byCSSPK == KEY_CTL_CCMP)
+	if (priv->byLocalID <= MAC_REVISION_A1)
+		if (priv->vnt_mgmt.byCSSPK == KEY_CTL_CCMP)
 			return;
 
-	wOffset = MISCFIFO_KEYETRY0;
-	wOffset += (uEntryIdx * MISCFIFO_KEYENTRYSIZE);
+	offset = MISCFIFO_KEYETRY0;
+	offset += (entry_idx * MISCFIFO_KEYENTRYSIZE);
 
-	set_key.u.write.key_ctl = cpu_to_le16(wKeyCtl);
-	memcpy(set_key.u.write.addr, pbyAddr, ETH_ALEN);
+	set_key.u.write.key_ctl = cpu_to_le16(key_ctl);
+	memcpy(set_key.u.write.addr, addr, ETH_ALEN);
 
 	/* swap over swap[0] and swap[1] to get correct write order */
 	swap(set_key.u.swap[0], set_key.u.swap[1]);
@@ -145,10 +145,10 @@ void MACvSetKeyEntry(struct vnt_private *pDevice, u16 wKeyCtl, u32 uEntryIdx,
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 		"offset %d key ctl %d set key %24ph\n",
-				wOffset, wKeyCtl, (u8 *)&set_key);
+				offset, key_ctl, (u8 *)&set_key);
 
-	CONTROLnsRequestOut(pDevice, MESSAGE_TYPE_SETKEY, wOffset,
-		(u16)uKeyIdx, sizeof(struct vnt_mac_set_key), (u8 *)&set_key);
+	CONTROLnsRequestOut(priv, MESSAGE_TYPE_SETKEY, offset,
+		(u16)key_idx, sizeof(struct vnt_mac_set_key), (u8 *)&set_key);
 }
 
 void MACvRegBitsOff(struct vnt_private *priv, u8 reg_ofs, u8 bits)
-- 
1.9.1

