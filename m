Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db3on0118.outbound.protection.outlook.com ([157.55.234.118]:49999
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752307AbbFPH0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 03:26:33 -0400
From: "Abdul, Hussain (H.)" <habdul@visteon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] Staging: wilc1000: Remove casting the values returned by
 kmalloc()
Date: Tue, 16 Jun 2015 07:10:28 +0000
Message-ID: <1434438549-5340-1-git-send-email-habdul@visteon.com> (sfid-20150616_092638_509828_AD373A1A)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abdul Hussain <habdul@visteon.com>

This patch removes casting the values returned by memory allocation functions.

Signed-off-by: Abdul Hussain <habdul@visteon.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 5f87148..c1e9272 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -580,7 +580,7 @@ static void linux_wlan_dbg(uint8_t *buff)
 static void *linux_wlan_malloc_atomic(uint32_t sz)
 {
 	char *pntr = NULL;
-	pntr = (char *)kmalloc(sz, GFP_ATOMIC);
+	pntr = kmalloc(sz, GFP_ATOMIC);
 	PRINT_D(MEM_DBG, "Allocating %d bytes at address %p\n", sz, pntr);
 	return (void *)pntr;
 
@@ -588,7 +588,7 @@ static void *linux_wlan_malloc_atomic(uint32_t sz)
 static void *linux_wlan_malloc(uint32_t sz)
 {
 	char *pntr = NULL;
-	pntr = (char *)kmalloc(sz, GFP_KERNEL);
+	pntr = kmalloc(sz, GFP_KERNEL);
 	PRINT_D(MEM_DBG, "Allocating %d bytes at address %p\n", sz, pntr);
 	return (void *)pntr;
 }
@@ -605,7 +605,7 @@ void linux_wlan_free(void *vp)
 static void *internal_alloc(uint32_t size, uint32_t flag)
 {
 	char *pntr = NULL;
-	pntr = (char *)kmalloc(size, flag);
+	pntr = kmalloc(size, flag);
 	PRINT_D(MEM_DBG, "Allocating %d bytes at address %p\n", size, pntr);
 	return (void *)pntr;
 }
-- 
1.9.1
