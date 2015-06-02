Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0127.outbound.protection.outlook.com ([157.56.112.127]:46556
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752983AbbFBKci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 06:32:38 -0400
From: "Dhere, Chaitanya (C.)" <cvijaydh@visteon.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	"Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: wilc1000: Modification in code to use ARRAY_SIZE
 macro
Date: Tue, 2 Jun 2015 09:58:50 +0000
Message-ID: <20150602095844.GA31971@ubuntu> (sfid-20150602_123242_148647_67C24721)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaitanya Dhere <cvijaydh@visteon.com>

In this patch, ARRAY_SIZE() macro is used to determine the
size. This change was detected with the help of coccinelle
tool.

Signed-off-by: Chaitanya Dhere <cvijaydh@visteon.com>
---
 drivers/staging/wilc1000/linux_wlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b033eb8..592b8ae 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1737,7 +1737,7 @@ static int linux_wlan_read_mac_addr(void *vp)
 	mm_segment_t old_fs;
 	loff_t pos = 0;
 	int index;
-	int array_size = sizeof(path_string) / sizeof(path_string[0]);
+	int array_size = ARRAY_SIZE(path_string);
 
 	/* change to KERNEL_DS address limit */
 	old_fs = get_fs();
-- 
1.7.9.5
