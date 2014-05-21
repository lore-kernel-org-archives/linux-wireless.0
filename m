Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54842 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaEUUKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 16:10:44 -0400
Received: by mail-wg0-f42.google.com with SMTP id y10so2444144wgg.25
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2014 13:10:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6656: ETHbIsBufferCrc32Ok replace CRCdwGetCrc32
Date: Wed, 21 May 2014 21:09:41 +0100
Message-Id: <1400702984-3221-3-git-send-email-tvboxspy@gmail.com> (sfid-20140521_221048_016792_9810C8B1)
In-Reply-To: <1400702984-3221-1-git-send-email-tvboxspy@gmail.com>
References: <1400702984-3221-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CRCdwGetCrc32 is a bitwise not of ether_crc_le.

Replace with ether_crc_le.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/tether.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6656/tether.c b/drivers/staging/vt6656/tether.c
index 1db1e84..ada3e7e 100644
--- a/drivers/staging/vt6656/tether.c
+++ b/drivers/staging/vt6656/tether.c
@@ -51,11 +51,11 @@
  */
 bool ETHbIsBufferCrc32Ok(u8 * pbyBuffer, unsigned int cbFrameLength)
 {
-	u32 dwCRC;
+	u32 n_crc = ~ether_crc_le(cbFrameLength - 4, pbyBuffer);
 
-	dwCRC = CRCdwGetCrc32(pbyBuffer, cbFrameLength - 4);
-	if (cpu_to_le32(*((u32 *)(pbyBuffer + cbFrameLength - 4))) != dwCRC)
+	if (le32_to_cpu(*((__le32 *)(pbyBuffer + cbFrameLength - 4))) != n_crc)
 		return false;
+
 	return true;
 }
 
-- 
1.9.1

