Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:5534 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756003AbeDYRTZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 13:19:25 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 01/21] staging: wilc1000: replace crc7_byte() with inline macro CRC7_BYTE
Date: Wed, 25 Apr 2018 22:48:06 +0530
Message-ID: <1524676706-13179-2-git-send-email-ajay.kathat@microchip.com> (sfid-20180425_191933_110745_CB16E4C7)
In-Reply-To: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
References: <1524676706-13179-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace the function call for crc7_byte() with macro CRC7_BYTE.
crc7_byte() was called in close while(), so replaced it with macro to
avoid extra functional call depth.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_spi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 2cb9f4e..3bb8fec 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -75,15 +75,12 @@ static const u8 crc7_syndrome_table[256] = {
 	0x46, 0x4f, 0x54, 0x5d, 0x62, 0x6b, 0x70, 0x79
 };
 
-static u8 crc7_byte(u8 crc, u8 data)
-{
-	return crc7_syndrome_table[(crc << 1) ^ data];
-}
+#define CRC7_BYTE(crc, data) crc7_syndrome_table[(crc << 1) ^ data]
 
 static u8 crc7(u8 crc, const u8 *buffer, u32 len)
 {
 	while (len--)
-		crc = crc7_byte(crc, *buffer++);
+		crc = CRC7_BYTE(crc, *buffer++);
 	return crc;
 }
 
-- 
2.7.4
