Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0103.outbound.protection.outlook.com ([157.56.112.103]:24016
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750892AbbFRMhE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 08:37:04 -0400
From: "Abdul, Hussain (H.)" <habdul@visteon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mravind@visteon.com" <mravind@visteon.com>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>
Subject: [PATCH] Staging: wilc1000: NULL check before some freeing functions
 is not needed
Date: Thu, 18 Jun 2015 12:37:00 +0000
Message-ID: <1434630935-4526-1-git-send-email-habdul@visteon.com> (sfid-20150618_143708_935387_F8888395)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abdul Hussain <habdul@visteon.com>

This patch removes check before freeing the memory 
since kfree(NULL) is safe

Signed-off-by: Abdul Hussain <habdul@visteon.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 1eee1d5..236669c 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -214,8 +214,7 @@ int linux_spi_write(uint8_t *b, uint32_t len)
 				PRINT_ER("SPI transaction failed\n");
 			}
 		}
-		if (r_buffer)
-			kfree(r_buffer);
+		kfree(r_buffer);
 	} else {
 		PRINT_ER("can't write data with the following length: %d\n", len);
 		PRINT_ER("FAILED due to NULL buffer or ZERO length check the following length: %d\n", len);
@@ -377,8 +376,7 @@ int linux_spi_read(unsigned char *rb, unsigned long rlen)
 			}
 		}
 
-		if (t_buffer)
-			kfree(t_buffer);
+		kfree(t_buffer);
 	} else {
 		PRINT_ER("can't read data with the following length: %ld\n", rlen);
 		ret = -1;
-- 
1.9.1
