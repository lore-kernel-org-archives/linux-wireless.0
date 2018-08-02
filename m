Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:46356 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728767AbeHBNRx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 09:17:53 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH] staging: wilc1000: fix compilation warning for ARCH PowerPC
Date: Thu, 2 Aug 2018 16:57:02 +0530
Message-ID: <1533209222-22295-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180802_132712_547551_57B2559A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix below warning reported for PowerPC arch compilation

include/uapi/linux/byteorder/big_endian.h:95:37: warning: passing
argument 1 of '__swab32s' makes pointer from integer without a cast
[-Wint-conversion]

Fixes: 02211edc9a1f ("staging: wilc1000: fix endianness warnings
reported by sparse")

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 2 +-
 drivers/staging/wilc1000/wilc_spi.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index 8bda550..1908afa1 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -563,7 +563,7 @@ static int sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		}
 	}
 
-	le32_to_cpus(*data);
+	le32_to_cpus(data);
 
 	return 1;
 
diff --git a/drivers/staging/wilc1000/wilc_spi.c b/drivers/staging/wilc1000/wilc_spi.c
index 064892d..a85f87b 100644
--- a/drivers/staging/wilc1000/wilc_spi.c
+++ b/drivers/staging/wilc1000/wilc_spi.c
@@ -699,7 +699,7 @@ static int spi_internal_read(struct wilc *wilc, u32 adr, u32 *data)
 		return 0;
 	}
 
-	le32_to_cpus(*data);
+	le32_to_cpus(data);
 
 	return 1;
 }
@@ -778,7 +778,7 @@ static int wilc_spi_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		return 0;
 	}
 
-	le32_to_cpus(*data);
+	le32_to_cpus(data);
 
 	return 1;
 }
-- 
2.7.4
