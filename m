Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:61633 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaCVJCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Mar 2014 05:02:25 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so2244816wgh.22
        for <linux-wireless@vger.kernel.org>; Sat, 22 Mar 2014 02:02:24 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/10] staging: vt6656: rxtx: s_vFillTxKey Fix base type pdwExtIV
Date: Sat, 22 Mar 2014 09:01:25 +0000
Message-Id: <1395478892-3419-3-git-send-email-tvboxspy@gmail.com> (sfid-20140322_100228_837247_723F4A06)
In-Reply-To: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
References: <1395478892-3419-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use base type to __le32.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index f2f96ee..43e13e2 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -182,7 +182,7 @@ static void s_vFillTxKey(struct vnt_private *pDevice,
 {
 	u8 *pbyBuf = (u8 *)&fifo_head->adwTxKey[0];
 	__le32 *pdwIV = (__le32 *)pbyIVHead;
-	u32 *pdwExtIV = (u32 *)((u8 *)pbyIVHead + 4);
+	__le32 *pdwExtIV = (__le32 *)((u8 *)pbyIVHead + 4);
 	struct ieee80211_hdr *pMACHeader = (struct ieee80211_hdr *)pbyHdrBuf;
 	__le32 rev_iv_counter;
 
-- 
1.9.0

