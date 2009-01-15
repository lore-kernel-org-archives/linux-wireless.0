Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:21491 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbZAOHK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 02:10:58 -0500
Received: by wf-out-1314.google.com with SMTP id 27so1111761wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2009 23:10:57 -0800 (PST)
Subject: [PATCH] prism54: remove private implementation of le32_add_cpu
From: Harvey Harrison <harvey.harrison@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 23:10:55 -0800
Message-Id: <1232003455.5819.0.camel@brick> (sfid-20090115_081117_281198_3E6ECF3B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/wireless/prism54/islpci_eth.c |    5 +++--
 drivers/net/wireless/prism54/islpci_mgt.h |    6 ------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/prism54/islpci_eth.c b/drivers/net/wireless/prism54/islpci_eth.c
index e43bae9..88895bd 100644
--- a/drivers/net/wireless/prism54/islpci_eth.c
+++ b/drivers/net/wireless/prism54/islpci_eth.c
@@ -23,6 +23,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <asm/byteorder.h>
 
 #include "prismcompat.h"
 #include "isl_38xx.h"
@@ -471,8 +472,8 @@ islpci_eth_receive(islpci_private *priv)
 		wmb();
 
 		/* increment the driver read pointer */
-		add_le32p(&control_block->
-			  driver_curr_frag[ISL38XX_CB_RX_DATA_LQ], 1);
+		le32_add_cpu(&control_block->
+			     driver_curr_frag[ISL38XX_CB_RX_DATA_LQ], 1);
 	}
 
 	/* trigger the device */
diff --git a/drivers/net/wireless/prism54/islpci_mgt.h b/drivers/net/wireless/prism54/islpci_mgt.h
index f91a88f..87a1734 100644
--- a/drivers/net/wireless/prism54/islpci_mgt.h
+++ b/drivers/net/wireless/prism54/islpci_mgt.h
@@ -85,12 +85,6 @@ extern int pc_debug;
 #define PIMFOR_FLAG_APPLIC_ORIGIN               0x01
 #define PIMFOR_FLAG_LITTLE_ENDIAN               0x02
 
-static inline void
-add_le32p(__le32 * le_number, u32 add)
-{
-	*le_number = cpu_to_le32(le32_to_cpup(le_number) + add);
-}
-
 void display_buffer(char *, int);
 
 /*
-- 
1.6.1.212.g4b3ec



