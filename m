Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:26546 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZEZTPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 15:15:25 -0400
Message-ID: <4A1C4060.5070202@oracle.com>
Date: Tue, 26 May 2009 12:17:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: ilw@linux.intel.com,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH -next] iwmc3200wifi: fix printk format
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format for size_t variable:

drivers/net/wireless/iwmc3200wifi/fw.c:75: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: ilw@linux.intel.com
---
 drivers/net/wireless/iwmc3200wifi/fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090526.orig/drivers/net/wireless/iwmc3200wifi/fw.c
+++ linux-next-20090526/drivers/net/wireless/iwmc3200wifi/fw.c
@@ -72,7 +72,7 @@ static int iwm_fw_op_offset(struct iwm_p
 	}
 
 	if (fw->size < IWM_HDR_LEN) {
-		IWM_ERR(iwm, "FW is too small (%d)\n", fw->size);
+		IWM_ERR(iwm, "FW is too small (%zu)\n", fw->size);
 		return -EINVAL;
 	}
 

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
