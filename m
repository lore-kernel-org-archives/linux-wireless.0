Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35481 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab3AVUMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 15:12:42 -0500
Received: by mail-bk0-f53.google.com with SMTP id je9so1430663bkc.12
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 12:12:41 -0800 (PST)
Message-ID: <1358885554.5062.21.camel@canaries64> (sfid-20130122_211246_748012_61313746)
Subject: [PATCH] staging: vt6656: revert : 64 bit- Correctly address void
 structure.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 22 Jan 2013 20:12:34 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The patch is wrong and is partially reverted.

The NULL check of pTransmitKey->pvKeyTable is kept.

The problem was ultimately fixed by upstream commit.
1ee4c55fc9620451b2a825d793042a7e0775391b
staging: vt6656: Fix inconsistent structure packing

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # 3.8

---
 drivers/staging/vt6656/rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 536d314..92343f2 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1232,7 +1232,7 @@ static int s_bPacketToWirelessUsb(struct vnt_private *pDevice, u8 byPktType,
 	pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
 
 	if (bNeedEncryption && pTransmitKey->pvKeyTable) {
-		if (((PSKeyTable)&pTransmitKey->pvKeyTable)->bSoftWEP == TRUE)
+		if (((PSKeyTable)pTransmitKey->pvKeyTable)->bSoftWEP == TRUE)
 			bSoftWEP = TRUE; /* WEP 256 */
 	}
 
-- 
1.8.0



