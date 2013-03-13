Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:30508 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab3CMMNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 08:13:10 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 01/14] wil6210: Remove local implementation of dynamic hexdump
Date: Wed, 13 Mar 2013 14:12:38 +0200
Message-ID: <1363176771-10082-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130313_131314_368257_40D24238)
In-Reply-To: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1363176771-10082-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This functionality now integrated in kernel, local hack not needed any more

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/dbg_hexdump.h |   20 --------------------
 drivers/net/wireless/ath/wil6210/wil6210.h     |    6 ++----
 2 files changed, 2 insertions(+), 24 deletions(-)
 delete mode 100644 drivers/net/wireless/ath/wil6210/dbg_hexdump.h

diff --git a/drivers/net/wireless/ath/wil6210/dbg_hexdump.h b/drivers/net/wireless/ath/wil6210/dbg_hexdump.h
deleted file mode 100644
index e5712f0..0000000
--- a/drivers/net/wireless/ath/wil6210/dbg_hexdump.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef WIL_DBG_HEXDUMP_H_
-#define WIL_DBG_HEXDUMP_H_
-
-#include <linux/printk.h>
-#include <linux/dynamic_debug.h>
-
-#if defined(CONFIG_DYNAMIC_DEBUG)
-#define wil_print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
-				 groupsize, buf, len, ascii)		\
-	dynamic_hex_dump(prefix_str, prefix_type, rowsize,		\
-			     groupsize, buf, len, ascii)
-
-#else /* defined(CONFIG_DYNAMIC_DEBUG) */
-#define wil_print_hex_dump_debug(prefix_str, prefix_type, rowsize,	\
-				 groupsize, buf, len, ascii)		\
-	print_hex_dump(KERN_DEBUG, prefix_str, prefix_type, rowsize,	\
-		       groupsize, buf, len, ascii)
-#endif /* defined(CONFIG_DYNAMIC_DEBUG) */
-
-#endif /* WIL_DBG_HEXDUMP_H_ */
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index aea961f..bdab0e2 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -21,8 +21,6 @@
 #include <linux/wireless.h>
 #include <net/cfg80211.h>
 
-#include "dbg_hexdump.h"
-
 #define WIL_NAME "wil6210"
 
 /**
@@ -277,13 +275,13 @@ struct wil6210_priv {
 
 #define wil_hex_dump_txrx(prefix_str, prefix_type, rowsize,	\
 			  groupsize, buf, len, ascii)		\
-			  wil_print_hex_dump_debug("DBG[TXRX]" prefix_str,\
+			  print_hex_dump_debug("DBG[TXRX]" prefix_str,\
 					 prefix_type, rowsize,	\
 					 groupsize, buf, len, ascii)
 
 #define wil_hex_dump_wmi(prefix_str, prefix_type, rowsize,	\
 			 groupsize, buf, len, ascii)		\
-			 wil_print_hex_dump_debug("DBG[ WMI]" prefix_str,\
+			 print_hex_dump_debug("DBG[ WMI]" prefix_str,\
 					prefix_type, rowsize,	\
 					groupsize, buf, len, ascii)
 
-- 
1.7.10.4

